import {
	DefaultResourceLoader,
	formatSkillsForPrompt,
	getAgentDir,
	type ExtensionAPI,
	type Skill,
} from "@mariozechner/pi-coding-agent";

interface PromptResources {
	cwd: string;
	customPrompt?: string;
	appendSystemPrompt?: string;
	contextFiles: Array<{ path: string; content: string }>;
	skills: Skill[];
}

interface BuildPromptInput {
	activeTools: string[];
	allTools: Map<string, { description: string }>;
	resources: PromptResources;
}

function summarizeToolDescription(name: string, description?: string): string {
	const builtIn: Record<string, string> = {
		read: "Read file contents",
		bash: "Execute bash commands",
		edit: "Make precise edits with exact text replacement",
		write: "Create or overwrite files",
		grep: "Search file contents",
		find: "Find files and directories",
		ls: "List files and directories",
	};

	if (builtIn[name]) {
		return builtIn[name];
	}

	const firstLine = description?.split("\n").find((line) => line.trim())?.trim();
	if (!firstLine) {
		return "Custom tool available in this project";
	}

	const firstSentence = firstLine.match(/^(.+?[.!?])(?:\s|$)/)?.[1]?.trim();
	return firstSentence || firstLine;
}

function buildToolsSection(activeTools: string[], allTools: Map<string, { description: string }>): string {
	if (activeTools.length === 0) {
		return "(none)";
	}

	return activeTools
		.map((name) => `- ${name}: ${summarizeToolDescription(name, allTools.get(name)?.description)}`)
		.join("\n");
}

function buildPolicy(activeTools: string[]): string {
	const has = (tool: string) => activeTools.includes(tool);
	const explorationRule =
		has("bash") && !has("grep") && !has("find") && !has("ls")
			? "- Use bash for fast repo exploration like `ls`, `rg`, and `find`"
			: has("bash") && (has("grep") || has("find") || has("ls"))
				? "- Prefer dedicated search/list tools over bash when they fit"
				: undefined;

	const sections = [
		[
			"## Operating Mode",
			"- Solve the task completely before yielding unless you are blocked or the user asked for partial work",
			"- Work repo-first and use tools to inspect reality; do not guess or invent unseen results",
			"- Do not rely on the user for intermediate steps you can perform yourself",
			"- Ask questions only when blocked, ambiguity matters, or the action is high risk",
			"- Skip planning for straightforward tasks; for larger or riskier work, make a brief multi-step plan first",
		],
		[
			"## Tool Discipline",
			explorationRule,
			"- Prefer dedicated tools over shell commands for reading and editing files when available",
			"- Read existing code before editing when the right change is not already obvious",
			"- Use web only for external APIs, libraries, or genuinely fresh information",
			"- Use subagents only when broader recon, isolation, or parallelism materially helps",
		],
		[
			"## Editing Constraints",
			"- Reuse existing patterns before introducing new abstractions",
			"- Prefer the smallest effective diff unless the user asked for a broader refactor",
			"- Avoid new dependencies unless necessary and justify them when you add them",
			"- Never overwrite, revert, or ignore user changes you did not make",
			"- If unexpected external changes appear while you work, stop and ask how to proceed",
		],
		[
			"## Verification And Completion",
			"- Before claiming success, run the relevant checks or commands and use their actual output as evidence",
			"- If you cannot verify something directly, say what remains unverified",
			"- Before finishing, re-read the request and confirm only the necessary files and state changes were introduced",
			"- Avoid destructive or high-risk actions unless explicitly requested or confirmed",
		],
		[
			"## Responses",
			"- Be terse, direct, and friendly by default",
			"- Show file paths clearly when working with files",
			"- For review requests, lead with findings, risks, and missing tests",
			"- For code changes, explain what changed and why without dumping large file contents",
		],
	];

	return sections
		.map((section) => section.filter((line): line is string => Boolean(line)).join("\n"))
		.join("\n\n");
}

export function buildCodingSystemPrompt({ activeTools, allTools, resources }: BuildPromptInput): string {
	const toolsSection = buildToolsSection(activeTools, allTools);
	const policy = buildPolicy(activeTools);
	const sections = [
		"You are an expert coding assistant operating inside pi, a coding agent harness. Help the user read code, change code, run commands, verify results, and answer technical questions.",
	];

	if (resources.customPrompt?.trim()) {
		sections.push(`Additional user-defined system instructions:\n${resources.customPrompt.trim()}`);
	}

	sections.push(`Available tools:
${toolsSection}

In addition to the tools above, you may have access to other custom tools depending on the project.`);
	sections.push(policy);

	if (resources.appendSystemPrompt?.trim()) {
		sections.push(resources.appendSystemPrompt.trim());
	}

	if (resources.contextFiles.length > 0) {
		sections.push(
			"# Project Context\n\nProject-specific instructions and guidelines:\n\n" +
				resources.contextFiles.map(({ path, content }) => `## ${path}\n\n${content}`).join("\n\n"),
		);
	}

	if (activeTools.includes("read") && resources.skills.length > 0) {
		const skills = formatSkillsForPrompt(resources.skills).trim();
		if (skills) {
			sections.push(skills);
		}
	}

	const now = new Date();
	const year = now.getFullYear();
	const month = String(now.getMonth() + 1).padStart(2, "0");
	const day = String(now.getDate()).padStart(2, "0");
	sections.push(`Current date: ${year}-${month}-${day}`);
	sections.push(`Current working directory: ${resources.cwd.replace(/\\/g, "/")}`);

	return sections.join("\n\n").trim();
}

export async function loadPromptResources(cwd: string): Promise<PromptResources> {
	const loader = new DefaultResourceLoader({
		cwd,
		agentDir: getAgentDir(),
		noExtensions: true,
		noPromptTemplates: true,
		noThemes: true,
	});
	await loader.reload();

	return {
		cwd,
		customPrompt: loader.getSystemPrompt(),
		appendSystemPrompt: loader.getAppendSystemPrompt().join("\n\n") || undefined,
		contextFiles: loader.getAgentsFiles().agentsFiles,
		skills: loader.getSkills().skills,
	};
}

export default function codingSystemPrompt(pi: ExtensionAPI) {
	let cachedResources: PromptResources | undefined;

	const ensureResources = async (cwd: string) => {
		if (!cachedResources || cachedResources.cwd !== cwd) {
			cachedResources = await loadPromptResources(cwd);
		}
		return cachedResources;
	};

	pi.on("session_start", async (_event, ctx) => {
		cachedResources = await loadPromptResources(ctx.cwd);
	});

	pi.on("before_agent_start", async (_event, ctx) => {
		const resources = await ensureResources(ctx.cwd);
		const activeTools = pi.getActiveTools();
		const allTools = new Map(pi.getAllTools().map((tool) => [tool.name, { description: tool.description }]));

		return {
			systemPrompt: buildCodingSystemPrompt({
				activeTools,
				allTools,
				resources,
			}),
		};
	});
}

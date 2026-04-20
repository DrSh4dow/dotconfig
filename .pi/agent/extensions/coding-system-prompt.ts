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

function buildGuidelines(activeTools: string[]): string {
	const guidelines: string[] = [];
	const seen = new Set<string>();
	const add = (guideline: string) => {
		if (seen.has(guideline)) {
			return;
		}
		seen.add(guideline);
		guidelines.push(guideline);
	};

	const has = (tool: string) => activeTools.includes(tool);

	if (has("bash") && !has("grep") && !has("find") && !has("ls")) {
		add("Use bash for file operations like ls, rg, find");
	} else if (has("bash") && (has("grep") || has("find") || has("ls"))) {
		add("Prefer grep/find/ls tools over bash for file exploration when they fit");
	}

	add("Be terse by default");
	add("Show file paths clearly when working with files");
	add("Start in the repo; use web only for external APIs, libraries, or fresh facts");
	add("Explore before editing when the relevant code is not already clear");
	add("Reuse existing patterns before inventing new abstractions");
	add("Prefer the smallest effective diff unless broader refactoring is requested");
	add("Ask questions only when blocked, ambiguity matters, or risk is high");
	add("Act directly on clear small tasks; make a brief plan first for large or risky work");
	add("Do not make speculative claims about code, behavior, or command results you have not verified");
	add("Verify with real commands or concrete evidence before claiming success");
	add("Avoid destructive or high-risk actions unless the user asked or confirmed");
	add("Avoid adding dependencies unless necessary and justify them when you do");
	add("Use subagents only when broad recon, isolation, or parallelism materially helps");
	add("Give brief checkpoints during long tasks");

	return guidelines.map((guideline) => `- ${guideline}`).join("\n");
}

export function buildCodingSystemPrompt({ activeTools, allTools, resources }: BuildPromptInput): string {
	const toolsSection = buildToolsSection(activeTools, allTools);
	const guidelines = buildGuidelines(activeTools);
	const sections = [
		`You are an expert coding assistant operating inside pi, a coding agent harness. You help users by reading files, executing commands, editing code, and writing new files.

Available tools:
${toolsSection}

In addition to the tools above, you may have access to other custom tools depending on the project.

Guidelines:
${guidelines}`,
	];

	if (resources.customPrompt?.trim()) {
		sections.push(`User-defined system instructions:\n${resources.customPrompt.trim()}`);
	}

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

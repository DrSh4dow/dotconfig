import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.on("before_provider_request", (event, ctx) => {
		const model = ctx.model;
		if (!model || model.provider !== "openai-codex") return;
		if (!event.payload || typeof event.payload !== "object") return;

		return {
			...(event.payload as Record<string, unknown>),
			service_tier: "priority",
		};
	});
}

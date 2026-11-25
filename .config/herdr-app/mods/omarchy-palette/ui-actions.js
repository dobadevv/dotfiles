// Generated from ui/actions.js. Edit that source, then run npm run sync-ui.
import { focused, spaces, openOverlay, run, layout, exec } from "herdr";

export function showDialog(spec) {
  return openOverlay({ mod: "omarchy-dialog", kind: "dialog", frame: "none", width: 420, height: spec.mode === "prompt" ? (spec.hint ? 180 : 160) : (spec.detail ? 150 : 130), props: spec });
}

// Through the CLI: run() refuses an argument nested deeper than 16 levels, and the layout's tree is deeper.
function toggleTitlebar() {
  const l = layout();
  if (!l) return;
  return exec("herdr-app", ["do", "layout.set", JSON.stringify({ layout: { ...l, titlebar: l.titlebar === "none" ? "system" : "none" } })]);
}

export function runOmarchy(name, args = {}) {
  if (name === "window.titlebar") return toggleTitlebar();
  if (name === "space.close" && !args.confirmed) {
    const space = spaces().find(s => s.id === (args.id ?? focused()?.space));
    if (!space) return;
    return showDialog({ mode: "confirm", title: "Close space?", detail: space.name,
      command: { name, args: { ...args, id: space.id, confirmed: true } } });
  }
  if ((name === "tab.rename" || name === "space.rename") && args.name === undefined) {
    const isTab = name === "tab.rename";
    const id = args.id ?? (isTab ? focused()?.tab : focused()?.space);
    const target = isTab ? spaces().flatMap(s => s.tabs).find(t => t.id === id) : spaces().find(s => s.id === id);
    if (!target) return;
    return showDialog({ mode: "prompt", title: isTab ? "Rename tab" : "Rename space", value: target.name ?? "",
      command: { name, args: { ...args, id } } });
  }
  if (name === "mod.clone" && !args.name) {
    return showDialog({ mode: "prompt", title: "Duplicate mod", hint: "Mod to copy; creates <name>-copy", command: { name, args } });
  }
  const panels = { "app.settings": "omarchy-settings", "app.help": "omarchy-keys", "app.palette": "omarchy-palette" };
  return panels[name] ? run("mod.open", { name: panels[name] }) : run(name, args);
}

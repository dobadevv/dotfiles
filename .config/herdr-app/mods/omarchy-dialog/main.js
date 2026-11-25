import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { props, theme, closeOverlay, run, nextCommand } from "herdr";
import { surface, button, inputFrame, dialogHeader, UI } from "./ui.js";
import { runOmarchy } from "./ui-actions.js";

export default class Dialog extends View {
  init(_props, cx) {
    if (!props()?.overlay) {
      cx.spawn(async cx => {
        for (;;) {
          const command = await nextCommand();
          if (command === "rename-tab") runOmarchy("tab.rename");
          if (command === "rename-space") runOmarchy("space.rename");
          cx.notify();
        }
      });
      return;
    }
    this.handle = cx.focus_handle();
    this.text = props().value ?? "";
    if (props().mode === "prompt") {
      this.inputFocused = true;
      this.input = InputState.new({ value: this.text });
      this.input.on("change", (_e, cx) => { this.text = this.input.value(); cx.notify(); });
      this.input.on("submit", () => this.submit());
      this.input.on("focus", (_e, cx) => { this.inputFocused = true; cx.notify(); });
      this.input.on("blur", (_e, cx) => { this.inputFocused = false; cx.notify(); });
      this.input.set_selected_range({ start: 0, end: this.text.length });
      this.input.focus();
      cx.timer.after(300, () => this.input.focus());
    } else this.handle.focus();
  }

  submit() {
    const p = props();
    const args = { ...p.command.args, ...(p.mode === "prompt" ? { name: this.text } : {}) };
    closeOverlay(p.overlay);
    run(p.command.name, args);
  }

  render() {
    const p = props();
    if (!p?.overlay) return div().size_full();
    const t = theme();
    const cancel = () => closeOverlay(p.overlay);
    return surface(t, v_flex().id("omarchy-dialog").role("dialog").accessibility_label(p.title)
      .track_focus(this.handle).size_full().min_h(0)).p(UI.padding).gap(UI.gap).text_size(UI.text)
      .on_key_down((e, cx) => {
        if (e.key === "escape") cancel();
        else if (e.key === "enter" && p.mode !== "prompt") this.submit();
        else return;
        cx.stop_propagation();
      })
      .child(dialogHeader(t, p.title, cancel))
      .when(Boolean(p.detail), el => el.child(div().flex_1().min_h(0).overflow_y_scroll().text_color(t.muted).child(p.detail)))
      .when(p.mode === "prompt", el => el.child(inputFrame(t, Input.new(this.input), this.inputFocused)))
      .when(Boolean(p.hint), el => el.child(div().text_size(12).text_color(t.muted).child(p.hint)))
      .when(!p.detail, el => el.child(div().flex_1().min_h(0)))
      .child(h_flex().justify_end().gap(UI.gap)
        .child(button(t, "dialog-cancel", "Cancel", cancel))
        .child(button(t, "dialog-submit", p.mode === "prompt" ? "Save" : "Confirm", () => this.submit(), "primary")));
  }
}

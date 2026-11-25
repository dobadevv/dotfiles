// How notifications look. Anything can post one with notify({ title, body,
// level, icon, action }); replace this mod to restyle them all. Click to
// run its action (e.g. go to the agent) and dismiss it.

import { surface, UI } from "./ui.js";
import { View, div, image } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { props, closeOverlay, run, theme } from "herdr";

const DOT = { error: "blocked", warning: "working", success: "done", info: "accent" };

export default class Toast extends View {
  render(cx) {
    const t = theme();
    const p = props() ?? {};
    const color = t[DOT[p.level] ?? "accent"];
    const login = /^([a-z0-9][a-z0-9_.-]{0,31}) needs login; run hc machine login \1$/.exec(p.body ?? "");
    const command = login ? `hc machine login ${login[1]}` : null;
    return surface(t, h_flex(), "toast")
      .id("toast")
      .role(p.level === "error" ? "alert" : "status")
      .size_full()
      .px(UI.padding)
      .py(8)
      .gap(UI.gap)
      .items_center()
      .cursor_pointer()
      .hover((s) => s.bg(t.hover))
      .on_click(() => {
        if (p.action?.name) run(p.action.name, p.action.args ?? {});
        closeOverlay(p.overlay);
      })
      .child(div().w(3).h(28).flex_none().bg(color))
      .when(Boolean(p.icon), el => el.child(image(p.icon).w(16).h(16).flex_none()))
      .child(
        v_flex()
          .flex_1()
          .min_w(0)
          .gap(3)
          .overflow_hidden()
          .child(div().truncate().font_semibold().text_size(13).text_color(t.foreground).child(login ? `${login[1]} needs a login: run` : p.title ?? ""))
          .when(!login && Boolean(p.body), (el) => el.child(div().truncate().text_size(12).text_color(t.muted).child(p.body ?? "")))
          .when(Boolean(login), (el) => el.child(h_flex().gap(8).items_center()
            .child(div().flex_1().min_w(0).truncate().tooltip(command).text_size(12).text_color(t.muted).child(command))
            .child(div().id("toast-login-copy").flex_none().px(6).py(3).rounded(0).border_1().border_color(t.border).bg(t.chrome)
              .text_size(12).text_color(t.foreground).cursor_pointer().hover(s => s.bg(t.hover))
              .on_click((_e, cx) => { cx.stop_propagation(); cx.write_to_clipboard(command); this.copied = true; cx.notify(); })
              .child(this.copied ? "Copied" : "Copy")))),
      )
      .child(div().id("toast-dismiss").role("button").accessibility_label("Dismiss notification")
        .size(24).flex_none().flex().items_center().justify_center().border_1().border_color(t.border)
        .text_size(16).text_color(t.muted).cursor_pointer().hover(s => s.bg(t.hover).text_color(t.foreground))
        .on_click((_e, cx) => { cx.stop_propagation(); closeOverlay(p.overlay); }).child("×"));
  }
}

// Generated from ui/components.js. Edit that source, then run npm run sync-ui.
import { div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";

export const UI = Object.freeze({ padding: 12, gap: 8, controlHeight: 30, inputHeight: 32, menuHeight: 28, text: 13, scrim: "#000000b3" });

export function heading(t, text) {
  return div().pt(4).pb(8).mb(2).border_b(1).border_color(t.border).text_size(11).font_semibold().text_color(t.accent).child(text.toUpperCase());
}

// One setting: what it is on the left, the control on the right.
export function row(t, title, about, control) {
  return h_flex()
    .w_full()
    .gap(14)
    .py(10)
    .items_center()
    .border_b(1)
    .border_color(t.border)
    .child(
      v_flex()
        .flex_1()
        .min_w(0)
        .gap(3)
        .child(div().text_size(13).text_color(t.foreground).child(title))
        .when(Boolean(about), (el) => el.child(div().text_size(12).line_height("17px").text_color(t.muted).child(about))),
    )
    .child(div().flex_none().child(control));
}

export function button(t, id, label, onClick, kind = "secondary") {
  const primary = kind === "primary" || kind === "danger";
  const fill = kind === "danger" ? t.ansi1 : t.accent;
  return div()
    .id(id)
    .role("button")
    .flex_none()
    .whitespace_nowrap()
    .px(10)
    .h(UI.controlHeight)
    .flex()
    .items_center()
    .justify_center()
    .rounded(0)
    .border_1()
    .border_color(t.border)
    .bg(primary ? fill : t.chrome)
    .cursor_pointer()
    .text_size(13)
    .text_color(primary ? (kind === "danger" ? t.background : t.accent_foreground) : t.foreground)
    .hover((s) => primary ? s.opacity(0.88) : s.bg(t.hover).border_color(t.accent))
    .on_click(onClick)
    .child(label);
}

// − value +
export function stepper(t, id, value, onMinus, onPlus) {
  const b = (k, label, f) =>
    div()
      .id(`${id}-${k}`)
      .w(28)
      .h(28)
      .flex()
      .items_center()
      .justify_center()
      .cursor_pointer()
      .text_size(15)
      .text_color(t.muted)
      .hover((s) => s.bg(t.hover).text_color(t.foreground))
      .on_click(f)
      .child(label);
  return h_flex()
    .flex_none()
    .whitespace_nowrap()
    .items_center()
    .rounded(0)
    .border_1()
    .border_color(t.border)
    .bg(t.raised)
    .overflow_hidden()
    .child(b("minus", "\u2212", onMinus))
    .child(div().w(46).text_size(12.5).text_color(t.foreground).flex().justify_center().child(value))
    .child(b("plus", "+", onPlus));
}

export function toggle(t, id, on, onClick) {
  return div()
    .id(id)
    .w(36)
    .h(22)
    .border_1()
    .border_color(on ? t.accent : t.border)
    .rounded(0)
    .p(2)
    .cursor_pointer()
    .bg(on ? t.accent : t.background)
    .flex()
    .when(on, (el) => el.justify_end())
    .on_click(onClick)
    .child(div().w(16).h(16).rounded(0).bg(on ? t.accent_foreground : t.muted));
}


export function surface(t, element, kind = "dialog") {
  const quiet = kind === "menu" || kind === "toast";
  return element.rounded(0).border(quiet ? 1 : 2).border_color(quiet ? t.border : t.accent).bg(t.popover).text_color(t.foreground);
}

export function inputFrame(t, element, focused = false) {
  return element.h(UI.inputHeight).px(10).rounded(0).border_1().border_color(focused ? t.accent : t.input)
    .bg(t.background).text_size(UI.text).text_color(t.foreground);
}

export function dialogHeader(t, title, onClose) {
  return h_flex().flex_none().gap(UI.gap).items_center()
    .child(div().flex_1().min_w(0).text_size(14).font_semibold().text_color(t.foreground).child(title))
    .child(button(t, "dialog-close", "Esc", onClose).h(24).text_size(11));
}

export function menuRow(t, element, selected = false) {
  return element.whitespace_nowrap().h(UI.menuHeight).px(8).gap(9).rounded(0).items_center().border_l(2)
    .border_color(selected ? t.accent : "#00000000").text_color(t.foreground)
    .when(selected, el => el.bg(t.selected)).hover(s => s.bg(t.hover));
}

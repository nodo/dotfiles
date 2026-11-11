// Nodo sidebar: SPACES and AGENTS in box-drawn panels, monospace, theme colors.
// props.part: "title" (top strip, window drag), "spaces" / "agents" (one list each, its
// own focusable layout block), "agent-menu" / "space-menu" (right-click popups), or
// omitted (both lists in one block).
//
// Spaces: click to switch, drag to reorder, right-click for Herdr's space menu
// (rename, worktrees, close); git worktree spaces sit under their main checkout.
// Agents: click to focus, right-click for pin / peek / close; pinned ones come first.
// Keyboard: each list is a pane for pane.go: ctrl+s h focuses it, ctrl+s j/k move between
// the two lists. Inside: j/k/g/G move, enter switches/focuses, esc / l / ctrl+s l go back
// to the pane you came from.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { spaces, agents, panes, theme, settings, run, props, exec, openOverlay, closeOverlay, setAgentOrder, nextCommand, focused, setShared } from "herdr";

const MARK = { working: "[~]", blocked: "[!]", done: "[*]", idle: "[ ]" };
const SPIN = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"].map((c) => `[${c}]`);
const GIT_EVERY = 5000;

const mono = () => settings().font_family ?? "JetBrains Mono";
const statusColor = (t, s) => ({ working: t.working, blocked: t.blocked, done: t.done, idle: t.dim }[s] ?? t.dim);

// Where a space is now: its first terminal's live folder, else where it was made.
function place(s, ps) {
  const tabs = new Set((s.tabs ?? []).map((c) => c.id));
  return ps.find((p) => tabs.has(p.tab) && p.cwd)?.cwd || s.folder;
}
const placeKey = (s, ps) => JSON.stringify([s.machine ?? null, place(s, ps)]);

// A panel with its title sitting on the top border: ┌─ TITLE ──┐
// grow: share of the sidebar height (0 = fit content).
function box(t, id, title, count, body, grow = 0) {
  return v_flex().id(id).relative().mt(10).mx(10).pt(10).pb(6)
    .when(grow > 0, (el) => el.flex_basis(0).flex_grow(grow).flex_shrink(1).min_h(80))
    .when(grow === 0, (el) => el.flex_none())
    .border(1).border_color(t.border)
    .child(h_flex().absolute().top(-9).left(8).px(4).bg(t.chrome).gap(6)
      .child(div().text_color(t.accent).font_bold().child(title))
      .child(div().text_color(t.dim).child(count)))
    .child(body);
}

export default class NodoSidebar extends View {
  init(p, cx) {
    // Popups are copies of this mod; only the title strip and the lists listen for focus.
    if (p?.part && !["title", "spaces", "agents"].includes(p.part)) return;
    if (p?.part === "title") {
      // Focusable applies to every copy: step past the title strip onto the lists.
      cx.spawn(async () => { for (;;) if ((await nextCommand()) === "focus") run("pane.go", { direction: "down" }); });
      return;
    }
    this.handle = cx.focus_handle();
    this.items = []; // this block's rows, keyboard order: ["s:<space id>" | "a:<agent address>", ...]
    this.cursor = null; // item key under the keyboard cursor
    cx.spawn(async (cx) => {
      for (;;) {
        const c = await nextCommand();
        // Commands reach every copy of this mod; only the one holding the keyboard acts on keys.
        if (c !== "focus" && !this.handle.is_focused()) continue;
        if (c === "back") {
          this.back();
        } else if (c === "focus") {
          // The pane we came from: leaving goes back to it, not to whatever pane.go picks.
          // While a mod holds the keyboard focused().pane stays the last terminal pane, so
          // hopping spaces -> agents keeps it.
          this.from = focused()?.pane ?? null;
          this.cursor = this.items.find((k) => this.isCurrent(k)) ?? this.items[0] ?? null;
          this.handle.focus();
          // setShared re-renders every copy, so the block we left drops its cursor.
          setShared("nodo-sidebar.focus", `${props()?.part}:${Date.now()}`);
        } else continue;
        cx.notify();
      }
    });
    this.git = {}; // placeKey -> { repo, linked } | null (not a repo)
    this.pressed = null; // space id being dragged
    this.over = null; // space id under the pointer while dragging
    this.refreshGit(cx);
    cx.timer.every(GIT_EVERY, (cx) => this.refreshGit(cx));
  }

  isCurrent(k) {
    if (k.startsWith("s:")) return !!spaces().find((s) => `s:${s.id}` === k)?.active;
    return !!agents().find((a) => `a:${a.address}` === k)?.focused;
  }

  // Keys while the list has focus. Global chords (ctrl+s ...) still win.
  key(e, cx) {
    const ks = e.keystroke, i = this.items.indexOf(this.cursor);
    const move = (n) => { if (this.items.length) this.cursor = this.items[Math.max(0, Math.min(this.items.length - 1, n))]; };
    if (ks === "j" || ks === "down") move(i + 1);
    else if (ks === "k" || ks === "up") move(i - 1);
    else if (ks === "g") move(0);
    else if (ks === "shift-g") move(this.items.length - 1);
    else if (ks === "enter" || ks === "space") this.activate(this.cursor);
    else if (ks === "escape" || ks === "l" || ks === "right") this.back();
    else return;
    cx.stop_propagation();
    cx.notify();
  }

  // Back to the pane we came from if it's still in the shown tab, else the nearest one.
  back() {
    setShared("nodo-sidebar.focus", null);
    const tab = focused()?.tab;
    if (this.from && panes().some((p) => p.pane === this.from && p.tab === tab)) run("pane.focus", { pane: this.from });
    else run("pane.go", { direction: "right" });
  }

  activate(k) {
    if (!k) return;
    if (k.startsWith("s:")) {
      run("space.select", { id: k.slice(2) });
      run("pane.go", { direction: "right" });
    } else {
      const a = agents().find((x) => `a:${x.address}` === k);
      if (a) run("pane.focus", { pane: a.pane });
    }
  }

  // Which repo each space is in, and whether it's a linked worktree.
  refreshGit(cx) {
    cx.spawn(async (cx) => {
      const ps = panes();
      const keys = [...new Set(spaces().map((s) => placeKey(s, ps)))];
      let changed = false;
      for (const key of keys) {
        const [on, cwd] = JSON.parse(key);
        let info = null;
        try {
          const top = await exec("git", ["rev-parse", "--show-toplevel"], { cwd, on });
          const common = await exec("git", ["rev-parse", "--path-format=absolute", "--git-common-dir"], { cwd, on });
          if (top.code === 0 && common.code === 0) {
            const repo = common.stdout.trim();
            info = { repo: JSON.stringify([on, repo]), linked: repo !== `${top.stdout.trim()}/.git` };
          }
        } catch { info = this.git[key] ?? null; }
        if (JSON.stringify(this.git[key]) !== JSON.stringify(info)) { this.git[key] = info; changed = true; }
      }
      if (changed) cx.notify();
    });
  }

  // Spaces in model order, each linked worktree moved under its main checkout.
  ordered() {
    const sp = spaces(), ps = panes();
    const list = sp.map((s) => ({ s, g: this.git[placeKey(s, ps)] ?? null }));
    const mains = new Set(list.filter((r) => r.g && !r.g.linked).map((r) => r.g.repo));
    const nested = (r) => r.g?.linked && mains.has(r.g.repo);
    const out = [], placed = new Set();
    for (const r of list) {
      if (nested(r)) continue;
      out.push({ ...r, tree: null });
      if (!r.g || r.g.linked || placed.has(r.g.repo)) continue;
      placed.add(r.g.repo);
      const kids = list.filter((k) => nested(k) && k.g.repo === r.g.repo);
      kids.forEach((k, n) => out.push({ ...k, tree: n === kids.length - 1 ? "└─" : "├─" }));
    }
    return out;
  }

  spaceRow(t, { s, tree, g }) {
    const dragging = this.pressed !== null && this.pressed !== s.id;
    const from = spaces().findIndex((x) => x.id === this.pressed);
    const here = spaces().findIndex((x) => x.id === s.id);
    const cur = this.cursor === `s:${s.id}` && this.handle?.is_focused();
    return h_flex().id(`sp-${s.id}`).relative().h(22).px(8).gap(6).items_center()
      .when(s.active, (el) => el.bg(t.selected))
      .when(cur, (el) => el.bg(t.hover).border(1).border_color(t.accent))
      .hover((el) => el.bg(t.hover))
      .when(this.pressed === s.id && this.over !== s.id, (el) => el.opacity(0.5))
      .when(dragging && this.over === s.id, (el) => el.child(
        div().absolute().left(0).right(0).h(1).bg(t.accent)
          .when(from < here, (l) => l.bottom(0))
          .when(from > here, (l) => l.top(0))))
      .on_mouse_down("left", () => { this.pressed = s.id; this.over = s.id; })
      .on_mouse_move((_e, cx) => {
        if (this.pressed === null) return;
        const src = spaces().find((x) => x.id === this.pressed);
        const over = src && (src.machine ?? null) === (s.machine ?? null) ? s.id : null;
        if (this.over !== over) { this.over = over; cx.notify(); }
      })
      .on_mouse_up("left", (_e, cx) => {
        const src = this.pressed, over = this.over;
        this.pressed = null; this.over = null;
        if (src !== null && over === s.id && src !== s.id) run("space.move", { id: src, index: here + 1 });
        else if (src === s.id) run("space.select", { id: s.id });
        cx.notify();
      })
      .on_mouse_down("right", () =>
        openOverlay({
          mod: "nodo-sidebar", kind: "popup", width: 180, height: 170,
          props: { part: "space-menu", id: s.id, git: g ? (g.linked ? "linked" : "main") : null },
        }))
      .child(div().flex_none().w(10).text_color(t.accent).child(s.active ? ">" : " "))
      .when(!!tree, (el) => el.child(div().flex_none().text_color(t.dim).child(tree)))
      .child(div().flex_1().min_w(0).truncate().text_color(s.active ? t.foreground : t.muted).child(s.name))
      .when(!!s.branch && s.branch !== s.name, (el) =>
        el.child(div().flex_none().max_w(90).truncate().text_color(t.dim).child(s.branch)))
      .when(!!s.status && s.status !== "idle", (el) =>
        el.child(div().flex_none().text_color(statusColor(t, s.status)).child(MARK[s.status])));
  }

  agentRow(t, a) {
    const mark = div().flex_none().text_color(statusColor(t, a.status));
    const cur = this.cursor === `a:${a.address}` && this.handle?.is_focused();
    return v_flex().id(`ag-${a.address}`).px(8).py(3)
      .when(a.focused, (el) => el.bg(t.selected))
      .when(cur, (el) => el.bg(t.hover).border(1).border_color(t.accent))
      .hover((el) => el.bg(t.hover))
      .on_click(() => run("pane.focus", { pane: a.pane }))
      .on_mouse_down("right", () => openOverlay({
        mod: "nodo-sidebar", kind: "popup", width: 180, height: 140,
        props: { part: "agent-menu", address: a.address, pane: a.pane },
      }))
      .child(h_flex().gap(6).items_center()
        .child(a.status === "working" ? mark.frames(SPIN, 80) : mark.child(MARK[a.status] ?? "[ ]"))
        .child(div().flex_1().min_w(0).truncate()
          .text_color(a.focused ? t.foreground : t.muted).child((a.program?.name ?? a.app ?? "agent").toLowerCase()))
        .when(a.pinned, (el) => el.child(div().flex_none().text_color(t.accent).child("^")))
        .child(div().flex_none().text_color(t.dim).child(`${a.space_name}:${a.tab_index}`)))
      .when(!!a.title, (el) => el.child(div().pl(30).truncate().text_size(11).text_color(t.dim).child(a.title)));
  }

  // A retro popup menu: "> item" rows; picking one closes the popup, then acts.
  menu(t, p, items) {
    return v_flex().w_full().p(4).bg(t.popover).border(1).border_color(t.border)
      .font_family(mono()).text_size(12)
      .children(items.map(([label, act], i) =>
        h_flex().id(`mi-${i}`).h(24).px(8).items_center().text_color(t.foreground)
          .hover((el) => el.bg(t.hover).text_color(t.accent))
          .on_click(() => { closeOverlay(p.overlay); act(); })
          .child(`> ${label}`)));
  }

  agentMenu(t, p) {
    const a = agents().find((x) => x.address === p.address);
    return this.menu(t, p, a ? [
      [a.pinned ? "unpin" : "pin to top", () => run("terminal.pin", { terminal: a.address, pinned: !a.pinned })],
      ["peek", () => run("terminal.peek", { terminal: a.address })],
      ["focus", () => run("pane.focus", { pane: a.pane })],
      ["close pane", () => run("pane.close", { pane: a.pane })],
    ] : []);
  }

  // Same items as Herdr's space menu; worktree ones only inside a git checkout.
  spaceMenu(t, p) {
    const s = spaces().find((x) => x.id === p.id);
    const worktree = (action) => () => openOverlay({
      mod: "worktree", kind: "dialog",
      ...(action === "open" ? { width: 560, height: 480 } : { width: 440, height: 260 }),
      props: { space: p.id, action },
    });
    return this.menu(t, p, s ? [
      ["rename", () => run("space.rename", { id: s.id })],
      ...(p.git ? [["new worktree", worktree("new")], ["open worktree", worktree("open")]] : []),
      ...(p.git === "linked" ? [["remove worktree", worktree("remove")]] : []),
      ["close", () => run("space.close", { id: s.id })],
    ] : []);
  }

  render() {
    const t = theme();
    const p = props() ?? {};
    const root = v_flex().size_full().bg(t.chrome).font_family(mono()).text_size(12);

    if (p.part === "title") {
      return root.justify_center().pl(84).child(h_flex().gap(6)
        .child(div().text_color(t.accent).font_bold().child("HERDR"))
        .child(div().text_color(t.dim).child("_")));
    }
    if (p.part === "agent-menu") return this.agentMenu(t, p);
    if (p.part === "space-menu") return this.spaceMenu(t, p);

    const showSpaces = p.part !== "agents", showAgents = p.part !== "spaces";
    const rows = showSpaces ? this.ordered() : [];
    // Pinned first, otherwise the model's order (space, tab, pane).
    const ag = showAgents ? [...agents()].sort((x, y) => (y.pinned ? 1 : 0) - (x.pinned ? 1 : 0)) : [];
    if (showAgents) setAgentOrder(ag.map((a) => a.address));
    this.items = [...rows.map((r) => `s:${r.s.id}`), ...ag.map((a) => `a:${a.address}`)];
    if (this.cursor && !this.items.includes(this.cursor)) this.cursor = this.items[0] ?? null;

    const spaceRows = v_flex().id("space-rows").flex_1().min_h(0).overflow_y_scrollbar()
      .on_mouse_up("left", (_e, cx) => { if (this.pressed !== null) { this.pressed = null; this.over = null; cx.notify(); } })
      .children(rows.map((r) => this.spaceRow(t, r)));

    const agentRows = ag.length === 0
      ? div().px(8).h(22).text_color(t.dim).child("-- none --")
      : v_flex().children(ag.map((a) => this.agentRow(t, a)));

    return root.when(showAgents, (el) => el.pb(10)).id("nodo-sidebar")
      .track_focus(this.handle).on_key_down((e, cx) => this.key(e, cx))
      .when(showSpaces, (el) => el.child(box(t, "box-spaces", "SPACES", `${rows.length}`, spaceRows, 1)))
      .when(showAgents, (el) => el.child(box(t, "box-agents", "AGENTS", `${ag.length}`,
        v_flex().id("agent-rows").flex_1().min_h(0).overflow_y_scrollbar().child(agentRows), 2)));
  }
}

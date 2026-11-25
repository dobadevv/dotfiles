export function layoutPreview(node) {
  if (typeof node?.preview === "string" && node.preview) return node.preview;
  for (const child of node?.children ?? []) {
    const preview = layoutPreview(child);
    if (preview) return preview;
  }
  return null;
}

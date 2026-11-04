// Lists every git-tracked TS/JS function and method implementation (constructors are exempt) with more than 2 parameters,
// or with a destructured parameter that wraps the declaration over several lines.
// Usage: node find-violations.mjs [projectRoot]
// Output: <file>:<line>\t<name>\t<paramCount>\t<tags>; exits 1 when violations exist.
import { execFileSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import os from 'node:os';
import path from 'node:path';

const MAX_PARAMS = 2;
const root = path.resolve(process.argv[2] ?? '.');
const ts = loadTypeScript();

const files = execFileSync(
  'git',
  ['ls-files', '*.ts', '*.tsx', '*.mts', '*.cts', '*.js', '*.jsx', '*.mjs', '*.cjs'],
  { cwd: root, encoding: 'utf8' },
)
  .split('\n')
  .filter((file) => file && !/\.d\.[mc]?ts$/.test(file));

let violationCount = 0;
for (const file of files) {
  const text = readFileSync(path.join(root, file), 'utf8');
  const sourceFile = ts.createSourceFile(file, text, ts.ScriptTarget.Latest, true);
  visit(sourceFile, sourceFile, file);
}
console.error(`${violationCount} violation(s) in ${files.length} file(s)`);
process.exit(violationCount > 0 ? 1 : 0);

// TypeScript 7+ (native port) ships no JS compiler API, so only accept a build that has createSourceFile.
function loadTypeScript() {
  const cacheDir = path.join(os.homedir(), '.cache', 'fix-function-params');
  const candidates = [root, path.join(cacheDir, 'node_modules')];
  for (const dir of candidates) {
    try {
      const typescript = createRequire(path.join(dir, 'noop.js'))('typescript');
      if (typeof typescript.createSourceFile === 'function') return typescript;
    } catch {}
  }
  console.error(`No TypeScript with a JS compiler API found. Run once: npm i --prefix ${cacheDir} typescript@5`);
  process.exit(2);
}

function visit(node, sourceFile, file) {
  if (isImplementation(node)) {
    const params = node.parameters.filter((param) => param.name.getText(sourceFile) !== 'this');
    const tags = tagsOf(node);
    if (params.some((param) => isWrappedDestructuring(param, sourceFile))) tags.push('wrapped-destructuring');
    if (params.length > MAX_PARAMS || tags.includes('wrapped-destructuring')) {
      violationCount++;
      const { line } = sourceFile.getLineAndCharacterOfPosition(node.getStart(sourceFile));
      console.log([`${file}:${line + 1}`, nameOf(node, sourceFile), params.length, tags.join(',')].join('\t'));
    }
  }
  ts.forEachChild(node, (child) => visit(child, sourceFile, file));
}

function isImplementation(node) {
  return (
    (ts.isFunctionDeclaration(node) ||
      ts.isFunctionExpression(node) ||
      ts.isArrowFunction(node) ||
      ts.isMethodDeclaration(node)) &&
    node.body !== undefined
  );
}

function isWrappedDestructuring(param, sourceFile) {
  if (!ts.isObjectBindingPattern(param.name)) return false;
  const lineOf = (position) => sourceFile.getLineAndCharacterOfPosition(position).line;
  return lineOf(param.name.getStart(sourceFile)) !== lineOf(param.name.getEnd());
}

function nameOf(node, sourceFile) {
  if (node.name) return node.name.getText(sourceFile);
  const parent = node.parent;
  if ((ts.isVariableDeclaration(parent) || ts.isPropertyAssignment(parent) || ts.isPropertyDeclaration(parent)) && parent.name) {
    return parent.name.getText(sourceFile);
  }
  return '<anonymous>';
}

// callback: the receiving call dictates the signature; exempt only when that callee comes from a library.
function tagsOf(node) {
  const parent = node.parent;
  const isInlineCallback =
    ((ts.isCallExpression(parent) || ts.isNewExpression(parent)) && parent.arguments?.includes(node)) ||
    ts.isJsxExpression(parent);
  return isInlineCallback ? ['callback'] : [];
}

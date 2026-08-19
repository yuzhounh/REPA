import { execSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const input = path.join(root, 'assets', 'icon.svg');
const output = path.join(root, 'assets', 'favicon.png');

execSync(`npx --yes @resvg/resvg-js-cli "${input}" "${output}"`, {
  stdio: 'inherit',
  cwd: root,
});

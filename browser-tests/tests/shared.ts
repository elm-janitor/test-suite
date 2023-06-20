import { execSync } from 'node:child_process';
import path from 'node:path';
import fs from 'node:fs/promises';

export async function compileElmProgram(name: string, cwd: string) {
    const out = `${name}.html`;
    execSync(`elm make ${name}.elm --output=${out}`, { cwd });
    // remove Elm caches
    await fs.rm(path.join(cwd, 'elm-stuff'), { force: true, recursive: true });
    return path.join(cwd, out);
}

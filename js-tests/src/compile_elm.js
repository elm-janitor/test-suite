const { spawn } = require('node:child_process');
const os = require('node:os');
const path = require('node:path');


/**
 * Executes the Elm compiler
 * @param {string} moduleName Elm module name
 * @returns {string} path to compiled .js file
 */
async function compile(moduleName) {
    return new Promise((resolve, reject) => {
        const outFile = path.join(os.tmpdir(), `${moduleName}_${Date.now()}.js`);
        const args = ['make', `src/${moduleName}.elm`, '--output', outFile, '--optimize'];
        // stdio: stdin, stdout, stderr
        const compiler = spawn('elm', args, { stdio: ['inherit', 'ignore', 'pipe'] });

        const err = [];

        compiler.stderr.on('data', (data) => {
            err.push(data.toString());
        });

        compiler.on('close', (code) => {
            if (code === 0) {
                resolve(outFile);
            } else {
                console.error(err.join('\n'));
                reject(code);
            }
        });
    });
}

module.exports = {
    compile,
};

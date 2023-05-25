const fs = require('node:fs/promises');
const { compile } = require('./src/compile_elm.js');

/**
 * Test changes of <https://github.com/elm/core/pull/952>
 */

let simpleWorkerJsFile;

beforeAll(async () => {
    await fs.rm('./elm-stuff', { force: true, recursive: true });
    simpleWorkerJsFile = await compile('SimpleWorker');
});

afterAll(() => {
    if (simpleWorkerJsFile) return fs.rm(simpleWorkerJsFile)
});

// Fixes https://github.com/elm/core/pull/952#issue-309052667
test('Throw an exception when a non-function callback is passed to elm.ports[port].subscribe', async () => {
    const { Elm } = require(simpleWorkerJsFile);
    const app = Elm.SimpleWorker.init();

    expect(() => app.ports.state.subscribe(undefined)).toThrow();
});

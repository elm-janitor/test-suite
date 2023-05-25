const fs = require('node:fs/promises');
const { compile } = require('../src/compile_elm.js');

/**
 * Test changes of <https://github.com/elm/core/pull/952>
 */

let compiledFile;

beforeAll(async () => {
    compiledFile = await compile('SimpleWorker');
});

afterAll(() => {
    if (compiledFile) return fs.rm(compiledFile);
});

// Fixes https://github.com/elm/core/pull/952#issue-309052667
test('Throw an exception when a non-function callback is passed to elm.ports[port].subscribe', async () => {
    const Elm = require(compiledFile).Elm.SimpleWorker;
    const app = Elm.init();

    expect(() => app.ports.state.subscribe(undefined)).toThrow();
});

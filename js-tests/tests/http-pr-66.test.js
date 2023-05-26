const fs = require('node:fs/promises');
const { compile } = require('../src/compile_elm.js');

/**
 * Test changes of <https://github.com/elm/http/pull/66>
 */

let compiledFile;

beforeAll(async () => {
    compiledFile = await compile('HttpPr66');
});

afterAll(() => {
    if (compiledFile) return fs.rm(compiledFile);
});

// Fixes https://github.com/elm/http/pull/66#issue-502583298
test('Should send xhr with charset utf-8', async () => {
    const xhrMock = {
        open: jest.fn(),
        send: jest.fn(),
        setRequestHeader: jest.fn(),
        addEventListener: jest.fn(),
        readyState: 4,
        status: 200,
        response: 'OK',
    };

    jest.spyOn(window, 'XMLHttpRequest').mockImplementation(() => xhrMock);

    const Elm = require(compiledFile).Elm.HttpPr66;
    Elm.init();

    expect(xhrMock.open).toBeCalledWith('POST', 'https://example.test', true);
    const expected = "application/json;charset=utf-8";
    expect(xhrMock.setRequestHeader).toBeCalledWith('Content-Type', expected);
});

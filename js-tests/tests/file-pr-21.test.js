const fs = require('node:fs/promises');
const { compile } = require('../src/compile_elm.js');

/**
 * Test changes of <https://github.com/elm/file/pull/21>
 * 
 * Problem: `download` attribute was not implemented in iOS < 13
 * https://bugs.webkit.org/show_bug.cgi?id=167341
 * 
 * And other browsers cannot use all the features of Webkit that Safari is allowed to.
 * It was still reported as an issue in the Safari-based Chrome browser on 2021-09-23
 * https://bugs.webkit.org/show_bug.cgi?id=167341#c66
 */

let elm;
let beforeURL;

beforeAll(async () => {
    elm = await compile('FilePr17');
    const code = await fs.readFile(elm, { encoding: 'utf-8' });
    const changed = fakeFileClick(code);
    await fs.writeFile(elm, changed);
    beforeURL = window.URL;
});

afterAll(() => {
    window.URL = beforeURL;
    if (elm) return fs.rm(elm);
});

beforeEach(() => {
    jest.useFakeTimers();
    jest.spyOn(global, 'setTimeout');
})

afterEach(() => {
    jest.useRealTimers();
})

/**
 * Verify that fix of https://github.com/elm/file/issues/17 is used.
 * This suite cannot actually test that using `setTimeout` fixes the issue on iOS devices.
 * It only tests that `setTimeout` is used.
 * Description of the fix using `setTimeout`: https://developer.apple.com/forums/thread/115102
 */
test('ensure `setTimeout` is used before the ObjectURL is revoked', async () => {
    const fakeObjectUrl = 'fake-obj-url'
    const origCreateObjectURL = window.URL.createObjectURL;
    const origRevokeObjectURL = window.URL.revokeObjectURL;
    const mockCreateObjectURL = jest.fn(obj => fakeObjectUrl);
    window.URL.createObjectURL = mockCreateObjectURL;

    const mockRevokeObjectURL = jest.fn();
    window.URL.revokeObjectURL = mockRevokeObjectURL;

    const Elm = require(elm).Elm.FilePr17;
    // file download is triggered directly during init, but stopped due to `fakeFileClick`
    Elm.init();
    window.URL.createObjectURL = origCreateObjectURL;
    expect(mockCreateObjectURL).toHaveBeenCalledTimes(1);

    // fix introduced a setTimeout https://github.com/elm/file/issues/17#issuecomment-668408518
    expect(setTimeout).toHaveBeenCalledTimes(1);
    jest.runAllTimers();

    // and afterwards the ObjectURL is removed again
    window.URL.revokeObjectURL = origRevokeObjectURL;
    expect(mockRevokeObjectURL).toHaveBeenCalledWith(fakeObjectUrl);
    expect(mockRevokeObjectURL).toHaveBeenCalledTimes(1);
});


/**
 * JSDOM fails without this change with error:
 * `Error: Not implemented: navigation (except hash changes)`
 */
function fakeFileClick(code) {
    const fn = 'function _File_click(node)';
    const fnIndex = code.indexOf(fn);
    if (fnIndex < 0) throw `Could not find '${fn}' in code`;
    const openParens = code.indexOf('{', fnIndex);
    return code.substring(0, openParens + 1) + 'return "fake _File_click";' + code.substring(openParens + 1);
}

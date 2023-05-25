const fs = require('node:fs/promises');

/**
 * Configured in field `globalSetup` of `./jest.config.js`.
 * @param {import('@jest/types').Config.GlobalConfig} _globalConfig 
 * @param {import('@jest/types').Config.ProjectConfig} projectConfig 
 */
module.exports = async function setup(_globalConfig, _projectConfig) {
    console.log('\nRemoving elm-stuff before running jest tests.\n');
    await fs.rm('./elm-stuff', { force: true, recursive: true });
}

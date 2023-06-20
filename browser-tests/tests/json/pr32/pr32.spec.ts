import { test, expect } from '@playwright/test';
import { compileElmProgram } from '../../shared';

test('Verify https://github.com/elm/json/pull/32', async ({ page }) => {
    // Fixes https://github.com/elm/core/issues/904
    // Fixes https://github.com/elm/json/issues/15
    const file = await compileElmProgram('Issue15Example', __dirname);

    await page.goto(`file://${file}`);

    const okBtn = page.getByText("+1 (works)");
    const failBtn = page.getByText("oneOf failure: Will always set value to 1");

    await failBtn.click();
    const h1 = page.locator('h1');
    await expect(h1).toHaveText('1');

    await okBtn.click();
    await expect(h1).toHaveText('2');

    await failBtn.click();
    await expect(h1).toHaveText('3');
});

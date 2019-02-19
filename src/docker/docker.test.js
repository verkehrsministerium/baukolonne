const { setup } = require('shellshot');

setup();

it(
    'tests if make build succeeds in CI environment',
    async () => {
        await expect.command('make build')
            .withEnv({ CI: '1' })
            .forExitCode(expectation => expectation.toBe(0));
    },
);

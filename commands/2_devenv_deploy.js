#!/usr/bin/env node

const { runWinScript } = require('./utils');

exports.command = 'devenvDeploy';
exports.desc = 'Build the custom distro';
exports.builder = {
    entryPoint: {
        alias: 'e',
        describe: 'The file number the script will begin at. If no argument is given, the scripts will begin normally.' +
        '\n  1 - build-environment' +
        '\n  2 - setup-win-firewall-rules',
        type: 'number',
        default: 1
    },
    singlePoint: {
        alias: 's',
        describe: 'Run only a single script. If no argument is given, all scripts will run.' +
        '\n  1 - build-environment' +
        '\n  2 - setup-win-firewall-rules',
        type: 'number',
        default: null
    },
    verbose: {
        alias: 'v',
        describe: 'Enables verbose logging',
        type: 'boolean',
        default: false
    }
};
exports.handler = function (argv) {
    const scripts = [
        './resources/build-environment.ps1',
        './win-scripts/7_setup-win-firewall-rules.ps1'
    ];
    
    const spinnerTexts = [
        'Building AuGR Distro, anticipate about 20m',
        'Building Windows Firewall rules'
    ];
    const endLogs = [
        'Distro build complete.',
        'Firewall rules setup complete.'
    ];

    const entryPoint = argv.entryPoint - 1;

    let promise = Promise.resolve();

    for (let index = entryPoint; index < scripts.length; index++) {
        const script = scripts[index];
        const endLog = endLogs[index];

        if (argv.singlePoint && index !== argv.singlePoint - 1) {
            continue;
        }
        const spinnerText = spinnerTexts[index];
        promise = promise
            .then(() => runWinScript(script, argv.verbose, spinnerText))
            .then(() => console.log(endLog));
    }
    promise
        .then(() => console.log('devenvDeploy, please run wslDeploy next.'))
        .catch(err => {
            console.error(err);
            process.exit(1);
        });
};

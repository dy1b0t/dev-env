#!/usr/bin/env node

const fs = require("fs");
const { runWinScript } = require("./utils");

exports.command = "devenvSetup";
exports.desc = "Set up the development environment";
exports.builder = {
  entryPoint: {
    alias: "e",
    describe:
      "The file number the script will begin at. If no argument is given, the scripts will begin normally.",
    type: "number",
    default: 1,
  },
  singlePoint: {
    alias: "s",
    describe:
      "Run only a single script. If no argument is given, all scripts will run.",
    type: "number",
    default: null,
  },
  verbose: {
    alias: "v",
    describe: "Enables verbose logging",
    type: "boolean",
    default: false,
  },
};

exports.handler = function (argv) {
  const scripts = [
    "./win-scripts/1_setup-win-pwsh.ps1",
    "./win-scripts/2_install-dep-docker.ps1",
    "./win-scripts/3_install-dep-vscode.ps1",
    "./win-scripts/4_enable-wsl2-part1.ps1",
    "./win-scripts/5_enable-wsl2-part2.ps1",
    "./win-scripts/6_setup-win-hosts.ps1",
  ];

  const endLogs = [
    "PowerShell setup complete.",
    "Docker installation complete.",
    "VSCode installation complete.",
    "WSL2 part 1 setup complete.",
    "WSL2 part 2 setup complete.",
    "Host setup complete.",
  ];

  const entryPoint = argv.entryPoint - 1;

    let promise = Promise.resolve();

    for (let index = entryPoint; index < scripts.length; index++) {
        const script = scripts[index];
        const endLog = endLogs[index];

        if (argv.singlePoint && index !== argv.singlePoint - 1) {
            continue;
        }
        promise = promise
            .then(() => runWinScript(script, argv.verbose))
            .then(() => console.log(endLog));
    }
    promise
        .then(() => console.log('devenvDeploy, please run wslDeploy next.'))
        .catch(err => {
            console.error(err);
            process.exit(1);
        });
};

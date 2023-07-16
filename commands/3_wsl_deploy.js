#!/usr/bin/env node

const { runInheritScript } = require("./utils");

exports.command = "wslDeploy";
exports.describe = "Run sequence of WSL housekeeping scripts within WSL";
exports.builder = {
  entryPoint: {
    alias: "e",
    describe:
      "The file number the script will begin at. If no argument is given, the scripts will begin normally." +
      "\n  1 - export-path" +
      "\n  2 - config-host" +
      "\n  3 - import-cert" +
      "\n  4 - update-deps" +
      "\n  5 - verify-tools" +
      "\n  6 - initialize-docker",
    type: "number",
    default: 1,
  },
  singlePoint: {
    alias: "s",
    describe:
      "Run only a single script. If no argument is given, all scripts will run." +
      "\n  1 - export-path" +
      "\n  2 - config-host" +
      "\n  3 - import-cert" +
      "\n  4 - update-deps" +
      "\n  5 - verify-tools" +
      "\n  6 - initialize-docker",
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
    "1_export-path.sh",
    "2_config-host.sh",
    "3_import-cert.sh",
    "4_update-deps.sh",
    "5_verify-tools.sh",
    "6_initialize-docker.sh",
  ];
  const endLogs = [
    "Path updated.",
    "WSL Hosts configured successfully",
    "Certificate imported to Windows.",
    "Dependencies updated.",
    "Tool verification has completed.",
    "Docker is currently running, and user has been added to group."
  ];

  const entryPoint = argv.entryPoint - 1;

  const scriptPath = "/home/Ubuntu/wsl-scripts/wsl";

  let promise = Promise.resolve();

  for (let index = entryPoint; index < scripts.length; index++) {
    const script = scripts[index];
    const endLog = endLogs[index];

    if (argv.singlePoint && index !== argv.singlePoint - 1) {
      continue;
    }
    promise = promise
      .then(() => runInheritScript(`${scriptPath}/${script}`, argv.verbose))
      .then(() => console.log(endLog));
  }
};

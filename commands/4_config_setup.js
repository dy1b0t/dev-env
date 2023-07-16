const { runInheritScript, runScriptWithRetry } = require("./utils");
 
exports.command = "mk8sSetup";
exports.describe = "Run sequence of mk8s setup scripts";
exports.builder = {
  entryPoint: {
    alias: "e",
    describe:
      "The file number the script will begin at. If no argument is given, the scripts will begin normally." +
      "\n  1 - login-lpass" +
      "\n  2 - gen-config-gittoken" +
      "\n  3 - gen-config-docker" +
      "\n  4 - login-docker" +
      "\n  5 - gen-config-ssh" +
      "\n  6 - clone-repos",
    type: "number",
    default: 1,
  },
  singlePoint: {
    alias: "s",
    describe:
      "Run only a single script. If no argument is given, all scripts will run." +
      "\n  1 - login-lpass" +
      "\n  2 - gen-config-gittoken" +
      "\n  3 - gen-config-docker" +
      "\n  4 - login-docker" +
      "\n  5 - gen-config-ssh" +
      "\n  6 - clone-repos",
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
    "1_login-lpass.sh",
    "2_gen-config-gittoken.sh",
    "3_gen-config-docker.sh",
    "4_login-docker.sh",
    "5_gen-config-ssh.sh",
    "6_clone-repos.sh",
  ];
  const endLogs = [
    "Logged in and synced with lastpass sucessfully.",
    "Token 'gittoken' added to lastpass sucessfully.",
    "Docker config file generated successfully.",
    "Docker login to docker.n50.black successful.",
    "SSH configuration with Github established successfully.",
    "Repository has been cloned successfully.",
  ];

  const entryPoint = argv.entryPoint - 1;

  const scriptPath = "/home/Ubuntu/wsl-scripts/config";

  let promise = Promise.resolve();

  for (let index = entryPoint; index < scripts.length; index++) {
    const script = scripts[index];
    const endLog = endLogs[index];

    if (argv.singlePoint && index !== argv.singlePoint - 1) {
      continue;
    }

    // If the current script is 7, restart WSL and retry upon failure
    if (index === 6) {
      const { execSync } = require("child_process");
      try {
        execSync("wsl --shutdown");
        console.log("WSL shutdown successfully.");
      } catch (err) {
        console.error("Failed to shutdown WSL:", err);
        process.exit(1);
      }

      const MAX_RETRIES = 3;

      promise = promise.then(() => {
        return runScriptWithRetry(`${scriptPath}/${script}`, argv.verbose, MAX_RETRIES)
          .then(() => console.log(endLog))
          .catch((error) => {
            console.error('Snap install failed after maximum retries:', error);
            process.exit(1);
          });
      });
    } else {
      promise = promise
        .then(() => runInheritScript(`${scriptPath}/${script}`, argv.verbose))
        .then(() => console.log(endLog));
    }
  }
};

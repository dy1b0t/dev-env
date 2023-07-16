const { spawn } = require("child_process");
const ora = require("ora");

module.exports.runWinScript = function runWinScript(
  scriptPath,
  verbose,
  spinnerMsg = ""
) {
  return new Promise((resolve, reject) => {
    const now = new Date();
    const currentTime = `${now.getHours()}:${now.getMinutes()}`;

    const process = spawn("pwsh.exe", ["-File", scriptPath]);

    let spinner;
    if (!verbose && spinnerMsg) {
      spinner = ora(`${spinnerMsg} from ${currentTime}...`).start();
    }

    process.stdout.on("data", function (data) {
      if (verbose) console.log(data.toString());
    });

    process.stderr.on("data", function (data) {
      console.error(data.toString());
    });

    process.on("close", (code) => {
      if (spinner) spinner.stop();

      if (code !== 0) {
        console.error(`\nScript exited with error code: ${code}`);
        return reject(new Error(`Script exited with error code: ${code}`));
      }

      resolve();
    });
  });
};

module.exports.runWslScript = function runWslScript(scriptPath, verbose) {
  return new Promise((resolve, reject) => {
    let process = spawn("wsl", ["-u", "Ubuntu", scriptPath]);

    process.stdout.on("data", (data) => {
      if (verbose) console.log(`${scriptPath} output:\n${data}`);
    });

    process.stderr.on("data", (data) => {
      console.error(`${scriptPath} error:\n${data}`);
    });

    process.on("exit", (code) => {
      if (code !== 0) {
        reject(new Error(`${scriptPath} exited with code ${code}`));
      } else {
        console.log(`${scriptPath} executed successfully`);
        resolve();
      }
    });
  });
};

module.exports.runInheritScript = function runInheritScript(scriptPath) {
  return new Promise((resolve, reject) => {
    const childProcess = spawn("wsl", ["-u", "Ubuntu", scriptPath], {
      stdio: "inherit",
    });

    childProcess.on("exit", (code) => {
      if (code !== 0) {
        return reject(new Error(`Script exited with code ${code}`));
      }
      resolve();
    });
  });
};

const { runInheritScript } = module.exports;
const { execSync } = require("child_process");

module.exports.runScriptWithRetry = function runScriptWithRetry(scriptPath, verbose, maxRetries) {
  return new Promise((resolve, reject) => {
    function attempt(n) {
      if (n === 0) {
        reject(new Error('Script failed after maximum retries'));
      } else {
        runInheritScript(scriptPath, verbose)
          .then(resolve)
          .catch((error) => {
            console.log(`Attempt ${maxRetries - n + 1} failed, restarting WSL and trying again...`);
            execSync("wsl --shutdown");
            attempt(n - 1);
          });
      }
    }
    attempt(maxRetries);
  });
};

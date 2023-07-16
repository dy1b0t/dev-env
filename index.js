const yargs = require("yargs");
const figlet = require("figlet");

yargs
  .scriptName("node index.js")
  .usage(
    figlet.textSync("Custom WSL Dev Env", {
      font: "Dr Pepper",
    }) + "\nUsage: $0 <command> [options]"
  )
  .commandDir("commands")
  .demandCommand(1, "You need at least one command before moving on")
  .option("e", {
    alias: "entryPoint",
    describe: "The file number the script will begin at.",
    type: "number",
  })
  .option("s", {
    alias: "singlePoint",
    describe: "Run only a single script.",
    type: "number",
  })
  .option("v", {
    alias: "verbose",
    describe: "Enable verbose logging.",
    type: "boolean",
  })
  .help()
  .wrap(yargs.terminalWidth())
  .argv;

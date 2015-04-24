fs = require "fs"
onlyScripts = require("./utils/scriptFilter")
tasks = fs.readdirSync("#{__dirname}/tasks/").filter onlyScripts

tasks.forEach (task) ->
  require "./tasks/#{task}"

notify = require "gulp-notify"

module.exports = ->
  # Send error to notification center with gulp-notify
  opts =
    title: "Compile Error"
    message: "<%= error.message %>"

  notify.onError(opts).apply this, arguments

  # Keep gulp from hanging on this task
  this.emit "end"

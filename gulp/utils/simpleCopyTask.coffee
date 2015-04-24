gulp = require "gulp"
paths = require "../paths"

module.exports = (name) ->
  gulp.task "copy-#{name}", ->
    gulp.src paths[name].src
      .pipe gulp.dest(paths[name].dest)

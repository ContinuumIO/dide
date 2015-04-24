gulp = require "gulp"
livereload = require "gulp-livereload"
sass = require "gulp-sass"

gulp.task "sass", ->
  gulp.src "./scss/application.scss"
    .pipe sass()
    .pipe gulp.dest "./css/"
    .pipe livereload auto: false

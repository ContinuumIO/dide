gulp = require "gulp"
livereload = require "gulp-livereload"

gulp.task "default", ["build"], ->
  livereload.listen auto: true

  coffeePath = "coffee/**/*.*"
  gulp.watch "scss/**/*.*", ["sass", ]
  gulp.watch [coffeePath, "test/**/*.*"], ["test", ]

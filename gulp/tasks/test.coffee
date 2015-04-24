gulp = require "gulp"
mocha = require "gulp-mocha"

gulp.task "test", ->
  # TODO Handle failure better
  gulp.src "./test", read: false
    .pipe mocha()

gulp.task "test:watch", ["test"], ->
  gulp.watch ["./test/**/**", "./coffee/**/**"], ["test"]

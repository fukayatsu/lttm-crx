gulp        = require 'gulp'
coffee      = require 'gulp-coffee'
sass        = require 'gulp-sass'
clean       = require 'gulp-clean'
zip         = require 'gulp-zip'
runSequence = require 'run-sequence'
download    = require 'gulp-download'
Octokat     = require 'octokat'
fs          = require 'fs'

paths =
  lib: 'lib/**/*.*'
  js:  'src/js/**/*.coffee'
  css: 'src/css/**/*.scss'

gulp.task 'copy', ->
  gulp.src(paths.lib)
    .pipe(gulp.dest('build/'))

gulp.task 'download:misawa', ->
  download('http://horesase.github.io/horesase-boys/meigens.json')
   .pipe(gulp.dest("lib/config"))

gulp.task 'download:irasutoya', ->
  download('https://june29.github.io/irasutoya-data/irasutoya.json')
   .pipe(gulp.dest("lib/config"))

gulp.task 'download:decomoji', (done) ->
  octo = new Octokat()
  repo = octo.repos('oti', 'slack-reaction-decomoji')
  images = []
  dirs = ['basic', 'extra']
  fetchPromises = dirs.map((dir) -> repo.contents("decomoji/#{dir}").fetch(ref: '4.0.0'))
  Promise.all(fetchPromises).then (contents) ->
    contents = [].concat.apply([], contents) # array flatten
    for content in contents
      images.push
        url: content.downloadUrl
        keywords: [content.name.split('.')[0]]

    fs.writeFileSync "lib/config/decomoji.json", JSON.stringify(images)

gulp.task 'download:sushidot', (done) ->
  octo = new Octokat()
  repo = octo.repos('fukayatsu', 'lttm-crx')
  images = []
  repo.contents('vendor/sushidot').fetch (err, contents) ->
    for content in contents
      images.push
        url: content.downloadUrl
        keywords: [content.name.split('.')[0]]

    fs.writeFileSync "lib/config/sushidot.json", JSON.stringify(images)
    done()

gulp.task 'coffee', ->
  gulp.src(paths.js)
    .pipe(coffee())
    .pipe(gulp.dest('build/js/'))

gulp.task 'sass', ->
  gulp.src(paths.css)
    .pipe(sass())
    .pipe(gulp.dest('build/css/'))

gulp.task 'watch', ->
  gulp.watch paths.lib, ['copy']
  gulp.watch paths.js,  ['coffee']
  gulp.watch paths.css, ['sass']

gulp.task 'clean', ->
  gulp.src(['build', 'build.zip'], { read: false })
    .pipe(clean())

gulp.task 'zip', ->
  gulp.src('build/**/*.*')
    .pipe(zip('build.zip'))
    .pipe(gulp.dest('./'))

gulp.task 'download', [
  'download:misawa',
  'download:irasutoya',
  'download:decomoji',
  'download:sushidot'
]
gulp.task 'build',    ['copy', 'download', 'coffee', 'sass']
gulp.task 'rebuild', -> runSequence('clean', 'build')
gulp.task 'release', -> runSequence('clean', 'build', 'zip')
gulp.task 'default', -> runSequence('clean', 'build', 'watch')

gulp        = require 'gulp'
coffee      = require 'gulp-coffee'
sass        = require('gulp-sass')(require 'sass')
clean       = require 'gulp-clean'
zip         = require 'gulp-zip'
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
  repo = octo.repos('decomoji', 'slack-reaction-decomoji')
  images = []
  ref = "4.12.0"
  types = ['basic', 'extra']
  promises = types.map((type) -> repo.contents("decomoji-#{type}.md").read(ref: ref))
  Promise.all(promises).then (contents) ->
    for content in contents
      matches = content.match(/decomoji\/[a-z]+\/[0-9a-z-_]+\.png/g)
      for match in matches
        images.push
          url: "https://raw.githubusercontent.com/decomoji/slack-reaction-decomoji/#{ref}/#{match}"
          keywords: [match.replace(/.*\/|\.png/g, '')]

    fs.writeFileSync "lib/config/decomoji.json", JSON.stringify(images)

gulp.task 'download:sushidot', (done) ->
  octo = new Octokat()
  repo = octo.repos('fukayatsu', 'lttm-crx')
  images = []
  repo.contents('vendor/sushidot').fetch (err, contents) ->
    for content in contents.items
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
  gulp.watch paths.lib, gulp.task('copy')
  gulp.watch paths.js,  gulp.task('coffee')
  gulp.watch paths.css, gulp.task('sass')

gulp.task 'clean', ->
  gulp.src(['build', 'build.zip'], { read: false, allowEmpty: true })
    .pipe(clean())

gulp.task 'zip', ->
  gulp.src('build/**/*.*')
    .pipe(zip('build.zip'))
    .pipe(gulp.dest('./'))

gulp.task 'download', gulp.parallel(
  'download:misawa',
  'download:irasutoya',
  'download:decomoji',
  'download:sushidot'
)

gulp.task 'build', gulp.parallel('copy', 'download', 'coffee', 'sass')
gulp.task 'rebuild', gulp.series('clean', 'build')
gulp.task 'release', gulp.series('clean', 'build', 'zip')
gulp.task 'default', gulp.series('clean', 'build', 'watch')

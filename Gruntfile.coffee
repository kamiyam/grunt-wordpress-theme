"use strict"
module.exports = (grunt) ->


  wordpressUrl = "http://localhost:3000/"
  try
    themeConfig = grunt.file.readJSON('./theme.json')

  catch e
    return grunt.log.error e

  # configurable paths
  config =
    LIVERELOAD_PORT: 35729
    server:
      url: require("url").parse(wordpressUrl)
      ini: null
#      ini: "/usr/local/etc/php/5.4/php.ini"   # -c option ini file path ex) /usr/local/etc/php/5.4/php.ini
      root: "../../"   # -t option docment root file path ex)/htdocs
    wp:
      themeDir: "../themes/" + themeConfig.badge.text_domain
    srcDir: "app/"
    devDir: ".tmp/"

  themeDir =
    css: themeConfig.assets_dir.css + "/"
    js: themeConfig.assets_dir.js + "/"
    img: themeConfig.assets_dir.img + "/"

  wordpressUrl = themeConfig.url

  linker =
    linkerCsss: ["linker/**"]
    linkerJs: ["linker/**"]

  ## server strat command
  phpOption = do ->
    options = []

    options.push("-S")
    options.push(config.server.url.host + "")
    if config.server.ini?
      options.push("-c")
      options.push(config.server.ini)
    if config.server.root?
      options.push("-t")
      options.push(config.server.root)

    return options

  ## grunt tasks

  # Load grunt tasks automatically
  require('load-grunt-tasks')(grunt)

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt)

  # Project configuration.
  grunt.initConfig

    external_daemon:
      php:
        cmd: "php"
        args: phpOption
        options:
          verbose: true

    ## Set compile settings
    sass:
      dev:
        files: [
          expand: true
          cwd: config.srcDir + "linker/" + themeDir.css
          src: ["**/*.sass","**/*.scss"]
          dest: config.devDir + "linker/" + themeDir.css
          ext: ".css"
        ,
          expand: true
          cwd: config.srcDir + themeDir.css
          src: ["**/*.sass","**/*.scss"]
          dest: config.devDir + themeDir.css
          ext: ".css"
        ]

    less:
      dev:
        files: [
          expand: true
          cwd: config.srcDir + "linker/" + themeDir.css
          src: ["**/*.less"]
          dest: config.devDir + "linker/" + themeDir.css
          ext: ".css"
        ,
          expand: true
          cwd: config.srcDir + themeDir.css
          src: ["**/*.less"]
          dest: config.devDir + themeDir.css
          ext: ".css"
        ]

    stylus:
      dev:
        files: [
          expand: true
          cwd: config.srcDir + "linker/" + themeDir.css
          src: ["**/*.styl"]
          dest: config.devDir + "linker/" + themeDir.css
          ext: ".css"
        ,
          expand: true
          cwd: config.srcDir + themeDir.css
          src: ["**/*.styl"]
          dest: config.devDir + themeDir.css
          ext: ".css"
        ]

    coffee:
      grunt:
        files:
          ".Gruntfile.js": "Gruntfile.coffee"

      dev:
        options:
          bare: true
          sourceMap: true
        files: [
          expand: true
          cwd: config.srcDir + "linker/" + themeDir.js
          src: ['**/*.coffee']
          dest: config.devDir + "linker/" + themeDir.js
          ext: '.js'
        ,
          expand: true
          cwd: config.srcDir + themeDir.js
          src: ['**/*.coffee']
          dest: config.devDir + themeDir.js
          ext: '.js'
        ]

    typescript:
      dev:
        files: [
          expand: true
          cwd: config.srcDir + "linker/" + themeDir.js
          src: ['**/*.ts']
          dest: config.devDir + "linker/" + themeDir.js
          ext: '.js'
        ,
          expand: true
          cwd: config.srcDir + themeDir.js
          src: ['**/*.ts']
          dest: config.devDir + themeDir.js
          ext: '.js'
        ]

    # watch files settings
    watch:
      options:
        livereload: false

      sass:
        options:
          cwd: config.srcDir
        files: [
          themeDir.css + "**/*.sass"
          themeDir.css + "**/*.scss"
          "linker/" + themeDir.css + "**/*.sass"
          "linker/" + themeDir.css + "**/*.scss"
        ]
        tasks: ["sass:dev"]

      less:
        options:
          cwd: config.srcDir
        files: [
          themeDir.css + "**/*.less"
          "linker/" + themeDir.css + "**/*.less"
        ]
        tasks: ["less:dev"]

      stylus:
        options:
          cwd: config.srcDir
        files: [
          themeDir.css + "**/*.styl"
          "linker/" + themeDir.css + "**/*.styl"
        ]
        tasks: ["stylus:dev"]

      coffee:
        options:
          cwd: config.srcDir
        files: [
          themeDir.js + "**/*.coffee"
          "linker/" + themeDir.js + "**/*.coffee"
        ]
        tasks: ["coffee:dev"]

      typescript:
        options:
          cwd: config.srcDir
        files: [
          themeDir.js + "**/*.ts"
          "linker/" + themeDir.js + "**/*.ts"
        ]
        tasks: ["typescript:dev"]

      plain:
        options:
          cwd: config.srcDir
          livereload: false
        files: ["**/*.php", "**/*.css", "**/*.js"]
        tasks: ["sync:dev"]

      compiled:
        options:
          cwd: config.devDir
          livereload: true
        files: ["css/**/*.css", "**/*.php",  "**/*.js"]

    clean:
      grunt:
        src: ".Gruntfile.js"
      theme:
        src: [config.wp.themeDir]
#        options:
#          force: true
      dev:
        cwd: config.devDir
        src: ["**"]
        options:
          force: true

    sync:
      dev:
        files: [
          cwd: config.srcDir
          src: ["**","!**/*.{ts,sass,scss,less,styl}"]
          dest: config.devDir
        ],
        verbose: true
      dist:
        files: [
          cwd: config.devDir
          src: ["**","!**/*.{coffee,map,ts,sass,scss,less,styl}"]
          dest: config.wp.themeDir
        ],
        verbose: true

    symlink:
      options:
        overwrite: false
      dev:
        src: config.devDir
        dest: config.wp.themeDir

    replace:
      options:
        patterns: [
          match: "theme_name"
          replacement: themeConfig.badge.theme_name
        ,
          match: "theme_url"
          replacement: themeConfig.badge.theme_url
        ,
          match: "author"
          replacement: themeConfig.badge.author
        ,
          match: "author_uri"
          replacement: themeConfig.badge.author_uri
        ,
          match: "description"
          replacement: themeConfig.badge.description
        ,
          match: "version"
          replacement: themeConfig.badge.version
        ,
          match: "license"
          replacement: themeConfig.badge.license
        ,
          match: "license_uri"
          replacement: themeConfig.badge.license_uri
        ,
          match: "tags"
          replacement: themeConfig.badge.tags
        ,
          match: "text_domain"
          replacement: themeConfig.badge.text_domain
        ,
          match: 'timestamp'
          replacement: '<%= grunt.template.today() %>'
        ,
        ]
      badge:
        files: [
          expand: true
          flatten: true
          cwd: config.devDir
          src: ["style.css"]
          dest: config.devDir
        ]

    # browser open
    open:
      server:
        path: wordpressUrl
#        app: 'Google Chrome Canary'

  init = ->
    themaPath = require("path").resolve config.wp.themeDir
    console.log "Create SymbolicLink => " + themaPath
    process.on 'exit', ->
      console.log "Delete SymbolicLink => " + themaPath
      exec = require('child_process').exec
      exec "grunt clean:theme", ->
        process.exit()

  # task configure
  grunt.registerTask "default", ->
    grunt.task.run ["coffee:grunt", "clean", "sync:dev", "compile", "symlink:dev", "replace:badge", "open", "watch"]
    init()

  grunt.registerTask "serv", ->
    grunt.task.run ["external_daemon:php", "default"]
    init()

  grunt.registerTask "build", ["clean", "sync:dev", "compile", "replace:badge", "sync:dist"]

  grunt.registerTask "compile", ["coffee:dev","typescript:dev", "sass:dev", "less:dev", "stylus:dev"]
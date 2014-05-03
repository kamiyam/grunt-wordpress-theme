"use strict"

themeName = "grunt-theme"
# configurable paths
config =
  LIVERELOAD_PORT: 35729
  listen: 3002  ## if use apache ... proxy setting
  server:
    port: 3000
    domain: "localhost"
    ini: "/usr/local/etc/php/5.4/php.ini"   # -c option ini file path ex) /usr/local/etc/php/5.4/php.ini
    root: "../../"   # -t option docment root file path ex)/htdocs
  wp:
    themeDir: "../themes/" + themeName
  srcDir: "app"
  tempDir: ".tmp"
  distDir: "dist"

proxySnippet = require('grunt-connect-proxy/lib/utils').proxyRequest

folderMount = (connect, base) ->
  require("path").resolve base
  # Serve static files.
  connect.static ( require("path").resolve base )


## server strat command
phpOption = do->
  options = [];

  options.push("-S")
  options.push(config.server.domain + ":"+ config.server.port + "")
  if config.server.ini
    options.push("-c")
    options.push(config.server.ini)
  if config.server.root
    options.push("-t")
    options.push(config.server.root)

  return options


module.exports = (grunt) ->

  # Load grunt tasks automatically
  require('load-grunt-tasks')(grunt)

  # Time how long tasks take. Can help when optimizing build times
#  require('time-grunt')(grunt)

  # Project configuration.
  grunt.initConfig

    symlink:
      dev:
        target: require("path").resolve config.tempDir
        link: config.wp.themeDir
  #       options:
  #         overwrite: true
  #         force: true

        dist:
          target: require("path").resolve config.distDir
          link: config.wp.themeDir

    external_daemon:
      php:
        cmd: "php"
        args: phpOption
        options:
          verbose: true

    throttle:
      default:
        remote_host: 'localhost'
        remote_port: 3000
        local_port: 3001
        upstream: 10 * 1024 # 10KB/s
        downstream: 100 * 1024 # 100KB/s


    connect:
      options:
        livereload: config.LIVERELOAD_PORT
        port: config.listen
        hostname: "localhost"

      front:
        options:
          debug: true
          base: [".",config.wp.themeDir]
          middleware: (connect, options) ->
            return [proxySnippet]

      proxies: [
        context: "/"
        host: "localhost"
        port: config.server.port
        https: false
        changeOrigin: false
        xforward: false
      ]

    ## Set compile settings
    sass:
      dev:
        files: [
          expand: true
          cwd: config.srcDir + "/css/"
          src: ["**/*.sass","**/*.scss"]
          dest: config.tempDir + "/css/"
          ext: ".css"
        ]

    less:
      dev:
        files: [
          expand: true
          cwd: config.srcDir + "/css/"
          src: ["**/*.less"]
          dest: config.tempDir + "/css/"
          ext: ".css"
        ]

    stylus:
      dev:
        files: [
          expand: true
          cwd: config.srcDir + "/css/"
          src: ["**/*.styl"]
          dest: config.tempDir + "/css/"
          ext: ".css"
        ]

    coffee:
      grunt:
        files:
          ".Gruntfile.js": "Gruntfile.coffee"

      dev:
        files: [
          options:
            bare: true
          expand: true
          cwd: config.srcDir + "/js/"
          src: ['**/*.coffee']
          dest: config.tempDir + "/js/"
          ext: '.js'
        ]

    typescript:
      dev:
        files: [
          expand: true
          cwd: config.srcDir + "/js/"
          src: ['**/*.ts']
          dest: config.tempDir + "/js/"
          ext: '.js'
        ]

    # watch files settings
    watch:
      options:
        livereload: false

      sass:
        options:
          cwd: config.srcDir + "/css/"
        files: ["**/*.sass", "**/*.scss"]
        tasks: ["sass:dev"]

      less:
        options:
          cwd: config.srcDir + "/css/"
        files: ["**/*.less"]
        tasks: ["less:dev"]

      stylus:
        options:
          cwd: config.srcDir + "/css/"
        files: ["**/*.styl"]
        tasks: ["stylus:dev"]

      coffee:
        options:
          cwd: config.srcDir + "/js/"
        files: ["**/*.coffee"]
        tasks: ["coffee:dev"]

      typescript:
        options:
          cwd: config.srcDir + "/js/"
        files: ["**/*.ts"]
        tasks: ["typescript:dev"]

      plain:
        options:
          cwd: config.srcDir + "/"
          livereload: false
        files: ["**/*.php", "**/*.css", "**/*.js"]
        tasks: ["sync:dev"]

      compiled:
        options:
          cwd: config.tempDir + "/"
          livereload: true
        files: ["css/**/*.css", "**/*.php",  "**/*.js"]

    clean:
      link:
        src: config.wp.themeDir
        force: true
      grunt:
        src: ".Gruntfile.js"
      dev:
        src: [config.tempDir + "/**"]
      dist:
        src: [config.distDir + "/**"]

    copy:
      dev:
        files:[
          {
            expand: true
            cwd: config.srcDir
            src: ["**","!**/*.{coffee,ts,sass,scss,less,styl}"]
            dest: config.tempDir
          }
        ]
      dist:
        files:[
          {
            expand: true
            cwd: config.srcDir
            src: ["**","!**/*.{coffee,ts,sass,scss,less,styl}"]
            dest: config.distDir
          },
          {
          expand: true,
          cwd: config.srcDir
          src: ["**"],
          dest: config.distDir
          }
        ]

    sync:
      dev:
        files: [
          cwd: config.srcDir
          src: ["**","!**/*.{coffee,ts,sass,scss,less,styl}"]
          dest: config.tempDir
        ],
        verbose: true

    # browser open
    open:
      server:
        path: "http://localhost:" + config.server.port
        app: 'Google Chrome Canary'


  # task configure
  grunt.registerTask "default", ->
    grunt.task.run ["serv"];

  grunt.registerTask "serv", ->
    grunt.task.run ["external_daemon:php", "coffee:grunt", "clean", "sync:dev", "compile", "symlink:dev", "configureProxies", "connect:front", "open", "watch"]

  grunt.registerTask "build", ["clean", "compile", "copy:dist"]

  grunt.registerTask "compile", ["coffee:dev","typescript:dev", "sass:dev", "less:dev", "stylus:dev"]
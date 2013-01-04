#! Grunt configuration for this project.
#!

module.exports = (grunt) ->

  # Underscore
  # ==========
  _ = grunt.util._

  # Package
  # =======
  pkg = require './package.json'

  # Configuration
  # =============
  configuration = _(grunt.file.readYAML('./config.yml')).defaults
    server:
      host: null
      port: 80
      path: ''

  server = configuration.server
  configuration.address  = if server.host then "//#{server.host}" else ''
  configuration.address += if server.host then ":#{server.port}" else ''

  # Grunt
  # =====
  grunt.initConfig

    # Clean
    # -----
    clean:
      build: ['build']
      temp: ['temp']

    # Copy
    # ----
    copy:
      scripts:
        options: cwd: 'src/scripts'
        files: 'temp/scripts/': ['**/*']

      templates:
        options: cwd: 'src/templates'
        files: 'temp/templates/': ['**/*']

      static:
        options: cwd: 'src'
        files: 'temp/': ['**/*', '!**/*.{coffee,scss,haml}']

      build:
        options: {cwd: 'temp', excludeEmpty: true}
        files:
          # Any files in root; index, robots, etc.
          # Any built style files.
          'build/': ['*', 'styles/**/*.css', 'media/**/*']

          # Modernizer is loaded before we boot into require; so it is outside
          # of the mega-js file.
          'build/components/modernizr/modernizr.js':
            'components/modernizr/modernizr.js'

    # Template
    # --------
    template:
      options:
        context:
          pkg: pkg
          config: configuration

      scripts:
        files: grunt.file.expandMapping ['**/*.coffee', '!vendor/**'], 'te/scripts/'
          cwd: 'src/scripts/'

      templates:
        files: grunt.file.expandMapping '**/*.haml', 'temp/templates/'
          cwd: 'src/templates/'

    # CoffeeScript
    # ------------
    coffee:
      compile:
        options: bare: true
        files: grunt.file.expandMapping '**/*.coffee', 'temp/scripts/'
          cwd: 'src/scripts/'
          rename: (base, path) -> base + path.replace /\.coffee$/, '.js'

    # Compass
    # -------
    compass:
      options:
        sassDir: 'src/styles'
        imagesDir: 'src/media/images'
        cssDir: 'temp/styles'
        javascriptsDir: 'temp/scripts'
        force: true
        relativeAssets: true

      compile:
        options:
          outputStyle: 'expanded'
          environment: 'development'

      build:
        options:
          outputStyle: 'compressed'
          environment: 'production'

    # Haml
    # ----
    haml:
      options:
        language: 'coffee'
        uglify: true
        customHtmlEscape: 'haml.escape'
        customPreserve: 'haml.preserve'
        customCleanValue: 'haml.clean'
        dependencies:
          'haml': 'lib/haml'

      compile:
        options: target: 'js'
        files: grunt.file.expandMapping '**/*.haml', 'temp/templates/'
          cwd: 'src/templates/'
          rename: (base, path) -> base + path.replace /\.haml$/, '.js'

      index:
        options: context: lazyload: true
        files: 'temp/index.html': 'src/index.haml'

      build:
        options: context: lazyload: false
        files: 'temp/index.html': 'src/index.haml'

    # Filesize
    # --------
    filesize:
      build: files: 'build/**/*'

    # Watch
    # -----
    watch:
      coffee:
        files: 'src/scripts/**/*.coffee'
        tasks: ['copy:scripts', 'coffee:compile']

      haml:
        files: 'src/templates/**/*.haml'
        tasks: ['copy:templates', 'haml:compile']

      index:
        files: 'src/index.haml'
        tasks: 'haml:index'

      compass:
        files: 'src/styles/**/*.scss'
        tasks: 'compass:compile'

    # Require.js
    # ----------
    requirejs:
      compile:
        options:
          out: 'build/scripts/main.js'
          include: _(grunt.file.expandMapping(['main*', 'controllers/**/*'], ''
            cwd: 'src/scripts/'
            rename: (base, path) ->
              path.replace /\.coffee$/, ''
          )).keys()
          mainConfigFile: 'temp/scripts/main.js'
          baseUrl: './temp/scripts'
          keepBuildDir: true
          almond: true
          insertRequire: ['main']
          optimize: 'uglify'
          inlineText: false

    # Webserver
    # ---------
    connect:
      base: 'temp'
      hostname: 'localhost'
      port: 3501

    # Lint
    # ----
    coffeelint:
      src: ['src/**/*.coffee']

  # Dependencies
  # ============
  packageInfo = require './package.json'
  for listing in ['dependencies', 'devDependencies']
    for name, version of packageInfo[listing]
      if name.substring(0, 6) is 'grunt-'
        grunt.loadNpmTasks name

  # Custom
  # ======

  # Template
  # --------
  # grunt.registerMultiTask 'template', 'Render underscore templates', ->
  #   eco = require 'eco'

  #   # Compile each file; concatenating them into the source if desired.
  #   output = for filename in @file.src
  #     eco.render grunt.file.read(filename), @options().context

  #   # If we managed to get anything; let the world know.
  #   if output.length > 0
  #     grunt.file.write @file.dest, output.join('\n') || ''
  #     grunt.log.writeln "File #{@file.dest.cyan} created."

  # Tasks
  # =====

  # Lint
  # ----
  grunt.registerTask 'lint', [
    'coffeelint'
  ]

  # Default
  # -------
  grunt.registerTask 'default', [
    'clean:temp'
    'copy:static'
    'copy:scripts'
    # 'copy:templates'
    # 'template'
    'coffee:compile'
    'haml:compile'
    'haml:index'
    'compass:compile'
    'connect'
    'wisdom'
    'watch'
  ]

  # Build
  # -----
  grunt.registerTask 'build', [
    'clean'
    'copy:static'
    'copy:scripts'
    'copy:templates'
    # 'template'
    'coffee:compile'
    'compass:build'
    'haml:compile'
    'haml:build'
    'requirejs:compile'
    'copy:build'
    'filesize:build'
    'wisdom'
  ]

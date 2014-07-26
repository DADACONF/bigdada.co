module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      },
      prod: {
        src: 'app/assets/javascripts/main.js',
        dest: 'build/js/main.min.js',
        compress: true
      },
      dev: {
        src: 'app/assets/javascripts/main.js',
        dest: 'build/js/main.js',
        beautify: true
      }
    },
    less: {
      dev: {
        options: {
          paths: ["app/assets/stylesheets"]
        },
        files: {
          "build/stylesheets/main.css" : "app/assets/stylesheets/main.less"
        }
      },
      prod: {
        options: {
          paths: ["app/assets/stylesheets"]
        },
        files: {
          "build/stylesheets/main.min.css" : "app/assets/stylesheets/main.less"
        },
        compress: true, 
        cleancss: true,
        strictimports: true,
      }
    },
    copy: {
      dev: {
        files: [
          {expand: true, src: "app/views/**", dest: "build/", flatten: true, filter: "isFile"},
          {expand: true, src: "bower_components/bootstrap/dist/css/bootstrap.min.css", dest: "build/stylesheets/", flatten: true},
          {expand: true, src: "bower_components/bootstrap/dist/js/bootstrap.min.js", dest: "build/js/", flatten: true},
          {expand: true, src: "bower_components/jquery/dist/jquery.min.js", dest: "build/js/", flatten: true}
        ]
      },
      prod: {
        files: [
        {exxpand: true, src: "bower_components/bootstrap/dist/css/bootstrap.min.css", dest: "build/stylesheets/", flatten: true},
        {expand: true, src: "bower_components/bootstrap/dist/js/bootstrap.min.js", dest: "build/js/", flatten: true},
        {expand: true, src: "bower_components/jquery/dist/jquery.min.js", dest: "build/js/", flatten: true}]
        // files: [{expand: true, src: "app/views/**", dest: "build/", flatten: true, filter: "isFile"}]
      }
    }, 
    replace: {
      dev: {},
      prod: {
        src: ["apps/views/index.html"],
        dest:["build/"],
        replacements: [
          { from: "main.js",
            to: "main.min.js"},
          { from: "main.css",
            to: "main.min.css"
          }
        ]
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-text-replace');
  grunt.loadNpmTasks('grunt-s3');

  // Default task(s).
  grunt.registerTask('default', 'Building a production build', 
    ['uglify:prod', 
     'less:prod', 
     'copy:prod']);
  grunt.registerTask('dev', 'Generating a development build', 
    ['uglify:dev', 
     'less:dev',
     'copy:dev']);

};
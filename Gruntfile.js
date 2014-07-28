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
        {expand: true, src: "bower_components/bootstrap/dist/css/bootstrap.min.css", dest: "build/stylesheets/", flatten: true},
        {expand: true, src: "bower_components/bootstrap/dist/js/bootstrap.min.js", dest: "build/js/", flatten: true},
        {expand: true, src: "bower_components/jquery/dist/jquery.min.js", dest: "build/js/", flatten: true},
        {expand: true, src: "app/views/**", dest: "build/", flatten: true, filter: "isFile"}]
      }
    }, 
    replace: {
      prod: {
        src: ["build/index.html"],
        overwrite: true,
        replacements: [
          { from: "js/main.js",
            to: "js/main.min.js"},
          { from: "stylesheets/main.css",
            to: "stylesheets/main.min.css"
          }
        ]
      }
    },
    clean: ["build/"],
    aws: grunt.file.readJSON('grunt-aws.json'),
    s3: {
      options: {
        key: '<%= aws.key %>',
        secret: '<%= aws.secret %>',
        bucket: '<%= aws.bucket %>',
        access: 'private'
      },
      prod: {
        upload: [
          {
            src: 'build/*',
            dest: ''
          },
          {
            src: 'build/js/*',
            dest: 'js/'
          },
          {
            src: 'build/stylesheets/*',
            dest: 'stylesheets/'
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
  grunt.loadNpmTasks('grunt-contrib-clean');
  // Default task(s).
  grunt.registerTask('default', 'Building a production build', 
    ['clean',
     'uglify:prod', 
     'less:prod', 
     'copy:prod', 
     'replace:prod']);

  grunt.registerTask('dev', 'Generating a development build', 
    ['clean',
     'uglify:dev', 
     'less:dev',
     'copy:dev']);

  grunt.registerTask('deploy', 'Uploading to S3',
    ['default',
     's3:prod']);
};
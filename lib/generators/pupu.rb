module Merb
  module Generators
    class PupuGenerator < AppGenerator
      #
      # ==== Paths
      #

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates', 'application', 'pupu')
      end

      def self.common_templates_dir
        File.expand_path(File.join(File.dirname(__FILE__), 'templates', 'application', 'common'))
      end

      def destination_root
        File.join(@destination_root, base_name)
      end

      def common_templates_dir
        self.class.common_templates_dir
      end
      
      #
      # ==== Generator options
      #

      desc <<-DESC
      This generates a pupu, merb media plugin.
      DESC

      first_argument :name, :required => true, :desc => "Pupu name"
      # TODO
      second_argument :files, :as => :array, :default => nil, :desc => "Extra files. Example: foo.js foo.css"

      option :js_framework, :default => :mootools, :desc => "Use given JS framework for new pupu. Choices: mootools, jquery, prototype."

      #
      # ==== Common directories & files
      #

      empty_directory :images, 'images'

      file :gitignore do |file|
        file.source = File.join(common_templates_dir, 'dotgitignore')
        file.destination = ".gitignore"
      end

      file :changelog do |file|
        file.source = File.join(source_root, "CHANGELOG")
        file.destination = "CHANGELOG"
      end

      file :rakefile do |file|
        file.source = File.join(source_root, "Rakefile")
        file.destination = "Rakefile"
      end

      file :todo do |file|
        file.source = File.join(source_root, "TODO")
        file.destination = "TODO"
      end

      template :config do |template|
        template.source = File.join(common_templates_dir, "config.rb")
        template.destination = "config.rb"
      end

      template :license do |template|
        template.source = File.join(common_templates_dir, "LICENSE")
        template.destination = "LICENSE"
      end

      template :readme do |template|
        template.source = File.join(common_templates_dir, "README.textile")
        template.destination = "README.textile"
      end

      template :js_init_file do |template|
        template.source = File.join(source_root, "initializer.js")
        template.destination = "initializers/#{name}.js"
      end

      template :css_init_file do |template|
        template.source = File.join(source_root, "initializer.css")
        template.destination = "initializers/#{name}.css"
      end

      template :javascript do |template|
        template.source = File.join(source_root, "javascript.js")
        template.destination = "javascripts/#{name}.js"
      end

      template :stylesheet do |template|
        template.source = File.join(source_root, "stylesheet.css")
        template.destination = "stylesheets/#{name}.css"
      end


      def after_generation
        STDOUT.puts "\nDon't forget to add 'pupu :#{name}' to your layout."
      end
    end
    add 'pupu', PupuGenerator
  end
end

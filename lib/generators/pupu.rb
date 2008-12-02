module Merb
  module Generators
    class PupuGenerator < AppGenerator
      #
      # ==== Paths
      #

      def self.source_root
        File.join(super, 'application', 'pupu')
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

      #option :template_engine, :default => :haml,
      #:desc => 'Template engine to prefer for this application (one of: erb, haml).'

      #desc <<-DESC
      #This generates a "prepackaged" (or "opinionated") Merb application that uses ActiveRecord,
      #TestUnit, helpers, assets, mailer, caching, slices and merb-auth all out of the box.
    #DESC

      first_argument :name, :required => true, :desc => "Pupu name"

      #
      # ==== Common directories & files
      #

      empty_directory :images, 'images'
      empty_directory :javascripts, 'javascripts'
      empty_directory :stylesheets, 'stylesheets'

      file :gitignore do |file|
        file.source = File.join(common_templates_dir, 'dotgitignore')
        file.destination = ".gitignore"
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

      #
      # ==== Layout specific things
      #

      # empty array means all files are considered to be just
      # files, not templates
      glob! "app"
      glob! "autotest"
      glob! "config"
      glob! "doc",      []
      glob! "public"
      glob! "lib"
      glob! "merb"

      invoke :layout do |generator|
        generator.new(destination_root, options, 'application')
      end
    end

    add 'pupu', PupuGenerator
  end
end

require "ostruct"
require "media-path"

class Hash
  def to_html_attrs
    self.map { |key, value| "#{key}='#{value}'" }.join(" ")
  end
end

module Pupu
  class DSL
    attr_reader :output, :files, :path
    def initialize(pupu)
      @pupu = pupu
      @output = Array.new
      @files  = Array.new
      @dependencies = Array.new
      @path = pupu.file("config.rb")
    end

    def evaluate
      content = File.read(self.path.to_s)
      self.instance_eval(content)
    rescue Exception => exception
      abort "Exception during parsing #{self.path} in #{pupu.inspect}:\n#{exception.inspect}\n#{exception.backtrace.join("\n")}"
    end

    def output
      @output.join("\n")
    end

    def dependency(pupu, params = Hash.new)
      struct = OpenStruct.new
      struct.name = pupu
      struct.params = params
      @dependencies.push(struct)
    end

    def dependencies(*pupus)
      pupus.each do |pupu|
        self.dependency(pupu)
      end
    end

    def get_dependencies
      @dependencies
    end

    def javascript(basename, params = Hash.new)
      path = @pupu.javascript(basename).url
      tag  = "<script src='#{path}' type='text/javascript'></script>"
      @files.push(path)
      @output.push(tag)
    end

    def stylesheet(basename, params = Hash.new)
      path = @pupu.stylesheet(basename).url
      default = {media: 'screen', rel: 'stylesheet', type: 'text/css'}
      params = default.merge(params)
      tag  = "<link href='#{path}' #{params.to_html_attrs} />"
      @files.push(path)
      @output.push(tag)
    end

    def javascripts(*names)
      names.each do |name|
        self.javascript(name)
      end
    end

    def stylesheets(*names)
      names.each do |name|
        self.stylesheet(name)
      end
    end

    # parameter :type, :optional => ["local", "request"] do |type|
    #   javascript "autocompleter.#{type}"
    # end

    # parameter :more do |boolean|
    #  javascript "mootools-1.2-more" if boolean
    # end
    def parameter(name, params = Hash.new, &block)
      # pupu :autocompleter, :type => "request"
      # @pupu.params: { :type => "request" }

      # pupu :mootools, :more => true
      # @pupu.params: { :more => true }
      if @pupu.params.key?(name)
        block.call(@pupu.params[name])
      end
    end
  end
end

# css_include_tag "blueprint/screen", "blueprint/plugins/fancy-type/screen", :media => "screen, projection"
# css_include_tag "blueprint/print", :media => "print"
# / [if IE]
#   = css_include_tag "blueprint/ie", :media => "screen, projection"

# TODO
# :if => "ie"
stylesheet "screen", :media => "screen, projection"
stylesheet "print", :media => "print"
stylesheet "ie"

# parameters of plugin
# it will be blank in most cases
parameter :plugins do |plugins|
  plugins.each do |plugin|
    stylesheet "plugins/#{plugin}/screen", :media => "screen, projection"
  end
end
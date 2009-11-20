# dependencies of the pupu
dependency :mootools

# javascripts for loading
javascripts "ratings", "ie6-png-fix"

# parameters of plugin
# it will be blank in most cases
parameter :style, :optional => ["star", "heart"] do |type|
  # TODO
  #stylesheet "lib/autocompleter.#{type}"
end

# you can put there message which will be displayed after installation
#message "foo"

# encoding: utf-8

# autocompleter depends on mootools
dependencies :mootools

# javascripts for loading
javascripts "observer", "autocompleter"

# stylesheet
stylesheet "autocompleter"

parameter :type, optional: ["local", "request"] do |type|
  javascript "autocompleter.#{type}"
end

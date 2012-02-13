require 'yaml'

if ::YAML.const_defined?(:ENGINE)
  ::YAML::ENGINE.yamler = 'syck'
end

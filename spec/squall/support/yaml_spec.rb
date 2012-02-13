require 'spec_helper'

describe "YAML::ENGINE.yamler", :if => YAML.const_defined?(:ENGINE) && !(RUBY_PLATFORM == "java" && RUBY_VERSION == "1.9.2") do
  it { YAML::ENGINE.yamler.should == 'syck' }
end

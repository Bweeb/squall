require 'spec_helper'

describe "YAML::ENGINE.yamler", :if => YAML.const_defined?(:ENGINE) do
  it { YAML::ENGINE.yamler.should == 'syck' }
end

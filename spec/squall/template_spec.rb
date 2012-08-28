require 'spec_helper'

describe Squall::Template do
  before(:each) do
    @template = Squall::Template.new
    @keys = ["label", "operating_system_distro", "operating_system_arch", "created_at",
      "operating_system_tail", "operating_system", "updated_at", "operating_system_edition",
      "allowed_swap", "allow_resize_without_reboot", "virtualization", "id", "file_name",
      "checksum", "version", "user_id", "template_size", "allowed_hot_migrate", "min_disk_size", "state"]
  end

  describe "#list" do
    use_vcr_cassette 'template/list'

    it "returns a list" do
      list = @template.list
      list.size.should be(22)

      first = list.first
      first.keys.should include(*@keys)
      first['label'].should == 'CentOS 5.5 x64'
    end
  end

  describe "#make_public" do
    use_vcr_cassette 'template/make_public'

    it "makes the template public" do
      pub = @template.make_public(1)
      @template.success.should be_true
      pub.keys.should include(*@keys)
    end
  end
end

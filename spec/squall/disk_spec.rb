require 'spec_helper'

describe Squall::Disk do
  before(:each) do
    @disk = Squall::Disk.new
    @valid = { data_store_id: 1, disk_size: 2, is_swap: 0,
               mount_point: '/disk2', add_to_linux_fstab: 0,
               require_format_disk: 1 }
  end

  describe "#list" do
    use_vcr_cassette "disk/list"

    it "returns all disk" do
      disks = @disk.list
      disks.should be_an(Array)
    end

    it "contains the disk data" do
      disks = @disk.list
      disks.all? { |w| w.is_a?(Hash) }.should be_true
    end

    it "contains correct disk data" do
      disks = @disk.list
      disks.all? { |w| !w['disk_vm_number'].nil? }.should be_true
    end
  end

  describe "#vm_disk_list" do
    use_vcr_cassette "disk/vm_disk_list"

    it "returns all VM disk" do
      disks = @disk.vm_disk_list(58)
      disks.should be_an(Array)
    end

    it "contains the disk data" do
      disks = @disk.vm_disk_list(58)
      disks.all? { |w| w.is_a?(Hash) }.should be_true
    end

    it "contains correct disk data" do
      disks = @disk.vm_disk_list(58)
      disks.all? { |w| !w['disk_vm_number'].nil? }.should be_true
    end
  end

  describe "#create" do
    use_vcr_cassette "disk/create"

    it "creates a disk" do
      @disk.create(58, @valid)
      @disk.success.should be_true
    end
  end

  describe "#edit" do
    use_vcr_cassette "disk/edit"

    it "accepts valid params" do
      @disk.edit(78, disk_size: 3)
      @disk.success.should be_true
    end
  end


  describe "#migrate" do
    use_vcr_cassette "disk/migrate"

    it "should return association error" do
      migrate = @disk.migrate(58, 78, data_store_id: 2)
      @disk.success.should be_false
      migrate['errors'].should include("Data store cannot be associated with this virtual machine.")
    end
  end

  describe "#iops_usage" do
    use_vcr_cassette "disk/iops_usage"

    it "returns a disk IOPS usage" do
      usage = @disk.iops_usage(77)
      usage.should be_a(Array)
      usage.all? { |w| w.is_a?(Hash) }.should be_true
      usage.all? { |w| !w['stat_time'].nil? }.should be_true
    end
  end

  describe "#build" do
    use_vcr_cassette "disk/build"

    it "builds a disk" do
      @disk.build(78)
      @disk.success.should be_true
    end

    it "returns disk info" do
      build = @disk.build(78)
      build.should be_a(Hash)
      build['id'].should eq 78
    end
  end

  describe "#unlock" do
    use_vcr_cassette "disk/unlock"

    it "unlocks a disk" do
      @disk.unlock(78)
      @disk.success.should be_true
    end

    it "returns disk info" do
      unlock = @disk.unlock(78)
      unlock.should be_a(Hash)
      unlock['id'].should eq 78
    end
  end

  describe "#auto_backup_on" do
    use_vcr_cassette "disk/auto_backup_on"

    it "enable auto_backup for disk" do
      @disk.auto_backup_on(78)
      @disk.success.should be_true
    end

    it "returns disk info" do
      backup = @disk.auto_backup_on(78)
      backup.should be_a(Hash)
      backup['id'].should eq 78
    end
  end

  describe "#auto_backup_off" do
    use_vcr_cassette "disk/auto_backup_off"

    it "disable auto_backup for disk" do
      @disk.auto_backup_off(78)
      @disk.success.should be_true
    end

    it "returns disk info" do
      backup = @disk.auto_backup_off(78)
      backup.should be_a(Hash)
      backup['id'].should eq 78
    end
  end

  describe "#schedules" do
    use_vcr_cassette "disk/schedules"

    it "returns schedules for a disk" do
      schedules = @disk.schedules(78)
      schedules.should be_a(Array)
      schedules.all? { |w| !w['target_id'].nil? }.should be_true
    end
  end

  describe "#add_schedule" do
    use_vcr_cassette "disk/add_schedule"

    it "adds schedule for a disk" do
      disk = @disk.add_schedule(78, action: 'autobackup', duration: 1, period: 'days')
      @disk.success.should be_true
      disk.should be_a(Array)
    end
  end

  describe "#backups" do
    use_vcr_cassette "disk/backups"

    it "lists backups for a disk" do
      backups = @disk.backups(78)
      @disk.success.should be_true
      backups.should be_a(Array)
      backups.all? { |w| !w['disk_id'].nil? }.should be_true
    end
  end

  describe "#delete" do
    use_vcr_cassette "disk/delete"

    it "deletes a disk" do
      @disk.delete(78)
      @disk.success.should be_true
    end
  end

end

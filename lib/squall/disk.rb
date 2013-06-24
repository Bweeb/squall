module Squall
  # OnApp Disk
  class Disk < Base

    # Returns a list of disks
    def list
      response = request(:get, "/settings/disks.json")
      response.collect { |i| i['disk'] }
    end

    # Get the list of disks available for a particular VM
    #
    # ==== Params
    #
    # * +id+ - ID of the virtual machine
    def vm_disk_list(id)
      response = request(:get, "/virtual_machines/#{id}/disks.json")
      response.collect { |i| i['disk'] }
    end

    # Creates a new Disk
    #
    # ==== Params
    #
    # * +id+ - ID of the virtual machine
    # * +options+ - Params for the disk
    #
    # ==== Options
    #
    # * +data_store_id*+ - The ID of a data store where this disk is located
    # * +disk_size*+ - The disk space in GB
    # * +is_swap+ - Set true if this is a swap disk
    # * +mount_point+ - a physical location in the partition used as a root filesystem
    # * +add_to_linux_fstab+ - Set true to add
    # * +require_format_disk+ – set true to format disk
    #
    # ==== Example
    #
    # params = {
    #   :data_store_id => 1,
    #   :disk_size => 10,
    #   :is_swap => 0,
    #   :mount_point => '/disk2',
    #   :add_to_linux_fstab => 1,
    #   :require_format_disk => 1
    # }
    #
    #
    def create(id, options = {})
      request(:post, "/virtual_machines/#{id}/disks.json", default_params(options))
    end

    # Updates an existing disk
    #
    # ==== Params
    #
    # * +id+ - ID of the disk
    # * +options+ - Params for the disk
    #
    # ==== Options
    #
    # * +disk_size*+ - The disk space in GB
    def edit(id, options = {})
      request(:put, "/settings/disks/#{id}.json", default_params(options))
    end

    # Migrates a VM disk to another data store
    #
    # ==== Params
    #
    # * +vm_id+ - ID of the virtual machine
    # * +id+ - ID of the disk
    # * +options+ - Params for the disk
    #
    # ==== Options
    #
    # * +data_store_id*+ - The disk space in GB
    def migrate(vm_id, id, options = {})
      request(:post, "/virtual_machines/#{vm_id}/disks/#{id}/migrate.json", default_params(options))
    end

    # View Input/Output statistics for disk
    #
    # ==== Params
    #
    # * +id+ - ID of the disk
    def iops_usage(id)
      response = request(:get, "/settings/disks/#{id}/usage.json")
      response.collect { |i| i['disk_hourly_stat'] }
    end

    # Builds disk
    #
    # ==== Params
    #
    # * +id+ - ID of the disk
    def build(id)
      response = request(:post, "/settings/disks/#{id}/build.json")
      response['disk']
    end

    # Unlock disk
    #
    # ==== Params
    #
    # * +id+ - ID of the disk
    def unlock(id)
      response = request(:post, "/settings/disks/#{id}/unlock.json")
      response['disk']
    end

    # Enable autobackups for a disk
    #
    # ==== Params
    #
    # * +id+ - ID of the disk
    def auto_backup_on(id)
      response = request(:post, "/settings/disks/#{id}/autobackup_enable.json")
      response['disk']
    end

    # Disable autobackups for a disk
    #
    # ==== Params
    #
    # * +id+ - ID of the disk
    def auto_backup_off(id)
      response = request(:post, "/settings/disks/#{id}/autobackup_disable.json")
      response['disk']
    end

    # Get the list of schedules for a disk
    #
    # ==== Params
    #
    # * +id+ - ID of the disk
    def schedules(id)
      response = request(:get, "/settings/disks/#{id}/schedules.json")
      response.collect { |i| i['schedule'] }
    end

    # Add autobackup schedule to a disk
    #
    # ==== Params
    #
    # * +id+ - ID of the disk
    # * +options+ - Params for the disk
    #
    # ==== Options
    #
    # * +action*+ - set Autobackup to add a backup schedule
    # * +duration*+ - specify duration
    # * +period*+ - set the period (days|weeks|months|years)
    #
    # ==== Example
    #
    # params = {
    #   :action => 'autobackup',
    #   :duration => 10,
    #   :period => days
    # }
    #
    def add_schedule(id, options = {})
      request(:post, "/settings/disks/#{id}/schedules.json", default_params(options))
    end


    # Get the list of backups available for a disk
    #
    # ==== Params
    #
    # * +id+ - ID of the disk
    def backups(id)
      response = request(:get, "/settings/disks/#{id}/backups.json")
      response.collect { |i| i['backup'] }
    end

    # Delete a disk
    #
    # ==== Params
    #
    # * +id+ - ID of the disk
    def delete(id)
      request(:delete, "/settings/disks/#{id}.json")
    end
  end
end

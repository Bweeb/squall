module Squall
  # OnApp Disk
  class Disk < Base
    # Public: List all disks.
    #
    # Returns an Array.
    def list
      response = request(:get, "/settings/disks.json")
      response.collect { |i| i['disk'] }
    end

    # Public: List all disks available for a particular VM.
    #
    # id - ID of the virtual machine
    #
    # Returns an Array.
    def vm_disk_list(id)
      response = request(:get, "/virtual_machines/#{id}/disks.json")
      response.collect { |i| i['disk'] }
    end

    # Public: Creates a new Disk.
    #
    # id      - ID of the virtual machine
    # options - Params for the disk:
    #           :add_to_linux_fstab  - Set true to add
    #           :data_store_id       - The ID of a data store where this disk is
    #                                  located
    #           :disk_size           - The disk space in GB
    #           :is_swap             - Set true if this is a swap disk
    #           :mount_point         - a physical location in the partition used
    #                                  as a root filesystem
    #           :require_format_disk – set true to format disk
    #
    # Example
    #
    #     create(
    #       add_to_linux_fstab:  1,
    #       data_store_id:       1,
    #       disk_size:           10,
    #       is_swap:             0,
    #       mount_point:         '/disk2',
    #       require_format_disk: 1
    #     )
    #
    # Returns a Hash.
    def create(id, options = {})
      request(:post, "/virtual_machines/#{id}/disks.json", default_params(options))
    end

    # Public: Updates an existing disk.
    #
    # id      - ID of the disk
    # options - Params for the disk
    #           :disk_size - The disk space in GB
    #
    # Returns a Hash.
    def edit(id, options = {})
      request(:put, "/settings/disks/#{id}.json", default_params(options))
    end

    # Public: Migrates a VM disk to another data store.
    #
    # vm_id   - ID of the virtual machine
    # id      - ID of the disk
    # options - Params for the disk
    #           :data_store_id - The disk space in GB
    #
    # Returns a Hash.
    def migrate(vm_id, id, options = {})
      request(:post, "/virtual_machines/#{vm_id}/disks/#{id}/migrate.json", default_params(options))
    end

    # Public: View Input/Output statistics for a disk.
    #
    # id - ID of the disk
    #
    # Returns an Array
    def iops_usage(id)
      response = request(:get, "/settings/disks/#{id}/usage.json")
      response.collect { |i| i['disk_hourly_stat'] }
    end

    # Public: Builds a disk.
    #
    # id - ID of the disk
    #
    # Returns a Hash.
    def build(id)
      response = request(:post, "/settings/disks/#{id}/build.json")
      response['disk']
    end

    # Public: Unlock a disk.
    #
    # id - ID of the disk
    #
    # Returns a Hash.
    def unlock(id)
      response = request(:post, "/settings/disks/#{id}/unlock.json")
      response['disk']
    end

    # Public: Enable autobackups for a disk.
    #
    # id - ID of the disk
    #
    # Returns a Hash.
    def auto_backup_on(id)
      response = request(:post, "/settings/disks/#{id}/autobackup_enable.json")
      response['disk']
    end

    # Public: Disable autobackups for a disk
    #
    # id - ID of the disk
    #
    # Returns a Hash.
    def auto_backup_off(id)
      response = request(:post, "/settings/disks/#{id}/autobackup_disable.json")
      response['disk']
    end

    # Public: Get the list of schedules for a disk.
    #
    # id - ID of the disk
    #
    # Returns an Array.
    def schedules(id)
      response = request(:get, "/settings/disks/#{id}/schedules.json")
      response.collect { |i| i['schedule'] }
    end

    # Public: Add autobackup schedule to a disk
    #
    # id      - ID of the disk
    # options - Params for the disk
    #           :action   - set Autobackup to add a backup schedule
    #           :duration - specify duration
    #           :period   - set the period (days|weeks|months|years)
    #
    # Example
    #
    #     params = {
    #       action:   'autobackup',
    #       duration: 10,
    #       period:   days
    #     }
    #
    # Returns an Array.
    def add_schedule(id, options = {})
      request(:post, "/settings/disks/#{id}/schedules.json", default_params(options))
    end

    # Public: List backups available for a disk.
    #
    # id - ID of the disk
    #
    # Returns an Array.
    def backups(id)
      response = request(:get, "/settings/disks/#{id}/backups.json")
      response.collect { |i| i['backup'] }
    end

    # Public: Delete a disk.
    #
    # id - ID of the disk
    #
    # Returns a Hash.
    def delete(id)
      request(:delete, "/settings/disks/#{id}.json")
    end
  end
end

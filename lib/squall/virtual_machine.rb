module Squall
  # OnApp VirtualMachine
  class VirtualMachine < Base
    # Return a list of virtual machines
    def list
      response = request(:get, '/virtual_machines.json')
      response.collect { |v| v['virtual_machine'] }
    end

    # Return a Hash for the given virtual machines
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    def show(id)
      response = request(:get, "/virtual_machines/#{id}.json")
      response.first[1]
    end

    # Create a new virtual machine
    #
    # ==== Params
    #
    # * +options+ - Params for creating the virtual machine
    #
    # ==== Options
    #
    # * +label*+ - Label for the virtual machine
    # * +hostname*+ - Hostname for the virtual machine
    # * +memory*+ - Amount of RAM assigned to this virtual machine
    # * +cpus*+ - Number of CPUs assigned to the virtual machine
    # * +cpu_shares*+ - CPU priority for this virtual machine
    # * +primary_disk_size*+ - Disk space for this virtual machine
    # * +template_id*+ - ID for a template from which the virtual machine will be built
    # * +hypervisor_id+ - ID for a hypervisor where virtual machine will be built.  If not provided the virtual machine will be assigned to the first available hypervisor
    # * +swap_disk_size+ - Swap space (does not apply to Windows virtual machines)
    # * +primary_network_id+ - ID of the primary network
    # * +required_automatic_backup+ - Set to '1' if automatic backups are required
    # * +rate_limit+ - Max port speed
    # * +required_ip_address_assignment+ - Set to '1' if you wish to assign an IP address automatically
    # * +required_virtual_machine_build+ - Set to '1' to build virtual machine automatically
    # * +admin_note+ - Comment that can only be set by admin of virtual machine
    # * +note+ - Comment that can be set by the user of the virtual machine
    # * +allowed_hot_migrate+ - Set to '1'  to allow hot migration
    # * +initial_root_password+ - Root password for the virtual machine.  6-31 characters consisting of letters, numbers, '-' and '_'
    # * hypervisor_group_id - the ID of the hypervisor zone in which the VM will be created. Optional: if no hypervisor zone is set, the VM will be built in any available hypervisor zone.

    #
    # ==== Example
    #
    #  params = {
    #    :label => 'testmachine',
    #    :hypervisor_id => 5,
    #    :hostname => 'testmachine',
    #    :memory => 512,
    #    :cpus => 1,
    #    :cpu_shares => 10,
    #    :primary_disk_size => 10,
    #    :template_id => 1
    #  }
    #
    #  create params
    def create(options = {})
      response = request(:post, '/virtual_machines.json', default_params(options))
      response['virtual_machine']
    end

    # Build a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    # * +options+ - Params for creating the virtual machine
    #
    # ==== Options
    #
    # * +template_id*+ - ID of the template to be used to build the virtual machine
    # * +required_startup+ - Set to '1' to startup virtual machine after building
    def build(id, options = {})
      response = request(:post, "/virtual_machines/#{id}/build.json", default_params(options))
      response.first[1]
    end

    # Edit a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    # * +options+ - Params for creating the virtual machine
    #
    # ==== Options
    #
    # See #create
    def edit(id, options = {})
      response = request(:put, "/virtual_machines/#{id}.json", default_params(options))
      response['virtual_machine']
    end

    # Change the owner of a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    # * +user_id*+ - ID of the target User
    def change_owner(id, user_id)
      response = request(:post, "/virtual_machines/#{id}/change_owner.json", query: { user_id: user_id })
      response['virtual_machine']
    end

    # Change the password
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    # * +password*+ - New password
    def change_password(id, password)
      response = request(:post, "/virtual_machines/#{id}/reset_password.json", query: { new_password: password })
      response['virtual_machine']
    end

    # Assigns SSH keys of all administrators and a owner to a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    def set_ssh_keys(id)
      response = request(:post, "/virtual_machines/#{id}/set_ssh_keys.json")
      response['virtual_machine']
    end

    # Migrate a virtual machine to a new hypervisor
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    # * +options+ - :destination, :cold_migrate_on_rollback
    #
    # ==== Options
    #
    # * +destination*+ - ID of a hypervisor to which to migrate the virtual machine
    # * +cold_migrate_on_rollback+ - Set to '1' to switch to cold migration if migration fails
    def migrate(id, options = {})
      request(:post, "/virtual_machines/#{id}/migrate.json", query: { virtual_machine: options } )
    end

    # Toggle the VIP status of the virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    def set_vip(id)
      response = request(:post, "/virtual_machines/#{id}/set_vip.json")
      response['virtual_machine']
    end

    # Delete a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    def delete(id)
      request(:delete, "/virtual_machines/#{id}.json")
    end

    # Resize a virtual machine's memory
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    # * +options+ - Options for resizing
    #
    # * ==== Options
    #
    # * +memory*+ - Amount of RAM assigned to this virtual machine
    # * +cpus*+ - Number of CPUs assigned to the virtual machine
    # * +cpu_shares*+ - CPU priority for this virtual machine
    # * +allow_cold_resize*+ - Set to '1' to allow cold resize
    def resize(id, options = {})
      response = request(:post, "/virtual_machines/#{id}/resize.json", default_params(options))
      response['virtual_machine']
    end

    # Suspend/Unsuspend a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    def suspend(id)
      response = request(:post, "/virtual_machines/#{id}/suspend.json")
      response['virtual_machine']
    end

    # Unlock a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    def unlock(id)
      response = request(:post, "/virtual_machines/#{id}/unlock.json")
      response['virtual_machine']
    end

    # Boot a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    def startup(id)
      response = request(:post, "/virtual_machines/#{id}/startup.json")
      response['virtual_machine']
    end

    # Shutdown a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    def shutdown(id)
      response = request(:post, "/virtual_machines/#{id}/shutdown.json")
      response['virtual_machine']
    end

    # Stop a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    def stop(id)
      response = request(:post, "/virtual_machines/#{id}/stop.json")
      response['virtual_machine']
    end

    # Reboot a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    # * +recovery+ - Set to true to reboot in recovery, defaults to false
    def reboot(id, recovery=false)
      response = request(:post, "/virtual_machines/#{id}/reboot.json", { query: recovery ? { mode: :recovery } : nil })
      response['virtual_machine']
    end

    # Segregate a virtual machine from another virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    # * +target_vm_id+* - ID of another virtual machine from which it should be segregated
    def segregate(id, target_vm_id)
      response = request(:post, "/virtual_machines/#{id}/strict_vm.json", default_params(strict_virtual_machine_id: target_vm_id))
      response['virtual_machine']
    end

    # Open a console for a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    def console(id)
      response = request(:post, "/virtual_machines/#{id}/console.json")
      response['virtual_machine']
    end

    # Get billing statistics for a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of the virtual machine
    def stats(id)
      response = request(:post, "/virtual_machines/#{id}/vm_stats.json")
      response['virtual_machine']
    end
  end
end

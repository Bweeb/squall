module Squall
  class VirtualMachine < Base
    def list
      response = request(:get, '/virtual_machines.json')
      response.collect { |v| v['virtual_machine'] }
    end

    def show(id)
      response = request(:get, "/virtual_machines/#{id}.json")
      response.first[1]
    end

    def create(options = {})
      required = [:label, :hypervisor_id, :hostname, :memory, :cpus, :cpu_shares, :primary_disk_size]
      optional = [:cpu_shares,
                  :swap_disk_size,
                  :primary_network_id,
                  :required_automatic_backup,
                  :rate_limit,
                  :required_ip_address_assignment,
                  :required_virtual_machine_build,
                  :admin_note,
                  :note,
                  :allowed_hot_migrate,
                  :template_id,
                  :initial_root_password
      ]
      params.required(required).accepts(optional).validate! options
      response = request(:post, '/virtual_machines.json', default_params(options))
      response['virtual_machine']
    end

    def build(id, options = {})
      params.accepts(:template_id, :required_startup).validate! options
      response = request(:post, "/virtual_machines/#{id}/build.json", default_params(options))
      response.first[1]
    end

    def edit(id, options = {})
      optional = [:label,
                  :hypervisor_id,
                  :hostname,
                  :memory,
                  :cpus,
                  :cpu_shares,
                  :primary_disk_size,
                  :cpu_shares,
                  :swap_disk_size,
                  :primary_network_id,
                  :required_automatic_backup,
                  :rate_limit,
                  :required_ip_address_assignment,
                  :required_virtual_machine_build,
                  :admin_note,
                  :note,
                  :allowed_hot_migrate,
                  :template_id,
                  :initial_root_password
      ]
      params.accepts(optional).validate! options
      request(:put, "/virtual_machines/#{id}.json", default_params(options))
    end

    def change_owner(id, user_id)
      response = request(:post, "/virtual_machines/#{id}/change_owner.json", :query => { :user_id => user_id })
      response['virtual_machine']
    end

    def change_password(id, password)
      response = request(:post, "/virtual_machines/#{id}/reset_password.json", :query => { :new_password => password })
      response['virtual_machine']
    end

    def migrate(id, options = {})
      params.required(:destination).accepts(:cold_migrate_on_rollback).validate! options 
      response = request(:post, "/virtual_machines/#{id}/migrate.json", :query => options )
    end

    def delete(id)
      request(:delete, "/virtual_machines/#{id}.json")
    end

    def resize(id, options = {})
      params.required(:memory).accepts(:allow_migration).validate! options
      response = request(:post, "/virtual_machines/#{id}/resize.json", default_params(options))
      response['virtual_machine']
    end

    def suspend(id)
      response = request(:post, "/virtual_machines/#{id}/suspend.json")
      response['virtual_machine']
    end

    def unlock(id)
      response = request(:post, "/virtual_machines/#{id}/unlock.json")
      response['virtual_machine']
    end
  end
end

module Squall
  module CLI
    class VirtualMachine < Base

      def initialize(command, argv = [])
        @argv    = argv
        @options = {}
        @command = if command == 'help'
                     @argv << '--help'
                     if @argv.size > 1
                       command = @argv.shift
                     else
                       command
                     end
                   else
                     command
                   end
      end

      def run!
        send(@command)
      end

      ## General help for virtual_machine
      def help
        puts %{Usage: squall virtual_machine [COMMAND] [OPTIONS]

          Available Commands:
                  list                         List all VMs
                  build                        Build a VM
                  create                       Create a new VM
                  show                         Show details for a VM
                  edit                         Edit a VM
                  change_owner                 Change the owner of a VM
                  change_password              Change a VM's password
                  migrate                      Migrate VM to a new Hypervisor
                  delete                       Delete a VM
                  resize                       Resize a VM
                  reboot                       Reboot a VM
                  suspend                      Suspend a VM
                  unsuspend                    Unsuspend a VM
                  startup                      Boot a VM
                  shutdown                     Shutdown a VM
                  stop                         Stop a VM
                  unlock                       Unlock a VM
        }.gsub(/^          /, '')
      end

      def build
        opts = OptionParser.new do |opt|
          opt.banner = "Usage: squall virtual_machine build"
          opt.on('--template-id [ID]', 'Template ID') do |id|
            @options[:template_id] = id.to_i
          end
          opt.on('--startup', "Require startup") do
            @options[:require_startup] = true
          end
          opt.parse!(@argv)
        end

        unless @options[:template_id]
          puts "Must specify --template-id"
          puts opts
          exit(-1)
        end
      end

      def list
        OptionParser.new do |opt|
          opt.banner = 'Usage: squall virtual_machine list'
          opt.parse!(@argv)
        end
        # RUN IT
      end

      def create
        OptionParser.new do |opt|
          opt.banner = "Usage: squall virtual_machine create [OPTIONS]"

          opt.separator "\nRequired:\n"
          opt.on('--label [LABEL]', "User-friendly VM description") do |label|
            @options[:label] = label
          end
          opt.on("--hostname [HOSTNAME]", "Hostname for the VM") do |hostname|
            @options[:hostname] = hostname
          end
          opt.on("--memory [MEMORY]", "Amount of RAM assigned to the VM") do |memory|
            @options[:memory] = memory
          end
          opt.on("--cpus [CPUS]", "Number of CPUs assigned to the VM") do |cpus|
            @options[:cpus] = cpus
          end
          opt.on("--cpu-shares [SHARES]", "CPU priority for the VM") do |shares|
            @options[:cpu_shares] = shares
          end
          opt.on("--primary-disk-size [SIZE]", "Disk space for the VM") do |size|
            @options[:primary_disk_size] = size
          end

          opt.separator "\nOptional:"
          opt.on("--hypervisor-id [ID]", "ID of a hypervisor where the VM will be built") do |id|
            @options[:hypervisor_id] = id
          end
          opt.on("--hypervisor-group-id [ID]", "ID of a hypervisor zone where the VM will be built") do |id|
            @options[:hypervisor_group_id] = id
          end
          opt.on("--swap-disk-size [SIZE]", "Swap disk size for the VM") do |swap|
            @options[:swap_disk_size] = swap
          end
          opt.on("--primary-network-id [ID]", "Primary Network ID") do |id|
            @options[:primary_network_id] = id
          end
          opt.on("--enable-backups", "Enable automatic backups") do
            @options[:required_automatic_backup] = true
          end
          opt.on("--rate-limit [LIMIT]", "Maximum port speed, unlimited if not set") do |limit|
            @options[:rate_limit] = limit
          end
          opt.on("--auto-ip", "Automatically assign IP address to the VM") do
            @options[:required_ip_address_assignment] = true
          end
          opt.on("--build", "Build VM automatically") do
            @options[:required_virtual_machine_build] = true
          end
          opt.on("--admin-note [NOTE]", "A brief comment for the VM") do |note|
            @options[:admin_note] = note
          end
          opt.on("--note [NOTE]", "A brief comment a user can add to the VM") do |note|
            @options[:note] = note
          end
          opt.on("--allowed-hot-migrate", "Allow hot migration for the VM") do
            @options[:allowed_hot_migrate] = true
          end
          opt.on("--template-id [ID]", "ID of a template form which the VM should be built") do |id|
            @options[:template_id] = id
          end
          opt.on("--root-password", "Initial root password") do |pass|
            @options[:initial_root_password] = pass
          end
          opt.parse!(@argv)
        end
      end
    end
  end
end

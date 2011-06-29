Squall::CLI.group :virtual_machine do
  help "VIRTUAL MACHINE HELP"
  command :create do
    description 'Usage: squall virtual_machine [command]'
    required_params << {
      :flag  => '--template-id ID',
      :label => 'Template ID',
      :type  => Integer,
      :proc  => lambda { |id| @options[:id] = id }
    }
  end
end

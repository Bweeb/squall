Squall [![Squall Build Status][Build Icon]][Build Status]
=========================================================

A Ruby library for working with the [OnApp REST API][].

Squall has been tested on MRI 1.8.7, MRI 1.9.2, MRI 1.9.3 Preview 1,
Rubinius 2.0.0pre, and JRuby 1.6.2.

Documentation is available in [RDoc][] format.

[Build Status]: http://travis-ci.org/site5/squall
[Build Icon]: https://secure.travis-ci.org/site5/squall.png?branch=master
[OnApp REST API]: https://help.onapp.com/manual.php?m=2
[RDoc]: http://rdoc.info/github/site5/squall/master/frames

Install
-------

    gem install squall

Usage
-----

Configure:

    require 'squall'

    Squall.config do |c|
      c.base_uri 'https://onappurl.com'
      c.username 'username'
      c.password 'topsecret'
    end
    
Squall can load configuration from a yaml file:

    # .squall.yml
    base_uri 'https://onappurl.com'
    username 'username'
    password 'topsecret'
    
To load it (by default it assumes ~/.squall.yml):

    Squall.config_file(/[path]/[to]/.squall.yml)

Show the info for a VM:

    vm = Squall::VirtualMachine.new
    vm.show 1

Create a new VM:

    vm = Squall::VirtualMachine.new

    params = {
      :label             => 'testmachine',
      :hypervisor_id     => 5,
      :hostname          => 'testmachine',
      :memory            => 512,
      :cpus              => 1,
      :cpu_shares        => 10,
      :primary_disk_size => 10,
      :template_id       => 1
    }

    vm.create params
    
To run tests:

    bundle exec rake
    rspec spec/[module]/[method].rb
    
Squall uses [VCR](https://github.com/myronmarston/vcr) to cache server responses to test against. To test via live http connections, make sure you have a config file setup and set the shell var SQUALL_LIVE=1. NOTE: since OnApp does not currently support a test environment this is not recommended!

To enable HTTParty's debug mode:

    Squall::Base.debug_output
    
Known issues:

1. virtual_machines#change_user currently breaks the parser on an invalid user_id  because OnApp returns html instead of JSON
2. virtual_machines#create is currently broken in certain cases.  See https://help.onapp.com/kb_article.php?s=0b397f5b851334cea54da9ddd829bf5f&ref=8181-TYFH-8069

Note on Patches/Pull Requests
-----------------------------
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a
  commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2011 Site5 LLC. See LICENSE for details.

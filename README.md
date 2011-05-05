Squall
=======
[![Build Status](http://travis-ci.org/site5/squall.png)](http://travis-ci.org/site5/squall)


A Ruby library for working with the OnApp REST API

[RDoc](http://rdoc.info/github/site5/squall/master/frames)

Confirmed to work with ruby 1.8.7, 1.9.2, Rubinis, REE and JRuby 1.6.0 with OnApp 2.1

Install
-------

    gem install squall

Usage
-----

Configure

    require 'squall'

    Squall.config do |c|
      c.base_uri 'https://onappurl.com'
      c.username 'username'
      c.password 'topsecret'
    end

Show the info for a VM

    vm = Squall::VirtualMachine.new
    vm.show 1


Create a new VM

   vm = Squall::VirtualMachine.new

   params = {
     :label => 'testmachine', 
     :hypervisor_id => 5,
     :hostname => 'testmachine', 
     :memory => 512, 
     :cpus => 1,
     :cpu_shares => 10, 
     :primary_disk_size => 10
   }

   vm.create params



Note on Patches/Pull Requests
=======
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
=======

Copyright (c) 2011 Site5 LLC. See LICENSE for details.

Vagrant.configure(2) do |config|

  config.cache.auto_detect = true

	saltSatckInstall = ""

  case ARGV[0]
		when "provision", "up"
    	print "Do you want to install salt Stack master/minion (y/n) ?\n"
    	saltSatckInstall = STDIN.gets.chomp
    	print "\n"
  end

	# Set some variables
  etcHosts=""
  common = <<-SHELL
  sudo apt update -qq 2>&1 >/dev/null
  sudo apt install -y -qq git vim tree net-tools telnet 2>&1 >/dev/null
  sudo echo "autocmd filetype yaml setlocal ai ts=2 sw=2 et" > /home/vagrant/.vimrc
  sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
  sudo systemctl restart sshd
  SHELL

	# set vagrant image
	config.vm.box = "ubuntu/bionic64"
	config.vm.box_url = "ubuntu/bionic64"

	# set servers list and their parameters
	NODES = [
  	{ :hostname => "salt1", :ip => "192.168.123.10", :cpus => 4, :mem => 2048, :type => "master" },
  	{ :hostname => "salt2", :ip => "192.168.123.11", :cpus => 2, :mem => 1024, :type => "minion" },
  	{ :hostname => "salt3", :ip => "192.168.123.12", :cpus => 2, :mem => 1024, :type => "minion" },
  	{ :hostname => "salt4", :ip => "192.168.123.13", :cpus => 2, :mem => 1024, :type => "minion" }
	]

	# define /etc/hosts for all servers
  NODES.each do |node|
   	etcHosts += "echo '" + node[:ip] + "   " + node[:hostname] + "' >> /etc/hosts" + "\n"
  end #end NODES

	# run installation
  NODES.each do |node|
    config.vm.define node[:hostname] do |cfg|
			cfg.vm.hostname = node[:hostname]
      cfg.vm.network "private_network", ip: node[:ip]
      cfg.vm.provider "virtualbox" do |v|
				v.customize [ "modifyvm", :id, "--cpus", node[:cpus] ]
        v.customize [ "modifyvm", :id, "--memory", node[:mem] ]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        v.customize ["modifyvm", :id, "--name", node[:hostname] ]
      end #end provider
			
			#for all
      cfg.vm.provision :shell, :inline => etcHosts
			cfg.vm.provision :shell, :inline => common
      if node[:type] == "master" and saltSatckInstall == "y"
        cfg.vm.provision :shell, :path => "install_master.sh"
      end
      if node[:type] == "minion" and saltSatckInstall == "y"
        cfg.vm.provision :shell, :path => "install_minion.sh"
      end

    end # end config
  end # end nodes
end 

Vagrant.configure("2") do |config|
    config.vm.box = "kwilczynski/ubuntu-16.04-docker"
    
    
    config.vm.define "lb" do |lb|
        lb.vm.hostname = "kafka-tools"
        lb.vm.network "private_network", ip: "172.20.20.11"
    end
  
    (1..3).each do |i|
        config.vm.define "web#{i}" do |web|
            web.vm.hostname = "kafka0#{i}"
            web.vm.network "private_network", ip: "172.20.20.2#{i}"
        end
    end
  end
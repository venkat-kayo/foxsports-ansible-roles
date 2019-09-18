ROLE_NAME=File.basename(Dir.pwd)
ENV['ANSIBLE_NOCOWS'] = '1'

def generate_ansible_cfg
  unless File.exists? 'ansible.cfg'
    puts "Generating ansible.cfg file, which requires for testing"
    File.open('ansible.cfg', 'w') do |fp|
      fp.puts '[defaults]'
      fp.puts 'roles_path = tests/roles'
    end
  end
end

def run_ansible_galaxy
  if File.exists? 'tests/requirements.yml'
    puts "tests/requirements.yml found, running ansible galaxy"
    %x[ansible-galaxy install -r tests/requirements.yml --force]
  end
end

def symlink_self
  Dir.mkdir 'tests/roles' unless Dir.exists? 'tests/roles'
  File.symlink("../../../#{ROLE_NAME}", "tests/roles/#{ROLE_NAME}") unless File.symlink? "tests/roles/#{ROLE_NAME}"
end

def modify_gitignore
  require 'yaml'
  ignored = [
    '.vagrant',
    'ansible.cfg',
    "tests/roles/#{ROLE_NAME}",
  ]
  YAML.load_file('meta/main.yml')['dependencies'].each do |dependency|
    ignored << "tests/roles/#{dependency['role']}"
  end

  if File.exists? '.gitignore'
    content = File.read('.gitignore').split("\n")
    File.write('.gitignore', (ignored + content).uniq.join("\n"))
   else
    File.write('.gitignore', ignored.join("\n"))
  end
end

vagrant_command = ARGV[0]
unless [ 'destroy', 'ssh' ].include? vagrant_command
  generate_ansible_cfg
  run_ansible_galaxy
  symlink_self
  modify_gitignore
end

# To add forwarded ports - simply create an array of hashes as follows
#    forwarded_ports = [{ guest: 8080, host: 11080 }, { guest: 8081, host: 11081}]
# Which will forward the ports on Vagrantbox 8080/8081 to local box 11080/11081
forwarded_ports = []

Vagrant.configure("2") do |config|
  major_release_version = ENV['ANSIBLE_ROLE_MAJOR_RELEASE_VERSION'] || 'bionic'
  name = "#{ROLE_NAME}-ubuntu-#{major_release_version}"
  ram =  ENV['ANSIBLE_ROLE_RAM'] || '1536'

  (1..3).each do |i|
    rancher_node_name = "rancher-node-#{i}"
    config.vm.define rancher_node_name do |conf|
      conf.vm.box = "ansible-role-base-ubuntu-#{major_release_version}"
      conf.vm.box_url = "https://artifactory.foxsports.com.au/generic/vagrant/boxes/ansible-role-base-ubuntu-#{major_release_version}.box"
      conf.vm.hostname = "#{rancher_node_name}.#{name}.tester.vagrant.foxsports"
      conf.vm.synced_folder '.', '/vagrant', disabled: true
      conf.vm.provider "virtualbox" do |vb|
        vb.name = rancher_node_name
        vb.customize ['modifyvm', :id, '--memory', ram]
      end
      forwarded_ports.each do |port|
        config.vm.network "forwarded_port", guest: port[:guest], host: port[:host]
      end
      conf.vm.network "private_network", ip: "10.0.0.10#{i}"
      conf.vm.provision :shell, inline: "cat /etc/os-release"
      conf.vm.provision "ansible" do |ansible|
        ansible.playbook = "tests/rancher-test-node-setup.yml"
        ansible.inventory_path = "tests/inventory.sh"
        ansible.limit = "func-testing"
        ansible.config_file = "ansible.cfg"
        ansible.host_key_checking = false
        ansible.verbose = true
      end
    end
  end

  config.vm.define name, primary: true do |conf|
    conf.vm.box = "ansible-role-base-ubuntu-#{major_release_version}"
    conf.vm.box_url = "https://artifactory.foxsports.com.au/generic/vagrant/boxes/ansible-role-base-ubuntu-#{major_release_version}.box"
    conf.vm.hostname = "#{name}.tester.vagrant.foxsports"
    conf.vm.synced_folder '.', '/vagrant', disabled: true
    conf.vm.provider "virtualbox" do |vb|
      vb.name = name
      vb.customize ['modifyvm', :id, '--memory', ram]
    end

    forwarded_ports.each do |port|
      config.vm.network "forwarded_port", guest: port[:guest], host: port[:host]
    end
    conf.vm.network "private_network", ip: "10.0.0.254"

    conf.vm.provision :shell, inline: "cat /etc/os-release"
    conf.vm.provision "ansible" do |ansible|
      ansible.playbook = "tests/test.yml"
      ansible.inventory_path = "tests/inventory.sh"
      ansible.limit = "func-testing"
      ansible.config_file = "ansible.cfg"
      ansible.host_key_checking = false
      ansible.verbose = "v"
    end
  end
end



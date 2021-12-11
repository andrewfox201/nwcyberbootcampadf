# nwcyberbootcampadf
Repo for Class Projects as Part of NW Cyber Course


#all answers from readme activity week 3 below

## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

GDrive Link = https://drive.google.com/file/d/139DZJVHcmCB2pVbHZY4z-IrfZBzEMfQl/view?usp=sharing 

Also can be found in this git repo at Images/Week12HW.drawio.pdf


These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook files may be used to install only certain pieces of it, such as Filebeat (see filebeat-playbook.yml)

  Playbook Files:

  -ElkServer : pentest.yml with configs located in elkconfig.yml
  -Filebeat : filebeat-playbook.yml with configs located in filebeat-config.yml
  -Metricbeat :  metricbeat-playbook.yml with configs located in metricbeat-config.yml. 
  


This document contains the following details:
- Description of the Topology. 
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.
Load balancing ensures that the application will be highly available, in addition to restricting unauthorized access to the network.
- _TODO: What aspect of security do load balancers protect? What is the advantage of a jump box?_

If we speak in terms of the CIA Triad, Load Balancers ensure the Availability of well architected systems as well as protect the integrity of those systems against unathorized use. The advantage of a jump box is that our servers which hosts our web applications via docker containers deployed by Anisble are only accessible via certain ports (i.e. http over port 80) and cannot be accessed over other exposed ports by unauthorized users. In the case of this specific enterprise cloud deployment only the jump box has been configured to access our DVWA vm's over port 22 (SSH) and by design no external user (even with a compromised key) would be able to ssh to our web applications. The jump box is a segregated access point for which you need to be whitlisted. In the case of compromised jump keys, unauthorized users would not be whitelisted against our systems and they would be blocked from access. 

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the filesystem (in this case filebeat) and system metrics (in this case this beat is monitored using metricbeat). 
TODO: What does Filebeat watch for?_Filebeat collects data about the filesystem. Specifically, Filebeat forwards centralized log data to the ELK Server for easy monitoring via Kabana. This would be known as a "beat" or data collection module. 
TODO: What does Metricbeat record? Metric Beat collects machine metrics such as uptime by collecting data from the operating system on services running on the given server for which it is installed. 



The configuration details of each machine may be found below. 

Note: Use the [Markdown Table Generator](http://www.tablesgenerator.com/markdown_tables) to add/remove values from the table. 

See all responses below for network machine specifications here:


| Name                | Function                                                                                                           | IP Address                                    | Operating System           |
|---------------------|--------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|----------------------------|
| JumpBoxProvisioner2 | Gateway administration of all remote virtual machines. Hosts docker container  which uses ansible to deploy vm's.  | Public - 40.76.108.96 Private - 10.0.0.5      | Ubuntu 18.04 LTS - 2nd Gen |
| ElkServer           | ELK Server to monitor VM log and filesystem changes using Kabana.                                                  | Public - 52.237.165.214 Private - 10.1.0.4    | Ubuntu 18.04 LTS - 2nd Gen |
| Project1LB          | For HA purposes, balance external load for pool of the 2 VM's mentioned above (Web 1 + 2)                          | Public- 104.45.139.189                        | N/A - Native Azure         |
| Web1                | Web server to host docker container serving DVWA application.                                                      | Public - See Load balancer Private - 10.0.0.6 | Ubuntu 18.04 LTS - 2nd Gen |
| Web2                | Web server to host docker container serving DVWA application.                                                      | Public - See Load balancer Private - 10.0.0.7 | Ubuntu 18.04 LTS - 2nd Gen |



### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the JumpBoxProvisioner2 machine, Project1LB and ElkServer can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:

Whilisted IP addresses are as follows:

1). JumpBoxProvisioner2 can receive connections from my Ip address ****hidden here for security purposes so as not to list on github**** as part of the network security group "JumpBoxProvisioner2-nsg" over port 22 for SSH access which also has rules for inbound connections from the internet over port 80 to the Project1LB Load Balancer from my Ip address ****hidden here for security purposes so as not to list on github****. 

Machines within the network can only be accessed by JumpBoxProvisioner2. See network diagram for more details. 

Which machine did you allow to access your ELK VM? What was its IP address?

Answer - Our ELK virtual machine has a public IP address which is accessible from our JumpBox via Virtual Network Peering on Azure. 

You can see here that our docker container (provisioner with ansible) has an established connection via SSH to the ElkServer's public IP. 


root@2836f25e9ace:~# ssh ansible@52.237.165.214
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 5.4.0-1064-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat Dec 11 17:50:06 UTC 2021

  System load:  0.0                Processes:              139
  Usage of /:   23.4% of 28.90GB   Users logged in:        0
  Memory usage: 44%                IP address for eth0:    10.1.0.4
  Swap usage:   0%                 IP address for docker0: 172.17.0.1

 * Super-optimized for small spaces - read how we shrank the memory
   footprint of MicroK8s to make it the smallest full K8s around.

   https://ubuntu.com/blog/microk8s-memory-optimisation

3 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

New release '20.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Fri Dec 10 02:41:12 2021 from 10.0.0.5
ansible@ElkServer:~$ 


^Traffic pattern here is internet --> jump --> docker container within jump ---> ssh to public IP of ElkServer


A summary of the access policies in place can be found in the table below.

| Name    | Publicly Accessible (Y/N)   | Allowed IP Addresses  |
|---  |---  |---  |
| JumpBoxProvisioner2   | Y   | *My ip address (left blank for security reasons) over port 22 only for SSH  |
| Web 1 + Web 2   | Y ***only from Load Balancer on restricted ports  | *My ip over port 80 TO through our Public LB's Public IP  |
| ElkServer   | Y   | *My ip over port 5601 for Kabana GUI Access   |




### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...

What is the main advantage of automating configuration with Ansible?

The main advantage of automating configurations with ansible is really two fold 1). All remote configurations are saved in the event that they need to be provisioned in other parts of the cloud (i.e. in a different region, resource group etc.) if systems were to ever be compromised. Additionally, this allows for a highly scalable, highly avaialble and fault tolerant system. Specifically, if resources need to be scaled up (additional instances needed) or scaled out we can replicate these configurations as many times as needed in cases of resource contention or resourcing issues. Lastly, the amount of time required to build these enterprise network deployments is reduced as these resources can be simultaneously provisioned in the cloud rather than a human adminstrator building each component. 

The playbook implements the following tasks:
In 3-5 bullets, explain the steps of the ELK installation play. E.g., install Docker; download image; etc._

The ELK instalation playbook does the following. This is the breakdown for each line in the playbook (see commented lines for explanation):

root@2836f25e9ace:/etc/ansible# cat pentest.yml 
---
- name: Config Web VM with Docker
  hosts: webservers
  become: true
  tasks:
  - name: docker.io
    apt:
      force_apt_get: yes
      update_cache: yes
      name: docker.io
      state: present

#takes hosts from our config file and then runs an apt get request for docker pulling all relevant docker packages.  

  - name: Install pip3
    apt:
      force_apt_get: yes
      name: python3-pip
      state: present

#does the same as line above but runs an apt get request using the apt package manager to grab files needed for pip3 installation. 

  - name: Install Docker python module
    pip:
      name: docker
      state: present

#uses pip package manager to install docker's python module. 


  - name: download and launch a docker web container
    docker_container:
      name: dvwa
      image: cyberxsecurity/dvwa
      state: started
      published_ports: 80:80


#Downloads an image form the cyberxsecurity repository that contains the Damn Vulnerable Web Application and launches it on our docker container. 

  - name: Enable docker service
    systemd:
      name: docker
      enabled: yes
 
#uses the system daemon to start the docker service running on ubuntu. 

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

Update the path with the name of your screenshot of docker ps output](Images/docker_ps_output.png)- Rather than use screenshot this output is small so I have pasted evidence of that below. 

Evidence of running docker image (docker ps) - here - 

root@JumpBoxProvisioner2:/home/Project1User# docker ps
CONTAINER ID   IMAGE                    COMMAND                  CREATED      STATUS      PORTS     NAMES
2836f25e9ace   cyberxsecurity/ansible   "/bin/sh -c /bin/bas…"   3 days ago   Up 2 days             hopeful_taussig
root@JumpBoxProvisioner2:/home/Project1User# 

And can also be found in this repo at Images/dockerps.png


### Target Machines & Beats
This ELK server is configured to monitor the following machines:

List the IP addresses of the machines you are monitoring.

Web 1 private IP - 10.0.0.6
Web 2 private IP - 10.0.0.7

*Note both will have public IP of Load Balancer Front End Configuration. 

We have installed the following Beats on these machines:

Specify which Beats you successfully installed
Metric Beat + Filebeat

These Beats allow us to collect the following information from each machine:

In 1-2 sentences, explain what kind of data each beat collects, and provide 1 example of what you expect to see. E.g., `Winlogbeat` collects Windows logs, which we use to track user logon events, etc.

1). Filebeat collects data on the file system, specific examples of this would be our web server's respective garbage collection process ---> example here ---> "memstats":{"gc_next":9652048,"memory_alloc":8789952,"memory_total":117510056}. This snippet was taken from Kabana using our filebeat installation. 
2). Metricbeat collects system perfomance utilization data such as disk input / output. Snippet here taken from Kabana using our metric beat installation --->

"diskio":{"events":3,"success":3}


### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node 

here - 

root@JumpBoxProvisioner2:/home/Project1User# ls
root@JumpBoxProvisioner2:/home/Project1User# docker exec -it 2836f25e9ace bash

and follow the steps below:
- Copy the playbook file and configurations to root@2836f25e9ace:/etc/ansible# pwd
/etc/ansible

- Update the elk configuration file to include hoste name (private IP) for where you'd like ELK to be installed. See example here -->

root@2836f25e9ace:/etc/ansible# cat elkconfig.yml 
- name: Configure Elk VM with Docker
  hosts: 10.1.0.4


- Run the playbook, and navigate to the public IP of your elk server to check that the installation worked as expected. Sample URL from this installation will be here and is accessible via public internet so long as you are whitelisted against the public IP of the ELK Server:

In my case the ELK Kabana GUI is accessible here ---> http://52.237.165.214:5601/app/kibana#/dashboard/Filebeat-syslog-dashboard-ecs?_g=(refreshInterval:(pause:!t,value:0),time:(from:now-15m,to:now))&_a=(description:'Syslog%20dashboard%20from%20the%20Filebeat%20System%20module',filters:!(),fullScreenMode:!f,options:(darkTheme:!f),panels:!((embeddableConfig:(),gridData:(h:16,i:'1',w:32,x:0,y:4),id:Syslog-events-by-hostname-ecs,panelIndex:'1',type:visualization,version:'7.6.1'),(embeddableConfig:(),gridData:(h:16,i:'2',w:16,x:32,y:4),id:Syslog-hostnames-and-processes-ecs,panelIndex:'2',type:visualization,version:'7.6.1'),(embeddableConfig:(columns:!(host.hostname,process.name,message),sort:!('@timestamp',desc)),gridData:(h:28,i:'3',w:48,x:0,y:20),id:Syslog-system-logs-ecs,panelIndex:'3',type:search,version:'7.6.1'),(embeddableConfig:(),gridData:(h:4,i:'4',w:48,x:0,y:0),id:'327417e0-8462-11e7-bab8-bd2f0fb42c54-ecs',panelIndex:'4',type:visualization,version:'7.6.1')),query:(language:kuery,query:''),timeRestore:!f,title:'%5BFilebeat%20System%5D%20Syslog%20dashboard%20ECS',viewMode:view)



_TODO: Answer the following questions to fill in the blanks:_

- _Which file is the playbook? Where do you copy it?_

Playbook files are all yaml files such as filebeat-playbook.yml which are located in the /etc/ansible directory and are copied to wherever you'd want to issue your playbook commands from. In the case of this installation for homework / demo purposes you can see that here:

root@2836f25e9ace:/etc/ansible# ls
ansible.cfg    filebeat-config.yml    files  metricbeat-config.yml    pentest.yml
elkconfig.yml  filebeat-playbook.yml  hosts  metricbeat-playbook.yml
root@2836f25e9ace:/etc/ansible# 



- _Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_

Your hosts directory within /etc/ansible (ansible) will have specificed internal IP Addresses for the web servers group. See here ---> 

root@2836f25e9ace:/etc/ansible# cat hosts 

[webservers]
#alpha.example.org
#beta.example.org
#192.168.1.100
#192.168.1.110
10.0.0.7 ansible_python_interpreter=/usr/bin/python3
10.0.0.6 ansible_python_interpreter=/usr/bin/python3


Which our playbook files then refer back to such as the filebeat playbook yaml see below where webservers are referenced (hosts - webservers)

root@2836f25e9ace:/etc/ansible# cat filebeat-playbook.yml 
---
- name: Installing and Launch Filebeat
  hosts: webservers

How do I specify which machine to install the ELK server on versus which to install Filebeat on?_

Each playbook specifies which host machine to target and configure. For example the elkconfig.yml playbook ***ONLY** specifies 10.1.0.4 which is our Elk Server's Internal IP address.  **note in some cases it will refer to a "group" such as the web servers group above where the pentest.yaml file actually has web servers and excludes the elk server for dvwa installations. 


root@2836f25e9ace:/etc/ansible# cat elkconfig.yml 
- name: Configure Elk VM with Docker
  hosts: 10.1.0.4


- _Which URL do you navigate to in order to check that the ELK server is running?

Answer above already see here for format --->  http://(publicIPofELkServer):5601/app/







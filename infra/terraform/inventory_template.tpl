[app_servers]
todo-app-server ansible_host=${server_ip}

[app_servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${ssh_key_path}
ansible_python_interpreter=/usr/bin/python3
app_domain=${domain_name}
repo_url=${github_repo_url}
repo_branch=main
app_directory=/home/ubuntu/todo-app

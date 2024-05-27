#!/bin/bash

dnf install ansible -y
cd /tmp
git clone https://github.com/sriramulasrinath/expense-ansible-roles.git
cd expense-ansible-roles
ansible-playbook main.yml -e component=backend -e mysql_root_password=ExpenseApp1 
ansible-playbook main.yml -e component=frontend 


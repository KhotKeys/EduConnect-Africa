#!/usr/bin/env python3
"""
Dynamic Ansible inventory script that uses environment variables
Usage: ansible-playbook -i inventory/dynamic_hosts.py deploy.yml
"""

import json
import os
import sys

def get_inventory():
    ec2_host = os.getenv('EC2_HOST', 'localhost')
    ecr_repo = os.getenv('ECR_REPO', 'your-ecr-repo')
    aws_region = os.getenv('AWS_REGION', 'us-east-1')
    
    inventory = {
        'app_server': {
            'hosts': ['educonnect-server'],
            'vars': {
                'ansible_python_interpreter': '/usr/bin/python3',
                'ecr_repo': ecr_repo,
                'aws_region': aws_region,
                'ec2_host': ec2_host
            }
        },
        '_meta': {
            'hostvars': {
                'educonnect-server': {
                    'ansible_host': ec2_host,
                    'ansible_user': 'ubuntu',
                    'ansible_ssh_private_key_file': '~/.ssh/educonnect-key.pem'
                }
            }
        }
    }
    
    return inventory

if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] == '--list':
        print(json.dumps(get_inventory(), indent=2))
    elif len(sys.argv) == 3 and sys.argv[1] == '--host':
        print(json.dumps({}))
    else:
        print("Usage: {} --list or {} --host <hostname>".format(sys.argv[0], sys.argv[0]))
        sys.exit(1)
#!/bin/bash

if [ ! -f "ansible.cfg" ]; then
    cp /ansible_default.cfg ansible.cfg 
fi

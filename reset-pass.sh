#!/usr/bin/python3
from string import ascii_letters
from os import system
from random import choices
from argparse import ArgumentParser

parser = ArgumentParser()
random_user = ''.join(choices(ascii_letters, k=10)).encode().hex()
parser.add_argument('--user', type=str, required=False, default=random_user)
random_pass = ''.join(choices(ascii_letters, k=10)).encode().hex()
parser.add_argument('--pass', type=str, required=False, default=random_pass)
args = parser.parse_args()
system("mkdir -p /etc/wireguard")

username = bytes.fromhex(getattr(args, "user")).decode()
password = bytes.fromhex(getattr(args, "pass")).decode()
open("/etc/wireguard/wg.pass", "w").write(password)
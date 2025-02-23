#!/bin/python3
# -*- coding: utf-8 -*-

import os
import sys
import platform
import subprocess

def main():
	system_value=platform.system()
	if system_value == "Linux":
		init_linux()
	elif platform.system() == "Windows":
		init_windows()
	elif platform.system() == "Bsd":
		init_bsd()
	elif platform.system() == "Mac":
		init_mac()
	sys.exit(0)

#============================================================================= #
#  ╦  ╦╔╗╔╦ ╦═╗ ╦                                                              #
#  ║  ║║║║║ ║╔╩╦╝                                                              #
#  ╩═╝╩╝╚╝╚═╝╩ ╚═                                                              #
#============================================================================= #

def init_linux():
	HOME= os.environ.get('HOME')
	output = subprocess.run(['echo', 'hello'], capture_output=True, text=True)
	print(output)

#============================================================================= #
#  ╦ ╦╦╔╗╔╔╦╗╔═╗╦ ╦╔═╗                                                         #
#  ║║║║║║║ ║║║ ║║║║╚═╗                                                         #
#  ╚╩╝╩╝╚╝═╩╝╚═╝╚╩╝╚═╝                                                         #
#============================================================================= #

def init_windows():
	print('Windows')

#============================================================================= #
#  ╔╗ ╔═╗╔╦╗                                                                   #
#  ╠╩╗╚═╗ ║║    Work in progress...                                            #
#  ╚═╝╚═╝═╩╝                                                                   #
#============================================================================= #

def init_bsd():
	pass

#============================================================================= #
#  ╔╦╗╔═╗╔═╗                                                                   #
#  ║║║╠═╣║      Work in progress...                                            #
#  ╩ ╩╩ ╩╚═╝                                                                   #
#============================================================================= #

def init_mac():
	pass

main()
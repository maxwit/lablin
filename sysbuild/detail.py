#!/usr/bin/python

import os,sys,re
import shutil
from optparse import OptionParser

img = '/maxwit/image/hdd.img'
board = 'beagle'

top_dir = os.getcwd()
img_dir = '/maxwit/image'
source = '/maxwit/source'
build = '/maxwit/build'
boot = img_dir + '/boot'
rootfs = img_dir + '/rootfs'

# package list
linux = 'linux-3.5.4'


def main():
	parser = OptionParser()
	parser.add_option('-i', '--image', dest='image',
					  help="image file name")
	parser.add_option('-d', '--device', dest='device',
					  help="block device name")
	(options, args) = parser.parse_args()

	if options.image:
		print 'Using image file...'
	elif options.device:
		print 'Using physical device...'
	else:
		print 'Syntax error. Use "%s -h" for help.' % sys.argv[0]

	if not os.path.exists(boot):
		os.mkdir(boot)

	if not os.path.exists(boot + '/MLO'):
		print 'MLO does not exists.'
		if not os.path.exists(build + '/x-load'):
			os.system('git clone git://gitorious.org/x-load-omap3/mainline.git %s/x-load' % build)
			os.chdir(build + '/x-load')
			os.system('patch -p1 < %s/0001-support-g-bios.patch' % top_dir)
		os.chdir(build + '/x-load')
		os.system('make omap3530beagle_config')
		os.system('make CROSS_COMPILE=arm-linux-')
		os.system('make CROSS_COMPILE=arm-linux- ift')
		shutil.copyfile(build + '/x-load/MLO', boot + '/MLO')

	if not os.path.exists(boot + '/g-bios.bin'):
		print 'g-bios.bin does not exists.'
		if not os.path.exists(build + '/g-bios'):
			os.system('git clone git://github.com/maxwit/g-bios.git %s/g-bios' % build)
		os.chdir(build + '/g-bios')
		try:
			os.system('make clean')
			os.system('make %s_defconfig' % board)
			os.system('make')
			os.system('make DESTDIR=%s install' % boot)
		except:
			print 'fail to build g-bios'
			exit()

if __name__ == "__main__":
	curr_user = os.getenv('USER')
	if curr_user == 'root':
		print 'cannot run as root!'
		exit()

	main()

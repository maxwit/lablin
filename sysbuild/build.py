#!/usr/bin/python
#
# Authors:
#    Sandy Zhou <sandy.zhou@emc.com>
#    Conke Hu <conke.hu@maxwit.com>
#
# http://www.maxwit.com
# http://maxwit.github.com
# http://maxwit.googlecode.com
#

import os,sys,re
import shutil

build_path = '/maxwit/build'
source_path = '/maxwit/source'

top_dir = os.getcwd()

state_list = ['fetch', 'build', 'install', 'done']
state_dict = {'fetch':0, 'build':1, 'install':2, 'done':3}

class task:
	def __init__(self, name):
		self.name = name
		return

	def run(self):
		f = open(self.name)
		for pkg in f:
			pkg = pkg[:-1]
			self.build_package(pkg)
		f.close();

	def build_package(self, name):
		pkg = package(name)
		if pkg.isbuilt(name) == True:
			return

		if pkg.config.has_key('dep'):
			for dep in pkg.config['dep'].split(','):
				dep = dep.strip(' ')
				self.build_package(dep)

		pkg.build_one(name)

class package:
	def __init__(self, name):
		self.config = {}
		self.next_state = 'done'

		# load the config
		f = open('%s/%s/config' % (top_dir, name))
		for line in f:
			(key, val) = line.split('=')
			key = key.strip(' ')
			val = val.strip(' ')
			self.config[key] = val[:-1]
		f.close()
		print "%s: %s" %(name, self.config)

		ver = self.config['ver']
		pkg = name + '-' + ver + '.tar.xz'
		pkg_path = '%s/%s-%s' % (build_path, name, ver)

		# get current state
		state_file = '%s/lablin_state' % (pkg_path)
	
		if not os.path.exists(state_file):
			self.next_state = 'fetch'
		else:
			f = open(state_file, 'rw')
			lines = f.readlines()
			f.close()
			if len(lines) == 0:
				self.next_state = 'fetch'
			else:
				self.next_state = lines[-1][:-1]
				self.next_state = state_list[state_dict[self.next_state] + 1]

	def get_next_state(state, step):
		return state_list[state_dict[state], 1]

	def isbuilt(self, name):
		return self.next_state == 'done'

	def build_one(self, name):
		ver = self.config['ver']
		pkg = name + '-' + ver + '.tar.xz'
		pkg_path = '%s/%s-%s' % (build_path, name, ver)

		task = {
			'fetch': self.fetch,
			'build': self.build,
			'install': self.install
		}

		while self.next_state <> 'done':
			try:
				os.chdir(build_path)
				step = task[self.next_state](name)
			except:
				print '%s %s failed' % (self.next_state, name)
				exit()

			os.system('echo %s >> %s/lablin_state' % (self.next_state, pkg_path))
			self.next_state = state_list[state_dict[self.next_state] + step]

	def fetch(self, name):
		ver = self.config['ver']
		cmd = self.config['cmd']
		url = self.config['url']
		ext = self.config['ext']
		pkg = '%s-%s.%s' % (name, ver, ext)

		print 'fetch ' + pkg

		if os.path.exists('%s-%s' % (name, ver)):
			shutil.rmtree('%s-%s' % (name, ver))

		if cmd.startswith('wget'):
			cmd = cmd + ' -P ' + source_path

		if not os.path.exists(source_path + '/' + pkg):
			os.system('%s %s/%s' % (cmd, url, pkg))

		if ext.startswith('tar'):
			os.system('tar xf %s/%s' % (source_path, pkg))

		return 1

	def build(self, name):
		cmd = '%s/%s/build.sh' % (top_dir, name)
		if not os.path.exists(cmd):
			cmd = '%s/def_build.sh' % (top_dir)

		os.chdir('%s-%s' % (name, self.config['ver']))
		#os.system(cmd)
		print cmd

		return 1

	def install(self, name):
		print 'install ' + name
		return 1

if __name__ == "__main__":
	if os.getenv('USER') == 'root':
		print 'cannot run as root!'
		exit()

	try:
		tsk = task('base')
		tsk.run()
	except:
		print "failed to build with base"

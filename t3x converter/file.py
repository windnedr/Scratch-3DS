import os
from log import Log
import subprocess

class File:
	def __init__(self, name):
		self.path = name

	def get(self, ext):
		return self.path + "." + ext

	def png(self):
		return self.path + ".png"

	def t3x(self):
		return self.path + ".t3x"

	def clean(self, ext):
		try:
			os.remove(self.get(ext))			
		except FileNotFoundError:
			Log.append("Cannot clean " + self.get(ext) + ": Does not exist.")

			return False

		return True

	def convert(self):
		try:
			subprocess.call("tex3ds " + self.png() + " -o " + self.t3x(), shell=True)
		except subprocess.CalledProcessError:
			Log.append("Could not convert " + self.png() + ".")

			return False

		return True

	def move(self):
		start = self.path.find("/")
		real_path = "game" + self.path[start:]

		recursive_dirs = real_path.split("/")
		created_path = ""
		for i in range(len(recursive_dirs) - 1):
			created_path += recursive_dirs[i] + "/"
			if not os.path.isdir(created_path):
				os.mkdir(created_path)
		
		try:
			os.rename(self.t3x(), real_path + ".t3x")
		except subprocess.CalledProcessError:
			raise FileNotFoundError
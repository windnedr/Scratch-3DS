#!/usr/bin/python3

from os.path import splitext
from os.path import isfile
from os.path import isdir
from os import listdir

from log import Log
from file import File
import argparse

import subprocess

# @brief: Search recursively for png files
# @retrn: Dictionary of files with png/t3x keys
def search(path = None, file_list = None):
	if file_list is None:
		file_list = []
	
	if path is None:
		path = "game"
		
	try:
		for file in listdir(path):
			if isfile(path + "/" + file) and file[-4:] == ".png":
				no_ext_value = splitext(file)[0]
				file_list.append(File(path + "/" + no_ext_value))
			elif isdir(path + "/" + file):
				search(path + "/" + file, file_list)
		
		return file_list
	except FileNotFoundError:
		Log.append("Failed to find file listing for " + path)

# @brief: Converts the files from a search
# This outputs progress
def do_convert(file_list, arg):
	successful = True

	if file_list is None:
		return


	for i in range(len(file_list)):
		if arg["c"] == "":
			try:
				if file_list[i].convert():
					print("\x1b[2K\rConverting " + file_list[i].png() + " (" + str(i + 1) + " of " + str(len(file_list)) + ")", end = "", flush=True)
				
					if arg["mv"]:
						file_list[i].move()
			except subprocess.CalledProcessError:
				Log.append("Could not convert file " + file_list[i].png())
			except KeyboardInterrupt:
				Log.append("Conversion stopped.")
			except FileNotFoundError as err:
				Log.append("Could not find file " + file_list[i].png() + "\n\t(" + str(err) + ")")
		else:
			try:
				if file_list[i].clean(arg["c"]):
					print("\x1b[2K\rCleaning " + file_list[i].t3x() + " (" + str(i + 1) + " of " + str(len(file_list)) + ")", end = "", flush=True)
				else:
					successful = False
			except FileNotFoundError:
				Log.append("Could not clean file")

	if successful:
		print("\nDone.")

parser = argparse.ArgumentParser(description = "Recursively converts *.png -> *.t3x")
parser.add_argument("dir", type = str, default = "game", help = "Directory to scan. Default is the game directory.")
parser.add_argument("-c", type = str, default = "", choices = ["png", "t3x"], help = "Cleans the directory of either t3x or png files.")
parser.add_argument("-mv", type = bool, default = False, nargs = "?", const = True, help = "Moves all converted files to ./game/* when finished.")
args = vars(parser.parse_args())

do_convert(search(args["dir"]), args)

Log.write()
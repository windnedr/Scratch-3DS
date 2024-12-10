import time
import inspect

class Log(object):
	data = []

	@staticmethod
	def append(msg):
		local_time = time.localtime(time.time())
		
		curr_time = str(local_time.tm_hour) + ":" + str(local_time.tm_min)
		
		frame = inspect.stack()[1][0]
		info = inspect.getframeinfo(frame)

		name = info.filename.split("/")
		nice_name = name[len(name) - 1]

		Log.data.append("[" + curr_time + "] [" + nice_name + ":" + str(info.lineno) + "] " + msg)

	@staticmethod
	def write():
		if len(Log.data) > 0:
			log_file = open("log.txt", "w")
			log_file.write("\n".join(Log.data))
			log_file.flush()
			log_file.close()

			print("Errors were generated. Check log.txt!")
#!/usr/bin/python
import serial, commands, sys
#var = 1
#line = "empty"
#ser = serial.Serial('/dev/ttyACM0', 9600, timeout=100)
#ser.close()

#ser.open()

#while (var == 1):
#  f = open('/tmp/workfile', 'a')
#  line = ser.readline()
#  print line
#  f.write(line)
#  ser.flush()
#  f.close()

#ser.close()

#get date/time
dt = commands.getoutput("date '+%F %H:%M:%S'")

ser = serial.Serial('/dev/ttyACM0', 9600, timeout=100)
# close the port if we accidentaly left it open previously

# get data
line = ser.readline().split()
ser.flush()
ser.close()

# save the data to a file
orig_stdout = sys.stdout
f = file('/tmp/testser.txt', 'a')
# Redefine system output to our file
sys.stdout = f
print '{0}, {1}'.format(dt, line[0])
f.close()
# Re-set the stdout
sys.stdout = orig_stdout

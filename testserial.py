#!/usr/bin/python
import serial, commands, sys

port = serial.Serial('/dev/ttyACM0', 9600, timeout=5)

def gettelegram(cmd):
  # flag used to exit the while-loop
  abort = 0
  # countdown counter used to prevent infinite loops
  loops2go = 40
  # storage space for the telegram
  telegram = []
  # end of line delimiter
  delim = "\x0a"

  #try:
  #  port.open()
  #  serial.XON
  #except:
  #  abort == 4
  #  # open error terminates immediately
  #  return telegram, abort

  while abort == 0:
    try:
      port.flush()
      port.write(cmd)
      line = port.readline()
      # this doesn't seem to work
      #line = str(port.readline()).strip()
      #line = "".join(iter(lambda:port.read(1),delim)).strip()
    except:
      # read error, terminate prematurely
      abort = 2

    #if line[0] == "!":
    #  abort = 1
    telegram = line
    abort =1

    #if line != "":
    #   telegram.append(line)

    #loops2go = loops2go - 1
    #if loops2go < 0:
    #  abort = 3

  # test for correct start of telegram
  #if telegram[0][0] != "/":
  #  abort = 2

  #try:
  #  serial.XOFF
  #  port.flush()
  #  port.close()
  #except:
  #  abort == 5

  # Return codes:
  # abort == 1 indicates a successful read
  # abort == 2 means that no valid data was read from the serial port
  # abort == 3 indicates a data overrun. More lines were received than expected.
  # abort == 4 indicates a serial port open error.
  # abort == 5 indicates a serial port close error.
  return (telegram, abort)

if __name__ == "__main__":
  telegram, status = gettelegram("v")
  dt = commands.getoutput("date '+%F %H:%M:%S'")

  #port.write("v")
  # get data
  #line = port.readline()
  #port.flush()
  #discard the first line.
  #line = port.readline()
  #port.flush()
  #port.close()

  #f = file('/tmp/testser.txt', 'a')
  #f.write('{0}, {1}'.format(dt, line))
  print '{0}, {1}'.format(dt, telegram)
  #f.close()
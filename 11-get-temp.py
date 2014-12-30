#! /usr/bin/python

import sys, commands, time

def main():
    # Everybody! Remember where we parked! -Capt. Kirk
    orig_stdout = sys.stdout

    # Define output file
    f = file('/tmp/11-t-cpu.csv', 'a')
    # Redefine system output to our file
    sys.stdout = f

    # Read the CPU temperature
    outTemp = commands.getoutput("cat /sys/class/thermal/thermal_zone0/temp")
    if float(outTemp) > 75000:
        # can't believe my sensors. Probably a glitch. Wait a while then measure again
        time.sleep(7)
        outTemp = commands.getoutput("cat /sys/class/thermal/thermal_zone0/temp")
        outTemp = float(outTemp) + 0.1

    # Get the time and date in human-readable form...
    outDate = commands.getoutput("date '+%F %H:%M:%S'")
    # ... and machine-readable form (UNIX-epoch)
    outUxDate = commands.getoutput("date +%s")

    # Print the data
    print '{0}, {1}, {2}'.format(outDate, outUxDate, float(float(outTemp)/1000))

    # Close the file
    f.close()

    # Re-set the stdout
    sys.stdout = orig_stdout

if __name__ == "__main__":
    main()
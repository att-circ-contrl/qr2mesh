# Quick and dirty QR code to STL mesh converter - Makefile
# Written by Christopher Thomas.

MATLAB=matlab
MATFLAGS=-nodisplay -nodesktop -nosplash
MATGUIFLAGS=-nodesktop -nosplash

default:
	@echo "Targets:   run clean force"


force: clean run

clean:
	rm -f output/*

run:
	nice -n +10 $(MATLAB) $(MATFLAGS) \
		-r "dbstop if error; run('do_convert.m'); exit;"

#
# This is the end of the file.

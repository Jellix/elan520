all:
	gnatmake -f -O3 -fomit-frame-pointer -gnatp -gnatwa -gnaty elan520

clean:
	rm -f *.ali *.o *.s

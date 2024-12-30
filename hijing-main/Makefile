all: test.exe

test.exe: hipyset1.35.o hijing1.411.o test.o
	gfortran hipyset1.35.o hijing1.411.o test.o -ffixed-form -o test.exe

hipyset1.35.o: hipyset1.35.f
	gfortran -c hipyset1.35.f

hijing1.411.o: hijing1.411.f
	gfortran -c hijing1.411.f

test.o: test.f
	gfortran -c test.f
clean:
	rm *.o test.exe

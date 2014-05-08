THREADS?=1

default:
	cd R && make -j $(THREADS)
	cd picrust && make

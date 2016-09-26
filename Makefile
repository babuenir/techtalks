sessions = 		\
	u-boot-meetup-sep-2016

all:
	for session in $(sessions); do make -C $$session; done

clean:
	for session in $(sessions); do make -C $$session clean; done

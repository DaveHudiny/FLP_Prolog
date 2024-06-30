all:
	swipl -q -g start -o flp22-log -c db.pl

run:
	make
	./flp22-log

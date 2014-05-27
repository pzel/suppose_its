test:  build
	@chmod +x ./test.rb
	./test.rb

clean:
	@echo "cleaning"
	@rm -f /tmp/suppose_its*
	@rm -f *beam
	@rm -f erl_crash.dump
	@rm -f test_tstamp

build: clean
	@echo "building"
	@./suppose_its /dev/null date > /dev/null 2>&1

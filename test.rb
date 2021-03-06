#!/usr/bin/env ruby

require 'minitest/autorun'
require 'minitest/spec'


describe "suppose_its" do

  it "will print a message if run with no arguments" do
    (run_with "", "").must_match /suppose_its \d+\.\d+\nUsage: echo <date> > <filename> && \.\/suppose_its <filename> <program> \[arg1\] \[arg2\] \.\.\.\n/
  end

  it "will not interpose if timestamp file is missing" do
    given_no_timestamp_file
    (run_with default_timestamp,python_date_command).to_i.
      must_be_within_delta (Time.now.to_i),delta
  end

  it "will interpose if timestamp file contains a timestamp" do
    @fake_time = 1234567890
    given_timestamp_file @fake_time
    (run_with default_timestamp,python_date_command).to_i.
      must_be_within_delta @fake_time, 0
  end

  it "works with the erlang vm" do
    if `which erl`.length > 0
      given_erlang_testfile
      @fake_time = 111111111
      given_timestamp_file @fake_time
      (run_with default_timestamp,erlang_date_command).to_i.
        must_be_within_delta @fake_time, 0
    else
      skip "erlang not available"
    end
  end

end

def delta
  1
end

def default_timestamp
  "./test_tstamp"
end

def given_empty_timestamp_file
  system "echo '' > #{default_timestamp}"
end

def given_erlang_testfile
  `erlc ./erl_test.erl`
end

def given_no_timestamp_file
  system "rm -f #{default_timestamp}"
end

def given_timestamp_file ts
  system "echo #{ts.to_s} > #{default_timestamp}"
end

def python_date_command
  'python -c "import time;  print int(time.time())"'
end

def erlang_date_command
  'erl -noshell -s erl_test run'
end

def run_with filename, args
  `./suppose_its #{filename} '#{args}'`
end

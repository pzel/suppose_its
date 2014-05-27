-module(erl_test).
-export([run/0]).

run() -> io:format("~p~n", [posix(now())]), erlang:halt(0).

posix({Mega, Secs, _}) -> Mega*1000000 + Secs.

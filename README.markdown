A small nif to write to the local syslog daemon inspired by the project [JacobVorreuter/erlang_syslog](http://github.com/JacobVorreuter/erlang_syslog). Patches wanted.

# TODO

 * openlog options
 * tests

# Usage

Easier than you think:

    $ erl -pa /path/to/syslognif/ebin
    1> syslog:open("foo").
    ok
    2> syslog:write(3, "This is a dead parrot!").
    ok
    3> syslog:close().
    ok

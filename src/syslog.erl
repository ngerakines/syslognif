%% Copyright (c) 2010 Nick Gerakines <nick at gerakines dot net>
%% 
%% Permission is hereby granted, free of charge, to any person
%% obtaining a copy of this software and associated documentation
%% files (the "Software"), to deal in the Software without
%% restriction, including without limitation the rights to use,
%% copy, modify, merge, publish, distribute, sublicense, and/or sell
%% copies of the Software, and to permit persons to whom the
%% Software is furnished to do so, subject to the following
%% conditions:
%% 
%% The above copyright notice and this permission notice shall be
%% included in all copies or substantial portions of the Software.
%% 
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
%% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
%% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
%% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
%% HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
%% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
%% OTHER DEALINGS IN THE SOFTWARE.
-module(syslog).
-export([open/1, open/3, write/2, close/0,
         option/1, facility/1, level/1]).
-on_load(on_load/0).

on_load() ->
    Lib = filename:join([
            filename:dirname(code:which(?MODULE)),
            "..",
            "priv",
            ?MODULE
        ]),
    erlang:load_nif(Lib, 0).

open(Ident) ->
    open(Ident, option(pid) bxor option(cons), level(info)).

open(_,_,_) -> erlang:error(not_implemented).

write(_,_) -> erlang:error(not_implemented).

close() -> erlang:error(not_implemented).


% options for openlog()
option(pid) -> 16#01;       % log the pid with each message
option(cons) -> 16#02;      % log on the console if errors in sending
option(odelay) -> 16#04;    % delay open until first syslog() (default)
option(ndelay) -> 16#08;    % don't delay open
option(nowait) -> 16#10;    % don't wait for console forks: DEPRECATED
option(perror) -> 16#20.    % log to stderr as well

%% specify the type of program logging the message
facility(kern) -> 0 bsl 3;      % kernel messages
facility(user) -> 1 bsl 3;      % random user-level messages
facility(mail) -> 2 bsl 3;      % mail system
facility(daemon) -> 3 bsl 3;    % system daemons
facility(auth) -> 4 bsl 3;      % security/authorization messages
facility(syslog) -> 5 bsl 3;    % messages generated internally by syslogd
facility(lpr) -> 6 bsl 3;       % line printer subsystem
facility(news) -> 7 bsl 3;      % network news subsystem
facility(uucp) -> 8 bsl 3;      % UUCP subsystem
facility(cron) -> 9 bsl 3;      % clock daemon
facility(authpriv) -> 10 bsl 3; % security/authorization messages (private)
facility(ftp) -> 11 bsl 3;      % ftp daemon

facility(local0) -> 16 bsl 3;   % reserved for local use
facility(local1) -> 17 bsl 3;   % reserved for local use
facility(local2) -> 18 bsl 3;   % reserved for local use
facility(local3) -> 19 bsl 3;   % reserved for local use
facility(local4) -> 20 bsl 3;   % reserved for local use
facility(local5) -> 21 bsl 3;   % reserved for local use
facility(local6) -> 22 bsl 3;   % reserved for local use
facility(local7) -> 23 bsl 3.   % reserved for local use

%% importance of message
level(emerg) -> 0;
level(alert) -> 1;
level(crit) -> 2;
level(err) -> 3;
level(warning) -> 4;
level(notice) -> 5;
level(info) -> 6;
level(debug) -> 7.

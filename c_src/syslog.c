/*
Copyright (c) 2010 Nick Gerakines <nick at gerakines dot net>
 
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#include "erl_nif.h"

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <err.h>
#include <sys/errno.h>
#include <syslog.h>

#define MAXBUFLEN 1024

static ERL_NIF_TERM nif_open(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
    char facil[MAXBUFLEN];
    if (enif_get_string(env, argv[0], facil, sizeof(facil), ERL_NIF_LATIN1) < 1) {
        return enif_make_badarg(env);
    }
    openlog(facil, LOG_CONS | LOG_PID, 0);
    return enif_make_atom(env, "ok");
}

static ERL_NIF_TERM nif_write(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
    char message[MAXBUFLEN];
    int log_level;
    if (!enif_get_int(env, argv[0], &log_level)) {
        return enif_make_badarg(env);
    }
    if (enif_get_string(env, argv[1], message, sizeof(message), ERL_NIF_LATIN1) < 1) {
        return enif_make_badarg(env);
    }
    syslog(log_level, "%s", message);
    return enif_make_atom(env, "ok");
}

static ERL_NIF_TERM nif_close(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
    closelog();
    return enif_make_atom(env, "ok");
}

static ErlNifFunc nif_funcs[] = {
    {"open", 1, nif_open},
    {"write", 2, nif_write},
    {"close", 0, nif_close}
};

ERL_NIF_INIT(syslog, nif_funcs, NULL, NULL, NULL, NULL)


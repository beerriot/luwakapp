Luwakapp is a demonstration of the
[`external` luwak branch](https://github.com/beerriot/luwak/tree/external),
which uses the
[Riak Erlang client](https://github.com/basho/riak-erlang-client) to
communicate with Riak over Protocol Buffers, instead of expecting code
to run on a Riak node.  The app exposes the same HTTP interface that
Riak used to expose itself.

## Prereqs

You'll need [Riak](http://wiki.basho.com/Riak.html) and Erlang R14B
installed.  You'll also need [rebar](https://github.com/basho/rebar).

## Setup & Run

Clone this repo:

    git clone git://github.com/beerriot/luwakapp

Build the app:

    cd luwakapp
    rebar get-deps compile generate

Edit your config.  In `rel/luwak/etc/`, you'll find `sys.config`.
Change the `riak_ip` and `riak_port` settings to point to one of your
Riak nodes (default `127.0.0.1:8087`).  Also change the `http` and/or
`prefix` settings if you want the interface exposed somewhere other
than `http://localhost:8080/luwak/`.

Start the app:

    rel/luwak/bin/luwak console

(or use `start` instead of `console`, if you'd like it to run in the
background).

# Use

Interacting with this app should be exactly as described on the
[Luwak wiki page](http://wiki.basho.com/Luwak.html).

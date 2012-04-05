%% -------------------------------------------------------------------
%%
%% Copyright (c) 2011 Bryan Fink.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------
-module(luwakapp_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    Webmachines = webmachines(),
    {ok, { {one_for_one, 5, 10}, Webmachines} }.

webmachines() ->
    {ok, Prefix} = application:get_env(luwakapp, prefix),
    {ok, RiakIP} = application:get_env(luwakapp, riak_ip),
    {ok, RiakPort} = application:get_env(luwakapp, riak_port),
    Opts = [{prefix, Prefix}, {ip, RiakIP}, {port, RiakPort}],
    Routing = [{[Prefix], luwakapp_wm_file, Opts},
               {[Prefix, key], luwakapp_wm_file, Opts}],
    
    {ok, HTTP} = application:get_env(luwakapp, http),
    [ webmachine(IP, Port, Routing) || {IP, Port} <- HTTP ].

webmachine(IP, Port, Routing) ->
    Config = [{ip, IP}, {port, Port}, {dispatch, Routing}],
    {webmachine_name(IP, Port),
     {webmachine_mochiweb, start, [Config]},
     permanent, 5000, worker, [mochiweb_socket_server]}.

webmachine_name(IP, Port) ->
    list_to_atom(lists:flatten(["http", IP, ":", integer_to_list(Port)])).

%%======================================================================
%%
%% Leo Redundant Manager
%%
%% Copyright (c) 2012
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
%% ---------------------------------------------------------------------
%% Leo Redundant Manager
%% @doc
%% @end
%%======================================================================
%% Application Name
-define(APP, 'leo_redundant_manager').


%% Error
-define(ERROR_COULD_NOT_GET_RING,     "could not get ring").
-define(ERROR_COULD_NOT_GET_CHECKSUM, "could not get checksum").
-define(ERROR_COULD_NOT_UPDATE_RING,  "could not update ring").

-define(ERR_TYPE_INCONSISTENT_HASH,   inconsistent_hash).
-define(ERR_TYPE_NODE_DOWN,           nodedown).

%% Ring related
-define(TYPE_RING_TABLE_ETS,    'ets').
-define(TYPE_RING_TABLE_MNESIA, 'mnesia').
-define(CUR_RING_TABLE,         'ring_cur').
-define(PREV_RING_TABLE,        'ring_prv').

-type(ring_table_type() :: ?TYPE_RING_TABLE_ETS | ?TYPE_RING_TABLE_MNESIA).
-type(ring_table_info() :: {ring_table_type(), ?CUR_RING_TABLE} |
                           {ring_table_type(), ?PREV_RING_TABLE}).


%% Checksum
-define(CHECKSUM_RING,          'ring').
-define(CHECKSUM_MEMBER,        'member').

-type(checksum_type()   :: ?CHECKSUM_RING  | ?CHECKSUM_MEMBER).


%% Default
-define(MD5, 128).
-define(DEF_OPT_N, 1).
-define(DEF_OPT_R, 1).
-define(DEF_OPT_W, 1).
-define(DEF_OPT_D, 1).
-define(DEF_OPT_BIT_OF_RING, ?MD5).
-define(DEF_NUMBER_OF_VNODES, 64).


%% Node State
%%
-define(STATE_IDLING,    'idling').
-define(STATE_ATTACHED,  'attached').
-define(STATE_DETACHED,  'detached').
-define(STATE_SUSPEND,   'suspend').
-define(STATE_RUNNING,   'running').
-define(STATE_DOWNED,    'downed').
-define(STATE_STOP,      'stop').
-define(STATE_RESTARTED, 'restarted').

-type(node_state() :: ?STATE_IDLING   |
                      ?STATE_ATTACHED |
                      ?STATE_DETACHED |
                      ?STATE_SUSPEND  |
                      ?STATE_RUNNING  |
                      ?STATE_DOWNED   |
                      ?STATE_STOP     |
                      ?STATE_RESTARTED).


%% Property
%%
-define(PROP_SERVER_TYPE,   'server_type').
-define(PROP_MANAGERS,      'managers').
-define(PROP_NOTIFY_MF,     'notify_mf').
-define(PROP_SYNC_MF,       'sync_mf').
-define(PROP_OPTIONS,       'options').
-define(PROP_MEMBERS,       'members').
-define(PROP_RING_HASH,     'ring_hash').
-define(PROP_CUR_RING_TBL,  'cur_ring_table').
-define(PROP_PREV_RING_TBL, 'prev_ring_table').


%% Version
%%
-define(VER_CURRENT, 'cur' ).
-define(VER_PREV,    'prev').


%% Synchronization
%%
-define(SYNC_MODE_BOTH,      'both_rings').
-define(SYNC_MODE_MEMBERS,   'members').
-define(SYNC_MODE_CUR_RING,  'ring_cur').
-define(SYNC_MODE_PREV_RING, 'ring_prev').

-type(sync_mode() :: ?SYNC_MODE_BOTH | ?SYNC_MODE_MEMBERS |
                     ?SYNC_MODE_CUR_RING | ?SYNC_MODE_PREV_RING).


%% Server Type
%%
-define(SERVER_MANAGER, 'manager').
-define(SERVER_GATEWAY, 'gateway').
-define(SERVER_STORAGE, 'storage').


%% Dump File
%%
-define(DUMP_FILE_MEMBERS,   "./log/ring/members.dump.").
-define(DUMP_FILE_RING_CUR,  "./log/ring/ring_cur.dump.").
-define(DUMP_FILE_RING_PREV, "./log/ring/ring_prv.dump.").


%% Record
%%
-record(node_state, {
          node                 :: atom(),
          state                :: atom(),
          ring_hash_new = "-1" :: string(),
          ring_hash_old = "-1" :: string(),
          when_is   = 0        :: integer(),
          error     = 0        :: integer()
         }).

-record(redundancies,
        {id = -1               :: integer(),
         vnode_id = -1         :: integer(), %% virtual-node-id
         temp_nodes  = []      :: list(),    %% tempolary objects of redundant-nodes
         nodes       = []      :: list(),    %% objects of redundant-nodes
         n = 0                 :: integer(), %% # of replicas
         r = 0                 :: integer(), %% # of successes of READ
         w = 0                 :: integer(), %% # of successes of WRITE
         d = 0                 :: integer(), %% # of successes of DELETE
         ring_hash             :: integer()  %% ring-hash when writing an object
        }).

-record(ring,
        {vnode_id = -1         :: integer(),
         node                  :: atom()
        }).

-record(member,
        {node                  :: atom(),
         clock = 0             :: integer(),
         state = null          :: atom(),
         num_of_vnodes = ?DEF_NUMBER_OF_VNODES :: integer()
        }).




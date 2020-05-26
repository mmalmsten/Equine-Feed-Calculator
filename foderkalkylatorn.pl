:- use_module(library(http/json)).
:- use_module(library(csv)).

:- use_module(library(http/websocket)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_files)).

:- initialization(start).

:- http_handler('/ws', http_upgrade_to_websocket(ws, []), [spawn([])]).
:- http_handler('/', http_reply_from_files('.', []), [prefix]).

update_horse(Id, Data) :-
    horse(Id, Dict),
    retractall(horse(Id, _)), 
    asserta(horse(Id, Dict.put(Data))).

start :- http_server(http_dispatch, [port(3000)]).

%-------------------------------------------------------------------------------
%
%-------------------------------------------------------------------------------
ws(WebSocket) :-
    ws_receive(WebSocket, Message),
    (Message.opcode == close -> true ; 
    
        % Create Id
        get_time(Time), 
        random_between(1000000, 1000000000000, R), 
        Id is Time * R,

        atom_string(Atom, Message.data),
        atom_json_dict(Atom, Dict, []),
        asserta(horse(Id, Dict)),
        consult(nutrition), nutrition(Id), !,
        consult(feed), feed(Id),
        horse(Id, Result),
        atom_json_dict(Json, Result, []),
        atom_string(Json, Json1),
    	ws_send(WebSocket, text(Json1)),
        ws(WebSocket)
    ).
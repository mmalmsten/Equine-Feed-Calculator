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

nutrition(Dict, Energy2, Protein, Calcium, Phosphorus, Magnesium) :-
    consult(nutrition),
    energy(Dict.age, Dict.weight, Energy),
    additional(Dict.stallion, Energy, E1),
    additional(Dict.group, Energy, E2),
    training(Dict.walk, Dict.trotCanter, Dict.weight, E3),
    Energy2 is Energy + E1 + E2 + E3,
    protein(Dict.age, Energy2, Protein),
    Training is (E3 / Energy),
    calcium(Dict.age, Dict.weight, Training, Calcium),
    phosphorus(Dict.age, Dict.weight, Training, Phosphorus),
    magnesium(Dict.age, Dict.weight, Training, Magnesium).

start :- http_server(http_dispatch, [port(80)]).

ws(WebSocket) :-
    ws_receive(WebSocket, Message),
    (Message.opcode == close ->  true ;   
        atom_string(Atom, Message.data),
        atom_json_dict(Atom, Dict, []),
        nutrition(Dict, Energy, Protein, Calcium, Phosphorus, Magnesium), !,
        format('~p~n',[[Energy, Protein, Calcium, Phosphorus, Magnesium]]),
        consult(feed),
        feed(Dict, Energy, Protein, Calcium, Phosphorus, Magnesium, [[hay, Amount], [Amount1, Name1], [Amount2, Name2]], Energy1, Protein1, Calcium1, Phosphorus1, Magnesium1),
        dict_create(Need, need, [ca:Calcium, mg:Magnesium, mj:Energy, p:Phosphorus, smbrp:Protein]),
        dict_create(Intake, intake, [ca:Calcium1, mg:Magnesium1, mj:Energy1, p:Phosphorus1, smbrp:Protein1]),
        dict_create(Food, food, [Name1:Amount1, Name2:Amount2]),
        dict_create(Result, result, [hay:Amount, food:Food, need:Need, intake:Intake]),
        % Result = _{Name1:Amount1, Name2:Amount2, hay:Amount, intake:_{ca:Calcium1, mg:Magnesium1, mj:Energy1, p:Phosphorus1, smbrp:Protein1}, need:_{ca:Calcium, mg:Magnesium, mj:Energy, p:Phosphorus, smbrp:Protein}},
        atom_json_dict(Json, Result, []),
        atom_string(Json, Json1),
        format('~p~n',[Json1]),
    	ws_send(WebSocket, text(Json1)),
        ws(WebSocket)
    ).

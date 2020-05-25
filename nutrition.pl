nutrition(Id) :-
    mj(Id, Mj), update_horse(Id, Mj),
    smbrp(Id, SmbRp), update_horse(Id, SmbRp),
    ca(Id, Ca), update_horse(Id, Ca),
    p(Id, P), update_horse(Id, P),
    mg(Id, Mg), update_horse(Id, Mg).

%-------------------------------------------------------------------------------
% Energy need
%-------------------------------------------------------------------------------
mj(Id, [mj=Result,trainingMj=Training]) :- 
    horse(Id, Dict),
    mj_age(Dict.age, Factor), 
    pow(Dict.weight, 0.75, Pow), 
    Mj is Factor * Pow,
    mj_extra(Dict.stallion, Mj, Mj1),
    mj_extra(Dict.group, Mj, Mj2),
    mj_training(Id, Mj3),
    Result is Mj + Mj1 + Mj2 + Mj3,
    Training is Mj3 / Mj.

% Energy need based on age
mj_age(Age, 0.63) :- Age =< 6.
mj_age(Age, 0.59) :- Age =< 12.
mj_age(Age, 0.57) :- Age =< 36.
mj_age(_, 0.5).

% +10% energy need based on extra
mj_extra(false, _, 0).
mj_extra(_, Mj, (Mj * 0.1)).

% Energy need based on training
mj_training(Id, Mj) :-
    horse(Id, Dict),
    Mj is ((Dict.walk * 0.02 * (Dict.weight / 100)) + 
        (Dict.trotCanter * 0.13 * (Dict.weight / 100))).

%-------------------------------------------------------------------------------
% Protein need
%-------------------------------------------------------------------------------
smbrp(Id, [smbRp=SmbRp]) :- 
    horse(Id, Dict), smbrp_age(Dict.age, Factor), SmbRp is Dict.mj * Factor.

% Protein need based on age
smbrp_age(Age, 13) :- Age =< 4.
smbrp_age(Age, 10) :- Age =< 6.
smbrp_age(Age, 8.5) :- Age =< 12.
smbrp_age(Age, 7) :- Age =< 18.
smbrp_age(Age, 6.5) :- Age =< 36.
smbrp_age(_, 6).

%-------------------------------------------------------------------------------
% Calcium need
%-------------------------------------------------------------------------------
ca(Id, [ca=Ca]) :- 
    horse(Id, Dict), 
    (ca_age(Dict.age, Factor) ; ca_training(Dict.trainingMj, Factor)),
    Ca is Factor * (Dict.weight / 100).

% Calcium need based on age
ca_age(Age, 17.2) :- Age =< 6.
ca_age(Age, 10.3) :- Age =< 12.
ca_age(Age, 7.5) :- Age =< 24.
ca_age(Age, 6.2) :- Age =< 36.

% Calcium need based on training
ca_training(0, 4).
ca_training(Training, 8) :- Training >= 0.50.
ca_training(Training, 7) :- Training >= 0.30.
ca_training(_, 6).

%-------------------------------------------------------------------------------
% Phosphorus need
%-------------------------------------------------------------------------------
p(Id, [p=P]) :-
    horse(Id, Dict),
    (p_age(Dict.age, Factor) ; p_training(Dict.trainingMj, Factor)),
    P is Factor * (Dict.weight / 100).

% Phosphorus need based on age
p_age(Age, 9.6) :- Age =< 6.
p_age(Age, 5.7) :- Age =< 12.
p_age(Age, 4.2) :- Age =< 24.
p_age(Age, 3.4) :- Age =< 36.

% Phosphorus need based on training
p_training(0, 2.8).
p_training(Training, 5.8) :- Training >= 0.50.
p_training(Training, 4.2) :- Training >= 0.30.
p_training(_, 3.6).

%-------------------------------------------------------------------------------
% Magnesium need
%-------------------------------------------------------------------------------
mg(Id, [mg=Mg]) :-
    horse(Id, Dict),
    (mg_age(Dict.age, Factor) ; mg_training(Dict.trainingMj, Factor)),
    Mg is Factor * (Dict.weight / 100).

% Magnesium need based on age
mg_age(Age, 1.2) :- Age =< 6.
mg_age(Age, 1.7) :- Age =< 12.
mg_age(Age, 1.6) :- Age =< 24.
mg_age(Age, 1.5) :- Age =< 36.

% Magnesium need based on training
mg_training(0, 1.5).
mg_training(Training, 3) :- Training >= 0.50.
mg_training(Training, 2.3) :- Training >= 0.30.
mg_training(_, 1.9).

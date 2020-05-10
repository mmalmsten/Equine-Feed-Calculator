hay(Dict, {Energy, Protein, Calcium, Phosphorus, Magnesium}, Amount, {Energy1, Protein1, Calcium1, Phosphorus1, Magnesium1}) :-
    numlist(1, 10, L), reverse(L, L1), member(Amount, L1),
    Amount >= (Dict.weight / 100) / Dict.hay.ts,
    Energy1 is Energy - Dict.hay.energy * Amount * Dict.hay.ts,
    Energy1 >= 0,
    Protein1 is Protein - Dict.hay.protein * Amount * Dict.hay.ts,
    Calcium1 is Calcium - Dict.hay.calcium * Amount * Dict.hay.ts,
    Phosphorus1 is Phosphorus - Dict.hay.phosphorus * Amount * Dict.hay.ts,
    Magnesium1 is Magnesium - Dict.hay.magnesium * Amount * Dict.hay.ts.

grains({Energy, Protein, Calcium, Phosphorus, Magnesium}, [[Amount1, Name1], [Amount2, Name2]], {Energy1, Protein1, Calcium1, Phosphorus1, Magnesium1}) :-
    csv_read_file('krafft.csv', Feed, [functor(feed)]),
    member(feed(Name1,Ts1,FEn1,FPr1,_FL1,FCs1,FP1,FM1), Feed),
    member(feed(Name2,Ts2,FEn2,FPr2,_FL2,FCs2,FP2,FM2), Feed),
    numlist(0, 20, L), member(Amount1, L), member(Amount2, L),
    (Name1 \= Name2 ; Amount1 = 0),
    Energy1 is Energy - (Amount1 * (FEn1 / 10)) - (Amount2 * (FEn2 / 10)),
    Energy1 > -5, 
    Energy1 < 5,
    Protein1 is Protein - (Amount1 * (FPr1 / 10)) - (Amount2 * (FPr2 / 10)),
    Protein1 =< 0,
    Calcium1 is Calcium - (Amount1 * (FCs1 / 10)) - (Amount2 * (FCs2 / 10)),
    Calcium1 < 0,
    Phosphorus1 is Phosphorus - (Amount1 * (FP1 / 10)) - (Amount2 * (FP2 / 10)),
    Phosphorus1 < 0,
    Magnesium1 is Magnesium - (Amount1 * (FM1 / 10)) - (Amount2 * (FM2 / 10)),
    Magnesium1 < 0.

feed(Dict, Energy, Protein, Calcium, Phosphorus, Magnesium, [[hay, Amount], [Amount1, Name1], [Amount2, Name2]], Energy3, Protein3, Calcium3, Phosphorus3, Magnesium3) :-
    hay(Dict, {Energy, Protein, Calcium, Phosphorus, Magnesium}, Amount, {Energy1, Protein1, Calcium1, Phosphorus1, Magnesium1}),
    % format('~p kg hay~n',[Amount]),
    grains({Energy1, Protein1, Calcium1, Phosphorus1, Magnesium1}, [[Amount1, Name1], [Amount2, Name2]], {Energy2, Protein2, Calcium2, Phosphorus2, Magnesium2}),
    Energy3 is Energy - Energy2,
    Protein3 is Protein - Protein2,
    Calcium3 is Calcium - Calcium2,
    Phosphorus3 is Phosphorus - Phosphorus2,
    Magnesium3 is Magnesium - Magnesium2,
    Calcium3 / Phosphorus3 > 1.1,
    Protein3 / Energy3 > 6.
    % format('Energy ~p~n',[[Energy, Energy3]]),
    % format('Protein ~p~n',[[Protein, Protein3]]),
    % format('Calcium ~p~n',[[Calcium, Calcium3]]),
    % format('Phosphorus ~p~n',[[Phosphorus, Phosphorus3]]),
    % format('Magnesium ~p~n',[[Magnesium, Magnesium3]]),

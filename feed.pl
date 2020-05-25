feed(Id) :-
    findnsols(1000, {HayKg1, Amount, Grains}, (
        hay(Id, Hay), 
        grains(Id, Hay, Grains), 
        member(kg=HayKg, Hay), HayKg1 is 0 - HayKg,
        Amount = Grains.totalGrain
    ), Bag),
    sort(Bag, Bag1), [{HayK,_,Grain}|_] = Bag1, HayK1 is 0 - HayK,
    update_horse(Id, [haykg=HayK1, grains=Grain]).

%-------------------------------------------------------------------------------
% Amount of hay
%-------------------------------------------------------------------------------
hay(Id, [kg=Kg, mj=Mj, smbrp=SmbRp, ca=Ca, p=P, mg=Mg]) :-
    horse(Id, Dict),
    % Hay amounts
    Max is ceil(5 * (Dict.weight / 100) / Dict.hay.ts),
    Min is floor((Dict.weight / 100) / Dict.hay.ts),
    numlist(Min, Max, L), reverse(L, L1), member(Kg, L1),
    % Aggregate
    Mj is Dict.hay.mj * Kg * Dict.hay.ts, Mj =< Dict.mj,
    SmbRp is Dict.hay.smbrp * Kg * Dict.hay.ts,
    Ca is Dict.hay.ca * Kg * Dict.hay.ts,
    P is Dict.hay.p * Kg * Dict.hay.ts,
    Mg is Dict.hay.mg * Kg * Dict.hay.ts.


%-------------------------------------------------------------------------------
% Find combination of grains
%-------------------------------------------------------------------------------
grains(Id, [kg=_, mj=HayMj, smbrp=HaySmbRp, ca=HayCa, p=HayP, mg=HayMg], Grains) :-
    horse(Id, Dict),
    csv_read_file('svenskafoder.csv', Feed1, [functor(feed)]),
    csv_read_file('granngarden.csv', Feed2, [functor(feed)]),
    csv_read_file('krafft.csv', Feed3, [functor(feed)]),
    flatten([Feed1, Feed2, Feed3], Feed),
    % Find 3 feeds
    numlist(0, 20, L),
    member(feed(Name1, Mj1, SmbRp1, _FL1, Ca1, P1, Mg1, MaxAmount1), Feed), member(Hg1, L),
    member(feed(Name2, Mj2, SmbRp2, _FL2, Ca2, P2, Mg2, MaxAmount2), Feed), member(Hg2, L),
    (Name1 \= Name2 ; Hg2 = 0),
    member(feed(Name3, Mj3, SmbRp3, _FL3, Ca3, P3, Mg3, MaxAmount3), Feed), member(Hg3, L),
    (Name1 \= Name3, Name2 \= Name3 ; Hg3 = 0),
    Kg1 is Hg1/10, Kg2 is Hg2/10, Kg3 is Hg3/10,

    % Ensure not too much
    Kg1 =< MaxAmount1 * (Dict.weight / 100),
    Kg2 =< MaxAmount2 * (Dict.weight / 100),
    Kg3 =< MaxAmount3 * (Dict.weight / 100),
    TotalGrain is Hg1 + Hg2 + Hg3,
    TotalGrain =< (0.4 * (Dict.weight / 100) * 5) * 10,
    
    % Aggregate
    Mj is HayMj + (Mj1 * Kg1) + (Mj2 * Kg2) + (Mj3 * Kg3),
    Mj > Dict.mj - 2, Mj < Dict.mj + 2,

    SmbRp is HaySmbRp + (SmbRp1 * Kg1) + (SmbRp2 * Kg2) + (SmbRp3 * Kg3),
    SmbRp > Dict.smbRp,
    % ((HaySmbRp > Dict.smbRp, SmbRpMax is HaySmbRp * 1.5) ; SmbRpMax is Dict.smbRp * 1.5),
    % SmbRp < SmbRpMax,
    SmbRp / Mj > 6,

    Ca is HayCa + (Ca1 * Kg1) + (Ca2 * Kg2) + (Ca3 * Kg3), Ca > Dict.ca,
    P is HayP + (P1 * Kg1) + (P2 * Kg2) + (P3 * Kg3), P > Dict.p,
    Ca / P > 1.1,
    HayMg + (Mg1 * Kg1) + (Mg2 * Kg2) + (Mg3 * Kg3) > Dict.mg,
    
    dict_create(Grain1, _, [hg=Hg1, name=Name1, mj=Mj1, smbrp=SmbRp1, ca=Ca1, p=P1, mg=Mg1]),
    dict_create(Grain2, _, [hg=Hg2, name=Name2, mj=Mj2, smbrp=SmbRp2, ca=Ca2, p=P2, mg=Mg2]),
    dict_create(Grain3, _, [hg=Hg3, name=Name3, mj=Mj3, smbrp=SmbRp3, ca=Ca3, p=P3, mg=Mg3]),
    dict_create(Grains, grains, [totalGrain = TotalGrain, grain1=Grain1, grain2=Grain2, grain3=Grain3]).
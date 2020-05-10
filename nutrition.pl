energy(Age, Weight, Energy) :- Age =< 6, pow(Weight, 0.75, Pow), Energy is 0.63 * Pow.
energy(Age, Weight, Energy) :- Age =< 12, pow(Weight, 0.75, Pow), Energy is 0.59 * Pow.
energy(Age, Weight, Energy) :- Age =< 36, pow(Weight, 0.75, Pow), Energy is 0.57 * Pow.
energy(_, Weight, Energy) :- pow(Weight, 0.75, Pow), Energy is 0.5 * Pow.
    
additional(false, _, 0).
additional(_, Energy, (Energy * 0.1)).

training(Walk, TrotCanter, Weight, Energy) :- 
    Energy is ((Walk * 0.02 * (Weight / 100)) + (TrotCanter * 0.13 * (Weight / 100))).

protein(Age, Energy, Protein) :- Age =< 4, Protein is Energy * 13.
protein(Age, Energy, Protein) :- Age =< 6, Protein is Energy * 10.
protein(Age, Energy, Protein) :- Age =< 12, Protein is Energy * 8.5.
protein(Age, Energy, Protein) :- Age =< 18, Protein is Energy * 7.
protein(Age, Energy, Protein) :- Age =< 36, Protein is Energy * 6.5.
protein(_, Energy, Protein) :- Protein is Energy * 6.

calcium(Age, Weight, _, Calcium) :- Age =< 6, Calcium is 17.2 * (Weight / 100).
calcium(Age, Weight, _, Calcium) :- Age =< 12, Calcium is 10.3 * (Weight / 100).
calcium(Age, Weight, _, Calcium) :- Age =< 24, Calcium is 7.5 * (Weight / 100).
calcium(Age, Weight, _, Calcium) :- Age =< 36, Calcium is 6.2 * (Weight / 100).
calcium(_, Weight, 0, Calcium) :- Calcium is 4 * (Weight / 100).
calcium(_, Weight, Training, Calcium) :- Training >= 0.50, Calcium is 8 * (Weight / 100).
calcium(_, Weight, Training, Calcium) :- Training >= 0.30, Calcium is 7 * (Weight / 100).
calcium(_, Weight, _, Calcium) :- Calcium is 6 * (Weight / 100).

phosphorus(Age, Weight, _, Phosphorus) :- Age =< 6, Phosphorus is 9.6 * (Weight / 100).
phosphorus(Age, Weight, _, Phosphorus) :- Age =< 12, Phosphorus is 5.7 * (Weight / 100).
phosphorus(Age, Weight, _, Phosphorus) :- Age =< 24, Phosphorus is 4.2 * (Weight / 100).
phosphorus(Age, Weight, _, Phosphorus) :- Age =< 36, Phosphorus is 3.4 * (Weight / 100).
phosphorus(_, Weight, 0, Phosphorus) :- Phosphorus is 2.8 * (Weight / 100).
phosphorus(_, Weight, Training, Phosphorus) :- Training >= 0.50, Phosphorus is 5.8 * (Weight / 100).
phosphorus(_, Weight, Training, Phosphorus) :- Training >= 0.30, Phosphorus is 4.2 * (Weight / 100).
phosphorus(_, Weight, _, Phosphorus) :- Phosphorus is 3.6 * (Weight / 100).

magnesium(Age, Weight, _, Magnesium) :- Age =< 6, Magnesium is 1.2 * (Weight / 100).
magnesium(Age, Weight, _, Magnesium) :- Age =< 12, Magnesium is 1.7 * (Weight / 100).
magnesium(Age, Weight, _, Magnesium) :- Age =< 24, Magnesium is 1.6 * (Weight / 100).
magnesium(Age, Weight, _, Magnesium) :- Age =< 36, Magnesium is 1.5 * (Weight / 100).
magnesium(_, Weight, 0, Magnesium) :- Magnesium is 1.5 * (Weight / 100).
magnesium(_, Weight, Training, Magnesium) :- Training >= 0.50, Magnesium is 3 * (Weight / 100).
magnesium(_, Weight, Training, Magnesium) :- Training >= 0.30, Magnesium is 2.3 * (Weight / 100).
magnesium(_, Weight, _, Magnesium) :- Magnesium is 1.9 * (Weight / 100).
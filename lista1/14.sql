SELECT
    level "Poziom",
    pseudo "Pseudonim",
    funkcja "Funkcja",
    nr_bandy "Nr bandy"
FROM Kocury
WHERE plec = 'M'
CONNECT BY PRIOR pseudo = szef
START WITH funkcja = 'BANDZIOR';
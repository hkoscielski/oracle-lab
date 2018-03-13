SELECT
    nr_bandy "Nr bandy",
    plec "Plec",
    MIN(NVL(przydzial_myszy, 0)) "Minimalny przydzial"
FROM Kocury
GROUP BY 
    nr_bandy,
    plec;
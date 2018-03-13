SELECT 
    'Liczba kotow=' " ",
    COUNT(*) " ",
    'lowi jako' " ",
    funkcja " ",
    'i zjada max.' " ",
    TO_CHAR(MAX(NVL(PRZYDZIAL_MYSZY, 0) + NVL(MYSZY_EXTRA, 0)), '90.00') " ",
    'myszy miesiecznie' " "
FROM Kocury
WHERE 
    funkcja != 'SZEFUNIO'
    AND plec != 'M'
GROUP BY funkcja
HAVING AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) > 50;
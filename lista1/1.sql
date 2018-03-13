SELECT 
    imie_wroga "WROG",
    opis_incydentu "PRZEWINA"
FROM Wrogowie_Kocurow
WHERE EXTRACT(YEAR FROM data_incydentu) = 2009;
    
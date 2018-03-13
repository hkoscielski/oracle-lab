SELECT 
    imie,
    w_stadku_od "W stadku",
    ROUND(przydzial_myszy/1.1) "Zjadal",
    ADD_MONTHS(w_stadku_od, 6) "Podwyzka",
    przydzial_myszy "Zjada"
FROM Kocury
WHERE 
    MONTHS_BETWEEN(SYSDATE, w_stadku_od)/12 >= 8
    AND EXTRACT(MONTH FROM w_stadku_od) BETWEEN 3 AND 9;
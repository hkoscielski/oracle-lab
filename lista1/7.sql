SELECT 
    imie,
    NVL(przydzial_myszy * 3, 0) "MYSZY KWARTALNIE",
    NVL(myszy_extra * 3, 0) "KWARTALNE DODATKI"
FROM Kocury
WHERE 
    NVL(przydzial_myszy, 0) > 2 * NVL(myszy_extra, 0)
    AND przydzial_myszy >= 55;
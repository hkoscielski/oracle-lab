SELECT 
    pseudo "Pseudonim",
    COUNT(imie_wroga) "Liczba wrogow"
FROM Wrogowie_Kocurow
GROUP BY pseudo
HAVING COUNT(imie_wroga) >= 2;
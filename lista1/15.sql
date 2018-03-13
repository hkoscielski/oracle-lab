SELECT
    LPAD(level - 1, (level - 1) * 4 + 1, '===>') || '           ' || imie "Hierarchia",
    NVL(szef, 'Sam sobie panem') "Pseudo szefa",
    funkcja 
FROM Kocury
WHERE NVL(myszy_extra, 0) > 0
CONNECT BY PRIOR pseudo = szef
START WITH szef IS NULL;

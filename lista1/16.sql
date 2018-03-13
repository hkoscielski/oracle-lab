SELECT
    RPAD(' ', 4 * (level - 1)) || pseudo "Droga sluzbowa"    
FROM Kocury    
CONNECT BY PRIOR szef = pseudo
START WITH
    plec = 'M'       
    AND MONTHS_BETWEEN(SYSDATE, w_stadku_od)/12 > 8
    AND NVL(myszy_extra, 0) = 0;
    



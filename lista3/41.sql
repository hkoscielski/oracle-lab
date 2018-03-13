--Zad. 41. Zdefiniowaæ wyzwalacz, który zapewni, ¿e numer nowej bandy bêdzie zawsze wiêkszy o 1 
--od najwy¿szego numeru istniej¹cej ju¿ bandy. Sprawdziæ dzia³anie wyzwalacza wykorzystuj¹c procedurê z zadania 40.

CREATE OR REPLACE TRIGGER o_1_wiekszy
BEFORE INSERT ON Bandy
FOR EACH ROW
BEGIN
    SELECT MAX(nr_bandy) + 1 INTO :new.nr_bandy FROM Bandy;
END;

BEGIN
    wstaw_nowa_bande(10, 'LAPACZE', 'GORY');
END;

SELECT * FROM Bandy;

ROLLBACK;
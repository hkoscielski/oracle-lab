--Zad. 41. Zdefiniowa� wyzwalacz, kt�ry zapewni, �e numer nowej bandy b�dzie zawsze wi�kszy o 1 
--od najwy�szego numeru istniej�cej ju� bandy. Sprawdzi� dzia�anie wyzwalacza wykorzystuj�c procedur� z zadania 40.

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
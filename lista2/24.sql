--Zad. 24. Znale�� bandy, kt�re nie posiadaj� cz�onk�w. 
--Wy�wietli� ich numery, nazwy i tereny operowania. Zadanie rozwi�za� na dwa sposoby: 
--bez podzapyta� i operator�w zbiorowych oraz wykorzystuj�c operatory zbiorowe.
--
--NR BANDY  NAZWA                TEREN
----------- -------------------- ---------------
--        5 ROCKERSI             ZAGRODA

--a. bez podzapyta� i operator�w zbiorowych

SELECT
  nr_bandy "NR BANDY",
  nazwa,
  teren
FROM Kocury RIGHT JOIN Bandy USING(nr_bandy)
WHERE pseudo IS NULL;

--b. wykorzystuj�c operatory zbiorowe
SELECT nr_bandy, nazwa, teren FROM Bandy
MINUS
SELECT nr_bandy, nazwa, teren FROM Kocury JOIN Bandy USING(nr_bandy);

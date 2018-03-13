--Zad. 24. ZnaleŸæ bandy, które nie posiadaj¹ cz³onków. 
--Wyœwietliæ ich numery, nazwy i tereny operowania. Zadanie rozwi¹zaæ na dwa sposoby: 
--bez podzapytañ i operatorów zbiorowych oraz wykorzystuj¹c operatory zbiorowe.
--
--NR BANDY  NAZWA                TEREN
----------- -------------------- ---------------
--        5 ROCKERSI             ZAGRODA

--a. bez podzapytañ i operatorów zbiorowych

SELECT
  nr_bandy "NR BANDY",
  nazwa,
  teren
FROM Kocury RIGHT JOIN Bandy USING(nr_bandy)
WHERE pseudo IS NULL;

--b. wykorzystuj¹c operatory zbiorowe
SELECT nr_bandy, nazwa, teren FROM Bandy
MINUS
SELECT nr_bandy, nazwa, teren FROM Kocury JOIN Bandy USING(nr_bandy);

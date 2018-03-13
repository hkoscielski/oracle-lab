--Zad. 21. Okre�li� ile kot�w w ka�dej z band posiada wrog�w.
--
--Nazwa bandy          Koty z wrogami
---------------------- --------------
--SZEFOSTWO                         3
--BIALI LOWCY                       3
--CZARNI RYCERZE                    5
--LACIACI MYSLIWI                   4

SELECT 
  nazwa "Nazwa bandy",
  COUNT(DISTINCT pseudo) "Koty z wrogami"
FROM 
  Kocury JOIN Bandy USING(nr_bandy)
  JOIN Wrogowie_Kocurow USING(pseudo)
GROUP BY nazwa;
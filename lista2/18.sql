--Zad. 18. Wy�wietli� bez stosowania podzapytania imiona i daty przyst�pienia do stada kot�w, 
--kt�re przyst�pi�y do stada przed kotem o imieniu �JACEK�. 
--Wyniki uporz�dkowa� malej�co wg daty przyst�pienia do stadka.
--
--IMIE            POLUJE OD
----------------- ----------
--MELA            2008-11-01
--KSAWERY         2008-07-12
--BELA            2008-02-01
--PUNIA           2008-01-01
--PUCEK           2006-10-15
--RUDA            2006-09-17
--BOLEK           2006-08-15
--ZUZIA           2006-07-21
--KOREK           2004-03-16
--CHYTRY          2002-05-05
--MRUCZEK         2002-01-01

SELECT 
  K1.imie,
  K1.w_stadku_od "POLUJE OD"
FROM Kocury K1 JOIN Kocury K2 ON K2.imie='JACEK'
WHERE K1.w_stadku_od < K2.w_stadku_od
ORDER BY K1.w_stadku_od DESC; 

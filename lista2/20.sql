--Zad. 20. Wyœwietliæ imiona wszystkich kotek, które uczestniczy³y w incydentach po 01.01.2007. 
--Dodatkowo wyœwietliæ nazwy band do których nale¿¹ kotki, imiona ich wrogów wraz ze stopniem wrogoœci oraz datê incydentu.

--Imie kotki      Nazwa bandy          Imie wroga      Ocena wroga Data inc.
----------------- -------------------- --------------- ----------- ----------
--BELA            CZARNI RYCERZE       DZIKI BILL               10 2008-12-12
--BELA            CZARNI RYCERZE       KAZIO                    10 2009-01-07
--LATKA           LACIACI MYSLIWI      SWAWOLNY DYZIO            7 2011-07-14
--MELA            LACIACI MYSLIWI      KAZIO                    10 2009-02-07
--PUNIA           BIALI LOWCY          BUREK                     4 2010-12-14
--RUDA            SZEFOSTWO            CHYTRUSEK                 5 2007-03-07
--SONIA           BIALI LOWCY          SMUKLA                    1 2010-11-19

SELECT
  imie "Imie kotki",
  nazwa "Nazwa bandy",
  imie_wroga "Imie wroga",
  stopien_wrogosci "Ocena wroga",
  data_incydentu "Data inc."
FROM 
  Kocury JOIN Bandy USING(nr_bandy)
  JOIN Wrogowie_Kocurow USING(pseudo)
  JOIN Wrogowie USING(imie_wroga)
WHERE 
  plec = 'D'
  AND data_incydentu > '2007-01-01';

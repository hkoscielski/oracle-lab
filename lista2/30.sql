--Zad. 30. Wygenerowaæ listê kotów z zaznaczonymi kotami o najwy¿szym i o najni¿szym sta¿u w swoich bandach. 
--Zastosowaæ operatory zbiorowe.
--
--IMIE       WSTAPIL DO STADKA
------------ ----------------- -------------------------------------------
--BARI         2009-09-01 <--- NAJMLODSZY STAZEM W BANDZIE CZARNI RYCERZE
--BELA         2008-02-01
--BOLEK        2006-08-15
--CHYTRY       2002-05-05
--DUDEK        2011-05-15 <--- NAJMLODSZY STAZEM W BANDZIE LACIACI MYSLIWI
--JACEK        2008-12-01
--KOREK        2004-03-16 <--- NAJSTARSZY STAZEM W BANDZIE BIALI LOWCY
--KSAWERY      2008-07-12
--LATKA        2011-01-01
--LUCEK        2010-03-01
--MELA         2008-11-01
--MICKA        2009-10-14 <--- NAJMLODSZY STAZEM W BANDZIE SZEFOSTWO
--MRUCZEK      2002-01-01 <--- NAJSTARSZY STAZEM W BANDZIE SZEFOSTWO
--PUCEK        2006-10-15 <--- NAJSTARSZY STAZEM W BANDZIE LACIACI MYSLIWI
--PUNIA        2008-01-01
--RUDA         2006-09-17
--SONIA        2010-11-18 <--- NAJMLODSZY STAZEM W BANDZIE BIALI LOWCY
--ZUZIA        2006-07-21 <--- NAJSTARSZY STAZEM W BANDZIE CZARNI RYCERZE

SELECT 
    imie,
    TO_CHAR(w_stadku_od) "WSTAPIL DO STADKA",
    ' ' " "
FROM Kocury K1
WHERE 
    w_stadku_od != (SELECT MAX(w_stadku_od) FROM Kocury WHERE nr_bandy = K1.nr_bandy)
    AND w_stadku_od != (SELECT MIN(w_stadku_od) FROM Kocury WHERE nr_bandy = K1.nr_bandy)
    
UNION ALL

SELECT 
    imie,
    w_stadku_od || ' <---' "WSTAPIL DO STADKA",
    'NAJMLODSZY STAZEM W BANDZIE ' || nazwa
FROM Kocury K1 JOIN Bandy B ON K1.nr_bandy = B.nr_bandy
WHERE 
    w_stadku_od = (SELECT MAX(w_stadku_od) FROM Kocury WHERE nr_bandy = K1.nr_bandy)
    
UNION ALL

SELECT 
    imie,
    w_stadku_od || ' <---' "WSTAPIL DO STADKA",
    'NAJSTARSZY STAZEM W BANDZIE ' || nazwa
FROM Kocury K1 JOIN Bandy B ON K1.nr_bandy = B.nr_bandy
WHERE 
    w_stadku_od = (SELECT MIN(w_stadku_od) FROM Kocury WHERE nr_bandy = K1.nr_bandy)    
ORDER BY 1;

    
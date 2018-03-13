--Zad. 29. Dla kocurów (p³eæ mêska), dla których ca³kowity przydzia³ myszy nie przekracza œredniej w ich bandzie 
--wyznaczyæ nastêpuj¹ce dane: imiê, ca³kowite spo¿ycie myszy, numer bandy, œrednie ca³kowite spo¿ycie w bandzie. 
--Nie stosowaæ perspektywy. Zadanie rozwi¹zaæ na trzy sposoby:
--a.	ze z³¹czeniem ale bez podzapytañ,
--b.	ze z³¹czenie i z jedynym podzapytaniem w klauzurze FROM,
--c.	bez z³¹czeñ i z dwoma podzapytaniami: w klauzurach SELECT i WHERE.
--
--IMIE                 ZJADA   NR BANDY SREDNIA BANDY
----------------- ---------- ---------- -------------
--DUDEK                   40          4         49.40
--LUCEK                   43          3         61.75
--BARI                    56          2         66.60
--CHYTRY                  50          1         80.50

-- a.	ze z³¹czeniem ale bez podzapytañ:
SELECT 
    K1.imie,
    NVL(K1.przydzial_myszy,0) + NVL(K1.myszy_extra,0) "ZJADA",
    K1.nr_bandy,
    TO_CHAR(AVG(NVL(K2.przydzial_myszy,0) + NVL(K2.myszy_extra,0)),'99.99') "SREDNIA BANDY"    
FROM 
    Kocury K1 JOIN Kocury K2 ON K1.nr_bandy = K2.nr_bandy
WHERE K1.plec = 'M'
GROUP BY 
    K1.imie, 
    NVL(K1.przydzial_myszy,0) + NVL(K1.myszy_extra,0),
    K1.nr_bandy
HAVING 
    NVL(K1.przydzial_myszy,0) + NVL(K1.myszy_extra,0) <= AVG(NVL(K2.przydzial_myszy,0) + NVL(K2.myszy_extra,0));
    
    
    SELECT 
      K1.imie, 
      NVL(K1.przydzial_myszy,0) + NVL(K1.myszy_extra,0),
      K1.nr_bandy,
      TO_CHAR(AVG(NVL(K2.przydzial_myszy,0) + NVL(K2.myszy_extra,0)),'99.99') "SREDNIA BANDY"  
    FROM Kocury K1 JOIN Kocury K2 ON K1.nr_bandy = K2.nr_bandy
    WHERE K1.plec = 'M'
    GROUP BY 
      K1.imie, 
      NVL(K1.przydzial_myszy,0) + NVL(K1.myszy_extra,0),
      K1.nr_bandy
--b.	ze z³¹czeniem i z jedynym podzapytaniem w klauzurze FROM:
SELECT 
    K1.imie,
    NVL(K1.przydzial_myszy,0) + NVL(K1.myszy_extra,0) "ZJADA",
    K1.nr_bandy,
    TO_CHAR(SR.srednia,'99.99') "SREDNIA BANDY"
FROM Kocury K1 JOIN (SELECT 
                        nr_bandy,
                        AVG(NVL(przydzial_myszy,0) + NVL(myszy_extra,0)) srednia
                     FROM Kocury
                     GROUP BY nr_bandy) SR ON K1.nr_bandy = SR.nr_bandy
WHERE 
    K1.plec = 'M'
    AND NVL(K1.przydzial_myszy,0) + NVL(K1.myszy_extra,0) <= SR.srednia;

--c.	bez z³¹czeñ i z dwoma podzapytaniami: w klauzurach SELECT i WHERE
SELECT
    imie,
    NVL(przydzial_myszy,0) + NVL(myszy_extra,0) "ZJADA",
    nr_bandy,
    TO_CHAR((SELECT AVG(NVL(przydzial_myszy,0) + NVL(myszy_extra,0))
            FROM Kocury
            WHERE nr_bandy = K1.nr_bandy),'99.99') "SREDNIA BANDY"   
FROM Kocury K1
WHERE 
    plec = 'M'
    AND NVL(przydzial_myszy,0) + NVL(myszy_extra,0) < (SELECT AVG(NVL(przydzial_myszy,0) + NVL(myszy_extra,0))
                                                       FROM Kocury
                                                       WHERE nr_bandy = K1.nr_bandy);

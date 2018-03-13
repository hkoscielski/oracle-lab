--Zad. 28. Okreœliæ lata, dla których liczba wst¹pieñ do stada jest najbli¿sza (od góry i od do³u) 
--œredniej liczbie wst¹pieñ  dla wszystkich lat (œrednia z wartoœci okreœlaj¹cych liczbê wst¹pieñ w poszczególnych latach). 
--Nie stosowaæ perspektywy.
--
--ROK              LICZBA WSTAPIEN
------------------ ---------------
--2009                   2
--2010                   2
--2011                   2
--2002                   2
--Srednia                2.5714286
--2006                   4

SELECT
  TO_CHAR(EXTRACT(YEAR FROM w_stadku_od)) "ROK",
  COUNT(pseudo) "LICZBA WSTAPIEN"
FROM Kocury
GROUP BY EXTRACT(YEAR FROM w_stadku_od)
HAVING COUNT(pseudo) IN (
       (SELECT * FROM
           (SELECT DISTINCT COUNT(pseudo)
            FROM Kocury
            GROUP BY EXTRACT(YEAR FROM w_stadku_od)
            HAVING COUNT(pseudo) > (SELECT AVG(COUNT(EXTRACT(YEAR FROM w_stadku_od)))
                                    FROM Kocury
                                    GROUP BY EXTRACT(YEAR FROM w_stadku_od))
            ORDER BY COUNT(pseudo))
         WHERE ROWNUM = 1),
        (SELECT * FROM
           (SELECT DISTINCT COUNT(pseudo)
            FROM Kocury
            GROUP BY EXTRACT(YEAR FROM w_stadku_od)
            HAVING COUNT(pseudo) < (SELECT AVG(COUNT(EXTRACT(YEAR FROM w_stadku_od)))
                                    FROM Kocury
                                    GROUP BY EXTRACT(YEAR FROM w_stadku_od))
            ORDER BY COUNT(pseudo) DESC)
         WHERE ROWNUM = 1)) 
UNION ALL
SELECT
  'Srednia',
  ROUND(AVG(COUNT(EXTRACT(YEAR FROM w_stadku_od))), 7)
FROM Kocury
GROUP BY EXTRACT(YEAR FROM w_stadku_od)
ORDER BY 2;
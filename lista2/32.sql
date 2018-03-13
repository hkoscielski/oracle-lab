--Zad. 32. Dla kot�w o trzech najd�u�szym sta�ach w po��czonych bandach CZARNI RYCERZE i �ACIACI MY�LIWI 
--zwi�kszy� przydzia� myszy o 10% minimalnego przydzia�u w ca�ym stadzie lub o 10 w zale�no�ci od tego 
--czy podwy�ka dotyczy kota p�ci �e�skiej czy kota p�ci m�skiej. 
--Przydzia� myszy extra dla kot�w obu p�ci zwi�kszy� o 15% �redniego przydzia�u extra w bandzie kota. 
--Wy�wietli� na ekranie warto�ci przed i po podwy�ce a nast�pnie wycofa� zmiany.
--
--Pseudonim       Plec     Myszy pszed podw.    Extra przed podw.
----------------- ----- -------------------- --------------------
--SZYBKA            D                     65                    0
--LYSY              M                     72                   21
--LASKA             D                     24                   28
--RAFA              M                     65                    0
--DAMA              D                     51                    0
--MAN               M                     51                    0
--
--Pseudonim       Plec       Myszy po podw.       Extra po podw.
----------------- ----- -------------------- --------------------
--SZYBKA            D                     67                    1
--LYSY              M                     82                   22
--LASKA             D                     26                   29
--RAFA              M                     75                    0
--DAMA              D                     53                    0
--MAN               M                     61                    0

CREATE OR REPLACE VIEW Najdluzsze_Staze
AS SELECT
        pseudo,
        nr_bandy,
        plec,
        przydzial_myszy,
        myszy_extra
    FROM Kocury 
    WHERE pseudo IN (
        (SELECT * FROM
            (SELECT pseudo
            FROM Kocury JOIN Bandy USING(nr_bandy)
            WHERE nazwa = 'CZARNI RYCERZE'
            ORDER BY w_stadku_od)
        WHERE ROWNUM < 4))
    OR pseudo IN (
        (SELECT * FROM 
            (SELECT pseudo
            FROM Kocury JOIN Bandy USING(nr_bandy)
            WHERE nazwa = 'LACIACI MYSLIWI'
            ORDER BY w_stadku_od)
        WHERE ROWNUM < 4)
    );

SELECT
    pseudo,
    plec,
    NVL(przydzial_myszy,0) "Myszy przed podw.",
    NVL(myszy_extra,0) "Extra przed podw."
FROM Najdluzsze_Staze;

UPDATE Najdluzsze_Staze NS
SET przydzial_myszy = CASE WHEN plec = 'D' THEN
                            NVL(przydzial_myszy,0) + (SELECT MIN(NVL(przydzial_myszy,0)) * 0.1 FROM Kocury)
                      ELSE 
                            NVL(przydzial_myszy,0) + 10
                      END,
    myszy_extra = NVL(myszy_extra,0) + ROUND((SELECT AVG(NVL(myszy_extra,0)) * 0.15 FROM Kocury WHERE nr_bandy = NS.nr_bandy));
    
SELECT
    pseudo,
    plec,
    NVL(przydzial_myszy,0) "Myszy po podw.",
    NVL(myszy_extra,0) "Extra po podw."
FROM Najdluzsze_Staze;    

ROLLBACK;

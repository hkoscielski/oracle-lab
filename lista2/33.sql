--Zad. 33. Napisaæ zapytanie, w ramach którego obliczone zostan¹ sumy ca³kowitego spo¿ycia myszy przez koty 
--sprawuj¹ce ka¿d¹ z funkcji z podzia³em na bandy i p³cie kotów. Podsumowaæ przydzia³y dla ka¿dej z funkcji. 
--Zadanie wykonaæ na dwa sposoby:
--a.	z wykorzystaniem tzw. raportu macierzowego,
--b.	z wykorzystaniem klauzuli PIVOT
--
--
--NAZWA BANDY       PLEC    ILE  SZEFUNIO  BANDZIOR    LOWCZY    LAPACZ       KOT   MILUSIA  DZIELCZY    SUMA
------------------- ------ ---- --------- --------- --------- --------- --------- --------- --------- -------
--BIALI LOWCY       Kotka     2         0         0        61         0         0        55         0     116
--                  Kocor     2         0        88         0         0        43         0         0     131
--CZARNI RYCERZE    Kotka     2         0         0        65         0         0        52         0     117
--                  Kocor     3         0        93        67        56         0         0         0     216
--LACIACI MYSLIWI   Kotka     2         0         0         0        51        40         0         0      91
--                  Kocor     3         0         0        65        51        40         0         0     156
--SZEFOSTWO         Kotka     2         0         0         0         0         0       136         0     136
--                  Kocor     2       136         0         0         0         0         0        50     186
--Z---------------- ------ ---- --------- --------- --------- --------- --------- --------- --------- -------
--ZJADA RAZEM                         136       181       258       158       123       243        50    1149
--
--a.	z wykorzystaniem tzw. raportu macierzowego:
SELECT      
    DECODE(plec, 'Kotka', ' ', nazwa) nazwa,
    plec,
    ile,
    szefunio, 
    bandzior, 
    lowczy, 
    lapacz, 
    kot,
    milusia, 
    dzielczy, 
    suma
FROM (SELECT nazwa,
             DECODE(plec, 'M', 'Kocor', 'Kotka') plec,
             TO_CHAR(COUNT(pseudo)) ile,
             TO_CHAR(SUM(DECODE(funkcja, 'SZEFUNIO', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) szefunio, 
             TO_CHAR(SUM(DECODE(funkcja, 'BANDZIOR', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) bandzior, 
             TO_CHAR(SUM(DECODE(funkcja, 'LOWCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) lowczy, 
             TO_CHAR(SUM(DECODE(funkcja, 'LAPACZ', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) lapacz, 
             TO_CHAR(SUM(DECODE(funkcja, 'KOT', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) kot,
             TO_CHAR(SUM(DECODE(funkcja, 'MILUSIA', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) milusia, 
             TO_CHAR(SUM(DECODE(funkcja, 'DZIELCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) dzielczy, 
             TO_CHAR(SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) suma
      FROM Kocury JOIN Bandy USING(nr_bandy)
      GROUP BY nazwa, plec
      UNION ALL
      SELECT 
            'Z--------------', '------', '--------', '---------', '---------', '--------', '--------', '--------', '--------', '--------', '--------'
      FROM DUAL
      UNION ALL
      SELECT 
            'ZJADA RAZEM' nazwa,
            ' ' plec,
            ' ' ile,
            TO_CHAR(SUM(DECODE(funkcja, 'SZEFUNIO', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) szefunio, 
            TO_CHAR(SUM(DECODE(funkcja, 'BANDZIOR', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) bandzior, 
            TO_CHAR(SUM(DECODE(funkcja, 'LOWCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) lowczy, 
            TO_CHAR(SUM(DECODE(funkcja, 'LAPACZ', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) lapacz, 
            TO_CHAR(SUM(DECODE(funkcja, 'KOT', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) kot,
            TO_CHAR(SUM(DECODE(funkcja, 'MILUSIA', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) milusia, 
            TO_CHAR(SUM(DECODE(funkcja, 'DZIELCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) dzielczy, 
            TO_CHAR(SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) suma
    FROM Kocury JOIN Bandy USING(nr_bandy)
    ORDER BY 1, 2 
);

--OK

--b.	z wykorzystaniem klauzuli PIVOT:
WITH Kocury_Bandy AS
     (SELECT * 
     FROM Kocury JOIN Bandy USING(nr_bandy))
SELECT
  DECODE("PLEC", 'Kocur', ' ', NAZWA) "NAZWA BANDY",
  "PLEC",
  "ILE",
  "SZEFUNIO",
  "BANDZIOR",
  "LOWCZY",
  "LAPACZ",
  "KOT",
  "MILUSIA",
  "DZIELCZY",
  "SUMA"
FROM (
  SELECT
    NAZWA,
    DECODE(PLEC, 'M', 'Kocur', 'Kotka') "PLEC",
    TO_CHAR(ILE) ILE,
    TO_CHAR(NVL(SZEFUNIO, 0)) "SZEFUNIO",
    TO_CHAR(NVL(BANDZIOR, 0)) "BANDZIOR",
    TO_CHAR(NVL(LOWCZY, 0)) "LOWCZY",
    TO_CHAR(NVL(LAPACZ, 0)) "LAPACZ",
    TO_CHAR(NVL(KOT, 0)) "KOT",
    TO_CHAR(NVL(MILUSIA, 0)) "MILUSIA",
    TO_CHAR(NVL(DZIELCZY, 0)) "DZIELCZY",
    TO_CHAR(SUMA) SUMA
  FROM
    (
      SELECT
        nazwa,
        plec,
        funkcja,
        NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) myszy_calk
      FROM Kocury_Bandy
      )
      PIVOT (
        SUM(myszy_calk)
        FOR FUNKCJA
        IN ('SZEFUNIO' "SZEFUNIO", 'BANDZIOR' "BANDZIOR", 'LOWCZY' "LOWCZY", 'LAPACZ' "LAPACZ", 'KOT' "KOT", 'MILUSIA' "MILUSIA", 'DZIELCZY' "DZIELCZY")
      )
    NATURAL JOIN
    (
      SELECT
        nazwa,
        plec,
        COUNT(pseudo) ILE,
        TO_CHAR(SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) SUMA
      FROM Kocury_Bandy
      GROUP BY nazwa, plec
      )
  UNION ALL SELECT
          'Z----------------',
          '------',
          '----',
          '---------',
          '---------',
          '---------',
          '---------',
          '---------',
          '---------',
          '---------',
          '-------'
        FROM Dual
  UNION ALL SELECT
          'ZJADA RAZEM',
          ' ',
          ' ',
          TO_CHAR(SUM(DECODE(funkcja, 'SZEFUNIO', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) "SZEFUNIO",
          TO_CHAR(SUM(DECODE(funkcja, 'BANDZIOR', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) "BANDZIOR",
          TO_CHAR(SUM(DECODE(funkcja, 'LOWCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) "LOWCZY",
          TO_CHAR(SUM(DECODE(funkcja, 'LAPACZ', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) "LAPACZ",
          TO_CHAR(SUM(DECODE(funkcja, 'KOT', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) "KOT",
          TO_CHAR(SUM(DECODE(funkcja, 'MILUSIA', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) "MILUSIA",
          TO_CHAR(SUM(DECODE(funkcja, 'DZIELCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) "DZIELCZY",
          TO_CHAR(SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) "SUMA"
        FROM
          Kocury)
ORDER BY NAZWA, PLEC DESC;

--OK
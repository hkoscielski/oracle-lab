--Zad. 19. Dla kotów pe³ni¹cych funkcjê KOT i MILUSIA wyœwietliæ w kolejnoœci hierarchii imiona wszystkich ich szefów. 
--Zadanie rozwi¹zaæ na trzy sposoby:
--a.	z wykorzystaniem tylko z³¹czeñ,
--b.	z wykorzystaniem drzewa, operatora CONNECT_BY_ROOT i tabel przestawnych,
--c.	z wykorzystaniem drzewa i funkcji SYS_CONNECT_BY_PATH
--i operatora CONNECT_BY_ROOT.
--
--Wynik dla a. i b.
--
--Imie           Funkcja        Szef 1         Szef 2         Szef 3
------------ --- ---------- --- ---------- --- ---------- --- ---------
--LUCEK       |  KOT         |  PUNIA       |  KOREK       |  MRUCZEK
--MICKA       |  MILUSIA     |  MRUCZEK     |              |
--RUDA        |  MILUSIA     |  MRUCZEK     |              |
--SONIA       |  MILUSIA     |  KOREK       |  MRUCZEK     |
--BELA        |  MILUSIA     |  BOLEK       |  MRUCZEK     |
--DUDEK       |  KOT         |  PUCEK       |  MRUCZEK     |
--LATKA       |  KOT         |  PUCEK       |  MRUCZEK     |
--Wynik dla c.
--
--Imie           Funkcja    Imiona kolejnych szefów
------------ --- ---------- ------------------------------------------
--SONIA       |  MILUSIA     | KOREK         | MRUCZEK       |
--MICKA       |  MILUSIA     | MRUCZEK       |
--LUCEK       |  KOT         | PUNIA         | KOREK         | MRUCZEK
--BELA        |  MILUSIA     | BOLEK         | MRUCZEK       |
--DUDEK       |  KOT         | PUCEK         | MRUCZEK       |
--LATKA       |  KOT         | PUCEK         | MRUCZEK       |
--RUDA        |  MILUSIA     | MRUCZEK       |

--Z góry trzeba za³o¿yæ g³êbokoœæ drzewa = 3

--a.	z wykorzystaniem tylko z³¹czeñ:
SELECT
    K1.imie,
    ' | ' " ",
    K1.funkcja,
    ' | ' "  ",
    NVL(K2.imie,' ') "Szef 1",
    ' | ' "   ",
    NVL(K3.imie,' ') "Szef 2",
    ' | ' "    ",
    NVL(K4.imie,' ') "Szef 3"
FROM Kocury K1
     LEFT JOIN Kocury K2 ON K1.szef = K2.pseudo
     LEFT JOIN Kocury K3 ON K2.szef = K3.pseudo
     LEFT JOIN Kocury K4 ON K3.szef = K4.pseudo
WHERE K1.funkcja IN ('KOT','MILUSIA');

--b.	z wykorzystaniem drzewa, operatora CONNECT_BY_ROOT i tabel przestawnych:
SELECT  
    imieRoot imie,
    funkcja,
    NVL(s2,' ') "SZEF 1",
    NVL(s3,' ') "SZEF 2",
    NVL(s4,' ') "SZEF 3"
FROM (SELECT      
        CONNECT_BY_ROOT imie imieRoot,
        CONNECT_BY_ROOT funkcja funkcja,
        level lvl,
        imie
      FROM Kocury 
      CONNECT BY PRIOR szef = pseudo
      START WITH funkcja IN ('KOT', 'MILUSIA'))
PIVOT (
  MAX(imie) 
  FOR lvl 
  IN (2 s2, 3 s3, 4 s4)
);
    
--c.	z wykorzystaniem drzewa i funkcji SYS_CONNECT_BY_PATH i operatora CONNECT_BY_ROOT:
SELECT
  CONNECT_BY_ROOT imie "Imie",
  ' | ' " ",
  CONNECT_BY_ROOT funkcja "Funkcja",
  SUBSTR(SYS_CONNECT_BY_PATH(RPAD(imie, 12), '| ') || '|', 14, 38) "Imiona kolejnych szefów"
FROM Kocury
WHERE CONNECT_BY_ISLEAF = 1
CONNECT BY PRIOR szef = pseudo
START WITH funkcja IN ('MILUSIA', 'KOT');

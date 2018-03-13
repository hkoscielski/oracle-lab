--Zad. 23. Wy�wietli� imiona kot�w, kt�re dostaj� �mysz�� premi� wraz z ich ca�kowitym rocznym spo�yciem myszy. 
--Dodatkowo je�li ich roczna dawka myszy przekracza 864 wy�wietli� tekst �powyzej 864�, je�li jest r�wna 864 tekst �864�, 
--je�li jest mniejsza od 864 tekst �poni�ej 864�. Wyniki uporz�dkowa� malej�co wg rocznej dawki myszy. 
--Do rozwi�zania wykorzysta� operator zbiorowy UNION.
--
--IMIE            DAWKA ROCZNA    DAWKA
----------------- ------------ --------------
--MRUCZEK                 1632    powyzej 864
--BOLEK                   1116    powyzej 864
--KOREK                   1056    powyzej 864
--MICKA                    864            864
--RUDA                     768    ponizej 864
--SONIA                    660    ponizej 864
--BELA                     624    ponizej 864

SELECT
  imie,
  NVL(przydzial_myszy * 12, 0) + NVL(myszy_extra * 12, 0) "DAWKA ROCZNA",
  'ponizej 864' "DAWKA"
FROM Kocury
WHERE 
    NVL(przydzial_myszy * 12, 0) + NVL(myszy_extra * 12, 0) < 864
    AND NVL(myszy_extra * 12, 0) > 0
UNION ALL
SELECT
  imie,
  NVL(przydzial_myszy * 12, 0) + NVL(myszy_extra * 12, 0) "DAWKA ROCZNA",
  '864' "DAWKA"
FROM Kocury
WHERE 
    NVL(przydzial_myszy * 12, 0) + NVL(myszy_extra * 12, 0) = 864
    AND NVL(myszy_extra * 12, 0) > 0
UNION ALL
SELECT
  imie,
  NVL(przydzial_myszy * 12, 0) + NVL(myszy_extra * 12, 0) "DAWKA ROCZNA",
  'powyzej 864' "DAWKA"
FROM Kocury
WHERE 
    NVL(przydzial_myszy * 12, 0) + NVL(myszy_extra * 12, 0) > 864
    AND NVL(myszy_extra * 12, 0) > 0
ORDER BY "DAWKA ROCZNA" DESC;
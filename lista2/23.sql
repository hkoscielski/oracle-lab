--Zad. 23. Wyœwietliæ imiona kotów, które dostaj¹ „mysz¹” premiê wraz z ich ca³kowitym rocznym spo¿yciem myszy. 
--Dodatkowo jeœli ich roczna dawka myszy przekracza 864 wyœwietliæ tekst ’powyzej 864’, jeœli jest równa 864 tekst ’864’, 
--jeœli jest mniejsza od 864 tekst ’poni¿ej 864’. Wyniki uporz¹dkowaæ malej¹co wg rocznej dawki myszy. 
--Do rozwi¹zania wykorzystaæ operator zbiorowy UNION.
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
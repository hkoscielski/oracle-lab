--Zad. 35. Napisaæ blok PL/SQL, który wyprowadza na ekran nastêpuj¹ce informacje o kocie o pseudonimie wprowadzonym z klawiatury 
--(w zale¿noœci od rzeczywistych danych):
---	'calkowity roczny przydzial myszy >700'
---	'imiê zawiera litere A'
---	'styczeñ jest miesiacem przystapienia do stada'
---	'nie odpowiada kryteriom'.
--Powy¿sze informacje wymienione s¹ zgodnie z hierarchi¹ wa¿noœci. Ka¿d¹ wprowadzan¹ informacjê poprzedziæ imieniem kota.

DECLARE
  im Kocury.imie%TYPE;
  myszy_calk NUMBER;
  miesiac NUMBER;
  czy_spelnia BOOLEAN DEFAULT FALSE;
BEGIN
  SELECT
    imie,
    12 * (NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)),
    EXTRACT(MONTH FROM w_stadku_od)
  INTO im, myszy_calk, miesiac
  FROM Kocury
  WHERE pseudo = '&pseudo';
  
  IF myszy_calk > 700 THEN 
    DBMS_OUTPUT.PUT_LINE('calkowity roczny przydzial myszy > 700');
    czy_spelnia := TRUE;
  END IF;
  IF im LIKE '%A%' THEN 
    DBMS_OUTPUT.PUT_LINE('imie zawiera litere A');
    czy_spelnia := TRUE;
  END IF;
  IF miesiac = 1 THEN 
    DBMS_OUTPUT.PUT_LINE('styczeñ jest miesi¹cem przyst¹pienia do stada'); 
    czy_spelnia := TRUE;
  END IF;
  IF NOT czy_spelnia THEN 
    DBMS_OUTPUT.PUT_LINE('nie odpowiada kryteriom');  
  END IF;
EXCEPTION 
  WHEN NO_DATA_FOUND 
      THEN DBMS_OUTPUT.PUT_LINE('Nie ma kota o takim pseudonimie!');
  WHEN OTHERS
      THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

SELECT 
  pseudo, 
  imie, 
  EXTRACT(MONTH FROM w_stadku_od) miesiac,
  12 * (NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) myszy_calk
FROM Kocury;
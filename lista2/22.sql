--Zad. 22. Znale�� koty (wraz z pe�nion� funkcj�), kt�re posiadaj� wi�cej ni� jednego wroga.
--
--Funkcja    Pseudonim kota  Liczba wrogow
------------ --------------- -------------
--DZIELCZY   BOLEK                       2
--SZEFUNIO   TYGRYS                      2
--MILUSIA    LASKA                       2

SELECT
  k.funkcja,
  wk.pseudo "Pseudonim kota",
  COUNT(wk.pseudo) "Liczba wrogow"
FROM Kocury k JOIN Wrogowie_Kocurow wk ON k.pseudo = wk.pseudo
GROUP BY wk.pseudo, k.funkcja
HAVING COUNT(wk.pseudo) > 1;

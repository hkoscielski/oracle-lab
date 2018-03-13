SELECT
    imie_wroga "WROG",
    gatunek,
    stopien_wrogosci "STOPIEN WROGOSCI"
FROM Wrogowie
WHERE lapowka IS NULL
ORDER BY stopien_wrogosci ASC;
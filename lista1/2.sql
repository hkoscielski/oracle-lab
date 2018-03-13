SELECT 
    imie,
    funkcja, 
    w_stadku_od "Z NAMI OD"
FROM Kocury
WHERE 
    plec = 'D' 
    AND w_stadku_od BETWEEN '2005-09-01' AND '2007-07-31'; 
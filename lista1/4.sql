SELECT
    imie || ' zwany ' || pseudo || ' (fun. ' || funkcja || ') lowi myszki w bandzie ' || nr_bandy || ' od ' || w_stadku_od "WSZYSTKO O KOCURACH"
FROM Kocury
WHERE plec = 'M'
ORDER BY 
    w_stadku_od DESC,
    pseudo;
    
    
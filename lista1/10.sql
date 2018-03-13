SELECT 
    CASE COUNT(pseudo) WHEN 1
                          THEN pseudo || ' - Unikalny'
                       ELSE pseudo || ' - nieunikalny'
                       END "Unikalnosc atr. PSEUDO"
FROM Kocury
GROUP BY pseudo;

SELECT 
    CASE COUNT(szef) WHEN 1
                          THEN szef || ' - Unikalny'
                       ELSE szef || ' - nieunikalny'
                       END "Unikalnosc atr. SZEF"
FROM Kocury
WHERE szef IS NOT NULL
GROUP BY szef;
SELECT 
    imie,
    CASE WHEN 12 * (NVL(PRZYDZIAL_MYSZY, 0) + NVL(MYSZY_EXTRA, 0)) > 660
            THEN TO_CHAR(12 * (NVL(PRZYDZIAL_MYSZY, 0) + NVL(MYSZY_EXTRA, 0)))
         WHEN 12 * (NVL(PRZYDZIAL_MYSZY, 0) + NVL(MYSZY_EXTRA, 0)) = 660
            THEN 'Limit'
         ELSE 'Ponizej 660'
         END "ZJADA ROCZNIE"
FROM Kocury;
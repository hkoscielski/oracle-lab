SELECT 
    pseudo,
    REGEXP_REPLACE(
      REGEXP_REPLACE(pseudo, 'L', '%', 1, 1), 'A', '#', 1, 1
    ) "Po wymianie A na # oraz L na %"
FROM Kocury
WHERE INSTR(pseudo, 'A') > 0 AND INSTR(pseudo, 'L') > 0;

SELECT
  PSEUDO,
  W_STADKU_OD "W STADKU",
  CASE
  WHEN EXTRACT(DAY FROM W_STADKU_OD) <= 15
    THEN
      CASE
      WHEN NEXT_DAY(LAST_DAY('2017-10-23') - 7, 'ŒRODA') < '2017-10-23'
        THEN NEXT_DAY(LAST_DAY(ADD_MONTHS('2017-10-23', 1)) - 7, 'ŒRODA')
      ELSE
        NEXT_DAY(LAST_DAY('2017-10-23') - 7, 'ŒRODA')
      END
  ELSE
    NEXT_DAY(LAST_DAY(ADD_MONTHS('2017-10-23', 1)) - 7, 'ŒRODA')
  END         "WYPLATA"
FROM Kocury;

SELECT 
    pseudo,
    w_stadku_od "W STADKU",
    CASE WHEN EXTRACT(DAY FROM w_stadku_od) <= 15
            THEN CASE WHEN NEXT_DAY(LAST_DAY('2017-10-26') - 7, 'ŒRODA') < '2017-10-26'
                        THEN NEXT_DAY(LAST_DAY(ADD_MONTHS('2017-10-26', 1)) - 7, 'ŒRODA')
                      ELSE 
                        NEXT_DAY(LAST_DAY('2017-10-26') - 7, 'ŒRODA')
                      END
         ELSE
            NEXT_DAY(LAST_DAY(ADD_MONTHS('2017-10-26', 1)) - 7, 'ŒRODA')
         END "WYPLATA"
FROM Kocury;
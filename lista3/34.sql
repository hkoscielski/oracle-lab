DECLARE    
  fun Kocury.funkcja%TYPE;
  ile NUMBER;
BEGIN   
  SELECT funkcja, COUNT(pseudo) INTO fun, ile
  FROM Kocury
  GROUP BY funkcja
  HAVING funkcja = '&fun';
  IF ile > 0 THEN DBMS_OUTPUT.PUT_LINE('Znaleziono kota o funkcji ' || fun);
             ELSE DBMS_OUTPUT.PUT_LINE('Nie znaleziono kota');
  END IF;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;


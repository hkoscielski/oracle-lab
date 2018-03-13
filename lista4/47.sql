--Zad. 47. Za³o¿yæ, ¿e w stadzie kotów pojawi³ siê podzia³ na elitê i na plebs. 
--Cz³onek elity posiada³ prawo do jednego s³ugi wybranego spoœród plebsu. 
--Dodatkowo móg³ gromadziæ myszy na dostêpnym dla ka¿dego cz³onka elity koncie. 
--Konto ma zawieraæ dane o dacie wprowadzenia na nie pojedynczej myszy i o dacie jej usuniêcia. 
--O tym, do kogo nale¿y mysz ma mówiæ odniesienie do jej w³aœciciela z elity. 
--Przyjmuj¹c te dodatkowe za³o¿enia zdefiniowaæ schemat bazy danych kotów (bez odpowiedników relacji Funkcje, Bandy, Wrogowie) 
--w postaci relacyjno-obiektowej, gdzie dane dotycz¹ce kotów, elity, plebsu. kont, incydentów bêd¹ okreœlane przez odpowiednie typy obiektowe. 
--Dla ka¿dego z typów zaproponowaæ i zdefiniowaæ przyk³adowe metody. Powi¹zania referencyjne nale¿y zdefiniowaæ za pomoc¹ typów odniesienia. 
--Tak przygotowany schemat wype³niæ danymi z rzeczywistoœci kotów (dane do opisu elit, plebsu i kont zaproponowaæ samodzielnie) 
--a nastêpnie wykonaæ przyk³adowe zapytania SQL, operuj¹ce na rozszerzonym schemacie bazy, 
--wykorzystuj¹ce referencje (jako realizacje z³¹czeñ), podzapytania, grupowanie oraz metody zdefiniowane w ramach typów. 
--Dla ka¿dego z mechanizmów (referencja, podzapytanie, grupowanie) nale¿y przedstawiæ  jeden taki przyk³ad. 
--Zrealizowaæ dodatkowo, w ramach nowego, relacyjno-obiektowego schematu, po dwa wybrane zadania z list nr  2 i 3.

--KOCUR

CREATE OR REPLACE TYPE KOCUR AS OBJECT (
    imie VARCHAR2(15),
    plec VARCHAR2(1),
    pseudo VARCHAR2(15),
    funkcja VARCHAR2(10), --Powinien byc REF do Funkcja
    szef REF KOCUR,
    w_stadku_od DATE,
    przydzial_myszy NUMBER(3),
    myszy_extra NUMBER(3),
    nr_bandy NUMBER(2), --Powinien byc REF do Banda
    
    MAP MEMBER FUNCTION Porownaj RETURN VARCHAR2,    
    MEMBER FUNCTION GetCalkowityPrzydzial RETURN NUMBER,
    MEMBER FUNCTION GetMiesiacPrzystapienia RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY KOCUR IS
    MAP MEMBER FUNCTION Porownaj RETURN VARCHAR2 IS
    BEGIN
        RETURN pseudo;
    END;    
    MEMBER FUNCTION GetCalkowityPrzydzial RETURN NUMBER IS
    BEGIN
        RETURN NVL(przydzial_myszy,0) + NVL(myszy_extra,0);
    END;
    MEMBER FUNCTION GetMiesiacPrzystapienia RETURN NUMBER IS
        miesiac NUMBER;
    BEGIN
        SELECT EXTRACT(MONTH FROM w_stadku_od) INTO miesiac FROM Dual; 
        RETURN miesiac;
    END;
END;

-- INCYDENT

CREATE OR REPLACE TYPE INCYDENT AS OBJECT (  
    nr_incydentu NUMBER,
    pseudo REF KOCUR,
    imie_wroga VARCHAR2(15),
    data_incydentu DATE,
    opis_incydentu VARCHAR2(50),
    
    MAP MEMBER FUNCTION Porownaj RETURN VARCHAR2
)

CREATE OR REPLACE TYPE BODY INCYDENT AS 
    MAP MEMBER FUNCTION Porownaj RETURN VARCHAR2 IS 
        k KOCUR;
    BEGIN
        SELECT DEREF(pseudo) INTO k FROM Dual;
        RETURN k.pseudo;
    END;
END;

-- PLEBS

CREATE OR REPLACE TYPE PLEBS AS OBJECT (
    nr_plebsu NUMBER,
    kocur_plebs REF KOCUR,
    
    MAP MEMBER FUNCTION Porownaj RETURN VARCHAR2,
    MEMBER FUNCTION GetKocur RETURN KOCUR
);

CREATE OR REPLACE TYPE BODY PLEBS AS
    MAP MEMBER FUNCTION Porownaj RETURN VARCHAR2 IS
        k KOCUR;
    BEGIN
        SELECT DEREF(kocur_plebs) INTO k FROM Dual;
        RETURN k.pseudo;
    END;
    
    MEMBER FUNCTION GetKocur RETURN KOCUR IS
        k KOCUR;
    BEGIN
        SELECT DEREF(kocur_plebs) INTO k FROM Dual;
        RETURN k;
    END;
END;

-- ELITA

CREATE OR REPLACE TYPE ELITA AS OBJECT (
    nr_elity NUMBER,
    kocur_elita REF KOCUR,
    sluga REF PLEBS,
    
    MAP MEMBER FUNCTION Porownaj RETURN VARCHAR2,
    MEMBER FUNCTION GetElita RETURN KOCUR,
    MEMBER FUNCTION GetSluga RETURN KOCUR
);

CREATE OR REPLACE TYPE BODY ELITA AS 
    MAP MEMBER FUNCTION Porownaj RETURN VARCHAR2 IS
        k KOCUR;
    BEGIN
        SELECT DEREF(kocur_elita) INTO k FROM Dual;
        RETURN k.pseudo;
    END;
    
    MEMBER FUNCTION GetElita RETURN KOCUR IS
        k KOCUR;
    BEGIN
        SELECT DEREF(kocur_elita) INTO k FROM Dual;
        RETURN k;
    END;
    
    MEMBER FUNCTION GetSluga RETURN KOCUR IS
        p PLEBS;
    BEGIN 
        SELECT DEREF(sluga) INTO p FROM Dual;
        return p.GetKocur();
    END;
END;

-- KONTO

CREATE OR REPLACE TYPE KONTO AS OBJECT (
    nr_operacji NUMBER,
    wlasciciel REF ELITA,
    data_wprow DATE,
    data_us DATE,
    
    MAP MEMBER FUNCTION Porownaj RETURN VARCHAR2,
    MEMBER FUNCTION GetWlasciciel RETURN KOCUR  
);

CREATE OR REPLACE TYPE BODY KONTO AS 
    MAP MEMBER FUNCTION Porownaj RETURN VARCHAR2 IS
    BEGIN
        RETURN nr_operacji;
    END;    
    MEMBER FUNCTION GetWlasciciel RETURN KOCUR IS
        e ELITA;
    BEGIN 
        SELECT DEREF(wlasciciel) INTO e FROM Dual;
        RETURN e.GetElita();
    END;
END;

DROP TYPE BODY KOCUR;
DROP TYPE KOCUR;
DROP TYPE BODY INCYDENT;
DROP TYPE INCYDENT;
DROP TYPE BODY PLEBS;
DROP TYPE PLEBS;
DROP TYPE BODY ELITA;
DROP TYPE ELITA;
DROP TYPE BODY KONTO;
DROP TYPE KONTO;

-- 
-- TABELE
--

CREATE TABLE KocuryO OF KOCUR
(CONSTRAINT kocuryo_im_nn imie NOT NULL,
CONSTRAINT kocuryo_plec_ch CHECK(plec IN ('M','D')),
CONSTRAINT kocuryo_ps_pk PRIMARY KEY(pseudo),
CONSTRAINT kocuryo_sz_fk szef SCOPE IS KocuryO,
w_stadku_od DEFAULT SYSDATE)

CREATE TABLE IncydentyO OF INCYDENT
(CONSTRAINT incydentyo_nr_indydentu_pk PRIMARY KEY (nr_incydentu),
CONSTRAINT incydentyo_pseudo_fk pseudo SCOPE IS KocuryO,
CONSTRAINT incydentyo_imie_wroga_nn imie_wroga NOT NULL,
CONSTRAINT incydentyo_data_nn data_incydentu NOT NULL)

CREATE TABLE PlebsO OF PLEBS
(CONSTRAINT plebso_nr_plebsu_pk PRIMARY KEY(nr_plebsu),
CONSTRAINT plebso_kocur_plebs_fk kocur_plebs SCOPE IS KocuryO)

CREATE TABLE ElityO OF ELITA
(CONSTRAINT elityo_nr_elity_pk PRIMARY KEY(nr_elity),
CONSTRAINT elityo_kocur_elita_fk kocur_elita SCOPE IS KocuryO,
CONSTRAINT elityo_sluga_fk sluga SCOPE IS PlebsO)

CREATE TABLE KontaO OF KONTO
(CONSTRAINT kontao_nr_operacji_pk PRIMARY KEY(nr_operacji),
CONSTRAINT kontao_wlasciciel_fk wlasciciel SCOPE IS ElityO,
CONSTRAINT kontao_data_wprow_nn data_wprow NOT NULL,
CONSTRAINT kontao_data_us_ch CHECK (data_wprow <= data_us))

--
-- WPROWADZENIE DANYCH
--

---- KOCURY

INSERT INTO KocuryO VALUES ('MRUCZEK', 'M', 'TYGRYS', 'SZEFUNIO', NULL, '2002-01-01', 103, 33, 1);
INSERT INTO KocuryO VALUES ('RUDA', 'D', 'MALA', 'MILUSIA', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='TYGRYS'), '2006-09-17', 22, 42, 1);
INSERT INTO KocuryO VALUES ('MICKA', 'D', 'LOLA', 'MILUSIA', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='TYGRYS'), '2009-10-14', 25, 47, 1);
INSERT INTO KocuryO VALUES ('PUCEK', 'M', 'RAFA', 'LOWCZY', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='TYGRYS'), '2006-10-15', 65, NULL, 4);
INSERT INTO KocuryO VALUES ('CHYTRY', 'M', 'BOLEK', 'DZIELCZY', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='TYGRYS'), '2002-05-05', 50, NULL, 1);
INSERT INTO KocuryO VALUES ('KOREK', 'M', 'ZOMBI', 'BANDZIOR', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='TYGRYS'), '2004-03-16', 75, 13, 3);
INSERT INTO KocuryO VALUES ('BOLEK', 'M', 'LYSY', 'BANDZIOR', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='TYGRYS'), '2006-08-15', 72, 21, 2);
INSERT INTO KocuryO VALUES ('KSAWERY', 'M', 'MAN', 'LAPACZ', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='RAFA'), '2008-07-12', 51, NULL, 4);
INSERT INTO KocuryO VALUES ('MELA', 'D', 'DAMA', 'LAPACZ', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='RAFA'), '2008-11-01', 51, NULL, 4);
INSERT INTO KocuryO VALUES ('LATKA', 'D', 'UCHO', 'KOT', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='RAFA'), '2011-01-01', 40, NULL, 4);
INSERT INTO KocuryO VALUES ('DUDEK', 'M', 'MALY', 'KOT', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='RAFA'), '2011-05-15', 40, NULL, 4);
INSERT INTO KocuryO VALUES ('ZUZIA' ,'D', 'SZYBKA', 'LOWCZY', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='LYSY'), '2006-07-21', 65, NULL, 2);
INSERT INTO KocuryO VALUES ('BELA', 'D', 'LASKA', 'MILUSIA', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='LYSY'), '2008-02-01', 24, 28, 2);
INSERT INTO KocuryO VALUES ('JACEK', 'M', 'PLACEK', 'LOWCZY', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='LYSY'), '2008-12-01', 67, NULL, 2);
INSERT INTO KocuryO VALUES ('BARI', 'M', 'RURA', 'LAPACZ', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='LYSY'), '2009-09-01', 56, NULL, 2);
INSERT INTO KocuryO VALUES ('PUNIA', 'D', 'KURKA', 'LOWCZY', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='ZOMBI'), '2008-01-01', 61, NULL,  3);
INSERT INTO KocuryO VALUES ('SONIA', 'D', 'PUSZYSTA', 'MILUSIA', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='ZOMBI'), '2010-11-18', 20, 35, 3);
INSERT INTO KocuryO VALUES ('LUCEK', 'M', 'ZERO', 'KOT', (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='KURKA'), '2010-03-01', 43, NULL, 3);

---- INCYDENTY

INSERT INTO IncydentyO VALUES (1,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='TYGRYS'), 'KAZIO', '2004-10-13','USILOWAL NABIC NA WIDLY');
INSERT INTO IncydentyO VALUES (2,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='ZOMBI'), 'SWAWOLNY DYZIO', '2005-03-07','WYBIL OKO Z PROCY');
INSERT INTO IncydentyO VALUES (3,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='BOLEK'), 'KAZIO', '2005-03-29','POSZCZUL BURKIEM');
INSERT INTO IncydentyO VALUES (4,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='SZYBKA'), 'GLUPIA ZOSKA', '2006-09-12','UZYLA KOTA JAKO SCIERKI');
INSERT INTO IncydentyO VALUES (5,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='MALA'), 'CHYTRUSEK', '2007-03-07','ZALECAL SIE');
INSERT INTO IncydentyO VALUES (6,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='TYGRYS'), 'DZIKI BILL', '2007-06-12','USILOWAL POZBAWIC ZYCIA');
INSERT INTO IncydentyO VALUES (7,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='BOLEK'), 'DZIKI BILL', '2007-11-10','ODGRYZL UCHO');
INSERT INTO IncydentyO VALUES (8,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='LASKA'), 'DZIKI BILL', '2008-12-12','POGRYZL ZE LEDWO SIE WYLIZALA');
INSERT INTO IncydentyO VALUES (9,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='LASKA'), 'KAZIO', '2009-01-07','ZLAPAL ZA OGON I ZROBIL WIATRAK');
INSERT INTO IncydentyO VALUES (10,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='DAMA'), 'KAZIO', '2009-02-07','CHCIAL OBEDRZEC ZE SKORY');
INSERT INTO IncydentyO VALUES (11,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='MAN'), 'REKSIO', '2009-04-14','WYJATKOWO NIEGRZECZNIE OBSZCZEKAL');
INSERT INTO IncydentyO VALUES (12,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='LYSY'), 'BETHOVEN', '2009-05-11','NIE PODZIELIL SIE SWOJA KASZA');
INSERT INTO IncydentyO VALUES (13,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='RURA'), 'DZIKI BILL', '2009-09-03','ODGRYZL OGON');
INSERT INTO IncydentyO VALUES (14,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='PLACEK'), 'BAZYLI', '2010-07-12','DZIOBIAC UNIEMOZLIWIL PODEBRANIE KURCZAKA');
INSERT INTO IncydentyO VALUES (15,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='PUSZYSTA'), 'SMUKLA', '2010-11-19','OBRZUCILA SZYSZKAMI');
INSERT INTO IncydentyO VALUES (16,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='KURKA'), 'BUREK', '2010-12-14','POGONIL');
INSERT INTO IncydentyO VALUES (17,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='MALY'), 'CHYTRUSEK', '2011-07-13','PODEBRAL PODEBRANE JAJKA');
INSERT INTO IncydentyO VALUES (18,(SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='UCHO'), 'SWAWOLNY DYZIO', '2011-07-14','OBRZUCIL KAMIENIAMI');

---- PLEBS

INSERT INTO PlebsO VALUES (1, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='PLACEK')); 
INSERT INTO PlebsO VALUES (2, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='RURA')); 
INSERT INTO PlebsO VALUES (3, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='ZERO'));
INSERT INTO PlebsO VALUES (4, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='PUSZYSTA'));
INSERT INTO PlebsO VALUES (5, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='UCHO'));
INSERT INTO PlebsO VALUES (6, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='MALY'));
INSERT INTO PlebsO VALUES (7, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='SZYBKA'));
INSERT INTO PlebsO VALUES (8, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='KURKA'));
INSERT INTO PlebsO VALUES (9, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='LASKA'));
INSERT INTO PlebsO VALUES (10, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='MAN'));
INSERT INTO PlebsO VALUES (11, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='DAMA'));

---- ELITY

INSERT INTO ElityO VALUES (1, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='TYGRYS'), (SELECT REF(PO) FROM PlebsO PO WHERE PO.nr_plebsu=11));
INSERT INTO ElityO VALUES (2, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='LYSY'), (SELECT REF(PO) FROM PlebsO PO WHERE PO.nr_plebsu=4));
INSERT INTO ElityO VALUES (3, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='ZOMBI'), (SELECT REF(PO) FROM PlebsO PO WHERE PO.nr_plebsu=7));
INSERT INTO ElityO VALUES (4, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='RAFA'), (SELECT REF(PO) FROM PlebsO PO WHERE PO.nr_plebsu=8));
INSERT INTO ElityO VALUES (5, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='LOLA'), (SELECT REF(PO) FROM PlebsO PO WHERE PO.nr_plebsu=2));
INSERT INTO ElityO VALUES (6, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='BOLEK'), (SELECT REF(PO) FROM PlebsO PO WHERE PO.nr_plebsu=3));
INSERT INTO ElityO VALUES (7, (SELECT REF(KO) FROM KocuryO KO WHERE KO.pseudo='MALA'), (SELECT REF(PO) FROM PlebsO PO WHERE PO.nr_plebsu=9));

---- KONTA

INSERT INTO KontaO VALUES (1, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=1), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (2, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=1), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (3, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=1), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (4, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=3), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (5, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=6), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (6, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=2), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (7, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=5), SYSDATE, NULL);
INSERT INTO KontaO VALUES (8, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=1), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (9, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=2), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (10, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=7), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (11, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=7), SYSDATE, NULL);
INSERT INTO KontaO VALUES (12, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=4), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (13, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=2), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (14, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=1), SYSDATE, NULL);
INSERT INTO KontaO VALUES (15, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=6), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (16, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=2), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (17, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=6), SYSDATE, NULL); 
INSERT INTO KontaO VALUES (18, (SELECT REF(EO) FROM ElityO EO WHERE EO.nr_elity=5), SYSDATE, NULL);

--
-- ZAPYTANIA I ZADANIA
--

---- Referencja - Pseudonimy plebsu
SELECT DEREF(PO.kocur_plebs).pseudo "Pseudonim plebsu"
FROM PlebsO PO;

---- Podzapytanie - Elity, które nie maja myszy na koncie
SELECT DEREF(EO.kocur_elita).pseudo "Elitarny biedak"
FROM ElityO EO
WHERE DEREF(EO.kocur_elita).pseudo NOT IN (SELECT DISTINCT KO.GetWlasciciel().pseudo FROM KontaO KO WHERE KO.data_us IS NULL);

---- Grupowanie
SELECT
    KO.GetWlasciciel().pseudo "Wlasciciel",
    COUNT(nr_operacji) "Myszy na koncie"
FROM KontaO KO
WHERE KO.data_us IS NULL
GROUP BY KO.GetWlasciciel().pseudo
ORDER BY 2 DESC;

---- Zad.18
SELECT 
    KO1.imie,
    KO1.w_stadku_od "POLUJE OD"
FROM KocuryO KO1 JOIN KocuryO KO2 ON KO2.imie='JACEK'
WHERE KO1.w_stadku_od < KO2.w_stadku_od
ORDER BY "POLUJE OD" DESC; 

---- Zad.23
SELECT
  imie,
  12 * KO.GetCalkowityPrzydzial() "DAWKA ROCZNA",
  'ponizej 864' "DAWKA"
FROM KocuryO KO
WHERE 
    12 * KO.GetCalkowityPrzydzial() < 864
    AND NVL(myszy_extra * 12, 0) > 0
UNION ALL
SELECT
  imie,
  12 * KO.GetCalkowityPrzydzial() "DAWKA ROCZNA",
  LPAD('864',11) "DAWKA"
FROM KocuryO KO
WHERE 
    12 * KO.GetCalkowityPrzydzial() = 864
    AND NVL(myszy_extra * 12, 0) > 0
UNION ALL
SELECT
  imie,
  12 * KO.GetCalkowityPrzydzial() "DAWKA ROCZNA",
  'powyzej 864' "DAWKA"
FROM KocuryO KO 
WHERE 
    12 * KO.GetCalkowityPrzydzial() > 864
    AND NVL(myszy_extra * 12, 0) > 0
ORDER BY "DAWKA ROCZNA" DESC;

---- Zad.35
DECLARE
  im KocuryO.imie%TYPE;
  myszy_calk NUMBER;
  miesiac NUMBER;
  czy_spelnia BOOLEAN DEFAULT FALSE;
BEGIN
  SELECT
    imie,
    12 * (NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)),
    KO.GetMiesiacPrzystapienia()
  INTO im, myszy_calk, miesiac
  FROM KocuryO KO
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

---- Zad.37
DECLARE
    sa_kocury BOOLEAN DEFAULT FALSE;
    kocury_not_found EXCEPTION;
    ile NUMBER:=0;
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('Nr', 4) ||  RPAD('Pseudonim', 12) || 'Zjada');
  DBMS_OUTPUT.PUT_LINE(LPAD(' ', 22, '-'));
  
  FOR kot IN (SELECT 
                pseudo,
                KO.GetCalkowityPrzydzial() zjada
              FROM KocuryO KO 
              ORDER BY 2 DESC)
  LOOP
    sa_kocury := TRUE;
    DBMS_OUTPUT.PUT_LINE(RPAD(ile + 1, 4) || RPAD(kot.pseudo, 12) || LPAD(kot.zjada, 5));
    ile := ile + 1;
    EXIT WHEN ile = 5;
  END LOOP;
  IF NOT sa_kocury THEN
    RAISE kocury_not_found;
  END IF;
EXCEPTION
    WHEN kocury_not_found
        THEN DBMS_OUTPUT.PUT_LINE('Nie znaleziono kocurow');
    WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
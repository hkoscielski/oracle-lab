CREATE TABLE Bandy
(nr_bandy NUMBER(2) CONSTRAINT bandy_nr_pk PRIMARY KEY,
nazwa VARCHAR2(20) CONSTRAINT bandy_nazwa_nn NOT NULL,
teren VARCHAR2(15) CONSTRAINT bandy_teren_un UNIQUE,
szef_bandy VARCHAR2(15) CONSTRAINT bandy_szef_un UNIQUE
);

CREATE TABLE Funkcje
(funkcja VARCHAR2(10) CONSTRAINT funkcje_fun_pk PRIMARY KEY,
min_myszy NUMBER(3) CONSTRAINT funkcje_min_ch CHECK (min_myszy > 5),
max_myszy NUMBER(3) CONSTRAINT funkcje_max_chmax CHECK (200 > max_myszy),
CONSTRAINT funkcje_max_chmin CHECK (max_myszy >= min_myszy)
); 
                    
CREATE TABLE Wrogowie
(imie_wroga VARCHAR(15) CONSTRAINT wrogowie_imie_pk PRIMARY KEY,
stopien_wrogosci NUMBER(2) CONSTRAINT wrogowie_stopien_ch CHECK (stopien_wrogosci BETWEEN 1 AND 10),
gatunek VARCHAR2(15),
lapowka VARCHAR2(20)
);


CREATE TABLE Kocury
(imie VARCHAR2(15) CONSTRAINT kocury_im_nn NOT NULL,
plec VARCHAR2(1) CONSTRAINT kocury_im_ch CHECK(plec IN ('M','D')),
pseudo VARCHAR2(15) CONSTRAINT kocury_ps_pk PRIMARY KEY,
funkcja VARCHAR2(10) CONSTRAINT kocury_fun_fk REFERENCES Funkcje(funkcja),
szef VARCHAR2(15) CONSTRAINT kocury_sz_fk REFERENCES Kocury(pseudo),
w_stadku_od DATE DEFAULT SYSDATE,
przydzial_myszy NUMBER(3),
myszy_extra NUMBER(3),
nr_bandy NUMBER(2) CONSTRAINT kocury_nrb_fk REFERENCES Bandy(nr_bandy)
);

ALTER TABLE Bandy ADD CONSTRAINT bandy_szef_fk FOREIGN KEY (szef_bandy) REFERENCES Kocury(pseudo);

CREATE TABLE Wrogowie_Kocurow
(pseudo VARCHAR2(15) CONSTRAINT wrogowiekocurow_pseudo_fk REFERENCES Kocury(pseudo),
imie_wroga VARCHAR2(15) CONSTRAINT wrogowiekocurow_imie_fk REFERENCES Wrogowie(imie_wroga),
data_incydentu DATE CONSTRAINT wrogowiekocurow_data_nn NOT NULL,
opis_incydentu VARCHAR2(50),
CONSTRAINT wrogowiekocurow_pk PRIMARY KEY (pseudo, imie_wroga)
);
use  yemek;

CREATE TABLE yemekler (
    id INT IDENTITY(1,1) PRIMARY KEY,
    yemek_adi VARCHAR(100) NOT NULL,
    tarif_detay TEXT,
    fotograf_url VARCHAR(255)
);

CREATE TABLE malzemeler (
    id INT IDENTITY(1,1) PRIMARY KEY,
    malzeme_adi VARCHAR(100) NOT NULL
);

CREATE TABLE yemek_malzeme (
    yemek_id INT FOREIGN KEY REFERENCES yemekler(id) ON DELETE CASCADE,
    malzeme_id INT FOREIGN KEY REFERENCES malzemeler(id) ON DELETE CASCADE,
    miktar VARCHAR(50)
);


INSERT INTO malzemeler (malzeme_adi) VALUES 
('Domates'), 
('Soğan'), 
('Sarımsak'), 
('Zeytinyağı'), 
('Tuz'), 
('Karabiber'), 
('Kıyma'), 
('Patates'), 
('Tereyağı'), 
('Un'), 
('Süt'), 
('Yumurta'), 
('Biber Salçası'), 
('Domates Salçası');
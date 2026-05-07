use yemek;

CREATE TABLE yemekler (
    id INT AUTO_INCREMENT PRIMARY KEY,
    yemek_adi VARCHAR(100) NOT NULL,
    tarif_detay TEXT,
    fotograf_url VARCHAR(255)
);

CREATE TABLE malzemeler (
    id INT AUTO_INCREMENT PRIMARY KEY,
    malzeme_adi VARCHAR(100) NOT NULL
);

CREATE TABLE yemek_malzeme (
    yemek_id INT,
    malzeme_id INT,
    miktar VARCHAR(50),
    FOREIGN KEY (yemek_id) REFERENCES yemekler(id) ON DELETE CASCADE,
    FOREIGN KEY (malzeme_id) REFERENCES malzemeler(id) ON DELETE CASCADE
);


INSERT INTO malzemeler (malzeme_adi) VALUES 
('Domates'), ('Soğan'), ('Sarımsak'), ('Zeytinyağı'), ('Tuz'), 
('Karabiber'), ('Kıyma'), ('Patates'), ('Tereyağı'), ('Un'), 
('Süt'), ('Yumurta'), ('Biber Salçası'), ('Domates Salçası');


CREATE TABLE yemekler (
    id SERIAL PRIMARY KEY,
    yemek_adi VARCHAR(100) NOT NULL,
    tarif_detay TEXT,
    fotograf_url VARCHAR(255)
);

CREATE TABLE malzemeler (
    id SERIAL PRIMARY KEY,
    malzeme_adi VARCHAR(100) NOT NULL
);

CREATE TABLE yemek_malzeme (
    yemek_id INT REFERENCES yemekler(id) ON DELETE CASCADE,
    malzeme_id INT REFERENCES malzemeler(id) ON DELETE CASCADE,
    miktar VARCHAR(50)
);


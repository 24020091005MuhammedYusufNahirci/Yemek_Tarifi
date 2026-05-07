#  Yemek Tarifi Yönetim Sistemi (PHP & PostgreSQL)

Bu proje, **Veri Tabanı Yönetim Sistemleri** dersi kapsamında geliştirilmiş; yemek tariflerini, içerdiği malzemeleri ve bu malzemelerin miktarlarını dinamik olarak yönetmeyi sağlayan web tabanlı bir uygulamadır. Proje, **PHP** dili ile geliştirilmiş ve veritabanı yönetim sistemi olarak **PostgreSQL** kullanılmıştır.

---

##  Özellikler

* **Tam CRUD Operasyonları:** Yemek tarifi ekleme, listeleme, güncelleme ve silme işlemleri.
* **Dinamik Malzeme Yönetimi:** Malzemelerin veritabanından çekilerek Switch butonları ile seçilmesi ve miktar girişi.
* **İlişkisel Veritabanı Mimarisi:** Yemekler ve malzemeler arasında **Many-to-Many** (Çoka Çok) ilişki yapısı.

---

##  Veritabanı Yapısı

Sistem, verilerin bütünlüğünü ve performansını optimize etmek amacıyla ilişkisel bir model üzerine inşa edilmiştir.

| Veritabanı Tablosu | Ekran Görüntüsü |
| :--- | :--- |
| **Yemekler Tablosu:** Yemek adı, detayları ve görsel yollarını saklar. | ![Yemekler Tablosu](images/yemek.png) |
| **Malzemeler Tablosu:** Sistemdeki tüm tanımlı malzeme listesini saklar. | ![Malzemeler Tablosu](images/malzemeler.png) |
| **Yemek-Malzeme (Ara Tablo):** Yemekler ve malzemeler arasındaki bağı ve miktarları saklar. | ![Ara Tablo](images/aratablo.png) |

---

##  Uygulama Ekran Görüntüleri

### 1. Ana Sayfa (Dashboard)
Kayıtlı tüm tariflerin PostgreSQL'den çekilerek kart yapısıyla sergilendiği, detay görme ve silme aksiyonlarının bulunduğu ekrandır.
![Ana Sayfa](images/anasayfa.jpg)

### 2. Yeni Tarif / Yönetim Paneli
Yeni yemeklerin sisteme tanımlandığı, veritabanındaki malzemelerin dinamik olarak listelenip seçildiği yönetim sayfasıdır.
![Yeni Tarif Ekle](images/ekleme.png)

### 3. Tarif Detay Sayfası
Seçilen tarife ait hazırlanış adımlarının ve `JOIN` sorgusu ile ara tablodan çekilen alışveriş listesinin görüntülendiği alandır.
![Tarif Detay](images/info.jpg)

### 4. Düzenleme Paneli
Mevcut tarif bilgilerinin, fotoğraflarının ve seçili malzeme miktarlarının revize edildiği güncelleme ekranıdır.
![Tarif Güncelle](images/güncelle.png)

---

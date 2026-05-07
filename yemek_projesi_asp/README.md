#  Yemek Tarifi Yönetim Sistemi (ASP.NET Core & PostgreSQL)

Bu proje, **Veri Tabanı Yönetim Sistemleri** dersi kapsamında geliştirilmiş; yemek tariflerini, malzemelerini ve bu malzemelerin miktarlarını dinamik olarak yönetmeyi sağlayan bir web uygulamasıdır. Proje, **ASP.NET Core** mimarisi kullanılarak geliştirilmiş ve veritabanı tarafında **PostgreSQL** ile desteklenmiştir.

---

##  Özellikler

* **Tam CRUD Operasyonları:** Yemek tarifi ekleme, listeleme, güncelleme ve silme işlemleri.
* **Dinamik Malzeme Yönetimi:** Malzemelerin veritabanından çekilerek Switch butonları aracılığıyla seçilmesi ve miktar girişi.
* **İlişkisel Veritabanı Mimarisi:** Yemekler ve malzemeler arasında **Many-to-Many** (Çoka Çok) ilişki yapısı.

---


##  Veritabanı Yapısı

Sistem, verilerin bütünlüğünü korumak adına ilişkisel bir model kullanmaktadır. Tablo yapıları ve içerikleri aşağıdadır:

| Veritabanı Tablosu | Ekran Görüntüsü |
| :--- | :--- |
| **Yemekler Tablosu:** Ana tarif bilgilerini (ad, tarif, foto) tutar. | ![Yemekler Tablosu](image/yemekler.png) |
| **Malzemeler Tablosu:** Sistemde tanımlı tüm malzemeleri tutar. | ![Malzemeler Tablosu](image/malzemeler.png) |
| **Yemek-Malzeme (Ara Tablo):** Hangi yemekte hangi malzemenin ne kadar olduğunu tutar. | ![Ara Tablo](image/aratablo.png) |

---

##  Uygulama Ekran Görüntüleri

### 1. Ana Sayfa
Kayıtlı tüm yemeklerin kart tasarımlarıyla listelendiği, hızlı silme ve detay görme butonlarının bulunduğu yönetim panelidir.
![Ana Sayfa](image/anasayfa.jpg)

### 2. Yeni Tarif Ekleme
Sisteme yeni yemeklerin ve malzemelerin tanımlandığı, modern form yapısına sahip ekleme ekranı.
![Yeni Tarif Ekle](image/ekleme.png)

### 3. Tarif Detay Sayfası
Seçilen tarifin içeriği ve kullanılan malzemelerin `JOIN` sorgusuyla ilişkili tablodan çekilerek listelendiği ekran.
![Tarif Detay](image/info.jpg)

### 4. Güncelleme Ekranı
Mevcut tarif bilgilerinin, fotoğraflarının ve malzeme miktarlarının revize edildiği düzenleme alanı.
![Tarif Güncelle](image/güncelle.png)

---

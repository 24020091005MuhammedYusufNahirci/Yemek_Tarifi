#  Çok Platformlu Yemek Tarifi Yönetim Sistemi

Bu depo, **Veri Tabanı Yönetim Sistemleri (VTYS)** dersi bitirme projesi kapsamında geliştirilen, aynı veritabanı şeması üzerine kurulu üç farklı web teknolojisi uygulamasını içermektedir. Projenin temel amacı; ilişkisel bir veritabanı (PostgreSQL) kullanarak yemek tariflerini, malzemelerini ve miktarlarını yöneten dinamik bir yapı kurmaktır.

---

##  Proje Yapısı

Bu repository içerisinde aynı işlevselliğe sahip 3 farklı yazılım mimarisi bulunmaktadır:

| Proje Klasörü | Kullanılan Teknoloji | Veritabanı 
| :--- | :--- | :--- | 
| [**yemek_projesi_asp**](./yemek_projesi_asp) | ASP.NET Core | PostgreSQL 
| [**yemek_projesi_jsp**](./yemek_projesi_jsp) | Java Server Pages (JSP) | PostgreSQL 
| [**yemek_projesi_php**](./yemek_projesi_php) | PHP (Native) | PostgreSQL 
---

##  Ortak Özellikler & Teknoloji Yığını

Her üç proje de aşağıdaki özellikleri ve teknolojileri ortak olarak kullanmaktadır:

* **Veritabanı:** PostgreSQL (İlişkisel model, Many-to-Many yapı).
* **Fonksiyonellik:** * Yemek tariflerinin CRUD (Ekle, Oku, Güncelle, Sil) işlemleri.
    * Dinamik malzeme seçimi ve miktar yönetimi.

---

## Veritabanı Şeması

Tüm uygulamalar tek bir veritabanı yapısı üzerinden konuşmaktadır. SQL kodlarına her klasörün altından veya ana dizindeki `postgre.sql` dosyasından ulaşabilirsiniz.

* `yemekler`: Tarif başlığı, hazırlama adımları ve fotoğraf linkleri.
* `malzemeler`: Sistemde tanımlı ham malzeme listesi.
* `yemek_malzeme`: Miktar bilgilerini içeren ara tablo (Relationship Table).

---


> **Geliştirici:** Yusuf  
> **Ders:** Veri Tabanı Yönetim Sistemleri  
> **Üniversite:** İstiklal Üniversitesi

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.Veritabani"%>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>JSP Tarif Paneli</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-dark mb-4 shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">🍲 JSP Tarif Yönetim Paneli</a>
            <a href="yeni.jsp" class="btn btn-success">Yeni Tarif Ekle</a>
        </div>
    </nav>

    <div class="container mt-4">
        <h2 class="mb-4">Kayıtlı Yemekler</h2>
        <div class="row">

            <%
                // Veritabanı nesnelerimizi tanımlıyoruz (Değişkenlerde Türkçe karakter yok)
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    conn = Veritabani.baglantiGetir();
                    
                    if(conn != null) {
                        stmt = conn.createStatement();
                        // PostgreSQL'deki yemekler tablosundan verileri çekiyoruz
                        String query = "SELECT * FROM yemekler ORDER BY id DESC";
                        rs = stmt.executeQuery(query);

                        boolean veriVarMi = false;

                        // Veritabanındaki her bir satır için döngü çalışır
                        while(rs.next()) {
                            veriVarMi = true;
                            int id = rs.getInt("id");
                            String yemekAdi = rs.getString("yemek_adi");
                            String tarifDetay = rs.getString("tarif_detay");
                            String fotoUrl = rs.getString("fotograf_url");

                            // Tarif detayı çok uzunsa ekranda taşırmaması için ilk 100 harfini alıyoruz
                            if(tarifDetay != null && tarifDetay.length() > 100) {
                                tarifDetay = tarifDetay.substring(0, 100) + "...";
                            }
            %>

            <div class="col-md-4 mb-4">
                <div class="card h-100 shadow-sm border-0">
                    <img src="<%= fotoUrl %>" class="card-img-top" alt="<%= yemekAdi %>" style="height: 200px; object-fit: cover;">
                    <div class="card-body">
                        <h5 class="card-title text-primary fw-bold"><%= yemekAdi %></h5>
                        <p class="card-text text-muted"><%= tarifDetay %></p>
                    </div>
                    <div class="card-footer bg-white border-0 pb-3 d-flex gap-2">
                        <a href="detay.jsp?id=<%= id %>" class="btn btn-sm btn-outline-primary flex-grow-1">Tarifi Oku</a>
                        <a href="sil.jsp?id=<%= id %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Emin misiniz?');">Sil</a>
                    </div>
                </div>
            </div>

            <%
                        } // Döngünün bitiş süslü parantezi

                        // Eğer tablo tamamen boşsa kullanıcıya uyarı gösteriyoruz
                        if(!veriVarMi) {
            %>
                            <div class="col-12">
                                <div class="alert alert-info shadow-sm">Sistemde henüz yemek bulunmuyor. Eklemeye başla!</div>
                            </div>
            <%
                        }
                    } else {
                        // Veritabanı şifresi veya URL yanlışsa çıkacak hata
                        out.println("<div class='col-12'><div class='alert alert-danger'>Veritabanı bağlantısı kurulamadı. util.Veritabani sınıfındaki şifreyi kontrol et!</div></div>");
                    }
                } catch(Exception e) {
                    out.println("<div class='col-12'><div class='alert alert-danger'>Sistem Hatası: " + e.getMessage() + "</div></div>");
                } finally {
                    // İşlem bitince veritabanı yorulmasın diye kapıları kapatıyoruz
                    if(rs != null) try { rs.close(); } catch(SQLException e) {}
                    if(stmt != null) try { stmt.close(); } catch(SQLException e) {}
                    if(conn != null) try { conn.close(); } catch(SQLException e) {}
                }
            %>

        </div>
    </div>

</body>
</html>
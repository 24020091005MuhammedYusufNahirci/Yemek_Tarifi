<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.Veritabani"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Yeni Tarif - JSP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .custom-card { border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .custom-header { background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); color: white; border-radius: 20px 20px 0 0 !important; }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5 mb-5">
    <div class="row">
        <div class="col-md-8 mx-auto">
            <div class="card custom-card">
                <div class="card-header custom-header p-4 text-center">
                    <h3 class="mb-0 fw-bold"> Yeni Tarif Oluştur (JSP & Postgres)</h3>
                </div>
                <div class="card-body p-4 p-md-5">
                    <form action="islem_kaydet.jsp" method="POST">
                        
                        <div class="form-floating mb-4">
                            <input type="text" name="yemek_adi" class="form-control rounded-3" id="yAdi" placeholder="Yemek Adi" required>
                            <label for="yAdi">🍽️ Yemeğin Adı</label>
                        </div>
                        
                        <div class="form-floating mb-4">
                            <input type="text" name="foto_url" class="form-control rounded-3" id="fUrl" placeholder="Foto URL">
                            <label for="fUrl">📸 Fotoğraf URL'si</label>
                        </div>

                        <div class="form-floating mb-5">
                            <textarea name="tarif_detay" class="form-control rounded-3" id="tDetay" placeholder="Tarif" style="height: 150px"></textarea>
                            <label for="tDetay">📝 Hazırlanışı</label>
                        </div>

                        <h6 class="fw-bold mb-3 text-secondary border-bottom pb-2">Malzeme Seçimi</h6>
                        <div class="row g-3 mb-4" style="max-height: 250px; overflow-y: auto;">
                            <%
                                // Veritabanındaki malzemeleri listelemek için Java kodumuzu açıyoruz
                                try (Connection conn = Veritabani.baglantiGetir();
                                     Statement stmt = conn.createStatement();
                                     ResultSet rs = stmt.executeQuery("SELECT * FROM malzemeler ORDER BY malzeme_adi")) {
                                    
                                    while(rs.next()) {
                                        int mid = rs.getInt("id");
                                        String mAd = rs.getString("malzeme_adi");
                            %>
                            <div class="col-md-6">
                                <div class="p-3 border rounded-3 bg-white d-flex align-items-center">
                                    <div class="form-check form-switch me-3">
                                        <input class="form-check-input" type="checkbox" name="secilen_malzemeler" value="<%= mid %>" id="m_<%= mid %>">
                                    </div>
                                    <div class="flex-grow-1">
                                        <label class="fw-bold d-block mb-1" for="m_<%= mid %>"><%= mAd %></label>
                                        <input type="text" name="miktar_<%= mid %>" class="form-control form-control-sm border-0 bg-light" placeholder="Miktar">
                                    </div>
                                </div>
                            </div>
                            <%      }
                                } catch(Exception e) { out.print("Hata: " + e.getMessage()); }
                            %>
                        </div>

                        <div class="d-grid gap-3 d-md-flex justify-content-md-end mt-5 pt-3 border-top">
                            <a href="index.jsp" class="btn btn-light btn-lg rounded-pill px-4">Vazgeç</a>
                            <button type="submit" class="btn btn-success btn-lg rounded-pill px-5 shadow-sm fw-bold">Kaydet ve Yayınla</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
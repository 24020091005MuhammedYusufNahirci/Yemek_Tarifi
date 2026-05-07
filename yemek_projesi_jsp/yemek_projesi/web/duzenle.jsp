<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.Veritabani"%>
<%@page import="java.util.HashSet"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tarifi Düzenle - JSP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .custom-card { border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1); }
        .custom-header { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; border-radius: 20px 20px 0 0 !important; }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5 mb-5">
    <%
        String id = request.getParameter("id");
        Connection conn = null;
        try {
            conn = Veritabani.baglantiGetir();
            
            // 1. Yemeğin mevcut bilgilerini çek
            PreparedStatement psYemek = conn.prepareStatement("SELECT * FROM yemekler WHERE id = ?");
            psYemek.setInt(1, Integer.parseInt(id));
            ResultSet rsYemek = psYemek.executeQuery();

            if(rsYemek.next()) {
                // Seçili malzemeleri hızlıca kontrol etmek için bir listeye alalım
                HashSet<Integer> seciliMlzIdleri = new HashSet<>();
                java.util.HashMap<Integer, String> mlzMiktarlari = new java.util.HashMap<>();
                
                PreparedStatement psSecili = conn.prepareStatement("SELECT malzeme_id, miktar FROM yemek_malzeme WHERE yemek_id = ?");
                psSecili.setInt(1, Integer.parseInt(id));
                ResultSet rsSecili = psSecili.executeQuery();
                while(rsSecili.next()){
                    seciliMlzIdleri.add(rsSecili.getInt("malzeme_id"));
                    mlzMiktarlari.put(rsSecili.getInt("malzeme_id"), rsSecili.getString("miktar"));
                }
    %>
    <div class="row">
        <div class="col-md-9 mx-auto">
            <div class="card custom-card">
                <div class="card-header custom-header p-4 text-center">
                    <h3 class="mb-0 fw-bold">🛠️ Tarifi Güncelle: <%= rsYemek.getString("yemek_adi") %></h3>
                </div>
                <div class="card-body p-4 p-md-5">
                    <form action="islem_duzenle.jsp" method="POST">
                        <input type="hidden" name="id" value="<%= id %>">
                        
                        <div class="form-floating mb-4">
                            <input type="text" name="yemek_adi" class="form-control rounded-3" value="<%= rsYemek.getString("yemek_adi") %>" required>
                            <label>🍽️ Yemeğin Adı</label>
                        </div>
                        
                        <div class="form-floating mb-4">
                            <input type="text" name="foto_url" class="form-control rounded-3" value="<%= rsYemek.getString("fotograf_url") %>">
                            <label>📸 Fotoğraf URL'si</label>
                        </div>

                        <div class="form-floating mb-5">
                            <textarea name="tarif_detay" class="form-control rounded-3" style="height: 150px"><%= rsYemek.getString("tarif_detay") %></textarea>
                            <label>📝 Hazırlanışı</label>
                        </div>

                        <h6 class="fw-bold mb-3 text-secondary border-bottom pb-2">Malzemeleri Güncelle</h6>
                        <div class="row g-3 mb-4" style="max-height: 300px; overflow-y: auto;">
                            <%
                                Statement stmtMlz = conn.createStatement();
                                ResultSet rsMlz = stmtMlz.executeQuery("SELECT * FROM malzemeler ORDER BY malzeme_adi");
                                while(rsMlz.next()) {
                                    int mid = rsMlz.getInt("id");
                                    boolean seciliMi = seciliMlzIdleri.contains(mid);
                                    String miktar = seciliMi ? mlzMiktarlari.get(mid) : "";
                            %>
                            <div class="col-md-6">
                                <div class="p-3 border rounded-3 <%= seciliMi ? "bg-light border-primary" : "bg-white" %> d-flex align-items-center">
                                    <div class="form-check form-switch me-3">
                                        <input class="form-check-input" type="checkbox" name="secilen_malzemeler" value="<%= mid %>" <%= seciliMi ? "checked" : "" %>>
                                    </div>
                                    <div class="flex-grow-1">
                                        <label class="fw-bold d-block mb-1"><%= rsMlz.getString("malzeme_adi") %></label>
                                        <input type="text" name="miktar_<%= mid %>" class="form-control form-control-sm" placeholder="Miktar" value="<%= miktar %>">
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>

                        <div class="d-grid gap-3 d-md-flex justify-content-md-end mt-5 pt-3 border-top">
                            <a href="detay.jsp?id=<%= id %>" class="btn btn-light btn-lg rounded-pill px-4">Vazgeç</a>
                            <button type="submit" class="btn btn-primary btn-lg rounded-pill px-5 shadow-sm fw-bold">Değişiklikleri Kaydet</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <%
            }
        } catch(Exception e) { out.print("Hata: " + e.getMessage()); }
        finally { if(conn != null) conn.close(); }
    %>
</div>

</body>
</html>
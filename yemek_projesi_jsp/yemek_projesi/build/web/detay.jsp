<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.Veritabani"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tarif Detayı - JSP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .recipe-card { border-radius: 20px; overflow: hidden; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .ingredient-badge { background-color: #f8f9fa; border: 1px solid #dee2e6; color: #333; transition: 0.3s; }
        .ingredient-badge:hover { background-color: #e9ecef; }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5 mb-5">
    <%
        String id = request.getParameter("id");
        Connection conn = null;
        PreparedStatement psYemek = null;
        PreparedStatement psMalzeme = null;
        ResultSet rsYemek = null;
        ResultSet rsMalzeme = null;

        try {
            conn = Veritabani.baglantiGetir();
            
            // 1. Yemeğin ana bilgilerini çekiyoruz
            String sqlYemek = "SELECT * FROM yemekler WHERE id = ?";
            psYemek = conn.prepareStatement(sqlYemek);
            psYemek.setInt(1, Integer.parseInt(id));
            rsYemek = psYemek.executeQuery();

            if(rsYemek.next()) {
    %>
    <div class="row">
        <div class="col-md-8">
            <div class="card recipe-card bg-white">
                <img src="<%= rsYemek.getString("fotograf_url") %>" class="img-fluid" style="width: 100%; max-height: 450px; object-fit: cover;">
                <div class="card-body p-4 p-md-5">
                    <h1 class="fw-bold text-success mb-4"><%= rsYemek.getString("yemek_adi") %></h1>
                    <hr>
                    <h4 class="fw-bold mb-3">📝 Hazırlanışı</h4>
                    <p class="lead text-muted" style="white-space: pre-line; line-height: 1.8;">
                        <%= rsYemek.getString("tarif_detay") %>
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card recipe-card shadow-sm mb-4">
                <div class="card-header bg-warning py-3 text-center">
                    <h5 class="mb-0 fw-bold">🛒 Gerekli Malzemeler</h5>
                </div>
                <div class="list-group list-group-flush">
                    <%
                        // JOIN sorgusu ile yemek_malzeme ve malzemeler tablosunu birleştiriyoruz
                        String sqlMalzeme = "SELECT m.malzeme_adi, ym.miktar FROM yemek_malzeme ym " +
                                           "JOIN malzemeler m ON ym.malzeme_id = m.id " +
                                           "WHERE ym.yemek_id = ?";
                        psMalzeme = conn.prepareStatement(sqlMalzeme);
                        psMalzeme.setInt(1, Integer.parseInt(id));
                        rsMalzeme = psMalzeme.executeQuery();

                        boolean malzemeVarMi = false;
                        while(rsMalzeme.next()) {
                            malzemeVarMi = true;
                    %>
                    <div class="list-group-item d-flex justify-content-between align-items-center py-3">
                        <span class="fw-semibold"><%= rsMalzeme.getString("malzeme_adi") %></span>
                        <span class="badge rounded-pill bg-secondary px-3 py-2"><%= rsMalzeme.getString("miktar") %></span>
                    </div>
                    <%
                        }
                        if(!malzemeVarMi) {
                            out.print("<div class='list-group-item text-center text-muted py-4'>Bu tarif için malzeme girilmemiş.</div>");
                        }
                    %>
                </div>
            </div>
            
            <div class="d-grid gap-2">
                <a href="index.jsp" class="btn btn-dark btn-lg rounded-pill shadow-sm">⬅ Listeye Geri Dön</a>
                <a href="duzenle.jsp?id=<%= id %>" class="btn btn-outline-primary btn-lg rounded-pill">✏️ Tarifi Düzenle</a>
            </div>
        </div>
    </div>
    <%
            } else {
                out.print("<div class='alert alert-danger'>Yemek bulunamadı!</div>");
            }
        } catch(Exception e) {
            out.print("<div class='alert alert-danger'>Hata: " + e.getMessage() + "</div>");
        } finally {
            if(rsYemek != null) rsYemek.close();
            if(rsMalzeme != null) rsMalzeme.close();
            if(psYemek != null) psYemek.close();
            if(psMalzeme != null) psMalzeme.close();
            if(conn != null) conn.close();
        }
    %>
</div>

</body>
</html>
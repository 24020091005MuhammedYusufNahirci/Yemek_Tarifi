<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.Veritabani"%>
<%
    // Formdan gelen ana verileri aliyoruz
    request.setCharacterEncoding("UTF-8"); // Turkce karakter sorunu olmamasi icin
    String yemekAdi = request.getParameter("yemek_adi");
    String fotoUrl = request.getParameter("foto_url");
    String tarifDetay = request.getParameter("tarif_detay");
    String[] secilenMalzemeler = request.getParameterValues("secilen_malzemeler");

    Connection conn = null;
    PreparedStatement psYemek = null;
    PreparedStatement psMlz = null;

    try {
        conn = Veritabani.baglantiGetir();
        conn.setAutoCommit(false); // Transaction baslatiyoruz (Ya hepsi ya hicbiri!)

        // 1. Yemegi ekliyoruz ve PostgreSQL'den olusan yeni ID'yi istiyoruz
        String sqlYemek = "INSERT INTO yemekler (yemek_adi, tarif_detay, fotograf_url) VALUES (?, ?, ?) RETURNING id";
        psYemek = conn.prepareStatement(sqlYemek);
        psYemek.setString(1, yemekAdi);
        psYemek.setString(2, tarifDetay);
        psYemek.setString(3, fotoUrl);
        
        ResultSet rs = psYemek.executeQuery();
        int yeniYemekId = 0;
        if(rs.next()) {
            yeniYemekId = rs.getInt(1);
        }

        // 2. Secilen malzemeleri ilişki tablosuna ekliyoruz
        if(secilenMalzemeler != null && yeniYemekId > 0) {
            String sqlMlz = "INSERT INTO yemek_malzeme (yemek_id, malzeme_id, miktar) VALUES (?, ?, ?)";
            psMlz = conn.prepareStatement(sqlMlz);
            
            for(String mIdStr : secilenMalzemeler) {
                int mId = Integer.parseInt(mIdStr);
                String miktar = request.getParameter("miktar_" + mId);
                
                if(miktar != null && !miktar.trim().isEmpty()) {
                    psMlz.setInt(1, yeniYemekId);
                    psMlz.setInt(2, mId);
                    psMlz.setString(3, miktar);
                    psMlz.executeUpdate();
                }
            }
        }

        conn.commit(); // Her sey yolunda, veritabanina yaz!
        response.sendRedirect("index.jsp"); // Ana sayfaya don

    } catch(Exception e) {
        if(conn != null) conn.rollback(); // Hata varsa islemleri geri al
        out.println("Kritik Hata: " + e.getMessage());
    } finally {
        if(psYemek != null) psYemek.close();
        if(psMlz != null) psMlz.close();
        if(conn != null) conn.close();
    }
%>
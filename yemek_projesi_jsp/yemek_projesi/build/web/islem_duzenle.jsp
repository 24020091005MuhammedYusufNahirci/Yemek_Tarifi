<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.Veritabani"%>
<%
    request.setCharacterEncoding("UTF-8");
    int id = Integer.parseInt(request.getParameter("id"));
    String yemekAdi = request.getParameter("yemek_adi");
    String fotoUrl = request.getParameter("foto_url");
    String tarifDetay = request.getParameter("tarif_detay");
    String[] secilenMalzemeler = request.getParameterValues("secilen_malzemeler");

    Connection conn = null;
    try {
        conn = Veritabani.baglantiGetir();
        conn.setAutoCommit(false); // Transaction

        // 1. Yemek tablosunu guncelle
        PreparedStatement psUp = conn.prepareStatement("UPDATE yemekler SET yemek_adi=?, tarif_detay=?, fotograf_url=? WHERE id=?");
        psUp.setString(1, yemekAdi);
        psUp.setString(2, tarifDetay);
        psUp.setString(3, fotoUrl);
        psUp.setInt(4, id);
        psUp.executeUpdate();

        // 2. Eski malzemeleri sil (temiz bir baslangic icin)
        PreparedStatement psDel = conn.prepareStatement("DELETE FROM yemek_malzeme WHERE yemek_id=?");
        psDel.setInt(1, id);
        psDel.executeUpdate();

        // 3. Yeni secilenleri ekle
        if(secilenMalzemeler != null) {
            PreparedStatement psIns = conn.prepareStatement("INSERT INTO yemek_malzeme (yemek_id, malzeme_id, miktar) VALUES (?, ?, ?)");
            for(String mIdStr : secilenMalzemeler) {
                int mid = Integer.parseInt(mIdStr);
                String miktar = request.getParameter("miktar_" + mid);
                if(miktar != null && !miktar.trim().isEmpty()) {
                    psIns.setInt(1, id);
                    psIns.setInt(2, mid);
                    psIns.setString(3, miktar);
                    psIns.executeUpdate();
                }
            }
        }

        conn.commit();
        response.sendRedirect("detay.jsp?id=" + id); // Guncelleme bitince detay sayfasina geri don

    } catch(Exception e) {
        if(conn != null) conn.rollback();
        out.print("Güncelleme Hatası: " + e.getMessage());
    } finally {
        if(conn != null) conn.close();
    }
%>
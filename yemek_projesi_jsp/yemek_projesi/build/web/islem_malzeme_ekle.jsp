<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.Veritabani"%>
<%
    // Formdan gelen veriyi aliyoruz
    request.setCharacterEncoding("UTF-8");
    String malzemeAdi = request.getParameter("malzeme_adi");

    if (malzemeAdi != null && !malzemeAdi.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = Veritabani.baglantiGetir();
            String sql = "INSERT INTO malzemeler (malzeme_adi) VALUES (?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, malzemeAdi);
            
            ps.executeUpdate();
            
            // Malzeme eklenince direkt "Yeni Tarif" sayfasina gitsin ki tarif yazmaya devam edelim
            response.sendRedirect("yeni.jsp"); 

        } catch (Exception e) {
            out.println("Hata oluştu: " + e.getMessage());
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    } else {
        response.sendRedirect("malzeme_ekle.jsp");
    }
%>
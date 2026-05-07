<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.Veritabani"%>
<%
    // URL'den gelen id parametresini alıyoruz
    String id = request.getParameter("id");

    if (id != null) {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = Veritabani.baglantiGetir();
            
            // Yemekler tablosundan siliyoruz. 
            // Postgres'teki CASCADE ayarın sayesinde yemek_malzeme'dekiler de otomatik silinecek!
            String sql = "DELETE FROM yemekler WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(id));
            
            ps.executeUpdate();
            
            // Silme işlemi bitince ana sayfaya geri dönüyoruz
            response.sendRedirect("index.jsp");

        } catch (Exception e) {
            out.println("<div style='color:red;'>Silme hatası: " + e.getMessage() + "</div>");
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    } else {
        response.sendRedirect("index.jsp");
    }
%>
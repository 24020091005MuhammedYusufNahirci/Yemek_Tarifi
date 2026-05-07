package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Veritabani {
    
    private static final String URL = "jdbc:postgresql://localhost:5433/yemek";
    private static final String KULLANICI = "postgres"; 
    private static final String SIFRE = "yusufefe05"; 
    
    public static Connection baglantiGetir() {
        Connection conn = null;
        try {
            // PostgreSQL surucusunu yukluyoruz
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(URL, KULLANICI, SIFRE);
            System.out.println("Baglanti basarili!");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver bulunamadi: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Baglanti hatasi: " + e.getMessage());
        }
        return conn;
    }
}
using Microsoft.EntityFrameworkCore;
using yemek_tarifi.Models;

namespace yemek_tarifi.Models
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<Yemek> Yemekler { get; set; }
        public DbSet<Malzeme> Malzemeler { get; set; }
        public DbSet<YemekMalzeme> YemekMalzemeler { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // 1. Tablo İsimlerini Eşleştiriyoruz
            modelBuilder.Entity<Yemek>().ToTable("yemekler");
            modelBuilder.Entity<Malzeme>().ToTable("malzemeler");
            modelBuilder.Entity<YemekMalzeme>().ToTable("yemek_malzeme");

            // 2. Yemek Tablosu Sütun Eşleştirmeleri
            modelBuilder.Entity<Yemek>().Property(y => y.Id).HasColumnName("id"); // Büyük Id -> küçük id
            modelBuilder.Entity<Yemek>().Property(y => y.YemekAdi).HasColumnName("yemek_adi");
            modelBuilder.Entity<Yemek>().Property(y => y.TarifDetay).HasColumnName("tarif_detay");
            modelBuilder.Entity<Yemek>().Property(y => y.FotografUrl).HasColumnName("fotograf_url");

            // 3. Malzeme Tablosu Sütun Eşleştirmeleri
            modelBuilder.Entity<Malzeme>().Property(m => m.Id).HasColumnName("id");
            modelBuilder.Entity<Malzeme>().Property(m => m.MalzemeAdi).HasColumnName("malzeme_adi");

            // 4. Yemek_Malzeme (İlişkisel) Tablo Ayarları
            modelBuilder.Entity<YemekMalzeme>().HasKey(ym => new { ym.YemekId, ym.MalzemeId });
            modelBuilder.Entity<YemekMalzeme>().Property(ym => ym.YemekId).HasColumnName("yemek_id");
            modelBuilder.Entity<YemekMalzeme>().Property(ym => ym.MalzemeId).HasColumnName("malzeme_id");
            modelBuilder.Entity<YemekMalzeme>().Property(ym => ym.Miktar).HasColumnName("miktar");
        }
    }
}
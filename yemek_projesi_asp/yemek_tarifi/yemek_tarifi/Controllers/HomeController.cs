using Microsoft.AspNetCore.Mvc;
using yemek_tarifi.Models;
using System.Linq;

namespace yemek_tarifi.Controllers
{
    public class HomeController : Controller
    {
        private readonly AppDbContext _context;

        public HomeController(AppDbContext context)
        {
            _context = context;
        }

        // --- 1. ANA SAYFA LİSTELEME İŞLEMİ ---
        public IActionResult Index()
        {
            var yemekler = _context.Yemekler.ToList();
            return View(yemekler);
        }

        // --- 2. DETAY SAYFASI VE MALZEMELERİ ÇEKME İŞLEMİ ---
        public IActionResult Detay(int id)
        {
            // Tıklanan yemeği veritabanından buluyoruz
            var yemek = _context.Yemekler.FirstOrDefault(y => y.Id == id);

            if (yemek == null)
            {
                return NotFound(); // Eğer yemek silinmişse veya yoksa 404 sayfasına atar
            }

            // Bu yemeğe ait malzemeleri SQL JOIN mantığıyla çekiyoruz
            var malzemeListesi = (from ym in _context.YemekMalzemeler
                                  join m in _context.Malzemeler on ym.MalzemeId equals m.Id
                                  where ym.YemekId == id
                                  select new
                                  {
                                      Ad = m.MalzemeAdi,
                                      Miktar = ym.Miktar
                                  }).ToList();

            // Malzemeleri ekranda göstermek için ViewBag içine paketliyoruz
            ViewBag.Malzemeler = malzemeListesi;

            // Bulduğumuz yemeği ve malzemeleri görsele (View) gönderiyoruz
            return View(yemek);
        }
    }
}
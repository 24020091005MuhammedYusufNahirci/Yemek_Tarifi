using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using yemek_tarifi.Models;
using System.Linq;
using System.Collections.Generic;

namespace yemek_tarifi.Controllers
{
    public class YonetimController : Controller
    {
        private readonly AppDbContext _context;

        public YonetimController(AppDbContext context)
        {
            _context = context;
        }

        // --- 1. YENİ KAYIT EKRANI (GET) ---
        public IActionResult Yeni()
        {
            ViewBag.Malzemeler = _context.Malzemeler.OrderBy(m => m.MalzemeAdi).ToList();
            return View();
        }

        // --- 2. YENİ KAYDETME İŞLEMİ (POST) ---
        // DİKKAT: string[] yerine Dictionary<int, string> kullandık
        [HttpPost]
        public IActionResult Yeni(Yemek yeniYemek, int[] secilenMalzemeler, Dictionary<int, string> miktarlar)
        {
            if (ModelState.IsValid)
            {
                _context.Yemekler.Add(yeniYemek);
                _context.SaveChanges();

                for (int i = 0; i < secilenMalzemeler.Length; i++)
                {
                    var m_id = secilenMalzemeler[i];

                    // Sözlükte bu ID var mı diye güvenli kontrol yapıyoruz
                    var miktar = miktarlar.ContainsKey(m_id) ? miktarlar[m_id] : "";

                    if (!string.IsNullOrEmpty(miktar))
                    {
                        var iliski = new YemekMalzeme
                        {
                            YemekId = yeniYemek.Id,
                            MalzemeId = m_id,
                            Miktar = miktar
                        };
                        _context.YemekMalzemeler.Add(iliski);
                    }
                }
                _context.SaveChanges();
                return RedirectToAction("Index", "Home");
            }
            return View(yeniYemek);
        }

        // --- 3. DÜZENLEME EKRANI (GET) ---
        public IActionResult Duzenle(int id)
        {
            var yemek = _context.Yemekler.Find(id);
            if (yemek == null) return NotFound();

            ViewBag.Malzemeler = _context.Malzemeler.OrderBy(m => m.MalzemeAdi).ToList();
            ViewBag.SeciliMalzemeler = _context.YemekMalzemeler.Where(ym => ym.YemekId == id).ToList();

            return View(yemek);
        }

        // --- 4. DÜZENLEMEYİ KAYDETME (POST) ---
        // DİKKAT: Burada da Dictionary kullandık
        [HttpPost]
        public IActionResult Duzenle(Yemek guncelYemek, int[] secilenMalzemeler, Dictionary<int, string> miktarlar)
        {
            if (ModelState.IsValid)
            {
                _context.Yemekler.Update(guncelYemek);

                var eskiMalzemeler = _context.YemekMalzemeler.Where(ym => ym.YemekId == guncelYemek.Id).ToList();
                _context.YemekMalzemeler.RemoveRange(eskiMalzemeler);

                for (int i = 0; i < secilenMalzemeler.Length; i++)
                {
                    var m_id = secilenMalzemeler[i];

                    // Güvenli sözlük kontrolü
                    var miktar = miktarlar.ContainsKey(m_id) ? miktarlar[m_id] : "";

                    if (!string.IsNullOrEmpty(miktar))
                    {
                        var iliski = new YemekMalzeme
                        {
                            YemekId = guncelYemek.Id,
                            MalzemeId = m_id,
                            Miktar = miktar
                        };
                        _context.YemekMalzemeler.Add(iliski);
                    }
                }

                _context.SaveChanges();
                return RedirectToAction("Detay", "Home", new { id = guncelYemek.Id });
            }

            return View(guncelYemek);
        }

        // --- 5. SİLME İŞLEMİ ---
        public IActionResult Sil(int id)
        {
            var yemek = _context.Yemekler.Find(id);
            if (yemek != null)
            {
                _context.Yemekler.Remove(yemek);
                _context.SaveChanges();
            }
            return RedirectToAction("Index", "Home");
        }
    }
}
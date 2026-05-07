<?php
require_once 'baglanti.php';

// --- CREATE (EKLEME) ISLEMI ---
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['islem']) && $_POST['islem'] == 'ekle') {
    $yemek_adi = trim($_POST['yemek_adi']);
    $tarif_detay = trim($_POST['tarif_detay']);
    $fotograf_url = trim($_POST['fotograf_url']);

    if (!empty($yemek_adi)) {
        // 1. Önce yemeği 'yemekler' tablosuna ekliyoruz
        $sql = "INSERT INTO yemekler (yemek_adi, tarif_detay, fotograf_url) VALUES (?, ?, ?)";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$yemek_adi, $tarif_detay, $fotograf_url]);
        
        // 2. Eklenen bu yeni yemeğin ID'sini alıyoruz (Malzemeleri buna bağlayacağız)
        $yeni_yemek_id = $pdo->lastInsertId();

        // 3. Eğer formda malzeme seçildiyse, bunları 'yemek_malzeme' tablosuna ekliyoruz
        if (isset($_POST['secilen_malzemeler']) && is_array($_POST['secilen_malzemeler'])) {
            $sql_malzeme = "INSERT INTO yemek_malzeme (yemek_id, malzeme_id, miktar) VALUES (?, ?, ?)";
            $stmt_malzeme = $pdo->prepare($sql_malzeme);

            foreach ($_POST['secilen_malzemeler'] as $malzeme_id) {
                // Seçilen malzemenin miktarını alıyoruz (boş bırakıldıysa boş kaydeder)
                $miktar = $_POST['miktarlar'][$malzeme_id] ?? '';
                // Yemek ID, Malzeme ID ve Miktar bilgisini ilişkisel tabloya yazıyoruz
                $stmt_malzeme->execute([$yeni_yemek_id, $malzeme_id, $miktar]);
            }
        }

        $mesaj = "Yemek ve malzemeleri başarıyla eklendi!";
    }
}

// --- DELETE (SILME) ISLEMI ---
if (isset($_GET['sil_id'])) {
    $sil_id = $_GET['sil_id'];
    $sql = "DELETE FROM yemekler WHERE id = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$sil_id]);
    header("Location: yeni_tarif.php"); 
    exit;
}

// --- VERITABANINDAN YEMEKLERI CEK (Sagdaki liste icin) ---
$sorgu_yemekler = $pdo->query("SELECT * FROM yemekler ORDER BY id DESC");
$liste_yemekler = $sorgu_yemekler->fetchAll(PDO::FETCH_ASSOC);

// --- VERITABANINDAN MALZEMELERI CEK (Soldaki form icin) ---
$sorgu_malzemeler = $pdo->query("SELECT * FROM malzemeler ORDER BY malzeme_adi ASC");
$liste_malzemeler = $sorgu_malzemeler->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Tarif Yönetimi - CRUD Operasyonları</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4 shadow">
        <div class="container">
            <a class="navbar-brand" href="index.php">⬅ Ana Ekrana Dön</a>
            <span class="navbar-text text-white">Tarif Yönetim Paneli</span>
        </div>
    </nav>

    <div class="container">
        <?php if(isset($mesaj)): ?>
            <div class="alert alert-success"><?= $mesaj ?></div>
        <?php endif; ?>

        <div class="row">
            <div class="col-md-5 mb-4">
                <div class="card shadow border-0">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Yeni Tarif Ekle (Create)</h5>
                    </div>
                    <div class="card-body">
                        <form action="yeni_tarif.php" method="POST">
                            <input type="hidden" name="islem" value="ekle">
                            
                            <div class="mb-3">
                                <label class="form-label">Yemek Adı</label>
                                <input type="text" name="yemek_adi" class="form-control" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Fotoğraf URL</label>
                                <input type="text" name="fotograf_url" class="form-control" placeholder="https://ornek.com/resim.jpg">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Tarif Detayı & Yapılışı</label>
                                <textarea name="tarif_detay" class="form-control" rows="4"></textarea>
                            </div>

                            <div class="mb-3 p-3 bg-white border rounded shadow-sm" style="max-height: 250px; overflow-y: auto;">
                                <label class="form-label fw-bold text-danger">Kullanılacak Malzemeleri Seçin</label>
                                
                                <?php foreach($liste_malzemeler as $mlz): ?>
                                    <div class="input-group mb-2">
                                        <div class="input-group-text bg-light">
                                            <input class="form-check-input mt-0" type="checkbox" name="secilen_malzemeler[]" value="<?= $mlz['id'] ?>" id="mlz_<?= $mlz['id'] ?>">
                                        </div>
                                        
                                        <label class="form-control bg-light" for="mlz_<?= $mlz['id'] ?>">
                                            <?= htmlspecialchars($mlz['malzeme_adi']) ?>
                                        </label>
                                        
                                        <input type="text" name="miktarlar[<?= $mlz['id'] ?>]" class="form-control" placeholder="Miktar (Örn: 2 Adet)">
                                    </div>
                                <?php endforeach; ?>
                            </div>

                            <button type="submit" class="btn btn-success w-100">Kaydet</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <div class="card shadow border-0 mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Tarif Listesi (Read & Delete)</h5>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Yemek Adı</th>
                                    <th>Alışveriş Listesi</th>
                                    <th>İşlemler</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach($liste_yemekler as $satir): ?>
                                <tr>
                                    <td class="fw-bold align-middle"><?= htmlspecialchars($satir['yemek_adi']) ?></td>
                                    <td class="align-middle">
                                        <a href="detay.php?id=<?= $satir['id'] ?>" target="_blank" class="btn btn-sm btn-outline-secondary">Malzemeleri Gör</a>
                                    </td>
                                    <td class="align-middle">
                                        <a href="duzenle.php?id=<?= $satir['id'] ?>" class="btn btn-sm btn-warning">Düzenle</a>
                                        <a href="yeni_tarif.php?sil_id=<?= $satir['id'] ?>" class="btn btn-sm btn-danger" onclick="return confirm('Bu yemeği silmek istediğinize emin misiniz? (Bağlı malzemeler de silinecektir)');">Sil</a>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>

</body>
</html>
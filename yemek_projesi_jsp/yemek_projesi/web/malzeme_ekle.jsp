<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Malzeme Ekle - JSP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row">
        <div class="col-md-6 mx-auto">
            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-header bg-primary text-white p-3 rounded-top-4">
                    <h5 class="mb-0">🥦 Yeni Malzeme Tanımla</h5>
                </div>
                <div class="card-body p-4">
                    <form action="islem_malzeme_ekle.jsp" method="POST">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Malzeme Adı</label>
                            <input type="text" name="malzeme_adi" class="form-control" placeholder="Örn: Patlıcan, Kıyma, Tuz..." required>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="index.jsp" class="btn btn-light border flex-grow-1">İptal</a>
                            <button type="submit" class="btn btn-primary flex-grow-1">Sisteme Ekle</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
# Veteriner Klinik ve Hayvan Sağlığı Yönetim Sistemi

İleri Veri Tabanı Sistemleri Dersi Projesi - PostgreSQL + Python

##  Proje Yapısı

```
veteriner_klinik_proje/
├── sql/
│   ├── 01_ddl.sql              # Tablo oluşturma komutları
│   ├── 02_dml_veri.sql         # Test verileri
│   ├── 03_views.sql            # Görünümler
│   ├── 04_procedures.sql       # Stored Procedure'lar
│   ├── 05_triggers.sql         # Tetikleyiciler
│   ├── 06_indexes.sql          # İndeksler
│   └── 07_sorgular.sql         # 10 karmaşık sorgu
├── src/
│   ├── db_config.py            # Veritabanı bağlantı ayarları
│   ├── setup_database.py       # Veritabanını kuran script
│   ├── main.py                 # Ana menü programı
│   └── sorgular_test.py        # 10 sorguyu test eden script
├── requirements.txt
└── README.md
```

##  Kurulum Adımları (PyCharm)

### 1. PostgreSQL Kurulumu
- PostgreSQL 16.x indir: https://www.postgresql.org/download/
- Kurulum sırasında `postgres` kullanıcısı için bir şifre belirle (örn: `postgres123`)
- Port: 5432 (varsayılan)

### 2. Veritabanını Oluştur
pgAdmin veya psql üzerinden:
```sql
CREATE DATABASE veteriner_klinik;
```

### 3. PyCharm'da Projeyi Aç
- PyCharm > File > Open > `veteriner_klinik_proje` klasörünü seç
- Yeni Virtual Environment oluştur (Python 3.10+)

### 4. Gerekli Paketleri Yükle
PyCharm terminalinde:
```bash
pip install -r requirements.txt
```

### 5. Bağlantı Ayarlarını Yap
`src/db_config.py` dosyasını aç ve kendi şifreni yaz:
```python
DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "database": "veteriner_klinik",
    "user": "postgres",
    "password": "postgres123"  # ← Kendi şifrenizi yazın
}
```

### 6. Veritabanını Kur
PyCharm'da `setup_database.py` dosyasını çalıştır (Sağ tık > Run):
- Tüm tabloları oluşturur
- Test verilerini ekler
- View, Procedure, Trigger ve Index'leri kurar

### 7. Ana Programı Çalıştır
`main.py` dosyasını çalıştır - interaktif menü ile:
- 10 karmaşık sorguyu çalıştırabilirsin
- İş kurallarını test edebilirsin (trigger, procedure)
- Yeni randevu, reçete oluşturabilirsin

## 🧪 Test Senaryoları

`main.py` menüsünden test edilebilecek özellikler:
1.  Sorgu 1-10 (Hastalık dağılımı, aşı gecikme, performans vb.)
2.  İK-1: Randevu limiti (15 aşımı)
3.  İK-2: Hayvan silme koruması (soft delete)
4.  İK-3: Stoksuz ilaç reçete engeli
5.  İK-5: Fatura trigger'ı
6.  Transaction senaryosu (BEGIN/COMMIT)

##  Veritabanı İstatistikleri
- 20 tablo
- 2 View
- 2 Stored Procedure
- 2 Trigger
- 16+ İndeks
- 10 Karmaşık Sorgu
- 7 İş Kuralı

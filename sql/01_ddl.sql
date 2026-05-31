-- ═══════════════════════════════════════════════════════════
-- VETERİNER KLİNİK VE HAYVAN SAĞLIĞI YÖNETİM SİSTEMİ
-- 01_DDL.SQL - Tablo Oluşturma Komutları
-- ═══════════════════════════════════════════════════════════

-- Önceki tabloları temizle (sıralama önemli!)
DROP TABLE IF EXISTS log_kaydi CASCADE;
DROP TABLE IF EXISTS fatura_kalem CASCADE;
DROP TABLE IF EXISTS fatura CASCADE;
DROP TABLE IF EXISTS lab_test CASCADE;
DROP TABLE IF EXISTS cerrahi_operasyon CASCADE;
DROP TABLE IF EXISTS asi_kaydi CASCADE;
DROP TABLE IF EXISTS recete_detay CASCADE;
DROP TABLE IF EXISTS recete CASCADE;
DROP TABLE IF EXISTS ilac CASCADE;
DROP TABLE IF EXISTS tedarikci CASCADE;
DROP TABLE IF EXISTS muayene CASCADE;
DROP TABLE IF EXISTS randevu CASCADE;
DROP TABLE IF EXISTS hayvan_alerji CASCADE;
DROP TABLE IF EXISTS hayvan CASCADE;
DROP TABLE IF EXISTS personel CASCADE;
DROP TABLE IF EXISTS veteriner CASCADE;
DROP TABLE IF EXISTS hayvan_sahibi CASCADE;
DROP TABLE IF EXISTS kisi_adres CASCADE;
DROP TABLE IF EXISTS kisi CASCADE;

-- ═══════════════════════════════════════════════════════════
-- KISI (Üst Sınıf)
-- ═══════════════════════════════════════════════════════════
CREATE TABLE kisi (
    kisi_id SERIAL PRIMARY KEY,
    tc_kimlik CHAR(11) NOT NULL UNIQUE,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    telefon VARCHAR(15) NOT NULL,
    e_posta VARCHAR(100),
    kisi_turu VARCHAR(15) NOT NULL
        CHECK (kisi_turu IN ('Sahip', 'Veteriner', 'Personel')),
    kayit_tarihi TIMESTAMP DEFAULT NOW()
);

-- Çok değerli nitelik: adres
CREATE TABLE kisi_adres (
    adres_id SERIAL PRIMARY KEY,
    kisi_id INT NOT NULL REFERENCES kisi(kisi_id) ON DELETE CASCADE,
    adres_turu VARCHAR(20) DEFAULT 'Ev',
    adres_satiri TEXT NOT NULL,
    ilce VARCHAR(50),
    il VARCHAR(50)
);

-- ═══════════════════════════════════════════════════════════
-- ALT SINIFLAR (Genelleme/Uzmanlaşma)
-- ═══════════════════════════════════════════════════════════
CREATE TABLE hayvan_sahibi (
    kisi_id INT PRIMARY KEY REFERENCES kisi(kisi_id) ON DELETE CASCADE,
    acil_irtibat_telefon VARCHAR(15)
);

CREATE TABLE veteriner (
    kisi_id INT PRIMARY KEY REFERENCES kisi(kisi_id) ON DELETE CASCADE,
    diploma_no VARCHAR(20) NOT NULL UNIQUE,
    uzmanlik_alani VARCHAR(50),
    oda_numarasi VARCHAR(10)
);

CREATE TABLE personel (
    kisi_id INT PRIMARY KEY REFERENCES kisi(kisi_id) ON DELETE CASCADE,
    pozisyon VARCHAR(50) NOT NULL,
    maas DECIMAL(10,2),
    calisma_saatleri VARCHAR(50)
);

-- ═══════════════════════════════════════════════════════════
-- HAYVAN
-- ═══════════════════════════════════════════════════════════
CREATE TABLE hayvan (
    hayvan_id SERIAL PRIMARY KEY,
    ad VARCHAR(50) NOT NULL,
    tur VARCHAR(30) NOT NULL,
    irk VARCHAR(50),
    cinsiyet CHAR(1) NOT NULL CHECK (cinsiyet IN ('E', 'D')),
    dogum_tarihi DATE,
    kilo DECIMAL(5,2),
    renk VARCHAR(30),
    mikrocip_no VARCHAR(20) UNIQUE,
    durum VARCHAR(10) DEFAULT 'Aktif'
        CHECK (durum IN ('Aktif', 'Pasif')),
    sahip_id INT NOT NULL REFERENCES kisi(kisi_id)
);

-- Çok değerli nitelik: alerji
CREATE TABLE hayvan_alerji (
    alerji_id SERIAL PRIMARY KEY,
    hayvan_id INT NOT NULL REFERENCES hayvan(hayvan_id) ON DELETE CASCADE,
    alerji_turu VARCHAR(50) NOT NULL,
    aciklama TEXT
);

-- ═══════════════════════════════════════════════════════════
-- RANDEVU
-- ═══════════════════════════════════════════════════════════
CREATE TABLE randevu (
    randevu_id SERIAL PRIMARY KEY,
    tarih_saat TIMESTAMP NOT NULL,
    durum VARCHAR(15) DEFAULT 'Bekliyor'
        CHECK (durum IN ('Bekliyor', 'Onaylandi', 'Iptal', 'Tamamlandi')),
    aciklama TEXT,
    hayvan_id INT NOT NULL REFERENCES hayvan(hayvan_id),
    veteriner_id INT NOT NULL REFERENCES kisi(kisi_id)
);

-- ═══════════════════════════════════════════════════════════
-- MUAYENE
-- ═══════════════════════════════════════════════════════════
CREATE TABLE muayene (
    muayene_id SERIAL PRIMARY KEY,
    tarih_saat TIMESTAMP NOT NULL,
    bitis_saat TIMESTAMP,
    bulgular TEXT,
    tani VARCHAR(200),
    tedavi_plani TEXT,
    notlar TEXT,
    randevu_id INT REFERENCES randevu(randevu_id),
    hayvan_id INT NOT NULL REFERENCES hayvan(hayvan_id),
    veteriner_id INT NOT NULL REFERENCES kisi(kisi_id)
);

-- ═══════════════════════════════════════════════════════════
-- TEDARIKCI
-- ═══════════════════════════════════════════════════════════
CREATE TABLE tedarikci (
    tedarikci_id SERIAL PRIMARY KEY,
    firma_adi VARCHAR(100) NOT NULL,
    yetkili_kisi VARCHAR(100),
    telefon VARCHAR(15),
    e_posta VARCHAR(100),
    adres TEXT
);

-- ═══════════════════════════════════════════════════════════
-- ILAC
-- ═══════════════════════════════════════════════════════════
CREATE TABLE ilac (
    ilac_id SERIAL PRIMARY KEY,
    ilac_adi VARCHAR(100) NOT NULL,
    etken_madde VARCHAR(100),
    kategori VARCHAR(50),
    birim VARCHAR(20),
    stok_miktari INT DEFAULT 0,
    kritik_stok_seviyesi INT DEFAULT 10,
    son_kullanma_tarihi DATE,
    birim_fiyat DECIMAL(10,2),
    tedarikci_id INT REFERENCES tedarikci(tedarikci_id)
);

-- ═══════════════════════════════════════════════════════════
-- RECETE (Zayıf Varlık)
-- ═══════════════════════════════════════════════════════════
CREATE TABLE recete (
    recete_id INT,
    muayene_id INT NOT NULL REFERENCES muayene(muayene_id) ON DELETE CASCADE,
    tarih TIMESTAMP DEFAULT NOW(),
    aciklama TEXT,
    PRIMARY KEY (recete_id, muayene_id)
);

CREATE TABLE recete_detay (
    recete_id INT,
    muayene_id INT,
    ilac_id INT REFERENCES ilac(ilac_id),
    doz VARCHAR(50),
    kullanim_sekli VARCHAR(100),
    sure_gun INT,
    PRIMARY KEY (recete_id, muayene_id, ilac_id),
    FOREIGN KEY (recete_id, muayene_id)
        REFERENCES recete(recete_id, muayene_id) ON DELETE CASCADE
);

-- ═══════════════════════════════════════════════════════════
-- ASI_KAYDI
-- ═══════════════════════════════════════════════════════════
CREATE TABLE asi_kaydi (
    asi_kaydi_id SERIAL PRIMARY KEY,
    asi_turu VARCHAR(50) NOT NULL,
    uygulama_tarihi DATE NOT NULL,
    sonraki_doz_tarihi DATE,
    parti_no VARCHAR(30),
    hayvan_id INT NOT NULL REFERENCES hayvan(hayvan_id),
    veteriner_id INT NOT NULL REFERENCES kisi(kisi_id),
    CONSTRAINT chk_doz_tarihi
        CHECK (sonraki_doz_tarihi IS NULL OR sonraki_doz_tarihi > uygulama_tarihi),
    CONSTRAINT uq_ayni_gun_asi
        UNIQUE (hayvan_id, asi_turu, uygulama_tarihi)
);

-- ═══════════════════════════════════════════════════════════
-- CERRAHI_OPERASYON
-- ═══════════════════════════════════════════════════════════
CREATE TABLE cerrahi_operasyon (
    operasyon_id SERIAL PRIMARY KEY,
    operasyon_turu VARCHAR(100) NOT NULL,
    tarih_saat TIMESTAMP NOT NULL,
    anestezi_turu VARCHAR(50),
    notlar TEXT,
    durum VARCHAR(20) DEFAULT 'Planlanmis',
    hayvan_id INT NOT NULL REFERENCES hayvan(hayvan_id),
    veteriner_id INT NOT NULL REFERENCES kisi(kisi_id)
);

-- ═══════════════════════════════════════════════════════════
-- LAB_TEST
-- ═══════════════════════════════════════════════════════════
CREATE TABLE lab_test (
    test_id SERIAL PRIMARY KEY,
    test_turu VARCHAR(100) NOT NULL,
    tarih DATE NOT NULL,
    sonuc TEXT,
    referans_deger_alt DECIMAL(10,2),
    referans_deger_ust DECIMAL(10,2),
    birim VARCHAR(20),
    durum VARCHAR(20) DEFAULT 'Bekliyor',
    hayvan_id INT NOT NULL REFERENCES hayvan(hayvan_id),
    veteriner_id INT NOT NULL REFERENCES kisi(kisi_id),
    muayene_id INT REFERENCES muayene(muayene_id)
);

-- ═══════════════════════════════════════════════════════════
-- FATURA
-- ═══════════════════════════════════════════════════════════
CREATE TABLE fatura (
    fatura_id SERIAL PRIMARY KEY,
    tarih TIMESTAMP DEFAULT NOW(),
    toplam_tutar DECIMAL(10,2) CHECK (toplam_tutar >= 0),
    odeme_durumu VARCHAR(15) DEFAULT 'Bekliyor'
        CHECK (odeme_durumu IN ('Bekliyor', 'Odendi', 'Iptal')),
    odeme_turu VARCHAR(20),
    muayene_id INT REFERENCES muayene(muayene_id),
    sahip_id INT NOT NULL REFERENCES kisi(kisi_id)
);

CREATE TABLE fatura_kalem (
    fatura_id INT REFERENCES fatura(fatura_id) ON DELETE CASCADE,
    kalem_no INT,
    hizmet_adi VARCHAR(100) NOT NULL,
    miktar INT DEFAULT 1,
    birim_fiyat DECIMAL(10,2) NOT NULL,
    toplam DECIMAL(10,2),
    PRIMARY KEY (fatura_id, kalem_no)
);

-- ═══════════════════════════════════════════════════════════
-- LOG_KAYDI
-- ═══════════════════════════════════════════════════════════
CREATE TABLE log_kaydi (
    log_id SERIAL PRIMARY KEY,
    tablo_adi VARCHAR(50),
    islem_turu VARCHAR(20),
    islem_tarihi TIMESTAMP DEFAULT NOW(),
    eski_deger TEXT,
    yeni_deger TEXT,
    kullanici VARCHAR(50)
);

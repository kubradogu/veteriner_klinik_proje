-- ═══════════════════════════════════════════════════════════
-- 03_VIEWS.SQL - Görünümler
-- ═══════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════
-- GÖRÜNÜM 1: v_hayvan_detay
-- Amaç: Hayvan bilgilerini sahip bilgileriyle birleştirir
-- TC kimlik gizlenir (güvenlik)
-- Sadece aktif hayvanlar gösterilir
-- ═══════════════════════════════════════════════════════════
CREATE OR REPLACE VIEW v_hayvan_detay AS
SELECT
    h.hayvan_id,
    h.ad AS hayvan_adi,
    h.tur,
    h.irk,
    h.cinsiyet,
    h.dogum_tarihi,
    h.kilo,
    h.mikrocip_no,
    EXTRACT(YEAR FROM AGE(h.dogum_tarihi))::INT AS yas,
    k.ad || ' ' || k.soyad AS sahip_adi,
    k.telefon AS sahip_telefon,
    k.e_posta AS sahip_email
FROM hayvan h
JOIN kisi k ON h.sahip_id = k.kisi_id
WHERE h.durum = 'Aktif';

-- ═══════════════════════════════════════════════════════════
-- GÖRÜNÜM 2: v_personel_ozet
-- Amaç: Personel bilgilerini maaş ve TC kimlik gizleyerek sunar
-- Sadece halka açık bilgiler
-- ═══════════════════════════════════════════════════════════
CREATE OR REPLACE VIEW v_personel_ozet AS
SELECT
    k.kisi_id,
    k.ad,
    k.soyad,
    k.telefon,
    k.e_posta,
    p.pozisyon,
    p.calisma_saatleri
FROM kisi k
JOIN personel p ON k.kisi_id = p.kisi_id;

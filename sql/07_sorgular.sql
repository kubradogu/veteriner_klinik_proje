-- ═══════════════════════════════════════════════════════════
-- 07_SORGULAR.SQL - 10 Karmaşık Sorgu
-- ═══════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════
-- SORGU 1: Tür ve Irka Göre Hastalık Dağılım Analizi
-- (İç içe sorgu + Gruplama + Birleştirme)
-- ═══════════════════════════════════════════════════════════
SELECT
    h.tur,
    h.irk,
    m.tani,
    COUNT(*) AS vaka_sayisi,
    ROUND(COUNT(*) * 100.0 / (
        SELECT COUNT(*) FROM muayene m2
        JOIN hayvan h2 ON m2.hayvan_id = h2.hayvan_id
        WHERE h2.tur = h.tur
    ), 2) AS yuzde_oran
FROM muayene m
JOIN hayvan h ON m.hayvan_id = h.hayvan_id
WHERE m.tani IS NOT NULL
GROUP BY h.tur, h.irk, m.tani
HAVING COUNT(*) >= 2
ORDER BY h.tur, vaka_sayisi DESC;


-- ═══════════════════════════════════════════════════════════
-- SORGU 2: Aşı Takvimi Gecikmiş Hayvanlar
-- (Tarih hesaplama + Alt sorgu + Birleştirme)
-- ═══════════════════════════════════════════════════════════
SELECT
    h.ad AS hayvan_adi,
    h.tur,
    h.irk,
    k.ad || ' ' || k.soyad AS sahip_adi,
    k.telefon AS sahip_tel,
    a.asi_turu,
    a.sonraki_doz_tarihi,
    (CURRENT_DATE - a.sonraki_doz_tarihi) AS gecikme_gun
FROM asi_kaydi a
JOIN hayvan h ON a.hayvan_id = h.hayvan_id
JOIN kisi k ON h.sahip_id = k.kisi_id
WHERE a.sonraki_doz_tarihi < CURRENT_DATE
  AND a.asi_kaydi_id = (
      SELECT MAX(a2.asi_kaydi_id)
      FROM asi_kaydi a2
      WHERE a2.hayvan_id = a.hayvan_id
        AND a2.asi_turu = a.asi_turu
  )
ORDER BY gecikme_gun DESC;


-- ═══════════════════════════════════════════════════════════
-- SORGU 3: Veteriner Hekim Aylık Performans Raporu
-- (Gruplama + Toplama fonksiyonları + Birleştirme)
-- ═══════════════════════════════════════════════════════════
SELECT
    k.ad || ' ' || k.soyad AS veteriner_adi,
    v.uzmanlik_alani,
    TO_CHAR(m.tarih_saat, 'YYYY-MM') AS ay,
    COUNT(m.muayene_id) AS muayene_sayisi,
    ROUND(AVG(EXTRACT(EPOCH FROM (m.bitis_saat - m.tarih_saat)) / 60)::NUMERIC, 1) AS ort_sure_dk,
    COUNT(DISTINCT m.hayvan_id) AS benzersiz_hasta
FROM muayene m
JOIN kisi k ON m.veteriner_id = k.kisi_id
JOIN veteriner v ON k.kisi_id = v.kisi_id
WHERE m.bitis_saat IS NOT NULL
GROUP BY k.ad, k.soyad, v.uzmanlik_alani, TO_CHAR(m.tarih_saat, 'YYYY-MM')
ORDER BY ay DESC, muayene_sayisi DESC;


-- ═══════════════════════════════════════════════════════════
-- SORGU 4: Kritik Stok ve Son Kullanma Tarihi Raporu
-- (Filtreleme + Birleştirme + CASE)
-- ═══════════════════════════════════════════════════════════
SELECT
    i.ilac_adi,
    i.etken_madde,
    i.kategori,
    i.stok_miktari,
    i.kritik_stok_seviyesi,
    i.son_kullanma_tarihi,
    t.firma_adi AS tedarikci,
    CASE
        WHEN i.son_kullanma_tarihi < CURRENT_DATE THEN 'SURESI GECMIS'
        WHEN i.son_kullanma_tarihi < CURRENT_DATE + 30 THEN 'SON 30 GUN'
        WHEN i.stok_miktari <= i.kritik_stok_seviyesi THEN 'KRITIK STOK'
        ELSE 'NORMAL'
    END AS uyari_durumu
FROM ilac i
LEFT JOIN tedarikci t ON i.tedarikci_id = t.tedarikci_id
WHERE i.stok_miktari <= i.kritik_stok_seviyesi
   OR i.son_kullanma_tarihi < CURRENT_DATE + 30
ORDER BY
    CASE
        WHEN i.son_kullanma_tarihi < CURRENT_DATE THEN 1
        WHEN i.stok_miktari <= i.kritik_stok_seviyesi THEN 2
        ELSE 3
    END,
    i.son_kullanma_tarihi;


-- ═══════════════════════════════════════════════════════════
-- SORGU 5: Hizmet Türüne Göre Aylık Gelir Analizi
-- (Karmaşık birleştirme + Gruplama + Pencere fonksiyonu)
-- ═══════════════════════════════════════════════════════════
SELECT
    ay,
    hizmet_adi,
    toplam_gelir,
    fatura_sayisi,
    ROUND((toplam_gelir * 100.0 / SUM(toplam_gelir) OVER (PARTITION BY ay))::NUMERIC, 2)
        AS gelir_yuzde
FROM (
    SELECT
        TO_CHAR(f.tarih, 'YYYY-MM') AS ay,
        fk.hizmet_adi,
        SUM(fk.toplam) AS toplam_gelir,
        COUNT(DISTINCT f.fatura_id) AS fatura_sayisi
    FROM fatura f
    JOIN fatura_kalem fk ON f.fatura_id = fk.fatura_id
    WHERE f.odeme_durumu = 'Odendi'
    GROUP BY TO_CHAR(f.tarih, 'YYYY-MM'), fk.hizmet_adi
) alt
ORDER BY ay DESC, toplam_gelir DESC;


-- ═══════════════════════════════════════════════════════════
-- SORGU 6: Hayvan Tedavi Geçmişi Özeti
-- (Çoklu alt sorgular + Birleştirme + Gruplama)
-- ═══════════════════════════════════════════════════════════
SELECT
    h.ad AS hayvan_adi,
    h.tur,
    h.irk,
    (SELECT COUNT(*) FROM muayene WHERE hayvan_id = h.hayvan_id) AS muayene_sayisi,
    (SELECT COUNT(*) FROM asi_kaydi WHERE hayvan_id = h.hayvan_id) AS asi_sayisi,
    (SELECT COUNT(*) FROM cerrahi_operasyon WHERE hayvan_id = h.hayvan_id) AS operasyon_sayisi,
    (SELECT COUNT(*) FROM lab_test WHERE hayvan_id = h.hayvan_id) AS test_sayisi,
    (SELECT COALESCE(SUM(f.toplam_tutar), 0)
     FROM fatura f
     JOIN muayene m ON f.muayene_id = m.muayene_id
     WHERE m.hayvan_id = h.hayvan_id) AS toplam_harcama
FROM hayvan h
WHERE h.durum = 'Aktif'
ORDER BY toplam_harcama DESC
LIMIT 15;


-- ═══════════════════════════════════════════════════════════
-- SORGU 7: En Çok Kullanılan İlaçlar ve Tedarikçi Analizi
-- (Birleştirme + Gruplama + Sıralama + HAVING)
-- ═══════════════════════════════════════════════════════════
SELECT
    i.ilac_adi,
    i.etken_madde,
    i.kategori,
    t.firma_adi AS tedarikci,
    COUNT(rd.ilac_id) AS recete_sayisi,
    SUM(rd.sure_gun) AS toplam_kullanim_gun,
    i.stok_miktari AS mevcut_stok,
    i.birim_fiyat
FROM recete_detay rd
JOIN ilac i ON rd.ilac_id = i.ilac_id
LEFT JOIN tedarikci t ON i.tedarikci_id = t.tedarikci_id
GROUP BY i.ilac_id, i.ilac_adi, i.etken_madde, i.kategori,
         t.firma_adi, i.stok_miktari, i.birim_fiyat
HAVING COUNT(rd.ilac_id) >= 1
ORDER BY recete_sayisi DESC;


-- ═══════════════════════════════════════════════════════════
-- SORGU 8: Ödenmemiş Fatura Takip Raporu
-- (Birleştirme + Filtreleme + CASE)
-- ═══════════════════════════════════════════════════════════
SELECT
    f.fatura_id,
    f.tarih::DATE AS fatura_tarihi,
    k.ad || ' ' || k.soyad AS sahip_adi,
    k.telefon,
    k.e_posta,
    f.toplam_tutar,
    (CURRENT_DATE - DATE(f.tarih)) AS gecen_gun,
    CASE
        WHEN CURRENT_DATE - DATE(f.tarih) > 90 THEN 'KRITIK'
        WHEN CURRENT_DATE - DATE(f.tarih) > 60 THEN 'YUKSEK'
        WHEN CURRENT_DATE - DATE(f.tarih) > 30 THEN 'ORTA'
        ELSE 'NORMAL'
    END AS oncelik
FROM fatura f
JOIN kisi k ON f.sahip_id = k.kisi_id
WHERE f.odeme_durumu = 'Bekliyor'
ORDER BY gecen_gun DESC;


-- ═══════════════════════════════════════════════════════════
-- SORGU 9: Cerrahi Operasyon İstatistikleri
-- (Gruplama + Toplama + STRING_AGG)
-- ═══════════════════════════════════════════════════════════
SELECT
    co.operasyon_turu,
    COUNT(*) AS toplam_operasyon,
    COUNT(DISTINCT co.veteriner_id) AS yapan_hekim_sayisi,
    COUNT(DISTINCT co.hayvan_id) AS hasta_sayisi,
    STRING_AGG(DISTINCT co.anestezi_turu, ', ') AS kullanilan_anesteziler,
    SUM(CASE WHEN co.durum = 'Tamamlandi' THEN 1 ELSE 0 END) AS tamamlanan,
    SUM(CASE WHEN co.durum = 'Planlanmis' THEN 1 ELSE 0 END) AS planlanan
FROM cerrahi_operasyon co
GROUP BY co.operasyon_turu
ORDER BY toplam_operasyon DESC;


-- ═══════════════════════════════════════════════════════════
-- SORGU 10: Laboratuvar Sonucu Anormal Değer Raporu
-- (Filtreleme + Birleştirme + Tip Dönüşümü)
-- ═══════════════════════════════════════════════════════════
SELECT
    lt.test_id,
    h.ad AS hayvan_adi,
    h.tur,
    lt.test_turu,
    lt.sonuc::DECIMAL(10,2) AS sonuc_deger,
    lt.referans_deger_alt,
    lt.referans_deger_ust,
    lt.birim,
    k.ad || ' ' || k.soyad AS hekim_adi,
    CASE
        WHEN lt.sonuc::DECIMAL < lt.referans_deger_alt THEN 'DUSUK'
        WHEN lt.sonuc::DECIMAL > lt.referans_deger_ust THEN 'YUKSEK'
        ELSE 'NORMAL'
    END AS durum
FROM lab_test lt
JOIN hayvan h ON lt.hayvan_id = h.hayvan_id
JOIN kisi k ON lt.veteriner_id = k.kisi_id
WHERE lt.sonuc IS NOT NULL
  AND lt.sonuc ~ '^[0-9]+\.?[0-9]*$'
  AND (lt.sonuc::DECIMAL < lt.referans_deger_alt
       OR lt.sonuc::DECIMAL > lt.referans_deger_ust)
ORDER BY lt.tarih DESC;

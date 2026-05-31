-- ═══════════════════════════════════════════════════════════
-- 04_PROCEDURES.SQL - Stored Procedures
-- ═══════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════
-- PROCEDURE 1: sp_recete_yaz
-- Amaç: Reçete yazma - İK-3 ve İK-6 kontrolü
-- İK-3: Stokta olmayan ilaç için reçete yazılamaz
-- İK-6: Son kullanma tarihi geçmiş ilaç reçeteye eklenemez
-- ═══════════════════════════════════════════════════════════
CREATE OR REPLACE PROCEDURE sp_recete_yaz(
    p_muayene_id INT,
    p_ilac_id INT,
    p_doz VARCHAR(50),
    p_kullanim VARCHAR(100),
    p_sure INT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_stok INT;
    v_skt DATE;
    v_recete_id INT;
    v_ilac_adi VARCHAR(100);
BEGIN
    -- İlaç bilgilerini al
    SELECT stok_miktari, son_kullanma_tarihi, ilac_adi
    INTO v_stok, v_skt, v_ilac_adi
    FROM ilac WHERE ilac_id = p_ilac_id;

    -- İlaç var mı?
    IF v_stok IS NULL THEN
        RAISE EXCEPTION 'HATA: İlaç bulunamadı. İlaç ID: %', p_ilac_id;
    END IF;

    -- Stok kontrolü (İK-3)
    IF v_stok <= 0 THEN
        RAISE EXCEPTION 'İK-3 İhlali: "%" stokta yok!', v_ilac_adi;
    END IF;

    -- Son kullanma tarihi kontrolü (İK-6)
    IF v_skt < CURRENT_DATE THEN
        RAISE EXCEPTION 'İK-6 İhlali: "%" ilacının son kullanma tarihi geçmiş (SKT: %)', v_ilac_adi, v_skt;
    END IF;

    -- Muayene mevcut mu?
    IF NOT EXISTS (SELECT 1 FROM muayene WHERE muayene_id = p_muayene_id) THEN
        RAISE EXCEPTION 'HATA: Muayene bulunamadı. Muayene ID: %', p_muayene_id;
    END IF;

    -- Mevcut reçeteyi bul ya da yeni oluştur
    SELECT recete_id INTO v_recete_id
    FROM recete WHERE muayene_id = p_muayene_id
    LIMIT 1;

    IF v_recete_id IS NULL THEN
        v_recete_id := 1;
        INSERT INTO recete (recete_id, muayene_id, tarih, aciklama)
        VALUES (v_recete_id, p_muayene_id, NOW(), 'Otomatik reçete');
    END IF;

    -- Reçete detayı ekle
    INSERT INTO recete_detay
        (recete_id, muayene_id, ilac_id, doz, kullanim_sekli, sure_gun)
    VALUES (v_recete_id, p_muayene_id, p_ilac_id, p_doz, p_kullanim, p_sure);

    -- Stoktan düş
    UPDATE ilac SET stok_miktari = stok_miktari - 1
    WHERE ilac_id = p_ilac_id;

    RAISE NOTICE 'Reçete başarıyla oluşturuldu. İlaç: %, Doz: %', v_ilac_adi, p_doz;
END;
$$;

-- ═══════════════════════════════════════════════════════════
-- PROCEDURE 2: sp_randevu_olustur
-- Amaç: Randevu oluşturma - İK-1 kontrolü
-- İK-1: Veterinerin günlük randevu sayısı 15'i geçemez
-- ═══════════════════════════════════════════════════════════
CREATE OR REPLACE PROCEDURE sp_randevu_olustur(
    p_tarih_saat TIMESTAMP,
    p_hayvan_id INT,
    p_veteriner_id INT,
    p_aciklama TEXT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_randevu_sayisi INT;
    v_vet_ad VARCHAR(100);
BEGIN
    -- Veteriner bilgisini al
    SELECT ad || ' ' || soyad INTO v_vet_ad
    FROM kisi WHERE kisi_id = p_veteriner_id;

    IF v_vet_ad IS NULL THEN
        RAISE EXCEPTION 'HATA: Veteriner bulunamadı. ID: %', p_veteriner_id;
    END IF;

    -- Günlük randevu sayısını hesapla (İK-1)
    SELECT COUNT(*) INTO v_randevu_sayisi
    FROM randevu
    WHERE veteriner_id = p_veteriner_id
      AND DATE(tarih_saat) = DATE(p_tarih_saat)
      AND durum NOT IN ('Iptal');

    -- Limit kontrolü
    IF v_randevu_sayisi >= 15 THEN
        RAISE EXCEPTION 'İK-1 İhlali: Dr. %, % tarihinde 15 randevu limitini doldurdu!',
            v_vet_ad, DATE(p_tarih_saat);
    END IF;

    -- Hayvan kontrolü
    IF NOT EXISTS (SELECT 1 FROM hayvan WHERE hayvan_id = p_hayvan_id AND durum = 'Aktif') THEN
        RAISE EXCEPTION 'HATA: Hayvan bulunamadı veya pasif. ID: %', p_hayvan_id;
    END IF;

    -- Randevu oluştur
    INSERT INTO randevu (tarih_saat, durum, aciklama, hayvan_id, veteriner_id)
    VALUES (p_tarih_saat, 'Bekliyor', p_aciklama, p_hayvan_id, p_veteriner_id);

    RAISE NOTICE 'Randevu başarıyla oluşturuldu. Dr. %, Tarih: %', v_vet_ad, p_tarih_saat;
END;
$$;

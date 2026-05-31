-- ═══════════════════════════════════════════════════════════
-- 05_TRIGGERS.SQL - Tetikleyiciler
-- ═══════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════
-- TRIGGER 1: trg_hayvan_sil_log
-- Amaç: İK-2 - Hayvan kaydı silinemez, durumu 'Pasif' yapılır
-- ═══════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION fn_hayvan_sil_koruma()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    -- Silme işlemini iptal et, durumu Pasif yap
    UPDATE hayvan SET durum = 'Pasif'
    WHERE hayvan_id = OLD.hayvan_id;

    -- Log kaydı oluştur
    INSERT INTO log_kaydi
        (tablo_adi, islem_turu, eski_deger, yeni_deger, kullanici)
    VALUES (
        'hayvan',
        'SOFT_DELETE',
        'hayvan_id=' || OLD.hayvan_id || ', ad=' || OLD.ad || ', tur=' || OLD.tur,
        'durum=Pasif',
        CURRENT_USER
    );

    RAISE NOTICE 'İK-2: "%" adlı hayvan silinmedi, durumu Pasif yapıldı.', OLD.ad;

    -- DELETE işlemini iptal et
    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_hayvan_sil_log ON hayvan;
CREATE TRIGGER trg_hayvan_sil_log
BEFORE DELETE ON hayvan
FOR EACH ROW
EXECUTE FUNCTION fn_hayvan_sil_koruma();

-- ═══════════════════════════════════════════════════════════
-- TRIGGER 2: trg_fatura_muayene_guncelle
-- Amaç: İK-5 - Fatura oluşturulunca muayene notuna eklenir + log
-- ═══════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION fn_fatura_olusturuldu()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    -- Muayene notuna fatura bilgisi ekle
    IF NEW.muayene_id IS NOT NULL THEN
        UPDATE muayene
        SET notlar = COALESCE(notlar, '') || ' [Faturalandı: #' || NEW.fatura_id || ']'
        WHERE muayene_id = NEW.muayene_id;
    END IF;

    -- Log kaydı
    INSERT INTO log_kaydi
        (tablo_adi, islem_turu, yeni_deger, kullanici)
    VALUES (
        'fatura',
        'INSERT',
        'fatura_id=' || NEW.fatura_id || ', tutar=' || NEW.toplam_tutar || ' TL',
        CURRENT_USER
    );

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_fatura_muayene_guncelle ON fatura;
CREATE TRIGGER trg_fatura_muayene_guncelle
AFTER INSERT ON fatura
FOR EACH ROW
EXECUTE FUNCTION fn_fatura_olusturuldu();

-- ═══════════════════════════════════════════════════════════
-- 06_INDEXES.SQL - İndeksler
-- ═══════════════════════════════════════════════════════════

-- Hayvan tablosu
CREATE INDEX IF NOT EXISTS idx_hayvan_tur ON hayvan(tur);
CREATE INDEX IF NOT EXISTS idx_hayvan_sahip ON hayvan(sahip_id);
CREATE INDEX IF NOT EXISTS idx_hayvan_durum ON hayvan(durum);

-- Randevu tablosu
CREATE INDEX IF NOT EXISTS idx_randevu_tarih ON randevu(tarih_saat);
CREATE INDEX IF NOT EXISTS idx_randevu_veteriner ON randevu(veteriner_id);
CREATE INDEX IF NOT EXISTS idx_randevu_durum ON randevu(durum);

-- Muayene tablosu
CREATE INDEX IF NOT EXISTS idx_muayene_tarih ON muayene(tarih_saat);
CREATE INDEX IF NOT EXISTS idx_muayene_hayvan ON muayene(hayvan_id);
CREATE INDEX IF NOT EXISTS idx_muayene_veteriner ON muayene(veteriner_id);

-- Aşı takibi
CREATE INDEX IF NOT EXISTS idx_asi_hayvan ON asi_kaydi(hayvan_id);
CREATE INDEX IF NOT EXISTS idx_asi_sonraki_doz ON asi_kaydi(sonraki_doz_tarihi);

-- İlaç stok kontrolü
CREATE INDEX IF NOT EXISTS idx_ilac_stok ON ilac(stok_miktari);
CREATE INDEX IF NOT EXISTS idx_ilac_skt ON ilac(son_kullanma_tarihi);

-- Fatura sorguları
CREATE INDEX IF NOT EXISTS idx_fatura_odeme ON fatura(odeme_durumu);
CREATE INDEX IF NOT EXISTS idx_fatura_sahip ON fatura(sahip_id);

-- Bileşik indeksler
CREATE INDEX IF NOT EXISTS idx_randevu_vet_tarih
    ON randevu(veteriner_id, tarih_saat);
CREATE INDEX IF NOT EXISTS idx_muayene_hayvan_tarih
    ON muayene(hayvan_id, tarih_saat);

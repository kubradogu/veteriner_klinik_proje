
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))

from db_config import get_connection
from tabulate import tabulate


def temizle_ekran():
    """Ekranı temizler (Windows ve Unix uyumlu)."""
    import os
    os.system('cls' if os.name == 'nt' else 'clear')


def baslik_yaz(text):
    """Başlık çizgisi ile yazdırır."""
    print("\n" + "═" * 70)
    print(f"  {text}")
    print("═" * 70)


def sorgu_calistir(conn, sql, baslik, params=None):
    """SQL sorgusunu çalıştırır ve sonucu tablo halinde gösterir."""
    baslik_yaz(baslik)

    try:
        cur = conn.cursor()
        if params:
            cur.execute(sql, params)
        else:
            cur.execute(sql)

        if cur.description:
            kolonlar = [desc[0] for desc in cur.description]
            sonuclar = cur.fetchall()

            if sonuclar:
                print(f"\n📊 {len(sonuclar)} sonuç bulundu:\n")
                print(tabulate(sonuclar, headers=kolonlar,
                             tablefmt="grid", numalign="right",
                             stralign="left"))
            else:
                print("\n⚠️  Sonuç bulunamadı.")

        cur.close()
    except Exception as e:
        print(f"\n❌ HATA: {e}")


# ═══════════════════════════════════════════════════════════
# 10 KARMAŞIK SORGU
# ═══════════════════════════════════════════════════════════

def sorgu_1(conn):
    """Hastalık dağılımı analizi"""
    sql = """
    SELECT h.tur, h.irk, m.tani, COUNT(*) AS vaka_sayisi,
           ROUND(COUNT(*) * 100.0 / (
               SELECT COUNT(*) FROM muayene m2
               JOIN hayvan h2 ON m2.hayvan_id = h2.hayvan_id
               WHERE h2.tur = h.tur
           ), 2) AS yuzde
    FROM muayene m
    JOIN hayvan h ON m.hayvan_id = h.hayvan_id
    WHERE m.tani IS NOT NULL
    GROUP BY h.tur, h.irk, m.tani
    HAVING COUNT(*) >= 2
    ORDER BY h.tur, vaka_sayisi DESC;
    """
    sorgu_calistir(conn, sql, "SORGU 1: Tür ve Irka Göre Hastalık Dağılımı")


def sorgu_2(conn):
    """Aşı gecikmiş hayvanlar"""
    sql = """
    SELECT h.ad AS hayvan,
           h.tur,
           k.ad || ' ' || k.soyad AS sahip,
           k.telefon,
           a.asi_turu,
           a.sonraki_doz_tarihi,
           (CURRENT_DATE - a.sonraki_doz_tarihi) AS gecikme_gun
    FROM asi_kaydi a
    JOIN hayvan h ON a.hayvan_id = h.hayvan_id
    JOIN kisi k ON h.sahip_id = k.kisi_id
    WHERE a.sonraki_doz_tarihi < CURRENT_DATE
      AND a.asi_kaydi_id = (
          SELECT MAX(a2.asi_kaydi_id) FROM asi_kaydi a2
          WHERE a2.hayvan_id = a.hayvan_id
            AND a2.asi_turu = a.asi_turu
      )
    ORDER BY gecikme_gun DESC;
    """
    sorgu_calistir(conn, sql, "SORGU 2: Aşı Takvimi Gecikmiş Hayvanlar")


def sorgu_3(conn):
    """Veteriner performans raporu"""
    sql = """
    SELECT k.ad || ' ' || k.soyad AS veteriner,
           v.uzmanlik_alani,
           TO_CHAR(m.tarih_saat, 'YYYY-MM') AS ay,
           COUNT(m.muayene_id) AS muayene_sayisi,
           ROUND(AVG(EXTRACT(EPOCH FROM
               (m.bitis_saat - m.tarih_saat)) / 60)::NUMERIC, 1) AS ort_sure_dk,
           COUNT(DISTINCT m.hayvan_id) AS hasta_sayisi
    FROM muayene m
    JOIN kisi k ON m.veteriner_id = k.kisi_id
    JOIN veteriner v ON k.kisi_id = v.kisi_id
    WHERE m.bitis_saat IS NOT NULL
    GROUP BY k.ad, k.soyad, v.uzmanlik_alani, TO_CHAR(m.tarih_saat, 'YYYY-MM')
    ORDER BY ay DESC, muayene_sayisi DESC;
    """
    sorgu_calistir(conn, sql, "SORGU 3: Veteriner Hekim Aylık Performans")


def sorgu_4(conn):
    """Kritik stok raporu"""
    sql = """
    SELECT i.ilac_adi, i.kategori, i.stok_miktari,
           i.kritik_stok_seviyesi AS kritik_seviye,
           i.son_kullanma_tarihi AS skt,
           t.firma_adi AS tedarikci,
           CASE
               WHEN i.son_kullanma_tarihi < CURRENT_DATE THEN '⛔ SURESI GECMIS'
               WHEN i.son_kullanma_tarihi < CURRENT_DATE + 30 THEN '⚠️  SON 30 GUN'
               WHEN i.stok_miktari <= i.kritik_stok_seviyesi THEN '🟡 KRITIK STOK'
               ELSE '✅ NORMAL'
           END AS uyari
    FROM ilac i
    LEFT JOIN tedarikci t ON i.tedarikci_id = t.tedarikci_id
    WHERE i.stok_miktari <= i.kritik_stok_seviyesi
       OR i.son_kullanma_tarihi < CURRENT_DATE + 30
    ORDER BY
        CASE
            WHEN i.son_kullanma_tarihi < CURRENT_DATE THEN 1
            WHEN i.stok_miktari <= i.kritik_stok_seviyesi THEN 2
            ELSE 3
        END;
    """
    sorgu_calistir(conn, sql, "SORGU 4: Kritik Stok ve SKT Raporu")


def sorgu_5(conn):
    """Aylık gelir analizi"""
    sql = """
    SELECT TO_CHAR(f.tarih, 'YYYY-MM') AS ay,
           fk.hizmet_adi,
           SUM(fk.toplam) AS toplam_gelir,
           COUNT(DISTINCT f.fatura_id) AS fatura_sayisi
    FROM fatura f
    JOIN fatura_kalem fk ON f.fatura_id = fk.fatura_id
    WHERE f.odeme_durumu = 'Odendi'
    GROUP BY TO_CHAR(f.tarih, 'YYYY-MM'), fk.hizmet_adi
    ORDER BY ay DESC, toplam_gelir DESC;
    """
    sorgu_calistir(conn, sql, "SORGU 5: Hizmet Türüne Göre Aylık Gelir")


def sorgu_6(conn):
    """Hayvan tedavi geçmişi"""
    sql = """
    SELECT h.ad AS hayvan, h.tur, h.irk,
           (SELECT COUNT(*) FROM muayene WHERE hayvan_id = h.hayvan_id) AS muayene,
           (SELECT COUNT(*) FROM asi_kaydi WHERE hayvan_id = h.hayvan_id) AS asi,
           (SELECT COUNT(*) FROM cerrahi_operasyon WHERE hayvan_id = h.hayvan_id) AS operasyon,
           (SELECT COUNT(*) FROM lab_test WHERE hayvan_id = h.hayvan_id) AS test,
           (SELECT COALESCE(SUM(f.toplam_tutar), 0)
            FROM fatura f
            JOIN muayene m ON f.muayene_id = m.muayene_id
            WHERE m.hayvan_id = h.hayvan_id) AS harcama
    FROM hayvan h
    WHERE h.durum = 'Aktif'
    ORDER BY harcama DESC
    LIMIT 15;
    """
    sorgu_calistir(conn, sql, "SORGU 6: Hayvan Tedavi Geçmişi (Top 15)")


def sorgu_7(conn):
    """En çok kullanılan ilaçlar"""
    sql = """
    SELECT i.ilac_adi, i.kategori,
           t.firma_adi AS tedarikci,
           COUNT(rd.ilac_id) AS recete_sayisi,
           SUM(rd.sure_gun) AS toplam_kullanim_gun,
           i.stok_miktari AS mevcut_stok
    FROM recete_detay rd
    JOIN ilac i ON rd.ilac_id = i.ilac_id
    LEFT JOIN tedarikci t ON i.tedarikci_id = t.tedarikci_id
    GROUP BY i.ilac_id, i.ilac_adi, i.kategori, t.firma_adi, i.stok_miktari
    ORDER BY recete_sayisi DESC;
    """
    sorgu_calistir(conn, sql, "SORGU 7: En Çok Kullanılan İlaçlar")


def sorgu_8(conn):
    """Ödenmemiş faturalar"""
    sql = """
    SELECT f.fatura_id, f.tarih::DATE,
           k.ad || ' ' || k.soyad AS sahip,
           k.telefon,
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
    """
    sorgu_calistir(conn, sql, "SORGU 8: Ödenmemiş Fatura Takip")


def sorgu_9(conn):
    """Cerrahi operasyon istatistikleri"""
    sql = """
    SELECT co.operasyon_turu,
           COUNT(*) AS toplam,
           COUNT(DISTINCT co.veteriner_id) AS hekim_sayisi,
           COUNT(DISTINCT co.hayvan_id) AS hasta_sayisi,
           STRING_AGG(DISTINCT co.anestezi_turu, ', ') AS anesteziler,
           SUM(CASE WHEN co.durum = 'Tamamlandi' THEN 1 ELSE 0 END) AS tamamlanan,
           SUM(CASE WHEN co.durum = 'Planlanmis' THEN 1 ELSE 0 END) AS planlanan
    FROM cerrahi_operasyon co
    GROUP BY co.operasyon_turu
    ORDER BY toplam DESC;
    """
    sorgu_calistir(conn, sql, "SORGU 9: Cerrahi Operasyon İstatistikleri")


def sorgu_10(conn):
    """Anormal lab değerleri"""
    sql = r"""
    SELECT lt.test_id,
           h.ad AS hayvan, h.tur,
           lt.test_turu,
           lt.sonuc::DECIMAL(10,2) AS sonuc,
           lt.referans_deger_alt AS ref_alt,
           lt.referans_deger_ust AS ref_ust,
           lt.birim,
           CASE
               WHEN lt.sonuc::DECIMAL < lt.referans_deger_alt THEN '⬇️  DUSUK'
               WHEN lt.sonuc::DECIMAL > lt.referans_deger_ust THEN '⬆️  YUKSEK'
               ELSE 'NORMAL'
           END AS durum
    FROM lab_test lt
    JOIN hayvan h ON lt.hayvan_id = h.hayvan_id
    WHERE lt.sonuc IS NOT NULL
      AND lt.sonuc ~ '^[0-9]+\.?[0-9]*$'
      AND (lt.sonuc::DECIMAL < lt.referans_deger_alt
           OR lt.sonuc::DECIMAL > lt.referans_deger_ust)
    ORDER BY lt.tarih DESC;
    """
    sorgu_calistir(conn, sql, "SORGU 10: Anormal Lab Değerleri")


# ═══════════════════════════════════════════════════════════
# İŞ KURALI TESTLERİ
# ═══════════════════════════════════════════════════════════

def test_ik3_stoksuz_ilac(conn):
    """İK-3 Testi: Stoksuz ilaç için reçete yazılamaz"""
    baslik_yaz("TEST: İK-3 - Stoksuz İlaç Reçete Engeli")
    print("\nDeneme: Stoğu 0 olan bir ilaç için reçete yazılmaya çalışılacak...")

    try:
        # Önce bir ilacın stoğunu 0'a indirelim
        cur = conn.cursor()
        cur.execute("UPDATE ilac SET stok_miktari = 0 WHERE ilac_id = 15;")
        conn.commit()
        print("\n📦 'Eski İlaç A' ilacının stoğu 0'a indirildi.")

        # Şimdi reçete yazmayı deneyelim
        cur.execute("CALL sp_recete_yaz(1, 15, '500mg', 'Günde 2 kez', 7);")
        conn.commit()
        print("\n✅ Reçete oluşturuldu (HATA! Olmamalıydı)")
    except Exception as e:
        conn.rollback()
        print(f"\n✅ BAŞARI: Procedure hata fırlattı (beklenen davranış):")
        print(f"   {e}")

        # Stoğu eski haline döndür
        cur = conn.cursor()
        cur.execute("UPDATE ilac SET stok_miktari = 5 WHERE ilac_id = 15;")
        conn.commit()


def test_ik2_hayvan_silme(conn):
    """İK-2 Testi: Hayvan kaydı silinemez"""
    baslik_yaz("TEST: İK-2 - Hayvan Silme Koruması (Soft Delete)")
    print("\nDeneme: Hayvan ID=1 silinmeye çalışılacak...")

    try:
        cur = conn.cursor()

        # Önce hayvanın durumunu görelim
        cur.execute("SELECT ad, durum FROM hayvan WHERE hayvan_id = 1;")
        ad, durum = cur.fetchone()
        print(f"\n📋 Önce: Hayvan '{ad}', Durum: {durum}")

        # Silme denemesi
        cur.execute("DELETE FROM hayvan WHERE hayvan_id = 1;")
        conn.commit()

        # Sonucu kontrol et
        cur.execute("SELECT ad, durum FROM hayvan WHERE hayvan_id = 1;")
        result = cur.fetchone()
        if result:
            ad, durum = result
            print(f"\n✅ BAŞARI: Hayvan silinmedi, durumu güncellendi.")
            print(f"   Sonra: Hayvan '{ad}', Durum: {durum}")

        # Log kaydını göster
        cur.execute("""
            SELECT eski_deger, yeni_deger, islem_tarihi
            FROM log_kaydi
            WHERE tablo_adi = 'hayvan'
            ORDER BY log_id DESC LIMIT 1;
        """)
        log = cur.fetchone()
        if log:
            print(f"\n📝 Log Kaydı Oluşturuldu:")
            print(f"   Eski: {log[0]}")
            print(f"   Yeni: {log[1]}")
            print(f"   Tarih: {log[2]}")

        # Hayvanı tekrar aktif yapalım
        cur.execute("UPDATE hayvan SET durum = 'Aktif' WHERE hayvan_id = 1;")
        conn.commit()
        print(f"\n♻️  Hayvan tekrar Aktif duruma getirildi.")

    except Exception as e:
        conn.rollback()
        print(f"\n❌ HATA: {e}")


def test_ik1_randevu_limit(conn):
    """İK-1 Testi: Veterinerin 15 randevu limiti"""
    baslik_yaz("TEST: İK-1 - Veteriner Günlük Randevu Limiti (15)")
    print("\nDeneme: Veteriner ID=9 için aynı güne 16 randevu eklenmeye çalışılacak...")

    test_tarihi = "'2026-06-01"
    try:
        cur = conn.cursor()

        # Önce o güne ait randevuları temizle
        cur.execute(f"DELETE FROM randevu WHERE veteriner_id = 9 AND DATE(tarih_saat) = '2026-06-01';")
        conn.commit()

        # 15 randevu ekle - başarılı olmalı
        for i in range(15):
            saat = f"{9+i//2:02d}:{30*(i%2):02d}"
            cur.execute(f"""
                CALL sp_randevu_olustur(
                    '2026-06-01 {saat}:00'::TIMESTAMP,
                    1, 9, 'Test randevu {i+1}'
                );
            """)
            conn.commit()

        print(f"\n✅ 15 randevu başarıyla eklendi.")

        # 16. randevu - HATA vermeli
        print(f"\n🚫 16. randevu ekleniyor (HATA vermeli)...")
        cur.execute("""
            CALL sp_randevu_olustur(
                '2026-06-01 17:00:00'::TIMESTAMP,
                1, 9, 'Bu eklenmemeli'
            );
        """)
        conn.commit()
        print("\n❌ HATA: 16. randevu eklendi (olmamalıydı)")

    except Exception as e:
        conn.rollback()
        print(f"\n✅ BAŞARI: 16. randevu engellenmiş!")
        print(f"   {e}")

        # Temizle
        cur = conn.cursor()
        cur.execute("DELETE FROM randevu WHERE veteriner_id = 9 AND DATE(tarih_saat) = '2026-06-01';")
        conn.commit()


def test_transaction(conn):
    """Transaction senaryosu testi"""
    baslik_yaz("TEST: Transaction Senaryosu (Muayene Tamamlama)")
    print("\nSenaryo: Bir muayene tamamlanırken hem reçete yazılır,")
    print("hem stoktan ilaç düşülür, hem fatura oluşturulur.")
    print("Herhangi birinde hata olursa hepsi geri alınır.\n")

    try:
        cur = conn.cursor()

        # Önceki stok ve fatura sayısı
        cur.execute("SELECT stok_miktari FROM ilac WHERE ilac_id = 1;")
        eski_stok = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM fatura;")
        eski_fatura_sayisi = cur.fetchone()[0]

        print(f"📦 Başlangıç stok: {eski_stok}")
        print(f"📄 Başlangıç fatura sayısı: {eski_fatura_sayisi}")

        # TRANSACTION
        conn.autocommit = False

        # 1. Yeni muayene
        cur.execute("""
            INSERT INTO muayene (tarih_saat, bitis_saat, bulgular, tani, tedavi_plani, hayvan_id, veteriner_id)
            VALUES (NOW(), NOW() + INTERVAL '30 minutes',
                    'Transaction testi', 'Test Tanı', 'Test Tedavi', 1, 9)
            RETURNING muayene_id;
        """)
        yeni_muayene_id = cur.fetchone()[0]
        print(f"\n1️⃣  Muayene oluşturuldu (ID: {yeni_muayene_id})")

        # 2. Reçete + Stok düşür
        cur.execute("CALL sp_recete_yaz(%s, 1, '500mg', 'Günde 2 kez', 7);", (yeni_muayene_id,))
        print(f"2️⃣  Reçete yazıldı + Stok düşürüldü")

        # 3. Fatura
        cur.execute("""
            INSERT INTO fatura (tarih, toplam_tutar, odeme_durumu, odeme_turu, muayene_id, sahip_id)
            VALUES (NOW(), 350.00, 'Bekliyor', 'Kredi Kartı', %s, 1)
            RETURNING fatura_id;
        """, (yeni_muayene_id,))
        yeni_fatura_id = cur.fetchone()[0]
        print(f"3️⃣  Fatura oluşturuldu (ID: {yeni_fatura_id})")

        # COMMIT
        conn.commit()
        print(f"\n✅ COMMIT - Tüm işlemler başarıyla kaydedildi!")

        # Sonuçları göster
        cur.execute("SELECT stok_miktari FROM ilac WHERE ilac_id = 1;")
        yeni_stok = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM fatura;")
        yeni_fatura_sayisi = cur.fetchone()[0]

        print(f"\n📦 Yeni stok: {yeni_stok} (azalma: {eski_stok - yeni_stok})")
        print(f"📄 Yeni fatura sayısı: {yeni_fatura_sayisi} (artış: {yeni_fatura_sayisi - eski_fatura_sayisi})")

        conn.autocommit = True

    except Exception as e:
        conn.rollback()
        conn.autocommit = True
        print(f"\n❌ ROLLBACK - Hata oluştu, tüm işlemler geri alındı:")
        print(f"   {e}")


def view_test(conn):
    """Görünüm testleri"""
    baslik_yaz("TEST: Görünümler (Views)")

    print("\n📋 View 1: v_hayvan_detay (Aktif hayvanlar + sahip bilgisi)")
    sorgu_calistir(conn, "SELECT * FROM v_hayvan_detay LIMIT 10;", "v_hayvan_detay")

    print("\n📋 View 2: v_personel_ozet (Maaş GİZLİ)")
    sorgu_calistir(conn, "SELECT * FROM v_personel_ozet;", "v_personel_ozet")


# ═══════════════════════════════════════════════════════════
# ANA MENÜ
# ═══════════════════════════════════════════════════════════

def menu_goster():
    """Ana menüyü gösterir."""
    print("\n" + "═" * 70)
    print("  🐾 VETERİNER KLİNİK YÖNETİM SİSTEMİ - ANA MENÜ 🐾")
    print("═" * 70)
    print("\n  ━━━ 10 KARMAŞIK SORGU ━━━")
    print("   1.  Hastalık Dağılım Analizi (Tür + Irk)")
    print("   2.  Aşı Gecikmiş Hayvanlar")
    print("   3.  Veteriner Performans Raporu")
    print("   4.  Kritik Stok ve SKT Raporu")
    print("   5.  Aylık Gelir Analizi")
    print("   6.  Hayvan Tedavi Geçmişi (Top 15)")
    print("   7.  En Çok Kullanılan İlaçlar")
    print("   8.  Ödenmemiş Faturalar")
    print("   9.  Cerrahi Operasyon İstatistikleri")
    print("  10.  Anormal Lab Değerleri")
    print("\n  ━━━ İŞ KURALI TESTLERİ ━━━")
    print("  11.  İK-3 Testi (Stoksuz ilaç engeli)")
    print("  12.  İK-2 Testi (Hayvan silme koruması)")
    print("  13.  İK-1 Testi (Randevu limiti)")
    print("  14.  Transaction Senaryosu")
    print("\n  ━━━ DİĞER ━━━")
    print("  15.  Görünümleri (Views) Test Et")
    print("  16.  Log Kayıtlarını Göster")
    print("\n   0.  Çıkış")
    print("═" * 70)


def log_goster(conn):
    """Log kayıtlarını gösterir"""
    sql = """
    SELECT log_id, tablo_adi, islem_turu,
           islem_tarihi::TIMESTAMP(0),
           SUBSTRING(eski_deger, 1, 50) AS eski_deger,
           SUBSTRING(yeni_deger, 1, 50) AS yeni_deger,
           kullanici
    FROM log_kaydi
    ORDER BY log_id DESC
    LIMIT 20;
    """
    sorgu_calistir(conn, sql, "Log Kayıtları (Son 20)")


def main():
    print("\n🔌 Veritabanına bağlanılıyor...")
    try:
        conn = get_connection()
        conn.autocommit = True
        print("✅ Bağlandı!\n")
    except Exception:
        return

    sorgular = {
        "1": sorgu_1, "2": sorgu_2, "3": sorgu_3, "4": sorgu_4,
        "5": sorgu_5, "6": sorgu_6, "7": sorgu_7, "8": sorgu_8,
        "9": sorgu_9, "10": sorgu_10,
        "11": test_ik3_stoksuz_ilac,
        "12": test_ik2_hayvan_silme,
        "13": test_ik1_randevu_limit,
        "14": test_transaction,
        "15": view_test,
        "16": log_goster,
    }

    while True:
        menu_goster()
        secim = input("\n  Seçiminiz: ").strip()

        if secim == "0":
            print("\n👋 Görüşmek üzere!")
            break
        elif secim in sorgular:
            sorgular[secim](conn)
            input("\n\n   ↩️  Devam etmek için ENTER'a basın...")
        else:
            print("\n  ⚠️  Geçersiz seçim! Lütfen tekrar deneyin.")

    conn.close()


if __name__ == "__main__":
    main()

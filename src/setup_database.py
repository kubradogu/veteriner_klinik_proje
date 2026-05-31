

import os
import sys
from pathlib import Path

# Proje kök dizinini path'e ekle
sys.path.insert(0, str(Path(__file__).parent))

from db_config import get_connection


# SQL dosyalarının bulunduğu klasör
SQL_DIR = Path(__file__).parent.parent / "sql"


def read_sql_file(filename):
    """SQL dosyasını okur."""
    filepath = SQL_DIR / filename
    if not filepath.exists():
        raise FileNotFoundError(f"SQL dosyası bulunamadı: {filepath}")
    with open(filepath, "r", encoding="utf-8") as f:
        return f.read()


def execute_sql_file(conn, filename, description):
    """SQL dosyasını çalıştırır."""
    print(f"\n{'='*60}")
    print(f"📄 {description}")
    print(f"   Dosya: {filename}")
    print(f"{'='*60}")

    sql_content = read_sql_file(filename)

    try:
        cur = conn.cursor()
        cur.execute(sql_content)
        conn.commit()
        cur.close()
        print(f"✅ Başarıyla çalıştırıldı.")
        return True
    except Exception as e:
        conn.rollback()
        print(f"❌ HATA: {e}")
        return False


def show_table_stats(conn):
    """Tablolardaki kayıt sayılarını gösterir."""
    print(f"\n{'='*60}")
    print(f"📊 VERİTABANI İSTATİSTİKLERİ")
    print(f"{'='*60}")

    tables = [
        "kisi", "hayvan", "hayvan_alerji", "veteriner", "personel",
        "randevu", "muayene", "asi_kaydi", "cerrahi_operasyon",
        "lab_test", "ilac", "tedarikci", "recete", "recete_detay",
        "fatura", "fatura_kalem", "log_kaydi"
    ]

    cur = conn.cursor()
    for table in tables:
        try:
            cur.execute(f"SELECT COUNT(*) FROM {table};")
            count = cur.fetchone()[0]
            print(f"   {table:<25} {count:>6} kayıt")
        except Exception as e:
            print(f"   {table:<25} HATA: {str(e)[:30]}")
    cur.close()


def main():
    print("\n" + "═"*60)
    print("  VETERİNER KLİNİK YÖNETİM SİSTEMİ - KURULUM")
    print("═"*60)

    # Bağlantı
    try:
        conn = get_connection()
        print("\n✅ Veritabanına bağlandı.")
    except Exception:
        return

    # SQL dosyalarını sırayla çalıştır
    steps = [
        ("01_ddl.sql", "1️⃣  TABLO OLUŞTURMA (DDL)"),
        ("02_dml_veri.sql", "2️⃣  TEST VERİLERİ EKLEME (DML)"),
        ("03_views.sql", "3️⃣  GÖRÜNÜMLER (VIEWS)"),
        ("04_procedures.sql", "4️⃣  STORED PROCEDURE'LAR"),
        ("05_triggers.sql", "5️⃣  TETİKLEYİCİLER (TRIGGERS)"),
        ("06_indexes.sql", "6️⃣  İNDEKSLER (INDEXES)"),
    ]

    all_success = True
    for filename, description in steps:
        success = execute_sql_file(conn, filename, description)
        if not success:
            all_success = False
            break

    if all_success:
        show_table_stats(conn)
        print(f"\n{'═'*60}")
        print("  ✅ KURULUM BAŞARIYLA TAMAMLANDI!")
        print(f"{'═'*60}")
        print("\n🚀 Şimdi 'main.py' dosyasını çalıştırabilirsiniz.")
    else:
        print(f"\n{'═'*60}")
        print("  ❌ KURULUM SIRASINDA HATA OLUŞTU")
        print(f"{'═'*60}")

    conn.close()


if __name__ == "__main__":
    main()

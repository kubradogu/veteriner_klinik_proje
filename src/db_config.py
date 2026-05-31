
import psycopg2
from psycopg2.extras import RealDictCursor

# ═══════════════════════════════════════════════════════════
# BAĞLANTI AYARLARI - KENDİ ŞİFRENİZİ YAZIN
# ═══════════════════════════════════════════════════════════
DB_CONFIG = {
    "host": "localhost",
    "port": ********,
    "database": "*******",
    "user": "******",    #  Kendi PostgreSQL user bilgini buraya yaz
    "password": "**********"  #  Kendi PostgreSQL şifrenizi buraya yaz
}


def get_connection():
    """Veritabanı bağlantısı oluşturur."""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except psycopg2.OperationalError as e:
        print(f" Veritabanına bağlanılamadı!")
        print(f"   Hata: {e}")
        print(f"\n Çözüm:")
        print(f"   1. PostgreSQL servisinin çalıştığından emin olun")
        print(f"   2. db_config.py dosyasındaki şifreyi kontrol edin")
        print(f"   3. 'veteriner_klinik' veritabanının oluşturulduğundan emin olun")
        print(f"      CREATE DATABASE veteriner_klinik;")
        raise


def test_connection():
    """Bağlantıyı test eder."""
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()[0]
        print(f" Bağlantı başarılı!")
        print(f"   PostgreSQL: {version[:50]}...")
        cur.close()
        conn.close()
        return True
    except Exception as e:
        print(f" Bağlantı hatası: {e}")
        return False


if __name__ == "__main__":
    test_connection()

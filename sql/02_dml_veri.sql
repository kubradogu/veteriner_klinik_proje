-- ═══════════════════════════════════════════════════════════
-- 02_DML_VERI.SQL - Test Verileri
-- ═══════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════
-- KİŞİLER (8 Sahip + 5 Veteriner + 7 Personel = 20 Kişi)
-- ═══════════════════════════════════════════════════════════

-- HAYVAN SAHİPLERİ
INSERT INTO kisi (tc_kimlik, ad, soyad, telefon, e_posta, kisi_turu) VALUES
('12345678901', 'Ahmet', 'Yılmaz', '05321234567', 'ahmet.yilmaz@mail.com', 'Sahip'),
('12345678902', 'Ayşe', 'Demir', '05322234567', 'ayse.demir@mail.com', 'Sahip'),
('12345678903', 'Mehmet', 'Kaya', '05323234567', 'mehmet.kaya@mail.com', 'Sahip'),
('12345678904', 'Fatma', 'Çelik', '05324234567', 'fatma.celik@mail.com', 'Sahip'),
('12345678905', 'Mustafa', 'Şahin', '05325234567', 'mustafa.sahin@mail.com', 'Sahip'),
('12345678906', 'Zeynep', 'Aydın', '05326234567', 'zeynep.aydin@mail.com', 'Sahip'),
('12345678907', 'Hasan', 'Öztürk', '05327234567', 'hasan.ozturk@mail.com', 'Sahip'),
('12345678908', 'Elif', 'Arslan', '05328234567', 'elif.arslan@mail.com', 'Sahip');

INSERT INTO hayvan_sahibi (kisi_id, acil_irtibat_telefon) VALUES
(1, '02121234567'),
(2, '02122234567'),
(3, '02123234567'),
(4, '02124234567'),
(5, '02125234567'),
(6, '02126234567'),
(7, '02127234567'),
(8, '02128234567');

-- VETERİNER HEKİMLER
INSERT INTO kisi (tc_kimlik, ad, soyad, telefon, e_posta, kisi_turu) VALUES
('22345678901', 'Dr. Ali', 'Korkmaz', '05331234567', 'ali.korkmaz@vet.com', 'Veteriner'),
('22345678902', 'Dr. Selin', 'Yıldız', '05332234567', 'selin.yildiz@vet.com', 'Veteriner'),
('22345678903', 'Dr. Burak', 'Doğan', '05333234567', 'burak.dogan@vet.com', 'Veteriner'),
('22345678904', 'Dr. Merve', 'Polat', '05334234567', 'merve.polat@vet.com', 'Veteriner'),
('22345678905', 'Dr. Emre', 'Aslan', '05335234567', 'emre.aslan@vet.com', 'Veteriner');

INSERT INTO veteriner (kisi_id, diploma_no, uzmanlik_alani, oda_numarasi) VALUES
(9, 'VET-2015-001', 'Küçük Hayvan Cerrahisi', '101'),
(10, 'VET-2018-002', 'Dahiliye', '102'),
(11, 'VET-2020-003', 'Egzotik Hayvanlar', '103'),
(12, 'VET-2017-004', 'Ortopedi', '104'),
(13, 'VET-2019-005', 'Dermatoloji', '105');

-- PERSONEL
INSERT INTO kisi (tc_kimlik, ad, soyad, telefon, e_posta, kisi_turu) VALUES
('32345678901', 'Ece', 'Erdem', '05341234567', 'ece.erdem@klinik.com', 'Personel'),
('32345678902', 'Can', 'Akın', '05342234567', 'can.akin@klinik.com', 'Personel'),
('32345678903', 'Deniz', 'Tuna', '05343234567', 'deniz.tuna@klinik.com', 'Personel'),
('32345678904', 'Berk', 'Yavuz', '05344234567', 'berk.yavuz@klinik.com', 'Personel'),
('32345678905', 'Gizem', 'Kara', '05345234567', 'gizem.kara@klinik.com', 'Personel'),
('32345678906', 'Sinem', 'Acar', '05346234567', 'sinem.acar@klinik.com', 'Personel'),
('32345678907', 'Tolga', 'Bilen', '05347234567', 'tolga.bilen@klinik.com', 'Personel');

INSERT INTO personel (kisi_id, pozisyon, maas, calisma_saatleri) VALUES
(14, 'Resepsiyon', 18000.00, '09:00-18:00'),
(15, 'Veteriner Teknisyeni', 22000.00, '09:00-18:00'),
(16, 'Veteriner Teknisyeni', 22000.00, '10:00-19:00'),
(17, 'Laboratuvar Teknisyeni', 25000.00, '08:00-17:00'),
(18, 'Hemşire', 20000.00, '09:00-18:00'),
(19, 'Resepsiyon', 18000.00, '12:00-21:00'),
(20, 'Temizlik Personeli', 16000.00, '06:00-15:00');

-- ADRESLER (Çok değerli nitelik)
INSERT INTO kisi_adres (kisi_id, adres_turu, adres_satiri, ilce, il) VALUES
(1, 'Ev', 'Kadıköy Cad. No:15', 'Kadıköy', 'İstanbul'),
(1, 'İş', 'Maslak Plaza Kat:5', 'Sarıyer', 'İstanbul'),
(2, 'Ev', 'Beşiktaş Mah. No:22', 'Beşiktaş', 'İstanbul'),
(3, 'Ev', 'Ataşehir Bulvarı No:8', 'Ataşehir', 'İstanbul'),
(4, 'Ev', 'Üsküdar Cad. No:31', 'Üsküdar', 'İstanbul'),
(5, 'Ev', 'Bakırköy Sok. No:7', 'Bakırköy', 'İstanbul'),
(6, 'Ev', 'Şişli Mah. No:44', 'Şişli', 'İstanbul'),
(7, 'Ev', 'Kartal Sahil Yolu No:19', 'Kartal', 'İstanbul'),
(8, 'Ev', 'Pendik Cad. No:62', 'Pendik', 'İstanbul');

-- ═══════════════════════════════════════════════════════════
-- HAYVANLAR (25 hayvan)
-- ═══════════════════════════════════════════════════════════
INSERT INTO hayvan (ad, tur, irk, cinsiyet, dogum_tarihi, kilo, renk, mikrocip_no, sahip_id) VALUES
('Pamuk', 'Kedi', 'British Shorthair', 'D', '2020-03-15', 4.5, 'Gri', 'MC001', 1),
('Karabaş', 'Köpek', 'Labrador', 'E', '2019-06-20', 28.5, 'Siyah', 'MC002', 1),
('Minnoş', 'Kedi', 'Scottish Fold', 'D', '2021-01-10', 3.8, 'Beyaz', 'MC003', 2),
('Rex', 'Köpek', 'Golden Retriever', 'E', '2018-09-05', 32.0, 'Sarı', 'MC004', 2),
('Tarçın', 'Kedi', 'Van Kedisi', 'E', '2020-07-22', 5.2, 'Beyaz-Sarı', 'MC005', 3),
('Çakıl', 'Köpek', 'Sokak', 'E', '2017-04-12', 18.0, 'Karışık', 'MC006', 3),
('Luna', 'Kedi', 'Persian', 'D', '2019-11-30', 4.1, 'Beyaz', 'MC007', 4),
('Max', 'Köpek', 'Bulldog', 'E', '2020-02-18', 22.5, 'Kahverengi', 'MC008', 4),
('Boncuk', 'Kedi', 'Tekir', 'D', '2021-05-08', 3.5, 'Tekir', 'MC009', 5),
('Şila', 'Köpek', 'Husky', 'D', '2019-08-25', 24.0, 'Gri-Beyaz', 'MC010', 5),
('Mırnav', 'Kedi', 'Maine Coon', 'E', '2018-12-03', 7.8, 'Kahverengi', 'MC011', 6),
('Cesur', 'Köpek', 'German Shepherd', 'E', '2017-06-15', 35.0, 'Siyah-Sarı', 'MC012', 6),
('Bonibon', 'Tavşan', 'Hollanda', 'D', '2022-01-20', 1.5, 'Beyaz-Siyah', 'MC013', 7),
('Çıtır', 'Hamster', 'Suriye', 'E', '2023-03-10', 0.15, 'Sarı', 'MC014', 7),
('Patiş', 'Kedi', 'Norveç', 'D', '2020-10-05', 5.5, 'Gri-Beyaz', 'MC015', 8),
('Zümrüt', 'Papağan', 'Muhabbet', 'E', '2021-08-12', 0.05, 'Yeşil', 'MC016', 8),
('Pıtır', 'Kedi', 'Tekir', 'E', '2022-04-18', 3.2, 'Sarı Tekir', 'MC017', 1),
('Lokum', 'Köpek', 'Pomeranian', 'D', '2021-12-25', 4.5, 'Beyaz', 'MC018', 2),
('Kömür', 'Kedi', 'Sokak', 'E', '2019-09-14', 4.8, 'Siyah', 'MC019', 3),
('Bella', 'Köpek', 'Chihuahua', 'D', '2020-05-30', 2.8, 'Bej', 'MC020', 4),
('Zeytin', 'Kedi', 'Sokak', 'D', '2018-07-07', 4.3, 'Siyah-Beyaz', 'MC021', 5),
('Aslan', 'Köpek', 'Kangal', 'E', '2016-11-20', 55.0, 'Bej', 'MC022', 6),
('Çiko', 'Köpek', 'Maltese', 'E', '2021-03-08', 3.0, 'Beyaz', 'MC023', 7),
('Mia', 'Kedi', 'Ragdoll', 'D', '2022-06-15', 4.0, 'Krem', 'MC024', 8),
('Duman', 'Kedi', 'Russian Blue', 'E', '2020-08-22', 4.6, 'Gri', 'MC025', 1);

-- ALERJİLER (Çok değerli nitelik)
INSERT INTO hayvan_alerji (hayvan_id, alerji_turu, aciklama) VALUES
(1, 'Penisilin', 'Şiddetli alerjik reaksiyon'),
(2, 'Tavuk', 'Mama alerjisi'),
(4, 'Polen', 'Mevsimsel'),
(7, 'Süt ürünleri', 'Hafif alerji'),
(10, 'Aspirin', 'Toksik etki'),
(12, 'Buğday', 'Mama alerjisi'),
(15, 'Penisilin', 'Cilt reaksiyonu');

-- ═══════════════════════════════════════════════════════════
-- TEDARİKÇİLER
-- ═══════════════════════════════════════════════════════════
INSERT INTO tedarikci (firma_adi, yetkili_kisi, telefon, e_posta, adres) VALUES
('VetSağlık A.Ş.', 'Cem Yılmaz', '02124441234', 'info@vetsaglik.com', 'İstanbul'),
('PetMed Ltd.', 'Sevgi Aksoy', '02124442234', 'info@petmed.com', 'İstanbul'),
('AnimalCare', 'Murat Yıldırım', '02124443234', 'info@animalcare.com', 'Ankara'),
('BioVet İlaç', 'Aslı Demir', '02124444234', 'info@biovet.com', 'İzmir'),
('MediPet', 'Tarık Çelik', '02124445234', 'info@medipet.com', 'Bursa');

-- ═══════════════════════════════════════════════════════════
-- İLAÇLAR
-- ═══════════════════════════════════════════════════════════
INSERT INTO ilac (ilac_adi, etken_madde, kategori, birim, stok_miktari, kritik_stok_seviyesi, son_kullanma_tarihi, birim_fiyat, tedarikci_id) VALUES
('Amoxipet 500mg', 'Amoxicillin', 'Antibiyotik', 'Tablet', 150, 30, '2026-12-31', 25.00, 1),
('Metacam 1.5mg/ml', 'Meloxicam', 'Ağrı Kesici', 'ml', 200, 50, '2027-06-30', 45.00, 2),
('Frontline Plus', 'Fipronil', 'Parazit', 'Pipet', 80, 20, '2026-09-15', 85.00, 3),
('Drontal Plus', 'Praziquantel', 'İç Parazit', 'Tablet', 120, 25, '2027-03-20', 35.00, 1),
('Cefa-Cure 250mg', 'Cefalexin', 'Antibiyotik', 'Tablet', 90, 20, '2026-11-30', 30.00, 2),
('Ketofen 1%', 'Ketoprofen', 'Anti-inflamatuar', 'ml', 100, 30, '2027-01-15', 55.00, 4),
('Eurican Plus', 'Karma Aşı', 'Aşı', 'Doz', 200, 40, '2026-12-15', 120.00, 1),
('Nobivac Tricat', 'Karma Aşı', 'Aşı', 'Doz', 180, 35, '2026-10-20', 110.00, 3),
('Defensor 3', 'Kuduz Aşısı', 'Aşı', 'Doz', 150, 30, '2027-02-28', 95.00, 1),
('Synulox 250mg', 'Amoksisilin-Klavulanik Asit', 'Antibiyotik', 'Tablet', 60, 15, '2026-08-30', 40.00, 4),
('Tramadol 50mg', 'Tramadol', 'Ağrı Kesici', 'Tablet', 75, 20, '2027-04-10', 28.00, 2),
('Furosemid 20mg', 'Furosemide', 'Diüretik', 'Tablet', 110, 25, '2026-09-30', 22.00, 5),
('Prednisolon 5mg', 'Prednisolone', 'Kortikosteroid', 'Tablet', 95, 20, '2026-11-15', 18.00, 5),
('Insulvet 100IU', 'İnsülin', 'Hormon', 'ml', 40, 10, '2026-07-20', 250.00, 4),
-- Kritik stok seviyesinde olan
('Eski İlaç A', 'Test Madde', 'Antibiyotik', 'Tablet', 5, 20, '2026-12-31', 15.00, 1),
('Eski İlaç B', 'Test Madde 2', 'Ağrı Kesici', 'Tablet', 8, 25, '2027-01-31', 20.00, 2),
-- Son kullanma tarihi geçmiş
('Süresi Geçmiş İlaç', 'Eski Madde', 'Antibiyotik', 'Tablet', 50, 20, '2025-06-30', 18.00, 3);

-- ═══════════════════════════════════════════════════════════
-- RANDEVULAR (50+)
-- ═══════════════════════════════════════════════════════════
INSERT INTO randevu (tarih_saat, durum, aciklama, hayvan_id, veteriner_id) VALUES
('2026-05-01 09:00', 'Tamamlandi', 'Yıllık kontrol', 1, 9),
('2026-05-01 10:00', 'Tamamlandi', 'Aşı', 2, 9),
('2026-05-01 11:00', 'Tamamlandi', 'Genel muayene', 3, 10),
('2026-05-02 09:30', 'Tamamlandi', 'Cilt sorunu', 4, 13),
('2026-05-02 10:30', 'Tamamlandi', 'Kontrol', 5, 10),
('2026-05-02 14:00', 'Tamamlandi', 'Aşı', 6, 11),
('2026-05-03 09:00', 'Tamamlandi', 'Sterilizasyon', 7, 9),
('2026-05-03 11:00', 'Tamamlandi', 'Diş kontrolü', 8, 10),
('2026-05-04 10:00', 'Tamamlandi', 'Kırık kontrol', 9, 12),
('2026-05-04 13:00', 'Tamamlandi', 'Aşı', 10, 11),
('2026-05-05 09:00', 'Tamamlandi', 'Yıllık kontrol', 11, 10),
('2026-05-05 11:00', 'Tamamlandi', 'Acil', 12, 9),
('2026-05-06 14:00', 'Tamamlandi', 'Aşı', 13, 11),
('2026-05-07 10:00', 'Tamamlandi', 'Tüy dökülmesi', 14, 13),
('2026-05-08 09:30', 'Tamamlandi', 'Genel muayene', 15, 10),
('2026-05-08 11:30', 'Tamamlandi', 'Aşı', 16, 11),
('2026-05-09 10:00', 'Tamamlandi', 'Karın ağrısı', 17, 10),
('2026-05-09 13:00', 'Tamamlandi', 'Pati yaralanması', 18, 12),
('2026-05-10 09:00', 'Tamamlandi', 'Aşı', 19, 11),
('2026-05-10 11:00', 'Tamamlandi', 'Sterilizasyon', 20, 9),
('2026-05-11 14:00', 'Onaylandi', 'Kontrol', 21, 10),
('2026-05-11 15:00', 'Onaylandi', 'Diş çekimi', 22, 9),
('2026-05-12 09:00', 'Onaylandi', 'Aşı', 23, 11),
('2026-05-12 10:00', 'Bekliyor', 'Genel muayene', 24, 10),
('2026-05-13 11:00', 'Bekliyor', 'Cilt kontrolü', 25, 13),
('2026-05-13 14:00', 'Bekliyor', 'Yıllık kontrol', 1, 9),
('2026-05-14 09:30', 'Bekliyor', 'Aşı', 3, 11),
('2026-05-14 10:30', 'Bekliyor', 'Kontrol', 5, 10),
('2026-05-15 09:00', 'Bekliyor', 'Sterilizasyon', 21, 9),
('2026-05-15 11:00', 'Bekliyor', 'Aşı', 7, 11);

-- ═══════════════════════════════════════════════════════════
-- MUAYENELER (40+)
-- ═══════════════════════════════════════════════════════════
INSERT INTO muayene (tarih_saat, bitis_saat, bulgular, tani, tedavi_plani, hayvan_id, veteriner_id, randevu_id) VALUES
('2026-05-01 09:00', '2026-05-01 09:30', 'Genel sağlık durumu iyi', 'Sağlıklı', 'Yıllık aşı önerildi', 1, 9, 1),
('2026-05-01 10:00', '2026-05-01 10:20', 'Aşı zamanı geldi', 'Sağlıklı', 'Karma aşı uygulandı', 2, 9, 2),
('2026-05-01 11:00', '2026-05-01 11:25', 'Hafif kilo artışı', 'Obezite riski', 'Diyet önerildi', 3, 10, 3),
('2026-05-02 09:30', '2026-05-02 10:15', 'Cilt kızarıklığı, kaşıntı', 'Atopik Dermatit', 'Antihistaminik + krem', 4, 13, 4),
('2026-05-02 10:30', '2026-05-02 10:50', 'Normal', 'Sağlıklı', 'Sonraki kontrol 6 ay', 5, 10, 5),
('2026-05-02 14:00', '2026-05-02 14:25', 'Aşı uygulaması', 'Sağlıklı', 'Karma aşı', 6, 11, 6),
('2026-05-03 09:00', '2026-05-03 11:30', 'Sterilizasyon operasyonu', 'Operasyon Tamamlandı', 'Antibiyotik 7 gün', 7, 9, 7),
('2026-05-03 11:00', '2026-05-03 11:45', 'Diş taşı, hafif gingivit', 'Diş Eti İltihabı', 'Diş temizliği önerildi', 8, 10, 8),
('2026-05-04 10:00', '2026-05-04 10:40', 'Sol arka pati şişlik', 'Burkulma', 'İstirahat + ağrı kesici', 9, 12, 9),
('2026-05-04 13:00', '2026-05-04 13:20', 'Aşı zamanı', 'Sağlıklı', 'Karma aşı', 10, 11, 10),
('2026-05-05 09:00', '2026-05-05 09:30', 'Yıllık genel kontrol', 'Sağlıklı', 'Vitamin desteği', 11, 10, 11),
('2026-05-05 11:00', '2026-05-05 12:00', 'Acil - kusma, ishal', 'Gastroenterit', 'IV sıvı + antibiyotik', 12, 9, 12),
('2026-05-06 14:00', '2026-05-06 14:20', 'Aşı', 'Sağlıklı', 'Karma aşı', 13, 11, 13),
('2026-05-07 10:00', '2026-05-07 10:45', 'Yoğun tüy dökülmesi', 'Mevsimsel Tüy Dökümü', 'Omega-3 + şampuan', 14, 13, 14),
('2026-05-08 09:30', '2026-05-08 10:00', 'Genel muayene', 'Sağlıklı', 'Rutin kontrol', 15, 10, 15),
('2026-05-08 11:30', '2026-05-08 11:50', 'Aşı', 'Sağlıklı', 'Karma aşı', 16, 11, 16),
('2026-05-09 10:00', '2026-05-09 10:50', 'Karın bölgesinde hassasiyet', 'Üst Solunum Yolu Enfeksiyonu', 'Antibiyotik 7 gün', 17, 10, 17),
('2026-05-09 13:00', '2026-05-09 13:30', 'Pati pencesinde derin kesik', 'Yumuşak Doku Yaralanması', 'Dikiş + antibiyotik', 18, 12, 18),
('2026-05-10 09:00', '2026-05-10 09:20', 'Aşı', 'Sağlıklı', 'Karma aşı', 19, 11, 19),
('2026-05-10 11:00', '2026-05-10 13:00', 'Sterilizasyon', 'Operasyon Tamamlandı', 'Antibiyotik 7 gün', 20, 9, 20);

-- Devamı (ay öncesi muayeneler)
INSERT INTO muayene (tarih_saat, bitis_saat, bulgular, tani, tedavi_plani, hayvan_id, veteriner_id) VALUES
('2026-04-15 10:00', '2026-04-15 10:30', 'Cilt sorunu', 'Atopik Dermatit', 'Krem + ilaç', 4, 13),
('2026-04-20 11:00', '2026-04-20 11:25', 'Kontrol', 'Sağlıklı', 'Rutin kontrol', 1, 9),
('2026-04-22 14:00', '2026-04-22 14:30', 'Üst Solunum Yolu Enfeksiyonu', 'Üst Solunum Yolu Enfeksiyonu', 'Antibiyotik', 17, 10),
('2026-04-25 09:00', '2026-04-25 09:25', 'Mide rahatsızlığı', 'Gastroenterit', 'Diyet + ilaç', 12, 9),
('2026-03-10 10:00', '2026-03-10 10:40', 'Atopik dermatit kontrolü', 'Atopik Dermatit', 'İlaç değişikliği', 7, 13),
('2026-03-15 11:00', '2026-03-15 11:30', 'Genel muayene', 'Sağlıklı', 'Rutin', 11, 10),
('2026-03-20 13:00', '2026-03-20 13:25', 'Aşı', 'Sağlıklı', 'Karma aşı', 5, 11),
('2026-03-25 14:00', '2026-03-25 14:45', 'Diş kontrolü', 'Diş Eti İltihabı', 'Temizlik önerildi', 8, 10);

-- ═══════════════════════════════════════════════════════════
-- AŞI KAYITLARI (Bazıları geçmiş, bazıları gecikmiş)
-- ═══════════════════════════════════════════════════════════
INSERT INTO asi_kaydi (asi_turu, uygulama_tarihi, sonraki_doz_tarihi, parti_no, hayvan_id, veteriner_id) VALUES
('Karma Aşı', '2025-05-01', '2026-05-01', 'LOT-A123', 1, 9),
('Kuduz', '2025-05-01', '2026-05-01', 'LOT-B456', 1, 9),
('Karma Aşı', '2025-06-15', '2026-06-15', 'LOT-A124', 2, 9),
('Kuduz', '2025-06-15', '2026-06-15', 'LOT-B457', 2, 9),
('Karma Aşı', '2024-12-10', '2025-12-10', 'LOT-A125', 3, 10),  -- Gecikmiş!
('Karma Aşı', '2025-08-20', '2026-08-20', 'LOT-A126', 4, 10),
('Kuduz', '2025-08-20', '2026-08-20', 'LOT-B458', 4, 10),
('Karma Aşı', '2024-11-05', '2025-11-05', 'LOT-A127', 5, 11),  -- Gecikmiş!
('Karma Aşı', '2025-07-12', '2026-07-12', 'LOT-A128', 6, 11),
('Karma Aşı', '2026-05-01', '2027-05-01', 'LOT-A129', 7, 9),
('Karma Aşı', '2024-09-22', '2025-09-22', 'LOT-A130', 8, 10),  -- Gecikmiş!
('Karma Aşı', '2025-10-08', '2026-10-08', 'LOT-A131', 9, 12),
('Karma Aşı', '2025-04-15', '2026-04-15', 'LOT-A132', 10, 11),  -- Gecikmiş!
('Karma Aşı', '2025-12-25', '2026-12-25', 'LOT-A133', 11, 10),
('Karma Aşı', '2026-05-05', '2027-05-05', 'LOT-A134', 12, 9),
('Karma Aşı', '2025-03-18', '2026-03-18', 'LOT-A135', 13, 11),  -- Gecikmiş!
('Karma Aşı', '2025-08-30', '2026-08-30', 'LOT-A136', 15, 10),
('Karma Aşı', '2026-05-08', '2027-05-08', 'LOT-A137', 16, 11),
('Karma Aşı', '2024-10-12', '2025-10-12', 'LOT-A138', 19, 11),  -- Gecikmiş!
('Karma Aşı', '2025-11-20', '2026-11-20', 'LOT-A139', 21, 10);

-- ═══════════════════════════════════════════════════════════
-- CERRAHİ OPERASYONLAR
-- ═══════════════════════════════════════════════════════════
INSERT INTO cerrahi_operasyon (operasyon_turu, tarih_saat, anestezi_turu, notlar, durum, hayvan_id, veteriner_id) VALUES
('Sterilizasyon', '2026-05-03 09:30', 'Genel', 'Sorunsuz', 'Tamamlandi', 7, 9),
('Sterilizasyon', '2026-05-10 11:30', 'Genel', 'Sorunsuz', 'Tamamlandi', 20, 9),
('Diş Çekimi', '2026-04-12 14:00', 'Lokal', 'Üst sağ köpek dişi çekildi', 'Tamamlandi', 8, 9),
('Kitle Çıkarma', '2026-03-20 10:00', 'Genel', 'İyi huylu kitle', 'Tamamlandi', 12, 9),
('Kırık Onarımı', '2026-04-05 11:00', 'Genel', 'Sol arka pati', 'Tamamlandi', 9, 12),
('Sterilizasyon', '2026-02-15 09:00', 'Genel', 'Sorunsuz', 'Tamamlandi', 3, 9),
('Diş Çekimi', '2026-01-22 10:30', 'Lokal', 'Diş taşı temizliği + çekim', 'Tamamlandi', 11, 9),
('Sterilizasyon', '2026-05-15 09:00', 'Genel', 'Planlandı', 'Planlanmis', 21, 9),
('Tümor Çıkarma', '2026-05-20 10:00', 'Genel', 'Planlandı', 'Planlanmis', 22, 9);

-- ═══════════════════════════════════════════════════════════
-- LAB TESTLERİ
-- ═══════════════════════════════════════════════════════════
INSERT INTO lab_test (test_turu, tarih, sonuc, referans_deger_alt, referans_deger_ust, birim, durum, hayvan_id, veteriner_id, muayene_id) VALUES
('Hemoglobin', '2026-05-02', '14.5', 12.0, 18.0, 'g/dL', 'Tamamlandi', 4, 13, 4),
('Glukoz', '2026-05-02', '95', 70.0, 110.0, 'mg/dL', 'Tamamlandi', 4, 13, 4),
('Hemoglobin', '2026-05-09', '8.5', 12.0, 18.0, 'g/dL', 'Tamamlandi', 17, 10, 17),
('Lökosit', '2026-05-09', '25000', 6000.0, 17000.0, 'mm3', 'Tamamlandi', 17, 10, 17),
('Glukoz', '2026-05-05', '180', 70.0, 110.0, 'mg/dL', 'Tamamlandi', 12, 9, 12),
('Hemoglobin', '2026-05-05', '11.0', 12.0, 18.0, 'g/dL', 'Tamamlandi', 12, 9, 12),
('Lökosit', '2026-04-22', '22000', 6000.0, 17000.0, 'mm3', 'Tamamlandi', 17, 10, 23),
('Glukoz', '2026-05-10', '85', 70.0, 110.0, 'mg/dL', 'Tamamlandi', 11, 10, 11),
('Üre', '2026-05-10', '22', 15.0, 45.0, 'mg/dL', 'Tamamlandi', 11, 10, 11),
('Kreatinin', '2026-05-10', '0.8', 0.5, 1.5, 'mg/dL', 'Tamamlandi', 11, 10, 11);

-- ═══════════════════════════════════════════════════════════
-- REÇETELER
-- ═══════════════════════════════════════════════════════════
INSERT INTO recete (recete_id, muayene_id, tarih, aciklama) VALUES
(1, 4, '2026-05-02', 'Atopik dermatit tedavisi'),
(1, 7, '2026-05-03', 'Operasyon sonrası antibiyotik'),
(1, 9, '2026-05-04', 'Pati burkulması'),
(1, 12, '2026-05-05', 'Gastroenterit'),
(1, 17, '2026-05-09', 'Solunum yolu enfeksiyonu'),
(1, 18, '2026-05-09', 'Yara tedavisi');

INSERT INTO recete_detay (recete_id, muayene_id, ilac_id, doz, kullanim_sekli, sure_gun) VALUES
(1, 4, 13, '5mg', 'Günde 1 tablet', 10),
(1, 4, 6, '0.5ml', 'Günde 1 kez deri altı', 5),
(1, 7, 1, '500mg', 'Günde 2 tablet', 7),
(1, 7, 2, '1ml', 'Günde 1 kez ağız yoluyla', 5),
(1, 9, 2, '1ml', 'Günde 1 kez ağız yoluyla', 7),
(1, 9, 11, '50mg', 'Günde 2 tablet', 5),
(1, 12, 1, '500mg', 'Günde 2 tablet', 7),
(1, 17, 5, '250mg', 'Günde 2 tablet', 7),
(1, 17, 11, '50mg', 'Günde 2 tablet', 3),
(1, 18, 1, '500mg', 'Günde 2 tablet', 5);

-- ═══════════════════════════════════════════════════════════
-- FATURALAR
-- ═══════════════════════════════════════════════════════════
INSERT INTO fatura (tarih, toplam_tutar, odeme_durumu, odeme_turu, muayene_id, sahip_id) VALUES
('2026-05-01 09:35', 350.00, 'Odendi', 'Nakit', 1, 1),
('2026-05-01 10:25', 280.00, 'Odendi', 'Kredi Kartı', 2, 1),
('2026-05-01 11:30', 250.00, 'Odendi', 'Kredi Kartı', 3, 2),
('2026-05-02 10:20', 450.00, 'Odendi', 'Kredi Kartı', 4, 2),
('2026-05-02 10:55', 250.00, 'Odendi', 'Nakit', 5, 3),
('2026-05-02 14:30', 280.00, 'Odendi', 'Kredi Kartı', 6, 3),
('2026-05-03 11:35', 1500.00, 'Odendi', 'Kredi Kartı', 7, 4),
('2026-05-03 11:50', 350.00, 'Bekliyor', NULL, 8, 4),
('2026-05-04 10:45', 320.00, 'Bekliyor', NULL, 9, 5),
('2026-05-04 13:25', 280.00, 'Odendi', 'Nakit', 10, 5),
('2026-05-05 09:35', 250.00, 'Odendi', 'Kredi Kartı', 11, 6),
('2026-05-05 12:05', 850.00, 'Bekliyor', NULL, 12, 6),
('2026-05-06 14:25', 280.00, 'Odendi', 'Nakit', 13, 7),
('2026-05-07 10:50', 380.00, 'Odendi', 'Kredi Kartı', 14, 7),
('2026-05-08 10:05', 250.00, 'Odendi', 'Nakit', 15, 8),
('2026-05-08 11:55', 280.00, 'Odendi', 'Kredi Kartı', 16, 8),
('2026-05-09 10:55', 480.00, 'Bekliyor', NULL, 17, 1),
('2026-05-09 13:35', 550.00, 'Bekliyor', NULL, 18, 2),
('2026-05-10 09:25', 280.00, 'Odendi', 'Nakit', 19, 3),
('2026-05-10 13:05', 1500.00, 'Odendi', 'Kredi Kartı', 20, 4),
-- Eski ödenmemiş faturalar
('2026-02-15 10:00', 750.00, 'Bekliyor', NULL, NULL, 1),
('2026-03-10 11:00', 420.00, 'Bekliyor', NULL, 25, 4),
('2026-01-20 14:00', 1200.00, 'Bekliyor', NULL, NULL, 6);

-- FATURA KALEMLERİ
INSERT INTO fatura_kalem (fatura_id, kalem_no, hizmet_adi, miktar, birim_fiyat, toplam) VALUES
(1, 1, 'Genel Muayene', 1, 250.00, 250.00),
(1, 2, 'Yıllık Kontrol', 1, 100.00, 100.00),
(2, 1, 'Karma Aşı', 1, 200.00, 200.00),
(2, 2, 'Muayene', 1, 80.00, 80.00),
(3, 1, 'Genel Muayene', 1, 250.00, 250.00),
(4, 1, 'Dermatoloji Muayene', 1, 350.00, 350.00),
(4, 2, 'İlaç', 1, 100.00, 100.00),
(5, 1, 'Kontrol Muayenesi', 1, 250.00, 250.00),
(6, 1, 'Karma Aşı', 1, 200.00, 200.00),
(6, 2, 'Muayene', 1, 80.00, 80.00),
(7, 1, 'Sterilizasyon Operasyonu', 1, 1500.00, 1500.00),
(8, 1, 'Diş Kontrolü', 1, 350.00, 350.00),
(9, 1, 'Ortopedi Muayenesi', 1, 320.00, 320.00),
(10, 1, 'Karma Aşı', 1, 200.00, 200.00),
(10, 2, 'Muayene', 1, 80.00, 80.00),
(11, 1, 'Yıllık Kontrol', 1, 250.00, 250.00),
(12, 1, 'Acil Muayene', 1, 450.00, 450.00),
(12, 2, 'IV Sıvı Tedavisi', 1, 250.00, 250.00),
(12, 3, 'Lab Test', 1, 150.00, 150.00),
(13, 1, 'Karma Aşı', 1, 200.00, 200.00),
(13, 2, 'Muayene', 1, 80.00, 80.00),
(14, 1, 'Dermatoloji Muayene', 1, 350.00, 350.00),
(14, 2, 'Şampuan', 1, 30.00, 30.00),
(15, 1, 'Genel Muayene', 1, 250.00, 250.00),
(16, 1, 'Karma Aşı', 1, 200.00, 200.00),
(16, 2, 'Muayene', 1, 80.00, 80.00),
(17, 1, 'Dahiliye Muayene', 1, 280.00, 280.00),
(17, 2, 'Antibiyotik Tedavisi', 1, 200.00, 200.00),
(18, 1, 'Ortopedi Muayene', 1, 320.00, 320.00),
(18, 2, 'Yara Bakımı + Dikiş', 1, 230.00, 230.00),
(19, 1, 'Karma Aşı', 1, 200.00, 200.00),
(19, 2, 'Muayene', 1, 80.00, 80.00),
(20, 1, 'Sterilizasyon Operasyonu', 1, 1500.00, 1500.00),
(21, 1, 'Diş Operasyonu', 1, 750.00, 750.00),
(22, 1, 'Aşı + Muayene', 1, 420.00, 420.00),
(23, 1, 'Cerrahi Operasyon', 1, 1200.00, 1200.00);

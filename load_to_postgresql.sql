--- ===========================================
--- MILESTONE 1 - SQL
---	Nama	: Aldi Zulkarnaen Alamsyah
--- Batch	: CODA-RMT-023
---	
--- Program ini dibuat untuk menyimpan data saham paling aktif yang telah dibersihkan sebelumnya melalui pandas.
--- ===========================================

--- LANGKAH 0 :
--- Data ini tidak memerlukan normalisasi karena data yang diambil merupakan data tunggal
--- Snapshot data 100 saham paling aktif dalam satu waktu, tidak ada pengulangan atau redundansi
CREATE DATABASE milestone1_aldi;

--- Pindah koneksi ke database milestone1_aldi sebelum lanjut ke langkah 1,
--- supaya tabel tidak terbuat di database default (postgres).
--- psql   : jalankan \c milestone1_aldi
--- pgAdmin: buka Query Tool baru pada database milestone1_aldi


--- LANGKAH 1 : Membuat tabel
--- Menggunakan VARCHAR untuk teks (symbol & nama), menggunakan FLOAT untuk angka desimal dan besar (price, change percent, volume, & market cap)
CREATE TABLE most_active_stocks (
	symbol VARCHAR(10) PRIMARY KEY, ---> Symbol, digunakan sebagai unique identifier (PK)
	company_name VARCHAR(100),
	price FLOAT,
	change_percent FLOAT,
	volume FLOAT,
	market_cap FLOAT
);


--- LANGKAH 2 : Import data
--- Menggunakan copy from shared untuk bypass akses file lokal
--- Menggunakan parameter header agar baris pertama (nama kolom) pada csv tidak ikut masuk ke dalam tabel SQL
COPY most_active_stocks FROM '/Users/Shared/bersih_most_active.csv'
DELIMITER ','
CSV HEADER;


---	LANGKAH 3 : Menampilkan data
SELECT * FROM most_active_stocks;


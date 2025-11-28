USE TokoRetailDB;

INSERT INTO Pelanggan(NamaDepan, NamaBelakang, Email, NoTelepon)
VALUES
('Muhammad Rifqi', 'Rajif', 'apacoba@gmail.com', '086234673476'),
('Novaldy Arya', 'Friwansyah', 'hehe@gmail.com', NULL); 

INSERT INTO KategoriProduk(NamaKategori)
VALUES
('Elektronik'),
('Pakaian'),
('Buku');

--MELIHAT DATA
SELECT * FROM Pelanggan;
SELECT * FROM KategoriProduk;
SELECT NamaDepan,NamaBelakang,Email,NoTelepon From Pelanggan;

INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID)
VALUES
('ELEC-001', 'Laptop Pro 14 inch', 15000000.00, 50, 1), -- KategoriID 1 =
--Elektronik
('PAK-001', 'Kaos Polos Putih', 75000.00, 200, 2), -- KategoriID 2 =
--Pakaian
('BUK-001', 'Dasar-Dasar SQL', 120000.00, 100, 3); -- KategoriID 3 =
--Buku

SELECT * FROM Produk;

SELECT P.*, K.NamaKategori
FROM Produk AS P
JOIN KategoriProduk AS K ON P.KategoriID = K.KategoriID;

PRINT 'Uji Coba Error 1 (UNIQUE):';
INSERT INTO Pelanggan (NamaDepan, Email)
VALUES ('Muhammad Rifqi', 'apacoba@gmail.com');
GO

PRINT 'Uji Coba Error 2 (FOREIGN KEY):';
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID)
VALUES ('XXX-001', 'Produk Aneh', 1000, 10, 99);
GO

PRINT 'Data Rifqi SEBELUM Update';
SELECT * FROM Pelanggan WHERE PelangganID = 2;

BEGIN TRANSACTION;

UPDATE Pelanggan
SET NoTelepon = '085759210832'
WHERE PelangganID = 2;

PRINT 'Data Rifqi SETELAH Update (Belum di-COMMIT):';
SELECT * FROM Pelanggan WHERE PelangganID = 2;

COMMIT TRANSACTION;

PRINT 'Data Rifqi setelah di-COMMIT:';
SELECT * FROM Pelanggan WHERE PelangganID = 2;

PRINT 'Data Elektronik SEBELUM Update:';
SELECT * FROM Produk WHERE KategoriID = 1;

BEGIN TRANSACTION;

UPDATE Produk
SET Harga = Harga * 1.10
WHERE KategoriID = 1;

PRINT 'Data Elektronik SETELAH Update (Belum di-COMMIT):';
SELECT * FROM Produk WHERE KategoriID = 1;

COMMIT TRANSACTION;

PRINT 'Data Produk SEBELUM Delete:';
SELECT * FROM Produk WHERE SKU = 'BUK-001';

BEGIN TRANSACTION;

DELETE FROM Produk
WHERE SKU = 'BUK-001';

PRINT 'Data Produk SETELAH Delete (Belum di-COMMIT):';
SELECT * FROM Produk WHERE SKU = 'BUK-001';

COMMIT TRANSACTION;

PRINT 'Data Stok SEBELUM Bencana:';
SELECT SKU, NamaProduk, Stok FROM Produk;

BEGIN TRANSACTION;

UPDATE Produk
SET Stok = 0;

PRINT 'Data Stok SETELAH Bencana (PANIK!):';
SELECT SKU, NamaProduk, Stok FROM Produk;

PRINT 'Melakukan ROLLBACK...';
ROLLBACK TRANSACTION;

PRINT 'Data Stok SETELAH di-ROLLBACK (AMAN):';
SELECT SKU, NamaProduk, Stok FROM Produk;

INSERT INTO PesananHeader (PelangganID, StatusPesanan)
VALUES (1, 'Baru');

PRINT 'Data Pesanan Rifqi:';
SELECT * FROM PesananHeader WHERE PelangganID = 1;
GO

PRINT 'Mencoba Menghapus Rifqi...:';
BEGIN TRANSACTION;

DELETE FROM Pelanggan
WHERE PelangganID = 1;

ROLLBACK TRANSACTION;

CREATE TABLE ProdukArsip (
ProdukID INT PRIMARY KEY,
SKU VARCHAR(20) NOT NULL,
NamaProduk VARCHAR(150) NOT NULL,
Harga DECIMAL(10, 2) NOT NULL,
TanggalArsip DATE DEFAULT GETDATE()
);
GO

BEGIN TRANSACTION;

UPDATE Produk SET Stok = 0 WHERE SKU = 'PAK-001';

INSERT INTO ProdukArsip (ProdukID, SKU, NamaProduk, Harga)
SELECT ProdukID, SKU, NamaProduk, Harga
FROM Produk
WHERE Stok = 0;

DELETE FROM Produk
WHERE  Stok = 0;

PRINT 'Cek Produk Aktif (Kaos harus hilang):';
SELECT * FROM Produk;

PRINT 'Cek Produk Arsip (Kaos harus ada):';
SELECT * FROM ProdukArsip;

COMMIT TRANSACTION;

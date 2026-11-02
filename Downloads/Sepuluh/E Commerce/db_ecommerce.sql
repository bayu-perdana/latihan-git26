-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 01, 2026 at 05:08 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_ecommerce`
--

-- --------------------------------------------------------

--
-- Table structure for table `detail_pesanan`
--

CREATE TABLE `detail_pesanan` (
  `id_detail` int(11) NOT NULL,
  `id_pesanan` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_pesanan`
--

INSERT INTO `detail_pesanan` (`id_detail`, `id_pesanan`, `id_produk`, `jumlah`, `subtotal`) VALUES
(1, 1, 1, 1, 8500000.00),
(2, 1, 2, 1, 150000.00),
(3, 2, 3, 1, 450000.00),
(4, 2, 2, 1, 150000.00),
(5, 3, 4, 1, 1800000.00),
(6, 4, 5, 3, 285000.00),
(7, 5, 8, 1, 3500000.00),
(8, 6, 6, 1, 1250000.00),
(9, 6, 7, 1, 350000.00),
(10, 7, 3, 1, 450000.00);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pelanggan` int(11) NOT NULL,
  `nama_pelanggan` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telepon` varchar(15) DEFAULT NULL,
  `kota` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id_pelanggan`, `nama_pelanggan`, `email`, `telepon`, `kota`) VALUES
(1, 'Budi Santoso', 'budi@gmail.com', '081234567890', 'Jakarta'),
(2, 'Siti Aminah', 'siti@yahoo.com', '082198765432', 'Bandung'),
(3, 'Eko Prasetyo', 'eko@gmail.com', '085611223344', 'Surabaya'),
(4, 'Rina Wijaya', 'rina@gmail.com', '087855667788', 'Semarang'),
(5, 'Dewi Lestari', 'dewi@outlook.com', '081399001122', 'Yogyakarta'),
(6, 'Ahmad Fauzi', 'ahmad@gmail.com', '085744332211', 'Jakarta'),
(7, 'Lestari Putri', 'lestari@gmail.com', '081288776655', 'Medan'),
(8, 'Hadi Pratama', 'hadi@yahoo.com', '083811224455', 'Surabaya'),
(9, 'Maya Indah', 'maya@gmail.com', '089633445566', 'Bandung'),
(10, 'Rizky Ramadhan', 'rizky@gmail.com', '087799887766', 'Jakarta');

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `id_pesanan` int(11) NOT NULL,
  `id_pelanggan` int(11) NOT NULL,
  `tanggal_pesan` date NOT NULL,
  `total_harga` decimal(12,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`id_pesanan`, `id_pelanggan`, `tanggal_pesan`, `total_harga`) VALUES
(1, 1, '2026-10-01', 8650000.00),
(2, 2, '2026-10-02', 600000.00),
(3, 3, '2026-10-03', 1800000.00),
(4, 4, '2026-10-04', 285000.00),
(5, 5, '2026-10-05', 3500000.00),
(6, 6, '2026-10-06', 1550000.00),
(7, 7, '2026-10-07', 450000.00),
(8, 8, '2026-10-08', 750000.00),
(9, 9, '2026-10-09', 190000.00),
(10, 10, '2026-10-10', 8850000.00);

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id_produk` int(11) NOT NULL,
  `nama_produk` varchar(100) NOT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `harga` decimal(12,2) NOT NULL,
  `stok` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id_produk`, `nama_produk`, `kategori`, `harga`, `stok`) VALUES
(1, 'Laptop Asus Vivobook', 'Elektronik', 8500000.00, 9),
(2, 'Mouse Wireless Logitech', 'Aksesori', 150000.00, 50),
(3, 'Keyboard Mekanikal', 'Aksesori', 450000.00, 30),
(4, 'Monitor LED 24 Inch', 'Elektronik', 1800000.00, 20),
(5, 'Flashdisk 64GB', 'Aksesori', 95000.00, 100),
(6, 'Printer Inkjet Canon', 'Elektronik', 1250000.00, 12),
(7, 'Headset Gaming', 'Aksesori', 350000.00, 25),
(8, 'Smartphone Samsung', 'Elektronik', 3500000.00, 18),
(9, 'Webcam Full HD', 'Aksesori', 275000.00, 40),
(10, 'Meja Kerja Kayu', 'Meubel', 750000.00, 8);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `id_pesanan` (`id_pesanan`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id_pesanan`),
  ADD KEY `id_pelanggan` (`id_pelanggan`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_produk`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id_pelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id_pesanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD CONSTRAINT `detail_pesanan_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_pesanan_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

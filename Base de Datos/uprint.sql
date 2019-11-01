-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 01, 2019 at 04:54 AM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `uprint`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `showsproductcost` (`idprod` INT)  BEGIN
        SELECT pc.idProduct, pc.idSupply, sp.nameSupply, pc.typeSupply, sp.unitCostSupply, pc.quantityProductCost, pc.idUnit
        FROM productscost AS pc
        INNER JOIN supplies AS sp ON pc.idSupply=sp.idSupply
        INNER JOIN products AS p ON pc.idProduct=p.idProduct
        WHERE p.statusProduct=1 AND p.idProduct=idprod;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `showsproductprice` (`idprod` INT)  BEGIN
        SELECT pp.idProduct, pp.publicUtilityPrice, pp.publicPrice, pp.associatedUtilityPrice, pp.associatedPrice, pp.wholesaleDiscountPrice, pp.wholesalePrice, pp.wholesaleUtilityPrice, pp.distributorDiscountPrice, pp.distributorPrice, pp.distributorUtilityPrice, pp.distinguishedDiscountPrice, pp.distinguishedPrice, pp.distinguishedUtilityPrice
        FROM productsprice AS pp
        INNER JOIN products AS p ON pp.idProduct=p.idProduct
        WHERE p.statusProduct=1 AND p.idProduct=idprod;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `showsproductproperties` (`idprod` INT)  BEGIN
        SELECT p.idProduct, p.nameProduct, p.idBrand, sl.idLine, sl.idSubline, p.idSubsubline, p.idUnit, d.widthDimension, d.heightDimension, p.idCategory, p.idSubcategory, p.imageProduct, p.enableProduct, p.featuresProduct
        FROM products AS p
        INNER JOIN subsublines AS ssbl ON p.idSubsubline=ssbl.idSubsubline
        INNER JOIN sublines AS sl ON ssbl.idSubline=sl.idSubline
        LEFT JOIN dimensions AS d ON p.idDimension=d.idDimension
        WHERE p.statusProduct=1 AND p.idProduct=idprod;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `showstecnipackcost` (`idtec` INT)  BEGIN
        SELECT tc.idTecnipack, tc.idProduct, p.nameProduct, tc.quantityTecnipackCost, pp.publicPrice
        FROM tecnipackscost AS tc
        INNER JOIN products AS p ON tc.idProduct=p.idProduct
        INNER JOIN productsprice AS pp ON p.idProduct=pp.idProduct
        INNER JOIN tecnipacks AS t ON tc.idTecnipack=t.idTecnipack
        WHERE t.statusTecnipack=1 AND t.idTecnipack=idtec;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `showstecnipackprice` (`idtec` INT)  BEGIN
        SELECT tp.idTecnipack, tp.publicUtilityPrice, tp.publicPrice, tp.associatedUtilityPrice, tp.associatedPrice, tp.wholesaleDiscountPrice, tp.wholesalePrice, tp.wholesaleUtilityPrice, tp.distributorDiscountPrice, tp.distributorPrice, tp.distributorUtilityPrice, tp.distinguishedDiscountPrice, tp.distinguishedPrice, tp.distinguishedUtilityPrice
        FROM tecnipacksprice AS tp
        INNER JOIN tecnipacks AS t ON tp.idTecnipack=t.idTecnipack
        WHERE t.statusTecnipack=1 AND t.idTecnipack=idtec;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `showstecnipackproperties` (`idtec` INT)  BEGIN
        SELECT t.idTecnipack, t.nameTecnipack, t.enableTecnipack, t.importantTecnipack, t.imageTecnipack
        FROM tecnipacks AS t
        WHERE t.statusTecnipack=1 AND t.idTecnipack=idtec;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `brands`
--

CREATE TABLE `brands` (
  `idBrand` int(11) NOT NULL,
  `nameBrand` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `brands`
--

INSERT INTO `brands` (`idBrand`, `nameBrand`) VALUES
(1, 'brand 1');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `idCategory` int(11) NOT NULL,
  `nameCategory` varchar(60) COLLATE utf8_spanish_ci NOT NULL,
  `imageCategory` varchar(100) COLLATE utf8_spanish_ci DEFAULT 'files/categories/defaultc.jpg',
  `statusCategory` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`idCategory`, `nameCategory`, `imageCategory`, `statusCategory`) VALUES
(0, 'Tazas', 'files/categories/defaultc.jpg', 1),
(1, 'Foto Regalos', 'files/categories/defaultc.jpg', 1),
(2, 'Foto libros', 'ruta/carpeta', 1),
(3, 'Foto Marcos', 'files/categories/defaultc.jpg', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE `cities` (
  `idCity` int(11) NOT NULL,
  `numberCity` int(11) NOT NULL,
  `nameCity` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `idState` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `cities`
--

INSERT INTO `cities` (`idCity`, `numberCity`, `nameCity`, `idState`) VALUES
(1, 123456789, 'Zitacuaro', 1),
(2, 2431, 'Morelia', 1),
(3, 6354, 'Uruapan', 1),
(4, 3554, 'San Antonio', 2);

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `idClient` int(11) NOT NULL,
  `nameClient` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `rfcClient` varchar(14) COLLATE utf8_spanish_ci NOT NULL,
  `streetClient` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `suburbClient` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `zipcodeClient` varchar(5) COLLATE utf8_spanish_ci NOT NULL,
  `extNumberClient` int(11) NOT NULL,
  `intNumberClient` int(11) DEFAULT NULL,
  `telephone1Client` varchar(14) COLLATE utf8_spanish_ci DEFAULT NULL,
  `telephone2Client` varchar(14) COLLATE utf8_spanish_ci DEFAULT NULL,
  `celphone1Client` varchar(14) COLLATE utf8_spanish_ci DEFAULT NULL,
  `celphone2Client` varchar(14) COLLATE utf8_spanish_ci DEFAULT NULL,
  `emailClient` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `dischargeDateClient` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `idCity` int(11) NOT NULL,
  `idTypeClient` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`idClient`, `nameClient`, `rfcClient`, `streetClient`, `suburbClient`, `zipcodeClient`, `extNumberClient`, `intNumberClient`, `telephone1Client`, `telephone2Client`, `celphone1Client`, `celphone2Client`, `emailClient`, `dischargeDateClient`, `idCity`, `idTypeClient`) VALUES
(1, 'Mario Alberto Vega Gonzalez', 'qwer123145qe', 'Francisco I. Madero', 'sdfghjkl', '58130', 76, NULL, '4434434433', NULL, NULL, NULL, 'mayitogonzales@itmorelia.edu.mx', '2019-10-21 05:00:00', 1, 1),
(2, 'Miriam Yadira Peñaloza Valencia', 'miyp123145qe', 'Atzimba', '', '', 167, NULL, '4430012345', NULL, NULL, NULL, 'btsosiosi@gmail.com', '2019-10-30 06:00:00', 2, 1),
(3, 'Rodrigo Alejandro Martinez Sanchez', 'ramt543wqe3', 'Fray nose', '', '58150', 85, NULL, '4431179034', NULL, NULL, NULL, 'sonykuun@gmail.com', '2019-10-01 05:00:00', 3, 1),
(4, 'Blanca Leticia Guerra Morales', 'blalg432gmj', 'Niños Heroes', '', '', 196, NULL, '4431042587', NULL, NULL, NULL, 'blancaleticia@gmail.com', '2017-05-09 05:00:00', 2, 1),
(43, 'Alexis Emmanuel Medrano Leon', 'alml876qe', 'Soledad', '', '', 520, NULL, '4431157976', NULL, NULL, NULL, 'alexis@gmail.com', '2019-10-29 06:00:00', 4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `idCountry` varchar(2) COLLATE utf8_spanish_ci NOT NULL,
  `nameCountry` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`idCountry`, `nameCountry`) VALUES
('1', 'Mexico'),
('2', 'Estados Unidos'),
('3', 'Brazil'),
('4', 'Canada');

-- --------------------------------------------------------

--
-- Table structure for table `dimensions`
--

CREATE TABLE `dimensions` (
  `idDimension` int(11) NOT NULL,
  `widthDimension` double NOT NULL,
  `heightDimension` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `dimensions`
--

INSERT INTO `dimensions` (`idDimension`, `widthDimension`, `heightDimension`) VALUES
(1, 25, 15),
(2, 15, 15);

-- --------------------------------------------------------

--
-- Table structure for table `employes`
--

CREATE TABLE `employes` (
  `idEmployee` int(11) NOT NULL,
  `nameEmployee` varchar(55) COLLATE utf8_spanish_ci NOT NULL,
  `rfcEmployee` varchar(14) COLLATE utf8_spanish_ci NOT NULL,
  `curpEmployee` varchar(18) COLLATE utf8_spanish_ci DEFAULT NULL,
  `birthdateEmployee` date NOT NULL,
  `streetEmployee` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `suburbEmployee` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `zipcodeEmployee` varchar(5) COLLATE utf8_spanish_ci NOT NULL,
  `extNumberEmployee` int(11) NOT NULL,
  `intNumberEmployee` int(11) DEFAULT NULL,
  `telephoneEmployee` varchar(14) COLLATE utf8_spanish_ci DEFAULT NULL,
  `emailEmployee` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `idCity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employesubline`
--

CREATE TABLE `employesubline` (
  `idEmployee` int(11) NOT NULL,
  `idSubsubline` int(11) NOT NULL,
  `idSubline` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kiosko`
--

CREATE TABLE `kiosko` (
  `user` varchar(15) NOT NULL,
  `street` varchar(35) NOT NULL,
  `suburb` varchar(35) NOT NULL,
  `attendantName` varchar(35) NOT NULL,
  `zipcode` varchar(7) NOT NULL,
  `attendantSecondName` varchar(40) NOT NULL,
  `pass` varchar(15) NOT NULL,
  `email` varchar(35) NOT NULL,
  `otheremail` varchar(35) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kiosko`
--

INSERT INTO `kiosko` (`user`, `street`, `suburb`, `attendantName`, `zipcode`, `attendantSecondName`, `pass`, `email`, `otheremail`) VALUES
('Abel Pintor', '687, 5th Avenue', '', 'Abel Pintor', '58120', 'Estrada', 'qwerty', 'abel@gmail.com', '');

-- --------------------------------------------------------

--
-- Table structure for table `managerusers`
--

CREATE TABLE `managerusers` (
  `idManagerUser` int(11) NOT NULL,
  `nameUser` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `passwordUser` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `idTypeUser` int(11) NOT NULL,
  `statusUser` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `moldings`
--

CREATE TABLE `moldings` (
  `idMolding` varchar(4) COLLATE utf8_spanish_ci NOT NULL,
  `widthMolding` double NOT NULL,
  `wasteMolding` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `idNotification` int(11) NOT NULL,
  `idUser` int(11) NOT NULL,
  `idCreator` int(11) NOT NULL,
  `messageNotification` varchar(150) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `offerts`
--

CREATE TABLE `offerts` (
  `idOffer` int(11) NOT NULL,
  `nameOffer` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `idProduct` int(11) DEFAULT NULL,
  `idTecnipack` int(11) DEFAULT NULL,
  `quantity` double NOT NULL,
  `discount` double NOT NULL,
  `imageOffer` varchar(100) COLLATE utf8_spanish_ci NOT NULL DEFAULT 'files/promotions/defaultc.jpg',
  `enableOffer` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `idSelling` int(11) NOT NULL,
  `idArticle` int(11) NOT NULL,
  `idEmployee` int(11) DEFAULT NULL,
  `comment` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `statusOrder` varchar(15) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`idSelling`, `idArticle`, `idEmployee`, `comment`, `statusOrder`) VALUES
(1, 1, NULL, NULL, '1'),
(2, 2, NULL, NULL, '1');

-- --------------------------------------------------------

--
-- Table structure for table `paymenttypes`
--

CREATE TABLE `paymenttypes` (
  `idPaymentType` int(11) NOT NULL,
  `namePaymentType` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `paymenttypes`
--

INSERT INTO `paymenttypes` (`idPaymentType`, `namePaymentType`) VALUES
(1, 'efectivo'),
(2, 'mastercard'),
(3, 'atm'),
(4, 'paypal');

-- --------------------------------------------------------

--
-- Table structure for table `plantillas`
--

CREATE TABLE `plantillas` (
  `id_plantilla` int(11) NOT NULL,
  `fk_product` int(11) NOT NULL,
  `route_file` varchar(100) NOT NULL,
  `atribute` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `plantillas`
--

INSERT INTO `plantillas` (`id_plantilla`, `fk_product`, `route_file`, `atribute`) VALUES
(10, 1, '', 'marco de aluminio, bordado refinado de alta calidad');

-- --------------------------------------------------------

--
-- Table structure for table `prices`
--

CREATE TABLE `prices` (
  `idPrice` int(11) NOT NULL,
  `idProduct` int(11) NOT NULL,
  `price` double NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `prices`
--

INSERT INTO `prices` (`idPrice`, `idProduct`, `price`) VALUES
(1, 1, 50);

-- --------------------------------------------------------

--
-- Table structure for table `productlines`
--

CREATE TABLE `productlines` (
  `idLine` int(11) NOT NULL,
  `nameLine` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `productos`
-- (See below for the actual view)
--
CREATE TABLE `productos` (
`idProduct` int(11)
,`nameProduct` varchar(150)
,`priceProduct` double
,`imageProduct` varchar(100)
,`enableProduct` tinyint(1)
,`featuresProduct` text
,`statusProduct` tinyint(1)
,`idCategory` int(11)
,`nameCategory` varchar(60)
,`idDimension` int(11)
,`heightDimension` double
,`widthDimension` double
,`max` int(11)
,`min` int(11)
,`time` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `idProduct` int(11) NOT NULL,
  `nameProduct` varchar(150) COLLATE utf8_spanish_ci NOT NULL,
  `imageProduct` varchar(100) COLLATE utf8_spanish_ci NOT NULL DEFAULT 'files/products/defaultp.jpg',
  `enableProduct` tinyint(1) NOT NULL DEFAULT '1',
  `featuresProduct` text COLLATE utf8_spanish_ci NOT NULL,
  `statusProduct` tinyint(1) NOT NULL DEFAULT '1',
  `idCategory` int(11) NOT NULL,
  `idSubcategory` int(11) DEFAULT NULL,
  `idDimension` int(11) DEFAULT NULL,
  `idBrand` int(11) DEFAULT NULL,
  `idSubsubline` int(11) DEFAULT NULL,
  `idSubline` int(11) DEFAULT NULL,
  `idUnit` int(11) DEFAULT NULL,
  `max` int(11) DEFAULT '1',
  `min` int(11) DEFAULT '1',
  `time` int(11) DEFAULT '1',
  `price` double NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`idProduct`, `nameProduct`, `imageProduct`, `enableProduct`, `featuresProduct`, `statusProduct`, `idCategory`, `idSubcategory`, `idDimension`, `idBrand`, `idSubsubline`, `idSubline`, `idUnit`, `max`, `min`, `time`, `price`) VALUES
(1, 'Marco', 'card1.JPG', 0, 'Marco de madera con foto', 1, 3, NULL, 1, NULL, NULL, NULL, NULL, 8, 1, 120, 320),
(2, 'Fotolibro', '3.JPG', 0, 'Fotolibro con fotografías en distintas formas y terminados', 1, 2, NULL, 1, NULL, NULL, NULL, NULL, 10, 1, 5, 350),
(3, 'Taza', 'fr1b.jpg', 0, 'Taza con imagen conmemorativa', 1, 1, NULL, 1, NULL, NULL, NULL, NULL, 10, 1, 2, 120),
(4, 'Marco de Aluminio', 'fotomarco.JPG', 0, 'Marco para fotografías, hecho de aluminio', 1, 3, NULL, 1, NULL, NULL, NULL, NULL, 3, 1, 1, 200),
(5, 'Rompecabezas', 'fr0.JPG', 0, 'Rompecabezas personalizado', 1, 1, NULL, 2, NULL, NULL, NULL, NULL, 10, 1, 5, 400),
(6, 'Fotolibro largo', '2.JPG', 0, 'Fotolibro de mayor dimension, con alma personalizada', 1, 2, NULL, 1, NULL, NULL, NULL, NULL, 10, 1, 3, 650),
(7, 'LLavero', 'IMG_4570.JPG', 0, 'LLavero, de alta calidad con foto', 1, 1, NULL, 2, NULL, NULL, NULL, NULL, 20, 1, 5, 70),
(8, 'Vaso Termico', 'fr3b.jpg', 0, 'Vaso personalizado para café.', 1, 1, NULL, 1, NULL, NULL, NULL, NULL, 5, 1, 5, 300),
(9, 'Tapete para Mouse', 'fr4.JPG', 0, 'Tapete para mouse', 1, 1, NULL, 2, NULL, NULL, NULL, NULL, 10, 1, 5, 120),
(10, 'Funda para celular', 'fr2.JPG', 0, 'De varios modelos de celular, con terminados y colores distintos', 1, 1, NULL, 2, NULL, NULL, NULL, NULL, 5, 1, 1, 90),
(11, 'Fotolibro para evento', '1.JPG', 0, 'Fotolibro con imagenes recopiladas de una sesión o evento.', 1, 2, NULL, 2, NULL, NULL, NULL, NULL, 30, 1, 5, 400),
(12, 'Tarjeta presentación', 'fr5.JPG', 0, 'Tarjeta de datos personales', 1, 1, NULL, 1, NULL, NULL, NULL, NULL, 100, 10, 2, 15);

-- --------------------------------------------------------

--
-- Table structure for table `productscost`
--

CREATE TABLE `productscost` (
  `idProduct` int(11) NOT NULL,
  `idSupply` int(11) NOT NULL,
  `typeSupply` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `quantityProductCost` double NOT NULL,
  `idUnit` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `productsprice`
--

CREATE TABLE `productsprice` (
  `idProduct` int(11) NOT NULL,
  `publicUtilityPrice` double NOT NULL,
  `publicPrice` double NOT NULL,
  `associatedUtilityPrice` double NOT NULL,
  `associatedPrice` double NOT NULL,
  `wholesaleDiscountPrice` double NOT NULL,
  `wholesalePrice` double NOT NULL,
  `wholesaleUtilityPrice` double NOT NULL,
  `distributorDiscountPrice` double NOT NULL,
  `distributorPrice` double NOT NULL,
  `distributorUtilityPrice` double NOT NULL,
  `distinguishedDiscountPrice` double NOT NULL,
  `distinguishedPrice` double NOT NULL,
  `distinguishedUtilityPrice` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `providers`
--

CREATE TABLE `providers` (
  `idProvider` int(11) NOT NULL,
  `nameProvider` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `rfcProvider` varchar(14) COLLATE utf8_spanish_ci NOT NULL,
  `streetProvider` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `suburbProvider` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `zipcodeProvider` varchar(5) COLLATE utf8_spanish_ci DEFAULT NULL,
  `extNumberProvider` int(11) NOT NULL,
  `intNumberProvider` int(11) DEFAULT NULL,
  `telephoneProvider` varchar(14) COLLATE utf8_spanish_ci DEFAULT NULL,
  `emailProvider` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `webPageProvider` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `idCity` int(11) NOT NULL,
  `idPaymentType` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `providers`
--

INSERT INTO `providers` (`idProvider`, `nameProvider`, `rfcProvider`, `streetProvider`, `suburbProvider`, `zipcodeProvider`, `extNumberProvider`, `intNumberProvider`, `telephoneProvider`, `emailProvider`, `webPageProvider`, `idCity`, `idPaymentType`) VALUES
(100, 'Carpintería Amaury', 'caam3423', 'Lazaro Cardenas', '', '58250', 317, NULL, '4433111111', 'carpamaury@sepomex@gmail.com', 'www.carpintamaury.com.mx', 2, 2);

-- --------------------------------------------------------

--
-- Table structure for table `reinforcements`
--

CREATE TABLE `reinforcements` (
  `idReinforcement` int(11) NOT NULL,
  `nameReinforcement` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `quantityReinforcement` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `request`
--

CREATE TABLE `request` (
  `idRequest` int(11) NOT NULL,
  `idUser` int(11) NOT NULL,
  `idEmployee` int(11) NOT NULL,
  `comment` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `statusRequest` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sellings`
--

CREATE TABLE `sellings` (
  `idSelling` int(11) NOT NULL,
  `idArticle` int(11) NOT NULL,
  `dateSelling` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `price` double NOT NULL,
  `zipNameSelling` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `street` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `idUser` int(11) NOT NULL,
  `idProduct` int(11) DEFAULT NULL,
  `idTecnipack` int(11) DEFAULT NULL,
  `idPaymentType` int(11) DEFAULT NULL,
  `idCity` int(11) DEFAULT NULL,
  `idSubsidiary` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `sellings`
--

INSERT INTO `sellings` (`idSelling`, `idArticle`, `dateSelling`, `price`, `zipNameSelling`, `quantity`, `street`, `idUser`, `idProduct`, `idTecnipack`, `idPaymentType`, `idCity`, `idSubsidiary`) VALUES
(1, 1, '2019-10-28 06:00:00', 500, NULL, 2, NULL, 1, 1, NULL, NULL, NULL, NULL),
(2, 2, '2019-10-28 06:00:00', 500, NULL, 2, NULL, 1, 1, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `shop`
--

CREATE TABLE `shop` (
  `idShop` int(11) NOT NULL,
  `quantityShop` int(11) NOT NULL,
  `zipNameShop` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `idUser` int(11) NOT NULL,
  `idProduct` int(11) DEFAULT NULL,
  `idTecnipack` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shopusers`
--

CREATE TABLE `shopusers` (
  `idShopUser` int(11) NOT NULL,
  `nameUser` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `passwordUser` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `tecnipunntos` double DEFAULT '0',
  `statusUser` tinyint(1) NOT NULL DEFAULT '1',
  `email` varchar(30) COLLATE utf8_spanish_ci NOT NULL,
  `otherEmail` varchar(30) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `shopusers`
--

INSERT INTO `shopusers` (`idShopUser`, `nameUser`, `passwordUser`, `tecnipunntos`, `statusUser`, `email`, `otherEmail`) VALUES
(1, 'Mayito Vega', 'qwerty', 10.5, 1, 'eqer@hotmail.com', NULL),
(2, 'Miriam Yadira', 'BMBMBM', 0, 1, 'btsosiosi@gmail.com', NULL),
(3, 'Sony Rodrigo', 'yasuo', 3, 1, 'sonyuun@gmail.com', NULL),
(4, 'Blanca Leti', '0987654', 1000, 1, 'blancaleticia@gmail.com', NULL),
(43, 'Alexis Emma', 'contrasena', 0.00001, 1, 'alexis@gmail.com', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

CREATE TABLE `states` (
  `idState` int(11) NOT NULL,
  `nameState` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `idCountry` varchar(2) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `states`
--

INSERT INTO `states` (`idState`, `nameState`, `idCountry`) VALUES
(1, 'Michoacan', '1'),
(2, 'Texas', '2'),
(3, 'Estado de Mexico', '1');

-- --------------------------------------------------------

--
-- Table structure for table `subcategories`
--

CREATE TABLE `subcategories` (
  `idSubcategory` int(11) NOT NULL,
  `nameSubcategory` varchar(60) COLLATE utf8_spanish_ci NOT NULL,
  `imageSubcategory` varchar(100) COLLATE utf8_spanish_ci DEFAULT 'files/subcategories/defaultc.jpg',
  `idCategory` int(11) NOT NULL,
  `importantSubcategory` tinyint(1) NOT NULL DEFAULT '0',
  `statusSubcategory` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `subcategories`
--

INSERT INTO `subcategories` (`idSubcategory`, `nameSubcategory`, `imageSubcategory`, `idCategory`, `importantSubcategory`, `statusSubcategory`) VALUES
(1, 'Tazas azules', 'files/subcategories/defaultc.jpg', 1, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `sublines`
--

CREATE TABLE `sublines` (
  `idSubline` int(11) NOT NULL,
  `nameSubline` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `idLine` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subsidiaries`
--

CREATE TABLE `subsidiaries` (
  `idSubsidiary` int(11) NOT NULL,
  `nameSubsidiary` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `streetSubsidiary` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `zipcodeSubsidiary` varchar(5) COLLATE utf8_spanish_ci NOT NULL,
  `idClient` int(11) NOT NULL,
  `idCity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subsublines`
--

CREATE TABLE `subsublines` (
  `idSubsubline` int(11) NOT NULL,
  `nameSubsubline` varchar(60) COLLATE utf8_spanish_ci NOT NULL,
  `idLine` int(11) NOT NULL,
  `idSubline` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `supplies`
--

CREATE TABLE `supplies` (
  `idSupply` int(11) NOT NULL,
  `nameSupply` varchar(150) COLLATE utf8_spanish_ci NOT NULL,
  `costSupply` double NOT NULL,
  `quantitySupply` double NOT NULL DEFAULT '1',
  `unitCostSupply` double NOT NULL,
  `statusSupply` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tecnipacks`
--

CREATE TABLE `tecnipacks` (
  `idTecnipack` int(11) NOT NULL,
  `nameTecnipack` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `importantTecnipack` tinyint(1) NOT NULL DEFAULT '0',
  `imageTecnipack` varchar(100) COLLATE utf8_spanish_ci NOT NULL DEFAULT 'files/tecnipacks/defaultt.jpg',
  `enableTecnipack` tinyint(1) NOT NULL DEFAULT '1',
  `statusTecnipack` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `tecnipacks`
--

INSERT INTO `tecnipacks` (`idTecnipack`, `nameTecnipack`, `importantTecnipack`, `imageTecnipack`, `enableTecnipack`, `statusTecnipack`) VALUES
(122, 'Paquete graduación', 0, 'files/tecnipacks/defaultt.jpg', 1, 1),
(123, 'paquete de bodas', 0, 'files/tecnipacks/defaultt.jpg', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tecnipackscost`
--

CREATE TABLE `tecnipackscost` (
  `idTecnipack` int(11) NOT NULL,
  `idProduct` int(11) NOT NULL,
  `quantityTecnipackCost` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `tecnipackscost`
--

INSERT INTO `tecnipackscost` (`idTecnipack`, `idProduct`, `quantityTecnipackCost`) VALUES
(122, 122, 3100),
(123, 123, 7600);

-- --------------------------------------------------------

--
-- Table structure for table `tecnipacksprice`
--

CREATE TABLE `tecnipacksprice` (
  `idTecnipack` int(11) NOT NULL,
  `publicUtilityPrice` double NOT NULL,
  `publicPrice` double NOT NULL,
  `associatedUtilityPrice` double NOT NULL,
  `associatedPrice` double NOT NULL,
  `wholesaleDiscountPrice` double NOT NULL,
  `wholesalePrice` double NOT NULL,
  `wholesaleUtilityPrice` double NOT NULL,
  `distributorDiscountPrice` double NOT NULL,
  `distributorPrice` double NOT NULL,
  `distributorUtilityPrice` double NOT NULL,
  `distinguishedDiscountPrice` double NOT NULL,
  `distinguishedPrice` double NOT NULL,
  `distinguishedUtilityPrice` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `typeclient`
--

CREATE TABLE `typeclient` (
  `idTypeClient` int(11) NOT NULL,
  `nameTypeClient` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `typeclient`
--

INSERT INTO `typeclient` (`idTypeClient`, `nameTypeClient`) VALUES
(1, 'frecuente');

-- --------------------------------------------------------

--
-- Table structure for table `typeusers`
--

CREATE TABLE `typeusers` (
  `idTypeUser` int(11) NOT NULL,
  `typeUser` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `users` tinyint(1) NOT NULL DEFAULT '0',
  `orders` tinyint(1) NOT NULL DEFAULT '0',
  `roles` tinyint(1) NOT NULL DEFAULT '0',
  `reports` tinyint(1) NOT NULL DEFAULT '0',
  `records` tinyint(1) NOT NULL DEFAULT '0',
  `supplies` tinyint(1) NOT NULL DEFAULT '0',
  `products` tinyint(1) NOT NULL DEFAULT '0',
  `configurations` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `idUnit` int(11) NOT NULL,
  `nameUnit` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `units`
--

INSERT INTO `units` (`idUnit`, `nameUnit`) VALUES
(1, 'metros'),
(2, 'centimetros'),
(3, 'metros'),
(4, 'centimetros');

-- --------------------------------------------------------

--
-- Stand-in structure for view `usernames`
-- (See below for the actual view)
--
CREATE TABLE `usernames` (
`id` int(11)
,`username` text
);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `secondlastname` varchar(255) DEFAULT NULL,
  `username` text,
  `about` text,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `isKiosko` enum('active','inactive') DEFAULT 'inactive',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `firstname`, `lastname`, `secondlastname`, `username`, `about`, `email`, `password`, `last_login`, `status`, `isKiosko`, `createdAt`, `updatedAt`) VALUES
(1, 'Ana', 'Chapulli', NULL, NULL, NULL, 'ana@gmail.com', '$2a$08$8VxwzeElYCVSl9l/FVQt7e6InuYvWj43HKO61JbOKWPvp7hvc1ZPe', NULL, 'active', 'inactive', '2019-10-15 01:12:30', '2019-10-15 01:12:30'),
(2, 'Rocio', 'Lopez', NULL, 'chioo', NULL, 'chio@gmail.com', '$2a$08$ELyJQcCKWwgNExQCRLH3U.6OYRdBgSW0MF7TJhVg83q6QeO7HW.Py', NULL, 'active', 'inactive', '2019-10-20 22:27:34', '2019-10-20 22:27:34'),
(3, 'Jorge Luis', 'Ponce', 'Rivera', 'Yorch', NULL, 'gorgeousgeorge0196@gmail.com', '$2a$08$9FkL2aZn55cpkjUHC8DRReSB9t5MGoUebBpGa.RVHcUBCwqXSwIUu', NULL, 'active', 'inactive', '2019-10-31 22:54:37', '2019-10-31 22:54:37');

-- --------------------------------------------------------

--
-- Stand-in structure for view `ventas`
-- (See below for the actual view)
--
CREATE TABLE `ventas` (
`idSelling` int(11)
,`idArticle` int(11)
,`statusOrder` varchar(15)
,`fecha` varchar(10)
,`price` double
,`zipNameSelling` varchar(45)
,`quantity` int(11)
,`street` varchar(45)
,`idProduct` int(11)
,`idCity` int(11)
,`nameProduct` varchar(150)
,`priceProduct` double
,`imageProduct` varchar(100)
,`enableProduct` tinyint(1)
,`featuresProduct` text
,`statusProduct` tinyint(1)
,`idCategory` int(11)
,`nameCategory` varchar(60)
,`idDimension` int(11)
,`heightDimension` double
,`widthDimension` double
,`max` int(11)
,`min` int(11)
,`time` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `productos`
--
DROP TABLE IF EXISTS `productos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `productos`  AS  select `products`.`idProduct` AS `idProduct`,`products`.`nameProduct` AS `nameProduct`,`products`.`price` AS `priceProduct`,`products`.`imageProduct` AS `imageProduct`,`products`.`enableProduct` AS `enableProduct`,`products`.`featuresProduct` AS `featuresProduct`,`products`.`statusProduct` AS `statusProduct`,`categories`.`idCategory` AS `idCategory`,`categories`.`nameCategory` AS `nameCategory`,`dimensions`.`idDimension` AS `idDimension`,`dimensions`.`heightDimension` AS `heightDimension`,`dimensions`.`widthDimension` AS `widthDimension`,`products`.`max` AS `max`,`products`.`min` AS `min`,`products`.`time` AS `time` from ((`products` join `categories` on((`products`.`idCategory` = `categories`.`idCategory`))) join `dimensions` on((`dimensions`.`idDimension` = `products`.`idDimension`))) where (`products`.`statusProduct` = 1) ;

-- --------------------------------------------------------

--
-- Structure for view `usernames`
--
DROP TABLE IF EXISTS `usernames`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `usernames`  AS  select `users`.`id` AS `id`,`users`.`username` AS `username` from `users` ;

-- --------------------------------------------------------

--
-- Structure for view `ventas`
--
DROP TABLE IF EXISTS `ventas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ventas`  AS  select `orders`.`idSelling` AS `idSelling`,`orders`.`idArticle` AS `idArticle`,`orders`.`statusOrder` AS `statusOrder`,date_format(`sellings`.`dateSelling`,'%d-%m-%Y') AS `fecha`,`sellings`.`price` AS `price`,`sellings`.`zipNameSelling` AS `zipNameSelling`,`sellings`.`quantity` AS `quantity`,`sellings`.`street` AS `street`,`productos`.`idProduct` AS `idProduct`,`sellings`.`idCity` AS `idCity`,`productos`.`nameProduct` AS `nameProduct`,`productos`.`priceProduct` AS `priceProduct`,`productos`.`imageProduct` AS `imageProduct`,`productos`.`enableProduct` AS `enableProduct`,`productos`.`featuresProduct` AS `featuresProduct`,`productos`.`statusProduct` AS `statusProduct`,`productos`.`idCategory` AS `idCategory`,`productos`.`nameCategory` AS `nameCategory`,`productos`.`idDimension` AS `idDimension`,`productos`.`heightDimension` AS `heightDimension`,`productos`.`widthDimension` AS `widthDimension`,`productos`.`max` AS `max`,`productos`.`min` AS `min`,`productos`.`time` AS `time` from ((`orders` join `sellings` on((`sellings`.`idSelling` = `orders`.`idSelling`))) join `productos` on((`productos`.`idProduct` = `sellings`.`idProduct`))) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`idBrand`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`idCategory`);

--
-- Indexes for table `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`idCity`),
  ADD KEY `idState` (`idState`);

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`idClient`),
  ADD KEY `idCity` (`idCity`),
  ADD KEY `idTypeClient` (`idTypeClient`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`idCountry`);

--
-- Indexes for table `dimensions`
--
ALTER TABLE `dimensions`
  ADD PRIMARY KEY (`idDimension`);

--
-- Indexes for table `employes`
--
ALTER TABLE `employes`
  ADD PRIMARY KEY (`idEmployee`),
  ADD KEY `idCity` (`idCity`);

--
-- Indexes for table `employesubline`
--
ALTER TABLE `employesubline`
  ADD PRIMARY KEY (`idEmployee`,`idSubsubline`),
  ADD KEY `idSubline` (`idSubline`,`idSubsubline`);

--
-- Indexes for table `kiosko`
--
ALTER TABLE `kiosko`
  ADD PRIMARY KEY (`user`);

--
-- Indexes for table `managerusers`
--
ALTER TABLE `managerusers`
  ADD PRIMARY KEY (`idManagerUser`),
  ADD KEY `idTypeUser` (`idTypeUser`);

--
-- Indexes for table `moldings`
--
ALTER TABLE `moldings`
  ADD PRIMARY KEY (`idMolding`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`idNotification`),
  ADD KEY `idUser` (`idUser`),
  ADD KEY `idCreator` (`idCreator`);

--
-- Indexes for table `offerts`
--
ALTER TABLE `offerts`
  ADD PRIMARY KEY (`idOffer`),
  ADD KEY `idProduct` (`idProduct`),
  ADD KEY `idTecnipack` (`idTecnipack`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`idSelling`,`idArticle`),
  ADD KEY `idEmployee` (`idEmployee`);

--
-- Indexes for table `paymenttypes`
--
ALTER TABLE `paymenttypes`
  ADD PRIMARY KEY (`idPaymentType`);

--
-- Indexes for table `plantillas`
--
ALTER TABLE `plantillas`
  ADD PRIMARY KEY (`id_plantilla`),
  ADD KEY `fk_product` (`fk_product`);

--
-- Indexes for table `prices`
--
ALTER TABLE `prices`
  ADD PRIMARY KEY (`idPrice`),
  ADD KEY `idProduct` (`idProduct`);

--
-- Indexes for table `productlines`
--
ALTER TABLE `productlines`
  ADD PRIMARY KEY (`idLine`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`idProduct`),
  ADD KEY `idCategory` (`idCategory`,`idSubcategory`),
  ADD KEY `idDimension` (`idDimension`),
  ADD KEY `idBrand` (`idBrand`),
  ADD KEY `idSubline` (`idSubline`,`idSubsubline`),
  ADD KEY `idUnit` (`idUnit`);

--
-- Indexes for table `productscost`
--
ALTER TABLE `productscost`
  ADD PRIMARY KEY (`idProduct`,`idSupply`),
  ADD KEY `idSupply` (`idSupply`),
  ADD KEY `idUnit` (`idUnit`);

--
-- Indexes for table `productsprice`
--
ALTER TABLE `productsprice`
  ADD PRIMARY KEY (`idProduct`);

--
-- Indexes for table `providers`
--
ALTER TABLE `providers`
  ADD PRIMARY KEY (`idProvider`),
  ADD KEY `idCity` (`idCity`),
  ADD KEY `idPaymentType` (`idPaymentType`);

--
-- Indexes for table `reinforcements`
--
ALTER TABLE `reinforcements`
  ADD PRIMARY KEY (`idReinforcement`);

--
-- Indexes for table `request`
--
ALTER TABLE `request`
  ADD PRIMARY KEY (`idRequest`),
  ADD KEY `idUser` (`idUser`),
  ADD KEY `idEmployee` (`idEmployee`);

--
-- Indexes for table `sellings`
--
ALTER TABLE `sellings`
  ADD PRIMARY KEY (`idSelling`),
  ADD KEY `idTecnipack` (`idTecnipack`),
  ADD KEY `idPaymentType` (`idPaymentType`),
  ADD KEY `idCity` (`idCity`),
  ADD KEY `idSubsidiary` (`idSubsidiary`),
  ADD KEY `sellings_ibfk_1` (`idUser`),
  ADD KEY `idProduct` (`idProduct`);

--
-- Indexes for table `shop`
--
ALTER TABLE `shop`
  ADD PRIMARY KEY (`idShop`),
  ADD KEY `idUser` (`idUser`),
  ADD KEY `idProduct` (`idProduct`),
  ADD KEY `idTecnipack` (`idTecnipack`);

--
-- Indexes for table `shopusers`
--
ALTER TABLE `shopusers`
  ADD PRIMARY KEY (`idShopUser`);

--
-- Indexes for table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`idState`),
  ADD KEY `idCountry` (`idCountry`);

--
-- Indexes for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD PRIMARY KEY (`idCategory`,`idSubcategory`);

--
-- Indexes for table `sublines`
--
ALTER TABLE `sublines`
  ADD PRIMARY KEY (`idLine`,`idSubline`);

--
-- Indexes for table `subsidiaries`
--
ALTER TABLE `subsidiaries`
  ADD PRIMARY KEY (`idSubsidiary`),
  ADD KEY `idClient` (`idClient`),
  ADD KEY `idCity` (`idCity`);

--
-- Indexes for table `subsublines`
--
ALTER TABLE `subsublines`
  ADD PRIMARY KEY (`idSubline`,`idSubsubline`),
  ADD KEY `idLine` (`idLine`,`idSubline`);

--
-- Indexes for table `supplies`
--
ALTER TABLE `supplies`
  ADD PRIMARY KEY (`idSupply`);

--
-- Indexes for table `tecnipacks`
--
ALTER TABLE `tecnipacks`
  ADD PRIMARY KEY (`idTecnipack`);

--
-- Indexes for table `tecnipackscost`
--
ALTER TABLE `tecnipackscost`
  ADD PRIMARY KEY (`idTecnipack`,`idProduct`),
  ADD KEY `idProduct` (`idProduct`);

--
-- Indexes for table `tecnipacksprice`
--
ALTER TABLE `tecnipacksprice`
  ADD PRIMARY KEY (`idTecnipack`);

--
-- Indexes for table `typeclient`
--
ALTER TABLE `typeclient`
  ADD PRIMARY KEY (`idTypeClient`);

--
-- Indexes for table `typeusers`
--
ALTER TABLE `typeusers`
  ADD PRIMARY KEY (`idTypeUser`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`idUnit`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `brands`
--
ALTER TABLE `brands`
  MODIFY `idBrand` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `dimensions`
--
ALTER TABLE `dimensions`
  MODIFY `idDimension` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `managerusers`
--
ALTER TABLE `managerusers`
  MODIFY `idManagerUser` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `idNotification` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `offerts`
--
ALTER TABLE `offerts`
  MODIFY `idOffer` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `paymenttypes`
--
ALTER TABLE `paymenttypes`
  MODIFY `idPaymentType` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `plantillas`
--
ALTER TABLE `plantillas`
  MODIFY `id_plantilla` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `prices`
--
ALTER TABLE `prices`
  MODIFY `idPrice` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `productlines`
--
ALTER TABLE `productlines`
  MODIFY `idLine` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `idProduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `reinforcements`
--
ALTER TABLE `reinforcements`
  MODIFY `idReinforcement` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `request`
--
ALTER TABLE `request`
  MODIFY `idRequest` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sellings`
--
ALTER TABLE `sellings`
  MODIFY `idSelling` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `shop`
--
ALTER TABLE `shop`
  MODIFY `idShop` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shopusers`
--
ALTER TABLE `shopusers`
  MODIFY `idShopUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `subsidiaries`
--
ALTER TABLE `subsidiaries`
  MODIFY `idSubsidiary` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `typeclient`
--
ALTER TABLE `typeclient`
  MODIFY `idTypeClient` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `typeusers`
--
ALTER TABLE `typeusers`
  MODIFY `idTypeUser` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `units`
--
ALTER TABLE `units`
  MODIFY `idUnit` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cities`
--
ALTER TABLE `cities`
  ADD CONSTRAINT `cities_ibfk_1` FOREIGN KEY (`idState`) REFERENCES `states` (`idState`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `clients_ibfk_1` FOREIGN KEY (`idClient`) REFERENCES `shopusers` (`idShopUser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `clients_ibfk_2` FOREIGN KEY (`idCity`) REFERENCES `cities` (`idCity`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `clients_ibfk_3` FOREIGN KEY (`idTypeClient`) REFERENCES `typeclient` (`idTypeClient`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `employes`
--
ALTER TABLE `employes`
  ADD CONSTRAINT `employes_ibfk_1` FOREIGN KEY (`idEmployee`) REFERENCES `managerusers` (`idManagerUser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `employes_ibfk_2` FOREIGN KEY (`idCity`) REFERENCES `cities` (`idCity`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `employesubline`
--
ALTER TABLE `employesubline`
  ADD CONSTRAINT `employesubline_ibfk_1` FOREIGN KEY (`idSubline`,`idSubsubline`) REFERENCES `subsublines` (`idSubline`, `idSubsubline`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `managerusers`
--
ALTER TABLE `managerusers`
  ADD CONSTRAINT `managerusers_ibfk_1` FOREIGN KEY (`idTypeUser`) REFERENCES `typeusers` (`idTypeUser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `managerusers` (`idManagerUser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`idCreator`) REFERENCES `managerusers` (`idManagerUser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `offerts`
--
ALTER TABLE `offerts`
  ADD CONSTRAINT `offerts_ibfk_2` FOREIGN KEY (`idTecnipack`) REFERENCES `tecnipacks` (`idTecnipack`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`idSelling`) REFERENCES `sellings` (`idSelling`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`idEmployee`) REFERENCES `employes` (`idEmployee`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`idCategory`) REFERENCES `categories` (`idCategory`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`idDimension`) REFERENCES `dimensions` (`idDimension`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `products_ibfk_3` FOREIGN KEY (`idBrand`) REFERENCES `brands` (`idBrand`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `products_ibfk_4` FOREIGN KEY (`idSubline`,`idSubsubline`) REFERENCES `subsublines` (`idSubline`, `idSubsubline`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `products_ibfk_5` FOREIGN KEY (`idUnit`) REFERENCES `units` (`idUnit`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `productscost`
--
ALTER TABLE `productscost`
  ADD CONSTRAINT `productscost_ibfk_2` FOREIGN KEY (`idSupply`) REFERENCES `supplies` (`idSupply`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `productscost_ibfk_3` FOREIGN KEY (`idUnit`) REFERENCES `units` (`idUnit`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `productscost_ibfk_4` FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProduct`);

--
-- Constraints for table `productsprice`
--
ALTER TABLE `productsprice`
  ADD CONSTRAINT `productsprice_ibfk_1` FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProduct`);

--
-- Constraints for table `providers`
--
ALTER TABLE `providers`
  ADD CONSTRAINT `providers_ibfk_1` FOREIGN KEY (`idCity`) REFERENCES `cities` (`idCity`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `providers_ibfk_2` FOREIGN KEY (`idPaymentType`) REFERENCES `paymenttypes` (`idPaymentType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `request`
--
ALTER TABLE `request`
  ADD CONSTRAINT `request_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `shopusers` (`idShopUser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `request_ibfk_2` FOREIGN KEY (`idEmployee`) REFERENCES `employes` (`idEmployee`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `sellings`
--
ALTER TABLE `sellings`
  ADD CONSTRAINT `sellings_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `sellings_ibfk_3` FOREIGN KEY (`idTecnipack`) REFERENCES `tecnipacks` (`idTecnipack`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `sellings_ibfk_4` FOREIGN KEY (`idPaymentType`) REFERENCES `paymenttypes` (`idPaymentType`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `sellings_ibfk_5` FOREIGN KEY (`idCity`) REFERENCES `cities` (`idCity`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `sellings_ibfk_6` FOREIGN KEY (`idSubsidiary`) REFERENCES `subsidiaries` (`idSubsidiary`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `sellings_ibfk_7` FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProduct`);

--
-- Constraints for table `shop`
--
ALTER TABLE `shop`
  ADD CONSTRAINT `shop_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `shopusers` (`idShopUser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `shop_ibfk_3` FOREIGN KEY (`idTecnipack`) REFERENCES `tecnipacks` (`idTecnipack`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `states`
--
ALTER TABLE `states`
  ADD CONSTRAINT `states_ibfk_1` FOREIGN KEY (`idCountry`) REFERENCES `countries` (`idCountry`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD CONSTRAINT `subcategories_ibfk_1` FOREIGN KEY (`idCategory`) REFERENCES `categories` (`idCategory`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `sublines`
--
ALTER TABLE `sublines`
  ADD CONSTRAINT `sublines_ibfk_1` FOREIGN KEY (`idLine`) REFERENCES `productlines` (`idLine`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `subsidiaries`
--
ALTER TABLE `subsidiaries`
  ADD CONSTRAINT `subsidiaries_ibfk_1` FOREIGN KEY (`idClient`) REFERENCES `clients` (`idClient`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `subsidiaries_ibfk_2` FOREIGN KEY (`idCity`) REFERENCES `cities` (`idCity`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `subsublines`
--
ALTER TABLE `subsublines`
  ADD CONSTRAINT `subsublines_ibfk_1` FOREIGN KEY (`idLine`,`idSubline`) REFERENCES `sublines` (`idLine`, `idSubline`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `tecnipackscost`
--
ALTER TABLE `tecnipackscost`
  ADD CONSTRAINT `tecnipackscost_ibfk_1` FOREIGN KEY (`idTecnipack`) REFERENCES `tecnipacks` (`idTecnipack`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `tecnipacksprice`
--
ALTER TABLE `tecnipacksprice`
  ADD CONSTRAINT `tecnipacksprice_ibfk_1` FOREIGN KEY (`idTecnipack`) REFERENCES `tecnipacks` (`idTecnipack`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 26-10-2019 a las 04:44:03
-- Versión del servidor: 10.1.21-MariaDB
-- Versión de PHP: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `uprint`
--

DELIMITER $$
--
-- Procedimientos
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
-- Estructura de tabla para la tabla `brands`
--

CREATE TABLE `brands` (
  `idBrand` int(11) NOT NULL,
  `nameBrand` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `brands`
--

INSERT INTO `brands` (`idBrand`, `nameBrand`) VALUES
(1, 'brand 1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categories`
--

CREATE TABLE `categories` (
  `idCategory` int(11) NOT NULL,
  `nameCategory` varchar(60) COLLATE utf8_spanish_ci NOT NULL,
  `imageCategory` varchar(100) COLLATE utf8_spanish_ci DEFAULT 'files/categories/defaultc.jpg',
  `statusCategory` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `categories`
--

INSERT INTO `categories` (`idCategory`, `nameCategory`, `imageCategory`, `statusCategory`) VALUES
(0, 'Tazas', 'files/categories/defaultc.jpg', 1),
(1, 'Foto Regalos', 'files/categories/defaultc.jpg', 1),
(2, 'Foto libros', 'ruta/carpeta', 1),
(3, 'Foto Marcos', 'files/categories/defaultc.jpg', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cities`
--

CREATE TABLE `cities` (
  `idCity` int(11) NOT NULL,
  `numberCity` int(11) NOT NULL,
  `nameCity` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `idState` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clients`
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `countries`
--

CREATE TABLE `countries` (
  `idCountry` varchar(2) COLLATE utf8_spanish_ci NOT NULL,
  `nameCountry` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dimensions`
--

CREATE TABLE `dimensions` (
  `idDimension` int(11) NOT NULL,
  `widthDimension` double NOT NULL,
  `heightDimension` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `dimensions`
--

INSERT INTO `dimensions` (`idDimension`, `widthDimension`, `heightDimension`) VALUES
(1, 25, 15),
(2, 15, 15);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `employes`
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
-- Estructura de tabla para la tabla `employesubline`
--

CREATE TABLE `employesubline` (
  `idEmployee` int(11) NOT NULL,
  `idSubsubline` int(11) NOT NULL,
  `idSubline` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `info_ventas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `info_ventas` (
`idSelling` int(11)
,`cantidad` bigint(21)
,`statusorder` varchar(15)
,`dateSelling` timestamp
,`price` double
,`zipNameSelling` varchar(45)
,`quantity` int(11)
,`street` varchar(45)
,`username` text
,`nameProduct` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `kiosko`
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `managerusers`
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
-- Estructura de tabla para la tabla `moldings`
--

CREATE TABLE `moldings` (
  `idMolding` varchar(4) COLLATE utf8_spanish_ci NOT NULL,
  `widthMolding` double NOT NULL,
  `wasteMolding` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `nameproducts`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `nameproducts` (
`idProduct` int(11)
,`nameProduct` varchar(150)
,`imageProduct` varchar(100)
,`nameCategory` varchar(60)
,`nameSubcategory` varchar(60)
,`widthDimension` double
,`heightDimension` double
,`nameUnit` varchar(45)
,`max` int(11)
,`min` int(11)
,`time` int(11)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notifications`
--

CREATE TABLE `notifications` (
  `idNotification` int(11) NOT NULL,
  `idUser` int(11) NOT NULL,
  `idCreator` int(11) NOT NULL,
  `messageNotification` varchar(150) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `offerts`
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
-- Estructura de tabla para la tabla `orders`
--

CREATE TABLE `orders` (
  `idSelling` int(11) NOT NULL,
  `idArticle` int(11) NOT NULL,
  `idEmployee` int(11) DEFAULT NULL,
  `comment` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `statusOrder` varchar(15) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paymenttypes`
--

CREATE TABLE `paymenttypes` (
  `idPaymentType` int(11) NOT NULL,
  `namePaymentType` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plantillas`
--

CREATE TABLE `plantillas` (
  `id_plantilla` int(11) NOT NULL,
  `fk_product` int(11) NOT NULL,
  `route_file` varchar(100) NOT NULL,
  `atribute` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prices`
--

CREATE TABLE `prices` (
  `idPrice` int(11) NOT NULL,
  `idProduct` int(11) NOT NULL,
  `price` double NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `produccion`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `produccion` (
`idVenta` int(11)
,`idArticulo` int(11)
,`fecha` varchar(10)
,`precio` double
,`cp` varchar(45)
,`cant` int(11)
,`calle` varchar(45)
,`usuario` text
,`product` varchar(150)
,`imagen` varchar(100)
,`categor` varchar(60)
,`subcategor` varchar(60)
,`ancho` double
,`alto` double
,`unidad` varchar(45)
,`stat` varchar(15)
,`max` int(11)
,`min` int(11)
,`time` int(11)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productlines`
--

CREATE TABLE `productlines` (
  `idLine` int(11) NOT NULL,
  `nameLine` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `productos`
-- (Véase abajo para la vista actual)
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
-- Estructura de tabla para la tabla `products`
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productscost`
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
-- Estructura de tabla para la tabla `productsprice`
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
-- Estructura de tabla para la tabla `providers`
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reinforcements`
--

CREATE TABLE `reinforcements` (
  `idReinforcement` int(11) NOT NULL,
  `nameReinforcement` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `quantityReinforcement` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `request`
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
-- Estructura de tabla para la tabla `sellings`
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shop`
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
-- Estructura de tabla para la tabla `shopusers`
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `states`
--

CREATE TABLE `states` (
  `idState` int(11) NOT NULL,
  `nameState` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `idCountry` varchar(2) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subcategories`
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
-- Volcado de datos para la tabla `subcategories`
--

INSERT INTO `subcategories` (`idSubcategory`, `nameSubcategory`, `imageSubcategory`, `idCategory`, `importantSubcategory`, `statusSubcategory`) VALUES
(1, 'Tazas azules', 'files/subcategories/defaultc.jpg', 1, 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sublines`
--

CREATE TABLE `sublines` (
  `idSubline` int(11) NOT NULL,
  `nameSubline` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `idLine` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subsidiaries`
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
-- Estructura de tabla para la tabla `subsublines`
--

CREATE TABLE `subsublines` (
  `idSubsubline` int(11) NOT NULL,
  `nameSubsubline` varchar(60) COLLATE utf8_spanish_ci NOT NULL,
  `idLine` int(11) NOT NULL,
  `idSubline` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `supplies`
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
-- Estructura de tabla para la tabla `tecnipacks`
--

CREATE TABLE `tecnipacks` (
  `idTecnipack` int(11) NOT NULL,
  `nameTecnipack` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `importantTecnipack` tinyint(1) NOT NULL DEFAULT '0',
  `imageTecnipack` varchar(100) COLLATE utf8_spanish_ci NOT NULL DEFAULT 'files/tecnipacks/defaultt.jpg',
  `enableTecnipack` tinyint(1) NOT NULL DEFAULT '1',
  `statusTecnipack` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tecnipackscost`
--

CREATE TABLE `tecnipackscost` (
  `idTecnipack` int(11) NOT NULL,
  `idProduct` int(11) NOT NULL,
  `quantityTecnipackCost` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tecnipacksprice`
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
-- Estructura de tabla para la tabla `typeclient`
--

CREATE TABLE `typeclient` (
  `idTypeClient` int(11) NOT NULL,
  `nameTypeClient` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `typeusers`
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
-- Estructura de tabla para la tabla `units`
--

CREATE TABLE `units` (
  `idUnit` int(11) NOT NULL,
  `nameUnit` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `units`
--

INSERT INTO `units` (`idUnit`, `nameUnit`) VALUES
(1, 'metros'),
(2, 'centimetros'),
(3, 'metros'),
(4, 'centimetros');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `usernames`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `usernames` (
`id` int(11)
,`username` text
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
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
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `firstname`, `lastname`, `secondlastname`, `username`, `about`, `email`, `password`, `last_login`, `status`, `isKiosko`, `createdAt`, `updatedAt`) VALUES
(1, 'Ana', 'Chapulli', NULL, NULL, NULL, 'ana@gmail.com', '$2a$08$8VxwzeElYCVSl9l/FVQt7e6InuYvWj43HKO61JbOKWPvp7hvc1ZPe', NULL, 'active', 'inactive', '2019-10-15 01:12:30', '2019-10-15 01:12:30'),
(2, 'Rocio', 'Lopez', NULL, 'chioo', NULL, 'chio@gmail.com', '$2a$08$ELyJQcCKWwgNExQCRLH3U.6OYRdBgSW0MF7TJhVg83q6QeO7HW.Py', NULL, 'active', 'inactive', '2019-10-20 22:27:34', '2019-10-20 22:27:34');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `us_ventas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `us_ventas` (
`idSelling` int(11)
,`idArticle` int(11)
,`dateSelling` timestamp
,`price` double
,`zipNameSelling` varchar(45)
,`quantity` int(11)
,`street` varchar(45)
,`username` text
,`nameProduct` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `ventas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `ventas` (
`idSelling` int(11)
,`idArticle` int(11)
,`dateSelling` timestamp
,`price` double
,`zipNameSelling` varchar(45)
,`quantity` int(11)
,`street` varchar(45)
,`idUser` int(11)
,`nameProduct` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `info_ventas`
--
DROP TABLE IF EXISTS `info_ventas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `info_ventas`  AS  select `orders`.`idSelling` AS `idSelling`,count(`orders`.`idArticle`) AS `cantidad`,`orders`.`statusOrder` AS `statusorder`,`us_ventas`.`dateSelling` AS `dateSelling`,`us_ventas`.`price` AS `price`,`us_ventas`.`zipNameSelling` AS `zipNameSelling`,`us_ventas`.`quantity` AS `quantity`,`us_ventas`.`street` AS `street`,`us_ventas`.`username` AS `username`,`us_ventas`.`nameProduct` AS `nameProduct` from (`orders` join `us_ventas`) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `nameproducts`
--
DROP TABLE IF EXISTS `nameproducts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `nameproducts`  AS  select `products`.`idProduct` AS `idProduct`,`products`.`nameProduct` AS `nameProduct`,`products`.`imageProduct` AS `imageProduct`,`categories`.`nameCategory` AS `nameCategory`,`subcategories`.`nameSubcategory` AS `nameSubcategory`,`dimensions`.`widthDimension` AS `widthDimension`,`dimensions`.`heightDimension` AS `heightDimension`,`units`.`nameUnit` AS `nameUnit`,`products`.`max` AS `max`,`products`.`min` AS `min`,`products`.`time` AS `time` from ((((`products` join `categories` on((`products`.`idCategory` = `categories`.`idCategory`))) join `subcategories` on((`products`.`idSubcategory` = `subcategories`.`idSubcategory`))) join `dimensions` on((`dimensions`.`idDimension` = `products`.`idDimension`))) join `units` on((`products`.`idUnit` = `units`.`idUnit`))) where (`products`.`statusProduct` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `produccion`
--
DROP TABLE IF EXISTS `produccion`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `produccion`  AS  select `sellings`.`idSelling` AS `idVenta`,`sellings`.`idArticle` AS `idArticulo`,date_format(`sellings`.`dateSelling`,'%d-%m-%Y') AS `fecha`,`sellings`.`price` AS `precio`,`sellings`.`zipNameSelling` AS `cp`,`sellings`.`quantity` AS `cant`,`sellings`.`street` AS `calle`,`usernames`.`username` AS `usuario`,`nameproducts`.`nameProduct` AS `product`,`nameproducts`.`imageProduct` AS `imagen`,`nameproducts`.`nameCategory` AS `categor`,`nameproducts`.`nameSubcategory` AS `subcategor`,`nameproducts`.`widthDimension` AS `ancho`,`nameproducts`.`heightDimension` AS `alto`,`nameproducts`.`nameUnit` AS `unidad`,`orders`.`statusOrder` AS `stat`,`nameproducts`.`max` AS `max`,`nameproducts`.`min` AS `min`,`nameproducts`.`time` AS `time` from (((`sellings` join `usernames` on((`sellings`.`idUser` = `usernames`.`id`))) join `nameproducts` on((`nameproducts`.`idProduct` = `sellings`.`idProduct`))) join `orders` on(((`orders`.`idSelling` = `sellings`.`idSelling`) and (`orders`.`idArticle` = `sellings`.`idArticle`)))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `productos`
--
DROP TABLE IF EXISTS `productos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `productos`  AS  select `products`.`idProduct` AS `idProduct`,`products`.`nameProduct` AS `nameProduct`,`products`.`price` AS `priceProduct`,`products`.`imageProduct` AS `imageProduct`,`products`.`enableProduct` AS `enableProduct`,`products`.`featuresProduct` AS `featuresProduct`,`products`.`statusProduct` AS `statusProduct`,`categories`.`idCategory` AS `idCategory`,`categories`.`nameCategory` AS `nameCategory`,`dimensions`.`idDimension` AS `idDimension`,`dimensions`.`heightDimension` AS `heightDimension`,`dimensions`.`widthDimension` AS `widthDimension`,`products`.`max` AS `max`,`products`.`min` AS `min`,`products`.`time` AS `time` from ((`products` join `categories` on((`products`.`idCategory` = `categories`.`idCategory`))) join `dimensions` on((`dimensions`.`idDimension` = `products`.`idDimension`))) where (`products`.`statusProduct` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `usernames`
--
DROP TABLE IF EXISTS `usernames`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `usernames`  AS  select `users`.`id` AS `id`,`users`.`username` AS `username` from `users` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `us_ventas`
--
DROP TABLE IF EXISTS `us_ventas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `us_ventas`  AS  select `ventas`.`idSelling` AS `idSelling`,`ventas`.`idArticle` AS `idArticle`,`ventas`.`dateSelling` AS `dateSelling`,`ventas`.`price` AS `price`,`ventas`.`zipNameSelling` AS `zipNameSelling`,`ventas`.`quantity` AS `quantity`,`ventas`.`street` AS `street`,`usernames`.`username` AS `username`,`ventas`.`nameProduct` AS `nameProduct` from (`ventas` join `usernames` on((`ventas`.`idUser` = `usernames`.`id`))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `ventas`
--
DROP TABLE IF EXISTS `ventas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ventas`  AS  select `sellings`.`idSelling` AS `idSelling`,`sellings`.`idArticle` AS `idArticle`,`sellings`.`dateSelling` AS `dateSelling`,`sellings`.`price` AS `price`,`sellings`.`zipNameSelling` AS `zipNameSelling`,`sellings`.`quantity` AS `quantity`,`sellings`.`street` AS `street`,`sellings`.`idUser` AS `idUser`,`nameproducts`.`nameProduct` AS `nameProduct` from (`sellings` join `nameproducts` on((`sellings`.`idProduct` = `nameproducts`.`idProduct`))) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`idBrand`);

--
-- Indices de la tabla `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`idCategory`);

--
-- Indices de la tabla `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`idCity`),
  ADD KEY `idState` (`idState`);

--
-- Indices de la tabla `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`idClient`),
  ADD KEY `idCity` (`idCity`),
  ADD KEY `idTypeClient` (`idTypeClient`);

--
-- Indices de la tabla `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`idCountry`);

--
-- Indices de la tabla `dimensions`
--
ALTER TABLE `dimensions`
  ADD PRIMARY KEY (`idDimension`);

--
-- Indices de la tabla `employes`
--
ALTER TABLE `employes`
  ADD PRIMARY KEY (`idEmployee`),
  ADD KEY `idCity` (`idCity`);

--
-- Indices de la tabla `employesubline`
--
ALTER TABLE `employesubline`
  ADD PRIMARY KEY (`idEmployee`,`idSubsubline`),
  ADD KEY `idSubline` (`idSubline`,`idSubsubline`);

--
-- Indices de la tabla `kiosko`
--
ALTER TABLE `kiosko`
  ADD PRIMARY KEY (`user`);

--
-- Indices de la tabla `managerusers`
--
ALTER TABLE `managerusers`
  ADD PRIMARY KEY (`idManagerUser`),
  ADD KEY `idTypeUser` (`idTypeUser`);

--
-- Indices de la tabla `moldings`
--
ALTER TABLE `moldings`
  ADD PRIMARY KEY (`idMolding`);

--
-- Indices de la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`idNotification`),
  ADD KEY `idUser` (`idUser`),
  ADD KEY `idCreator` (`idCreator`);

--
-- Indices de la tabla `offerts`
--
ALTER TABLE `offerts`
  ADD PRIMARY KEY (`idOffer`),
  ADD KEY `idProduct` (`idProduct`),
  ADD KEY `idTecnipack` (`idTecnipack`);

--
-- Indices de la tabla `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`idSelling`,`idArticle`),
  ADD KEY `idEmployee` (`idEmployee`);

--
-- Indices de la tabla `paymenttypes`
--
ALTER TABLE `paymenttypes`
  ADD PRIMARY KEY (`idPaymentType`);

--
-- Indices de la tabla `plantillas`
--
ALTER TABLE `plantillas`
  ADD PRIMARY KEY (`id_plantilla`),
  ADD KEY `fk_product` (`fk_product`);

--
-- Indices de la tabla `prices`
--
ALTER TABLE `prices`
  ADD PRIMARY KEY (`idPrice`),
  ADD KEY `idProduct` (`idProduct`);

--
-- Indices de la tabla `productlines`
--
ALTER TABLE `productlines`
  ADD PRIMARY KEY (`idLine`);

--
-- Indices de la tabla `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`idProduct`),
  ADD KEY `idCategory` (`idCategory`,`idSubcategory`),
  ADD KEY `idDimension` (`idDimension`),
  ADD KEY `idBrand` (`idBrand`),
  ADD KEY `idSubline` (`idSubline`,`idSubsubline`),
  ADD KEY `idUnit` (`idUnit`);

--
-- Indices de la tabla `productscost`
--
ALTER TABLE `productscost`
  ADD PRIMARY KEY (`idProduct`,`idSupply`),
  ADD KEY `idSupply` (`idSupply`),
  ADD KEY `idUnit` (`idUnit`);

--
-- Indices de la tabla `productsprice`
--
ALTER TABLE `productsprice`
  ADD PRIMARY KEY (`idProduct`);

--
-- Indices de la tabla `providers`
--
ALTER TABLE `providers`
  ADD PRIMARY KEY (`idProvider`),
  ADD KEY `idCity` (`idCity`),
  ADD KEY `idPaymentType` (`idPaymentType`);

--
-- Indices de la tabla `reinforcements`
--
ALTER TABLE `reinforcements`
  ADD PRIMARY KEY (`idReinforcement`);

--
-- Indices de la tabla `request`
--
ALTER TABLE `request`
  ADD PRIMARY KEY (`idRequest`),
  ADD KEY `idUser` (`idUser`),
  ADD KEY `idEmployee` (`idEmployee`);

--
-- Indices de la tabla `sellings`
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
-- Indices de la tabla `shop`
--
ALTER TABLE `shop`
  ADD PRIMARY KEY (`idShop`),
  ADD KEY `idUser` (`idUser`),
  ADD KEY `idProduct` (`idProduct`),
  ADD KEY `idTecnipack` (`idTecnipack`);

--
-- Indices de la tabla `shopusers`
--
ALTER TABLE `shopusers`
  ADD PRIMARY KEY (`idShopUser`);

--
-- Indices de la tabla `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`idState`),
  ADD KEY `idCountry` (`idCountry`);

--
-- Indices de la tabla `subcategories`
--
ALTER TABLE `subcategories`
  ADD PRIMARY KEY (`idCategory`,`idSubcategory`);

--
-- Indices de la tabla `sublines`
--
ALTER TABLE `sublines`
  ADD PRIMARY KEY (`idLine`,`idSubline`);

--
-- Indices de la tabla `subsidiaries`
--
ALTER TABLE `subsidiaries`
  ADD PRIMARY KEY (`idSubsidiary`),
  ADD KEY `idClient` (`idClient`),
  ADD KEY `idCity` (`idCity`);

--
-- Indices de la tabla `subsublines`
--
ALTER TABLE `subsublines`
  ADD PRIMARY KEY (`idSubline`,`idSubsubline`),
  ADD KEY `idLine` (`idLine`,`idSubline`);

--
-- Indices de la tabla `supplies`
--
ALTER TABLE `supplies`
  ADD PRIMARY KEY (`idSupply`);

--
-- Indices de la tabla `tecnipacks`
--
ALTER TABLE `tecnipacks`
  ADD PRIMARY KEY (`idTecnipack`);

--
-- Indices de la tabla `tecnipackscost`
--
ALTER TABLE `tecnipackscost`
  ADD PRIMARY KEY (`idTecnipack`,`idProduct`),
  ADD KEY `idProduct` (`idProduct`);

--
-- Indices de la tabla `tecnipacksprice`
--
ALTER TABLE `tecnipacksprice`
  ADD PRIMARY KEY (`idTecnipack`);

--
-- Indices de la tabla `typeclient`
--
ALTER TABLE `typeclient`
  ADD PRIMARY KEY (`idTypeClient`);

--
-- Indices de la tabla `typeusers`
--
ALTER TABLE `typeusers`
  ADD PRIMARY KEY (`idTypeUser`);

--
-- Indices de la tabla `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`idUnit`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `brands`
--
ALTER TABLE `brands`
  MODIFY `idBrand` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `dimensions`
--
ALTER TABLE `dimensions`
  MODIFY `idDimension` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `managerusers`
--
ALTER TABLE `managerusers`
  MODIFY `idManagerUser` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notifications`
--
ALTER TABLE `notifications`
  MODIFY `idNotification` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `offerts`
--
ALTER TABLE `offerts`
  MODIFY `idOffer` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `paymenttypes`
--
ALTER TABLE `paymenttypes`
  MODIFY `idPaymentType` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `plantillas`
--
ALTER TABLE `plantillas`
  MODIFY `id_plantilla` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `prices`
--
ALTER TABLE `prices`
  MODIFY `idPrice` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productlines`
--
ALTER TABLE `productlines`
  MODIFY `idLine` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `products`
--
ALTER TABLE `products`
  MODIFY `idProduct` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reinforcements`
--
ALTER TABLE `reinforcements`
  MODIFY `idReinforcement` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `request`
--
ALTER TABLE `request`
  MODIFY `idRequest` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sellings`
--
ALTER TABLE `sellings`
  MODIFY `idSelling` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `shop`
--
ALTER TABLE `shop`
  MODIFY `idShop` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `shopusers`
--
ALTER TABLE `shopusers`
  MODIFY `idShopUser` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `subsidiaries`
--
ALTER TABLE `subsidiaries`
  MODIFY `idSubsidiary` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `typeclient`
--
ALTER TABLE `typeclient`
  MODIFY `idTypeClient` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `typeusers`
--
ALTER TABLE `typeusers`
  MODIFY `idTypeUser` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `units`
--
ALTER TABLE `units`
  MODIFY `idUnit` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cities`
--
ALTER TABLE `cities`
  ADD CONSTRAINT `cities_ibfk_1` FOREIGN KEY (`idState`) REFERENCES `states` (`idState`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `clients_ibfk_1` FOREIGN KEY (`idClient`) REFERENCES `shopusers` (`idShopUser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `clients_ibfk_2` FOREIGN KEY (`idCity`) REFERENCES `cities` (`idCity`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `clients_ibfk_3` FOREIGN KEY (`idTypeClient`) REFERENCES `typeclient` (`idTypeClient`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `employes`
--
ALTER TABLE `employes`
  ADD CONSTRAINT `employes_ibfk_1` FOREIGN KEY (`idEmployee`) REFERENCES `managerusers` (`idManagerUser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `employes_ibfk_2` FOREIGN KEY (`idCity`) REFERENCES `cities` (`idCity`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `employesubline`
--
ALTER TABLE `employesubline`
  ADD CONSTRAINT `employesubline_ibfk_1` FOREIGN KEY (`idSubline`,`idSubsubline`) REFERENCES `subsublines` (`idSubline`, `idSubsubline`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `managerusers`
--
ALTER TABLE `managerusers`
  ADD CONSTRAINT `managerusers_ibfk_1` FOREIGN KEY (`idTypeUser`) REFERENCES `typeusers` (`idTypeUser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `managerusers` (`idManagerUser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`idCreator`) REFERENCES `managerusers` (`idManagerUser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `offerts`
--
ALTER TABLE `offerts`
  ADD CONSTRAINT `offerts_ibfk_2` FOREIGN KEY (`idTecnipack`) REFERENCES `tecnipacks` (`idTecnipack`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`idSelling`) REFERENCES `sellings` (`idSelling`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`idEmployee`) REFERENCES `employes` (`idEmployee`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`idCategory`) REFERENCES `categories` (`idCategory`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`idDimension`) REFERENCES `dimensions` (`idDimension`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `products_ibfk_3` FOREIGN KEY (`idBrand`) REFERENCES `brands` (`idBrand`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `products_ibfk_4` FOREIGN KEY (`idSubline`,`idSubsubline`) REFERENCES `subsublines` (`idSubline`, `idSubsubline`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `products_ibfk_5` FOREIGN KEY (`idUnit`) REFERENCES `units` (`idUnit`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `productscost`
--
ALTER TABLE `productscost`
  ADD CONSTRAINT `productscost_ibfk_2` FOREIGN KEY (`idSupply`) REFERENCES `supplies` (`idSupply`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `productscost_ibfk_3` FOREIGN KEY (`idUnit`) REFERENCES `units` (`idUnit`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `productscost_ibfk_4` FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProduct`);

--
-- Filtros para la tabla `productsprice`
--
ALTER TABLE `productsprice`
  ADD CONSTRAINT `productsprice_ibfk_1` FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProduct`);

--
-- Filtros para la tabla `providers`
--
ALTER TABLE `providers`
  ADD CONSTRAINT `providers_ibfk_1` FOREIGN KEY (`idCity`) REFERENCES `cities` (`idCity`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `providers_ibfk_2` FOREIGN KEY (`idPaymentType`) REFERENCES `paymenttypes` (`idPaymentType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `request`
--
ALTER TABLE `request`
  ADD CONSTRAINT `request_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `shopusers` (`idShopUser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `request_ibfk_2` FOREIGN KEY (`idEmployee`) REFERENCES `employes` (`idEmployee`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `sellings`
--
ALTER TABLE `sellings`
  ADD CONSTRAINT `sellings_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `sellings_ibfk_3` FOREIGN KEY (`idTecnipack`) REFERENCES `tecnipacks` (`idTecnipack`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `sellings_ibfk_4` FOREIGN KEY (`idPaymentType`) REFERENCES `paymenttypes` (`idPaymentType`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `sellings_ibfk_5` FOREIGN KEY (`idCity`) REFERENCES `cities` (`idCity`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `sellings_ibfk_6` FOREIGN KEY (`idSubsidiary`) REFERENCES `subsidiaries` (`idSubsidiary`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `sellings_ibfk_7` FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProduct`);

--
-- Filtros para la tabla `shop`
--
ALTER TABLE `shop`
  ADD CONSTRAINT `shop_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `shopusers` (`idShopUser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `shop_ibfk_3` FOREIGN KEY (`idTecnipack`) REFERENCES `tecnipacks` (`idTecnipack`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `states`
--
ALTER TABLE `states`
  ADD CONSTRAINT `states_ibfk_1` FOREIGN KEY (`idCountry`) REFERENCES `countries` (`idCountry`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `subcategories`
--
ALTER TABLE `subcategories`
  ADD CONSTRAINT `subcategories_ibfk_1` FOREIGN KEY (`idCategory`) REFERENCES `categories` (`idCategory`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `sublines`
--
ALTER TABLE `sublines`
  ADD CONSTRAINT `sublines_ibfk_1` FOREIGN KEY (`idLine`) REFERENCES `productlines` (`idLine`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `subsidiaries`
--
ALTER TABLE `subsidiaries`
  ADD CONSTRAINT `subsidiaries_ibfk_1` FOREIGN KEY (`idClient`) REFERENCES `clients` (`idClient`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `subsidiaries_ibfk_2` FOREIGN KEY (`idCity`) REFERENCES `cities` (`idCity`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `subsublines`
--
ALTER TABLE `subsublines`
  ADD CONSTRAINT `subsublines_ibfk_1` FOREIGN KEY (`idLine`,`idSubline`) REFERENCES `sublines` (`idLine`, `idSubline`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tecnipackscost`
--
ALTER TABLE `tecnipackscost`
  ADD CONSTRAINT `tecnipackscost_ibfk_1` FOREIGN KEY (`idTecnipack`) REFERENCES `tecnipacks` (`idTecnipack`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tecnipacksprice`
--
ALTER TABLE `tecnipacksprice`
  ADD CONSTRAINT `tecnipacksprice_ibfk_1` FOREIGN KEY (`idTecnipack`) REFERENCES `tecnipacks` (`idTecnipack`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

SET FOREIGN_KEY_CHECKS = 0;

USE `mysql` ;

-- -----------------------------------------------------
-- Schema amazon_product
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `ecommerce` ;

-- -----------------------------------------------------
-- Schema amazon_product
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ecommerce` DEFAULT CHARACTER SET utf8 ;
USE `ecommerce` ;


-- ----------------------------
-- Table structure for also_bought
-- ----------------------------
DROP TABLE IF EXISTS `also_bought`;
CREATE TABLE `also_bought` (
  `idAlsoBought` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_identifier_origin` varchar(45) DEFAULT NULL,
  `product_identifier` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idAlsoBought`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for also_viewed
-- ----------------------------
DROP TABLE IF EXISTS `also_viewed`;
CREATE TABLE `also_viewed` (
  `idAlsoViewed` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_identifier_origin` varchar(45) DEFAULT NULL,
  `product_identifier` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idAlsoViewed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for bought_together
-- ----------------------------
DROP TABLE IF EXISTS `bought_together`;
CREATE TABLE `bought_together` (
  `idBoughtTogether` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_identifier_origin` varchar(45) DEFAULT NULL,
  `product_identifier` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idBoughtTogether`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `idCategory` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(255) NOT NULL,
  `subcategory` varchar(255) NOT NULL,
  `product_identifier` varchar(45) NOT NULL,
  PRIMARY KEY (`idCategory`),
  KEY `IDX_category_category_index` (`category`),
  KEY `IDX_category_subcategory_index` (`subcategory`),
  KEY `IDX_category_product_identifier_index` (`product_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for customer_info
-- ----------------------------
DROP TABLE IF EXISTS `customer_info`;
CREATE TABLE `customer_info` (
  `idCustomer` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `surname` varchar(45) DEFAULT NULL,
  `gender` varchar(45) DEFAULT NULL COMMENT 'male\nfemale',
  `age` int(11) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idCustomer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `idProduct` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_identifier` varchar(45) NOT NULL,
  `title` varchar(255) NOT NULL,
  `brand` varchar(255) NOT NULL,
  `price` double NOT NULL DEFAULT '0',
  `description` varchar(2047) NOT NULL,
  `imUrl` varchar(255) NOT NULL,
  PRIMARY KEY (`idProduct`),
  KEY `IDX_product_product_identifier_index` (`product_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for purchase_summary
-- ----------------------------
DROP TABLE IF EXISTS `purchase_summary`;
CREATE TABLE `purchase_summary` (
  `idPurchaseSummary` int(11) NOT NULL AUTO_INCREMENT,
  `window_type` varchar(45) DEFAULT NULL COMMENT 'minute\nhour\ndaily\nmonthly',
  `window_start` timestamp NULL DEFAULT NULL,
  `window_end` timestamp NULL DEFAULT NULL,
  `window_start_date` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `age_category` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `unique_users` int(11) DEFAULT NULL,
  `num_purchases` int(11) DEFAULT NULL,
  `unique_products` int(11) DEFAULT NULL,
  `total_products` int(11) DEFAULT NULL,
  `total_price` double DEFAULT NULL,
  PRIMARY KEY (`idPurchaseSummary`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for purchase_transaction
-- ----------------------------
DROP TABLE IF EXISTS `purchase_transaction`;
CREATE TABLE `purchase_transaction` (
  `idPurchaseTransaction` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_uuid` varchar(45) DEFAULT NULL COMMENT 'From session_info',
  `transaction_uuid` varchar(45) DEFAULT NULL,
  `start_timestamp` int(11) DEFAULT NULL,
  `idUser` int(11) DEFAULT NULL,
  `product_identifier` varchar(45) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `time_spent` double DEFAULT NULL,
  `total_price` double DEFAULT NULL,
  PRIMARY KEY (`idPurchaseTransaction`),
  KEY `IDX_purchase_transaction_idUser` (`idUser`),
  KEY `IDX_purchase_transaction_transaction_uuid` (`transaction_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sales_rank
-- ----------------------------
DROP TABLE IF EXISTS `sales_rank`;
CREATE TABLE `sales_rank` (
  `idSalesRank` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_identifier` varchar(45) DEFAULT NULL,
  `category` varchar(45) DEFAULT NULL,
  `rank` int(11) DEFAULT NULL,
  PRIMARY KEY (`idSalesRank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for session_summary
-- ----------------------------
DROP TABLE IF EXISTS `session_summary`;
CREATE TABLE `session_summary` (
  `idSession` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_uuid` varchar(45) DEFAULT NULL,
  `idUser` varchar(45) DEFAULT NULL,
  `start_timestamp` int(11) DEFAULT NULL,
  `end_timestamp` int(11) DEFAULT NULL,
  `number_purchase_transactions` int(11) DEFAULT NULL,
  `number_product_visited` int(11) DEFAULT NULL,
  `number_product_bought` int(11) DEFAULT NULL,
  `total_spending` double DEFAULT NULL,
  PRIMARY KEY (`idSession`),
  KEY `IDX_session_summary_session_uuid` (`session_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for summary_ecommerce_bought
-- ----------------------------
DROP TABLE IF EXISTS `summary_ecommerce_bought`;
CREATE TABLE `summary_ecommerce_bought` (
  `idSummaryEcommerceBought` int(11) NOT NULL AUTO_INCREMENT,
  `wStart` timestamp NULL DEFAULT NULL,
  `wEnd` timestamp NULL DEFAULT NULL,
  `product_identifier` varchar(255) DEFAULT NULL,
  `quantity_total` int(11) DEFAULT NULL,
  `num_purchases` int(11) DEFAULT NULL,
  PRIMARY KEY (`idSummaryEcommerceBought`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for top_product
-- ----------------------------
DROP TABLE IF EXISTS `top_product`;
CREATE TABLE `top_product` (
  `idTopProducts` int(11) NOT NULL AUTO_INCREMENT,
  `top_type` varchar(255) DEFAULT NULL COMMENT 'category\nsubcategory\nbrand\ncountry\ngender\nage_range',
  `top_value` varchar(255) DEFAULT NULL,
  `window_type` varchar(255) DEFAULT NULL COMMENT 'minute\nhour\nday\nmonth',
  `window_start` timestamp NULL DEFAULT NULL,
  `window_end` timestamp NULL DEFAULT NULL,
  `window_start_date` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL COMMENT 'global\nchina\nspain',
  `unique_users` int(11) DEFAULT NULL,
  `num_purchases` int(11) DEFAULT NULL,
  `unique_products` int(11) DEFAULT NULL,
  `total_products` int(11) DEFAULT NULL,
  `total_price` double DEFAULT NULL,
  PRIMARY KEY (`idTopProducts`),
  KEY `idx_top_product_top_type` (`top_type`),
  KEY `idx_top_product_window_start_date` (`window_start_date`),
  KEY `idx_top_product_country` (`country`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for visit_session
-- ----------------------------
DROP TABLE IF EXISTS `visit_session`;
CREATE TABLE `visit_session` (
  `idVisitSession` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_type` varchar(255) DEFAULT NULL,
  `session_start` timestamp NULL DEFAULT NULL,
  `session_end` timestamp NULL DEFAULT NULL,
  `session_start_date` varchar(255) DEFAULT NULL,
  `idUser` int(11) DEFAULT NULL,
  `unique_products` int(11) DEFAULT NULL,
  `total_time_spent` double DEFAULT NULL,
  `unique_products_array` varchar(2047) DEFAULT NULL,
  `time_spent_array` varchar(2047) DEFAULT NULL,
  PRIMARY KEY (`idVisitSession`),
  KEY `IDX_session_summary_session_uuid` (`session_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for worldcities
-- ----------------------------
DROP TABLE IF EXISTS `worldcities`;
CREATE TABLE `worldcities` (
  `idCity` int(11) NOT NULL AUTO_INCREMENT,
  `city_name` varchar(255) DEFAULT NULL,
  `lat` double DEFAULT NULL,
  `lng` double DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `country_iso2` varchar(255) DEFAULT NULL,
  `country_iso3` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `admin_type` varchar(255) DEFAULT NULL,
  `population` int(11) DEFAULT NULL,
  PRIMARY KEY (`idCity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for worldcountries
-- ----------------------------
DROP TABLE IF EXISTS `worldcountries`;
CREATE TABLE `worldcountries` (
  `idCountry` int(11) NOT NULL AUTO_INCREMENT,
  `country_name` varchar(255) DEFAULT NULL,
  `country_original` varchar(255) DEFAULT NULL,
  `capital_name` varchar(255) DEFAULT NULL,
  `capital_name_original` varchar(255) DEFAULT NULL COMMENT 'Capital name in original language',
  `iso2` varchar(255) DEFAULT NULL,
  `iso3` varchar(255) DEFAULT NULL,
  `population` int(11) DEFAULT NULL,
  `country_code` varchar(255) DEFAULT NULL,
  `area` int(11) DEFAULT NULL,
  `gdp` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`idCountry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;

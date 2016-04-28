# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: mysql1.cs.clemson.edu (MySQL 5.5.49-0ubuntu0.12.04.1)
# Database: NiceCatch_eon9
# Generation Time: 2016-04-28 15:14:26 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table buildings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `buildings`;

CREATE TABLE `buildings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `buildingName` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;

INSERT INTO `buildings` (`id`, `buildingName`)
VALUES
	(1,'Brackett Hall'),
	(2,'BRC'),
	(3,'Brooks Center'),
	(4,'Cook Lab'),
	(5,'Earle Hall'),
	(6,'Fluor Daniel'),
	(7,'Freeman Hall'),
	(8,'Godfrey'),
	(9,'Godley Snell'),
	(10,'Harris A. Smith'),
	(11,'Hunter Hall'),
	(12,'Jordan'),
	(13,'Kinard Lab'),
	(14,'Lee Hall'),
	(15,'Lehotsky Hall'),
	(16,'Life Science'),
	(17,'Long Hall'),
	(18,'Lowry'),
	(19,'McAdams Hall'),
	(20,'Newman Hall'),
	(21,'Olin Hall'),
	(22,'Poole'),
	(23,'Ravenel'),
	(24,'Rhodes Annex'),
	(25,'Rhodes Hall'),
	(26,'Riggs'),
	(27,'Sirrine Hall'),
	(28,'AMRL'),
	(29,'Ansell'),
	(30,'CETL'),
	(31,'Cherry Farm'),
	(32,'Endocrine Lab'),
	(33,'Environmental Tox'),
	(34,'Griffith'),
	(35,'HP Cooper'),
	(36,'ICAR'),
	(37,'Lashch Lab'),
	(38,'Patewood'),
	(39,'Pee Dee'),
	(40,'Pesticide Bldg'),
	(41,'Rich Lab'),
	(42,'Vet Diagnostic Center');

/*!40000 ALTER TABLE `buildings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table departments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `departments`;

CREATE TABLE `departments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `departmentName` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;

INSERT INTO `departments` (`id`, `departmentName`)
VALUES
	(1,'Agricultural and Environmental Sciences'),
	(2,'Animal and Veterinary Sciences'),
	(3,'Architecture'),
	(4,'Art'),
	(5,'Automotive Engineering'),
	(6,'Bioengineering'),
	(7,'Biological Sciences'),
	(8,'Chemical and Biomolecular Engineering'),
	(9,'Chemistry'),
	(10,'Civil Engineering'),
	(11,'Construction Science and Management'),
	(12,'Electrical and Computer Engineering'),
	(13,'Environmental Engineering'),
	(14,'Food, Nutrition & Packaging Science'),
	(15,'Forestry and Environmetnal Conservaton'),
	(16,'Genetics and Biochemistry'),
	(17,'Materials Science and Engineering'),
	(18,'Mechanical Engineering'),
	(19,'Nursing'),
	(20,'Physics and Astronomy'),
	(21,'Public Health Sciences');

/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table involvementKinds
# ------------------------------------------------------------

DROP TABLE IF EXISTS `involvementKinds`;

CREATE TABLE `involvementKinds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `involvementKind` varchar(255) NOT NULL DEFAULT '',
  `default` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `involvementKinds` WRITE;
/*!40000 ALTER TABLE `involvementKinds` DISABLE KEYS */;

INSERT INTO `involvementKinds` (`id`, `involvementKind`, `default`)
VALUES
	(1,'Work Practice/Procedure',1),
	(2,'Chemical',1),
	(3,'Equipment',1),
	(4,'Work Space Condition',1),
	(5,'Radiation',1),
	(6,'Biological',1),
	(7,'Other',1),
	(11,'parking lot safety',0);

/*!40000 ALTER TABLE `involvementKinds` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table locations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `locations`;

CREATE TABLE `locations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `buildingID` int(11) unsigned NOT NULL,
  `room` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `buildingID-Locations` (`buildingID`),
  CONSTRAINT `buildingID-Locations` FOREIGN KEY (`buildingID`) REFERENCES `buildings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;

INSERT INTO `locations` (`id`, `buildingID`, `room`)
VALUES
	(1,1,NULL),
	(2,3,'244'),
	(3,1,NULL),
	(4,16,NULL),
	(5,2,'123'),
	(6,3,'5'),
	(7,11,'outside'),
	(8,17,'114'),
	(9,6,'n/a'),
	(10,4,'1A'),
	(11,25,'418'),
	(12,25,'414'),
	(13,24,'316'),
	(14,25,'410');

/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table people
# ------------------------------------------------------------

DROP TABLE IF EXISTS `people`;

CREATE TABLE `people` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `personKindID` int(11) unsigned NOT NULL,
  `username` varchar(64) NOT NULL,
  `name` varchar(255) DEFAULT '',
  `phone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `people` WRITE;
/*!40000 ALTER TABLE `people` DISABLE KEYS */;

INSERT INTO `people` (`id`, `personKindID`, `username`, `name`, `phone`)
VALUES
	(13,3,'jacksod','Jake','555-555-5555'),
	(14,1,'nnk','Ghj',''),
	(15,2,'asbrigh','Angel',''),
	(16,1,'jmorri2','Jim Morris',''),
	(17,1,'kkwist','Kerri Kwist','864-508-1951'),
	(18,9,'csdunca','Olivia Benson',''),
	(19,2,'lwray','Lisa Wray','656-0341'),
	(20,2,'gregory','Cassie','864-656-1710'),
	(21,1,'cmoody3','Christopher Moody','');

/*!40000 ALTER TABLE `people` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table personKinds
# ------------------------------------------------------------

DROP TABLE IF EXISTS `personKinds`;

CREATE TABLE `personKinds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `personKind` varchar(255) NOT NULL DEFAULT '',
  `default` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `personKinds` WRITE;
/*!40000 ALTER TABLE `personKinds` DISABLE KEYS */;

INSERT INTO `personKinds` (`id`, `personKind`, `default`)
VALUES
	(1,'Faculty',1),
	(2,'Staff',1),
	(3,'Student',1),
	(4,'Other',1),
	(8,'superhero',0),
	(9,'investigator',0);

/*!40000 ALTER TABLE `personKinds` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table preferences
# ------------------------------------------------------------

DROP TABLE IF EXISTS `preferences`;

CREATE TABLE `preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pin` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `preferences` WRITE;
/*!40000 ALTER TABLE `preferences` DISABLE KEYS */;

INSERT INTO `preferences` (`id`, `pin`)
VALUES
	(1,4294967295);

/*!40000 ALTER TABLE `preferences` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table reportKinds
# ------------------------------------------------------------

DROP TABLE IF EXISTS `reportKinds`;

CREATE TABLE `reportKinds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reportKind` varchar(255) NOT NULL DEFAULT '',
  `default` int(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `reportKinds` WRITE;
/*!40000 ALTER TABLE `reportKinds` DISABLE KEYS */;

INSERT INTO `reportKinds` (`id`, `reportKind`, `default`)
VALUES
	(1,'Close Call',1),
	(2,'Lesson Learned',1),
	(3,'Safety Issue',1),
	(4,'Other',1);

/*!40000 ALTER TABLE `reportKinds` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table reports
# ------------------------------------------------------------

DROP TABLE IF EXISTS `reports`;

CREATE TABLE `reports` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT '',
  `involvementKindID` int(11) unsigned NOT NULL,
  `reportKindID` int(11) unsigned NOT NULL,
  `locationID` int(11) unsigned NOT NULL,
  `personID` int(11) unsigned NOT NULL,
  `departmentID` int(11) unsigned NOT NULL,
  `dateTime` datetime NOT NULL,
  `statusID` int(11) unsigned DEFAULT NULL,
  `actionTaken` varchar(512) DEFAULT NULL,
  `photoPath` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `involvementKind-Reports` (`involvementKindID`),
  KEY `location-Reports` (`locationID`),
  KEY `person-Reports` (`reportKindID`),
  KEY `people-Reports` (`personID`),
  CONSTRAINT `involvementKind-Reports` FOREIGN KEY (`involvementKindID`) REFERENCES `involvementKinds` (`id`) ON DELETE CASCADE,
  CONSTRAINT `location-Reports` FOREIGN KEY (`locationID`) REFERENCES `locations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `people-Reports` FOREIGN KEY (`personID`) REFERENCES `people` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reportKind-Reports` FOREIGN KEY (`reportKindID`) REFERENCES `reportKinds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;

INSERT INTO `reports` (`id`, `description`, `involvementKindID`, `reportKindID`, `locationID`, `personID`, `departmentID`, `dateTime`, `statusID`, `actionTaken`, `photoPath`)
VALUES
	(107,'Test description',1,1,1,13,1,'2016-04-07 11:39:29',1,'','/home/jacksod/public_html/uploads/107/report-image.png'),
	(108,'Jjggh',3,2,2,14,2,'2016-04-07 14:57:57',1,'','/home/jacksod/public_html/uploads/108/report-image.png'),
	(109,'Ui',1,1,1,15,1,'2016-04-07 03:19:25',1,'','/home/jacksod/public_html/uploads/109/report-image.png'),
	(110,'PPE failure.',3,3,4,16,16,'2016-04-11 12:04:29',1,'','/home/jacksod/public_html/uploads/110/report-image.png'),
	(111,'Tripped over loose cords in the floor. Taped down so others wouldn\'t trip over them.',4,2,5,15,1,'2016-04-12 08:57:50',1,'',NULL),
	(112,'Food in lab',1,1,6,17,4,'2016-04-14 08:56:24',1,'',NULL),
	(113,'Slight scratch from exposed nail',1,1,7,17,9,'2016-04-15 10:24:30',1,'','/home/jacksod/public_html/uploads/113/report-image.png'),
	(114,'Slight scratch from exposed nail',1,1,7,17,9,'2016-04-15 10:24:34',1,'','/home/jacksod/public_html/uploads/114/report-image.png'),
	(115,'Slight scratch from exposed nail',1,1,7,17,9,'2016-04-15 10:25:08',1,'',NULL),
	(116,'I almost burnt myself on this heater.....',4,1,8,18,7,'2016-04-21 02:40:08',1,'','/home/jacksod/public_html/uploads/116/report-image.png'),
	(117,'I almost burnt myself on this heater.....',4,1,8,18,7,'2016-04-21 02:40:12',1,'','/home/jacksod/public_html/uploads/117/report-image.png'),
	(118,'Do not drop your phone in the parking lot, it will get run over',11,2,9,18,4,'2016-04-21 02:42:16',1,'',NULL),
	(119,'Water your plants or they will die',6,3,10,19,9,'2016-04-21 02:43:34',1,'','/home/jacksod/public_html/uploads/119/report-image.png'),
	(120,'Student was using the microtome without following safety protocol.  Had deactivated safety guard that protects the blade. Safety guard should always be activated when not cutting with the blade.',3,1,11,20,6,'2016-04-22 01:47:23',1,'','/home/jacksod/public_html/uploads/120/report-image.png'),
	(121,'Student was getting cells out of nitrogen dewar using heat protection gloves for autoclave use instead of cryogloves. Nitrogen could have gotten on her hands causing burns.',2,2,12,20,6,'2016-04-22 01:52:33',1,'','/home/jacksod/public_html/uploads/121/report-image.png'),
	(122,'Person working on power supply in electrical lab and touch a hot component that he shouldn\'t have.',3,3,13,20,6,'2016-04-22 02:07:30',1,'','/home/jacksod/public_html/uploads/122/report-image.png'),
	(123,'Tripping hazard',4,3,14,21,6,'2016-04-25 11:02:30',1,'','/home/jacksod/public_html/uploads/123/report-image.png'),
	(124,'Tripping hazard',4,3,14,21,6,'2016-04-25 11:02:32',1,'','/home/jacksod/public_html/uploads/124/report-image.png'),
	(125,'Using incubator without gloves or PPE',6,2,14,21,6,'2016-04-25 11:05:44',1,'','/home/jacksod/public_html/uploads/125/report-image.png'),
	(126,'Wrong storage of base near an acid. Chloroform in acid cabinet',2,1,14,21,6,'2016-04-25 11:08:06',1,'','/home/jacksod/public_html/uploads/126/report-image.png');

/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table statuses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `statuses`;

CREATE TABLE `statuses` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `statuses` WRITE;
/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;

INSERT INTO `statuses` (`id`, `name`)
VALUES
	(1,'New'),
	(2,'Closed'),
	(3,'Viewed');

/*!40000 ALTER TABLE `statuses` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

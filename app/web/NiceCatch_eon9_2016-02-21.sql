# ************************************************************
# Sequel Pro SQL dump
# Version 4529
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: mysql1.cs.clemson.edu (MySQL 5.5.47-0ubuntu0.12.04.1)
# Database: NiceCatch_eon9
# Generation Time: 2016-02-21 21:33:07 +0000
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
	(27,'Sirrine Hall');

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
	(1,'Agricultural & Environmental Sciences'),
	(2,'Animal & Veterinary Sciences'),
	(3,'Architecture'),
	(4,'Art'),
	(5,'Automotive Engineering'),
	(6,'Bioengineering'),
	(7,'Biological Sciences'),
	(8,'Chemical & Biomolecular Engineering'),
	(9,'Chemistry'),
	(10,'Civil Engineering'),
	(11,'Construction Science & Management'),
	(12,'Electrical & Computer Engineering'),
	(13,'Environmental Engineering'),
	(14,'Food, Nutrition & Packaging Science'),
	(15,'Forestry & Environmetnal Conservaton'),
	(16,'Genetics & Biochemistry'),
	(17,'Materials Science & Engineering'),
	(18,'Mechanical Engineering'),
	(19,'Nursing'),
	(20,'Physics & Astronomy'),
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
	(7,'Other',1);

/*!40000 ALTER TABLE `involvementKinds` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table locations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `locations`;

CREATE TABLE `locations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `buildingID` int(11) unsigned NOT NULL,
  `room` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `buildingID-Locations` (`buildingID`),
  CONSTRAINT `buildingID-Locations` FOREIGN KEY (`buildingID`) REFERENCES `buildings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;

INSERT INTO `locations` (`id`, `buildingID`, `room`)
VALUES
	(1,1,100),
	(3,1,101);

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
	(1,1,'bob','Tommy',NULL),
	(2,1,'jake','jack','123-654-7890'),
	(3,1,'john','john','123-654-0000'),
	(4,1,'toby','Toby',NULL);

/*!40000 ALTER TABLE `people` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table personKinds
# ------------------------------------------------------------

DROP TABLE IF EXISTS `personKinds`;

CREATE TABLE `personKinds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `personKind` varchar(255) NOT NULL DEFAULT '',
  `deafult` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `personKinds` WRITE;
/*!40000 ALTER TABLE `personKinds` DISABLE KEYS */;

INSERT INTO `personKinds` (`id`, `personKind`, `deafult`)
VALUES
	(1,'Faculty',1),
	(2,'Staff',1),
	(3,'Student',1),
	(4,'Other',1);

/*!40000 ALTER TABLE `personKinds` ENABLE KEYS */;
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

INSERT INTO `reports` (`id`, `description`, `involvementKindID`, `reportKindID`, `locationID`, `personID`, `departmentID`, `dateTime`, `statusID`, `actionTaken`)
VALUES
	(1,'this is a test',2,1,1,1,2,'2016-02-09 00:00:01',NULL,NULL);

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

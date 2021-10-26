CREATE DATABASE  IF NOT EXISTS `game` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `game`;
-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: cray
-- ------------------------------------------------------
-- Server version	8.0.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `goal`
--

DROP TABLE IF EXISTS `goal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goal` (
  `MatchID` int NOT NULL,
  `PlayerID` int NOT NULL,
  `Time` datetime NOT NULL,
  PRIMARY KEY (`MatchID`,`PlayerID`,`Time`),
  KEY `PlayerID` (`PlayerID`),
  CONSTRAINT `goal_ibfk_1` FOREIGN KEY (`MatchID`) REFERENCES `match` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goal_ibfk_2` FOREIGN KEY (`PlayerID`) REFERENCES `player` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goal`
--

LOCK TABLES `goal` WRITE;
/*!40000 ALTER TABLE `goal` DISABLE KEYS */;
INSERT INTO `goal` VALUES (1,1,'2021-05-01 14:07:12'),(2,3,'2021-05-09 18:02:53'),(2,4,'2021-05-09 18:16:45'),(1,7,'2021-05-01 14:20:01'),(2,9,'2021-05-09 18:05:07');
/*!40000 ALTER TABLE `goal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jerseycolor`
--

DROP TABLE IF EXISTS `jerseycolor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jerseycolor` (
  `TeamID` int NOT NULL,
  `Color` varchar(255) NOT NULL,
  KEY `TeamID` (`TeamID`),
  CONSTRAINT `jerseycolor_ibfk_1` FOREIGN KEY (`TeamID`) REFERENCES `team` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jerseycolor`
--

LOCK TABLES `jerseycolor` WRITE;
/*!40000 ALTER TABLE `jerseycolor` DISABLE KEYS */;
INSERT INTO `jerseycolor` VALUES (1,'Green'),(1,'Pink'),(2,'Blue');
/*!40000 ALTER TABLE `jerseycolor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manager`
--

DROP TABLE IF EXISTS `manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manager` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(255) NOT NULL,
  `MiddleName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) NOT NULL,
  `DOB` date NOT NULL,
  `Nationality` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manager`
--

LOCK TABLES `manager` WRITE;
/*!40000 ALTER TABLE `manager` DISABLE KEYS */;
INSERT INTO `manager` VALUES (1,'Thomas','Sans','Mercy','1994-06-14','France'),(2,'William','Cook','Shakespeare','1995-07-01','Japan'),(3,'Solar',NULL,'Lemma','1995-10-14','Germany');
/*!40000 ALTER TABLE `manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match`
--

DROP TABLE IF EXISTS `match`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `match` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `HomeTeamID` int NOT NULL,
  `AwayTeamID` int NOT NULL,
  `Date` date NOT NULL,
  `Time` datetime NOT NULL,
  `Venue` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `HomeTeamID` (`HomeTeamID`),
  KEY `AwayTeamID` (`AwayTeamID`),
  KEY `Venue` (`Venue`),
  CONSTRAINT `match_ibfk_1` FOREIGN KEY (`HomeTeamID`) REFERENCES `team` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `match_ibfk_2` FOREIGN KEY (`AwayTeamID`) REFERENCES `team` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `match_ibfk_3` FOREIGN KEY (`Venue`) REFERENCES `stadium` (`ID`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match`
--

LOCK TABLES `match` WRITE;
/*!40000 ALTER TABLE `match` DISABLE KEYS */;
INSERT INTO `match` VALUES (1,1,2,'2021-05-01','2021-05-01 14:00:00',1),(2,2,1,'2021-05-09','2021-05-09 18:00:00',2);
/*!40000 ALTER TABLE `match` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `player` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(255) NOT NULL,
  `MiddleName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) NOT NULL,
  `DOB` date NOT NULL,
  `Nationality` varchar(255) NOT NULL,
  `TeamID` int DEFAULT NULL,
  `PlayingEleven` tinyint(1) NOT NULL DEFAULT '0',
  `JerseyName` varchar(255) NOT NULL,
  `JerseyNumber` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `TeamID` (`TeamID`),
  CONSTRAINT `player_ibfk_1` FOREIGN KEY (`TeamID`) REFERENCES `team` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player`
--

LOCK TABLES `player` WRITE;
/*!40000 ALTER TABLE `player` DISABLE KEYS */;
INSERT INTO `player` VALUES (1,'Aloy',NULL,'Ihenacho','1995-07-21','Nigeria',1,1,'Ihenacho',24),(2,'Thomas','Eric','Blomeyer','1996-04-24','Germany',1,1,'Blomeyer',56),(3,'Milan','Husek','Ivana','1983-11-26','Slovakia',1,1,'Ivana',111),(4,'Attaberk','Sam','Gurgen','1996-09-30','Turkey',1,1,'Guergen',54),(5,'Konstantin','Chase','Engel','1988-07-27','Kazakhstan',1,1,'Engel',29),(6,'Ivan',NULL,'Komlev','1994-07-22','Ukraine',2,2,'Komlev',97),(7,'Dmytro',NULL,'Yusov','1993-05-11','Ukraine',2,2,'Yusov',41),(8,'Bas',NULL,'Sibum','1982-12-26','Netherlands',2,2,'Sibum',55),(9,'Livio',NULL,'Nabab','1988-06-14','Guadeloupe',2,2,'Nabab',49),(10,'Vitaliy',NULL,'Lysytskyi','1982-04-16','Ukraine',2,2,'Lysytskyi',87),(11,'Rick',NULL,'Hemmink','1993-02-14','Netherlands',2,0,'Hemmink',222),(12,'Haris',NULL,'Handzic','1990-06-20','Bosnia-Herzegovina',NULL,0,'Handzic',300),(13,'Semen',NULL,'Fomin','1989-01-10','Russia',NULL,0,'Fomin',592),(14,'Mahmut',NULL,'Metin','1994-07-12','Turkey',NULL,0,'Metin',675),(15,'Servet',NULL,'Cetin','1981-03-17','Turkey',NULL,0,'Cetin',812),(16,'Mehmet','Ali','Kacar','1998-01-18','Turkey',NULL,0,'Kacar',99),(17,'Oktay',NULL,'Delibalta','1985-10-27','Turkey',NULL,0,'Delibalta',12),(18,'Hilmi',NULL,'Resiti','1997-07-29','Turkey',NULL,0,'Resiti',65),(19,'Mehmet','Enes','Sigirci','1993-02-24','Turkey',NULL,0,'Sigirci',52),(20,'Marko',NULL,'Futacs','1990-02-22','Hungary',NULL,0,'Futacs',76),(21,'Rahmi',NULL,'Celik','1995-08-11','Turkey',NULL,0,'Celik',39),(22,'Selcuk',NULL,'Alibaz','1989-01-03','Germany',NULL,0,'Alibaz',66),(23,'Ciprian',NULL,'Marica','1985-01-02','Romania',NULL,0,'Marica',5),(24,'Dossa',NULL,'Junior','1986-07-28','Cyprus',NULL,0,'Junior',1),(25,'Dmitri',NULL,'Verkhovtsov','1986-10-10','Belarus',NULL,0,'Verkhovtsov',2),(26,'Evgeniy',NULL,'Osipov','1986-10-29','Russia',NULL,0,'Osipov',7),(27,'Christian',NULL,'Nade','1984-09-18','France',NULL,0,'Nade',67);
/*!40000 ALTER TABLE `player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playerposition`
--

DROP TABLE IF EXISTS `playerposition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playerposition` (
  `PlayerID` int NOT NULL,
  `Position` enum('striker','midfielder','defender','goalkeeper') NOT NULL,
  KEY `PlayerID` (`PlayerID`),
  CONSTRAINT `playerposition_ibfk_1` FOREIGN KEY (`PlayerID`) REFERENCES `player` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playerposition`
--

LOCK TABLES `playerposition` WRITE;
/*!40000 ALTER TABLE `playerposition` DISABLE KEYS */;
INSERT INTO `playerposition` VALUES (1,'striker'),(2,'striker'),(3,'striker'),(4,'midfielder'),(4,'striker'),(5,'midfielder'),(6,'midfielder'),(7,'midfielder'),(8,'defender'),(9,'defender'),(10,'defender'),(11,'defender'),(12,'goalkeeper'),(3,'goalkeeper'),(13,'striker'),(14,'striker'),(15,'midfielder'),(16,'midfielder'),(17,'midfielder'),(18,'midfielder'),(19,'midfielder'),(18,'striker'),(20,'defender'),(21,'defender'),(22,'defender'),(23,'defender'),(24,'striker'),(25,'goalkeeper'),(26,'goalkeeper'),(27,'goalkeeper'),(11,'goalkeeper');
/*!40000 ALTER TABLE `playerposition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `result`
--

DROP TABLE IF EXISTS `result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `result` (
  `MatchID` int NOT NULL,
  `HomeScore` int NOT NULL,
  `AwayScore` int NOT NULL,
  PRIMARY KEY (`MatchID`,`HomeScore`,`AwayScore`),
  CONSTRAINT `result_ibfk_1` FOREIGN KEY (`MatchID`) REFERENCES `match` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `result`
--

LOCK TABLES `result` WRITE;
/*!40000 ALTER TABLE `result` DISABLE KEYS */;
INSERT INTO `result` VALUES (1,1,1),(2,2,1);
/*!40000 ALTER TABLE `result` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stadium`
--

DROP TABLE IF EXISTS `stadium`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stadium` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Address` varchar(255) NOT NULL,
  `City` varchar(255) NOT NULL,
  `Country` varchar(255) NOT NULL,
  `Capacity` int NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Address` (`Address`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stadium`
--

LOCK TABLES `stadium` WRITE;
/*!40000 ALTER TABLE `stadium` DISABLE KEYS */;
INSERT INTO `stadium` VALUES (1,'Camp Nou Stadium','La Ternitat','Barcelona','Spain',99354),(2,'Japan National Stadium','Kasumigaoka','Tokyo','Japan',80000);
/*!40000 ALTER TABLE `stadium` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Country` varchar(255) NOT NULL,
  `StadiumID` int NOT NULL,
  `ManagerID` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `StadiumID` (`StadiumID`),
  KEY `ManagerID` (`ManagerID`),
  CONSTRAINT `team_ibfk_1` FOREIGN KEY (`StadiumID`) REFERENCES `stadium` (`ID`) ON UPDATE CASCADE,
  CONSTRAINT `team_ibfk_2` FOREIGN KEY (`ManagerID`) REFERENCES `manager` (`ID`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` VALUES (1,'Panthers','Italy',1,1),(2,'Giants','France',2,2);
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-10-26 19:11:20

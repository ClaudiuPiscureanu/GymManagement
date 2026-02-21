-- MySQL dump 10.13  Distrib 9.6.0, for macos15 (arm64)
--
-- Host: localhost    Database: palestra
-- ------------------------------------------------------
-- Server version	9.6.0-commercial

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '152f8094-0db5-11f1-9a89-fda853a64979:1-142';

--
-- Table structure for table `Allenamento`
--

DROP TABLE IF EXISTS `Allenamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Allenamento` (
  `idAllenamento` int NOT NULL AUTO_INCREMENT,
  `idScheda` int NOT NULL,
  `data` date NOT NULL DEFAULT (curdate()),
  `oraInizio` time NOT NULL,
  `oraFine` time NOT NULL,
  `percentualeCompletamento` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`idAllenamento`),
  UNIQUE KEY `uq_allenamento_slot` (`idScheda`,`data`,`oraInizio`),
  CONSTRAINT `fk_allenamento_scheda` FOREIGN KEY (`idScheda`) REFERENCES `Scheda` (`idScheda`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ck_allenamento_ore` CHECK ((`oraFine` > `oraInizio`)),
  CONSTRAINT `ck_allenamento_perc` CHECK (((`percentualeCompletamento` >= 0) and (`percentualeCompletamento` <= 100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_allenamento_before_insert` BEFORE INSERT ON `allenamento` FOR EACH ROW BEGIN
    DECLARE v_archiviata DATE;

    SELECT dataArchiviazione
    INTO   v_archiviata
    FROM   Scheda
    WHERE  idScheda = NEW.idScheda;

    IF v_archiviata IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile registrare un allenamento su una scheda archiviata.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Atleta`
--

DROP TABLE IF EXISTS `Atleta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Atleta` (
  `idAtleta` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cognome` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cf` char(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dataNascita` date NOT NULL,
  `dataIscrizione` date NOT NULL DEFAULT (curdate()),
  `idPr` int NOT NULL,
  PRIMARY KEY (`idAtleta`),
  UNIQUE KEY `uq_atleta_cf` (`cf`),
  UNIQUE KEY `uq_atleta_email` (`email`),
  KEY `fk_atleta_pt` (`idPr`),
  CONSTRAINT `fk_atleta_pt` FOREIGN KEY (`idPr`) REFERENCES `PersonalTrainer` (`idPr`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_atleta_utenti` FOREIGN KEY (`email`) REFERENCES `Utenti` (`email`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ck_atleta_cf` CHECK ((char_length(`cf`) = 16)),
  CONSTRAINT `ck_atleta_date` CHECK ((`dataIscrizione` >= `dataNascita`))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Attrezzatura`
--

DROP TABLE IF EXISTS `Attrezzatura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Attrezzatura` (
  `idAttrezzatura` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descrizione` text COLLATE utf8mb4_unicode_ci,
  `dataAcquisto` date DEFAULT (curdate()),
  PRIMARY KEY (`idAttrezzatura`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Esercizio`
--

DROP TABLE IF EXISTS `Esercizio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Esercizio` (
  `idEsercizio` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descrizione` text COLLATE utf8mb4_unicode_ci,
  `gruppoMuscolare` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idAttrezzatura` int DEFAULT NULL,
  PRIMARY KEY (`idEsercizio`),
  UNIQUE KEY `uq_esercizio_nome` (`nome`),
  KEY `fk_esercizio_attr` (`idAttrezzatura`),
  CONSTRAINT `fk_esercizio_attr` FOREIGN KEY (`idAttrezzatura`) REFERENCES `Attrezzatura` (`idAttrezzatura`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EsercizioScheda`
--

DROP TABLE IF EXISTS `EsercizioScheda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EsercizioScheda` (
  `idScheda` int NOT NULL,
  `idEsercizio` int NOT NULL,
  `numero` tinyint NOT NULL,
  `serie` tinyint NOT NULL,
  `ripetizioni` tinyint NOT NULL,
  `peso` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`idScheda`,`idEsercizio`),
  UNIQUE KEY `uq_es_ordine` (`idScheda`,`numero`),
  KEY `fk_es_esercizio` (`idEsercizio`),
  CONSTRAINT `fk_es_esercizio` FOREIGN KEY (`idEsercizio`) REFERENCES `Esercizio` (`idEsercizio`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_es_scheda` FOREIGN KEY (`idScheda`) REFERENCES `Scheda` (`idScheda`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ck_es_numero` CHECK ((`numero` > 0)),
  CONSTRAINT `ck_es_peso` CHECK (((`peso` is null) or (`peso` >= 0))),
  CONSTRAINT `ck_es_ripetizioni` CHECK ((`ripetizioni` > 0)),
  CONSTRAINT `ck_es_serie` CHECK ((`serie` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EsercizioSvolto`
--

DROP TABLE IF EXISTS `EsercizioSvolto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EsercizioSvolto` (
  `idAllenamento` int NOT NULL,
  `idEsercizio` int NOT NULL,
  `percCompletamento` tinyint NOT NULL,
  PRIMARY KEY (`idAllenamento`,`idEsercizio`),
  KEY `fk_esvolto_ese` (`idEsercizio`),
  CONSTRAINT `fk_esvolto_all` FOREIGN KEY (`idAllenamento`) REFERENCES `Allenamento` (`idAllenamento`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_esvolto_ese` FOREIGN KEY (`idEsercizio`) REFERENCES `Esercizio` (`idEsercizio`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ck_esvolto_perc` CHECK (((`percCompletamento` >= 0) and (`percCompletamento` <= 100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_esvolto_before_insert` BEFORE INSERT ON `eserciziosvolto` FOR EACH ROW BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*)
    INTO   v_count
    FROM   Allenamento  a
    JOIN   EsercizioScheda es ON es.idScheda = a.idScheda
    WHERE  a.idAllenamento = NEW.idAllenamento
      AND  es.idEsercizio  = NEW.idEsercizio;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L esercizio non appartiene alla scheda di questo allenamento.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `PersonalTrainer`
--

DROP TABLE IF EXISTS `PersonalTrainer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PersonalTrainer` (
  `idPr` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cognome` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `specializzazione` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idPr`),
  UNIQUE KEY `uq_pt_email` (`email`),
  CONSTRAINT `fk_pt_utenti` FOREIGN KEY (`email`) REFERENCES `Utenti` (`email`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Scheda`
--

DROP TABLE IF EXISTS `Scheda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Scheda` (
  `idScheda` int NOT NULL AUTO_INCREMENT,
  `idAtleta` int NOT NULL,
  `idPr` int NOT NULL,
  `dataCreazione` date NOT NULL DEFAULT (curdate()),
  `dataArchiviazione` date DEFAULT NULL,
  PRIMARY KEY (`idScheda`),
  UNIQUE KEY `uq_scheda_corrente` (`idAtleta`),
  KEY `fk_scheda_pt` (`idPr`),
  CONSTRAINT `fk_scheda_atleta` FOREIGN KEY (`idAtleta`) REFERENCES `Atleta` (`idAtleta`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_scheda_pt` FOREIGN KEY (`idPr`) REFERENCES `PersonalTrainer` (`idPr`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ck_scheda_date` CHECK (((`dataArchiviazione` is null) or (`dataArchiviazione` >= `dataCreazione`)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Utenti`
--

DROP TABLE IF EXISTS `Utenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Utenti` (
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruolo` enum('proprietario','personal_trainer','atleta') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`email`),
  CONSTRAINT `ck_utenti_email` CHECK ((`email` like _utf8mb4'%@%.%'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `v_report_pt`
--

DROP TABLE IF EXISTS `v_report_pt`;
/*!50001 DROP VIEW IF EXISTS `v_report_pt`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_report_pt` AS SELECT 
 1 AS `idPr`,
 1 AS `nomePT`,
 1 AS `cognomePT`,
 1 AS `idAtleta`,
 1 AS `nomeAtleta`,
 1 AS `cognomeAtleta`,
 1 AS `idAllenamento`,
 1 AS `data`,
 1 AS `oraInizio`,
 1 AS `oraFine`,
 1 AS `durata`,
 1 AS `percentualeCompletamento`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_scheda_corrente`
--

DROP TABLE IF EXISTS `v_scheda_corrente`;
/*!50001 DROP VIEW IF EXISTS `v_scheda_corrente`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_scheda_corrente` AS SELECT 
 1 AS `idAtleta`,
 1 AS `nomeAtleta`,
 1 AS `cognomeAtleta`,
 1 AS `idScheda`,
 1 AS `dataCreazione`,
 1 AS `numero`,
 1 AS `idEsercizio`,
 1 AS `nomeEsercizio`,
 1 AS `gruppoMuscolare`,
 1 AS `serie`,
 1 AS `ripetizioni`,
 1 AS `peso`,
 1 AS `nomeAttrezzatura`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'palestra'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `archivia_schede_inattive` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `archivia_schede_inattive` ON SCHEDULE EVERY 1 MONTH STARTS '2026-02-21 20:38:37' ON COMPLETION PRESERVE ENABLE COMMENT 'Archivia schede di atleti inattivi da più di 90 giorni' DO BEGIN
        UPDATE Scheda
        SET    dataArchiviazione = CURDATE()
        WHERE  dataArchiviazione IS NULL
          AND  idScheda NOT IN (
            -- Schede che hanno almeno un allenamento
            -- negli ultimi 90 giorni
            SELECT DISTINCT al.idScheda
            FROM   Allenamento al
            WHERE  al.data >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)
        );
    END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `rimozione_allenamenti_vecchi` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `rimozione_allenamenti_vecchi` ON SCHEDULE EVERY 1 MONTH STARTS '2026-08-21 20:38:37' ON COMPLETION PRESERVE ENABLE COMMENT 'Rimozione allenamenti e esercizi svolti più vecchi di 6 mesi' DO BEGIN
        DELETE FROM Allenamento
        WHERE data < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
    END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `rimozione_schede_archiviate_vecchie` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `rimozione_schede_archiviate_vecchie` ON SCHEDULE EVERY 1 MONTH STARTS '2027-02-21 20:38:37' ON COMPLETION PRESERVE ENABLE COMMENT 'Rimozione schede archiviate e relativi esercizi più vecchi di 12 mesi' DO BEGIN
        DELETE FROM Scheda
        WHERE dataArchiviazione IS NOT NULL
          AND dataArchiviazione < DATE_SUB(CURDATE(), INTERVAL 12 MONTH);
    END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'palestra'
--
/*!50003 DROP PROCEDURE IF EXISTS `aggiorna_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `aggiorna_password`(
    IN var_email        VARCHAR(100),
    IN var_pass_vecchia VARCHAR(45),
    IN var_pass_nuova   VARCHAR(45)
)
BEGIN
    DECLARE var_count       INT;
    DECLARE var_count_new   INT;

    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;

    -- Verifica che la password attuale sia corretta
    SELECT COUNT(*) INTO var_count
    FROM Utenti
    WHERE email    = var_email
      AND password = SHA2(var_pass_vecchia, 256);

    IF var_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Password attuale non corretta.';
    END IF;

    -- Verifica che la nuova password sia diversa dalla vecchia
    IF var_pass_vecchia = var_pass_nuova THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La nuova password deve essere diversa da quella attuale.';
    END IF;

    -- Verifica lunghezza minima password
    IF CHAR_LENGTH(var_pass_nuova) < 6 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La nuova password deve essere di almeno 6 caratteri.';
    END IF;

    UPDATE Utenti
    SET    password = SHA2(var_pass_nuova, 256)
    WHERE  email    = var_email;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `aggiungi_esercizio_scheda` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `aggiungi_esercizio_scheda`(
    IN var_idPr         INT,
    IN var_idScheda     INT,
    IN var_idEsercizio  INT,
    IN var_numero       TINYINT,
    IN var_serie        TINYINT,
    IN var_ripetizioni  TINYINT,
    IN var_peso         DECIMAL(5,2)    -- NULL se non applicabile
)
BEGIN
    DECLARE var_scheda_count    INT;

    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;

    -- Verifica che la scheda appartenga a un atleta del PT
    -- e che sia ancora corrente
    SELECT COUNT(*) INTO var_scheda_count
    FROM Scheda s
             JOIN Atleta a ON a.idAtleta = s.idAtleta
    WHERE s.idScheda          = var_idScheda
      AND a.idPr              = var_idPr
      AND s.dataArchiviazione IS NULL;

    IF var_scheda_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Scheda non trovata, archiviata o non di tua competenza.';
    END IF;

    INSERT INTO EsercizioScheda (idScheda, idEsercizio, numero, serie, ripetizioni, peso)
    VALUES (var_idScheda, var_idEsercizio, var_numero, var_serie, var_ripetizioni, var_peso);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `crea_scheda` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `crea_scheda`(
    IN var_idPr         INT,
    IN var_idAtleta     INT
)
BEGIN
    DECLARE var_atleta_count    INT;
    DECLARE var_idScheda        INT;

    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

    -- Verifica che l atleta sia assegnato a questo PT
    SELECT COUNT(*) INTO var_atleta_count
    FROM Atleta
    WHERE idAtleta = var_idAtleta
      AND idPr     = var_idPr;

    IF var_atleta_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Atleta non trovato o non assegnato a questo Personal Trainer.';
    END IF;

    -- Archivia la scheda corrente se esiste
    -- (il trigger trg_scheda_before_insert lo fa automaticamente,
    --  ma lo rendiamo esplicito per chiarezza e controllo)
    UPDATE Scheda
    SET    dataArchiviazione = CURDATE()
    WHERE  idAtleta          = var_idAtleta
      AND  dataArchiviazione IS NULL;

    -- Crea la nuova scheda corrente
    INSERT INTO Scheda (idAtleta, idPr, dataCreazione, dataArchiviazione)
    VALUES (var_idAtleta, var_idPr, CURDATE(), NULL);

    SET var_idScheda = LAST_INSERT_ID();

    COMMIT;

    -- Restituisce l id della nuova scheda al client
    -- Il client Java userà questo id per le chiamate successive
    -- a aggiungi_esercizio_scheda
    SELECT var_idScheda AS idScheda;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inizia_allenamento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inizia_allenamento`(
    IN  var_idAtleta    INT,
    IN  var_oraInizio   TIME,
    OUT var_idAllenamento INT
)
BEGIN
    DECLARE var_idScheda    INT;
    DECLARE var_count       INT;

    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

    -- Recupera la scheda corrente dell atleta
    SELECT idScheda INTO var_idScheda
    FROM Scheda
    WHERE idAtleta          = var_idAtleta
      AND dataArchiviazione IS NULL;

    IF var_idScheda IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nessuna scheda corrente. Contatta il tuo Personal Trainer.';
    END IF;

    -- Verifica che non esista già un allenamento aperto
    -- (stesso atleta, stessa data, stessa ora di inizio)
    SELECT COUNT(*) INTO var_count
    FROM Allenamento
    WHERE idScheda  = var_idScheda
      AND data      = CURDATE()
      AND oraInizio = var_oraInizio;

    IF var_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Esiste gia un allenamento registrato per questo orario.';
    END IF;

    -- Inserisce l allenamento con oraFine = oraInizio
    -- (verrà aggiornata da termina_allenamento)
    -- percentualeCompletamento inizia a 0
    INSERT INTO Allenamento (idScheda, data, oraInizio, oraFine, percentualeCompletamento)
    VALUES (var_idScheda, CURDATE(), var_oraInizio, var_oraInizio, 0);

    SET var_idAllenamento = LAST_INSERT_ID();

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inserisci_atleta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserisci_atleta`(
    IN var_nome             VARCHAR(50),
    IN var_cognome          VARCHAR(50),
    IN var_cf               CHAR(16),
    IN var_email            VARCHAR(100),
    IN var_dataNascita      DATE,
    IN var_idPr             INT,
    IN var_password         VARCHAR(45)
)
BEGIN
    DECLARE var_pt_count INT;

    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

    SELECT COUNT(*) INTO var_pt_count
    FROM PersonalTrainer
    WHERE idPr = var_idPr;

    IF var_pt_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Personal Trainer non trovato.';
    END IF;

    INSERT INTO Utenti (email, password, ruolo)
    VALUES (var_email, SHA2(var_password, 256), 'atleta');

    INSERT INTO Atleta (nome, cognome, cf, email, dataNascita, idPr)
    VALUES (var_nome, var_cognome, var_cf, var_email, var_dataNascita, var_idPr);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inserisci_attrezzatura` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserisci_attrezzatura`(
    IN var_nome         VARCHAR(100),
    IN var_descrizione  TEXT,
    IN var_dataAcquisto DATE
)
BEGIN
    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;

    INSERT INTO Attrezzatura (nome, descrizione, dataAcquisto)
    VALUES (var_nome, var_descrizione, var_dataAcquisto);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inserisci_esercizio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserisci_esercizio`(
    IN var_nome             VARCHAR(100),
    IN var_descrizione      TEXT,
    IN var_gruppoMuscolare  VARCHAR(100),
    IN var_idAttrezzatura   INT          -- NULL se corpo libero
)
BEGIN
    DECLARE var_attr_count  INT;

    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;

    -- Verifica attrezzatura solo se specificata
    IF var_idAttrezzatura IS NOT NULL THEN
        SELECT COUNT(*) INTO var_attr_count
        FROM Attrezzatura
        WHERE idAttrezzatura = var_idAttrezzatura;

        IF var_attr_count = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Attrezzatura non trovata.';
        END IF;
    END IF;

    INSERT INTO Esercizio (nome, descrizione, gruppoMuscolare, idAttrezzatura)
    VALUES (var_nome, var_descrizione, var_gruppoMuscolare, var_idAttrezzatura);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inserisci_personal_trainer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserisci_personal_trainer`(
    IN var_nome             VARCHAR(50),
    IN var_cognome          VARCHAR(50),
    IN var_email            VARCHAR(100),
    IN var_specializzazione VARCHAR(100),
    IN var_password         VARCHAR(45)
)
BEGIN
    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

    INSERT INTO Utenti (email, password, ruolo)
    VALUES (var_email, SHA2(var_password, 256), 'personal_trainer');

    INSERT INTO PersonalTrainer (nome, cognome, email, specializzazione)
    VALUES (var_nome, var_cognome, var_email, var_specializzazione);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lista_atleti` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_atleti`()
BEGIN
    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET TRANSACTION READ ONLY;
    START TRANSACTION;

    SELECT
        a.idAtleta,
        a.nome              AS nomeAtleta,
        a.cognome           AS cognomeAtleta,
        a.cf,
        a.email             AS emailAtleta,
        a.dataNascita,
        a.dataIscrizione,
        pt.idPr,
        pt.nome             AS nomePT,
        pt.cognome          AS cognomePT
    FROM Atleta a
             JOIN PersonalTrainer pt ON pt.idPr = a.idPr
    ORDER BY a.cognome, a.nome;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lista_clienti` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_clienti`(
    IN var_idPr INT
)
BEGIN
    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET TRANSACTION READ ONLY;
    START TRANSACTION;

    SELECT
        a.idAtleta,
        a.nome,
        a.cognome,
        a.cf,
        a.email,
        a.dataNascita,
        a.dataIscrizione,
        -- Mostra se l atleta ha una scheda corrente
        CASE
            WHEN EXISTS (
                SELECT 1 FROM Scheda s
                WHERE s.idAtleta          = a.idAtleta
                  AND s.dataArchiviazione IS NULL
            )
                THEN 'SI'
            ELSE 'NO'
            END AS haSchedaCorrente
    FROM Atleta a
    WHERE a.idPr = var_idPr
    ORDER BY a.cognome, a.nome;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lista_esercizi_disponibili` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_esercizi_disponibili`()
BEGIN
    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET TRANSACTION READ ONLY;
    START TRANSACTION;

    SELECT
        e.idEsercizio,
        e.nome,
        e.descrizione,
        e.gruppoMuscolare,
        COALESCE(a.nome, 'Corpo libero') AS attrezzatura,
        a.idAttrezzatura
    FROM Esercizio e
             LEFT JOIN Attrezzatura a ON a.idAttrezzatura = e.idAttrezzatura
    ORDER BY e.gruppoMuscolare, e.nome;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lista_personal_trainer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_personal_trainer`()
BEGIN
    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET TRANSACTION READ ONLY;
    START TRANSACTION;

    SELECT
        pt.idPr,
        pt.nome,
        pt.cognome,
        pt.email,
        pt.specializzazione,
        COUNT(a.idAtleta) AS numClienti
    FROM PersonalTrainer pt
             LEFT JOIN Atleta a ON a.idPr = pt.idPr
    GROUP BY pt.idPr, pt.nome, pt.cognome, pt.email, pt.specializzazione
    ORDER BY numClienti DESC;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `login`(
    IN  var_email    VARCHAR(100),
    IN  var_pass     VARCHAR(45),
    OUT var_role     INT
)
BEGIN
    DECLARE var_ruolo ENUM('proprietario','personal_trainer','atleta');

    SELECT ruolo INTO var_ruolo
    FROM   Utenti
    WHERE  email    = var_email
      AND  password = SHA2(var_pass, 256);

    IF    var_ruolo = 'proprietario'      THEN SET var_role = 1;
    ELSEIF var_ruolo = 'personal_trainer' THEN SET var_role = 2;
    ELSEIF var_ruolo = 'atleta'           THEN SET var_role = 3;
    ELSE                                       SET var_role = 0;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_sessioni` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `report_sessioni`(
    IN var_idPr         INT,
    IN var_dataInizio   DATE,
    IN var_dataFine     DATE
)
BEGIN
    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    SET TRANSACTION READ ONLY;
    START TRANSACTION;

    SELECT
        a.idAtleta,
        a.nome                                          AS nomeAtleta,
        a.cognome                                       AS cognomeAtleta,
        al.idAllenamento,
        al.data,
        al.oraInizio,
        al.oraFine,
        TIMEDIFF(al.oraFine, al.oraInizio)              AS durata,
        al.percentualeCompletamento,
        -- Conteggio sessioni per atleta nell intervallo
        COUNT(al.idAllenamento) OVER (
            PARTITION BY a.idAtleta
            )                                               AS totSessioniAtleta
    FROM Atleta a
             JOIN Scheda       s  ON s.idAtleta  = a.idAtleta
             JOIN Allenamento  al ON al.idScheda = s.idScheda
    WHERE a.idPr    =  var_idPr
      AND al.data  BETWEEN var_dataInizio AND var_dataFine
    ORDER BY a.cognome, a.nome, al.data, al.oraInizio;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `svolgi_esercizio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `svolgi_esercizio`(
    IN var_idAtleta     INT,
    IN var_idAllenamento INT,
    IN var_idEsercizio  INT,
    IN var_completato   TINYINT(1)  -- 1 = completato, 0 = saltato
)
BEGIN
    DECLARE var_all_count   INT;
    DECLARE var_ese_count   INT;
    DECLARE var_gia_svolto  INT;
    DECLARE var_perc        TINYINT;

    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

    -- Verifica che l allenamento appartenga all atleta
    SELECT COUNT(*) INTO var_all_count
    FROM Allenamento  al
             JOIN Scheda        s  ON s.idScheda  = al.idScheda
    WHERE al.idAllenamento = var_idAllenamento
      AND s.idAtleta       = var_idAtleta;

    IF var_all_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Allenamento non trovato o non di tua proprieta.';
    END IF;

    -- Verifica che l esercizio appartenga alla scheda
    SELECT COUNT(*) INTO var_ese_count
    FROM Allenamento        al
             JOIN EsercizioScheda    es  ON es.idScheda      = al.idScheda
    WHERE al.idAllenamento  = var_idAllenamento
      AND es.idEsercizio    = var_idEsercizio;

    IF var_ese_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Esercizio non presente in questa scheda.';
    END IF;

    -- Verifica che l esercizio non sia già stato registrato
    SELECT COUNT(*) INTO var_gia_svolto
    FROM EsercizioSvolto
    WHERE idAllenamento = var_idAllenamento
      AND idEsercizio   = var_idEsercizio;

    IF var_gia_svolto > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Esercizio gia registrato. Non e possibile modificarlo.';
    END IF;

    -- Determina la percentuale in base al flag
    SET var_perc = CASE WHEN var_completato = 1 THEN 100 ELSE 0 END;

    INSERT INTO EsercizioSvolto (idAllenamento, idEsercizio, percCompletamento)
    VALUES (var_idAllenamento, var_idEsercizio, var_perc);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `termina_allenamento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `termina_allenamento`(
    IN var_idAtleta         INT,
    IN var_idAllenamento    INT,
    IN var_oraFine          TIME
)
BEGIN
    DECLARE var_count           INT;
    DECLARE var_totEsercizi     INT;
    DECLARE var_completati      INT;
    DECLARE var_percentuale     TINYINT;
    DECLARE var_oraInizio       TIME;

    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

    -- Verifica che l allenamento appartenga all atleta
    SELECT COUNT(*) INTO var_count
    FROM Allenamento  al
             JOIN Scheda        s ON s.idScheda = al.idScheda
    WHERE al.idAllenamento = var_idAllenamento
      AND s.idAtleta       = var_idAtleta;

    IF var_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Allenamento non trovato o non di tua proprieta.';
    END IF;

    -- Recupera ora di inizio per validare ora di fine
    SELECT oraInizio INTO var_oraInizio
    FROM Allenamento
    WHERE idAllenamento = var_idAllenamento;

    IF var_oraFine <= var_oraInizio THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L ora di fine deve essere successiva all ora di inizio.';
    END IF;

    -- Calcola totale esercizi nella scheda
    SELECT COUNT(*) INTO var_totEsercizi
    FROM Allenamento        al
             JOIN EsercizioScheda    es ON es.idScheda = al.idScheda
    WHERE al.idAllenamento = var_idAllenamento;

    -- Calcola esercizi completati (percCompletamento = 100)
    SELECT COUNT(*) INTO var_completati
    FROM EsercizioSvolto
    WHERE idAllenamento     = var_idAllenamento
      AND percCompletamento = 100;

    -- Calcola percentuale (gestisce divisione per zero)
    SET var_percentuale = CASE
                              WHEN var_totEsercizi = 0 THEN 0
                              ELSE ROUND((var_completati / var_totEsercizi) * 100)
        END;

    -- Aggiorna l allenamento con ora fine e percentuale
    UPDATE Allenamento
    SET oraFine                  = var_oraFine,
        percentualeCompletamento = var_percentuale
    WHERE idAllenamento = var_idAllenamento;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `visualizza_scheda_archiviata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizza_scheda_archiviata`(
    IN var_idAtleta INT,
    IN var_idScheda INT
)
BEGIN
    DECLARE var_count INT;

    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET TRANSACTION READ ONLY;
    START TRANSACTION;

    -- Verifica che la scheda esista, sia dell atleta e sia archiviata
    SELECT COUNT(*) INTO var_count
    FROM Scheda
    WHERE idScheda          = var_idScheda
      AND idAtleta          = var_idAtleta
      AND dataArchiviazione IS NOT NULL;

    IF var_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Scheda non trovata, non archiviata o non di tua proprieta.';
    END IF;

    SELECT
        s.idScheda,
        s.dataCreazione,
        s.dataArchiviazione,
        pt.nome                             AS nomePT,
        pt.cognome                          AS cognomePT,
        es.numero,
        e.idEsercizio,
        e.nome                              AS nomeEsercizio,
        e.descrizione,
        e.gruppoMuscolare,
        es.serie,
        es.ripetizioni,
        es.peso,
        COALESCE(a.nome, 'Corpo libero')    AS attrezzatura
    FROM Scheda             s
             JOIN PersonalTrainer    pt  ON pt.idPr           = s.idPr
             JOIN EsercizioScheda    es  ON es.idScheda        = s.idScheda
             JOIN Esercizio          e   ON e.idEsercizio      = es.idEsercizio
             LEFT JOIN Attrezzatura  a   ON a.idAttrezzatura   = e.idAttrezzatura
    WHERE s.idScheda = var_idScheda
    ORDER BY es.numero;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `visualizza_scheda_corrente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizza_scheda_corrente`(
    IN var_idAtleta INT
)
BEGIN
    DECLARE var_scheda_count INT;

    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET TRANSACTION READ ONLY;
    START TRANSACTION;

    -- Verifica che esista una scheda corrente
    SELECT COUNT(*) INTO var_scheda_count
    FROM Scheda
    WHERE idAtleta          = var_idAtleta
      AND dataArchiviazione IS NULL;

    IF var_scheda_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nessuna scheda corrente trovata per questo atleta.';
    END IF;

    SELECT
        s.idScheda,
        s.dataCreazione,
        pt.nome                             AS nomePT,
        pt.cognome                          AS cognomePT,
        es.numero,
        e.idEsercizio,
        e.nome                              AS nomeEsercizio,
        e.descrizione,
        e.gruppoMuscolare,
        es.serie,
        es.ripetizioni,
        es.peso,
        COALESCE(a.nome, 'Corpo libero')    AS attrezzatura
    FROM Scheda             s
             JOIN PersonalTrainer    pt  ON pt.idPr           = s.idPr
             JOIN EsercizioScheda    es  ON es.idScheda        = s.idScheda
             JOIN Esercizio          e   ON e.idEsercizio      = es.idEsercizio
             LEFT JOIN Attrezzatura  a   ON a.idAttrezzatura   = e.idAttrezzatura
    WHERE s.idAtleta          = var_idAtleta
      AND s.dataArchiviazione IS NULL
    ORDER BY es.numero;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `visualizza_schede_archiviate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizza_schede_archiviate`(
    IN var_idAtleta INT
)
BEGIN
    DECLARE exit HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET TRANSACTION READ ONLY;
    START TRANSACTION;

    SELECT
        s.idScheda,
        s.dataCreazione,
        s.dataArchiviazione,
        DATEDIFF(s.dataArchiviazione, s.dataCreazione)  AS durataGiorni,
        pt.nome                                          AS nomePT,
        pt.cognome                                       AS cognomePT,
        COUNT(es.idEsercizio)                            AS numEsercizi
    FROM Scheda             s
             JOIN PersonalTrainer    pt  ON pt.idPr       = s.idPr
             JOIN EsercizioScheda    es  ON es.idScheda   = s.idScheda
    WHERE s.idAtleta           = var_idAtleta
      AND s.dataArchiviazione  IS NOT NULL
    GROUP BY s.idScheda, s.dataCreazione, s.dataArchiviazione,
             pt.nome, pt.cognome
    ORDER BY s.dataArchiviazione DESC;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_report_pt`
--

/*!50001 DROP VIEW IF EXISTS `v_report_pt`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_report_pt` AS select `pt`.`idPr` AS `idPr`,`pt`.`nome` AS `nomePT`,`pt`.`cognome` AS `cognomePT`,`a`.`idAtleta` AS `idAtleta`,`a`.`nome` AS `nomeAtleta`,`a`.`cognome` AS `cognomeAtleta`,`al`.`idAllenamento` AS `idAllenamento`,`al`.`data` AS `data`,`al`.`oraInizio` AS `oraInizio`,`al`.`oraFine` AS `oraFine`,timediff(`al`.`oraFine`,`al`.`oraInizio`) AS `durata`,`al`.`percentualeCompletamento` AS `percentualeCompletamento` from (((`personaltrainer` `pt` join `atleta` `a` on((`a`.`idPr` = `pt`.`idPr`))) join `scheda` `s` on((`s`.`idAtleta` = `a`.`idAtleta`))) join `allenamento` `al` on((`al`.`idScheda` = `s`.`idScheda`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_scheda_corrente`
--

/*!50001 DROP VIEW IF EXISTS `v_scheda_corrente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_scheda_corrente` AS select `a`.`idAtleta` AS `idAtleta`,`a`.`nome` AS `nomeAtleta`,`a`.`cognome` AS `cognomeAtleta`,`s`.`idScheda` AS `idScheda`,`s`.`dataCreazione` AS `dataCreazione`,`es`.`numero` AS `numero`,`e`.`idEsercizio` AS `idEsercizio`,`e`.`nome` AS `nomeEsercizio`,`e`.`gruppoMuscolare` AS `gruppoMuscolare`,`es`.`serie` AS `serie`,`es`.`ripetizioni` AS `ripetizioni`,`es`.`peso` AS `peso`,`at`.`nome` AS `nomeAttrezzatura` from ((((`atleta` `a` join `scheda` `s` on(((`s`.`idAtleta` = `a`.`idAtleta`) and (`s`.`dataArchiviazione` is null)))) join `esercizioscheda` `es` on((`es`.`idScheda` = `s`.`idScheda`))) join `esercizio` `e` on((`e`.`idEsercizio` = `es`.`idEsercizio`))) left join `attrezzatura` `at` on((`at`.`idAttrezzatura` = `e`.`idAttrezzatura`))) order by `a`.`idAtleta`,`es`.`numero` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-21 21:02:45

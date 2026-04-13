-- MySQL dump 10.16  Distrib 10.2.22-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: 
-- ------------------------------------------------------
-- Server version	10.2.22-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `ambari`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ambari` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `ambari`;

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--
-- Current Database: `druid`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `druid` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `druid`;

--

--

--

--

--

--

--

--

--

--

--
-- Current Database: `hive`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hive` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `hive`;

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--
-- Current Database: `mysql`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mysql` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `mysql`;

--

--

--

--

--

--

--

--

--
/*!40000 ALTER TABLE `help_topic` ENABLE KEYS */;

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--
/*!40000 ALTER TABLE `help_topic` ENABLE KEYS */;

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--
-- Current Database: `oozie`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `oozie` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `oozie`;

--

--

--

--

--

--

--

--

--

--

--

--

--
-- Current Database: `ranger`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ranger` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `ranger`;

--
-- Temporary table structure for view `vx_trx_log`
--

DROP TABLE IF EXISTS `vx_trx_log`;
/*!50001 DROP VIEW IF EXISTS `vx_trx_log`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vx_trx_log` (
  `id` tinyint NOT NULL,
  `create_time` tinyint NOT NULL,
  `update_time` tinyint NOT NULL,
  `added_by_id` tinyint NOT NULL,
  `upd_by_id` tinyint NOT NULL,
  `class_type` tinyint NOT NULL,
  `object_id` tinyint NOT NULL,
  `parent_object_id` tinyint NOT NULL,
  `parent_object_class_type` tinyint NOT NULL,
  `attr_name` tinyint NOT NULL,
  `parent_object_name` tinyint NOT NULL,
  `object_name` tinyint NOT NULL,
  `prev_val` tinyint NOT NULL,
  `new_val` tinyint NOT NULL,
  `trx_id` tinyint NOT NULL,
  `action` tinyint NOT NULL,
  `sess_id` tinyint NOT NULL,
  `req_id` tinyint NOT NULL,
  `sess_type` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--

--
-- Current Database: `rangerkms`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rangerkms` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `rangerkms`;

--

--

--
-- Current Database: `superset`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `superset` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `superset`;

--
-- Current Database: `test`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `test` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `test`;

--
-- Current Database: `ambari`
--

USE `ambari`;

--
-- Current Database: `druid`
--

USE `druid`;

--
-- Current Database: `hive`
--

USE `hive`;

--
-- Current Database: `mysql`
--

USE `mysql`;

--
-- Current Database: `mysql2`
--

USE `mysql2`;

--
-- Current Database: `oozie`
--

USE `oozie`;

--
-- Current Database: `ranger`
--

USE `ranger`;

--
-- Final view structure for view `vx_trx_log`
--

/*!50001 DROP TABLE IF EXISTS `vx_trx_log`*/;
/*!50001 DROP VIEW IF EXISTS `vx_trx_log`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ranger`@`%.gp.inet` SQL SECURITY DEFINER */
/*!50001 VIEW `vx_trx_log` AS select `x_trx_log`.`id` AS `id`,`x_trx_log`.`create_time` AS `create_time`,`x_trx_log`.`update_time` AS `update_time`,`x_trx_log`.`added_by_id` AS `added_by_id`,`x_trx_log`.`upd_by_id` AS `upd_by_id`,`x_trx_log`.`class_type` AS `class_type`,`x_trx_log`.`object_id` AS `object_id`,`x_trx_log`.`parent_object_id` AS `parent_object_id`,`x_trx_log`.`parent_object_class_type` AS `parent_object_class_type`,`x_trx_log`.`attr_name` AS `attr_name`,`x_trx_log`.`parent_object_name` AS `parent_object_name`,`x_trx_log`.`object_name` AS `object_name`,`x_trx_log`.`prev_val` AS `prev_val`,`x_trx_log`.`new_val` AS `new_val`,`x_trx_log`.`trx_id` AS `trx_id`,`x_trx_log`.`action` AS `action`,`x_trx_log`.`sess_id` AS `sess_id`,`x_trx_log`.`req_id` AS `req_id`,`x_trx_log`.`sess_type` AS `sess_type` from `x_trx_log` where `x_trx_log`.`id` in (select min(`x_trx_log`.`id`) from `x_trx_log` group by `x_trx_log`.`trx_id`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Current Database: `rangerkms`
--

USE `rangerkms`;

--
-- Current Database: `superset`
--

USE `superset`;

--
-- Current Database: `test`
--

USE `test`;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-07  2:27:35

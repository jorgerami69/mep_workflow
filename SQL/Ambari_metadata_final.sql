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
-- Table structure for table `ClusterHostMapping`
--

DROP TABLE IF EXISTS `ClusterHostMapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ClusterHostMapping` (
  `cluster_id` bigint(20) NOT NULL,
  `host_id` bigint(20) NOT NULL,
  PRIMARY KEY (`cluster_id`,`host_id`),
  KEY `FK_clusterhostmapping_host_id` (`host_id`),
  CONSTRAINT `FK_clhostmapping_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`cluster_id`),
  CONSTRAINT `FK_clusterhostmapping_host_id` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ClusterHostMapping`
--

/*!40000 ALTER TABLE `ClusterHostMapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `ClusterHostMapping` ENABLE KEYS */;

--
-- Table structure for table `QRTZ_BLOB_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QRTZ_BLOB_TRIGGERS` (
  `SCHED_NAME` varchar(100) NOT NULL,
  `TRIGGER_NAME` varchar(100) NOT NULL,
  `TRIGGER_GROUP` varchar(100) NOT NULL,
  `BLOB_DATA` blob DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_BLOB_TRIGGERS`
--

/*!40000 ALTER TABLE `QRTZ_BLOB_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_BLOB_TRIGGERS` ENABLE KEYS */;

--
-- Table structure for table `QRTZ_CALENDARS`
--

DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QRTZ_CALENDARS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `CALENDAR_NAME` varchar(200) NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_CALENDARS`
--

/*!40000 ALTER TABLE `QRTZ_CALENDARS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_CALENDARS` ENABLE KEYS */;

--
-- Table structure for table `QRTZ_CRON_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QRTZ_CRON_TRIGGERS` (
  `SCHED_NAME` varchar(100) NOT NULL,
  `TRIGGER_NAME` varchar(100) NOT NULL,
  `TRIGGER_GROUP` varchar(100) NOT NULL,
  `CRON_EXPRESSION` varchar(200) NOT NULL,
  `TIME_ZONE_ID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_CRON_TRIGGERS`
--

/*!40000 ALTER TABLE `QRTZ_CRON_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_CRON_TRIGGERS` ENABLE KEYS */;

--
-- Table structure for table `QRTZ_FIRED_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QRTZ_FIRED_TRIGGERS` (
  `SCHED_NAME` varchar(100) NOT NULL,
  `ENTRY_ID` varchar(95) NOT NULL,
  `TRIGGER_NAME` varchar(100) NOT NULL,
  `TRIGGER_GROUP` varchar(100) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `SCHED_TIME` bigint(13) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STATE` varchar(16) NOT NULL,
  `JOB_NAME` varchar(100) DEFAULT NULL,
  `JOB_GROUP` varchar(100) DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`),
  KEY `idx_qrtz_ft_trig_inst_name` (`SCHED_NAME`,`INSTANCE_NAME`),
  KEY `idx_qrtz_ft_inst_job_req_rcvry` (`SCHED_NAME`,`INSTANCE_NAME`,`REQUESTS_RECOVERY`),
  KEY `idx_qrtz_ft_j_g` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `idx_qrtz_ft_jg` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `idx_qrtz_ft_t_g` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `idx_qrtz_ft_tg` (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_FIRED_TRIGGERS`
--

/*!40000 ALTER TABLE `QRTZ_FIRED_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_FIRED_TRIGGERS` ENABLE KEYS */;

--
-- Table structure for table `QRTZ_JOB_DETAILS`
--

DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QRTZ_JOB_DETAILS` (
  `SCHED_NAME` varchar(100) NOT NULL,
  `JOB_NAME` varchar(100) NOT NULL,
  `JOB_GROUP` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) NOT NULL,
  `IS_DURABLE` varchar(1) NOT NULL,
  `IS_NONCONCURRENT` varchar(1) NOT NULL,
  `IS_UPDATE_DATA` varchar(1) NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) NOT NULL,
  `JOB_DATA` blob DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `idx_qrtz_j_req_recovery` (`SCHED_NAME`,`REQUESTS_RECOVERY`),
  KEY `idx_qrtz_j_grp` (`SCHED_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_JOB_DETAILS`
--

/*!40000 ALTER TABLE `QRTZ_JOB_DETAILS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_JOB_DETAILS` ENABLE KEYS */;

--
-- Table structure for table `QRTZ_LOCKS`
--

DROP TABLE IF EXISTS `QRTZ_LOCKS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QRTZ_LOCKS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_LOCKS`
--

/*!40000 ALTER TABLE `QRTZ_LOCKS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_LOCKS` ENABLE KEYS */;

--
-- Table structure for table `QRTZ_PAUSED_TRIGGER_GRPS`
--

DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_PAUSED_TRIGGER_GRPS`
--

/*!40000 ALTER TABLE `QRTZ_PAUSED_TRIGGER_GRPS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_PAUSED_TRIGGER_GRPS` ENABLE KEYS */;

--
-- Table structure for table `QRTZ_SCHEDULER_STATE`
--

DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QRTZ_SCHEDULER_STATE` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL,
  `CHECKIN_INTERVAL` bigint(13) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_SCHEDULER_STATE`
--

/*!40000 ALTER TABLE `QRTZ_SCHEDULER_STATE` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_SCHEDULER_STATE` ENABLE KEYS */;

--
-- Table structure for table `QRTZ_SIMPLE_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QRTZ_SIMPLE_TRIGGERS` (
  `SCHED_NAME` varchar(100) NOT NULL,
  `TRIGGER_NAME` varchar(100) NOT NULL,
  `TRIGGER_GROUP` varchar(100) NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL,
  `REPEAT_INTERVAL` bigint(12) NOT NULL,
  `TIMES_TRIGGERED` bigint(10) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_SIMPLE_TRIGGERS`
--

/*!40000 ALTER TABLE `QRTZ_SIMPLE_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_SIMPLE_TRIGGERS` ENABLE KEYS */;

--
-- Table structure for table `QRTZ_SIMPROP_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QRTZ_SIMPROP_TRIGGERS` (
  `SCHED_NAME` varchar(100) NOT NULL,
  `TRIGGER_NAME` varchar(100) NOT NULL,
  `TRIGGER_GROUP` varchar(100) NOT NULL,
  `STR_PROP_1` varchar(512) DEFAULT NULL,
  `STR_PROP_2` varchar(512) DEFAULT NULL,
  `STR_PROP_3` varchar(512) DEFAULT NULL,
  `INT_PROP_1` int(11) DEFAULT NULL,
  `INT_PROP_2` int(11) DEFAULT NULL,
  `LONG_PROP_1` bigint(20) DEFAULT NULL,
  `LONG_PROP_2` bigint(20) DEFAULT NULL,
  `DEC_PROP_1` decimal(13,4) DEFAULT NULL,
  `DEC_PROP_2` decimal(13,4) DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_SIMPROP_TRIGGERS`
--

/*!40000 ALTER TABLE `QRTZ_SIMPROP_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_SIMPROP_TRIGGERS` ENABLE KEYS */;

--
-- Table structure for table `QRTZ_TRIGGERS`
--

DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QRTZ_TRIGGERS` (
  `SCHED_NAME` varchar(100) NOT NULL,
  `TRIGGER_NAME` varchar(100) NOT NULL,
  `TRIGGER_GROUP` varchar(100) NOT NULL,
  `JOB_NAME` varchar(100) NOT NULL,
  `JOB_GROUP` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PREV_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PRIORITY` int(11) DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) NOT NULL,
  `TRIGGER_TYPE` varchar(8) NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) DEFAULT NULL,
  `MISFIRE_INSTR` smallint(2) DEFAULT NULL,
  `JOB_DATA` blob DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `idx_qrtz_t_j` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `idx_qrtz_t_jg` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `idx_qrtz_t_c` (`SCHED_NAME`,`CALENDAR_NAME`),
  KEY `idx_qrtz_t_g` (`SCHED_NAME`,`TRIGGER_GROUP`),
  KEY `idx_qrtz_t_state` (`SCHED_NAME`,`TRIGGER_STATE`),
  KEY `idx_qrtz_t_n_state` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `idx_qrtz_t_n_g_state` (`SCHED_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `idx_qrtz_t_next_fire_time` (`SCHED_NAME`,`NEXT_FIRE_TIME`),
  KEY `idx_qrtz_t_nft_st` (`SCHED_NAME`,`TRIGGER_STATE`,`NEXT_FIRE_TIME`),
  KEY `idx_qrtz_t_nft_misfire` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`),
  KEY `idx_qrtz_t_nft_st_misfire` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_STATE`),
  KEY `idx_qrtz_t_nft_st_misfire_grp` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `QRTZ_JOB_DETAILS` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QRTZ_TRIGGERS`
--

/*!40000 ALTER TABLE `QRTZ_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QRTZ_TRIGGERS` ENABLE KEYS */;

--
-- Table structure for table `adminpermission`
--

DROP TABLE IF EXISTS `adminpermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adminpermission` (
  `permission_id` bigint(20) NOT NULL,
  `permission_name` varchar(255) NOT NULL,
  `resource_type_id` int(11) NOT NULL,
  `permission_label` varchar(255) DEFAULT NULL,
  `principal_id` bigint(20) NOT NULL,
  `sort_order` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `UQ_perm_name_resource_type_id` (`permission_name`,`resource_type_id`),
  KEY `FK_permission_resource_type_id` (`resource_type_id`),
  KEY `FK_permission_principal_id` (`principal_id`),
  CONSTRAINT `FK_permission_principal_id` FOREIGN KEY (`principal_id`) REFERENCES `adminprincipal` (`principal_id`),
  CONSTRAINT `FK_permission_resource_type_id` FOREIGN KEY (`resource_type_id`) REFERENCES `adminresourcetype` (`resource_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminpermission`
--

/*!40000 ALTER TABLE `adminpermission` DISABLE KEYS */;
/*!40000 ALTER TABLE `adminpermission` ENABLE KEYS */;

--
-- Table structure for table `adminprincipal`
--

DROP TABLE IF EXISTS `adminprincipal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adminprincipal` (
  `principal_id` bigint(20) NOT NULL,
  `principal_type_id` int(11) NOT NULL,
  PRIMARY KEY (`principal_id`),
  KEY `FK_principal_principal_type_id` (`principal_type_id`),
  CONSTRAINT `FK_principal_principal_type_id` FOREIGN KEY (`principal_type_id`) REFERENCES `adminprincipaltype` (`principal_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminprincipal`
--

/*!40000 ALTER TABLE `adminprincipal` DISABLE KEYS */;
/*!40000 ALTER TABLE `adminprincipal` ENABLE KEYS */;

--
-- Table structure for table `adminprincipaltype`
--

DROP TABLE IF EXISTS `adminprincipaltype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adminprincipaltype` (
  `principal_type_id` int(11) NOT NULL,
  `principal_type_name` varchar(255) NOT NULL,
  PRIMARY KEY (`principal_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminprincipaltype`
--

/*!40000 ALTER TABLE `adminprincipaltype` DISABLE KEYS */;
/*!40000 ALTER TABLE `adminprincipaltype` ENABLE KEYS */;

--
-- Table structure for table `adminprivilege`
--

DROP TABLE IF EXISTS `adminprivilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adminprivilege` (
  `privilege_id` bigint(20) NOT NULL,
  `permission_id` bigint(20) NOT NULL,
  `resource_id` bigint(20) NOT NULL,
  `principal_id` bigint(20) NOT NULL,
  PRIMARY KEY (`privilege_id`),
  KEY `FK_privilege_permission_id` (`permission_id`),
  KEY `FK_privilege_principal_id` (`principal_id`),
  KEY `FK_privilege_resource_id` (`resource_id`),
  CONSTRAINT `FK_privilege_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `adminpermission` (`permission_id`),
  CONSTRAINT `FK_privilege_principal_id` FOREIGN KEY (`principal_id`) REFERENCES `adminprincipal` (`principal_id`),
  CONSTRAINT `FK_privilege_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `adminresource` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminprivilege`
--

/*!40000 ALTER TABLE `adminprivilege` DISABLE KEYS */;
/*!40000 ALTER TABLE `adminprivilege` ENABLE KEYS */;

--
-- Table structure for table `adminresource`
--

DROP TABLE IF EXISTS `adminresource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adminresource` (
  `resource_id` bigint(20) NOT NULL,
  `resource_type_id` int(11) NOT NULL,
  PRIMARY KEY (`resource_id`),
  KEY `FK_resource_resource_type_id` (`resource_type_id`),
  CONSTRAINT `FK_resource_resource_type_id` FOREIGN KEY (`resource_type_id`) REFERENCES `adminresourcetype` (`resource_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminresource`
--

/*!40000 ALTER TABLE `adminresource` DISABLE KEYS */;
/*!40000 ALTER TABLE `adminresource` ENABLE KEYS */;

--
-- Table structure for table `adminresourcetype`
--

DROP TABLE IF EXISTS `adminresourcetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adminresourcetype` (
  `resource_type_id` int(11) NOT NULL,
  `resource_type_name` varchar(255) NOT NULL,
  PRIMARY KEY (`resource_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminresourcetype`
--

/*!40000 ALTER TABLE `adminresourcetype` DISABLE KEYS */;
/*!40000 ALTER TABLE `adminresourcetype` ENABLE KEYS */;

--
-- Table structure for table `alert_current`
--

DROP TABLE IF EXISTS `alert_current`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_current` (
  `alert_id` bigint(20) NOT NULL,
  `definition_id` bigint(20) NOT NULL,
  `history_id` bigint(20) NOT NULL,
  `maintenance_state` varchar(255) NOT NULL,
  `original_timestamp` bigint(20) NOT NULL,
  `latest_timestamp` bigint(20) NOT NULL,
  `latest_text` text DEFAULT NULL,
  `occurrences` bigint(20) NOT NULL DEFAULT 1,
  `firmness` varchar(255) NOT NULL DEFAULT 'HARD',
  PRIMARY KEY (`alert_id`),
  UNIQUE KEY `history_id` (`history_id`),
  KEY `definition_id` (`definition_id`),
  CONSTRAINT `alert_current_ibfk_1` FOREIGN KEY (`definition_id`) REFERENCES `alert_definition` (`definition_id`),
  CONSTRAINT `alert_current_ibfk_2` FOREIGN KEY (`history_id`) REFERENCES `alert_history` (`alert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_current`
--

/*!40000 ALTER TABLE `alert_current` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_current` ENABLE KEYS */;

--
-- Table structure for table `alert_definition`
--

DROP TABLE IF EXISTS `alert_definition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_definition` (
  `definition_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `definition_name` varchar(255) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `component_name` varchar(255) DEFAULT NULL,
  `scope` varchar(255) NOT NULL DEFAULT 'ANY',
  `label` varchar(255) DEFAULT NULL,
  `help_url` varchar(512) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `enabled` smallint(6) NOT NULL DEFAULT 1,
  `schedule_interval` int(11) NOT NULL,
  `source_type` varchar(255) NOT NULL,
  `alert_source` text NOT NULL,
  `hash` varchar(64) NOT NULL,
  `ignore_host` smallint(6) NOT NULL DEFAULT 0,
  `repeat_tolerance` int(11) NOT NULL DEFAULT 1,
  `repeat_tolerance_enabled` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`definition_id`),
  UNIQUE KEY `uni_alert_def_name` (`cluster_id`,`definition_name`),
  CONSTRAINT `alert_definition_ibfk_1` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_definition`
--

/*!40000 ALTER TABLE `alert_definition` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_definition` ENABLE KEYS */;

--
-- Table structure for table `alert_group`
--

DROP TABLE IF EXISTS `alert_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_group` (
  `group_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `is_default` smallint(6) NOT NULL DEFAULT 0,
  `service_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`group_id`),
  UNIQUE KEY `uni_alert_group_name` (`cluster_id`,`group_name`),
  KEY `idx_alert_group_name` (`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_group`
--

/*!40000 ALTER TABLE `alert_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_group` ENABLE KEYS */;

--
-- Table structure for table `alert_group_target`
--

DROP TABLE IF EXISTS `alert_group_target`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_group_target` (
  `group_id` bigint(20) NOT NULL,
  `target_id` bigint(20) NOT NULL,
  PRIMARY KEY (`group_id`,`target_id`),
  KEY `target_id` (`target_id`),
  CONSTRAINT `alert_group_target_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `alert_group` (`group_id`),
  CONSTRAINT `alert_group_target_ibfk_2` FOREIGN KEY (`target_id`) REFERENCES `alert_target` (`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_group_target`
--

/*!40000 ALTER TABLE `alert_group_target` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_group_target` ENABLE KEYS */;

--
-- Table structure for table `alert_grouping`
--

DROP TABLE IF EXISTS `alert_grouping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_grouping` (
  `definition_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  PRIMARY KEY (`group_id`,`definition_id`),
  KEY `definition_id` (`definition_id`),
  CONSTRAINT `alert_grouping_ibfk_1` FOREIGN KEY (`definition_id`) REFERENCES `alert_definition` (`definition_id`),
  CONSTRAINT `alert_grouping_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `alert_group` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_grouping`
--

/*!40000 ALTER TABLE `alert_grouping` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_grouping` ENABLE KEYS */;

--
-- Table structure for table `alert_history`
--

DROP TABLE IF EXISTS `alert_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_history` (
  `alert_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `alert_definition_id` bigint(20) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `component_name` varchar(255) DEFAULT NULL,
  `host_name` varchar(255) DEFAULT NULL,
  `alert_instance` varchar(255) DEFAULT NULL,
  `alert_timestamp` bigint(20) NOT NULL,
  `alert_label` varchar(1024) DEFAULT NULL,
  `alert_state` varchar(255) NOT NULL,
  `alert_text` text DEFAULT NULL,
  PRIMARY KEY (`alert_id`),
  KEY `cluster_id` (`cluster_id`),
  KEY `idx_alert_history_def_id` (`alert_definition_id`),
  KEY `idx_alert_history_service` (`service_name`),
  KEY `idx_alert_history_host` (`host_name`),
  KEY `idx_alert_history_time` (`alert_timestamp`),
  KEY `idx_alert_history_state` (`alert_state`),
  CONSTRAINT `alert_history_ibfk_1` FOREIGN KEY (`alert_definition_id`) REFERENCES `alert_definition` (`definition_id`),
  CONSTRAINT `alert_history_ibfk_2` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_history`
--

/*!40000 ALTER TABLE `alert_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_history` ENABLE KEYS */;

--
-- Table structure for table `alert_notice`
--

DROP TABLE IF EXISTS `alert_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_notice` (
  `notification_id` bigint(20) NOT NULL,
  `target_id` bigint(20) NOT NULL,
  `history_id` bigint(20) NOT NULL,
  `notify_state` varchar(255) NOT NULL,
  `uuid` varchar(64) NOT NULL,
  PRIMARY KEY (`notification_id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `target_id` (`target_id`),
  KEY `history_id` (`history_id`),
  KEY `idx_alert_notice_state` (`notify_state`),
  CONSTRAINT `alert_notice_ibfk_1` FOREIGN KEY (`target_id`) REFERENCES `alert_target` (`target_id`),
  CONSTRAINT `alert_notice_ibfk_2` FOREIGN KEY (`history_id`) REFERENCES `alert_history` (`alert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_notice`
--

/*!40000 ALTER TABLE `alert_notice` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_notice` ENABLE KEYS */;

--
-- Table structure for table `alert_target`
--

DROP TABLE IF EXISTS `alert_target`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_target` (
  `target_id` bigint(20) NOT NULL,
  `target_name` varchar(255) NOT NULL,
  `notification_type` varchar(64) NOT NULL,
  `properties` text DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `is_global` smallint(6) NOT NULL DEFAULT 0,
  `is_enabled` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`target_id`),
  UNIQUE KEY `target_name` (`target_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_target`
--

/*!40000 ALTER TABLE `alert_target` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_target` ENABLE KEYS */;

--
-- Table structure for table `alert_target_states`
--

DROP TABLE IF EXISTS `alert_target_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_target_states` (
  `target_id` bigint(20) NOT NULL,
  `alert_state` varchar(255) NOT NULL,
  KEY `target_id` (`target_id`),
  CONSTRAINT `alert_target_states_ibfk_1` FOREIGN KEY (`target_id`) REFERENCES `alert_target` (`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_target_states`
--

/*!40000 ALTER TABLE `alert_target_states` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_target_states` ENABLE KEYS */;

--
-- Table structure for table `ambari_configuration`
--

DROP TABLE IF EXISTS `ambari_configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ambari_configuration` (
  `category_name` varchar(100) NOT NULL,
  `property_name` varchar(100) NOT NULL,
  `property_value` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`category_name`,`property_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ambari_configuration`
--

/*!40000 ALTER TABLE `ambari_configuration` DISABLE KEYS */;
/*!40000 ALTER TABLE `ambari_configuration` ENABLE KEYS */;

--
-- Table structure for table `ambari_operation_history`
--

DROP TABLE IF EXISTS `ambari_operation_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ambari_operation_history` (
  `id` bigint(20) NOT NULL,
  `from_version` varchar(255) NOT NULL,
  `to_version` varchar(255) NOT NULL,
  `start_time` bigint(20) NOT NULL,
  `end_time` bigint(20) DEFAULT NULL,
  `operation_type` varchar(255) NOT NULL,
  `comments` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ambari_operation_history`
--

/*!40000 ALTER TABLE `ambari_operation_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `ambari_operation_history` ENABLE KEYS */;

--
-- Table structure for table `ambari_sequences`
--

DROP TABLE IF EXISTS `ambari_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ambari_sequences` (
  `sequence_name` varchar(255) NOT NULL,
  `sequence_value` decimal(38,0) NOT NULL,
  PRIMARY KEY (`sequence_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ambari_sequences`
--

/*!40000 ALTER TABLE `ambari_sequences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ambari_sequences` ENABLE KEYS */;

--
-- Table structure for table `artifact`
--

DROP TABLE IF EXISTS `artifact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artifact` (
  `artifact_name` varchar(100) NOT NULL,
  `foreign_keys` varchar(100) NOT NULL,
  `artifact_data` longtext NOT NULL,
  PRIMARY KEY (`artifact_name`,`foreign_keys`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artifact`
--

/*!40000 ALTER TABLE `artifact` DISABLE KEYS */;
/*!40000 ALTER TABLE `artifact` ENABLE KEYS */;

--
-- Table structure for table `blueprint`
--

DROP TABLE IF EXISTS `blueprint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blueprint` (
  `blueprint_name` varchar(100) NOT NULL,
  `stack_id` bigint(20) NOT NULL,
  `security_type` varchar(32) NOT NULL DEFAULT 'NONE',
  `security_descriptor_reference` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`blueprint_name`),
  KEY `FK_blueprint_stack_id` (`stack_id`),
  CONSTRAINT `FK_blueprint_stack_id` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`stack_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blueprint`
--

/*!40000 ALTER TABLE `blueprint` DISABLE KEYS */;
/*!40000 ALTER TABLE `blueprint` ENABLE KEYS */;

--
-- Table structure for table `blueprint_configuration`
--

DROP TABLE IF EXISTS `blueprint_configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blueprint_configuration` (
  `blueprint_name` varchar(100) NOT NULL,
  `type_name` varchar(100) NOT NULL,
  `config_data` longtext NOT NULL,
  `config_attributes` longtext DEFAULT NULL,
  PRIMARY KEY (`blueprint_name`,`type_name`),
  CONSTRAINT `FK_cfg_blueprint_name` FOREIGN KEY (`blueprint_name`) REFERENCES `blueprint` (`blueprint_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blueprint_configuration`
--

/*!40000 ALTER TABLE `blueprint_configuration` DISABLE KEYS */;
/*!40000 ALTER TABLE `blueprint_configuration` ENABLE KEYS */;

--
-- Table structure for table `blueprint_setting`
--

DROP TABLE IF EXISTS `blueprint_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blueprint_setting` (
  `id` bigint(20) NOT NULL,
  `blueprint_name` varchar(100) NOT NULL,
  `setting_name` varchar(100) NOT NULL,
  `setting_data` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_blueprint_setting_name` (`blueprint_name`,`setting_name`),
  CONSTRAINT `FK_blueprint_setting_name` FOREIGN KEY (`blueprint_name`) REFERENCES `blueprint` (`blueprint_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blueprint_setting`
--

/*!40000 ALTER TABLE `blueprint_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `blueprint_setting` ENABLE KEYS */;

--
-- Table structure for table `clusterconfig`
--

DROP TABLE IF EXISTS `clusterconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clusterconfig` (
  `config_id` bigint(20) NOT NULL,
  `version_tag` varchar(100) NOT NULL,
  `version` bigint(20) NOT NULL,
  `type_name` varchar(100) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `stack_id` bigint(20) NOT NULL,
  `selected` smallint(6) NOT NULL DEFAULT 0,
  `config_data` longtext NOT NULL,
  `config_attributes` longtext DEFAULT NULL,
  `create_timestamp` bigint(20) NOT NULL,
  `unmapped` smallint(6) NOT NULL DEFAULT 0,
  `selected_timestamp` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `UQ_config_type_tag` (`cluster_id`,`type_name`,`version_tag`),
  UNIQUE KEY `UQ_config_type_version` (`cluster_id`,`type_name`,`version`),
  KEY `FK_clusterconfig_stack_id` (`stack_id`),
  CONSTRAINT `FK_clusterconfig_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`cluster_id`),
  CONSTRAINT `FK_clusterconfig_stack_id` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`stack_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clusterconfig`
--

/*!40000 ALTER TABLE `clusterconfig` DISABLE KEYS */;
/*!40000 ALTER TABLE `clusterconfig` ENABLE KEYS */;

--
-- Table structure for table `clusters`
--

DROP TABLE IF EXISTS `clusters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clusters` (
  `cluster_id` bigint(20) NOT NULL,
  `resource_id` bigint(20) NOT NULL,
  `upgrade_id` bigint(20) DEFAULT NULL,
  `cluster_info` varchar(255) NOT NULL,
  `cluster_name` varchar(100) NOT NULL,
  `provisioning_state` varchar(255) NOT NULL DEFAULT 'INIT',
  `security_type` varchar(32) NOT NULL DEFAULT 'NONE',
  `desired_cluster_state` varchar(255) NOT NULL,
  `desired_stack_id` bigint(20) NOT NULL,
  PRIMARY KEY (`cluster_id`),
  UNIQUE KEY `cluster_name` (`cluster_name`),
  KEY `FK_clusters_desired_stack_id` (`desired_stack_id`),
  KEY `FK_clusters_resource_id` (`resource_id`),
  KEY `FK_clusters_upgrade_id` (`upgrade_id`),
  CONSTRAINT `FK_clusters_desired_stack_id` FOREIGN KEY (`desired_stack_id`) REFERENCES `stack` (`stack_id`),
  CONSTRAINT `FK_clusters_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `adminresource` (`resource_id`),
  CONSTRAINT `FK_clusters_upgrade_id` FOREIGN KEY (`upgrade_id`) REFERENCES `upgrade` (`upgrade_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clusters`
--

/*!40000 ALTER TABLE `clusters` DISABLE KEYS */;
/*!40000 ALTER TABLE `clusters` ENABLE KEYS */;

--
-- Table structure for table `clusterservices`
--

DROP TABLE IF EXISTS `clusterservices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clusterservices` (
  `service_name` varchar(255) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `service_enabled` int(11) NOT NULL,
  PRIMARY KEY (`service_name`,`cluster_id`),
  KEY `FK_clusterservices_cluster_id` (`cluster_id`),
  CONSTRAINT `FK_clusterservices_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clusterservices`
--

/*!40000 ALTER TABLE `clusterservices` DISABLE KEYS */;
/*!40000 ALTER TABLE `clusterservices` ENABLE KEYS */;

--
-- Table structure for table `clusterstate`
--

DROP TABLE IF EXISTS `clusterstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clusterstate` (
  `cluster_id` bigint(20) NOT NULL,
  `current_cluster_state` varchar(255) NOT NULL,
  `current_stack_id` bigint(20) NOT NULL,
  PRIMARY KEY (`cluster_id`),
  KEY `FK_cs_current_stack_id` (`current_stack_id`),
  CONSTRAINT `FK_clusterstate_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`cluster_id`),
  CONSTRAINT `FK_cs_current_stack_id` FOREIGN KEY (`current_stack_id`) REFERENCES `stack` (`stack_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clusterstate`
--

/*!40000 ALTER TABLE `clusterstate` DISABLE KEYS */;
/*!40000 ALTER TABLE `clusterstate` ENABLE KEYS */;

--
-- Table structure for table `confgroupclusterconfigmapping`
--

DROP TABLE IF EXISTS `confgroupclusterconfigmapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `confgroupclusterconfigmapping` (
  `config_group_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `config_type` varchar(100) NOT NULL,
  `version_tag` varchar(100) NOT NULL,
  `user_name` varchar(100) DEFAULT '_db',
  `create_timestamp` bigint(20) NOT NULL,
  PRIMARY KEY (`config_group_id`,`cluster_id`,`config_type`),
  KEY `FK_confg` (`cluster_id`,`config_type`,`version_tag`),
  CONSTRAINT `FK_cgccm_gid` FOREIGN KEY (`config_group_id`) REFERENCES `configgroup` (`group_id`),
  CONSTRAINT `FK_confg` FOREIGN KEY (`cluster_id`, `config_type`, `version_tag`) REFERENCES `clusterconfig` (`cluster_id`, `type_name`, `version_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `confgroupclusterconfigmapping`
--

/*!40000 ALTER TABLE `confgroupclusterconfigmapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `confgroupclusterconfigmapping` ENABLE KEYS */;

--
-- Table structure for table `configgroup`
--

DROP TABLE IF EXISTS `configgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configgroup` (
  `group_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `tag` varchar(1024) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `create_timestamp` bigint(20) NOT NULL,
  `service_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`group_id`),
  KEY `FK_configgroup_cluster_id` (`cluster_id`),
  CONSTRAINT `FK_configgroup_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configgroup`
--

/*!40000 ALTER TABLE `configgroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `configgroup` ENABLE KEYS */;

--
-- Table structure for table `configgrouphostmapping`
--

DROP TABLE IF EXISTS `configgrouphostmapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configgrouphostmapping` (
  `config_group_id` bigint(20) NOT NULL,
  `host_id` bigint(20) NOT NULL,
  PRIMARY KEY (`config_group_id`,`host_id`),
  KEY `FK_cghm_host_id` (`host_id`),
  CONSTRAINT `FK_cghm_cgid` FOREIGN KEY (`config_group_id`) REFERENCES `configgroup` (`group_id`),
  CONSTRAINT `FK_cghm_host_id` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configgrouphostmapping`
--

/*!40000 ALTER TABLE `configgrouphostmapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `configgrouphostmapping` ENABLE KEYS */;

--
-- Table structure for table `execution_command`
--

DROP TABLE IF EXISTS `execution_command`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `execution_command` (
  `task_id` bigint(20) NOT NULL,
  `command` longblob DEFAULT NULL,
  PRIMARY KEY (`task_id`),
  CONSTRAINT `FK_execution_command_task_id` FOREIGN KEY (`task_id`) REFERENCES `host_role_command` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `execution_command`
--

/*!40000 ALTER TABLE `execution_command` DISABLE KEYS */;
/*!40000 ALTER TABLE `execution_command` ENABLE KEYS */;

--
-- Table structure for table `extension`
--

DROP TABLE IF EXISTS `extension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `extension` (
  `extension_id` bigint(20) NOT NULL,
  `extension_name` varchar(100) NOT NULL,
  `extension_version` varchar(100) NOT NULL,
  PRIMARY KEY (`extension_id`),
  UNIQUE KEY `UQ_extension` (`extension_name`,`extension_version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `extension`
--

/*!40000 ALTER TABLE `extension` DISABLE KEYS */;
/*!40000 ALTER TABLE `extension` ENABLE KEYS */;

--
-- Table structure for table `extensionlink`
--

DROP TABLE IF EXISTS `extensionlink`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `extensionlink` (
  `link_id` bigint(20) NOT NULL,
  `stack_id` bigint(20) NOT NULL,
  `extension_id` bigint(20) NOT NULL,
  PRIMARY KEY (`link_id`),
  UNIQUE KEY `UQ_extension_link` (`stack_id`,`extension_id`),
  KEY `FK_extensionlink_extension_id` (`extension_id`),
  CONSTRAINT `FK_extensionlink_extension_id` FOREIGN KEY (`extension_id`) REFERENCES `extension` (`extension_id`),
  CONSTRAINT `FK_extensionlink_stack_id` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`stack_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `extensionlink`
--

/*!40000 ALTER TABLE `extensionlink` DISABLE KEYS */;
/*!40000 ALTER TABLE `extensionlink` ENABLE KEYS */;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `group_id` int(11) NOT NULL,
  `principal_id` bigint(20) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `ldap_group` int(11) NOT NULL DEFAULT 0,
  `group_type` varchar(255) NOT NULL DEFAULT 'LOCAL',
  PRIMARY KEY (`group_id`),
  UNIQUE KEY `UNQ_groups_0` (`group_name`,`ldap_group`),
  KEY `FK_groups_principal_id` (`principal_id`),
  CONSTRAINT `FK_groups_principal_id` FOREIGN KEY (`principal_id`) REFERENCES `adminprincipal` (`principal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;

--
-- Table structure for table `host_role_command`
--

DROP TABLE IF EXISTS `host_role_command`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_role_command` (
  `task_id` bigint(20) NOT NULL,
  `attempt_count` smallint(6) NOT NULL,
  `retry_allowed` smallint(6) NOT NULL DEFAULT 0,
  `event` longtext NOT NULL,
  `exitcode` int(11) NOT NULL,
  `host_id` bigint(20) DEFAULT NULL,
  `last_attempt_time` bigint(20) NOT NULL,
  `request_id` bigint(20) NOT NULL,
  `role` varchar(100) DEFAULT NULL,
  `role_command` varchar(255) DEFAULT NULL,
  `stage_id` bigint(20) NOT NULL,
  `start_time` bigint(20) NOT NULL,
  `original_start_time` bigint(20) NOT NULL,
  `end_time` bigint(20) DEFAULT NULL,
  `status` varchar(100) NOT NULL DEFAULT 'PENDING',
  `auto_skip_on_failure` smallint(6) NOT NULL DEFAULT 0,
  `std_error` longblob DEFAULT NULL,
  `std_out` longblob DEFAULT NULL,
  `output_log` varchar(255) DEFAULT NULL,
  `error_log` varchar(255) DEFAULT NULL,
  `structured_out` longblob DEFAULT NULL,
  `command_detail` varchar(255) DEFAULT NULL,
  `ops_display_name` varchar(255) DEFAULT NULL,
  `custom_command_name` varchar(255) DEFAULT NULL,
  `is_background` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`task_id`),
  KEY `FK_host_role_command_host_id` (`host_id`),
  KEY `FK_host_role_command_stage_id` (`stage_id`,`request_id`),
  KEY `idx_hrc_request_id` (`request_id`),
  KEY `idx_hrc_status_role` (`status`,`role`),
  CONSTRAINT `FK_host_role_command_host_id` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`),
  CONSTRAINT `FK_host_role_command_stage_id` FOREIGN KEY (`stage_id`, `request_id`) REFERENCES `stage` (`stage_id`, `request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_role_command`
--

/*!40000 ALTER TABLE `host_role_command` DISABLE KEYS */;
/*!40000 ALTER TABLE `host_role_command` ENABLE KEYS */;

--
-- Table structure for table `host_version`
--

DROP TABLE IF EXISTS `host_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_version` (
  `id` bigint(20) NOT NULL,
  `repo_version_id` bigint(20) NOT NULL,
  `host_id` bigint(20) NOT NULL,
  `state` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_host_repo` (`host_id`,`repo_version_id`),
  KEY `FK_host_version_repovers_id` (`repo_version_id`),
  CONSTRAINT `FK_host_version_host_id` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`),
  CONSTRAINT `FK_host_version_repovers_id` FOREIGN KEY (`repo_version_id`) REFERENCES `repo_version` (`repo_version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_version`
--

/*!40000 ALTER TABLE `host_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `host_version` ENABLE KEYS */;

--
-- Table structure for table `hostcomponentdesiredstate`
--

DROP TABLE IF EXISTS `hostcomponentdesiredstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hostcomponentdesiredstate` (
  `id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `component_name` varchar(100) NOT NULL,
  `desired_state` varchar(255) NOT NULL,
  `host_id` bigint(20) NOT NULL,
  `service_name` varchar(100) NOT NULL,
  `admin_state` varchar(32) DEFAULT NULL,
  `maintenance_state` varchar(32) NOT NULL DEFAULT 'ACTIVE',
  `blueprint_provisioning_state` varchar(255) DEFAULT 'NONE',
  `restart_required` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_hcdesiredstate_name` (`component_name`,`service_name`,`host_id`,`cluster_id`),
  KEY `FK_hcdesiredstate_host_id` (`host_id`),
  KEY `hstcmpnntdesiredstatecmpnntnme` (`component_name`,`service_name`,`cluster_id`),
  CONSTRAINT `FK_hcdesiredstate_host_id` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`),
  CONSTRAINT `hstcmpnntdesiredstatecmpnntnme` FOREIGN KEY (`component_name`, `service_name`, `cluster_id`) REFERENCES `servicecomponentdesiredstate` (`component_name`, `service_name`, `cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostcomponentdesiredstate`
--

/*!40000 ALTER TABLE `hostcomponentdesiredstate` DISABLE KEYS */;
/*!40000 ALTER TABLE `hostcomponentdesiredstate` ENABLE KEYS */;

--
-- Table structure for table `hostcomponentstate`
--

DROP TABLE IF EXISTS `hostcomponentstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hostcomponentstate` (
  `id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `component_name` varchar(100) NOT NULL,
  `version` varchar(32) NOT NULL DEFAULT 'UNKNOWN',
  `current_state` varchar(255) NOT NULL,
  `last_live_state` varchar(255) NOT NULL DEFAULT 'UNKNOWN',
  `host_id` bigint(20) NOT NULL,
  `service_name` varchar(100) NOT NULL,
  `upgrade_state` varchar(32) NOT NULL DEFAULT 'NONE',
  PRIMARY KEY (`id`),
  KEY `hstcomponentstatecomponentname` (`component_name`,`service_name`,`cluster_id`),
  KEY `idx_host_component_state` (`host_id`,`component_name`,`service_name`,`cluster_id`),
  CONSTRAINT `FK_hostcomponentstate_host_id` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`),
  CONSTRAINT `hstcomponentstatecomponentname` FOREIGN KEY (`component_name`, `service_name`, `cluster_id`) REFERENCES `servicecomponentdesiredstate` (`component_name`, `service_name`, `cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostcomponentstate`
--

/*!40000 ALTER TABLE `hostcomponentstate` DISABLE KEYS */;
/*!40000 ALTER TABLE `hostcomponentstate` ENABLE KEYS */;

--
-- Table structure for table `hostconfigmapping`
--

DROP TABLE IF EXISTS `hostconfigmapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hostconfigmapping` (
  `create_timestamp` bigint(20) NOT NULL,
  `host_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `type_name` varchar(255) NOT NULL,
  `selected` int(11) NOT NULL DEFAULT 0,
  `service_name` varchar(255) DEFAULT NULL,
  `version_tag` varchar(255) NOT NULL,
  `user_name` varchar(255) NOT NULL DEFAULT '_db',
  PRIMARY KEY (`create_timestamp`,`host_id`,`cluster_id`,`type_name`),
  KEY `FK_hostconfmapping_cluster_id` (`cluster_id`),
  KEY `FK_hostconfmapping_host_id` (`host_id`),
  CONSTRAINT `FK_hostconfmapping_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`cluster_id`),
  CONSTRAINT `FK_hostconfmapping_host_id` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostconfigmapping`
--

/*!40000 ALTER TABLE `hostconfigmapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `hostconfigmapping` ENABLE KEYS */;

--
-- Table structure for table `hostgroup`
--

DROP TABLE IF EXISTS `hostgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hostgroup` (
  `blueprint_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `cardinality` varchar(255) NOT NULL,
  PRIMARY KEY (`blueprint_name`,`name`),
  CONSTRAINT `FK_hg_blueprint_name` FOREIGN KEY (`blueprint_name`) REFERENCES `blueprint` (`blueprint_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostgroup`
--

/*!40000 ALTER TABLE `hostgroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `hostgroup` ENABLE KEYS */;

--
-- Table structure for table `hostgroup_component`
--

DROP TABLE IF EXISTS `hostgroup_component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hostgroup_component` (
  `blueprint_name` varchar(100) NOT NULL,
  `hostgroup_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `provision_action` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`blueprint_name`,`hostgroup_name`,`name`),
  CONSTRAINT `FK_hgc_blueprint_name` FOREIGN KEY (`blueprint_name`, `hostgroup_name`) REFERENCES `hostgroup` (`blueprint_name`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostgroup_component`
--

/*!40000 ALTER TABLE `hostgroup_component` DISABLE KEYS */;
/*!40000 ALTER TABLE `hostgroup_component` ENABLE KEYS */;

--
-- Table structure for table `hostgroup_configuration`
--

DROP TABLE IF EXISTS `hostgroup_configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hostgroup_configuration` (
  `blueprint_name` varchar(100) NOT NULL,
  `hostgroup_name` varchar(100) NOT NULL,
  `type_name` varchar(100) NOT NULL,
  `config_data` longtext NOT NULL,
  `config_attributes` longtext DEFAULT NULL,
  PRIMARY KEY (`blueprint_name`,`hostgroup_name`,`type_name`),
  CONSTRAINT `FK_hg_cfg_bp_hg_name` FOREIGN KEY (`blueprint_name`, `hostgroup_name`) REFERENCES `hostgroup` (`blueprint_name`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostgroup_configuration`
--

/*!40000 ALTER TABLE `hostgroup_configuration` DISABLE KEYS */;
/*!40000 ALTER TABLE `hostgroup_configuration` ENABLE KEYS */;

--
-- Table structure for table `hosts`
--

DROP TABLE IF EXISTS `hosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hosts` (
  `host_id` bigint(20) NOT NULL,
  `host_name` varchar(255) NOT NULL,
  `cpu_count` int(11) NOT NULL,
  `cpu_info` varchar(255) NOT NULL,
  `discovery_status` varchar(2000) NOT NULL,
  `host_attributes` longtext NOT NULL,
  `ipv4` varchar(255) DEFAULT NULL,
  `ipv6` varchar(255) DEFAULT NULL,
  `last_registration_time` bigint(20) NOT NULL,
  `os_arch` varchar(255) NOT NULL,
  `os_info` varchar(1000) NOT NULL,
  `os_type` varchar(255) NOT NULL,
  `ph_cpu_count` int(11) DEFAULT NULL,
  `public_host_name` varchar(255) DEFAULT NULL,
  `rack_info` varchar(255) NOT NULL,
  `total_mem` bigint(20) NOT NULL,
  PRIMARY KEY (`host_id`),
  UNIQUE KEY `UQ_hosts_host_name` (`host_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hosts`
--

/*!40000 ALTER TABLE `hosts` DISABLE KEYS */;
/*!40000 ALTER TABLE `hosts` ENABLE KEYS */;

--
-- Table structure for table `hoststate`
--

DROP TABLE IF EXISTS `hoststate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hoststate` (
  `agent_version` varchar(255) NOT NULL,
  `available_mem` bigint(20) NOT NULL,
  `current_state` varchar(255) NOT NULL,
  `health_status` varchar(255) DEFAULT NULL,
  `host_id` bigint(20) NOT NULL,
  `time_in_state` bigint(20) NOT NULL,
  `maintenance_state` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`host_id`),
  CONSTRAINT `FK_hoststate_host_id` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hoststate`
--

/*!40000 ALTER TABLE `hoststate` DISABLE KEYS */;
/*!40000 ALTER TABLE `hoststate` ENABLE KEYS */;

--
-- Table structure for table `kerberos_descriptor`
--

DROP TABLE IF EXISTS `kerberos_descriptor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kerberos_descriptor` (
  `kerberos_descriptor_name` varchar(255) NOT NULL,
  `kerberos_descriptor` text NOT NULL,
  PRIMARY KEY (`kerberos_descriptor_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kerberos_descriptor`
--

/*!40000 ALTER TABLE `kerberos_descriptor` DISABLE KEYS */;
/*!40000 ALTER TABLE `kerberos_descriptor` ENABLE KEYS */;

--
-- Table structure for table `kerberos_keytab`
--

DROP TABLE IF EXISTS `kerberos_keytab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kerberos_keytab` (
  `keytab_path` varchar(255) NOT NULL,
  `owner_name` varchar(255) DEFAULT NULL,
  `owner_access` varchar(255) DEFAULT NULL,
  `group_name` varchar(255) DEFAULT NULL,
  `group_access` varchar(255) DEFAULT NULL,
  `is_ambari_keytab` smallint(6) NOT NULL DEFAULT 0,
  `write_ambari_jaas` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`keytab_path`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kerberos_keytab`
--

/*!40000 ALTER TABLE `kerberos_keytab` DISABLE KEYS */;
/*!40000 ALTER TABLE `kerberos_keytab` ENABLE KEYS */;

--
-- Table structure for table `kerberos_keytab_principal`
--

DROP TABLE IF EXISTS `kerberos_keytab_principal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kerberos_keytab_principal` (
  `kkp_id` bigint(20) NOT NULL DEFAULT 0,
  `keytab_path` varchar(255) NOT NULL,
  `principal_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `host_id` bigint(20) DEFAULT NULL,
  `is_distributed` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`kkp_id`),
  UNIQUE KEY `UNI_kkp` (`keytab_path`,`principal_name`,`host_id`),
  KEY `FK_kkp_host_id` (`host_id`),
  KEY `FK_kkp_principal_name` (`principal_name`),
  CONSTRAINT `FK_kkp_host_id` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`),
  CONSTRAINT `FK_kkp_keytab_path` FOREIGN KEY (`keytab_path`) REFERENCES `kerberos_keytab` (`keytab_path`),
  CONSTRAINT `FK_kkp_principal_name` FOREIGN KEY (`principal_name`) REFERENCES `kerberos_principal` (`principal_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kerberos_keytab_principal`
--

/*!40000 ALTER TABLE `kerberos_keytab_principal` DISABLE KEYS */;
/*!40000 ALTER TABLE `kerberos_keytab_principal` ENABLE KEYS */;

--
-- Table structure for table `kerberos_principal`
--

DROP TABLE IF EXISTS `kerberos_principal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kerberos_principal` (
  `principal_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `is_service` smallint(6) NOT NULL DEFAULT 1,
  `cached_keytab_path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`principal_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kerberos_principal`
--

/*!40000 ALTER TABLE `kerberos_principal` DISABLE KEYS */;
/*!40000 ALTER TABLE `kerberos_principal` ENABLE KEYS */;

--
-- Table structure for table `key_value_store`
--

DROP TABLE IF EXISTS `key_value_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `key_value_store` (
  `key` varchar(255) NOT NULL,
  `value` longtext DEFAULT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `key_value_store`
--

/*!40000 ALTER TABLE `key_value_store` DISABLE KEYS */;
/*!40000 ALTER TABLE `key_value_store` ENABLE KEYS */;

--
-- Table structure for table `kkp_mapping_service`
--

DROP TABLE IF EXISTS `kkp_mapping_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kkp_mapping_service` (
  `kkp_id` bigint(20) NOT NULL DEFAULT 0,
  `service_name` varchar(255) NOT NULL,
  `component_name` varchar(255) NOT NULL,
  PRIMARY KEY (`kkp_id`,`service_name`,`component_name`),
  CONSTRAINT `FK_kkp_service_principal` FOREIGN KEY (`kkp_id`) REFERENCES `kerberos_keytab_principal` (`kkp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kkp_mapping_service`
--

/*!40000 ALTER TABLE `kkp_mapping_service` DISABLE KEYS */;
/*!40000 ALTER TABLE `kkp_mapping_service` ENABLE KEYS */;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `member_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `UNQ_members_0` (`group_id`,`user_id`),
  KEY `FK_members_user_id` (`user_id`),
  CONSTRAINT `FK_members_group_id` FOREIGN KEY (`group_id`) REFERENCES `groups` (`group_id`),
  CONSTRAINT `FK_members_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

/*!40000 ALTER TABLE `members` DISABLE KEYS */;
/*!40000 ALTER TABLE `members` ENABLE KEYS */;

--
-- Table structure for table `metainfo`
--

DROP TABLE IF EXISTS `metainfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `metainfo` (
  `metainfo_key` varchar(255) NOT NULL,
  `metainfo_value` longtext DEFAULT NULL,
  PRIMARY KEY (`metainfo_key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metainfo`
--

/*!40000 ALTER TABLE `metainfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `metainfo` ENABLE KEYS */;

--
-- Table structure for table `permission_roleauthorization`
--

DROP TABLE IF EXISTS `permission_roleauthorization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission_roleauthorization` (
  `permission_id` bigint(20) NOT NULL,
  `authorization_id` varchar(100) NOT NULL,
  PRIMARY KEY (`permission_id`,`authorization_id`),
  KEY `FK_permission_roleauth_aid` (`authorization_id`),
  CONSTRAINT `FK_permission_roleauth_aid` FOREIGN KEY (`authorization_id`) REFERENCES `roleauthorization` (`authorization_id`),
  CONSTRAINT `FK_permission_roleauth_pid` FOREIGN KEY (`permission_id`) REFERENCES `adminpermission` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_roleauthorization`
--

/*!40000 ALTER TABLE `permission_roleauthorization` DISABLE KEYS */;
/*!40000 ALTER TABLE `permission_roleauthorization` ENABLE KEYS */;

--
-- Table structure for table `remoteambaricluster`
--

DROP TABLE IF EXISTS `remoteambaricluster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `remoteambaricluster` (
  `cluster_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`cluster_id`),
  UNIQUE KEY `UQ_remote_ambari_cluster` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remoteambaricluster`
--

/*!40000 ALTER TABLE `remoteambaricluster` DISABLE KEYS */;
/*!40000 ALTER TABLE `remoteambaricluster` ENABLE KEYS */;

--
-- Table structure for table `remoteambariclusterservice`
--

DROP TABLE IF EXISTS `remoteambariclusterservice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `remoteambariclusterservice` (
  `id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_remote_ambari_cluster_id` (`cluster_id`),
  CONSTRAINT `FK_remote_ambari_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `remoteambaricluster` (`cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remoteambariclusterservice`
--

/*!40000 ALTER TABLE `remoteambariclusterservice` DISABLE KEYS */;
/*!40000 ALTER TABLE `remoteambariclusterservice` ENABLE KEYS */;

--
-- Table structure for table `repo_applicable_services`
--

DROP TABLE IF EXISTS `repo_applicable_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repo_applicable_services` (
  `repo_definition_id` bigint(20) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  KEY `FK_repo_app_service_def_id` (`repo_definition_id`),
  CONSTRAINT `FK_repo_app_service_def_id` FOREIGN KEY (`repo_definition_id`) REFERENCES `repo_definition` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repo_applicable_services`
--

/*!40000 ALTER TABLE `repo_applicable_services` DISABLE KEYS */;
/*!40000 ALTER TABLE `repo_applicable_services` ENABLE KEYS */;

--
-- Table structure for table `repo_definition`
--

DROP TABLE IF EXISTS `repo_definition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repo_definition` (
  `id` bigint(20) NOT NULL,
  `repo_os_id` bigint(20) DEFAULT NULL,
  `repo_name` varchar(255) NOT NULL,
  `repo_id` varchar(255) NOT NULL,
  `base_url` mediumtext NOT NULL,
  `distribution` mediumtext DEFAULT NULL,
  `components` mediumtext DEFAULT NULL,
  `unique_repo` tinyint(1) DEFAULT 1,
  `mirrors` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_repo_definition_repo_os_id` (`repo_os_id`),
  CONSTRAINT `FK_repo_definition_repo_os_id` FOREIGN KEY (`repo_os_id`) REFERENCES `repo_os` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repo_definition`
--

/*!40000 ALTER TABLE `repo_definition` DISABLE KEYS */;
/*!40000 ALTER TABLE `repo_definition` ENABLE KEYS */;

--
-- Table structure for table `repo_os`
--

DROP TABLE IF EXISTS `repo_os`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repo_os` (
  `id` bigint(20) NOT NULL,
  `repo_version_id` bigint(20) NOT NULL,
  `family` varchar(255) NOT NULL DEFAULT '',
  `ambari_managed` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `FK_repo_os_id_repo_version_id` (`repo_version_id`),
  CONSTRAINT `FK_repo_os_id_repo_version_id` FOREIGN KEY (`repo_version_id`) REFERENCES `repo_version` (`repo_version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repo_os`
--

/*!40000 ALTER TABLE `repo_os` DISABLE KEYS */;
/*!40000 ALTER TABLE `repo_os` ENABLE KEYS */;

--
-- Table structure for table `repo_tags`
--

DROP TABLE IF EXISTS `repo_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repo_tags` (
  `repo_definition_id` bigint(20) NOT NULL,
  `tag` varchar(255) NOT NULL,
  KEY `FK_repo_tag_definition_id` (`repo_definition_id`),
  CONSTRAINT `FK_repo_tag_definition_id` FOREIGN KEY (`repo_definition_id`) REFERENCES `repo_definition` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repo_tags`
--

/*!40000 ALTER TABLE `repo_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `repo_tags` ENABLE KEYS */;

--
-- Table structure for table `repo_version`
--

DROP TABLE IF EXISTS `repo_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repo_version` (
  `repo_version_id` bigint(20) NOT NULL,
  `stack_id` bigint(20) NOT NULL,
  `version` varchar(255) NOT NULL,
  `display_name` varchar(128) NOT NULL,
  `repo_type` varchar(255) NOT NULL DEFAULT 'STANDARD',
  `hidden` smallint(6) NOT NULL DEFAULT 0,
  `resolved` tinyint(1) NOT NULL DEFAULT 0,
  `legacy` tinyint(1) NOT NULL DEFAULT 0,
  `version_url` varchar(1024) DEFAULT NULL,
  `version_xml` mediumtext DEFAULT NULL,
  `version_xsd` varchar(512) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`repo_version_id`),
  UNIQUE KEY `UQ_repo_version_display_name` (`display_name`),
  UNIQUE KEY `UQ_repo_version_stack_id` (`stack_id`,`version`),
  CONSTRAINT `FK_repoversion_stack_id` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`stack_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repo_version`
--

/*!40000 ALTER TABLE `repo_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `repo_version` ENABLE KEYS */;

--
-- Table structure for table `request`
--

DROP TABLE IF EXISTS `request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `request` (
  `request_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) DEFAULT NULL,
  `request_schedule_id` bigint(20) DEFAULT NULL,
  `command_name` varchar(255) DEFAULT NULL,
  `create_time` bigint(20) NOT NULL,
  `end_time` bigint(20) NOT NULL,
  `exclusive_execution` tinyint(1) NOT NULL DEFAULT 0,
  `inputs` longblob DEFAULT NULL,
  `request_context` varchar(255) DEFAULT NULL,
  `request_type` varchar(255) DEFAULT NULL,
  `start_time` bigint(20) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'PENDING',
  `display_status` varchar(255) NOT NULL DEFAULT 'PENDING',
  `cluster_host_info` longblob DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `FK_request_schedule_id` (`request_schedule_id`),
  CONSTRAINT `FK_request_schedule_id` FOREIGN KEY (`request_schedule_id`) REFERENCES `requestschedule` (`schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `request`
--

/*!40000 ALTER TABLE `request` DISABLE KEYS */;
/*!40000 ALTER TABLE `request` ENABLE KEYS */;

--
-- Table structure for table `requestoperationlevel`
--

DROP TABLE IF EXISTS `requestoperationlevel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requestoperationlevel` (
  `operation_level_id` bigint(20) NOT NULL,
  `request_id` bigint(20) NOT NULL,
  `level_name` varchar(255) DEFAULT NULL,
  `cluster_name` varchar(255) DEFAULT NULL,
  `service_name` varchar(255) DEFAULT NULL,
  `host_component_name` varchar(255) DEFAULT NULL,
  `host_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`operation_level_id`),
  KEY `FK_req_op_level_req_id` (`request_id`),
  CONSTRAINT `FK_req_op_level_req_id` FOREIGN KEY (`request_id`) REFERENCES `request` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requestoperationlevel`
--

/*!40000 ALTER TABLE `requestoperationlevel` DISABLE KEYS */;
/*!40000 ALTER TABLE `requestoperationlevel` ENABLE KEYS */;

--
-- Table structure for table `requestresourcefilter`
--

DROP TABLE IF EXISTS `requestresourcefilter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requestresourcefilter` (
  `filter_id` bigint(20) NOT NULL,
  `request_id` bigint(20) NOT NULL,
  `service_name` varchar(255) DEFAULT NULL,
  `component_name` varchar(255) DEFAULT NULL,
  `hosts` longblob DEFAULT NULL,
  PRIMARY KEY (`filter_id`),
  KEY `FK_reqresfilter_req_id` (`request_id`),
  CONSTRAINT `FK_reqresfilter_req_id` FOREIGN KEY (`request_id`) REFERENCES `request` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requestresourcefilter`
--

/*!40000 ALTER TABLE `requestresourcefilter` DISABLE KEYS */;
/*!40000 ALTER TABLE `requestresourcefilter` ENABLE KEYS */;

--
-- Table structure for table `requestschedule`
--

DROP TABLE IF EXISTS `requestschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requestschedule` (
  `schedule_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `batch_separation_seconds` smallint(6) DEFAULT NULL,
  `batch_toleration_limit` smallint(6) DEFAULT NULL,
  `authenticated_user_id` int(11) DEFAULT NULL,
  `create_user` varchar(255) DEFAULT NULL,
  `create_timestamp` bigint(20) DEFAULT NULL,
  `update_user` varchar(255) DEFAULT NULL,
  `update_timestamp` bigint(20) DEFAULT NULL,
  `minutes` varchar(10) DEFAULT NULL,
  `hours` varchar(10) DEFAULT NULL,
  `days_of_month` varchar(10) DEFAULT NULL,
  `month` varchar(10) DEFAULT NULL,
  `day_of_week` varchar(10) DEFAULT NULL,
  `yearToSchedule` varchar(10) DEFAULT NULL,
  `startTime` varchar(50) DEFAULT NULL,
  `endTime` varchar(50) DEFAULT NULL,
  `last_execution_status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requestschedule`
--

/*!40000 ALTER TABLE `requestschedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `requestschedule` ENABLE KEYS */;

--
-- Table structure for table `requestschedulebatchrequest`
--

DROP TABLE IF EXISTS `requestschedulebatchrequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requestschedulebatchrequest` (
  `schedule_id` bigint(20) NOT NULL,
  `batch_id` bigint(20) NOT NULL,
  `request_id` bigint(20) DEFAULT NULL,
  `request_type` varchar(255) DEFAULT NULL,
  `request_uri` varchar(1024) DEFAULT NULL,
  `request_body` longblob DEFAULT NULL,
  `request_status` varchar(255) DEFAULT NULL,
  `return_code` smallint(6) DEFAULT NULL,
  `return_message` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`schedule_id`,`batch_id`),
  CONSTRAINT `FK_rsbatchrequest_schedule_id` FOREIGN KEY (`schedule_id`) REFERENCES `requestschedule` (`schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requestschedulebatchrequest`
--

/*!40000 ALTER TABLE `requestschedulebatchrequest` DISABLE KEYS */;
/*!40000 ALTER TABLE `requestschedulebatchrequest` ENABLE KEYS */;

--
-- Table structure for table `role_success_criteria`
--

DROP TABLE IF EXISTS `role_success_criteria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_success_criteria` (
  `role` varchar(255) NOT NULL,
  `request_id` bigint(20) NOT NULL,
  `stage_id` bigint(20) NOT NULL,
  `success_factor` double NOT NULL,
  PRIMARY KEY (`role`,`request_id`,`stage_id`),
  KEY `role_success_criteria_stage_id` (`stage_id`,`request_id`),
  KEY `idx_rsc_request_id` (`request_id`),
  CONSTRAINT `role_success_criteria_stage_id` FOREIGN KEY (`stage_id`, `request_id`) REFERENCES `stage` (`stage_id`, `request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_success_criteria`
--

/*!40000 ALTER TABLE `role_success_criteria` DISABLE KEYS */;
/*!40000 ALTER TABLE `role_success_criteria` ENABLE KEYS */;

--
-- Table structure for table `roleauthorization`
--

DROP TABLE IF EXISTS `roleauthorization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roleauthorization` (
  `authorization_id` varchar(100) NOT NULL,
  `authorization_name` varchar(255) NOT NULL,
  PRIMARY KEY (`authorization_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roleauthorization`
--

/*!40000 ALTER TABLE `roleauthorization` DISABLE KEYS */;
/*!40000 ALTER TABLE `roleauthorization` ENABLE KEYS */;

--
-- Table structure for table `servicecomponent_version`
--

DROP TABLE IF EXISTS `servicecomponent_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servicecomponent_version` (
  `id` bigint(20) NOT NULL,
  `component_id` bigint(20) NOT NULL,
  `repo_version_id` bigint(20) NOT NULL,
  `state` varchar(32) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_scv_component_id` (`component_id`),
  KEY `FK_scv_repo_version_id` (`repo_version_id`),
  CONSTRAINT `FK_scv_component_id` FOREIGN KEY (`component_id`) REFERENCES `servicecomponentdesiredstate` (`id`),
  CONSTRAINT `FK_scv_repo_version_id` FOREIGN KEY (`repo_version_id`) REFERENCES `repo_version` (`repo_version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicecomponent_version`
--

/*!40000 ALTER TABLE `servicecomponent_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `servicecomponent_version` ENABLE KEYS */;

--
-- Table structure for table `servicecomponentdesiredstate`
--

DROP TABLE IF EXISTS `servicecomponentdesiredstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servicecomponentdesiredstate` (
  `id` bigint(20) NOT NULL,
  `component_name` varchar(100) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `desired_repo_version_id` bigint(20) NOT NULL,
  `desired_state` varchar(255) NOT NULL,
  `service_name` varchar(100) NOT NULL,
  `recovery_enabled` smallint(6) NOT NULL DEFAULT 0,
  `repo_state` varchar(255) NOT NULL DEFAULT 'NOT_REQUIRED',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_scdesiredstate_name` (`component_name`,`service_name`,`cluster_id`),
  KEY `FK_scds_desired_repo_id` (`desired_repo_version_id`),
  KEY `srvccmponentdesiredstatesrvcnm` (`service_name`,`cluster_id`),
  CONSTRAINT `FK_scds_desired_repo_id` FOREIGN KEY (`desired_repo_version_id`) REFERENCES `repo_version` (`repo_version_id`),
  CONSTRAINT `srvccmponentdesiredstatesrvcnm` FOREIGN KEY (`service_name`, `cluster_id`) REFERENCES `clusterservices` (`service_name`, `cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicecomponentdesiredstate`
--

/*!40000 ALTER TABLE `servicecomponentdesiredstate` DISABLE KEYS */;
/*!40000 ALTER TABLE `servicecomponentdesiredstate` ENABLE KEYS */;

--
-- Table structure for table `serviceconfig`
--

DROP TABLE IF EXISTS `serviceconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serviceconfig` (
  `service_config_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `version` bigint(20) NOT NULL,
  `create_timestamp` bigint(20) NOT NULL,
  `stack_id` bigint(20) NOT NULL,
  `user_name` varchar(255) NOT NULL DEFAULT '_db',
  `group_id` bigint(20) DEFAULT NULL,
  `note` longtext DEFAULT NULL,
  PRIMARY KEY (`service_config_id`),
  UNIQUE KEY `UQ_scv_service_version` (`cluster_id`,`service_name`,`version`),
  KEY `FK_serviceconfig_stack_id` (`stack_id`),
  CONSTRAINT `FK_serviceconfig_stack_id` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`stack_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serviceconfig`
--

/*!40000 ALTER TABLE `serviceconfig` DISABLE KEYS */;
/*!40000 ALTER TABLE `serviceconfig` ENABLE KEYS */;

--
-- Table structure for table `serviceconfighosts`
--

DROP TABLE IF EXISTS `serviceconfighosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serviceconfighosts` (
  `service_config_id` bigint(20) NOT NULL,
  `host_id` bigint(20) NOT NULL,
  PRIMARY KEY (`service_config_id`,`host_id`),
  KEY `FK_scvhosts_host_id` (`host_id`),
  CONSTRAINT `FK_scvhosts_host_id` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`),
  CONSTRAINT `FK_scvhosts_scv` FOREIGN KEY (`service_config_id`) REFERENCES `serviceconfig` (`service_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serviceconfighosts`
--

/*!40000 ALTER TABLE `serviceconfighosts` DISABLE KEYS */;
/*!40000 ALTER TABLE `serviceconfighosts` ENABLE KEYS */;

--
-- Table structure for table `serviceconfigmapping`
--

DROP TABLE IF EXISTS `serviceconfigmapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serviceconfigmapping` (
  `service_config_id` bigint(20) NOT NULL,
  `config_id` bigint(20) NOT NULL,
  PRIMARY KEY (`service_config_id`,`config_id`),
  KEY `FK_scvm_config` (`config_id`),
  CONSTRAINT `FK_scvm_config` FOREIGN KEY (`config_id`) REFERENCES `clusterconfig` (`config_id`),
  CONSTRAINT `FK_scvm_scv` FOREIGN KEY (`service_config_id`) REFERENCES `serviceconfig` (`service_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serviceconfigmapping`
--

/*!40000 ALTER TABLE `serviceconfigmapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `serviceconfigmapping` ENABLE KEYS */;

--
-- Table structure for table `servicedesiredstate`
--

DROP TABLE IF EXISTS `servicedesiredstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servicedesiredstate` (
  `cluster_id` bigint(20) NOT NULL,
  `desired_host_role_mapping` int(11) NOT NULL,
  `desired_repo_version_id` bigint(20) NOT NULL,
  `desired_state` varchar(255) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `maintenance_state` varchar(32) NOT NULL DEFAULT 'ACTIVE',
  `credential_store_enabled` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`cluster_id`,`service_name`),
  KEY `FK_repo_version_id` (`desired_repo_version_id`),
  KEY `servicedesiredstateservicename` (`service_name`,`cluster_id`),
  CONSTRAINT `FK_repo_version_id` FOREIGN KEY (`desired_repo_version_id`) REFERENCES `repo_version` (`repo_version_id`),
  CONSTRAINT `servicedesiredstateservicename` FOREIGN KEY (`service_name`, `cluster_id`) REFERENCES `clusterservices` (`service_name`, `cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicedesiredstate`
--

/*!40000 ALTER TABLE `servicedesiredstate` DISABLE KEYS */;
/*!40000 ALTER TABLE `servicedesiredstate` ENABLE KEYS */;

--
-- Table structure for table `setting`
--

DROP TABLE IF EXISTS `setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `setting` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `setting_type` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `updated_by` varchar(255) NOT NULL DEFAULT '_db',
  `update_timestamp` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setting`
--

/*!40000 ALTER TABLE `setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `setting` ENABLE KEYS */;

--
-- Table structure for table `stack`
--

DROP TABLE IF EXISTS `stack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stack` (
  `stack_id` bigint(20) NOT NULL,
  `stack_name` varchar(100) NOT NULL,
  `stack_version` varchar(100) NOT NULL,
  PRIMARY KEY (`stack_id`),
  UNIQUE KEY `UQ_stack` (`stack_name`,`stack_version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stack`
--

/*!40000 ALTER TABLE `stack` DISABLE KEYS */;
/*!40000 ALTER TABLE `stack` ENABLE KEYS */;

--
-- Table structure for table `stage`
--

DROP TABLE IF EXISTS `stage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stage` (
  `stage_id` bigint(20) NOT NULL,
  `request_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) DEFAULT NULL,
  `skippable` smallint(6) NOT NULL DEFAULT 0,
  `supports_auto_skip_failure` smallint(6) NOT NULL DEFAULT 0,
  `log_info` varchar(255) NOT NULL,
  `request_context` varchar(255) DEFAULT NULL,
  `command_params` longblob DEFAULT NULL,
  `host_params` longblob DEFAULT NULL,
  `command_execution_type` varchar(32) NOT NULL DEFAULT 'STAGE',
  `status` varchar(255) NOT NULL DEFAULT 'PENDING',
  `display_status` varchar(255) NOT NULL DEFAULT 'PENDING',
  PRIMARY KEY (`stage_id`,`request_id`),
  KEY `idx_stage_request_id` (`request_id`),
  CONSTRAINT `FK_stage_request_id` FOREIGN KEY (`request_id`) REFERENCES `request` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stage`
--

/*!40000 ALTER TABLE `stage` DISABLE KEYS */;
/*!40000 ALTER TABLE `stage` ENABLE KEYS */;

--
-- Table structure for table `topology_host_info`
--

DROP TABLE IF EXISTS `topology_host_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topology_host_info` (
  `id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `fqdn` varchar(255) DEFAULT NULL,
  `host_id` bigint(20) DEFAULT NULL,
  `host_count` int(11) DEFAULT NULL,
  `predicate` varchar(2048) DEFAULT NULL,
  `rack_info` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_hostinfo_group_id` (`group_id`),
  KEY `FK_hostinfo_host_id` (`host_id`),
  CONSTRAINT `FK_hostinfo_group_id` FOREIGN KEY (`group_id`) REFERENCES `topology_hostgroup` (`id`),
  CONSTRAINT `FK_hostinfo_host_id` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_host_info`
--

/*!40000 ALTER TABLE `topology_host_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `topology_host_info` ENABLE KEYS */;

--
-- Table structure for table `topology_host_request`
--

DROP TABLE IF EXISTS `topology_host_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topology_host_request` (
  `id` bigint(20) NOT NULL,
  `logical_request_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `stage_id` bigint(20) NOT NULL,
  `host_name` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `status_message` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_hostreq_group_id` (`group_id`),
  KEY `FK_hostreq_logicalreq_id` (`logical_request_id`),
  CONSTRAINT `FK_hostreq_group_id` FOREIGN KEY (`group_id`) REFERENCES `topology_hostgroup` (`id`),
  CONSTRAINT `FK_hostreq_logicalreq_id` FOREIGN KEY (`logical_request_id`) REFERENCES `topology_logical_request` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_host_request`
--

/*!40000 ALTER TABLE `topology_host_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `topology_host_request` ENABLE KEYS */;

--
-- Table structure for table `topology_host_task`
--

DROP TABLE IF EXISTS `topology_host_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topology_host_task` (
  `id` bigint(20) NOT NULL,
  `host_request_id` bigint(20) NOT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_hosttask_req_id` (`host_request_id`),
  CONSTRAINT `FK_hosttask_req_id` FOREIGN KEY (`host_request_id`) REFERENCES `topology_host_request` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_host_task`
--

/*!40000 ALTER TABLE `topology_host_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `topology_host_task` ENABLE KEYS */;

--
-- Table structure for table `topology_hostgroup`
--

DROP TABLE IF EXISTS `topology_hostgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topology_hostgroup` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `group_properties` longtext DEFAULT NULL,
  `group_attributes` longtext DEFAULT NULL,
  `request_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_hostgroup_req_id` (`request_id`),
  CONSTRAINT `FK_hostgroup_req_id` FOREIGN KEY (`request_id`) REFERENCES `topology_request` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_hostgroup`
--

/*!40000 ALTER TABLE `topology_hostgroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `topology_hostgroup` ENABLE KEYS */;

--
-- Table structure for table `topology_logical_request`
--

DROP TABLE IF EXISTS `topology_logical_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topology_logical_request` (
  `id` bigint(20) NOT NULL,
  `request_id` bigint(20) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_logicalreq_req_id` (`request_id`),
  CONSTRAINT `FK_logicalreq_req_id` FOREIGN KEY (`request_id`) REFERENCES `topology_request` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_logical_request`
--

/*!40000 ALTER TABLE `topology_logical_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `topology_logical_request` ENABLE KEYS */;

--
-- Table structure for table `topology_logical_task`
--

DROP TABLE IF EXISTS `topology_logical_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topology_logical_task` (
  `id` bigint(20) NOT NULL,
  `host_task_id` bigint(20) NOT NULL,
  `physical_task_id` bigint(20) DEFAULT NULL,
  `component` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ltask_hosttask_id` (`host_task_id`),
  KEY `FK_ltask_hrc_id` (`physical_task_id`),
  CONSTRAINT `FK_ltask_hosttask_id` FOREIGN KEY (`host_task_id`) REFERENCES `topology_host_task` (`id`),
  CONSTRAINT `FK_ltask_hrc_id` FOREIGN KEY (`physical_task_id`) REFERENCES `host_role_command` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_logical_task`
--

/*!40000 ALTER TABLE `topology_logical_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `topology_logical_task` ENABLE KEYS */;

--
-- Table structure for table `topology_request`
--

DROP TABLE IF EXISTS `topology_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topology_request` (
  `id` bigint(20) NOT NULL,
  `action` varchar(255) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `bp_name` varchar(100) NOT NULL,
  `cluster_properties` longtext DEFAULT NULL,
  `cluster_attributes` longtext DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `provision_action` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_topology_request_cluster_id` (`cluster_id`),
  CONSTRAINT `FK_topology_request_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_request`
--

/*!40000 ALTER TABLE `topology_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `topology_request` ENABLE KEYS */;

--
-- Table structure for table `upgrade`
--

DROP TABLE IF EXISTS `upgrade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `upgrade` (
  `upgrade_id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `request_id` bigint(20) NOT NULL,
  `direction` varchar(255) NOT NULL DEFAULT 'UPGRADE',
  `orchestration` varchar(255) NOT NULL DEFAULT 'STANDARD',
  `upgrade_package` varchar(255) NOT NULL,
  `upgrade_type` varchar(32) NOT NULL,
  `repo_version_id` bigint(20) NOT NULL,
  `skip_failures` tinyint(1) NOT NULL DEFAULT 0,
  `skip_sc_failures` tinyint(1) NOT NULL DEFAULT 0,
  `downgrade_allowed` tinyint(1) NOT NULL DEFAULT 1,
  `revert_allowed` tinyint(1) NOT NULL DEFAULT 0,
  `suspended` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`upgrade_id`),
  KEY `cluster_id` (`cluster_id`),
  KEY `request_id` (`request_id`),
  KEY `repo_version_id` (`repo_version_id`),
  CONSTRAINT `upgrade_ibfk_1` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`cluster_id`),
  CONSTRAINT `upgrade_ibfk_2` FOREIGN KEY (`request_id`) REFERENCES `request` (`request_id`),
  CONSTRAINT `upgrade_ibfk_3` FOREIGN KEY (`repo_version_id`) REFERENCES `repo_version` (`repo_version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `upgrade`
--

/*!40000 ALTER TABLE `upgrade` DISABLE KEYS */;
/*!40000 ALTER TABLE `upgrade` ENABLE KEYS */;

--
-- Table structure for table `upgrade_group`
--

DROP TABLE IF EXISTS `upgrade_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `upgrade_group` (
  `upgrade_group_id` bigint(20) NOT NULL,
  `upgrade_id` bigint(20) NOT NULL,
  `group_name` varchar(255) NOT NULL DEFAULT '',
  `group_title` varchar(1024) NOT NULL DEFAULT '',
  PRIMARY KEY (`upgrade_group_id`),
  KEY `upgrade_id` (`upgrade_id`),
  CONSTRAINT `upgrade_group_ibfk_1` FOREIGN KEY (`upgrade_id`) REFERENCES `upgrade` (`upgrade_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `upgrade_group`
--

/*!40000 ALTER TABLE `upgrade_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `upgrade_group` ENABLE KEYS */;

--
-- Table structure for table `upgrade_history`
--

DROP TABLE IF EXISTS `upgrade_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `upgrade_history` (
  `id` bigint(20) NOT NULL,
  `upgrade_id` bigint(20) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `component_name` varchar(255) NOT NULL,
  `from_repo_version_id` bigint(20) NOT NULL,
  `target_repo_version_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_upgrade_hist` (`upgrade_id`,`component_name`,`service_name`),
  KEY `FK_upgrade_hist_from_repo` (`from_repo_version_id`),
  KEY `FK_upgrade_hist_target_repo` (`target_repo_version_id`),
  CONSTRAINT `FK_upgrade_hist_from_repo` FOREIGN KEY (`from_repo_version_id`) REFERENCES `repo_version` (`repo_version_id`),
  CONSTRAINT `FK_upgrade_hist_target_repo` FOREIGN KEY (`target_repo_version_id`) REFERENCES `repo_version` (`repo_version_id`),
  CONSTRAINT `FK_upgrade_hist_upgrade_id` FOREIGN KEY (`upgrade_id`) REFERENCES `upgrade` (`upgrade_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `upgrade_history`
--

/*!40000 ALTER TABLE `upgrade_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `upgrade_history` ENABLE KEYS */;

--
-- Table structure for table `upgrade_item`
--

DROP TABLE IF EXISTS `upgrade_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `upgrade_item` (
  `upgrade_item_id` bigint(20) NOT NULL,
  `upgrade_group_id` bigint(20) NOT NULL,
  `stage_id` bigint(20) NOT NULL,
  `state` varchar(255) NOT NULL DEFAULT 'NONE',
  `hosts` text DEFAULT NULL,
  `tasks` text DEFAULT NULL,
  `item_text` text DEFAULT NULL,
  PRIMARY KEY (`upgrade_item_id`),
  KEY `upgrade_group_id` (`upgrade_group_id`),
  CONSTRAINT `upgrade_item_ibfk_1` FOREIGN KEY (`upgrade_group_id`) REFERENCES `upgrade_group` (`upgrade_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `upgrade_item`
--

/*!40000 ALTER TABLE `upgrade_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `upgrade_item` ENABLE KEYS */;

--
-- Table structure for table `user_authentication`
--

DROP TABLE IF EXISTS `user_authentication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_authentication` (
  `user_authentication_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `authentication_type` varchar(50) NOT NULL,
  `authentication_key` varchar(2048) DEFAULT NULL,
  `create_time` bigint(20) NOT NULL,
  `update_time` bigint(20) NOT NULL,
  PRIMARY KEY (`user_authentication_id`),
  KEY `FK_user_authentication_users` (`user_id`),
  CONSTRAINT `FK_user_authentication_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_authentication`
--

/*!40000 ALTER TABLE `user_authentication` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_authentication` ENABLE KEYS */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `principal_id` bigint(20) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `active` int(11) NOT NULL DEFAULT 1,
  `consecutive_failures` int(11) NOT NULL DEFAULT 0,
  `active_widget_layouts` varchar(1024) DEFAULT NULL,
  `display_name` varchar(255) NOT NULL,
  `local_username` varchar(255) NOT NULL,
  `create_time` bigint(20) NOT NULL,
  `version` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UNQ_users_0` (`user_name`),
  KEY `FK_users_principal_id` (`principal_id`),
  CONSTRAINT `FK_users_principal_id` FOREIGN KEY (`principal_id`) REFERENCES `adminprincipal` (`principal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

--
-- Table structure for table `viewentity`
--

DROP TABLE IF EXISTS `viewentity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viewentity` (
  `id` bigint(20) NOT NULL,
  `view_name` varchar(100) NOT NULL,
  `view_instance_name` varchar(100) NOT NULL,
  `class_name` varchar(255) NOT NULL,
  `id_property` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_viewentity_view_name` (`view_name`,`view_instance_name`),
  CONSTRAINT `FK_viewentity_view_name` FOREIGN KEY (`view_name`, `view_instance_name`) REFERENCES `viewinstance` (`view_name`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viewentity`
--

/*!40000 ALTER TABLE `viewentity` DISABLE KEYS */;
/*!40000 ALTER TABLE `viewentity` ENABLE KEYS */;

--
-- Table structure for table `viewinstance`
--

DROP TABLE IF EXISTS `viewinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viewinstance` (
  `view_instance_id` bigint(20) NOT NULL,
  `resource_id` bigint(20) NOT NULL,
  `view_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `description` varchar(2048) DEFAULT NULL,
  `visible` char(1) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `icon64` varchar(255) DEFAULT NULL,
  `xml_driven` char(1) DEFAULT NULL,
  `alter_names` tinyint(1) NOT NULL DEFAULT 1,
  `cluster_handle` bigint(20) DEFAULT NULL,
  `cluster_type` varchar(100) NOT NULL DEFAULT 'LOCAL_AMBARI',
  `short_url` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`view_instance_id`),
  UNIQUE KEY `UQ_viewinstance_name` (`view_name`,`name`),
  UNIQUE KEY `UQ_viewinstance_name_id` (`view_instance_id`,`view_name`,`name`),
  KEY `FK_instance_url_id` (`short_url`),
  KEY `FK_viewinstance_resource_id` (`resource_id`),
  CONSTRAINT `FK_instance_url_id` FOREIGN KEY (`short_url`) REFERENCES `viewurl` (`url_id`),
  CONSTRAINT `FK_viewinst_view_name` FOREIGN KEY (`view_name`) REFERENCES `viewmain` (`view_name`),
  CONSTRAINT `FK_viewinstance_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `adminresource` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viewinstance`
--

/*!40000 ALTER TABLE `viewinstance` DISABLE KEYS */;
/*!40000 ALTER TABLE `viewinstance` ENABLE KEYS */;

--
-- Table structure for table `viewinstancedata`
--

DROP TABLE IF EXISTS `viewinstancedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viewinstancedata` (
  `view_instance_id` bigint(20) NOT NULL,
  `view_name` varchar(100) NOT NULL,
  `view_instance_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `value` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`view_instance_id`,`name`,`user_name`),
  KEY `FK_viewinstdata_view_name` (`view_instance_id`,`view_name`,`view_instance_name`),
  CONSTRAINT `FK_viewinstdata_view_name` FOREIGN KEY (`view_instance_id`, `view_name`, `view_instance_name`) REFERENCES `viewinstance` (`view_instance_id`, `view_name`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viewinstancedata`
--

/*!40000 ALTER TABLE `viewinstancedata` DISABLE KEYS */;
/*!40000 ALTER TABLE `viewinstancedata` ENABLE KEYS */;

--
-- Table structure for table `viewinstanceproperty`
--

DROP TABLE IF EXISTS `viewinstanceproperty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viewinstanceproperty` (
  `view_name` varchar(100) NOT NULL,
  `view_instance_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `value` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`view_name`,`view_instance_name`,`name`),
  CONSTRAINT `FK_viewinstprop_view_name` FOREIGN KEY (`view_name`, `view_instance_name`) REFERENCES `viewinstance` (`view_name`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viewinstanceproperty`
--

/*!40000 ALTER TABLE `viewinstanceproperty` DISABLE KEYS */;
/*!40000 ALTER TABLE `viewinstanceproperty` ENABLE KEYS */;

--
-- Table structure for table `viewmain`
--

DROP TABLE IF EXISTS `viewmain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viewmain` (
  `view_name` varchar(255) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `description` varchar(2048) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `build` varchar(128) DEFAULT NULL,
  `resource_type_id` int(11) NOT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `icon64` varchar(255) DEFAULT NULL,
  `archive` varchar(255) DEFAULT NULL,
  `mask` varchar(255) DEFAULT NULL,
  `system_view` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`view_name`),
  KEY `FK_view_resource_type_id` (`resource_type_id`),
  CONSTRAINT `FK_view_resource_type_id` FOREIGN KEY (`resource_type_id`) REFERENCES `adminresourcetype` (`resource_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viewmain`
--

/*!40000 ALTER TABLE `viewmain` DISABLE KEYS */;
/*!40000 ALTER TABLE `viewmain` ENABLE KEYS */;

--
-- Table structure for table `viewparameter`
--

DROP TABLE IF EXISTS `viewparameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viewparameter` (
  `view_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(2048) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `placeholder` varchar(255) DEFAULT NULL,
  `default_value` varchar(2000) DEFAULT NULL,
  `cluster_config` varchar(255) DEFAULT NULL,
  `required` char(1) DEFAULT NULL,
  `masked` char(1) DEFAULT NULL,
  PRIMARY KEY (`view_name`,`name`),
  CONSTRAINT `FK_viewparam_view_name` FOREIGN KEY (`view_name`) REFERENCES `viewmain` (`view_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viewparameter`
--

/*!40000 ALTER TABLE `viewparameter` DISABLE KEYS */;
/*!40000 ALTER TABLE `viewparameter` ENABLE KEYS */;

--
-- Table structure for table `viewresource`
--

DROP TABLE IF EXISTS `viewresource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viewresource` (
  `view_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `plural_name` varchar(255) DEFAULT NULL,
  `id_property` varchar(255) DEFAULT NULL,
  `subResource_names` varchar(255) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `service` varchar(255) DEFAULT NULL,
  `resource` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`view_name`,`name`),
  CONSTRAINT `FK_viewres_view_name` FOREIGN KEY (`view_name`) REFERENCES `viewmain` (`view_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viewresource`
--

/*!40000 ALTER TABLE `viewresource` DISABLE KEYS */;
/*!40000 ALTER TABLE `viewresource` ENABLE KEYS */;

--
-- Table structure for table `viewurl`
--

DROP TABLE IF EXISTS `viewurl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viewurl` (
  `url_id` bigint(20) NOT NULL,
  `url_name` varchar(255) NOT NULL,
  `url_suffix` varchar(255) NOT NULL,
  PRIMARY KEY (`url_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viewurl`
--

/*!40000 ALTER TABLE `viewurl` DISABLE KEYS */;
/*!40000 ALTER TABLE `viewurl` ENABLE KEYS */;

--
-- Table structure for table `widget`
--

DROP TABLE IF EXISTS `widget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `widget` (
  `id` bigint(20) NOT NULL,
  `widget_name` varchar(255) NOT NULL,
  `widget_type` varchar(255) NOT NULL,
  `metrics` longtext DEFAULT NULL,
  `time_created` bigint(20) NOT NULL,
  `author` varchar(255) DEFAULT NULL,
  `description` varchar(2048) DEFAULT NULL,
  `default_section_name` varchar(255) DEFAULT NULL,
  `scope` varchar(255) DEFAULT NULL,
  `widget_values` longtext DEFAULT NULL,
  `properties` longtext DEFAULT NULL,
  `cluster_id` bigint(20) NOT NULL,
  `tag` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `widget`
--

/*!40000 ALTER TABLE `widget` DISABLE KEYS */;
/*!40000 ALTER TABLE `widget` ENABLE KEYS */;

--
-- Table structure for table `widget_layout`
--

DROP TABLE IF EXISTS `widget_layout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `widget_layout` (
  `id` bigint(20) NOT NULL,
  `layout_name` varchar(255) NOT NULL,
  `section_name` varchar(255) NOT NULL,
  `scope` varchar(255) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `cluster_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `widget_layout`
--

/*!40000 ALTER TABLE `widget_layout` DISABLE KEYS */;
/*!40000 ALTER TABLE `widget_layout` ENABLE KEYS */;

--
-- Table structure for table `widget_layout_user_widget`
--

DROP TABLE IF EXISTS `widget_layout_user_widget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `widget_layout_user_widget` (
  `widget_layout_id` bigint(20) NOT NULL,
  `widget_id` bigint(20) NOT NULL,
  `widget_order` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`widget_layout_id`,`widget_id`),
  KEY `FK_widget_id` (`widget_id`),
  CONSTRAINT `FK_widget_id` FOREIGN KEY (`widget_id`) REFERENCES `widget` (`id`),
  CONSTRAINT `FK_widget_layout_id` FOREIGN KEY (`widget_layout_id`) REFERENCES `widget_layout` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `widget_layout_user_widget`
--

/*!40000 ALTER TABLE `widget_layout_user_widget` DISABLE KEYS */;
/*!40000 ALTER TABLE `widget_layout_user_widget` ENABLE KEYS */;

--
-- Current Database: `druid`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `druid` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `druid`;

--
-- Table structure for table `druid_audit`
--

DROP TABLE IF EXISTS `druid_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `druid_audit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `audit_key` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `comment` varchar(2048) NOT NULL,
  `created_date` varchar(255) NOT NULL,
  `payload` longblob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_druid_audit_key_time` (`audit_key`,`created_date`),
  KEY `idx_druid_audit_type_time` (`type`,`created_date`),
  KEY `idx_druid_audit_audit_time` (`created_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `druid_audit`
--

/*!40000 ALTER TABLE `druid_audit` DISABLE KEYS */;
/*!40000 ALTER TABLE `druid_audit` ENABLE KEYS */;

--
-- Table structure for table `druid_config`
--

DROP TABLE IF EXISTS `druid_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `druid_config` (
  `name` varchar(255) NOT NULL,
  `payload` longblob NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `druid_config`
--

/*!40000 ALTER TABLE `druid_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `druid_config` ENABLE KEYS */;

--
-- Table structure for table `druid_dataSource`
--

DROP TABLE IF EXISTS `druid_dataSource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `druid_dataSource` (
  `dataSource` varchar(255) NOT NULL,
  `created_date` varchar(255) NOT NULL,
  `commit_metadata_payload` longblob NOT NULL,
  `commit_metadata_sha1` varchar(255) NOT NULL,
  PRIMARY KEY (`dataSource`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `druid_dataSource`
--

/*!40000 ALTER TABLE `druid_dataSource` DISABLE KEYS */;
/*!40000 ALTER TABLE `druid_dataSource` ENABLE KEYS */;

--
-- Table structure for table `druid_pendingSegments`
--

DROP TABLE IF EXISTS `druid_pendingSegments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `druid_pendingSegments` (
  `id` varchar(255) NOT NULL,
  `dataSource` varchar(255) NOT NULL,
  `created_date` varchar(255) NOT NULL,
  `start` varchar(255) NOT NULL,
  `end` varchar(255) NOT NULL,
  `sequence_name` varchar(255) NOT NULL,
  `sequence_prev_id` varchar(255) NOT NULL,
  `sequence_name_prev_id_sha1` varchar(255) NOT NULL,
  `payload` longblob NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sequence_name_prev_id_sha1` (`sequence_name_prev_id_sha1`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `druid_pendingSegments`
--

/*!40000 ALTER TABLE `druid_pendingSegments` DISABLE KEYS */;
/*!40000 ALTER TABLE `druid_pendingSegments` ENABLE KEYS */;

--
-- Table structure for table `druid_rules`
--

DROP TABLE IF EXISTS `druid_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `druid_rules` (
  `id` varchar(255) NOT NULL,
  `dataSource` varchar(255) NOT NULL,
  `version` varchar(255) NOT NULL,
  `payload` longblob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_druid_rules_datasource` (`dataSource`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `druid_rules`
--

/*!40000 ALTER TABLE `druid_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `druid_rules` ENABLE KEYS */;

--
-- Table structure for table `druid_segments`
--

DROP TABLE IF EXISTS `druid_segments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `druid_segments` (
  `id` varchar(255) NOT NULL,
  `dataSource` varchar(255) NOT NULL,
  `created_date` varchar(255) NOT NULL,
  `start` varchar(255) NOT NULL,
  `end` varchar(255) NOT NULL,
  `partitioned` tinyint(1) NOT NULL,
  `version` varchar(255) NOT NULL,
  `used` tinyint(1) NOT NULL,
  `payload` longblob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_druid_segments_datasource` (`dataSource`),
  KEY `idx_druid_segments_used` (`used`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `druid_segments`
--

/*!40000 ALTER TABLE `druid_segments` DISABLE KEYS */;
/*!40000 ALTER TABLE `druid_segments` ENABLE KEYS */;

--
-- Table structure for table `druid_supervisors`
--

DROP TABLE IF EXISTS `druid_supervisors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `druid_supervisors` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `spec_id` varchar(255) NOT NULL,
  `created_date` varchar(255) NOT NULL,
  `payload` longblob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_druid_supervisors_spec_id` (`spec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `druid_supervisors`
--

/*!40000 ALTER TABLE `druid_supervisors` DISABLE KEYS */;
/*!40000 ALTER TABLE `druid_supervisors` ENABLE KEYS */;

--
-- Table structure for table `druid_tasklocks`
--

DROP TABLE IF EXISTS `druid_tasklocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `druid_tasklocks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_id` varchar(255) DEFAULT NULL,
  `lock_payload` longblob DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_druid_tasklocks_task_id` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `druid_tasklocks`
--

/*!40000 ALTER TABLE `druid_tasklocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `druid_tasklocks` ENABLE KEYS */;

--
-- Table structure for table `druid_tasklogs`
--

DROP TABLE IF EXISTS `druid_tasklogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `druid_tasklogs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_id` varchar(255) DEFAULT NULL,
  `log_payload` longblob DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_druid_tasklogs_task_id` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `druid_tasklogs`
--

/*!40000 ALTER TABLE `druid_tasklogs` DISABLE KEYS */;
/*!40000 ALTER TABLE `druid_tasklogs` ENABLE KEYS */;

--
-- Table structure for table `druid_tasks`
--

DROP TABLE IF EXISTS `druid_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `druid_tasks` (
  `id` varchar(255) NOT NULL,
  `created_date` varchar(255) NOT NULL,
  `datasource` varchar(255) NOT NULL,
  `payload` longblob NOT NULL,
  `status_payload` longblob NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_druid_tasks_active_created_date` (`active`,`created_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `druid_tasks`
--

/*!40000 ALTER TABLE `druid_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `druid_tasks` ENABLE KEYS */;

--
-- Current Database: `hive`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hive` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `hive`;

--
-- Table structure for table `AUX_TABLE`
--

DROP TABLE IF EXISTS `AUX_TABLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AUX_TABLE` (
  `MT_KEY1` varchar(128) NOT NULL,
  `MT_KEY2` bigint(20) NOT NULL,
  `MT_COMMENT` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`MT_KEY1`,`MT_KEY2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUX_TABLE`
--

/*!40000 ALTER TABLE `AUX_TABLE` DISABLE KEYS */;
/*!40000 ALTER TABLE `AUX_TABLE` ENABLE KEYS */;

--
-- Table structure for table `BUCKETING_COLS`
--

DROP TABLE IF EXISTS `BUCKETING_COLS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BUCKETING_COLS` (
  `SD_ID` bigint(20) NOT NULL,
  `BUCKET_COL_NAME` varchar(256) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `INTEGER_IDX` int(11) NOT NULL,
  PRIMARY KEY (`SD_ID`,`INTEGER_IDX`),
  KEY `BUCKETING_COLS_N49` (`SD_ID`),
  CONSTRAINT `BUCKETING_COLS_FK1` FOREIGN KEY (`SD_ID`) REFERENCES `SDS` (`SD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BUCKETING_COLS`
--

/*!40000 ALTER TABLE `BUCKETING_COLS` DISABLE KEYS */;
/*!40000 ALTER TABLE `BUCKETING_COLS` ENABLE KEYS */;

--
-- Table structure for table `CDS`
--

DROP TABLE IF EXISTS `CDS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CDS` (
  `CD_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`CD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CDS`
--

/*!40000 ALTER TABLE `CDS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CDS` ENABLE KEYS */;

--
-- Table structure for table `COLUMNS_V2`
--

DROP TABLE IF EXISTS `COLUMNS_V2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `COLUMNS_V2` (
  `CD_ID` bigint(20) NOT NULL,
  `COMMENT` varchar(256) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `COLUMN_NAME` varchar(767) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `TYPE_NAME` mediumtext DEFAULT NULL,
  `INTEGER_IDX` int(11) NOT NULL,
  PRIMARY KEY (`CD_ID`,`COLUMN_NAME`),
  KEY `COLUMNS_V2_N49` (`CD_ID`),
  CONSTRAINT `COLUMNS_V2_FK1` FOREIGN KEY (`CD_ID`) REFERENCES `CDS` (`CD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COLUMNS_V2`
--

/*!40000 ALTER TABLE `COLUMNS_V2` DISABLE KEYS */;
/*!40000 ALTER TABLE `COLUMNS_V2` ENABLE KEYS */;

--
-- Table structure for table `COMPACTION_QUEUE`
--

DROP TABLE IF EXISTS `COMPACTION_QUEUE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `COMPACTION_QUEUE` (
  `CQ_ID` bigint(20) NOT NULL,
  `CQ_DATABASE` varchar(128) NOT NULL,
  `CQ_TABLE` varchar(128) NOT NULL,
  `CQ_PARTITION` varchar(767) DEFAULT NULL,
  `CQ_STATE` char(1) NOT NULL,
  `CQ_TYPE` char(1) NOT NULL,
  `CQ_TBLPROPERTIES` varchar(2048) DEFAULT NULL,
  `CQ_WORKER_ID` varchar(128) DEFAULT NULL,
  `CQ_START` bigint(20) DEFAULT NULL,
  `CQ_RUN_AS` varchar(128) DEFAULT NULL,
  `CQ_HIGHEST_WRITE_ID` bigint(20) DEFAULT NULL,
  `CQ_META_INFO` varbinary(2048) DEFAULT NULL,
  `CQ_HADOOP_JOB_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`CQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMPACTION_QUEUE`
--

/*!40000 ALTER TABLE `COMPACTION_QUEUE` DISABLE KEYS */;
/*!40000 ALTER TABLE `COMPACTION_QUEUE` ENABLE KEYS */;

--
-- Table structure for table `COMPLETED_COMPACTIONS`
--

DROP TABLE IF EXISTS `COMPLETED_COMPACTIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `COMPLETED_COMPACTIONS` (
  `CC_ID` bigint(20) NOT NULL,
  `CC_DATABASE` varchar(128) NOT NULL,
  `CC_TABLE` varchar(128) NOT NULL,
  `CC_PARTITION` varchar(767) DEFAULT NULL,
  `CC_STATE` char(1) NOT NULL,
  `CC_TYPE` char(1) NOT NULL,
  `CC_TBLPROPERTIES` varchar(2048) DEFAULT NULL,
  `CC_WORKER_ID` varchar(128) DEFAULT NULL,
  `CC_START` bigint(20) DEFAULT NULL,
  `CC_END` bigint(20) DEFAULT NULL,
  `CC_RUN_AS` varchar(128) DEFAULT NULL,
  `CC_HIGHEST_WRITE_ID` bigint(20) DEFAULT NULL,
  `CC_META_INFO` varbinary(2048) DEFAULT NULL,
  `CC_HADOOP_JOB_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`CC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMPLETED_COMPACTIONS`
--

/*!40000 ALTER TABLE `COMPLETED_COMPACTIONS` DISABLE KEYS */;
/*!40000 ALTER TABLE `COMPLETED_COMPACTIONS` ENABLE KEYS */;

--
-- Table structure for table `COMPLETED_TXN_COMPONENTS`
--

DROP TABLE IF EXISTS `COMPLETED_TXN_COMPONENTS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `COMPLETED_TXN_COMPONENTS` (
  `CTC_TXNID` bigint(20) NOT NULL,
  `CTC_DATABASE` varchar(128) NOT NULL,
  `CTC_TABLE` varchar(256) DEFAULT NULL,
  `CTC_PARTITION` varchar(767) DEFAULT NULL,
  `CTC_TIMESTAMP` timestamp NOT NULL DEFAULT current_timestamp(),
  `CTC_WRITEID` bigint(20) DEFAULT NULL,
  `CTC_UPDATE_DELETE` char(1) NOT NULL,
  KEY `COMPLETED_TXN_COMPONENTS_IDX` (`CTC_DATABASE`,`CTC_TABLE`,`CTC_PARTITION`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMPLETED_TXN_COMPONENTS`
--

/*!40000 ALTER TABLE `COMPLETED_TXN_COMPONENTS` DISABLE KEYS */;
/*!40000 ALTER TABLE `COMPLETED_TXN_COMPONENTS` ENABLE KEYS */;

--
-- Table structure for table `CTLGS`
--

DROP TABLE IF EXISTS `CTLGS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CTLGS` (
  `CTLG_ID` bigint(20) NOT NULL,
  `NAME` varchar(256) DEFAULT NULL,
  `DESC` varchar(4000) DEFAULT NULL,
  `LOCATION_URI` varchar(4000) NOT NULL,
  PRIMARY KEY (`CTLG_ID`),
  UNIQUE KEY `UNIQUE_CATALOG` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CTLGS`
--

/*!40000 ALTER TABLE `CTLGS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CTLGS` ENABLE KEYS */;

--
-- Table structure for table `DATABASE_PARAMS`
--

DROP TABLE IF EXISTS `DATABASE_PARAMS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DATABASE_PARAMS` (
  `DB_ID` bigint(20) NOT NULL,
  `PARAM_KEY` varchar(180) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `PARAM_VALUE` varchar(4000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`DB_ID`,`PARAM_KEY`),
  KEY `DATABASE_PARAMS_N49` (`DB_ID`),
  CONSTRAINT `DATABASE_PARAMS_FK1` FOREIGN KEY (`DB_ID`) REFERENCES `DBS` (`DB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DATABASE_PARAMS`
--

/*!40000 ALTER TABLE `DATABASE_PARAMS` DISABLE KEYS */;
/*!40000 ALTER TABLE `DATABASE_PARAMS` ENABLE KEYS */;

--
-- Table structure for table `DBS`
--

DROP TABLE IF EXISTS `DBS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DBS` (
  `DB_ID` bigint(20) NOT NULL,
  `DESC` varchar(4000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `DB_LOCATION_URI` varchar(4000) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `OWNER_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `OWNER_TYPE` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `CTLG_NAME` varchar(256) NOT NULL,
  PRIMARY KEY (`DB_ID`),
  UNIQUE KEY `UNIQUE_DATABASE` (`NAME`,`CTLG_NAME`),
  KEY `CTLG_FK1` (`CTLG_NAME`),
  CONSTRAINT `CTLG_FK1` FOREIGN KEY (`CTLG_NAME`) REFERENCES `CTLGS` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DBS`
--

/*!40000 ALTER TABLE `DBS` DISABLE KEYS */;
/*!40000 ALTER TABLE `DBS` ENABLE KEYS */;

--
-- Table structure for table `DB_PRIVS`
--

DROP TABLE IF EXISTS `DB_PRIVS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DB_PRIVS` (
  `DB_GRANT_ID` bigint(20) NOT NULL,
  `CREATE_TIME` int(11) NOT NULL,
  `DB_ID` bigint(20) DEFAULT NULL,
  `GRANT_OPTION` smallint(6) NOT NULL,
  `GRANTOR` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `GRANTOR_TYPE` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `PRINCIPAL_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `PRINCIPAL_TYPE` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `DB_PRIV` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `AUTHORIZER` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`DB_GRANT_ID`),
  UNIQUE KEY `DBPRIVILEGEINDEX` (`AUTHORIZER`,`DB_ID`,`PRINCIPAL_NAME`,`PRINCIPAL_TYPE`,`DB_PRIV`,`GRANTOR`,`GRANTOR_TYPE`),
  KEY `DB_PRIVS_N49` (`DB_ID`),
  CONSTRAINT `DB_PRIVS_FK1` FOREIGN KEY (`DB_ID`) REFERENCES `DBS` (`DB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DB_PRIVS`
--

/*!40000 ALTER TABLE `DB_PRIVS` DISABLE KEYS */;
/*!40000 ALTER TABLE `DB_PRIVS` ENABLE KEYS */;

--
-- Table structure for table `DELEGATION_TOKENS`
--

DROP TABLE IF EXISTS `DELEGATION_TOKENS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DELEGATION_TOKENS` (
  `TOKEN_IDENT` varchar(767) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `TOKEN` varchar(767) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`TOKEN_IDENT`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DELEGATION_TOKENS`
--

/*!40000 ALTER TABLE `DELEGATION_TOKENS` DISABLE KEYS */;
/*!40000 ALTER TABLE `DELEGATION_TOKENS` ENABLE KEYS */;

--
-- Table structure for table `FUNCS`
--

DROP TABLE IF EXISTS `FUNCS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FUNCS` (
  `FUNC_ID` bigint(20) NOT NULL,
  `CLASS_NAME` varchar(4000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `CREATE_TIME` int(11) NOT NULL,
  `DB_ID` bigint(20) DEFAULT NULL,
  `FUNC_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `FUNC_TYPE` int(11) NOT NULL,
  `OWNER_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `OWNER_TYPE` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`FUNC_ID`),
  UNIQUE KEY `UNIQUEFUNCTION` (`FUNC_NAME`,`DB_ID`),
  KEY `FUNCS_N49` (`DB_ID`),
  CONSTRAINT `FUNCS_FK1` FOREIGN KEY (`DB_ID`) REFERENCES `DBS` (`DB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FUNCS`
--

/*!40000 ALTER TABLE `FUNCS` DISABLE KEYS */;
/*!40000 ALTER TABLE `FUNCS` ENABLE KEYS */;

--
-- Table structure for table `FUNC_RU`
--

DROP TABLE IF EXISTS `FUNC_RU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FUNC_RU` (
  `FUNC_ID` bigint(20) NOT NULL,
  `RESOURCE_TYPE` int(11) NOT NULL,
  `RESOURCE_URI` varchar(4000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `INTEGER_IDX` int(11) NOT NULL,
  PRIMARY KEY (`FUNC_ID`,`INTEGER_IDX`),
  CONSTRAINT `FUNC_RU_FK1` FOREIGN KEY (`FUNC_ID`) REFERENCES `FUNCS` (`FUNC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FUNC_RU`
--

/*!40000 ALTER TABLE `FUNC_RU` DISABLE KEYS */;
/*!40000 ALTER TABLE `FUNC_RU` ENABLE KEYS */;

--
-- Table structure for table `GLOBAL_PRIVS`
--

DROP TABLE IF EXISTS `GLOBAL_PRIVS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GLOBAL_PRIVS` (
  `USER_GRANT_ID` bigint(20) NOT NULL,
  `CREATE_TIME` int(11) NOT NULL,
  `GRANT_OPTION` smallint(6) NOT NULL,
  `GRANTOR` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `GRANTOR_TYPE` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `PRINCIPAL_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `PRINCIPAL_TYPE` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `USER_PRIV` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `AUTHORIZER` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`USER_GRANT_ID`),
  UNIQUE KEY `GLOBALPRIVILEGEINDEX` (`AUTHORIZER`,`PRINCIPAL_NAME`,`PRINCIPAL_TYPE`,`USER_PRIV`,`GRANTOR`,`GRANTOR_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GLOBAL_PRIVS`
--

/*!40000 ALTER TABLE `GLOBAL_PRIVS` DISABLE KEYS */;
/*!40000 ALTER TABLE `GLOBAL_PRIVS` ENABLE KEYS */;

--
-- Table structure for table `HIVE_LOCKS`
--

DROP TABLE IF EXISTS `HIVE_LOCKS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `HIVE_LOCKS` (
  `HL_LOCK_EXT_ID` bigint(20) NOT NULL,
  `HL_LOCK_INT_ID` bigint(20) NOT NULL,
  `HL_TXNID` bigint(20) NOT NULL,
  `HL_DB` varchar(128) NOT NULL,
  `HL_TABLE` varchar(128) DEFAULT NULL,
  `HL_PARTITION` varchar(767) DEFAULT NULL,
  `HL_LOCK_STATE` char(1) NOT NULL,
  `HL_LOCK_TYPE` char(1) NOT NULL,
  `HL_LAST_HEARTBEAT` bigint(20) NOT NULL,
  `HL_ACQUIRED_AT` bigint(20) DEFAULT NULL,
  `HL_USER` varchar(128) NOT NULL,
  `HL_HOST` varchar(128) NOT NULL,
  `HL_HEARTBEAT_COUNT` int(11) DEFAULT NULL,
  `HL_AGENT_INFO` varchar(128) DEFAULT NULL,
  `HL_BLOCKEDBY_EXT_ID` bigint(20) DEFAULT NULL,
  `HL_BLOCKEDBY_INT_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`HL_LOCK_EXT_ID`,`HL_LOCK_INT_ID`),
  KEY `HIVE_LOCK_TXNID_INDEX` (`HL_TXNID`),
  KEY `HL_TXNID_IDX` (`HL_TXNID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HIVE_LOCKS`
--

/*!40000 ALTER TABLE `HIVE_LOCKS` DISABLE KEYS */;
/*!40000 ALTER TABLE `HIVE_LOCKS` ENABLE KEYS */;

--
-- Table structure for table `IDXS`
--

DROP TABLE IF EXISTS `IDXS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IDXS` (
  `INDEX_ID` bigint(20) NOT NULL,
  `CREATE_TIME` int(11) NOT NULL,
  `DEFERRED_REBUILD` bit(1) NOT NULL,
  `INDEX_HANDLER_CLASS` varchar(4000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `INDEX_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `INDEX_TBL_ID` bigint(20) DEFAULT NULL,
  `LAST_ACCESS_TIME` int(11) NOT NULL,
  `ORIG_TBL_ID` bigint(20) DEFAULT NULL,
  `SD_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`INDEX_ID`),
  UNIQUE KEY `UNIQUEINDEX` (`INDEX_NAME`,`ORIG_TBL_ID`),
  KEY `IDXS_N51` (`SD_ID`),
  KEY `IDXS_N50` (`INDEX_TBL_ID`),
  KEY `IDXS_N49` (`ORIG_TBL_ID`),
  CONSTRAINT `IDXS_FK1` FOREIGN KEY (`ORIG_TBL_ID`) REFERENCES `TBLS` (`TBL_ID`),
  CONSTRAINT `IDXS_FK2` FOREIGN KEY (`SD_ID`) REFERENCES `SDS` (`SD_ID`),
  CONSTRAINT `IDXS_FK3` FOREIGN KEY (`INDEX_TBL_ID`) REFERENCES `TBLS` (`TBL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IDXS`
--

/*!40000 ALTER TABLE `IDXS` DISABLE KEYS */;
/*!40000 ALTER TABLE `IDXS` ENABLE KEYS */;

--
-- Table structure for table `INDEX_PARAMS`
--

DROP TABLE IF EXISTS `INDEX_PARAMS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `INDEX_PARAMS` (
  `INDEX_ID` bigint(20) NOT NULL,
  `PARAM_KEY` varchar(256) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `PARAM_VALUE` varchar(4000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`INDEX_ID`,`PARAM_KEY`),
  KEY `INDEX_PARAMS_N49` (`INDEX_ID`),
  CONSTRAINT `INDEX_PARAMS_FK1` FOREIGN KEY (`INDEX_ID`) REFERENCES `IDXS` (`INDEX_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `INDEX_PARAMS`
--

/*!40000 ALTER TABLE `INDEX_PARAMS` DISABLE KEYS */;
/*!40000 ALTER TABLE `INDEX_PARAMS` ENABLE KEYS */;

--
-- Table structure for table `I_SCHEMA`
--

DROP TABLE IF EXISTS `I_SCHEMA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `I_SCHEMA` (
  `SCHEMA_ID` bigint(20) NOT NULL,
  `SCHEMA_TYPE` int(11) NOT NULL,
  `NAME` varchar(256) DEFAULT NULL,
  `DB_ID` bigint(20) DEFAULT NULL,
  `COMPATIBILITY` int(11) NOT NULL,
  `VALIDATION_LEVEL` int(11) NOT NULL,
  `CAN_EVOLVE` bit(1) NOT NULL,
  `SCHEMA_GROUP` varchar(256) DEFAULT NULL,
  `DESCRIPTION` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`SCHEMA_ID`),
  KEY `DB_ID` (`DB_ID`),
  KEY `UNIQUE_NAME` (`NAME`),
  CONSTRAINT `I_SCHEMA_ibfk_1` FOREIGN KEY (`DB_ID`) REFERENCES `DBS` (`DB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `I_SCHEMA`
--

/*!40000 ALTER TABLE `I_SCHEMA` DISABLE KEYS */;
/*!40000 ALTER TABLE `I_SCHEMA` ENABLE KEYS */;

--
-- Table structure for table `KEY_CONSTRAINTS`
--

DROP TABLE IF EXISTS `KEY_CONSTRAINTS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `KEY_CONSTRAINTS` (
  `CHILD_CD_ID` bigint(20) DEFAULT NULL,
  `CHILD_INTEGER_IDX` int(11) DEFAULT NULL,
  `CHILD_TBL_ID` bigint(20) DEFAULT NULL,
  `PARENT_CD_ID` bigint(20) DEFAULT NULL,
  `PARENT_INTEGER_IDX` int(11) NOT NULL,
  `PARENT_TBL_ID` bigint(20) NOT NULL,
  `POSITION` bigint(20) NOT NULL,
  `CONSTRAINT_NAME` varchar(400) NOT NULL,
  `CONSTRAINT_TYPE` smallint(6) NOT NULL,
  `UPDATE_RULE` smallint(6) DEFAULT NULL,
  `DELETE_RULE` smallint(6) DEFAULT NULL,
  `ENABLE_VALIDATE_RELY` smallint(6) NOT NULL,
  `DEFAULT_VALUE` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`CONSTRAINT_NAME`,`POSITION`),
  KEY `CONSTRAINTS_PARENT_TABLE_ID_INDEX` (`PARENT_TBL_ID`) USING BTREE,
  KEY `CONSTRAINTS_CONSTRAINT_TYPE_INDEX` (`CONSTRAINT_TYPE`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `KEY_CONSTRAINTS`
--

/*!40000 ALTER TABLE `KEY_CONSTRAINTS` DISABLE KEYS */;
/*!40000 ALTER TABLE `KEY_CONSTRAINTS` ENABLE KEYS */;

--
-- Table structure for table `MASTER_KEYS`
--

DROP TABLE IF EXISTS `MASTER_KEYS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MASTER_KEYS` (
  `KEY_ID` int(11) NOT NULL AUTO_INCREMENT,
  `MASTER_KEY` varchar(767) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`KEY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MASTER_KEYS`
--

/*!40000 ALTER TABLE `MASTER_KEYS` DISABLE KEYS */;
/*!40000 ALTER TABLE `MASTER_KEYS` ENABLE KEYS */;

--
-- Table structure for table `MATERIALIZATION_REBUILD_LOCKS`
--

DROP TABLE IF EXISTS `MATERIALIZATION_REBUILD_LOCKS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MATERIALIZATION_REBUILD_LOCKS` (
  `MRL_TXN_ID` bigint(20) NOT NULL,
  `MRL_DB_NAME` varchar(128) NOT NULL,
  `MRL_TBL_NAME` varchar(256) NOT NULL,
  `MRL_LAST_HEARTBEAT` bigint(20) NOT NULL,
  PRIMARY KEY (`MRL_TXN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MATERIALIZATION_REBUILD_LOCKS`
--

/*!40000 ALTER TABLE `MATERIALIZATION_REBUILD_LOCKS` DISABLE KEYS */;
/*!40000 ALTER TABLE `MATERIALIZATION_REBUILD_LOCKS` ENABLE KEYS */;

--
-- Table structure for table `METASTORE_DB_PROPERTIES`
--

DROP TABLE IF EXISTS `METASTORE_DB_PROPERTIES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `METASTORE_DB_PROPERTIES` (
  `PROPERTY_KEY` varchar(255) NOT NULL,
  `PROPERTY_VALUE` varchar(1000) NOT NULL,
  `DESCRIPTION` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`PROPERTY_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `METASTORE_DB_PROPERTIES`
--

/*!40000 ALTER TABLE `METASTORE_DB_PROPERTIES` DISABLE KEYS */;
/*!40000 ALTER TABLE `METASTORE_DB_PROPERTIES` ENABLE KEYS */;

--
-- Table structure for table `MIN_HISTORY_LEVEL`
--

DROP TABLE IF EXISTS `MIN_HISTORY_LEVEL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MIN_HISTORY_LEVEL` (
  `MHL_TXNID` bigint(20) NOT NULL,
  `MHL_MIN_OPEN_TXNID` bigint(20) NOT NULL,
  PRIMARY KEY (`MHL_TXNID`),
  KEY `MIN_HISTORY_LEVEL_IDX` (`MHL_MIN_OPEN_TXNID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MIN_HISTORY_LEVEL`
--

/*!40000 ALTER TABLE `MIN_HISTORY_LEVEL` DISABLE KEYS */;
/*!40000 ALTER TABLE `MIN_HISTORY_LEVEL` ENABLE KEYS */;

--
-- Table structure for table `MV_CREATION_METADATA`
--

DROP TABLE IF EXISTS `MV_CREATION_METADATA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MV_CREATION_METADATA` (
  `MV_CREATION_METADATA_ID` bigint(20) NOT NULL,
  `CAT_NAME` varchar(256) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `DB_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `TBL_NAME` varchar(256) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `TXN_LIST` text DEFAULT NULL,
  `MATERIALIZATION_TIME` bigint(20) NOT NULL,
  PRIMARY KEY (`MV_CREATION_METADATA_ID`),
  KEY `MV_UNIQUE_TABLE` (`TBL_NAME`,`DB_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MV_CREATION_METADATA`
--

/*!40000 ALTER TABLE `MV_CREATION_METADATA` DISABLE KEYS */;
/*!40000 ALTER TABLE `MV_CREATION_METADATA` ENABLE KEYS */;

--
-- Table structure for table `MV_TABLES_USED`
--

DROP TABLE IF EXISTS `MV_TABLES_USED`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MV_TABLES_USED` (
  `MV_CREATION_METADATA_ID` bigint(20) NOT NULL,
  `TBL_ID` bigint(20) NOT NULL,
  KEY `MV_TABLES_USED_FK1` (`MV_CREATION_METADATA_ID`),
  KEY `MV_TABLES_USED_FK2` (`TBL_ID`),
  CONSTRAINT `MV_TABLES_USED_FK1` FOREIGN KEY (`MV_CREATION_METADATA_ID`) REFERENCES `MV_CREATION_METADATA` (`MV_CREATION_METADATA_ID`),
  CONSTRAINT `MV_TABLES_USED_FK2` FOREIGN KEY (`TBL_ID`) REFERENCES `TBLS` (`TBL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MV_TABLES_USED`
--

/*!40000 ALTER TABLE `MV_TABLES_USED` DISABLE KEYS */;
/*!40000 ALTER TABLE `MV_TABLES_USED` ENABLE KEYS */;

--
-- Table structure for table `NEXT_COMPACTION_QUEUE_ID`
--

DROP TABLE IF EXISTS `NEXT_COMPACTION_QUEUE_ID`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NEXT_COMPACTION_QUEUE_ID` (
  `NCQ_NEXT` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NEXT_COMPACTION_QUEUE_ID`
--

/*!40000 ALTER TABLE `NEXT_COMPACTION_QUEUE_ID` DISABLE KEYS */;
/*!40000 ALTER TABLE `NEXT_COMPACTION_QUEUE_ID` ENABLE KEYS */;

--
-- Table structure for table `NEXT_LOCK_ID`
--

DROP TABLE IF EXISTS `NEXT_LOCK_ID`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NEXT_LOCK_ID` (
  `NL_NEXT` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NEXT_LOCK_ID`
--

/*!40000 ALTER TABLE `NEXT_LOCK_ID` DISABLE KEYS */;
/*!40000 ALTER TABLE `NEXT_LOCK_ID` ENABLE KEYS */;

--
-- Table structure for table `NEXT_TXN_ID`
--

DROP TABLE IF EXISTS `NEXT_TXN_ID`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NEXT_TXN_ID` (
  `NTXN_NEXT` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NEXT_TXN_ID`
--

/*!40000 ALTER TABLE `NEXT_TXN_ID` DISABLE KEYS */;
/*!40000 ALTER TABLE `NEXT_TXN_ID` ENABLE KEYS */;

--
-- Table structure for table `NEXT_WRITE_ID`
--

DROP TABLE IF EXISTS `NEXT_WRITE_ID`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NEXT_WRITE_ID` (
  `NWI_DATABASE` varchar(128) NOT NULL,
  `NWI_TABLE` varchar(256) NOT NULL,
  `NWI_NEXT` bigint(20) NOT NULL,
  UNIQUE KEY `NEXT_WRITE_ID_IDX` (`NWI_DATABASE`,`NWI_TABLE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NEXT_WRITE_ID`
--

/*!40000 ALTER TABLE `NEXT_WRITE_ID` DISABLE KEYS */;
/*!40000 ALTER TABLE `NEXT_WRITE_ID` ENABLE KEYS */;

--
-- Table structure for table `NOTIFICATION_LOG`
--

DROP TABLE IF EXISTS `NOTIFICATION_LOG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NOTIFICATION_LOG` (
  `NL_ID` bigint(20) NOT NULL,
  `EVENT_ID` bigint(20) NOT NULL,
  `EVENT_TIME` int(11) NOT NULL,
  `EVENT_TYPE` varchar(32) NOT NULL,
  `CAT_NAME` varchar(256) DEFAULT NULL,
  `DB_NAME` varchar(128) DEFAULT NULL,
  `TBL_NAME` varchar(256) DEFAULT NULL,
  `MESSAGE` longtext DEFAULT NULL,
  `MESSAGE_FORMAT` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`NL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NOTIFICATION_LOG`
--

/*!40000 ALTER TABLE `NOTIFICATION_LOG` DISABLE KEYS */;
/*!40000 ALTER TABLE `NOTIFICATION_LOG` ENABLE KEYS */;

--
-- Table structure for table `NOTIFICATION_SEQUENCE`
--

DROP TABLE IF EXISTS `NOTIFICATION_SEQUENCE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NOTIFICATION_SEQUENCE` (
  `NNI_ID` bigint(20) NOT NULL,
  `NEXT_EVENT_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`NNI_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NOTIFICATION_SEQUENCE`
--

/*!40000 ALTER TABLE `NOTIFICATION_SEQUENCE` DISABLE KEYS */;
/*!40000 ALTER TABLE `NOTIFICATION_SEQUENCE` ENABLE KEYS */;

--
-- Table structure for table `NUCLEUS_TABLES`
--

DROP TABLE IF EXISTS `NUCLEUS_TABLES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NUCLEUS_TABLES` (
  `CLASS_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `TABLE_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `TYPE` varchar(4) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `OWNER` varchar(2) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `VERSION` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `INTERFACE_NAME` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`CLASS_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NUCLEUS_TABLES`
--

/*!40000 ALTER TABLE `NUCLEUS_TABLES` DISABLE KEYS */;
/*!40000 ALTER TABLE `NUCLEUS_TABLES` ENABLE KEYS */;

--
-- Table structure for table `PARTITIONS`
--

DROP TABLE IF EXISTS `PARTITIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PARTITIONS` (
  `PART_ID` bigint(20) NOT NULL,
  `CREATE_TIME` int(11) NOT NULL,
  `LAST_ACCESS_TIME` int(11) NOT NULL,
  `PART_NAME` varchar(767) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `SD_ID` bigint(20) DEFAULT NULL,
  `TBL_ID` bigint(20) DEFAULT NULL,
  `WRITE_ID` bigint(20) DEFAULT 0,
  PRIMARY KEY (`PART_ID`),
  UNIQUE KEY `UNIQUEPARTITION` (`PART_NAME`,`TBL_ID`),
  KEY `PARTITIONS_N49` (`TBL_ID`),
  KEY `PARTITIONS_N50` (`SD_ID`),
  CONSTRAINT `PARTITIONS_FK1` FOREIGN KEY (`TBL_ID`) REFERENCES `TBLS` (`TBL_ID`),
  CONSTRAINT `PARTITIONS_FK2` FOREIGN KEY (`SD_ID`) REFERENCES `SDS` (`SD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PARTITIONS`
--

/*!40000 ALTER TABLE `PARTITIONS` DISABLE KEYS */;
/*!40000 ALTER TABLE `PARTITIONS` ENABLE KEYS */;

--
-- Table structure for table `PARTITION_EVENTS`
--

DROP TABLE IF EXISTS `PARTITION_EVENTS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PARTITION_EVENTS` (
  `PART_NAME_ID` bigint(20) NOT NULL,
  `CAT_NAME` varchar(256) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `DB_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `EVENT_TIME` bigint(20) NOT NULL,
  `EVENT_TYPE` int(11) NOT NULL,
  `PARTITION_NAME` varchar(767) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `TBL_NAME` varchar(256) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`PART_NAME_ID`),
  KEY `PARTITIONEVENTINDEX` (`PARTITION_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PARTITION_EVENTS`
--

/*!40000 ALTER TABLE `PARTITION_EVENTS` DISABLE KEYS */;
/*!40000 ALTER TABLE `PARTITION_EVENTS` ENABLE KEYS */;

--
-- Table structure for table `PARTITION_KEYS`
--

DROP TABLE IF EXISTS `PARTITION_KEYS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PARTITION_KEYS` (
  `TBL_ID` bigint(20) NOT NULL,
  `PKEY_COMMENT` varchar(4000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `PKEY_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `PKEY_TYPE` varchar(767) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `INTEGER_IDX` int(11) NOT NULL,
  PRIMARY KEY (`TBL_ID`,`PKEY_NAME`),
  KEY `PARTITION_KEYS_N49` (`TBL_ID`),
  CONSTRAINT `PARTITION_KEYS_FK1` FOREIGN KEY (`TBL_ID`) REFERENCES `TBLS` (`TBL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PARTITION_KEYS`
--

/*!40000 ALTER TABLE `PARTITION_KEYS` DISABLE KEYS */;
/*!40000 ALTER TABLE `PARTITION_KEYS` ENABLE KEYS */;

--
-- Table structure for table `PARTITION_KEY_VALS`
--

DROP TABLE IF EXISTS `PARTITION_KEY_VALS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PARTITION_KEY_VALS` (
  `PART_ID` bigint(20) NOT NULL,
  `PART_KEY_VAL` varchar(256) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `INTEGER_IDX` int(11) NOT NULL,
  PRIMARY KEY (`PART_ID`,`INTEGER_IDX`),
  KEY `PARTITION_KEY_VALS_N49` (`PART_ID`),
  CONSTRAINT `PARTITION_KEY_VALS_FK1` FOREIGN KEY (`PART_ID`) REFERENCES `PARTITIONS` (`PART_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PARTITION_KEY_VALS`
--

/*!40000 ALTER TABLE `PARTITION_KEY_VALS` DISABLE KEYS */;
/*!40000 ALTER TABLE `PARTITION_KEY_VALS` ENABLE KEYS */;

--
-- Table structure for table `PARTITION_PARAMS`
--

DROP TABLE IF EXISTS `PARTITION_PARAMS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PARTITION_PARAMS` (
  `PART_ID` bigint(20) NOT NULL,
  `PARAM_KEY` varchar(256) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `PARAM_VALUE` varchar(4000) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`PART_ID`,`PARAM_KEY`),
  KEY `PARTITION_PARAMS_N49` (`PART_ID`),
  CONSTRAINT `PARTITION_PARAMS_FK1` FOREIGN KEY (`PART_ID`) REFERENCES `PARTITIONS` (`PART_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PARTITION_PARAMS`
--

/*!40000 ALTER TABLE `PARTITION_PARAMS` DISABLE KEYS */;
/*!40000 ALTER TABLE `PARTITION_PARAMS` ENABLE KEYS */;

--
-- Table structure for table `PART_COL_PRIVS`
--

DROP TABLE IF EXISTS `PART_COL_PRIVS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PART_COL_PRIVS` (
  `PART_COLUMN_GRANT_ID` bigint(20) NOT NULL,
  `COLUMN_NAME` varchar(767) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `CREATE_TIME` int(11) NOT NULL,
  `GRANT_OPTION` smallint(6) NOT NULL,
  `GRANTOR` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `GRANTOR_TYPE` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `PART_ID` bigint(20) DEFAULT NULL,
  `PRINCIPAL_NAME` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `PRINCIPAL_TYPE` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `PART_COL_PRIV` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `AUTHORIZER` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`PART_COLUMN_GRANT_ID`),
  KEY `PART_COL_PRIVS_N49` (`PART_ID`),
  KEY `PARTITIONCOLUMNPRIVILEGEINDEX` (`AUTHORIZER`,`PART_ID`,`COLUMN_NAME`,`PRINCIPAL_NAME`,`PRINCIPAL_TYPE`,`PART_COL_PRIV`,`GRANTOR`,`GRANTOR_TYPE`),
  CONSTRAINT `PART_COL_PRIVS_FK1` FOREIGN KEY (`PART_ID`) REFERENCES `PARTITIONS` (`PART_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PART_COL_PRIVS`
--

/*!40000 ALTER TABLE `PART_COL_PRIVS` DISABLE KEYS */;
/*!40000 ALTER TABLE `PART_COL_PRIVS` ENABLE KEYS */;

--

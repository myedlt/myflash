/*
SQLyog Community Edition- MySQL GUI v7.0  
MySQL - 5.0.51b-community-nt : Database - amfphp
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/`amfphp` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;

USE `amfphp`;

/*Table structure for table `player` */

CREATE TABLE `player` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_bin default NULL,
  `team_id` int(11) default NULL,
  `position_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `FK_player` (`team_id`),
  KEY `FK_player_position` (`position_id`),
  CONSTRAINT `FK_player` FOREIGN KEY (`team_id`) REFERENCES `team` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_player_position` FOREIGN KEY (`position_id`) REFERENCES `position` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `player` */

insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (1,'Van der Sar',1,1);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (2,'G. Neville',1,4);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (3,'Ferdinand',1,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (4,'Vidic',1,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (5,'Evra',1,2);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (6,'Ronaldo',1,7);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (7,'Carrick',1,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (8,'Anderson',1,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (9,'Giggs',1,5);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (10,'Rooney',1,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (11,'Berbatov',1,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (12,'Cech',2,1);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (13,'Bosingwa',2,4);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (14,'Alex',2,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (15,'Terry',2,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (16,'Bridge',2,2);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (17,'Lampard',2,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (18,'Deco',2,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (19,'Mikel',2,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (20,'Kalou',2,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (21,'Anelka',2,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (22,'Malouda',2,8);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (23,'Reina',3,1);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (24,'Aurelio',3,4);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (25,'Agger',3,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (26,'Carragher',3,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (27,'Arbeloa',3,2);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (28,'Riera',3,7);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (29,'Gerrard',3,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (30,'Mascherano',3,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (31,'Benayoun',3,5);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (32,'Keane',3,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (33,'Kuyt',3,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (34,'Casillas',4,1);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (35,'Cannavaro',4,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (36,'Heinze',4,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (37,'Marcelo',4,2);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (38,'Sergio Ramos',4,4);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (39,'Guti',4,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (40,'Gago',4,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (41,'Sneijder',4,7);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (42,'Van der Vaart',4,5);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (43,'Saviola',4,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (44,'Higuan',4,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (45,'Valdes',5,1);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (46,'Alves',5,2);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (47,'Puyol',5,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (48,'Pique',5,4);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (49,'Marquez',5,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (50,'Toure',5,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (51,'Xavi',5,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (52,'Gudjonhsen',5,8);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (53,'Messi',5,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (54,'Eto\'o',5,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (55,'Henry',5,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (56,'Julio Cesar',6,1);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (57,'Maicon',6,4);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (58,'Maxwell',6,2);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (59,'Cordoba',6,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (60,'Samuel',6,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (61,'Vieira',6,9);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (62,'Cambiasso',6,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (63,'Zanetti',6,7);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (64,'Quaresma',6,5);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (65,'Ibrahimovic',6,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (66,'Cruz',6,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (67,'Abbiati',7,1);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (68,'Maldini',7,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (69,'Zambrotta',7,4);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (70,'Kaladze',7,3);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (71,'Jankulowski',7,2);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (72,'Pirlo',7,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (73,'Ambrosini',7,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (74,'Flamini',7,6);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (75,'Inzaghi',7,10);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (76,'Seedorf',7,8);
insert  into `player`(`id`,`name`,`team_id`,`position_id`) values (77,'Ronaldniho',NULL,8);

/*Table structure for table `position` */

CREATE TABLE `position` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) collate utf8_bin default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `position` */

insert  into `position`(`id`,`title`) values (1,'Goalkeeper');
insert  into `position`(`id`,`title`) values (2,'Left defender');
insert  into `position`(`id`,`title`) values (3,'Center defender');
insert  into `position`(`id`,`title`) values (4,'Right defender');
insert  into `position`(`id`,`title`) values (5,'Left midfielder');
insert  into `position`(`id`,`title`) values (6,'Center midfielder');
insert  into `position`(`id`,`title`) values (7,'Right midfielder');
insert  into `position`(`id`,`title`) values (8,'Offensive midfielder');
insert  into `position`(`id`,`title`) values (9,'Defensive midfielder');
insert  into `position`(`id`,`title`) values (10,'Attacker');

/*Table structure for table `team` */

CREATE TABLE `team` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) collate utf8_bin default NULL,
  `league` varchar(255) collate utf8_bin NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `team` */

insert  into `team`(`id`,`title`,`league`) values (1,'Manchester United','English Premiership League');
insert  into `team`(`id`,`title`,`league`) values (2,'Chelsea','English Premiership League');
insert  into `team`(`id`,`title`,`league`) values (3,'Liverpool','English Premiership League');
insert  into `team`(`id`,`title`,`league`) values (4,'Real Madrid','Spanish Primera Division');
insert  into `team`(`id`,`title`,`league`) values (5,'Barcelona','Spanish Primera Division');
insert  into `team`(`id`,`title`,`league`) values (6,'Inter','Italian Seria A');
insert  into `team`(`id`,`title`,`league`) values (7,'Milica','Italian Seria A');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

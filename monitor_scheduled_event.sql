/*定义存储过程用以创建 monitor_data_event_yyyymmdd, yyyymmdd 的值为第二天的日期*/
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_monitor_data_proc`()
BEGIN
declare str_date varchar(16);
SET str_date = date_format(date_add(now(), interval 1 day),"%Y%m%d");
SET @sqlcmd1 = CONCAT("CREATE TABLE `monitor_data_event_",str_date,"` (
  `id` int(64) unsigned NOT NULL AUTO_INCREMENT,
  `menu_code` varchar(255) NOT NULL DEFAULT '',
  `figure` double DEFAULT NULL,
  `ipport` varchar(30) DEFAULT NULL,
  `event_create_time` timestamp NULL DEFAULT NULL,
  `upload_interval` int(11) DEFAULT '60',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_menu_code` (`menu_code`),
  KEY `idx_event_create_time` (`event_create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=27271 DEFAULT CHARSET=utf8;");
PREPARE p1 FROM @sqlcmd1;
EXECUTE p1;
DEALLOCATE PREPARE p1;
END
//

/*定义定时任务，每天凌晨 2 点执行*/
DELIMITER //
CREATE EVENT `execute_create_monitor_data_proc`
 ON SCHEDULE
    every 1 day starts '2014-01-01 02:00:00'
    on completion preserve
    DO CALL create_monitor_data_proc();
//

/*
show variables like '%sche%';
SET GLOBAL event_scheduler = ON;
select * from mysql.event;
delete from mysql.event where name = 'execute_create_monitor_data_proc';
alter event execute_create_monitor_data_proc ON COMPLETION PRESERVE DISABLE;
alter event execute_create_monitor_data_proc ON COMPLETION PRESERVE ENABLE;
call create_monitor_data_proc();
*/


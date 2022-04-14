-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPAISESDIOT
DELIMITER ;
DROP TABLE IF EXISTS `CATPAISESDIOT`;DELIMITER $$

CREATE TABLE `CATPAISESDIOT` (
  `Clave` char(2) NOT NULL,
  `Pais` varchar(200) NOT NULL COMMENT 'Catalogo de Paises del SAT',
  `Nacionalidad` varchar(45) DEFAULT NULL COMMENT 'Nacionalidad ',
  PRIMARY KEY (`Clave`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
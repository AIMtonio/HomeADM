-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCABECERADEPREFAUTO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCABECERADEPREFAUTO`;DELIMITER $$

CREATE TABLE `TMPCABECERADEPREFAUTO` (
  `ConsecutivoID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave primaria de la tabla',
  `Registro` int(11) DEFAULT NULL COMMENT 'Registro de la cabecera constante 22',
  `NoCuenta` varchar(18) DEFAULT NULL COMMENT 'Numero de cuenta en la que se efectuo el movimiento',
  `NombreFichero` varchar(150) DEFAULT NULL COMMENT 'Nombre del Fichero',
  PRIMARY KEY (`ConsecutivoID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='TAB: Tabla que contiene los nombres y rutas de archivos a de depositos referenciados'$$
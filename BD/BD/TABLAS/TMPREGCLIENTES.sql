-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREGCLIENTES
DELIMITER ;
DROP TABLE IF EXISTS `TMPREGCLIENTES`;DELIMITER $$

CREATE TABLE `TMPREGCLIENTES` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del cliente',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'ID del estado de la direccion del cliente',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'ID del municipio de la direccion del cliente',
  `ColoniaID` int(11) DEFAULT NULL,
  `CodigoPostal` varchar(5) DEFAULT NULL,
  `Sexo` char(1) DEFAULT NULL COMMENT 'Sexo del Cliente F = femenino,  M = masculino',
  `FechaAlta` date DEFAULT NULL COMMENT 'Fecha en la que se dio de alta al cliente',
  `EsMenorEdad` char(1) DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Numero de transaccion que genera el reporte',
  PRIMARY KEY (`ClienteID`,`NumTransaccion`),
  KEY `idxEstmp` (`EstadoID`),
  KEY `idxMuniTmp` (`MunicipioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para reportes regulatorios, Almacena datos de'$$
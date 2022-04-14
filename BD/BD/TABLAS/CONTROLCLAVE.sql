-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTROLCLAVE
DELIMITER ;
DROP TABLE IF EXISTS `CONTROLCLAVE`;DELIMITER $$

CREATE TABLE `CONTROLCLAVE` (
  `ClienteID` varchar(30) NOT NULL COMMENT 'Identificador del Cliente\n',
  `Anio` char(4) NOT NULL COMMENT 'Año en el que sera valido la Clave',
  `Mes` char(2) NOT NULL COMMENT 'Mes en el que sera valido la Clave',
  `ClaveKey` varchar(100) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(100) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`,`Anio`,`Mes`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
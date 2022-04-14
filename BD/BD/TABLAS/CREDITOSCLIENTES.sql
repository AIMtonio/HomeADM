-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSCLIENTES
DELIMITER ;
DROP TABLE IF EXISTS `CREDITOSCLIENTES`;DELIMITER $$

CREATE TABLE `CREDITOSCLIENTES` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del Cliente	',
  `NumeroCreditos` int(11) DEFAULT NULL COMMENT 'Corresponde a la suma de lineas de credito y creditos otorgados',
  `FechaUltCre` date DEFAULT NULL COMMENT 'Fecha de Ultimo Credito o linea de Credito Otorgado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Creditos por Cliente, para el calculo del identificador del credito CNBV'$$
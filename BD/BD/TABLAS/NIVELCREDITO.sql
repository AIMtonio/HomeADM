-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NIVELCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `NIVELCREDITO`;DELIMITER $$

CREATE TABLE `NIVELCREDITO` (
  `NivelID` int(11) NOT NULL COMMENT 'ID nivel de credito',
  `Descripcion` varchar(20) NOT NULL COMMENT 'Descripcion nivel',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria Programa',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`NivelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los niveles que se pueden asignar a un credito'$$
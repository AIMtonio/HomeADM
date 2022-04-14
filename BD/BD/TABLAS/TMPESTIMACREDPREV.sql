-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPESTIMACREDPREV
DELIMITER ;
DROP TABLE IF EXISTS `TMPESTIMACREDPREV`;DELIMITER $$

CREATE TABLE `TMPESTIMACREDPREV` (
  `Consecutivo` int(11) NOT NULL COMMENT 'Consecutivo para iteracion de la tabla',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `Capital` decimal(14,2) DEFAULT '0.00' COMMENT 'Capital de credito',
  `Interes` decimal(14,2) DEFAULT '0.00' COMMENT 'Interes del credito',
  `PorcReservaExp` decimal(14,4) DEFAULT '0.0000' COMMENT 'Porcentaje para el calculo de reserva',
  `Clasificacion` char(1) DEFAULT '' COMMENT 'Clasificacion del Tipo de credito',
  `CuentaID` bigint(12) DEFAULT '0' COMMENT 'Cuenta del Cliente',
  `ClienteID` int(11) DEFAULT '0' COMMENT 'Cliente ID',
  `Origen` char(1) DEFAULT '' COMMENT 'Indica si el credito es Reestructura o no',
  `EsMarginada` char(1) DEFAULT '' COMMENT 'Indica si el cliente vive en zona marginada o no',
  `SubClasifID` int(11) DEFAULT '0' COMMENT 'Indica la clasificacion del credito determinada por el DestinoCreID',
  `Reacreditado` char(1) DEFAULT '' COMMENT 'Indica si el credito es reacreditado o no',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Consecutivo`),
  KEY `IDX_TMPESTIMACREDPREV` (`CreditoID`,`ClienteID`,`CuentaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal utilizada para realizar el calculo de reserva al cierre de mes'$$
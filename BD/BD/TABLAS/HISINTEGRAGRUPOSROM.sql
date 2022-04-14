-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISINTEGRAGRUPOSROM
DELIMITER ;
DROP TABLE IF EXISTS `HISINTEGRAGRUPOSROM`;DELIMITER $$

CREATE TABLE `HISINTEGRAGRUPOSROM` (
  `RompimientoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de rompimientos',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente que se esta desintegrando del grupo',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'Prospecto que se esta desintegrando del grupo',
  `GrupoID` int(10) NOT NULL DEFAULT '0' COMMENT 'Grupo al que se esta realizando el rompimiento',
  `Ciclo` int(11) DEFAULT NULL COMMENT 'Ciclo en el que iba el cliente',
  `SolicitudCreditoID` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Solicitud de credito del cliente/prospecto que se esta desintegrando',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus en el que estaba el integrante',
  `ProrrateaPago` char(1) DEFAULT NULL COMMENT 'Prorratea pago S= si, N=no',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'Fecha del sistema en que se genera el rompimiento',
  `Cargo` int(11) DEFAULT NULL COMMENT 'Cargo en el grupo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(15) DEFAULT NULL,
  PRIMARY KEY (`RompimientoID`,`GrupoID`,`SolicitudCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda el historial de los integrantes del grupo antes del r'$$
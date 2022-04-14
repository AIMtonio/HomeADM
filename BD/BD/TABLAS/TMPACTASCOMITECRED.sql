-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPACTASCOMITECRED
DELIMITER ;
DROP TABLE IF EXISTS `TMPACTASCOMITECRED`;DELIMITER $$

CREATE TABLE `TMPACTASCOMITECRED` (
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'ID DE SOLICITUD DE CREDITO',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'ID DE SUCURSAL',
  `NombreSucurs` varchar(45) DEFAULT NULL COMMENT 'NOMBRE DE SUCURSAL',
  `ClienteID` bigint(20) DEFAULT NULL COMMENT 'ID DE CLIENTE',
  `NombreCliente` varchar(100) DEFAULT NULL COMMENT 'NOMBRE COMPLETO DEL CLIENTE',
  `ProductoCredito` varchar(50) DEFAULT NULL COMMENT 'PRODUCTO CREDITO',
  `Tasa` decimal(8,2) DEFAULT NULL COMMENT 'TASA FIJA',
  `MontoSolicitado` decimal(12,2) DEFAULT NULL COMMENT 'MONTO SOLICITADO',
  `MontoAutorizado` decimal(12,2) DEFAULT NULL COMMENT 'MONTO AUTORIZADO',
  `Estatus` varchar(45) DEFAULT NULL,
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'CLASIFICACION DEL CLIENTE E=EMPLEADO O=FUNCIONARIO I=INDEPENDIENTE',
  `TipoCredito` char(1) DEFAULT NULL COMMENT 'TIPO CREDITO N=NUEVO O=RENOVADO R=REESTRUCTURADO',
  PRIMARY KEY (`SolicitudCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA PARA ALMACENAR DETALLE DE ACTAS DE COMITE USADA EN EL SP COMITECREDITOREP'$$
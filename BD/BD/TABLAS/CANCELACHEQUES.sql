-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELACHEQUES
DELIMITER ;
DROP TABLE IF EXISTS `CANCELACHEQUES`;DELIMITER $$

CREATE TABLE `CANCELACHEQUES` (
  `CancelaChequeID` int(11) NOT NULL COMMENT 'Consecutivo de cancelacion de cheque',
  `InstitucionID` int(11) NOT NULL COMMENT 'Numero de institucion del cheque',
  `NumCtaInstit` varchar(20) NOT NULL COMMENT 'Numero de cuenta de la institucion',
  `NumCheque` int(10) NOT NULL COMMENT 'Numero de cheque cancelado',
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal del cheque',
  `FechaCancela` date NOT NULL COMMENT 'Fecha de la cancelacion',
  `UsuarioCancelaID` int(11) NOT NULL COMMENT 'ID del usuario que realiza la cancelacion',
  `NumReqGasID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID de la requisicion del cheque',
  `ProveedorID` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de proveedor del cheque',
  `NumFactura` varchar(20) NOT NULL DEFAULT '' COMMENT 'No. de facura del cheque',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto del cheque',
  `MotivoID` int(11) NOT NULL COMMENT 'ID del motivo de cancelacion',
  `Comentario` varchar(500) NOT NULL COMMENT 'Comentario de la cancelacion',
  `TipoCancelacion` int(11) NOT NULL COMMENT '1 Gastos y anticipos, 2 Dispersion c/factura, 3 dispersion s/factura',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CancelaChequeID`),
  KEY `fk_SUCURSALES_2` (`SucursalID`),
  CONSTRAINT `fk_SUCURSALES_2` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena datos de la pantalla Tesoreria-Bancos-Cancelacion Cheques'$$
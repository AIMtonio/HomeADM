-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDDISPMULTIPLE
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDDISPMULTIPLE`;
DELIMITER $$

CREATE TABLE `TMPCREDDISPMULTIPLE` (
  `IDTmp` int(11) NOT NULL COMMENT 'ID de la Tabla',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal donde se dio de alta el credito',
  `TipoDispersion` char(1) DEFAULT NULL COMMENT 'Tipo de Dispersion\\n	S .- SPEI\\n	C .- Cheque\\n	O .- Orden de Pago\\n	E.- Efectivo',
  `CuentaCLABE` char(18) DEFAULT NULL COMMENT 'Cuenta Clabe',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`IDTmp`),
  KEY `FK_ASIGCARTASLIQUIDACION_1_idx` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal que guarda la relación de las Creditos con Cartas de Liquidación.'$$

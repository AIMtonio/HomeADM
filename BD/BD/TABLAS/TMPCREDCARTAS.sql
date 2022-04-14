-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDCARTAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDCARTAS`;
DELIMITER $$

CREATE TABLE `TMPCREDCARTAS` (
  `IDTmp` int(11) NOT NULL COMMENT 'ID de la Tabla',
  `AsignacionCartaID` bigint(11) NOT NULL COMMENT 'ID de Asignación de la Carta.',
  `CasaComercialID` bigint(12) NOT NULL COMMENT 'ID Número de la Casa Comercial',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la Carta de Liquidación',
  `MontoDispersion` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la Dispersion de Carta de Liquidación',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Carta de Asignación con respecto a Dispersion .\nS: si Dispersada \n N: No Dispersada',
  `DispCasa` char(1) DEFAULT NULL COMMENT 'Tipo de Dispersion de .\nS: SPEI \n C: CHEQUE \n  O: Orden de Pago',
  `DispImportada` char(1) DEFAULT NULL COMMENT 'Movimiento Dispersado .\nS: Si Imporada \n N: No importada',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`IDTmp`),
  KEY `FK_ASIGCARTASLIQUIDACION_1_idx` (`CasaComercialID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal que guarda la relación de las Casas Comerciales con Cartas de Liquidación.'$$

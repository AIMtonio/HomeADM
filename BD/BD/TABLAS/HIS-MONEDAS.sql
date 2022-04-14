-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-MONEDAS
DELIMITER ;
DROP TABLE IF EXISTS `HIS-MONEDAS`;
DELIMITER $$


CREATE TABLE `HIS-MONEDAS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `MonedaId` int(11) NOT NULL COMMENT 'Numero de Moneda',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(80) NOT NULL COMMENT 'Descripcion de la \nMoneda\n',
  `DescriCorta` varchar(45) NOT NULL COMMENT 'Descripcion Corta\nde la Moneda',
  `Simbolo` varchar(45) DEFAULT NULL COMMENT 'Simbolo de\nla Moneda\n',
  `TipCamComVen` decimal(14,6) DEFAULT NULL COMMENT 'Tipo de Cambio\nde Compra\nen Ventanilla\n',
  `TipCamVenVen` decimal(14,6) DEFAULT NULL COMMENT 'Tipo de Cambio\nde Venta\nen Ventanilla\n',
  `TipCamComInt` decimal(14,6) DEFAULT NULL COMMENT 'Tipo de Cambio\nde Compra\nen Operaciones\nInternas\n',
  `TipCamVenInt` decimal(14,6) DEFAULT NULL COMMENT 'Tipo de Cambio\nde Venta\nen Operaciones\nInternas',
  `TipoMoneda` char(1) DEFAULT NULL COMMENT 'Tipo de moneda\n1:Nacional\n2:Extranjera\n',
  `TipCamFixCom` decimal(14,6) DEFAULT NULL COMMENT 'Tipo de cambio compra Fix',
  `TipCamFixVen` decimal(14,6) DEFAULT NULL COMMENT 'Tipo de cambio venta Fix',
  `TipCamDof` decimal(14,6) DEFAULT NULL COMMENT 'Tipo de cambio Dof',
  `EqCNBVUIF` varchar(3) DEFAULT NULL COMMENT 'Equivalente a la clave de la moneda de acuerdo a los catalogos de la CNBV y UIF\n',
  `EqBuroCred` varchar(5) DEFAULT NULL COMMENT 'Equivalente a la clave de la moneda de acuerdo a los catalogos de Buro de Credito',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha de movimiento',
  `IDSerieBanxico` varchar(10) DEFAULT '' COMMENT 'Identificador de la Serie a Consultar para el Consumo del WS de BANXICO.',
  `FechaActBanxico` varchar(15) DEFAULT '1900-01-01' COMMENT 'Fecha de Actualización del Consumo del WS de BANXICO.',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (RegistroID),
  KEY `IDX_HISMONEDAS_001` (`IDSerieBanxico`),
  KEY `IDX_HISMONEDAS_002` (`FechaActBanxico`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historial de Catalogo Base de Monedas.'$$

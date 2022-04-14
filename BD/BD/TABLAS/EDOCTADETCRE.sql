-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADETCRE
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTADETCRE`;
DELIMITER $$


CREATE TABLE `EDOCTADETCRE` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `AnioMes` int(11) DEFAULT NULL,
  `SucursalID` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL,
  `FechaOperacion` date DEFAULT NULL,
  `TipoMovimi` int(11) DEFAULT NULL COMMENT '1.- Capital		(1,2,3,4)\n2.- Interes		(10,11,12,13,14)\n3.- IVA''s	 		(20,21,22,23)\n4.- Moratorios		(15)\n5.- Com.FalPago	(40)\n',
  `Descripcion` varchar(150) DEFAULT NULL,
  `Cargos` decimal(14,2) DEFAULT NULL,
  `Abonos` decimal(14,2) DEFAULT NULL,
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Referencia a DetallePoliza para actalizar el FolioUUID despues del Timbrado.',
  `NumAmortizaciones` int(4) DEFAULT NULL COMMENT 'Numero de amortizacion pactadas en el credito',
  `AmoCubiertas` int(4) DEFAULT NULL COMMENT 'Numero de amortizaciones cubiertas',
  `AmoPorCubrir` int(4) DEFAULT NULL COMMENT 'Numero de amortizaciones faltantes por cubrir',
  `CapitalCubierto` decimal(14,2) DEFAULT NULL COMMENT 'Capital Cubierto',
  KEY `IndxCliente` (`ClienteID`),
  KEY `IndxCredito` (`CreditoID`),
  KEY `indexPoliza` (`PolizaID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$

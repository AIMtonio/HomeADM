-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWPAGOCRERESUMEN
DELIMITER ;
DROP TABLE IF EXISTS `CRWPAGOCRERESUMEN`;
DELIMITER $$


CREATE TABLE `CRWPAGOCRERESUMEN` (
  `CreditoID` bigint(12) NOT NULL,
  `Transaccion` bigint(20) NOT NULL,
  `FechaPago` date NOT NULL,
  `MontoPago` decimal(12,2) DEFAULT NULL,
  `TipoPago` int(11) DEFAULT NULL COMMENT 'corresponde a TIPOSPAGOCRE',
  `PolizaID` bigint(20) DEFAULT NULL,
  `EmpresaID` int(12) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`,`Transaccion`,`FechaPago`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registra los tipos de pago a credito para crw'$$ 

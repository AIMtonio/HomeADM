-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMDIAFRECUENCRED
DELIMITER ;
DROP TABLE IF EXISTS `PARAMDIAFRECUENCRED`;DELIMITER $$

CREATE TABLE `PARAMDIAFRECUENCRED` (
  `ProducCreditoID` int(11) NOT NULL COMMENT 'Id del producto de credito',
  `Frecuencia` varchar(1) NOT NULL COMMENT 'Tipo de frecuencia',
  `Dias` int(11) NOT NULL COMMENT 'Dias que deben transcurrir para realizar el cobro de la primera amortización.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProducCreditoID`,`Frecuencia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que guarda la parametrizacion de los dias por frecuencias de creditos.'$$
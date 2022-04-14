-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREQTOSCOBRANZA
DELIMITER ;
DROP TABLE IF EXISTS `TMPREQTOSCOBRANZA`;DELIMITER $$

CREATE TABLE `TMPREQTOSCOBRANZA` (
  `ClienteID` int(11) NOT NULL DEFAULT '0',
  `CreditoID` bigint(12) NOT NULL DEFAULT '0',
  `NombreCliente` varchar(50) DEFAULT NULL,
  `DireccionCliente` varchar(200) DEFAULT NULL,
  `DiasMora` int(11) DEFAULT NULL,
  `FechaExigible` date DEFAULT NULL,
  `MontoExigible` varchar(100) DEFAULT NULL,
  `MontoLetras` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`,`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tabla temporal para los requerimientos generados por credito'$$
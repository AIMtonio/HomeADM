-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQTOSCOBRANZA
DELIMITER ;
DROP TABLE IF EXISTS `REQTOSCOBRANZA`;DELIMITER $$

CREATE TABLE `REQTOSCOBRANZA` (
  `RequerimientoID` int(11) NOT NULL,
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'descripcion del requerimieto',
  `DiasMoraInf` int(11) DEFAULT NULL COMMENT 'limite inferior de dias mora',
  `DiasMoraSup` int(11) DEFAULT NULL COMMENT 'Limite superior de dias mora',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RequerimientoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tabla para los niveles de requerimiento de cobranza'$$
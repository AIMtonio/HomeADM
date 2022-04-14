-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NEGAFILICLIENTE
DELIMITER ;
DROP TABLE IF EXISTS `NEGAFILICLIENTE`;DELIMITER $$

CREATE TABLE `NEGAFILICLIENTE` (
  `NegocioAfiliadoID` int(11) NOT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `ProspectoID` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_NEGAFILIACLIENTE_1_idx` (`NegocioAfiliadoID`),
  KEY `fk_NEGAFILIACLIENTE_2_idx` (`ClienteID`),
  KEY `fk_NEGAFILIACLIENTE_3_idx` (`ProspectoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
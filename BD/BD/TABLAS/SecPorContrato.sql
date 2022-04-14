-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SecPorContrato
DELIMITER ;
DROP TABLE IF EXISTS `SecPorContrato`;DELIMITER $$

CREATE TABLE `SecPorContrato` (
  `idSecPorContrato` int(11) NOT NULL AUTO_INCREMENT,
  `idContratos` int(11) NOT NULL,
  `idSecContrato` int(11) NOT NULL,
  `OrdenEnContrato` int(11) NOT NULL,
  PRIMARY KEY (`idSecPorContrato`,`idContratos`,`idSecContrato`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Definicion de que secciones van en cada contrato y su orden'$$
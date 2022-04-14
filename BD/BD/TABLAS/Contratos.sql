-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- Contratos
DELIMITER ;
DROP TABLE IF EXISTS `Contratos`;DELIMITER $$

CREATE TABLE `Contratos` (
  `idContratos` int(11) NOT NULL,
  `ContratoNombre` varchar(15) DEFAULT NULL,
  `Descripcion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idContratos`),
  UNIQUE KEY `idContratos_UNIQUE` (`idContratos`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Encabezado de Los Contratos'$$
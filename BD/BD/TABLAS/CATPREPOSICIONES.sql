-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPREPOSICIONES
DELIMITER ;
DROP TABLE IF EXISTS `CATPREPOSICIONES`;DELIMITER $$

CREATE TABLE `CATPREPOSICIONES` (
  `PreposicionID` int(11) NOT NULL COMMENT 'Identificador de la Preposicion',
  `Preposicion` varchar(10) NOT NULL COMMENT 'Preposicion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PreposicionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Preposiciones'$$
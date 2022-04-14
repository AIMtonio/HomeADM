
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------

-- TMPCLIENTESPEPLISTAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCLIENTESPEPLISTAS`;

DELIMITER $$
CREATE TABLE `TMPCLIENTESPEPLISTAS` (
  `TmpPEPID` bigint(20) NOT NULL COMMENT 'Id de la deteccion PEP.',
  `ClienteID` int(11) NOT NULL COMMENT 'Número del Cliente.',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria.',
  PRIMARY KEY (`TmpPEPID`,`NumTransaccion`),
  KEY `TMPCLIENTESPEPLISTAS_IDX_01` (`TmpPEPID`),
  KEY `TMPCLIENTESPEPLISTAS_IDX_02` (`ClienteID`),
  KEY `TMPCLIENTESPEPLISTAS_IDX_03` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Almacena los Clientes que Coincidieron con Listas Negras de Tipo PEP para su Actualización en el Conocimiento del Cliente.'$$


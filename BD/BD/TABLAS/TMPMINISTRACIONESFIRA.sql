-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPMINISTRACIONESFIRA
DELIMITER ;
DROP TABLE IF EXISTS `TMPMINISTRACIONESFIRA`;DELIMITER $$

CREATE TABLE `TMPMINISTRACIONESFIRA` (
  `ConsecutivoID` int(11) DEFAULT NULL COMMENT 'Número consecutivo.',
  `Numero` varchar(150) DEFAULT NULL COMMENT 'Número de ministración.',
  `Fecha` varchar(200) DEFAULT NULL COMMENT 'Fecha.',
  `FechaBold` varchar(100) DEFAULT 'false' COMMENT 'Indica si la etiqueta será negrita.',
  `FechaAlingn` varchar(150) DEFAULT 'CENTER' COMMENT 'Alineación de la etiqueta.',
  `FechaBorderLeft` varchar(150) DEFAULT '1' COMMENT 'Borde izquierdo de la celda.',
  `Monto` varchar(200) DEFAULT NULL COMMENT 'Monto.',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Número del crédito.',
  KEY `IDX_TMPMINISTRACIONESFIRA_1` (`CreditoID`),
  KEY `IDX_TMPMINISTRACIONESFIRA_2` (`ConsecutivoID`),
  KEY `IDX_TMPMINISTRACIONESFIRA_3` (`Numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Temporal para las ministraciones en contratos agro.'$$
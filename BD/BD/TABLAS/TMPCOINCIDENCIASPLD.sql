-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCOINCIDENCIASPLD
DELIMITER ;
DROP TABLE IF EXISTS `TMPCOINCIDENCIASPLD`;DELIMITER $$

CREATE TABLE `TMPCOINCIDENCIASPLD` (
  `CoincidenciaID` int(11) NOT NULL COMMENT 'Coincidencia',
  `ListaNegraID` bigint(12) DEFAULT NULL COMMENT 'Id Tabla PLDListaNegras',
  `PersonaBloqID` bigint(12) DEFAULT NULL COMMENT 'ID de la tabla para personas bloquedas',
  `ClavePersonaID` int(11) NOT NULL COMMENT 'Clave de la persona',
  `TipoPersSAFI` varchar(3) NOT NULL COMMENT 'Tipo de Persona',
  `PorcNombres` decimal(10,2) NOT NULL COMMENT 'Porcentaje de coincidencias en nombres',
  `PorcApellidos` int(11) DEFAULT NULL COMMENT 'Porcentaje de coincidencias en apellidos',
  `PorcRazonSoc` int(11) DEFAULT NULL COMMENT 'Porcentaje de coincidencias en Razón Social',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  PRIMARY KEY (`CoincidenciaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla temporal para la detección de coincidencias PLD'$$
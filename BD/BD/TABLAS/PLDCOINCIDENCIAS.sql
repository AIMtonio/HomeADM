-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCOINCIDENCIAS
DELIMITER ;
DROP TABLE IF EXISTS `PLDCOINCIDENCIAS`;DELIMITER $$

CREATE TABLE `PLDCOINCIDENCIAS` (
  `ClavePersonaInv` int(11) NOT NULL COMMENT 'Clave de la persona involucrada',
  `PersonaBloqID` bigint(12) DEFAULT NULL COMMENT 'ID de la tabla para personas bloquedas',
  `ListaNegraID` bigint(12) DEFAULT NULL COMMENT 'Id Tabla PLDListaNegras',
  `TipoPersSAFI` varchar(3) NOT NULL COMMENT 'CTE. Cliente USU. Usuario de Servicios AVA. Aval PRO. Prosepecto REL. Relacionado a la cuenta PRV. Proveedor NA. No Aplica (nuevo registro).',
  `FechaDeteccion` date NOT NULL COMMENT 'Fecha de deteccion',
  `HoraDeteccion` time NOT NULL COMMENT 'Hora de la deteccion',
  `OpeInusualID` int(11) DEFAULT NULL COMMENT 'Numero de Operacion Inusual',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ClavePersonaInv`,`FechaDeteccion`,`TipoPersSAFI`,`HoraDeteccion`),
  KEY `FK_PLDCOINCIDENCIAS_1_idx` (`ListaNegraID`),
  KEY `FK_PLDCOINCIDENCIAS_2_idx` (`PersonaBloqID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena las coincidencias de personas involucrudas en listas.'$$
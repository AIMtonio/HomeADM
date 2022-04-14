
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------

-- TMPPLDDETECPERS

DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDDETECPERS`;

DELIMITER $$
CREATE TABLE `TMPPLDDETECPERS` (
  `TmpID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Id de la deteccion PLD',
  `TipoPersonaSAFI` varchar(3) NOT NULL COMMENT 'Tipo de la persona involucrada\nCTE.- Cliente\nUSU.- Usuario de Servicios\nAVA.- Avales\nPRO.- Prospectos\nREL.-  Relacionados de la cuenta (Que no son socios/clientes)\nNA.- No Aplica (cuando no se trata de Clientes ni de Usuarios)',
  `ClavePersonaInv` int(11) NOT NULL COMMENT 'ID o Clave de la Persona Involucrada',
  `NombreCompleto` varchar(250) NOT NULL COMMENT 'Nombre completo o razón social de la persona',
  `TipoPersona` char(1) NOT NULL COMMENT 'Tipo de Persona de la persona',
  `RFC` varchar(15) NOT NULL COMMENT 'RFC de la persona',
  `FechaNac` DATE NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Nacimiento de la persona',
  `PaisID` varchar(250) NULL DEFAULT '0' COMMENT 'Pais de Nacimiento de la persona (PAISES)',
  `EstadoID` varchar(250) NULL DEFAULT '0' COMMENT 'Estado de la persona (ESTADOSREPUB)',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TmpID`),
  KEY `INDEX_TMPPLDDETECPERS_001` (`TipoPersonaSAFI`),
  KEY `INDEX_TMPPLDDETECPERS_002` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla de paso utilizada para listar a las Personas en SAFI (clientes, Usuarios de servicios, avales, etc,.) para encontrar coincidencias en Listas Negras y Personas Bloqueadas.'$$


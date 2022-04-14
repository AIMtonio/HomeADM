-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACIONPERSONAS
DELIMITER ;
DROP TABLE IF EXISTS `RELACIONPERSONAS`;DELIMITER $$

CREATE TABLE `RELACIONPERSONAS` (
  `PersonaID` int(11) NOT NULL COMMENT 'Identificador de la Persona\n',
  `NombrePersona` varchar(200) DEFAULT NULL COMMENT 'Nombre de la Persona Relacionada a la Empresa',
  `CURP` char(18) DEFAULT NULL COMMENT 'CURP de la Persona Relacionada',
  `RFC` varchar(45) DEFAULT NULL COMMENT 'RFC de la Persona Relacionada',
  `PuestoID` int(11) DEFAULT '0' COMMENT 'Puesto de la Persona Relacionada',
  `PorcAcciones` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Porcentaje de acciones',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`PersonaID`),
  KEY `IDX_RELACIONEMPLEADOCLIENTE_1` (`PersonaID`),
  KEY `IDX_RELACIONEMPLEADOCLIENTE_2` (`NombrePersona`),
  KEY `IDX_RELACIONEMPLEADOCLIENTE_3` (`CURP`),
  KEY `IDX_RELACIONEMPLEADOCLIENTE_4` (`RFC`),
  KEY `IDX_RELACIONEMPLEADOCLIENTE_5` (`PuestoID`),
  KEY `IDX_RELACIONEMPLEADOCLIENTE_6` (`PersonaID`,`PuestoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar las relaciones existentes entre cliente'$$
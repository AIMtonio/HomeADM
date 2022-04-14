
-- CATSPEIORIGENES --

DELIMITER  ;
DROP TABLE IF EXISTS `CATSPEIORIGENES`;

DELIMITER  $$
CREATE TABLE `CATSPEIORIGENES` (
  `OrigenSpeiID` char(1) NOT NULL COMMENT 'ID del Origen del SPEI.',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Descripción del Origen SPEI.',
  `Orden` int(11) DEFAULT NULL COMMENT 'Orden.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  PRIMARY KEY (`OrigenSpeiID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Origenes SPEI.'$$
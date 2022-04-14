
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPLDOPEINTERPREO
DELIMITER ;
DROP TABLE IF EXISTS `HISPLDOPEINTERPREO`;

DELIMITER $$
CREATE TABLE `HISPLDOPEINTERPREO` (
  `RegistroID` bigint(20) UNSIGNED AUTO_INCREMENT COMMENT 'Llave primaria del histórico.',
  `Fecha` date NOT NULL COMMENT 'Fecha de registro de la operación (captura).',
  `OpeInterPreoID` int(11) NOT NULL COMMENT 'Id de la Operación Interna Preocupante.',
  `ClaveRegistra` char(2) DEFAULT NULL COMMENT 'Clave del tipo de persona que detecta la operación\ntipo de registro\n1:personal interno\n2:personal externo\n3:sistema automático.',
  `NombreReg` varchar(35) DEFAULT NULL COMMENT 'Nombre de quien detecta la operación. Opcional.',
  `CatProcedIntID` varchar(10) DEFAULT NULL COMMENT 'Clave de procedimiento interno donde se localiza la operación según el Catálogo PLDCATPROCEDINT.',
  `CatMotivPreoID` varchar(15) DEFAULT NULL COMMENT 'Clave de motivo del registro de la operación según el Catálogo PLDCATMOTIVPREO.',
  `FechaDeteccion` date DEFAULT NULL COMMENT 'Clave de motivo del registro de la operación.',
  `CategoriaID` int(11) DEFAULT NULL COMMENT 'Id o clave de la Categoria según el Catálogo CATEGORIAPTO.',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Clave de la sucursal del personal involucrado según el Catálogo SUCURSALES.',
  `ClavePersonaInv` int(11) DEFAULT NULL COMMENT 'Id o Clave de la Persona Involucrada.',
  `NomPersonaInv` varchar(100) DEFAULT NULL COMMENT 'Nombre de la persona interna involucrada.',
  `CteInvolucrado` varchar(100) DEFAULT NULL COMMENT 'Nombre del cliente, prospecto o usuario involucrado.',
  `Frecuencia` char(1) DEFAULT NULL COMMENT 'Existe frecuencia o periodicidad en la ocurrencia de la operación.',
  `DesFrecuencia` varchar(50) DEFAULT NULL COMMENT 'Descripcion de la frecuencia en veces por espacio de tiempo.',
  `DesOperacion` varchar(300) DEFAULT NULL COMMENT 'Descripcion de la operación interna preocupante.',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Operacion según el Catálogo PREOCUPAEDOS.',
  `ComentarioOC` varchar(1500) DEFAULT NULL COMMENT 'Comentarios del OC.',
  `FechaCierre` date DEFAULT NULL COMMENT 'Fecha en que cambio al estado R o N. Automático por sistema.',
  `EstatusSITI` char(1) DEFAULT 'N' COMMENT 'Estatus de la Operacion que indica si ya fue integrado en el reporte con el formato del SITI.\nS: Sí.\nN: No.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  PRIMARY KEY (`RegistroID`),
  KEY `IDX_HISPLDOPEINTERPREO_001` (`Fecha`),
  KEY `IDX_HISPLDOPEINTERPREO_002` (`OpeInterPreoID`),
  KEY `IDX_HISPLDOPEINTERPREO_003` (`Estatus`),
  KEY `IDX_HISPLDOPEINTERPREO_004` (`EstatusSITI`, `Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='His: Histórico de las Operaciones Internas preocupantes reportadas.'$$


-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINTERPREO
DELIMITER ;
DROP TABLE IF EXISTS `PLDOPEINTERPREO`;DELIMITER $$

CREATE TABLE `PLDOPEINTERPREO` (
  `Fecha` date NOT NULL COMMENT 'fecha de registro de la operación (captura)',
  `OpeInterPreoID` int(11) NOT NULL COMMENT 'consecutivo general',
  `ClaveRegistra` char(2) DEFAULT NULL COMMENT 'clave del tipo de persona que detecta la operación\ntipo de registro (\n1:personal interno,\n2:personal externo,\n3:sistema automático)',
  `NombreReg` varchar(35) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL COMMENT 'Nombre de quien detecta la operación\nOpcional',
  `CatProcedIntID` varchar(10) DEFAULT NULL COMMENT 'clave de procedimiento interno donde se localiza la operación\nSegun el catalogo\nPLDCATPROCEDINT',
  `CatMotivPreoID` varchar(15) DEFAULT NULL COMMENT 'clave de motivo del registro de la operación\nSegun el Catalogo\nPLDCATMOTIVPREO',
  `FechaDeteccion` date DEFAULT NULL COMMENT 'clave de motivo del registro de la operación',
  `CategoriaID` int(11) DEFAULT NULL COMMENT 'ID o clave de la Categoria\nSegun el Catalogo\nCATEGORIAPTO\n',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Clave de la sucursal del personal involucrado\nSegun el Catalogo\nSUCURSALES',
  `ClavePersonaInv` int(11) DEFAULT NULL COMMENT 'ID o Clave de la Persona Involucrada',
  `NomPersonaInv` varchar(100) DEFAULT NULL COMMENT 'Nombre de la persona interna involucrada',
  `CteInvolucrado` varchar(100) DEFAULT NULL COMMENT 'Nombre del cliente, prospecto o usuario involucrado',
  `Frecuencia` char(1) DEFAULT NULL COMMENT 'Existe frecuencia o periodicidad en la ocurrencia de la operación',
  `DesFrecuencia` varchar(50) DEFAULT NULL COMMENT 'descripcion de la frecuencia en veces por espacio de tiempo',
  `DesOperacion` varchar(300) DEFAULT NULL COMMENT 'Descripcion de la operación interna preocupante',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Operacion\nSegun el Catalogo\nPREOCUPAEDOS',
  `ComentarioOC` varchar(1500) DEFAULT NULL COMMENT 'Comentarios del OC',
  `FechaCierre` date DEFAULT NULL COMMENT 'Fecha en que cambio al estado R o N, Automático por sistema',
  PRIMARY KEY (`Fecha`,`OpeInterPreoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro de Operaciones Internas preocupantes'$$
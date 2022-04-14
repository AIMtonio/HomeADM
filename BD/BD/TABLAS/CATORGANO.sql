-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATORGANO
DELIMITER ;
DROP TABLE IF EXISTS `CATORGANO`;DELIMITER $$

CREATE TABLE `CATORGANO` (
  `OrganoID` int(11) NOT NULL COMMENT 'Clave SITI de Organo',
  `TipoInstitID` int(11) NOT NULL DEFAULT '0' COMMENT 'Clave del tipo de Entidad Sofipo, Socap (TIPOSINSTITUCION)',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion del Organo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoInstitID`,`OrganoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Organo al que pertenece el Funcionario SITI - Reg. A1713'$$
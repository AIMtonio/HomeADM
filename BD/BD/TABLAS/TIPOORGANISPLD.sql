-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOORGANISPLD
DELIMITER ;
DROP TABLE IF EXISTS `TIPOORGANISPLD`;DELIMITER $$

CREATE TABLE `TIPOORGANISPLD` (
  `TipoOrganismoID` char(2) NOT NULL COMMENT 'clave del tipo de  organismos ',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'descripcion del tipo de  organismo',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'N. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoOrganismoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='catalogo de tipos de organismos a los que puede pertener los'$$
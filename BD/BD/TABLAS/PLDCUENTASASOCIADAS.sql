-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCUENTASASOCIADAS

DELIMITER ;
DROP TABLE IF EXISTS `PLDCUENTASASOCIADAS`;
DELIMITER $$

CREATE TABLE `PLDCUENTASASOCIADAS` (
  `NumCuentaAsociada` varchar(20) NOT NULL COMMENT 'Número de cuenta o proyecto',
  `RegimenCta` int(11) DEFAULT '0' COMMENT 'Regimen',
  `NivelCta` int(11) DEFAULT '0' COMMENT 'Nivel de cuenta',
  `NacionalidadCta` char(6) DEFAULT '' COMMENT 'Nacionalidad de la cuenta asociada de una institución financiera',
  `InstitucionCta` varchar(40) CHARACTER SET big5 DEFAULT '' COMMENT 'Institución financiera a la que pertenece el número de cuenta o cuenta clabeasociado',
  `ClabeCta` varchar(20) DEFAULT '' COMMENT 'Número de cuenta o cuenta CLABE asociada de una institución financiera',
  `TipoFinanciamiento` int(11) DEFAULT '0' COMMENT 'Tipo de financiamiento colectivo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`NumCuentaAsociada`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Información de las cuentas asociadas para el reporte de XML'$$

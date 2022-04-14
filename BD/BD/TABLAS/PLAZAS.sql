-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZAS
DELIMITER ;
DROP TABLE IF EXISTS `PLAZAS`;DELIMITER $$

CREATE TABLE `PLAZAS` (
  `PlazaID` int(11) NOT NULL COMMENT 'No. o ID de la plaza',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Nombre` varchar(100) DEFAULT NULL COMMENT 'Nombre de la plaza',
  `PlazaCLABE` char(3) DEFAULT NULL COMMENT 'No de plazaCLABE segun Banxico para formar cuentas de SPEI\n',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PlazaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Plazas donde la Institucion Tiene Operaciones'$$
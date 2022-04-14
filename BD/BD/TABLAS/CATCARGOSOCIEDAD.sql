-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCARGOSOCIEDAD
DELIMITER ;
DROP TABLE IF EXISTS `CATCARGOSOCIEDAD`;DELIMITER $$

CREATE TABLE `CATCARGOSOCIEDAD` (
  `CargoID` int(11) NOT NULL COMMENT 'Clave SITI de Cargo Dentro de la Sociedad',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion de la causa de baja',
  `TipoInstitID` int(11) NOT NULL COMMENT 'Clave por tipo de Institucion (TIPOSINSTITUCIONES)',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CargoID`,`TipoInstitID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo Cargo SITI - Se refiere a la jerarquia que ocupa el funcionario.'$$
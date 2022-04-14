-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOSINS
DELIMITER ;
DROP TABLE IF EXISTS `REGULATORIOSINS`;DELIMITER $$

CREATE TABLE `REGULATORIOSINS` (
  `RegulatorioID` int(11) NOT NULL COMMENT 'Identificador del regulatorio',
  `Clave` varchar(7) DEFAULT NULL COMMENT 'Clave del Regulatorio SITI',
  `Especiales` varchar(200) DEFAULT NULL COMMENT 'Identificador del Numero de Cliente, se parado por coma (,)',
  `Instituciones` varchar(200) DEFAULT NULL COMMENT 'Identificador del Tipo de Institucion (TIPOSINSTITUCION), separado por coma (,)',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RegulatorioID`),
  UNIQUE KEY `Clave` (`Clave`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla del Catalogo de Regulatorios para Principal'$$
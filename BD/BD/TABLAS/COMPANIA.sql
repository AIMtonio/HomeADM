-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMPANIA
DELIMITER ;
DROP TABLE IF EXISTS `COMPANIA`;DELIMITER $$

CREATE TABLE `COMPANIA` (
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa',
  `Nombre` varchar(150) NOT NULL COMMENT 'Nombre la \nEmpresa o \nCompania',
  `LogoCtePantalla` varchar(300) DEFAULT NULL COMMENT 'Ruta del Logo del Cliente que se muestra en la cabecera del SAFI',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EmpresaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Companias o Empresas'$$
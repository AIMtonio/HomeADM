-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECATDIASATRA
DELIMITER ;
DROP TABLE IF EXISTS `CRECATDIASATRA`;DELIMITER $$

CREATE TABLE `CRECATDIASATRA` (
  `ProcesoID` varchar(50) NOT NULL COMMENT 'ID del proceso o Reporte para el que aplica este catalogo de dias de atraso',
  `LimInferior` int(11) NOT NULL DEFAULT '0' COMMENT 'Limite de Dias de atraso Inferior',
  `LimSuperior` int(11) NOT NULL DEFAULT '0' COMMENT 'Limite de Dias de atraso Superior',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion de los Dias de Atraso',
  `Orden` int(11) DEFAULT NULL COMMENT 'Orden de Aparicion en Listados y Reportes',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'C . Comercial\nO .- Consumo\nH .- Hipotecario',
  `CuentaCNBV` varchar(40) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProcesoID`,`LimInferior`,`LimSuperior`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Dias de Atraso Para Reportes a Entidades'$$
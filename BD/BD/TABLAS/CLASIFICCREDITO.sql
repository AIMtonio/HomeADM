-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `CLASIFICCREDITO`;DELIMITER $$

CREATE TABLE `CLASIFICCREDITO` (
  `ClasificacionID` int(4) NOT NULL COMMENT 'ID de Clasificacion de acuerdo a Reportes Regulatorios.',
  `TipoClasificacion` char(1) DEFAULT NULL COMMENT 'Tipo de\nClasificacion:\n\nC . Comercial\nO .- Consumo\nH .- Hipotecario',
  `DescripClasifica` varchar(100) DEFAULT NULL COMMENT 'Descripcion',
  `CodigoClasific` varchar(12) DEFAULT NULL COMMENT 'Codigo de\nRepresentacion\nde  la Clasificacion\nSegun CNBV\n',
  `CodClasificBuroPM` varchar(5) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClasificacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Clasificacion de Tipos de Productos de Creditos'$$
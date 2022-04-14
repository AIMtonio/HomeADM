-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOCATTIPGAS
DELIMITER ;
DROP TABLE IF EXISTS `TESOCATTIPGAS`;DELIMITER $$

CREATE TABLE `TESOCATTIPGAS` (
  `TipoGastoID` int(11) NOT NULL COMMENT 'Tipo de Gasto',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion de Tipo de Gasto',
  `CuentaCompleta` char(25) DEFAULT NULL COMMENT 'Cuenta Contable donde contabilizara el gasto',
  `CajaChica` char(1) DEFAULT NULL COMMENT 'clave de caja chica\nS =Si\nN = No',
  `RepresentaActivo` char(1) DEFAULT 'N' COMMENT 'Si el tipo de gasto representa un activo S= si y N= no',
  `TipoActivoID` int(11) DEFAULT '0' COMMENT 'Idetinficador del tipo de activo tabla TIPOSACTIVOS',
  `Estatus` char(1) DEFAULT 'A' COMMENT 'Estatus tipo de gasto',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoGastoID`),
  KEY `idx_TESOCATTIPGAS_1` (`TipoActivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Gastos de Tesoreria'$$
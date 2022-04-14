-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDETAPOLIZA
DELIMITER ;
DROP TABLE IF EXISTS `TMPDETAPOLIZA`;DELIMITER $$

CREATE TABLE `TMPDETAPOLIZA` (
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `PolizaID` bigint(20) NOT NULL COMMENT 'Numero de la \nPoliza',
  `Fecha` date NOT NULL COMMENT 'Fecha de la \nPoliza',
  `CentroCostoID` int(11) NOT NULL COMMENT 'Centro de \nCostos',
  `CuentaCompleta` varchar(18) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Instrumento` varchar(20) NOT NULL COMMENT 'Instrumento\nque origino el\nmovimiento',
  `MonedaID` int(11) NOT NULL COMMENT 'Moneda',
  `Cargos` decimal(14,4) DEFAULT NULL,
  `Abonos` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Descripcion` varchar(21) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Referencia` varchar(200) NOT NULL COMMENT 'Referencia',
  `ProcedimientoCont` varchar(14) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `TipoInstrumentoID` varchar(2) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
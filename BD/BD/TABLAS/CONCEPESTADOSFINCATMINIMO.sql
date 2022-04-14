-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPESTADOSFINCATMINIMO
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPESTADOSFINCATMINIMO`;DELIMITER $$

CREATE TABLE `CONCEPESTADOSFINCATMINIMO` (
  `Reporte` varchar(10) NOT NULL COMMENT 'Iniciales del reporte Regulatorio',
  `ConceptoFinanID` int(11) NOT NULL COMMENT 'ID del Concepto Financiero',
  `NumClien` int(11) NOT NULL COMMENT 'Numero de cliente',
  `Descripcion` varchar(500) DEFAULT NULL COMMENT 'Descripcion del concepto Financiero',
  `CuentaContable` varchar(500) DEFAULT NULL COMMENT 'Cuenta contable a evaluar(puede ser formula)',
  `CuentaFija` varchar(45) DEFAULT NULL COMMENT 'Cuenta fija que se incluye en el reporte Regulatorio',
  `Presentacion` char(1) DEFAULT NULL COMMENT 'Presentacion: C: contable, N: Negativo, P:Positivo',
  `Tipo` char(1) DEFAULT NULL COMMENT 'Tipo: E: Encabezado, D: Detalle',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria Usuario ID',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria Numero de Transaccion',
  PRIMARY KEY (`NumClien`,`ConceptoFinanID`,`Reporte`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb= Tabla en la cual se configura el maximo concepto financiero para los regulatorios dependientes del catalogo minimo'$$
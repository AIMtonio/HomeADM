-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSFINCATMINFAP
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALDOSFINCATMINFAP`;DELIMITER $$

CREATE TABLE `TMPSALDOSFINCATMINFAP` (
  `EstadoFinanID` int(11) NOT NULL,
  `ConceptoFinanID` int(11) NOT NULL COMMENT 'ID del Concepto Financiero',
  `Descripcion` varchar(300) NOT NULL COMMENT 'Descripcion del Concepto Financiero',
  `Desplegado` varchar(300) NOT NULL COMMENT 'Desplegado a Mostrar en el Reporte',
  `CuentaContable` varchar(500) NOT NULL COMMENT 'Rango de Cuentas que Integran el Concepto Financiero',
  `Tipo` char(1) DEFAULT NULL COMMENT 'Tipo:\nE: Encabezado de un grupo de conceptos\nD: Detalle, concepto que no continene subcuentas en el reporte.\nO: Para los encabezados que se omite la sumatorio de sus subcuentas',
  `EsCalculado` char(1) DEFAULT NULL COMMENT 'Indica si es un Campo calculado(Con formulas)\nS .- SI\nN .- NO',
  `NombreCampo` varchar(20) DEFAULT NULL COMMENT 'Nombre del Campo, para el select dinamico ',
  `Espacios` int(11) DEFAULT NULL COMMENT 'Numero  columnas vacias que se dejaran antes de pintar la cadena',
  `Negrita` char(1) DEFAULT NULL COMMENT 'Indica si la cadena se pintara como Negrita\n"S" = Si\n"N" = No',
  `Sombreado` char(1) DEFAULT NULL COMMENT 'Indica si la cadena ira sombreada en el valor \n"S" = Si\n"N" = No',
  `CombinarCeldas` int(11) DEFAULT NULL COMMENT 'Indica el numero de celdas que se combinaran',
  `NumeroTransaccion` bigint(20) NOT NULL COMMENT 'Numero \n    Transaccion',
  `Fecha` date NOT NULL COMMENT 'Fecha',
  `SaldoFinal` decimal(15,2) DEFAULT NULL,
  `SaldoInicial` decimal(15,2) DEFAULT NULL,
  `Cargos` decimal(16,4) DEFAULT NULL,
  `Abonos` decimal(16,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
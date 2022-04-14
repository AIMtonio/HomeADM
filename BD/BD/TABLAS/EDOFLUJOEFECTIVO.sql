-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOFLUJOEFECTIVO
DELIMITER ;
DROP TABLE IF EXISTS `EDOFLUJOEFECTIVO`;
DELIMITER $$


CREATE TABLE `EDOFLUJOEFECTIVO` (
  `ConceptoFinanID` int(11) NOT NULL COMMENT 'Número Consecutivo de Concepto',
  `NumeroCliente` int(11) NOT NULL COMMENT 'Número de Cliente(CliProcEspecifico)',
  `CatConceptos` varchar(15) NOT NULL COMMENT 'Catálogo de Conceptos',
  `ClaveCampo` varchar(5) NOT NULL COMMENT 'Clave de Campo',
  `Descripcion` varchar(300) NOT NULL COMMENT 'Descripcion del Concepto Financiero',
  `Desplegado` varchar(300) NOT NULL COMMENT 'Desplegado a Mostrar en el Reporte',
  `FormulaContable` varchar(300) NOT NULL COMMENT 'Formula Contable',
  `FormulaReporte` varchar(300) NOT NULL COMMENT 'Formula del Reportes "Este campo tiene prioridad sobre el campo FormulaContable"',
  `CampoReporte` varchar(300) NOT NULL COMMENT 'Campo a mostrar en reporte',
  `Espacios` int(11) NOT NULL COMMENT 'Numero Columnas vacias que se dejaran antes de pintar la cadena',
  `Negrita` char(1) NOT NULL COMMENT 'Indica si la cadena se pintara como Negrita \n"S".- SI \n"N".- NO',
  `Sombreado` char(1) NOT NULL COMMENT 'Indica si la cadena se pintara como Sombreada \n"S".- SI \n"N".- NO',
  `Presentacion` char(3) NOT NULL COMMENT 'Presentación \nSCI = Saldo Contable Actual =  \nSIF = Saldo Inicio Fin \nSFI = Saldo Fin Inicio \nSCF = SaldoContableAnterior',
  `MostrarCampo` char(1) NOT NULL COMMENT 'Muestra el campo en el Reporte \n"S"- SI \n"N".- NO',
  `EmpresaID` int(11) NOT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`ConceptoFinanID`,`NumeroCliente`),
  KEY `IDX_EDOFLUJOEFECTIVO_1` (`ConceptoFinanID`,`NumeroCliente`,`CatConceptos`),
  KEY `IDX_EDOFLUJOEFECTIVO_2` (`ConceptoFinanID`,`NumeroCliente`,`ClaveCampo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Configuración del Reporte Financiero Estado de Flujo de Efectivo.'$$
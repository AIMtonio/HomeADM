-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOVARIACIONES
DELIMITER ;
DROP TABLE IF EXISTS `EDOVARIACIONES`;
DELIMITER $$


CREATE TABLE `EDOVARIACIONES` (
  `EstadoFinanID` int(11) NOT NULL COMMENT 'ID del concepto Financiero, 5 para el estado de variacion de capital',
  `CaTConceptos` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del catalogo de conceptos.',
  `NumeroCliente` int(11) NOT NULL COMMENT 'Numero del cliente.',
  `CuentaContable` varchar(15) DEFAULT NULL COMMENT 'Es el numero de Cuenta Contable Asignado por la SOFIPOS',
  `ClaveCampo` char(5) NOT NULL COMMENT 'Clave de Campo',
  `FormulaReporte` varchar(300) NOT NULL COMMENT 'Formula del Reportes "Este campo tiene prioridad sobre el campo FormulaContable"',
  `MostrarCampo` char(1) NOT NULL COMMENT 'Muestra el campo en el Reporte \n"S"- SI \n"N".- NO',
  `Presentacion` char(3) NOT NULL COMMENT 'Presentación \n"SCI"- Saldo Contable Inicial \n"SIF".- Saldo Inicial-Final \n"SFI".- Saldo Final-Inicial \n"SCF".- Saldo Contable Final',
  `Descripcion` varchar(300) DEFAULT NULL COMMENT 'Es la descripcion de la cuenta contable que se mostrara en el reporte',
  `ParticipacionControladora` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Participacion controladora',
  `CapitalSocial` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de capital social',
  `AportacionesCapital` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Aportaciones para futuros aumentos de capital formalizadas por su organo de gobierno.',
  `PrimaVenta` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Prima en venta de acciones.',
  `ObligacionesSubordinadas` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Obligaciones subordinadas en circulacion.',
  `IncorporacionSocFinancieras` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Efecto por incorporacion al regimen de sociedades financieras populares.',
  `ReservaCapital` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Reservas de capital.',
  `ResultadoEjerAnterior` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Resultado de ejercicios anteriores.',
  `ResultadoTitulosVenta` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Resultado por valuacion de titulos disponibles para la venta.',
  `ResultadoValuacionInstrumentos` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Resultado por valuacion de instrumentos de cobertura de flujos de efectivo.',
  `EfectoAcomulado` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Efecto acumulado por conversion.',
  `BeneficioEmpleados` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Remediciones por beneficios definidos a los empleados.',
  `ResultadoMonetario` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Resultado por tenencia de activos no monetarios.',
  `ResultadoActivos` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de  Resultado neto.',
  `ParticipacionNoControladora` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Participacion no controladora.',
  `CapitalContable` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Capital contable.',
  `Negrita` char(1) CHARACTER SET big5 DEFAULT NULL COMMENT 'Columna colocar la descripcion en negrita ',
  `Sombreado` char(1) DEFAULT NULL COMMENT 'Columna  colocar la descripcion en sombreado',
  `EfectoIncorporacion` varchar(300) DEFAULT NULL COMMENT 'Columna para las cuentas contables de Efecto por Incorporacion a Entidades de Ahorro y Credito Popular',
  PRIMARY KEY (`EstadoFinanID`,`CaTConceptos`,`NumeroCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla En la cual se registran las formulas de las cuentas contables para generar el reporte de variacion de Capital Contable.'$$
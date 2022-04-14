-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEDOVARIACIONES
DELIMITER ;
DROP TABLE IF EXISTS `TMPEDOVARIACIONES`;

DELIMITER $$
CREATE TABLE `TMPEDOVARIACIONES` (
  `NumeroTransaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Numero de Transaccion del reporte.',
  `CaTConceptos` int(11) NOT NULL DEFAULT '0' COMMENT 'El ID del concepto Contable',
  `CuentaContable` varchar(15) DEFAULT NULL COMMENT 'Es el numero de Cuenta Contable Asignado por la SOFIPOS',
  `ClaveCampo` char(5) NOT NULL COMMENT 'Clave de Campo',
  `FormulaReporte` varchar(300) NOT NULL COMMENT 'Formula del Reportes "Este campo tiene prioridad sobre el campo FormulaContable"',
  `MostrarCampo` char(1) NOT NULL COMMENT 'Muestra el campo en el Reporte \n"S"- SI \n"N".- NO',
  `Presentacion` char(3) NOT NULL COMMENT 'Presentación \n"SCI"- Saldo Contable Inicial \n"SIF".- Saldo Inicial-Final \n"SFI".- Saldo Final-Inicial \n"SCF".- Saldo Contable Final',
  `Descripcion` varchar(300) DEFAULT NULL COMMENT 'Es la descripcion de la cuenta contable que se mostrara en el reporte',
  `ParticipacionControladora` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Participacion controladora',
  `CapitalSocial` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Capital social.',
  `AportacionesCapital` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Aportaciones para futuros aumentos de capital formalizadas por su organo de gobierno.',
  `PrimaVenta` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Prima en venta de acciones.',
  `ObligacionesSubordinadas` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Obligaciones subordinadas en circulacion.',
  `IncorporacionSocFinancieras` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Efecto por incorporacion al regimen de sociedades financieras populares.',
  `ReservaCapital` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Reservas de capital.',
  `ResultadoEjerAnterior` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Resultado de ejercicios anteriores.',
  `ResultadoTitulosVenta` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Resultado por valuacion de titulos disponibles para la venta.',
  `ResultadoValuacionInstrumentos` decimal(18,2) DEFAULT NULL COMMENT 'os resultados de la evaluacion de las cuentas contables de Resultado por valuacion de instrumentos de cobertura de flujos de efectivo.',
  `EfectoAcomulado` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Efecto acumulado por conversion.',
  `BeneficioEmpleados` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Remediciones por beneficios definidos a los empleados.',
  `ResultadoMonetario` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Resultado por tenencia de activos no monetarios.',
  `ResultadoActivos` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Resultado neto.',
  `ParticipacionNoControladora` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Participacion no controladora.',
  `CapitalContable` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Capital contable.',
  `EfectoIncorporacion` decimal(18,2) DEFAULT NULL COMMENT 'Los resultados de la evaluacion de las cuentas contables de Incorporacion a Entidades de Ahorro y Credito Popular',
  PRIMARY KEY (`NumeroTransaccion`,`CaTConceptos`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal donde se guardan los resultados al evaluar las cuentas contables declaradas en la tabla EDOVARIACIONES.'$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMREGULATORIOS
DELIMITER ;
DROP TABLE IF EXISTS `PARAMREGULATORIOS`;

DELIMITER $$
CREATE TABLE `PARAMREGULATORIOS` (
  `ParametrosID` int(11) NOT NULL COMMENT 'ID de los Parametros',
  `ClaveEntidad` varchar(10) DEFAULT NULL COMMENT 'Clave CASFIM de la entidad',
  `NivelOperaciones` int(11) DEFAULT NULL COMMENT 'Nivel de Operaciones',
  `NivelPrudencial` int(11) DEFAULT NULL COMMENT 'Nivel de Regulacion prudencial',
  `CuentaEPRC` varchar(10) DEFAULT NULL COMMENT 'Cuenta de Reservas preventivas',
  `TipoRegulatorios` int(11) DEFAULT NULL COMMENT 'Formato de los regulatorios - TIPOSINSTITUCION',
  `ClaveFederacion` varchar(10) DEFAULT NULL COMMENT 'Clave de la federación para SOFIPOS',
  `MuestraRegistros` char(1) DEFAULT NULL COMMENT 'T = Todos, muestra todos los registros de los diferentes canales en los Reg. D2441 y D 2442,  S = Solo Datos, Muestra solo los registros que tengan datos de cuentas, clientes y operaciones',
  `MostrarComoOtros` char(1) DEFAULT NULL COMMENT 'Reg. D2441 y D 2442, indica si se deben cambiar las operaciones de sucural por el canal de Otros-2013, S = SI, N = No',
  `IntCredVencidos` char(1) DEFAULT NULL COMMENT 'campo: Suma Int. de Cred. Vencidos, paramatros S: Si o N:No',
  `AjusteSaldo` char(1) DEFAULT NULL COMMENT 'Campo que guarda el valor para ajustar la cuenta contable del catálogo mínimo: Valor S = SI y N = NO',
  `CuentaContableAjusteSaldo` varchar(16) DEFAULT NULL COMMENT 'Cuenta Contable a Ajustas, depende del campo Ajuste Saldo',
  `TipoRepActEco` char(1) DEFAULT NULL COMMENT 'Indica si se reporta la actividad de destino del credito con la C: Actividad del Cliente o D: Actividad por DESTINOSCREDITO',
  `MostrarSucursalOrigen` char(1) DEFAULT NULL COMMENT 'Campo que valida si se muestra la sucursal origen del cliente o la sucursal donde se origino un credito, Inversion o CEDE',
  `ContarEmpleados` char(1) DEFAULT NULL COMMENT 'Campo que guadar si el conteo de empleados sera del sistema (S) o de manera Manual (M)',
  `AjusteResPreventiva` char(1) NOT NULL COMMENT 'Campo que Ajusta la Reserva Preventiva de Cero Dias de Mora del Reporte R21 A2111. Valores: \nN.- NO \nS.- SI',
  `AjusteCargoAbono` char(1) NOT NULL COMMENT 'Ajustar Cargos y Abonos en Inversión y Cedes en el Regulatorio D0841. \nS.- SI \nN.- NO',
  `AjusteRFCMenor` char(1) NOT NULL COMMENT 'Ajustar RFC del Cliente Menor en el Regulatorio D0841. \nS.- SI \nN.- NO',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usario ID',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`ParametrosID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros generales para los regulatorios'$$
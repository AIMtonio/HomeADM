-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
DELIMITER ;
DROP TABLE IF EXISTS `TMPBUROCALIFICAREP`;
DELIMITER $$

CREATE TABLE `TMPBUROCALIFICAREP` (
  `Transaccion` BIGINT(20) NOT NULL COMMENT 'Numero de Transaccion',
  `ClienteID` INT(11) NOT NULL COMMENT 'ID del cliente',
  `CreditoID` BIGINT(12) NOT NULL COMMENT 'ID del Credito',
  `EstatusCredito` CHAR(1) DEFAULT NULL COMMENT 'Estatus del credito\nI) Inactivo\nA) Autorizado\nV) Vigente\nP) Pagado\nC) Cancelado\nB) Vencido\nK) Castigado\n',
  `CuentaAhoID` BIGINT(12) DEFAULT NULL COMMENT 'ID de la cuenta de ahorro',
  `TipoPersona` CHAR(1) DEFAULT NULL COMMENT 'Tipo Persona Para el reporte de Buro de acuerdo a los estatutos de Buro\nF) Fisica y Con Actividad Empresarial\nM) Moral\nA) Accionista',
  `NombreCompleto` VARCHAR(250) DEFAULT NULL COMMENT 'Nombre completo',
  `RazonSocial` VARCHAR(200) DEFAULT NULL COMMENT 'Razon social para personas morales',
  `PrimerNombre` VARCHAR(50) DEFAULT NULL COMMENT 'Primer nombre',
  `SegundoNombre` VARCHAR(50) DEFAULT NULL COMMENT 'Segundo nombre',
  `TercerNombre` VARCHAR(50) DEFAULT NULL COMMENT 'Tercer Nombre',
  `ApellidoPaterno` VARCHAR(50) DEFAULT NULL COMMENT 'Apellido Paterno',
  `ApellidoMaterno` VARCHAR(50) DEFAULT NULL COMMENT 'Apellido Materno',
  `RFCOficial` CHAR(13) DEFAULT NULL COMMENT 'RFC para personas fisicas y morales',
  `Nacionalidad` CHAR(1) DEFAULT NULL COMMENT 'Nacionalidad del cliente\nN) Nacional\nE) Extranjero',
  `PaisNacimiento` INT(11) DEFAULT NULL COMMENT 'ID del pais de nacimiento',
  `FechaNacimiento` DATE DEFAULT NULL COMMENT 'Fecha de nacimiento',
  `CURP` CHAR(18) DEFAULT NULL COMMENT 'Clave Unica de Registro de Poblacion',
  `Calle` VARCHAR(50) DEFAULT NULL COMMENT 'Calle de la direccion del cliente',
  `NumeroInterior` CHAR(10) DEFAULT NULL COMMENT 'Numero interior de la direccion del cliente',
  `NumeroExterior` CHAR(10) DEFAULT NULL COMMENT 'Numero exterior de la direccion del cliente',
  `Colonia` VARCHAR(150) DEFAULT NULL COMMENT 'Nombre de la Colonia',
  `Municipio` VARCHAR(150) DEFAULT NULL COMMENT 'Nombre del municipio de la direccion del cliente',
  `Ciudad` VARCHAR(150) DEFAULT NULL COMMENT 'Ciudad de la direccion del cliente',
  `Estado` VARCHAR(150) DEFAULT NULL COMMENT 'Nombre del Estado de la direcion del cliente',
  `CodigoPostal` CHAR(10) DEFAULT NULL COMMENT 'Codigo Postal de la direcion del cliente',
  `PaisResidencia` INT(11) DEFAULT NULL COMMENT 'ID del pais de residencia',
  `TipoGarantiaFIRAID` INT(11) DEFAULT NULL COMMENT 'ID de la garantia FIRA',
  `Clasificacion` INT(11) NOT NULL COMMENT 'Clasificacion \n1) Cliente\n2) Aval\n3) Garante\n4) Aval tipo Cliente\n5) Aval tipo Prospecto',
  `TotalAdeudoCredito` DECIMAL(18,2) DEFAULT NULL COMMENT 'Total del adeudo del credito',
  `TotalAdeudo` DECIMAL(18,2) DEFAULT NULL COMMENT 'Total del adeudo del cliente',
  `PorcentajeAdeudo` DECIMAL(18,2) DEFAULT NULL COMMENT 'De acuerdo a Buro, es el porcentaje que representa TotalAdeudoCredito del TotalAdeudo',
  `Consecutivo` INT(11) DEFAULT NULL COMMENT 'Numero consecutivo de los registros por transaccion',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigINT(20) DEFAULT NULL COMMENT 'C) Cliente\nA) Aval \nG) Garante',
  PRIMARY KEY (`Transaccion`,`ClienteID`,`CreditoID`,`Clasificacion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla para el reporte de Buro Califica'$$
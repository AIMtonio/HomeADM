-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCTIMBRADO
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTATDCTIMBRADO`;
DELIMITER $$

CREATE TABLE `EDOCTATDCTIMBRADO` (
  `AnioMes` INT(11) NOT NULL COMMENT 'Año mes',
  `SucursalID` INT(11) NOT NULL COMMENT 'Identificador de la sucursal',
  `NombreSucursalCte` VARCHAR(60) NOT NULL COMMENT 'Nombre Sucursal Cte',
  `ClienteID` INT(11) NOT NULL COMMENT 'Identificador del cliente',
  `NombreComple` VARCHAR(170) NOT NULL COMMENT 'Nombre completo del cliente',
  `TipPer` CHAR(1) DEFAULT NULL COMMENT 'Tipo de persona identificador',
  `TipoPersona` VARCHAR(50) NOT NULL COMMENT 'Tipo de persona',
  `Calle` VARCHAR(50) NOT NULL COMMENT 'Calle',
  `NumInt` CHAR(10) DEFAULT NULL COMMENT 'Numero Interior',
  `NumExt` CHAR(10) DEFAULT NULL COMMENT 'Numero Exterior',
  `Colonia` VARCHAR(200) NOT NULL COMMENT 'Colonia',
  `MunicipioDelegacion` VARCHAR(50) NOT NULL COMMENT 'Municipio delegacion',
  `Localidad` VARCHAR(50) NOT NULL COMMENT 'Localidad',
  `Estado` VARCHAR(50) NOT NULL COMMENT 'Estado',
  `CodigoPostal` CHAR(5) DEFAULT NULL COMMENT 'Codigo postal',
  `RFC` VARCHAR(13) NOT NULL COMMENT 'RFC',
  `InstrucEnvio` CHAR(1) NOT NULL COMMENT 'Intruccion de envio',
  `DireccionCompleta` VARCHAR(500) DEFAULT NULL COMMENT 'Direccion completa',
  `NombreInstitucion` VARCHAR(250) DEFAULT NULL COMMENT 'Nombre de la institucion',
  `DireccionInstitucion` VARCHAR(250) DEFAULT NULL COMMENT 'Direccion de la institucion',
  `FechaGeneracion` DATE DEFAULT NULL COMMENT 'Fecha de generacion',
  `RegHacienda` CHAR(1) DEFAULT NULL COMMENT 'Especifica si el cliente esta registrado en Hacienda\nS.- Si\nN.- No',
  `CadenaCFDI` VARCHAR(5000) DEFAULT NULL COMMENT 'Cadena para archivo de timbrado CFDI',
  `ComisionAhorro` DECIMAL(12,2) DEFAULT NULL COMMENT 'Total de Comisiones por Cuenta de Ahorro',
  `ComisionCredito` DECIMAL(12,2) DEFAULT NULL COMMENT 'Total de Comision por Creditos',
  `ComisionInver` DECIMAL(12,2) DEFAULT NULL COMMENT 'Total de Comisiones por Inversiones',
  `CFDIFechaEmision` DATE DEFAULT NULL COMMENT 'Fecha de Emision del CFDI\n',
  `CFDIVersion` VARCHAR(10) DEFAULT NULL COMMENT 'Tag Version del CFDI',
  `CFDINoCertSAT` VARCHAR(45) DEFAULT NULL COMMENT 'No Certificado del SAT',
  `CFDIUUID` VARCHAR(50) DEFAULT NULL COMMENT 'UUID del CFDI',
  `CFDIFechaTimbrado` VARCHAR(50) DEFAULT NULL COMMENT 'Fecha de Timbrado ',
  `CFDISelloCFD` VARCHAR(1000) DEFAULT NULL COMMENT 'Sello CFD del CFDI\n',
  `CFDISelloSAT` VARCHAR(1000) DEFAULT NULL COMMENT 'Sello del SAT',
  `CFDICadenaOrig` VARCHAR(2000) DEFAULT NULL COMMENT 'Cadena Original\n',
  `DiasPeriodo` VARCHAR(45) DEFAULT NULL COMMENT 'Dias del Periodo',
  `CFDIFechaCertifica` VARCHAR(45) DEFAULT NULL COMMENT 'Fecha certificada',
  `CFDINoCertEmisor` VARCHAR(80) DEFAULT NULL COMMENT 'Numero Certificado del emisor',
  `CFDILugExpedicion` VARCHAR(50) DEFAULT NULL COMMENT 'Lugar de expedicion',
  `Estatus` INT(11) DEFAULT NULL COMMENT 'Estatus',
  `TotalInteres` DECIMAL(12,2) DEFAULT NULL COMMENT 'Total Interes',
  `IvaComisiones` DECIMAL(12,2) DEFAULT NULL COMMENT 'Iva comiciones',
  `Comisiones` DECIMAL(12,2) DEFAULT NULL COMMENT 'Comiciones',
  `EmpresaID` INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATE NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` INT(11) NOT NULL COMMENT 'Parametro de Auditoria'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar datos de los timbrados'$$

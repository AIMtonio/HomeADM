-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSTANCIARETCTE
DELIMITER ;
DROP TABLE IF EXISTS `CONSTANCIARETCTE`;
DELIMITER $$


CREATE TABLE `CONSTANCIARETCTE` (
  `Anio` int(11) NOT NULL COMMENT 'Anio proceso',
  `Mes` int(11) NOT NULL COMMENT 'Mes de proceso',
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de Sucursal del Cliente',
  `NombreSucursalCte` varchar(60) NOT NULL COMMENT 'Nombre de Sucursal del Cliente',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `PrimerNombre` varchar(50) DEFAULT NULL COMMENT 'Primer Nombre del Cliente',
  `SegundoNombre` varchar(50) DEFAULT NULL COMMENT 'Segundo Nombre del Cliente',
  `TercerNombre` varchar(50) DEFAULT NULL COMMENT 'Tercer Nombre del Cliente',
  `ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del Cliente',
  `ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del Cliente',
  `NombreCompleto` varchar(170) DEFAULT NULL COMMENT 'Nombre Completo del Cliente',
  `RazonSocial` varchar(150) DEFAULT NULL COMMENT 'Razon Social',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Persona',
  `RFC` varchar(13) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes',
  `CURP` char(18) DEFAULT NULL COMMENT 'CURP del Cliente',
  `DireccionCompleta` varchar(500) DEFAULT NULL COMMENT 'Direccion Completa del Cliente',
  `NombreInstitucion` varchar(250) DEFAULT NULL COMMENT 'Nombre de la Institucion',
  `DireccionInstitucion` varchar(250) DEFAULT NULL COMMENT 'Direccion de la Institucion',
  `FechaGeneracion` date DEFAULT NULL COMMENT 'Fecha de Generacion',
  `RegHacienda` char(1) DEFAULT NULL COMMENT 'Especifica si el cliente esta registrado en Hacienda\nS.- Si\nN.- No',
  `CadenaCFDI` varchar(5000) DEFAULT NULL COMMENT 'Cadena para archivo de timbrado CFDI',
  `CFDIFechaEmision` date DEFAULT NULL COMMENT 'Fecha de Emision del CFDI',
  `CFDIVersion` varchar(10) DEFAULT NULL COMMENT 'Tag Version del CFDI',
  `CFDINoCertSAT` varchar(45) DEFAULT NULL COMMENT 'No Certificado del SAT',
  `CFDIUUID` varchar(50) DEFAULT NULL COMMENT 'UUID del CFDI',
  `CFDIFechaTimbrado` varchar(50) DEFAULT NULL COMMENT 'Fecha de Timbrado ',
  `CFDISelloCFD` varchar(1000) DEFAULT NULL COMMENT 'Sello CFD del CFDI',
  `CFDISelloSAT` varchar(1000) DEFAULT NULL COMMENT 'Sello del SAT',
  `CFDICadenaOrig` varchar(2000) DEFAULT NULL COMMENT 'Cadena Original',
  `CFDIFechaCertifica` varchar(45) DEFAULT NULL COMMENT 'Fecha de Certificacion',
  `CFDINoCertEmisor` varchar(80) DEFAULT NULL COMMENT 'Numero Certificacion Emisor',
  `Estatus` int(11) DEFAULT '1' COMMENT 'Estatus Timbrado\n1.- No Procesado\n2.- Exitoso\n3.- Erroneo',
  `MontoTotOperacion` decimal(18,2) DEFAULT NULL COMMENT 'Monto Total de Operacion en el anio fiscal (Inversiones,Cuentas,Cedes)',
  `MontoTotGrav` decimal(18,2) DEFAULT NULL COMMENT 'Monto Total Interes Gravado en el anio fiscal (Inversiones,Cuentas,Cedes)',
  `MontoTotExent` decimal(18,2) DEFAULT NULL COMMENT 'Monto Total Interes Exento en el anio fiscal (Inversiones,Cuentas,Cedes)',
  `MontoTotRet` decimal(18,2) DEFAULT NULL COMMENT 'Monto Total Retenciones en el anio fiscal (Inversiones,Cuentas,Cedes)',
  `MontoIntReal` decimal(18,2) DEFAULT NULL COMMENT 'Monto Total Interes Real en el anio fiscal (Inversiones,Cuentas,Cedes)',
  `MontoCapital` decimal(18,2) DEFAULT NULL COMMENT 'Monto Capital (Invesion/CEDE) o Saldo promedio de la cuenta de ahorro en el anio fiscal\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`Anio`,`Mes`,`SucursalID`,`ClienteID`),
  KEY `INDEX_CONSTANCIARETCTE_1` (`Anio`,`SucursalID`),
  KEY `INDEX_CONSTANCIARETCTE_2` (`Anio`,`ClienteID`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1 COMMENT='Tab: Datos Clientes Constancia de Retencion'$$
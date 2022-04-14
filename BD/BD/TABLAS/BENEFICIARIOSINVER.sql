-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BENEFICIARIOSINVER
DELIMITER ;
DROP TABLE IF EXISTS `BENEFICIARIOSINVER`;DELIMITER $$

CREATE TABLE `BENEFICIARIOSINVER` (
  `InversionID` int(11) NOT NULL COMMENT 'PK-Numero de Inversión',
  `BenefInverID` int(11) NOT NULL COMMENT 'PK-Numero consecutivo por numero de inversión',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'FK a CLIENTES. Numero de Cliente del Beneficiario',
  `Titulo` varchar(10) DEFAULT NULL COMMENT 'Titulo del Cliente, Ej. Sr., Sra, Srita, Lic, Dr. Ing, Prof.,CP, etc',
  `PrimerNombre` varchar(50) DEFAULT NULL COMMENT 'Primer nombre del beneficiario',
  `SegundoNombre` varchar(50) DEFAULT NULL COMMENT 'Segundo nombre del beneficiario',
  `TercerNombre` varchar(50) DEFAULT NULL COMMENT 'Tercer nombre del beneficiario',
  `PrimerApellido` varchar(50) DEFAULT NULL COMMENT 'Primer apellido del beneficiario',
  `SegundoApellido` varchar(50) DEFAULT NULL COMMENT 'Segundo apellido del beneficiario',
  `FechaNacimiento` date DEFAULT NULL COMMENT 'Fecha de nacimiento del beneficiario',
  `PaisID` int(5) DEFAULT NULL COMMENT 'FK a PAISES. Pais de nacimiento, Llave Foranea Hacia tabla PAISES',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'FK a ESTADOSREPUB. Entidad Federativa del beneficiario',
  `EstadoCivil` char(2) DEFAULT NULL COMMENT 'Estado Civil del beneficiario',
  `Sexo` char(1) DEFAULT NULL,
  `CURP` char(18) CHARACTER SET big5 COLLATE big5_bin DEFAULT NULL COMMENT 'Clave Unica de Registro Poblacional',
  `RFC` char(13) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes  del beneficiario',
  `OcupacionID` int(11) DEFAULT NULL COMMENT 'FK- Profesión del beneficiario, Llave Foránea Hacia tabla OCUPACIONES',
  `ClavePuestoID` varchar(200) DEFAULT NULL COMMENT 'Puesto de Trabajo',
  `TipoIdentiID` int(11) DEFAULT NULL COMMENT 'FK a \nTIPOSIDENTI- Tipo Identificacion del beneficiario',
  `NumIdentific` varchar(30) DEFAULT NULL COMMENT 'Es el num de identificacion del documento del beneficiario',
  `FecExIden` date DEFAULT NULL COMMENT 'Fecha de expedición de la identificación',
  `FecVenIden` date DEFAULT NULL COMMENT 'Fecha de vencimiento de su identificación',
  `TelefonoCasa` varchar(20) DEFAULT NULL COMMENT 'Teléfono de casa',
  `TelefonoCelular` varchar(20) DEFAULT NULL,
  `Correo` varchar(50) CHARACTER SET big5 COLLATE big5_bin DEFAULT NULL COMMENT 'Correo electrónico del beneficiario',
  `Domicilio` varchar(500) DEFAULT NULL COMMENT 'Dirección Completa del Beneficiario',
  `TipoRelacionID` int(11) DEFAULT NULL COMMENT 'FK a TIPORELACIONES. Identificador para Catalogo de Tipos de Relaciones (Parentesco)',
  `Porcentaje` decimal(12,2) DEFAULT NULL COMMENT 'Porcentaje del monto de la inversión que recibirá el beneficiario',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre completo del beneficiario se forma de los nombres y apellidos',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`InversionID`,`BenefInverID`),
  KEY `fk_BENEFICIARIOSINVER_1` (`InversionID`),
  KEY `fk_BENEFICIARIOSINVER_2` (`TipoRelacionID`),
  CONSTRAINT `fk_BENEFICIARIOSINVER_1` FOREIGN KEY (`InversionID`) REFERENCES `INVERSIONES` (`InversionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_BENEFICIARIOSINVER_2` FOREIGN KEY (`TipoRelacionID`) REFERENCES `TIPORELACIONES` (`TipoRelacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda los registros de los Beneficiarios al registrar una i'$$
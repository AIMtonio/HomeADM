-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TEMPPLDOPEINUREP
DELIMITER ;
DROP TABLE IF EXISTS `TEMPPLDOPEINUREP`;DELIMITER $$

CREATE TABLE `TEMPPLDOPEINUREP` (
  `Fecha` date NOT NULL DEFAULT '1900-01-01' COMMENT 'fecha de registro de la operación (captura)',
  `OpeInusualID` bigint(20) NOT NULL COMMENT 'consecutivo general',
  `CatProcedIntID` varchar(10) DEFAULT NULL COMMENT 'clave de procedimiento interno donde se localiza la operación\nSegun el catalogo\nPLDCATPROCEDINT',
  `Desc_CatProcedInt` varchar(100) DEFAULT NULL COMMENT 'Descripcion del Catalogo de Procedimientos Internos',
  `CatMotivInuID` varchar(15) DEFAULT NULL COMMENT 'clave de motivo del registro de la operación\nSegun el Catalogo\nPLDCATMOTIVINU',
  `Desc_CatMotivInu` varchar(50) DEFAULT NULL COMMENT 'Descripcion del catalogo de Motivos Inusuales',
  `FechaDeteccion` date DEFAULT NULL COMMENT 'clave de motivo del registro de la operación',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Clave de la sucursal del personal involucrado\nSegun el Catalogo\nSUCURSALES',
  `ClavePersonaInv` int(11) DEFAULT NULL COMMENT 'ID o Clave de la Persona Involucrada',
  `NomPersonaInv` varchar(200) DEFAULT NULL COMMENT 'Nombre de la persona interna involucrada',
  `Frecuencia` char(1) DEFAULT NULL COMMENT 'Existe frecuencia o periodicidad en la ocurrencia de la operación',
  `DesFrecuencia` varchar(150) DEFAULT NULL COMMENT 'descripcion de la frecuencia en veces por espacio de tiempo',
  `DesOperacion` varchar(300) DEFAULT NULL COMMENT 'Descripcion de la operación inusual',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Operacion\nSegun el Catalogo\nPREOCUPAEDOS',
  `DescripcionEstatus` varchar(150) DEFAULT NULL COMMENT 'descripcion de estados de las operaciones',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito que Genero la Alerta de Operacion Inusual',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Cuenta de Ahorro ID',
  `NaturaOperacion` char(1) NOT NULL COMMENT 'Naturaleza que genero la Operacion',
  `MontoOperacion` decimal(18,2) NOT NULL COMMENT 'Monto de la operacion que genero la alerta',
  `MonedaID` int(11) NOT NULL COMMENT 'Tipo de Moneda de la Cuenta que Genero la Operacion',
  `EqCNBVUIF` varchar(3) DEFAULT NULL COMMENT 'Clave de la Moneda de acuerdo al catalogo de MONEDAS',
  `FolioInterno` int(11) NOT NULL COMMENT 'Folio Interno usado para la Generacion del Archivo que se entregara a la CNVB y se arma con la fecha ejemplo fecha  01-May-2013  Folio 20130501',
  `TipoOpeCNBV` char(2) DEFAULT NULL COMMENT 'Tipo de Operacion de Acuerdo a Catalogo de CNBV\n01=Depósito\n02=Retiro\n03=Compra Divisas\n04=Venta Divisas\n05=Cheques de Caja\n06=Giros\n07=Ordenes de Pago\n08=Otorgamiento de Crédito\n09=Pago de Crédito\n10=Pago de Primas u Operación de Reaseguro\n11=Aportacione',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Registra forma de pago de la operacion inusual ''E'' Efectivo, ''T'' Transferencia, ''H''  Cheque',
  `TipoPersonaSAFI` varchar(3) DEFAULT NULL COMMENT 'Tipo de la persona involucrada\nCTE.- Cliente\nUSU.- Usuario de Servicios\nAVA.- Avales\nPRO.- Prospectos\nREL.-  Relacionados de la cuenta (Que no son socios/clientes)\nNA.- No Aplica (cuando no se trata de Clientes ni de Usuarios)',
  `FechaAlta` date DEFAULT NULL COMMENT 'Fecha de Alta Solo Cuando son Clientes',
  `ActividadBancoMX` varchar(15) DEFAULT NULL COMMENT 'Actividad Principal del Cte, segun Banco de Mexico,Llave Foranea Hacia tabla ACTIVIDADESBMX\n',
  `ActividadBMXDesc` varchar(200) DEFAULT NULL COMMENT 'Descripcion de la Actividad BMX',
  `NivelRiesgo` char(1) DEFAULT NULL COMMENT 'Nivel de Riesgo del Cliente',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria y parte de la llave primaria de la tabla temporal',
  PRIMARY KEY (`Fecha`,`OpeInusualID`,`NumTransaccion`),
  KEY `PLDOPEINUSUALES_IDX_1` (`FechaDeteccion`,`ClavePersonaInv`),
  KEY `fk_PLDOPEINUSUALES_1_idx` (`CatProcedIntID`),
  KEY `fk_PLDOPEINUSUALES_1_idx1` (`CatMotivInuID`),
  CONSTRAINT `FK_TMPPLDOPEINUSUALES_1` FOREIGN KEY (`CatProcedIntID`) REFERENCES `PLDCATPROCEDINT` (`CatProcedIntID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_TMPPLDOPEINUSUALES_2` FOREIGN KEY (`CatMotivInuID`) REFERENCES `PLDCATMOTIVINU` (`CatMotivInuID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal Fisica para la Generación del Reporte de Operaciones Inusuales'$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINUSUALES
DELIMITER ;
DROP TABLE IF EXISTS `PLDOPEINUSUALES`;
DELIMITER $$

CREATE TABLE `PLDOPEINUSUALES` (
  `Fecha` date NOT NULL COMMENT 'fecha de registro de la operación (captura)',
  `OpeInusualID` bigint(20) NOT NULL COMMENT 'consecutivo general',
  `ClaveRegistra` char(2) DEFAULT NULL COMMENT 'clave del tipo de persona que detecta la operación\ntipo de registro (\n1:personal interno,\n2:personal externo,\n3:sistema automático)',
  `NombreReg` varchar(70) DEFAULT NULL,
  `CatProcedIntID` varchar(10) DEFAULT NULL COMMENT 'clave de procedimiento interno donde se localiza la operación\nSegun el catalogo\nPLDCATPROCEDINT',
  `CatMotivInuID` varchar(15) DEFAULT NULL COMMENT 'clave de motivo del registro de la operaciÃ³n\nSegun el Catalogo\nPLDCATMOTIVINU',
  `FechaDeteccion` date DEFAULT NULL COMMENT 'clave de motivo del registro de la operación',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Clave de la sucursal del personal involucrado\nSegun el Catalogo\nSUCURSALES',
  `ClavePersonaInv` int(11) DEFAULT NULL COMMENT 'ID o Clave de la Persona Involucrada',
  `NomPersonaInv` varchar(200) DEFAULT NULL COMMENT 'Nombre de la persona interna involucrada',
  `EmpInvolucrado` varchar(100) DEFAULT NULL COMMENT 'Nombre del empleado involucrado',
  `Frecuencia` char(1) DEFAULT NULL COMMENT 'Existe frecuencia o periodicidad en la ocurrencia de la operación',
  `DesFrecuencia` varchar(150) DEFAULT NULL COMMENT 'descripcion de la frecuencia en veces por espacio de tiempo',
  `DesOperacion` varchar(1000) DEFAULT NULL COMMENT 'Descripcion de la operación inusual.',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Operacion\nSegun el Catalogo\nPLDCATEDOSPREO',
  `ComentarioOC` varchar(3000) DEFAULT NULL COMMENT 'Comentarios del OC.',
  `FechaCierre` date DEFAULT NULL COMMENT 'Fecha en que cambio al estado R o N, Automático por sistema',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito que Genero la Alerta de Operacion Inusual',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `TransaccionOpe` int(11) NOT NULL COMMENT 'Numero de Transaccion que Genero la Alerta de Operacion Inusual',
  `NaturaOperacion` char(1) NOT NULL COMMENT 'Naturaleza que genero la Operacion',
  `MontoOperacion` decimal(18,2) NOT NULL COMMENT 'Monto de la operacion que genero la alerta',
  `MonedaID` int(11) NOT NULL COMMENT 'Tipo de Moneda de la Cuenta que Genero la Operacion',
  `FolioInterno` int(11) NOT NULL COMMENT 'Folio Interno usado para la Generacion del Archivo que se entregara a la CNVB y se arma con la fecha ejemplo fecha  01-May-2013  Folio 20130501',
  `TipoOpeCNBV` char(2) DEFAULT NULL COMMENT 'Tipo de Operacion de Acuerdo a Catalogo de CNBV\n01=DepÃ³sito\n02=Retiro\n03=Compra Divisas\n04=Venta Divisas\n05=Cheques de Caja\n06=Giros\n07=Ordenes de Pago\n08=Otorgamiento de CrÃ©dito\n09=Pago de CrÃ©dito\n10=Pago de Primas u OperaciÃ³n de Reaseguro\n11=Aportac',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Registra forma de pago de la oeracion inusual ''E'' Efectivo, ''T'' Transferencia, ''H''  Cheque',
  `TipoPersonaSAFI` varchar(3) DEFAULT NULL COMMENT 'Tipo de la persona involucrada\nCTE.- Cliente\nUSU.- Usuario de Servicios\nAVA.- Avales\nPRO.- Prospectos\nREL.-  Relacionados de la cuenta (Que no son socios/clientes)\nNA.- No Aplica (cuando no se trata de Clientes ni de Usuarios)',
  `NombresPersonaInv` varchar(150) DEFAULT NULL COMMENT 'Nombres de la persona involucrada.',
  `ApPaternoPersonaInv` varchar(50) DEFAULT NULL,
  `ApMaternoPersonaInv` varchar(50) DEFAULT NULL,
  `TipoListaID` varchar(45) DEFAULT NULL COMMENT 'ID del Catalogo de Tipos de Listas de PLD',
  `ProcesoDetec` int(11) DEFAULT '1' COMMENT '1. Proceso Anterior\n2. Proceso Nuevo',
  `ConsecutivoCuentaRel` int(11) DEFAULT '0' COMMENT 'Número consecutivo de la persona relacionada a la cuenta.\n00 Titular',
  `NumCuentaRelacionado` bigint(12) DEFAULT NULL COMMENT 'Núm. Cuenta de la persona relacionada a la cuenta.',
  `NombreRelacionado` varchar(100) DEFAULT '' COMMENT 'Nombre(s) de la persona relacionada a la cuenta.',
  `ApellidoPaternoRelacionado` varchar(100) DEFAULT '' COMMENT 'Apellido Paterno de la persona relacionada a la cuenta.',
  `ApellidoMaternoRelacionado` varchar(100) DEFAULT '' COMMENT 'Apellido Materno de la persona relacionada a la cuenta.',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Fecha`,`OpeInusualID`),
  KEY `PLDOPEINUSUALES_IDX_1` (`FechaDeteccion`,`ClavePersonaInv`),
  KEY `FK_PLDOPEINUSUALES_1` (`CatProcedIntID`),
  KEY `FK_PLDOPEINUSUALES_2` (`CatMotivInuID`),
  KEY `INDEX_PLDOPEINUSUALES_1` (`ClavePersonaInv`,`SucursalID`,`NomPersonaInv`,`MonedaID`,`CatProcedIntID`,`CatMotivInuID`,`DesOperacion`,`CreditoID`,`CuentaAhoID`,`TransaccionOpe`,`NaturaOperacion`,`MontoOperacion`,`FormaPago`,`TipoPersonaSAFI`,`TipoOpeCNBV`),
  CONSTRAINT `FK_PLDOPEINUSUALES_1` FOREIGN KEY (`CatProcedIntID`) REFERENCES `PLDCATPROCEDINT` (`CatProcedIntID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_PLDOPEINUSUALES_2` FOREIGN KEY (`CatMotivInuID`) REFERENCES `PLDCATMOTIVINU` (`CatMotivInuID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro de Operaciones Inusuales(clientes)'$$
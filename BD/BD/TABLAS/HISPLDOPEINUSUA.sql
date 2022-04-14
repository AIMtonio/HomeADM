-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPLDOPEINUSUA
DELIMITER ;
DROP TABLE IF EXISTS `HISPLDOPEINUSUA`;DELIMITER $$

CREATE TABLE `HISPLDOPEINUSUA` (
  `Fecha` date NOT NULL COMMENT 'fecha de registro de la operaciÃ³n (captura)',
  `OpeInusualID` int(11) NOT NULL COMMENT 'consecutivo general',
  `ClaveRegistra` char(2) DEFAULT NULL COMMENT 'clave del tipo de persona que detecta la operaciÃ³n\ntipo de registro (\n1:personal interno,\n2:personal externo,\n3:sistema automÃ¡tico)',
  `NombreReg` varchar(35) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL COMMENT 'Nombre de quien detecta la operaciÃ³n\nOpcional',
  `CatProcedIntID` varchar(10) DEFAULT NULL COMMENT 'clave de procedimiento interno donde se localiza la operaciÃ³n\nSegun el catalogo\nPLDCATPROCEDINT',
  `CatMotivInuID` varchar(15) DEFAULT NULL COMMENT 'clave de motivo del registro de la operaciÃ³n\nSegun el Catalogo\nPLDCATMOTIVINU',
  `FechaDeteccion` date DEFAULT NULL COMMENT 'clave de motivo del registro de la operaciÃ³n',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Clave de la sucursal del personal involucrado\nSegun el Catalogo\nSUCURSALES',
  `ClavePersonaInv` int(11) DEFAULT NULL COMMENT 'ID o Clave de la Persona Involucrada',
  `NomPersonaInv` varchar(100) DEFAULT NULL COMMENT 'Nombre de la persona interna involucrada',
  `EmpInvolucrado` varchar(100) DEFAULT NULL COMMENT 'Nombre del empleado involucrado',
  `Frecuencia` char(1) DEFAULT NULL COMMENT 'Existe frecuencia o periodicidad en la ocurrencia de la operaciÃ³n',
  `DesFrecuencia` varchar(50) DEFAULT NULL COMMENT 'descripcion de la frecuencia en veces por espacio de tiempo',
  `DesOperacion` varchar(300) DEFAULT NULL COMMENT 'Descripcion de la operaciÃ³n inusual',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Operacion\nSegun el Catalogo\nPREOCUPAEDOS',
  `ComentarioOC` varchar(1500) DEFAULT NULL COMMENT 'Comentarios del OC',
  `FechaCierre` date DEFAULT NULL COMMENT 'Fecha en que cambio al estado R o N, AutomÃ¡tico por sistema',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito que Genero la Alerta de Operacion Inusual',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `TransaccionOpe` int(11) NOT NULL COMMENT 'Numero de Transaccion que Genero la Alerta de Operacion Inusual',
  `NaturaOperacion` char(1) NOT NULL COMMENT 'Naturaleza que genero la Operacion',
  `MontoOperacion` decimal(18,2) NOT NULL COMMENT 'Monto de la operacion que genero la alerta',
  `MonedaID` int(11) NOT NULL COMMENT 'Tipo de Moneda de la Cuenta que Genero la Operacion',
  `FolioInterno` int(11) NOT NULL COMMENT 'Folio Interno usado para la Generacion del Archivo que se entregara a la CNVB y se arma con la fecha ejemplo fecha  01-May-2013  Folio 20130501',
  `FolioSITI` varchar(15) DEFAULT NULL COMMENT 'Folio con el que se registro el Archivo en el SITI',
  `UsuarioSITI` varchar(15) DEFAULT NULL COMMENT 'Usuario del SITI que subio el archivo',
  `NombreArchivo` varchar(45) DEFAULT NULL COMMENT 'Nombre del Archivo en el que se envio la operacion detectada',
  `TipoOpeCNBV` char(2) DEFAULT NULL COMMENT 'Tipo de Operacion de Acuerdo a Catalogo de CNBV\n01=DepÃ³sito\n02=Retiro\n03=Compra Divisas\n04=Venta Divisas\n05=Cheques de Caja\n06=Giros\n07=Ordenes de Pago\n08=Otorgamiento de CrÃ©dito\n09=Pago de CrÃ©dito\n10=Pago de Primas u OperaciÃ³n de Reaseguro\n11=Aportac',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Registra forma de pago de la operacion inusual ''E'' Efectivo, ''T'' Transferencia, ''H''  Cheque',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro Historico de Operaciones Inusuales'$$
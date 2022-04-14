-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARCHIVOCARGADEPREF
DELIMITER ;
DROP TABLE IF EXISTS `ARCHIVOCARGADEPREF`;
DELIMITER $$

CREATE TABLE `ARCHIVOCARGADEPREF` (
  `NumTran` bigint(20) NOT NULL COMMENT 'Numero de Transaccion de Carga.',
  `FolioCargaID` bigint(17) NOT NULL COMMENT 'Folio unico de Carga de Archivo a Conciliar.',
  `CuentaAhoID` varchar(20) DEFAULT NULL COMMENT 'ID de la Cuenta de ahorro.',
  `NumeroMov` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion del Movimiento (se llena al conciliar).',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Numero de la Institucion Bancaria.',
  `FechaCarga` date DEFAULT NULL COMMENT 'Fecha de Carga de Archivo a Conciliar.',
  `FechaAplica` date DEFAULT NULL COMMENT 'Fecha de Registro de la Operacion en el Banco.',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento.\nC.- Cargo.\nA.- Abono.',
  `MontoMov` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Movimiento.',
  `TipoMov` char(4) DEFAULT NULL COMMENT 'Id del Tipo de Movimiento.',
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'Decripcion del Movimiento.',
  `ReferenciaMov` varchar(40) DEFAULT NULL COMMENT 'Referencia del Movimiento Debe ser el CREDITO o CUENTA.',
  `DescripcionNoIden` varchar(150) DEFAULT NULL COMMENT 'Descripcion nueva al genera los Depositos No Identificados.',
  `ReferenciaNoIden` varchar(35) DEFAULT NULL COMMENT 'Nueva referencia del resultado de lo No Identificado.',
  `Estatus` char(2) DEFAULT NULL COMMENT 'Estatus de Conciliacion.\nNacen como \nN.- No Aplicado\nNI .-  No identificado,\nA .-  Aplicado,\nC .-  Cancelado.',
  `MontoPendApli` decimal(12,2) DEFAULT NULL COMMENT 'Monto Pendiente de Aplicar.',
  `TipoDeposito` char(1) DEFAULT NULL COMMENT 'Tipo de Deposito.\nE .-  Si pago Efectivo\nT .-  Otro tipo deposito.',
  `TipoCanal` int(11) DEFAULT NULL COMMENT 'Identificacion por donde vino el deposito, corresponde con\nla tabla :\nTIPOCANAL.',
  `NumIdenArchivo` varchar(20) NOT NULL DEFAULT ' ' COMMENT 'Este campo se forma con el numero de transaccion del archivo y\ncon la fecha en que se realiza la operacion, cero indica vacio.',
  `MonedaId` int(11) DEFAULT NULL COMMENT 'Numero de la Moneda. MONEDAS.',
  `Validacion` varchar(150) DEFAULT NULL COMMENT 'Mensaje de Validacion.',
  `NumVal` int(11) DEFAULT NULL COMMENT 'Numero de validacion.',
  `NumeroFila` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de Fila del deposito en el archivo cargado',
  `AplicarDeposito` char(1) NOT NULL DEFAULT 'N' COMMENT 'En la pantalla de Depositos se selecciono para aplicar el deposito S= si, N = no, A = Aplicado por proceso masivo',
  `NombreArchivoCarga` varchar(500) NOT NULL DEFAULT '' COMMENT 'Nombre del archivo donde se cargo el deposito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  PRIMARY KEY (`NumTran`,`FolioCargaID`),
  KEY `IDX_ARCHIVOCARGADEPREF_1` (`NumTran`),
  KEY `IDX_ARCHIVOCARGADEPREF_2` (`NumIdenArchivo`),
  KEY `IDX_ARCHIVOCARGADEPREF_3` (`NumIdenArchivo`,`NumTran`),
  KEY `IDX_ARCHIVOCARGADEPREF_4` (`InstitucionID`,`CuentaAhoID`,`NumTran`,`Estatus`),
  KEY `IDX_ARCHIVOCARGADEPREF_5` (`InstitucionID`,`ReferenciaMov`,`TipoCanal`,`NumVal`),
  KEY `IDX_ARCHIVOCARGADEPREF_6` (`NumeroFila`),
  KEY `IDX_ARCHIVOCARGADEPREF_7` (`AplicarDeposito`),
  KEY `IDX_ARCHIVOCARGADEPREF_8` (`NumTran`,`NumeroFila`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Almacena los registros leidos del archivo de carga en la pantalla de Depositos Referenciados.'$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOREFERE
DELIMITER ;
DROP TABLE IF EXISTS `DEPOSITOREFERE`;
DELIMITER $$


CREATE TABLE `DEPOSITOREFERE` (
  `FolioCargaID` bigint(17) NOT NULL COMMENT 'Folio unico de Carga de Archivo a Conciliar',
  `CuentaAhoID` varchar(20) NOT NULL COMMENT 'ID de la Cuenta de ahorro',
  `NumeroMov` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion del Movimiento (se llena al conciliar)',
  `InstitucionID` int(11) NOT NULL COMMENT 'Id Del Banco (Institucion) de donde es la Cuenta',
  `FechaCarga` date DEFAULT NULL COMMENT 'Fecha de Carga de Archivo a Conciliar',
  `FechaAplica` date DEFAULT NULL COMMENT 'Fecha de Registro de la Operacion en el Banco',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento  C=Cargo, A=Abono',
  `MontoMov` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Movimiento',
  `TipoMov` char(4) DEFAULT NULL COMMENT 'Id del Tipo de Movimiento (se llena en el proceso)',
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'Decripcion del Movimiento (la que trae en la carga)',
  `ReferenciaMov` varchar(40) DEFAULT NULL COMMENT 'Referencia del Movimiento Debe ser el CREDITO o CUENTA',
  `DescripcionNoIden` varchar(150) DEFAULT NULL COMMENT 'Descripcion nueva al genera los Depositos No Identificados',
  `ReferenciaNoIden` varchar(35) DEFAULT NULL COMMENT 'Nueva referencia del resultado de lo No Identificado',
  `Status` char(2) DEFAULT NULL COMMENT 'Estatus de Conciliacion \nNacen como \nN=No Aplicado\nNI = No identificado,\nA = Aplicado,\nC = Cancelado (borrado logicamente)',
  `MontoPendApli` decimal(12,2) DEFAULT NULL COMMENT 'Monto Pendiente de Aplicar',
  `TipoDeposito` char(1) DEFAULT NULL COMMENT 'E = Si pago Efectivo\nT = Otro tipo deposito \nC= Cheque',
  `TipoCanal` int(11) DEFAULT NULL COMMENT 'Identificacion\npor donde\nvino el deposito,\ncorresponde con \nla tabla :\nTIPOCANAL',
  `NumIdenArchivo` varchar(20) NOT NULL DEFAULT '' COMMENT 'Este campo se forma con el número de transacción del archivo y con la fecha en que se realizá la operación, cero indica vacío.',
  `MonedaId` int(11) DEFAULT NULL COMMENT 'Tipo de moneda',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FolioCargaID`,`CuentaAhoID`,`InstitucionID`),
  KEY `fk_DEPOSITOREFERE_1` (`CuentaAhoID`),
  KEY `fk_DEPOSITOREFERE_2` (`InstitucionID`),
  KEY `fk_DEPOSITOREFERE_4` (`ReferenciaMov`),
  KEY `index5` (`FechaCarga`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Carga de Depositos Referenciados'$$
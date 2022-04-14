-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSANTGASTOS
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSANTGASTOS`;DELIMITER $$

CREATE TABLE `TIPOSANTGASTOS` (
  `TipoAntGastoID` int(11) NOT NULL COMMENT 'Id del Tipo  de gasto o anticipo',
  `Descripcion` varchar(75) DEFAULT NULL COMMENT 'Descripcion del tipo de Gasto o Anticipo',
  `Naturaleza` char(1) DEFAULT NULL COMMENT 'Naturaleza: Salida  "S" /Entrada "E"',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus Activo  "A" /Inactivo "I"',
  `EsGastoTeso` char(1) DEFAULT NULL COMMENT 'Es Gasto Tesoreria "S"=SI  / "N"= NO',
  `TipoGastoID` int(11) DEFAULT NULL COMMENT 'Tipo de Gasto Tesoreria ',
  `ReqNoEmp` char(1) DEFAULT NULL COMMENT 'Requiere No Empleado SI="S"/NO="N"',
  `CtaContable` char(25) DEFAULT NULL COMMENT 'Cuenta Contable\n',
  `CentroCosto` varchar(30) DEFAULT NULL COMMENT 'Centro de Costos',
  `Instrumento` int(11) DEFAULT NULL COMMENT 'instrumento contable',
  `MontoMaxEfect` decimal(14,2) DEFAULT NULL COMMENT 'Monto Maximo para dar en caja',
  `MontoMaxTrans` decimal(14,2) DEFAULT NULL COMMENT 'Monto maximo de transacciones en ventanilla',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`TipoAntGastoID`),
  KEY `fk_TIPOSANTGASTOS_1_idx` (`TipoGastoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
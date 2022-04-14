-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQGASTOSUCUR
DELIMITER ;
DROP TABLE IF EXISTS `REQGASTOSUCUR`;DELIMITER $$

CREATE TABLE `REQGASTOSUCUR` (
  `NumReqGasID` int(11) NOT NULL DEFAULT '0' COMMENT 'Número de  Requisición',
  `SucursalID` int(11) DEFAULT '0' COMMENT 'ID de la Sucursal ',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'ID del Usuario',
  `FechRequisicion` date DEFAULT NULL COMMENT 'Fecha de Requisición',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Forma de Pago\nS .-SPEI\nC .-CHEQUE\nE .-EFECTIVO\n',
  `CuentaDepositar` int(11) DEFAULT NULL COMMENT 'Cuenta a depositar\nrelacionado\ncon consecutivo de\nCUENTASAHOSUCUR',
  `EstatusReq` char(1) DEFAULT NULL COMMENT 'Estatus de la Requisicion\nC .-CANCELADA\nP .-PROCESADA - Nacen con este estatus\nF .-FINALIZADA\n',
  `TipoGasto` char(1) DEFAULT NULL COMMENT 'Centralizados=C ,\nLocales = L\n',
  `FolioDispersion` int(11) DEFAULT NULL COMMENT 'ID relacionado con\nla tabla \nDISPERCION',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL COMMENT '	',
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`NumReqGasID`),
  KEY `fk_REQGASTOSUCUR_1` (`SucursalID`),
  KEY `fk_REQGASTOSUCUR_2` (`UsuarioID`),
  CONSTRAINT `fk_REQGASTOSUCUR_1` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REQGASTOSUCUR_2` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Requisición de Gastos a Sucursal'$$
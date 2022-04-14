-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CTASCONTAPLIGAR
DELIMITER ;
DROP TABLE IF EXISTS `CTASCONTAPLIGAR`;DELIMITER $$

CREATE TABLE `CTASCONTAPLIGAR` (
  `TipoGarantiaID` int(11) NOT NULL COMMENT 'Tipo de Garantia Fira',
  `CuentaCompleta` varchar(50) NOT NULL DEFAULT '' COMMENT 'Cuenta contable de la garantia',
  `Descripcion` varchar(250) NOT NULL DEFAULT '' COMMENT 'Descripcion de la cuenta contable',
  `MonedaID` int(11) NOT NULL COMMENT 'Tipo de Moneda de la cta contable',
  `CentroCosto` varchar(60) NOT NULL COMMENT 'Centro de costo:  &SO = Sucursal Origen, &SC = Sucursal Cliente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoGarantiaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena las cuentas contables utlizadas en aplicacion de garantias fira.'$$
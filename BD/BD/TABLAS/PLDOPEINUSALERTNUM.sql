-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINUSALERTNUM
DELIMITER ;
DROP TABLE IF EXISTS `PLDOPEINUSALERTNUM`;DELIMITER $$

CREATE TABLE `PLDOPEINUSALERTNUM` (
  `PldOpeInusAlertID` bigint(20) NOT NULL,
  `CuentasAhoID` bigint(12) NOT NULL DEFAULT '0',
  `ClienteID` varchar(45) NOT NULL COMMENT 'Numero de Cliente de la Operacion',
  `NumeroMov` bigint(20) NOT NULL COMMENT 'Numero de Operacion, es el Numero de Transaccion',
  `NombreCliente` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo del Cliente',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en que se realiza la Operacion',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza de la Operacion\nA: Abono\nC: Cargo',
  `CantidadMov` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Operacion',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda en que se reliza la Operacion',
  `TipoOpeCNBV` char(2) DEFAULT NULL COMMENT 'Tipo de Operacion de Acuerdo a Catalogo de CNBV',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Registra forma de pago de la Operacion inusual ''E'' Efectivo, ''T'' Transferencia, ''H''  Cheque',
  `SucursalCli` int(11) DEFAULT NULL COMMENT 'Sucursal de Origen del Cliente',
  `Metodo` int(11) DEFAULT '1' COMMENT 'Campo de apoyo para identificar si las operaciones fueron detectadas con los nuevos cambios del perfil transaccional.\n1: Anterior\n2: Vigente',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CuentasAhoID`,`ClienteID`,`NumeroMov`,`PldOpeInusAlertID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los Movimientos en Cuentas que superaron su Transaccionalidad por Numero de Depositos o Retiros'$$
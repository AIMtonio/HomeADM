-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ABONOCHEQUESBC
DELIMITER ;
DROP TABLE IF EXISTS `ABONOCHEQUESBC`;DELIMITER $$

CREATE TABLE `ABONOCHEQUESBC` (
  `ChequeSBCID` int(11) NOT NULL COMMENT 'id de la tabla',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente que Cobra el Cheque corresponde con la tabla CLIENTES',
  `NombreReceptor` varchar(200) DEFAULT NULL COMMENT 'Nombre de la persona que cobra el cheque',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Recibido 	= R\nAplicado	=A\nCancelado =C',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto del cheque',
  `BancoEmisor` int(11) DEFAULT NULL COMMENT 'ID del Banco al que pertenece el Cheque corresponde con la tabla INSTITUCIONES',
  `CuentaEmisor` varchar(20) DEFAULT NULL COMMENT 'Este numero de cuenta pertenece al banco emisor ',
  `NumCheque` bigint(10) DEFAULT NULL COMMENT 'Número del cheque que se cobrara',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'sucursal donde se realiza la operacion',
  `NombreEmisor` varchar(200) DEFAULT NULL COMMENT 'Nombre del Emisor',
  `CajaID` int(12) DEFAULT NULL COMMENT 'Numero de Caja donde se reliza la operacion',
  `FechaCobro` date DEFAULT NULL COMMENT 'Fecha en que se realiza la operacion de Cobro del cheque (solo afecta al saldo SBC)',
  `FechaAplicacion` date DEFAULT NULL COMMENT 'Fecha en que se realiza la aplicacion del Cheque(Abono afectando el saldo disponible)',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Usuario que realiza la operacion',
  `NumMovimiento` bigint(20) DEFAULT NULL COMMENT 'numero de movimiento',
  `NumInstAplica` int(11) DEFAULT NULL COMMENT 'número de institucion a la que pertenece el cheque solo cuando la forma de Aplicacion es deposito a  cuenta.',
  `FormaAplica` char(1) DEFAULT NULL COMMENT 'Forma en la que se Aplica el cobro del cheque SBC \nE= Efectivo\nD= Deposito\n',
  `CuentaAplica` varchar(20) DEFAULT NULL COMMENT 'Numero de cuenta a la que se aplica  el deposito del cheque SBC',
  `TipoCtaCheque` char(1) DEFAULT NULL COMMENT 'I= Interna \nE=Externa',
  `FormaCobro` char(1) DEFAULT NULL COMMENT 'D= Deposito a Cuenta\nE=Efectivo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ChequeSBCID`),
  KEY `fk_ABONOCHEQUESBC_3_idx` (`SucursalID`,`CajaID`),
  CONSTRAINT `fk_ABONOCHEQUESBC_3` FOREIGN KEY (`SucursalID`, `CajaID`) REFERENCES `CAJASVENTANILLA` (`SucursalID`, `CajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
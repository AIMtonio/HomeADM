-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDMOVIMIENTOSCTA
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDMOVIMIENTOSCTA`;DELIMITER $$

CREATE TABLE `TMPPLDMOVIMIENTOSCTA` (
  `IDPLDMov` int(11) NOT NULL AUTO_INCREMENT,
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'Clave de la sucursal del personal involucrado\nSegun el Catalogo\nSUCURSALES',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
  `SoloNombres` varchar(500) DEFAULT NULL COMMENT 'Primer Nombre, Segundo Nombre y Tercer Nombre',
  `ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del Cliente\n',
  `ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del Cliente\n',
  `Fecha` date NOT NULL COMMENT 'fecha del movimiento',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `TipoMovAhoID` char(4) NOT NULL COMMENT 'ID del Tipo de \nMovimiento de \nAhorro\n',
  `TipoOpeCNBV` char(2) DEFAULT NULL COMMENT 'Tipo de Operacion de Acuerdo a Catalogo de CNBV\n01=DepÃ³sito\n02=Retiro\n03=Compra Divisas\n04=Venta Divisas\n05=Cheques de Caja\n06=Giros\n07=Ordenes de Pago\n08=Otorgamiento de CrÃ©dito\n09=Pago de CrÃ©dito\n10=Pago de Primas u OperaciÃ³n de Reaseguro\n11=Aportac',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion del\nTipo de Movimiento\nDe Ahorro',
  `DescripcionMov` varchar(150) NOT NULL COMMENT 'Descripcion del movimiento en estado de cuenta',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del Movimiento C cargo A abono',
  `CantidadMov` decimal(12,2) DEFAULT NULL,
  `MonedaID` int(11) NOT NULL,
  `DetecPLD` char(1) DEFAULT 'N' COMMENT 'Aplica la opeacion para la detección de operaciones Inusuales PLD',
  `EsEfectivo` char(1) NOT NULL COMMENT 'Indica si el tipo de \nMovimiento\nes en Efectivo\n\nSi - '' S ''\nNo - ''N''',
  `EsCredito` char(1) DEFAULT 'N' COMMENT 'Es Instrumento de Crédito',
  `EsDocumentos` char(1) DEFAULT 'N' COMMENT 'Define si la operacion es por el instrumento de Documentos.\nS:Si N:No',
  `EsTransferencia` char(1) DEFAULT 'N' COMMENT 'Define si el tipo de movimiento es por transferencia.',
  `DepositosMax` decimal(16,2) DEFAULT NULL COMMENT 'Monto Máximo de Abonos y Retiros por Operación.',
  `RetirosMax` decimal(16,2) DEFAULT NULL COMMENT 'Número Máximo de Transacciones',
  `NumDepositos` int(11) DEFAULT NULL COMMENT 'Número de Depositos Maximos realizados en un periodo de un Mes',
  `NumRetiros` int(11) DEFAULT NULL COMMENT 'Número de Retiros Maximos realizados en un periodo de un Mes',
  `NumeroMov` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  `DepositosHolg` decimal(16,2) DEFAULT NULL COMMENT 'Monto Máximo de Abonos y Retiros por Operación.',
  `DetectExcDepositos` char(1) DEFAULT NULL COMMENT 'Deteccion Monto de Depositos',
  `SumCantidadDepoMov` decimal(18,2) DEFAULT NULL,
  `RetirosMaxHolg` decimal(16,2) DEFAULT NULL COMMENT 'Número Máximo de Transacciones',
  `DetectExcRetiros` char(1) DEFAULT NULL COMMENT 'Deteccion Monto de Retiros',
  `SumCantidadRetoMov` decimal(18,2) DEFAULT NULL,
  `NumDepositosHolg` decimal(12,2) DEFAULT NULL COMMENT 'Número de Depositos Maximos realizados en un periodo de un Mes',
  `DetectNDepositos` char(1) DEFAULT NULL COMMENT 'Deteccion Numero de Depositos',
  `NDeposito` int(5) NOT NULL DEFAULT '0',
  `NumRetirosHolg` decimal(12,2) DEFAULT NULL COMMENT 'Número de Retiros Maximos realizados en un periodo de un Mes',
  `DetectNRetiros` char(1) DEFAULT NULL COMMENT 'Deteccion Numero de Retiros',
  `NRetiro` int(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`IDPLDMov`),
  KEY `IDX_TMPPLDMOVIMIENTOSCTA_1` (`ClienteID`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=latin1$$
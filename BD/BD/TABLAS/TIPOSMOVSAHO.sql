-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVSAHO
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSMOVSAHO`;
DELIMITER $$


CREATE TABLE `TIPOSMOVSAHO` (
  `TipoMovAhoID` char(4) NOT NULL COMMENT 'ID del Tipo de \nMovimiento de \nAhorro\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion del\nTipo de Movimiento\nDe Ahorro',
  `EsEfectivo` char(1) NOT NULL COMMENT 'Indica si el tipo de \nMovimiento\nes en Efectivo\n\nSi - '' S ''\nNo - ''N''',
  `TipoOpeCNBV` char(2) DEFAULT NULL COMMENT 'Tipo de Operacion de Acuerdo a Catalogo de CNBV\n01=DepÃ³sito\n02=Retiro\n03=Compra Divisas\n04=Venta Divisas\n05=Cheques de Caja\n06=Giros\n07=Ordenes de Pago\n08=Otorgamiento de CrÃ©dito\n09=Pago de CrÃ©dito\n10=Pago de Primas u OperaciÃ³n de Reaseguro\n11=Aportac',
  `ClasificacionMov` int(11) DEFAULT NULL COMMENT '1= Mov. General\n2= Mov, de Comisión\n3= Mov. de IVA\n4= Mov. deISR\n5= Mov. de Bonificación\n6= Mov. de IDE\n7= Mov. de Intereses\n8= Otros',
  `OrigenMov` int(11) DEFAULT NULL COMMENT '1= Cuenta Ahorro\n2= Inversiones\n3= Cedes\n4= Credito\n5= Otros\n6 = Aportaciones',
  `DetecPLD` char(1) DEFAULT 'N' COMMENT 'Aplica la opeacion para la detección de operaciones Inusuales PLD',
  `EsCredito` char(1) DEFAULT 'N' COMMENT 'Es Instrumento de Crédito',
  `EsDocumentos` char(1) DEFAULT 'N' COMMENT 'Define si la operacion es por el instrumento de Documentos.\nS:Si N:No',
  `EsTransferencia` char(1) DEFAULT 'N' COMMENT 'Define si el tipo de movimiento es por transferencia.',
  `Icono` VARCHAR(30) NOT NULL DEFAULT ''  COMMENT 'Icono de representacion del movimiento',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoMovAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Movimientos del Modulo de  Ahorro'$$

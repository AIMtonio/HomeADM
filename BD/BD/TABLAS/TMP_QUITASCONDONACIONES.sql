-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_QUITASCONDONACIONES
DELIMITER ;
DROP TABLE IF EXISTS `TMP_QUITASCONDONACIONES`;
DELIMITER $$

CREATE TABLE `TMP_QUITASCONDONACIONES` (
  `AmortizacionID` INT(4) NOT NULL COMMENT 'No\nAmortizacion',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `MonedaID` INT(11) DEFAULT NULL COMMENT 'Moneda',
  `Estatus` CHAR(1) DEFAULT NULL COMMENT 'Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nA.- Autorizado\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nK.- Castigado',
  `SucursalOrigen` INT(5) DEFAULT NULL COMMENT 'No de Sucursal a la que pertenece el cliente, Llave Foranea Hacia Tabla SUCURSALES\n',
  `ProductoCreditoID` INT(4) DEFAULT NULL COMMENT 'Producto de Credito ',
  `Clasificacion` CHAR(1) DEFAULT NULL COMMENT 'C : Comercial\nO : Consumo\nH : Hipotecario',
  `SaldoCapVigente` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente, en el alta nace con ceros',
  `SaldoCapAtrasa` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Atrasado, en el alta nace con ceros',
  `SaldoCapVencido` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido, en el alta nace con ceros',
  `SaldoCapVenNExi` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido no Exigible, en al alta nace con ceros',
  `SaldoInteresOrd` DECIMAL(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Ordinario, en el alta nace con ceros',
  `SaldoInteresAtr` DECIMAL(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Atrasado, en el alta nace con ceros',
  `SaldoInteresPro` DECIMAL(14,4) DEFAULT NULL COMMENT 'Saldo de Provision, en el alta nace con ceros',
  `SaldoIntNoConta` DECIMAL(12,4) DEFAULT NULL COMMENT 'Saldo de Interes\nNo Contabilizado',
  `SaldoMoratorios` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo Moratorios, en el alta nace con ceros',
  `SaldoComFaltaPa` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo Comision Falta Pago, en el alta nace con ceros',
  `SaldoOtrasComis` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo Otras Comisiones, en el alta nace con ceros',
  `SaldoInteresVen` DECIMAL(14,4) DEFAULT NULL COMMENT 'Saldos de Interes Vencido, en el alta nace con ceros',
  `SubClasifID` INT(11) DEFAULT NULL COMMENT 'ID de Sub Clasificacion de Cartera',
  `SaldoMoraVencido` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
  `SaldoMoraCarVen` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
  `SaldoNotCargoRev` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Notas Cargos Reversa',
  `SaldoNotCargoSinIVA` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Notas Cargos sin Iva',
  `SaldoNotCargoConIVA` DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Notas Cargos con Iva',
  `SaldoComServGar` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision por Servicio de Garantia Agro',
  `Aud_NumTransaccion` BIGINT(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP-CONDONACIONES'$$

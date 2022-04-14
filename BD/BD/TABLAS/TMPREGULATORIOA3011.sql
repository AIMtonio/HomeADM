-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREGULATORIOA3011
DELIMITER ;
DROP TABLE IF EXISTS `TMPREGULATORIOA3011`;DELIMITER $$

CREATE TABLE `TMPREGULATORIOA3011` (
  `EstadoID` int(11) DEFAULT '0' COMMENT 'ID del estado',
  `MunicipioID` varchar(20) DEFAULT '' COMMENT 'ID del municipio',
  `ColoniaID` int(11) DEFAULT NULL COMMENT 'Id de la Colonia',
  `CodigoPostal` varchar(5) DEFAULT NULL COMMENT 'ID del Codigo Postal',
  `ClaveMunicipio` varchar(200) DEFAULT NULL COMMENT 'Clave del municipio segun la CNBV',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion que genera el reporte',
  `Periodo` int(2) DEFAULT NULL COMMENT 'Periodo para el cual se genera el reporte	',
  `ClaveEntidad` varchar(20) DEFAULT NULL COMMENT 'Clave de la entidad (es un parametro)',
  `ClaveFormulario` int(11) DEFAULT NULL COMMENT 'Clave del formulario (es un valor fijo)',
  `NumSucursales` int(11) DEFAULT NULL COMMENT 'Numero de sucursales por municipio',
  `NumCajerosATM` int(111) DEFAULT NULL COMMENT 'Numero de cajeros automaticos por municipio',
  `NumMujeres` int(11) DEFAULT NULL COMMENT 'Total de mujeres ',
  `NumHombres` int(11) DEFAULT NULL COMMENT 'Total de hombres',
  `ParteSocial` decimal(14,2) DEFAULT NULL COMMENT 'Sumatoria de la aportacion social ',
  `NumContrato` int(11) DEFAULT NULL COMMENT 'Total de cuentas de ahorro activas',
  `SaldoAcum` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldo de cuentas de ahorro activas',
  `NumContratoPlazo` int(11) DEFAULT NULL COMMENT 'Total de inversiones vigentes',
  `SaldoAcumPlazo` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de Saldo de inversiones vigentes incluye interes ',
  `NumContratoTD` int(11) DEFAULT NULL COMMENT 'Total de tarjetas de debito',
  `SaldoAcumTD` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldos de las cuentas que corresponden a las Tarjetas de debito',
  `NumContratoTDRecar` int(11) DEFAULT NULL COMMENT 'Total de tarjetas de debito Recargables (Por ahora vale 0)',
  `SaldoAcumTDRecar` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldos de las cuentas que corresponden a las Tarjetas de debito recargables(Por ahora vale 0.0)',
  `NumCreditos` int(11) DEFAULT NULL COMMENT 'Total de creditos por clasificacion de destino',
  `SaldoVigenteCre` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldo de creditos vigentes por clasificacion de destino',
  `SaldoVencidoCre` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldo de creditos vencidos por clasificacion de destino',
  `NumMicroCreditos` int(11) DEFAULT NULL COMMENT 'Total de Microcreditos por clasificacion de destino',
  `SaldoVigenteMicroCre` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldo de microcreditos vigentes por clasificacion de destino',
  `SaldoVencidoMicroCre` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldo de microcreditos vencidos por clasificacion de destino',
  `NumContratoTC` int(11) DEFAULT NULL COMMENT 'Total de tarjetas de creditos',
  `SaldoVigenteTC` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldo vigente de tarjetas de credito	',
  `SaldoVencidoTC` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldo vencido de tarjetas de credito	',
  `NumCreConsumo` int(11) DEFAULT NULL COMMENT 'Total de creditos de consumo ',
  `SaldoVigenteCreConsumo` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldo vigente de creditos de consumo',
  `SaldoVencidoCreConsumo` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldo vencido de creditos de consumo',
  `NumCreVivienda` int(11) DEFAULT NULL COMMENT 'Total de creditos de vivienda ',
  `SaldoVigenteCreVivienda` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldo vigente de creditos de vivienda',
  `SaldoVencidoCreVivienda` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de saldo vencido de creditos de vivienda',
  `NumRemesas` int(11) DEFAULT NULL COMMENT 'Total de remesas pagadas en el periodo',
  `MontoRemesas` decimal(14,2) DEFAULT NULL COMMENT 'Sumatorio de montos pagados por remesas',
  KEY `idxNumTranTmp` (`NumTransaccion`,`EstadoID`,`MunicipioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
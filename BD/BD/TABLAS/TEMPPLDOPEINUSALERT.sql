-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TEMPPLDOPEINUSALERT
DELIMITER ;
DROP TABLE IF EXISTS `TEMPPLDOPEINUSALERT`;
DELIMITER $$


CREATE TABLE `TEMPPLDOPEINUSALERT` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de Transaccion asignado por el proceso.',
  `Fecha` date NOT NULL COMMENT 'Fecha del movimiento',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `TipoPersona` char(1) NOT NULL COMMENT 'Tipo de Persona A:Persona Fisica con Actividad Empresaria, F:Fisica, M:Moral.',
  `NivelRiesgo` char(1) NOT NULL COMMENT 'Nivel de Riesgo B:Bajo A:Alto M:Medio',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Numero de Cuenta de Ahorro',
  `NumeroMov` bigint(20) NOT NULL COMMENT 'Numero de transaccion que origino el movimiento',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del Movimiento C cargo A abono',
  `CantidadMov` decimal(12,2) DEFAULT NULL COMMENT 'Monto Cantidad de Movimiento',
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'Descripcion del movimiento en estado de cuenta',
  `TipoMovAhoID` char(4) NOT NULL COMMENT 'Tipo de Movimiento',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Tipo de Moneda',
  `EsEfectivo` char(1) DEFAULT NULL COMMENT 'Define si la operacion es por el instrumento de Efectivo.\nS:Si N:No',
  `EsTransferencia` char(1) DEFAULT NULL COMMENT 'Define si la operacion es por el instrumento de Transferencia.\nS:Si N:No',
  `EsDocumentos` char(1) DEFAULT NULL COMMENT 'Define si la operacion es por el instrumento de Documentos.\nS:Si N:No',
  `EsCredito` char(1) DEFAULT NULL COMMENT 'Define si la operacion es por el instrumento de Creditos.\nS:Si N:No',
  `TipoOpeCNBV` char(2) DEFAULT NULL COMMENT 'Tipo de Operacion de Acuerdo a Catalogo de CNBV\n01=Depósito\n02=Retiro\n03=Compra Divisas\n04=Venta Divisas\n05=Cheques de Caja\n06=Giros\n07=Ordenes de Pago\n08=Otorgamiento de Crédito\n09=Pago de Crédito\n10=Pago de Primas u Operación de Reaseguro\n11=Aportacione',
  `DepositosMax` decimal(16,2) DEFAULT NULL COMMENT 'Monto Máximo de Abonos y Retiros por Operación.',
  `RetirosMax` decimal(16,2) DEFAULT NULL COMMENT 'Número Máximo de Transacciones',
  `SucursalOrigen` int(5) DEFAULT NULL COMMENT 'No de Sucursal a la que pertenece el cliente, Llave Foranea Hacia Tabla SUCURSALES\n',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
  `SoloNombres` varchar(500) DEFAULT NULL COMMENT 'Primer Nombre, Segundo Nombre y Tercer Nombre',
  `ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del Cliente\n',
  `ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del Cliente\n',
  KEY `INDEX_TEMPPLDOPEINUSALERT_1` (`TipoPersona`,`NivelRiesgo`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal Fisica para la deóteccin de operaciones inusuales.'$$

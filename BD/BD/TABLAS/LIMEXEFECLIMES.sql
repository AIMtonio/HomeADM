-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMEXEFECLIMES
DELIMITER ;
DROP TABLE IF EXISTS `LIMEXEFECLIMES`;
DELIMITER $$


CREATE TABLE `LIMEXEFECLIMES` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `ClienteID` int(11) NOT NULL COMMENT 'ClienteID, llave primaria CLIENTES, forma llave primaria',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `NombreCliente` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo del Cliente',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Persona\n''F'' : Fisica\n''A'' : Fisica con Actividad Empresarial\n''M'': Moral',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucusal donde se origino la Operacion, llave primaria SUCURSALES',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de Cierre Mensual en que se realiza la deteccion',
  `SaldoMes` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Total de la Cuenta',
  `Cargo` decimal(12,2) DEFAULT NULL COMMENT 'Cargo de la Operacion',
  `Abono` decimal(12,2) DEFAULT NULL COMMENT 'Abono de la Operacion',
  `DescripcionOp` varchar(150) DEFAULT NULL COMMENT 'Descripcion del Movimiento',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion de la Operacion, forma llave primaria',
  `LimOrigen` decimal(12,2) DEFAULT NULL COMMENT 'Limite de Operacion que Rebasa para la Deteccion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(50) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ID Programa',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero Transaccion',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Agrupamiento de Operaciones en Efectivo que Rebasan los limites de Acumulado Mensual por Cliente'$$

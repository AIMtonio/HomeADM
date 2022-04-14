-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUM099CREDITOS
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTARESUM099CREDITOS`;DELIMITER $$

CREATE TABLE `EDOCTARESUM099CREDITOS` (
  `AnioMes` int(11) NOT NULL COMMENT 'Anio mes',
  `SucursalID` int(11) NOT NULL COMMENT 'Identificador de la SucursalID',
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del cliente',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Identificador del credito',
  `Producto` varchar(50) NOT NULL COMMENT 'Descripcion del producto de credito',
  `SaldoInsoluto` decimal(14,2) NOT NULL COMMENT 'Saldo insoluto',
  `FechaProxPago` date NOT NULL COMMENT 'Fecha proximo pago',
  `FechaLeyenda` varchar(50) NOT NULL COMMENT 'Fecha leyenda',
  `MontoProximoPago` decimal(12,2) NOT NULL COMMENT 'Monto proximo pago',
  `ValorIvaCred` decimal(14,2) NOT NULL COMMENT 'Valor iva de credito',
  `ValorIVAMora` decimal(14,2) NOT NULL COMMENT 'Valor iva de la mora',
  `ValorIVAAccesorios` decimal(14,2) NOT NULL COMMENT 'Valor iva accesorios',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`AnioMes`,`SucursalID`,`CreditoID`),
  KEY `INDEX_EDOCTARESUM099CREDITOS_1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar informacion de resumen de los creditos del cliente para el estado de cuenta de todos los clientes nuevos '$$
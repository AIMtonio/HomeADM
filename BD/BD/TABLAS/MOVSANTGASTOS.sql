-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MOVSANTGASTOS
DELIMITER ;
DROP TABLE IF EXISTS `MOVSANTGASTOS`;DELIMITER $$

CREATE TABLE `MOVSANTGASTOS` (
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal en donde se registra la operacion',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Caja que realiza la operacion',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en que se realiza la operacion',
  `MontoOpe` decimal(14,2) DEFAULT NULL COMMENT 'monto de la operacion',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'si es cheque o efectivo',
  `TipoOperacion` int(11) DEFAULT NULL COMMENT 'el tipo de gasto',
  `Naturaleza` char(1) DEFAULT NULL COMMENT 'Entrada o Salida',
  `EmpleadoID` int(11) DEFAULT NULL COMMENT 'ID del Empleado en caso de requerir',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'parametro de auditoria',
  KEY `fk_MOVSANTGASTOS_1_idx` (`TipoOperacion`),
  CONSTRAINT `fk_MOVSANTGASTOS_1` FOREIGN KEY (`TipoOperacion`) REFERENCES `TIPOSANTGASTOS` (`TipoAntGastoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar movimientos de Anticipos y gastos '$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURMONTOS
DELIMITER ;
DROP TABLE IF EXISTS `PRESUCURMONTOS`;DELIMITER $$

CREATE TABLE `PRESUCURMONTOS` (
  `PresupuestoID` int(11) NOT NULL COMMENT 'ID del presupuesto',
  `EncabezadoID` int(11) DEFAULT NULL COMMENT 'ID del encabezado o folio',
  `MontoSoli` decimal(18,2) DEFAULT NULL COMMENT 'Monto total solicitado',
  `MontoAuto` decimal(18,2) DEFAULT NULL COMMENT 'Monto Total Autorizado\n',
  `MontoPendi` decimal(18,2) DEFAULT NULL COMMENT 'Monto total pendiente',
  `SucursalOrigen` varchar(50) DEFAULT NULL,
  `MontoAutorizado` decimal(19,2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` varchar(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PresupuestoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene los Montos Totales Solicitados, Autorizados y pendi'$$
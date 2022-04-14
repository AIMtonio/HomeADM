-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRTIPMOVCARGOABONO
DELIMITER ;
DROP TABLE IF EXISTS `ARRTIPMOVCARGOABONO`;DELIMITER $$

CREATE TABLE `ARRTIPMOVCARGOABONO` (
  `TipMovCargoAbonoID` int(11) NOT NULL COMMENT 'ID del movimiento del cargo o abono del arrendamiento',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del tipo de Movimiento',
  `ColumArrendaAmorti` varchar(20) NOT NULL COMMENT 'Indica  el nombre de la columna de la tabla de ARRENDAAMORTI a la que se afectara al hacer un cargo o abono',
  `EmpresaID` int(11) NOT NULL COMMENT 'Id de la empresa (auditoria)',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario (auditoria)',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha atual del sistema(auditoria)',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP(auditoria)',
  `ProgramaID` varchar(20) NOT NULL COMMENT 'Id del programa que graba(auditoria)',
  `Sucursal` int(11) NOT NULL COMMENT 'Id de la sucursal(auditoria)',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion(auditoria)',
  PRIMARY KEY (`TipMovCargoAbonoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de catalogo de los movimientos de cargo o abono para arrendamiento. Los registros de esta tabla deberan existir en la tabla de CONCEPTOSARRENDA'$$
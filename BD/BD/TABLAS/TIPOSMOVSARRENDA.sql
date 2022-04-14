-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVSARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSMOVSARRENDA`;DELIMITER $$

CREATE TABLE `TIPOSMOVSARRENDA` (
  `TipoMovArrendaID` int(4) NOT NULL COMMENT 'ID del movimiento de arrendamiento',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del tipo de Movimiento',
  `PrealacionPago` int(2) NOT NULL COMMENT 'Orden o Prelacion de Pago',
  `EmpresaID` int(11) NOT NULL COMMENT 'Id de la empresa (auditoria)',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario (auditoria)',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha atual del sistema(auditoria)',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Dirección IP(auditoria)',
  `ProgramaID` varchar(20) NOT NULL COMMENT 'Id del programa que graba(auditoria)',
  `Sucursal` int(11) NOT NULL COMMENT 'Id de la sucursal(auditoria)',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de transacción(auditoria)',
  PRIMARY KEY (`TipoMovArrendaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de catalogo de los movimientos para arrendamiento'$$
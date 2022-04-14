-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXMODOENTRADA
DELIMITER ;
DROP TABLE IF EXISTS `ISOTRXMODOENTRADA`;
DELIMITER $$


CREATE TABLE `ISOTRXMODOENTRADA` (
  `ModoEntradaID` int(11) NOT NULL COMMENT 'Indica el modo de entrada',
  `Descripcion` varchar(250) DEFAULT NULL COMMENT 'Descripcion del modo de entrada',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ModoEntradaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo para el modo de entrada'$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- WSAUDITORIADEFAULT
DELIMITER ;
DROP TABLE IF EXISTS `WSAUDITORIADEFAULT`;
DELIMITER $$


CREATE TABLE `WSAUDITORIADEFAULT` (
  `WSAudID` int(11) NOT NULL COMMENT 'Numero de Usuario',
  `DefUsuarioID` int(11) NOT NULL COMMENT 'ID Usuario Default',
  `DefEmpresaID` varchar(10) DEFAULT NULL COMMENT 'ID Empresa Default ',
  `DefSucursalID` varchar(10) DEFAULT NULL COMMENT 'ID Sucusal Default',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Llave Foranea Hacia Paquete Empresa\n',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` int(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`WSAudID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para Manejo de Parametros de Auditoria de WS'$$

-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAHUELLA
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAHUELLA`;DELIMITER $$

CREATE TABLE `BITACORAHUELLA` (
  `NumeroTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion\n de Operación en\n Ventanilla',
  `Fecha` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de la transaccion',
  `TipoOperacion` int(11) DEFAULT NULL COMMENT 'Tipo de Operación\nV .- Operación de Ventanilla\nB .- Operación de BackOffice',
  `DescriOperacion` varchar(200) DEFAULT NULL COMMENT 'Descripcion o Nombre de la \nOperacion Realizada\n',
  `TipoUsuario` char(1) DEFAULT NULL COMMENT 'Tipo : Usuario = U\n           Cliente = C',
  `ClienteUsuario` int(11) DEFAULT NULL COMMENT 'ID del Cliente o Usuario',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Id de la Caja',
  `SucursalOperacion` int(11) DEFAULT NULL COMMENT 'ID de la Sucursal',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`Fecha`,`NumeroTransaccion`),
  KEY `Index_1` (`Fecha`,`ClienteUsuario`,`TipoUsuario`,`SucursalOperacion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACRCBCARGOABONO
DELIMITER ;
DROP TABLE IF EXISTS `BITACORACRCBCARGOABONO`;DELIMITER $$

CREATE TABLE `BITACORACRCBCARGOABONO` (
  `BitacoraID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la Bitacora',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de la transaccion',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Numero de la cuenta, ID de la tabla CUENTASAHO',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto a abonar',
  `NumeroError` int(11) NOT NULL COMMENT 'Numero de Error',
  `MensajeError` varchar(400) NOT NULL COMMENT 'Descripcion del Error',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  `Par_EmpresaID` int(11) NOT NULL COMMENT 'EmpresaID',
  `Aud_Usuario` int(11) NOT NULL COMMENT 'Usuario ID',
  `Aud_FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `Aud_DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `Aud_ProgramaID` varchar(50) NOT NULL COMMENT 'Nombre de programa',
  `Aud_Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID ',
  `Aud_NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  PRIMARY KEY (`BitacoraID`),
  KEY `CuentaAhoID` (`CuentaAhoID`),
  KEY `Fecha` (`Fecha`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Tab: Almacena los errores de abonos y retiros mediante ws.'$$
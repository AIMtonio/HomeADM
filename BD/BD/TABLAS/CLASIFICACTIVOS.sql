-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICACTIVOS
DELIMITER ;
DROP TABLE IF EXISTS `CLASIFICACTIVOS`;DELIMITER $$

CREATE TABLE `CLASIFICACTIVOS` (
  `ClasificaActivoID` int(11) NOT NULL COMMENT 'Idetinficador de la clasificacion del activo',
  `Descripcion` varchar(300) NOT NULL COMMENT 'Descripcion del el tipo de clasificacion del activo',
  `Estatus` char(1) NOT NULL COMMENT 'Indica el estatus de la clasificacion del tipo de activo, este puede 	ser A=ACTIVO o I=INACTIVO',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`ClasificaActivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacacena las clasificaciones de activos'$$
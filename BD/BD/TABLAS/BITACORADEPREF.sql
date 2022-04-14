-- BITACORADEPREF
DELIMITER ;
DROP TABLE IF EXISTS `BITACORADEPREF`;
DELIMITER $$

CREATE TABLE `BITACORADEPREF` (
  `BitacoraID` bigint(20) NOT NULL COMMENT 'Identificador de la bitacora',
  `NumTransaccionCarga` bigint(20) NOT NULL COMMENT 'Numero de Transaccion de Carga.',
  `FolioCargaID` bigint(20) NOT NULL COMMENT 'Folio unico de Carga de Archivo a Conciliar.',
  `NumErr` int(11) NOT NULL COMMENT 'Numero de error',
  `ErrMen` varchar(400) NOT NULL COMMENT 'Mensaje de error',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`BitacoraID`),
  KEY `IDX_BITACORADEPREF_1` (`NumTransaccionCarga`,`FolioCargaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar la bitacora de aplicacion de depositos referenciados.'$$
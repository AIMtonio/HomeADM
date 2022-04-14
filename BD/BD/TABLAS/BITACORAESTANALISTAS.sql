DELIMITER ;
DROP TABLE IF EXISTS BITACORAESTANALISTAS;
DELIMITER $$
CREATE TABLE `BITACORAESTANALISTAS`(
  `BitacoraUsuarioID` bigint(20) NOT NULL COMMENT 'Id de la tabla ',
  `UsuarioID` int(11)  NOT NULL COMMENT 'Id del Usuario analista de credito',
  `FechaEstatus` datetime(1) DEFAULT NULL COMMENT 'Fecha en que se modifica el Estatus',
  `Estatus` char(1)  DEFAULT NULL COMMENT 'Estatus del usuario en el perfil analista \nA.- activo \nI.- inactivo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`BitacoraUsuarioID`,`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar los registros del Estatus Usuarios Analistas. '$$


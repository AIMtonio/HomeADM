DELIMITER ;
DROP TABLE IF EXISTS BITACORAACCESANALISTA;
DELIMITER $$
CREATE TABLE `BITACORAACCESANALISTA`(
  `BitacoraAccesAID` bigint(20) NOT NULL COMMENT 'Id de la bitacora de acceso Analista ',
  `UsuarioID` int(11) NOT NULL COMMENT 'Id del usuario que actualiza el estatus',
  `Estatus` char(1) NOT NULL  COMMENT 'Estatus de usuario analista \nA .- activo \nI.- Inactivo',
  `HoraActualizacion` time NOT NULL COMMENT 'Hora en que se actualiza el estatus del usuario analista',
  `Fecha` date NOT NULL COMMENT 'Fecha de cambio de estatus',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Llave Foranea Hacia Paquete Empresa\n',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` int(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`BitacoraAccesAID`,`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para bitacora de acceso al sistema de usuario Analista de Credito. '$$


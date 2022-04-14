-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- JUSTIFPTRANSPLD
DELIMITER ;
DROP TABLE IF EXISTS `JUSTIFPTRANSPLD`;DELIMITER $$

CREATE TABLE `JUSTIFPTRANSPLD` (
  `JustificacionID` char(2) NOT NULL COMMENT 'clave del jsutificacion del perfil transaccional del cliente',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'descripcion del tipo de  organismo',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`JustificacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='catalogo de justificaciones del perfil transaccional	'$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISANALISTASASIG


DELIMITER ;
DROP TABLE IF EXISTS HISANALISTASASIG;
DELIMITER $$
CREATE TABLE `HISANALISTASASIG` (
  `HisAnalistasAsigID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Id del historico ',
  `AnalistasAsigID` bigint(20) NOT NULL COMMENT 'iD de la tabla ANALISTASASIGNACION',
  `UsuarioID` int(11)  NOT NULL COMMENT 'Id del usuario analista de credito',
  `TipoAsignacionID` INT(11) NOT NULL COMMENT 'Id Tipo de asignacion de solicitud de credito',
  `ProductoID` int(11)  NOT NULL DEFAULT '0' COMMENT 'Id Producto de credito',
  `FechaAsignacion` datetime DEFAULT NULL COMMENT 'Fecha en que se agrega el tipo de asignacion al analista',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`HisAnalistasAsigID`),
  KEY `INDEX_HISANALISTASASIG_1` (`TipoAsignacionID`),
  KEY `INDEX_HISANALISTASASIG_2` (`UsuarioID`),
  KEY `INDEX_HISANALISTASASIG_3` (`ProductoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico para almacenar los registros de asignacion de Analistas '$$



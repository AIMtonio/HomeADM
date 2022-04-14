-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPERFILESANALISTAS
DELIMITER ;
DROP TABLE IF EXISTS `HISPERFILESANALISTAS`;
DELIMITER $$


-- Creacion de la tabla Historico Perfilanalistas
CREATE TABLE `HISPERFILESANALISTAS` (
  `HisPerfilID` bigint(20) NOT NULL AUTO_INCREMENT  COMMENT 'Id del historico ', 
  `PerfilID` int(11) NOT NULL COMMENT 'Numero de Perfil',
  `RolID` int(11) DEFAULT NULL COMMENT 'Rol o Perfil del Usuario',
  `TipoPerfil` char(1) DEFAULT NULL COMMENT 'Tipo de perfil\nA .- Analista\nE .- Ejecutivo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`HisPerfilID`),
  KEY `INDEX_HISPERFILESANALISTAS_1` (`RolID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para el historico de Perfiles de Analistas de Credito'$$
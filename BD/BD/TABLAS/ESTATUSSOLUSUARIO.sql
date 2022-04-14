-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTATUSSOLUSUARIO
DELIMITER ;
DROP TABLE IF EXISTS `ESTATUSSOLUSUARIO`;DELIMITER $$

CREATE TABLE `ESTATUSSOLUSUARIO` (
  `Transaccion` bigint(20) DEFAULT NULL,
  `TipoEstatus` char(2) DEFAULT NULL,
  `TotalEstatus` int(11) DEFAULT NULL,
  `Orden` int(11) DEFAULT NULL,
  `UsuarioConsulta` int(11) NOT NULL COMMENT 'Usuario que realiza la consulta	',
  KEY `ESTATUSSOLUSUARIO_idx1` (`Transaccion`),
  KEY `ESTATUSSOLUSUARIO_idx2` (`TipoEstatus`),
  KEY `ESTATUSSOLUSUARIO_idx3` (`UsuarioConsulta`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
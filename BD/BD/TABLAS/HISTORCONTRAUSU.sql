-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISTORCONTRAUSU
DELIMITER ;
DROP TABLE IF EXISTS `HISTORCONTRAUSU`;DELIMITER $$

CREATE TABLE `HISTORCONTRAUSU` (
  `UsuarioID` int(11) NOT NULL,
  `Contrasenia` varchar(45) NOT NULL,
  `Empresa` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MENUSAPLICACION
DELIMITER ;
DROP TABLE IF EXISTS `MENUSAPLICACION`;DELIMITER $$

CREATE TABLE `MENUSAPLICACION` (
  `MenuID` int(11) NOT NULL COMMENT 'Numero o ID\ndel MENU',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Id Empresa',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion del\nMenu o Modulo',
  `Desplegado` varchar(45) NOT NULL COMMENT 'Desplegado o\nLeyanda a \nMostrar',
  `Orden` int(11) NOT NULL COMMENT 'Orden de Vista\ndel Menu',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`MenuID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Menus de la Aplicacion'$$
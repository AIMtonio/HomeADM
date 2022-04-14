-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOCONDICREDI
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOCONDICREDI`;DELIMITER $$

CREATE TABLE `SEGTOCONDICREDI` (
  `CondicionID` int(11) NOT NULL COMMENT 'Identificador de la Condicion	',
  `Descripcion` varchar(45) DEFAULT NULL COMMENT 'Descripcion de la condicion',
  `Estatus` varchar(45) DEFAULT NULL COMMENT 'Estatus de la Condicion V.-Vigente C.-Cancelado',
  `Empresa` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CondicionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Condiciones de Credito para pantalla de Seguimie'$$
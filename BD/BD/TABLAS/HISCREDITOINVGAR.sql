-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCREDITOINVGAR
DELIMITER ;
DROP TABLE IF EXISTS `HISCREDITOINVGAR`;
DELIMITER $$


CREATE TABLE `HISCREDITOINVGAR` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en que se da de baja el registro',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito relacionado',
  `InversionID` int(11) NOT NULL COMMENT 'Inversion usada como Garantia para el credito',
  `MontoEnGar` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la inversion que se esta dejando como garantia',
  `FechaAsignaGar` date DEFAULT NULL COMMENT 'Fecha en que se asigna la Garantia',
  `UsuarioAgrego` int(11) DEFAULT NULL COMMENT 'Usuario que Agrego la inversion como garantia .',
  `UsuarioElimina` int(11) NOT NULL COMMENT 'Usuario que elimina la liga de la inversion con el credito',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_HISCREDITOINVGAR_1_idx` (`CreditoID`,`InversionID`),
  KEY `fk_HISCREDITOINVGAR_2_idx` (`UsuarioElimina`),
  KEY `fk_HISCREDITOINVGAR_1_idx1` (`UsuarioAgrego`),
  CONSTRAINT `fk_HISCREDITOINVGAR_1` FOREIGN KEY (`UsuarioAgrego`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISCREDITOINVGAR_2` FOREIGN KEY (`UsuarioElimina`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='historico de asignaciones de inversiones a un credito'$$

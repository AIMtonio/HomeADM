-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONXPROMOTOR
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOADMONXPROMOTOR`;DELIMITER $$

CREATE TABLE `SEGTOADMONXPROMOTOR` (
  `GestorID` int(11) NOT NULL COMMENT 'Id del Gestor al que se le asignara un Ambito',
  `TipoGestionID` int(11) NOT NULL COMMENT 'Tipo de Gestor al que pertenece el Ambito',
  `PromotorID` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GestorID`,`TipoGestionID`,`PromotorID`),
  KEY `fk_SEGTOADMONXPROMOTOR_1_idx` (`GestorID`),
  KEY `fk_SEGTOADMONXPROMOTOR_2_idx` (`TipoGestionID`),
  KEY `fk_SEGTOADMONXPROMOTOR_3_idx` (`PromotorID`),
  CONSTRAINT `fk_Idx_TipoGestionID` FOREIGN KEY (`TipoGestionID`) REFERENCES `TIPOGESTION` (`TipoGestionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SEGTOADMONXPROMOTOR_1` FOREIGN KEY (`GestorID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SEGTOADMONXPROMOTOR_3` FOREIGN KEY (`PromotorID`) REFERENCES `PROMOTORES` (`PromotorID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar informacion de Gestores por Promotor'$$
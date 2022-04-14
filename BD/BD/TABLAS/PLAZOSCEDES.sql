-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSCEDES
DELIMITER ;
DROP TABLE IF EXISTS `PLAZOSCEDES`;DELIMITER $$

CREATE TABLE `PLAZOSCEDES` (
  `TipoCedeID` int(11) NOT NULL COMMENT 'Tipo de Cede',
  `PlazoInferior` int(11) NOT NULL COMMENT 'Plazo Inferior ',
  `PlazoSuperior` int(11) NOT NULL COMMENT 'Plazo Superior',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoCedeID`,`PlazoInferior`,`PlazoSuperior`),
  CONSTRAINT `fk_PLAZOSCEDES_1` FOREIGN KEY (`TipoCedeID`) REFERENCES `TIPOSCEDES` (`TipoCedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena el esquema de plazos para las cedes.'$$
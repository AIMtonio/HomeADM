-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOSCEDES
DELIMITER ;
DROP TABLE IF EXISTS `MONTOSCEDES`;DELIMITER $$

CREATE TABLE `MONTOSCEDES` (
  `TipoCedeID` int(11) NOT NULL COMMENT 'PK Tipo de CEDE',
  `MontoInferior` decimal(18,2) NOT NULL COMMENT 'PK Monto inferior ',
  `MontoSuperior` decimal(18,2) NOT NULL COMMENT 'PK Monto superior',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoCedeID`,`MontoInferior`,`MontoSuperior`),
  CONSTRAINT `fk_MONTOSCEDES_1` FOREIGN KEY (`TipoCedeID`) REFERENCES `TIPOSCEDES` (`TipoCedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena el esquema de montos para las cedes.'$$
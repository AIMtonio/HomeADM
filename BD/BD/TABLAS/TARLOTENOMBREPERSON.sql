-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGOPATROCINADOR
DELIMITER ;
DROP TABLE IF EXISTS `TARLOTENOMBREPERSON`;
DELIMITER $$

CREATE TABLE `TARLOTENOMBREPERSON` (

  `NombrePerID` 	    INT(11) NOT NULL COMMENT'Identificador del nombre',
  `LoteDebID` 			INT(11) NOT NULL COMMENT'Identificador del Lote',
  `NombrePerso`   		VARCHAR(21) DEFAULT NULL COMMENT 'Nombre del cliente personalizado',
  `EmpresaID`      		INT(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario`        		INT(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual`    		DATETIME DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP`    		VARCHAR(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID`     		VARCHAR(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal`       		INT(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` 		BIGINT(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`NombrePerID`)

) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Nombre personalizado para las tarjetas'$$

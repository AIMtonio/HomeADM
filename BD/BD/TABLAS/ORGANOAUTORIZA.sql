-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANOAUTORIZA
DELIMITER ;
DROP TABLE IF EXISTS `ORGANOAUTORIZA`;DELIMITER $$

CREATE TABLE `ORGANOAUTORIZA` (
  `EsquemaID` int(11) NOT NULL COMMENT 'Llave Foranea hacia el Catalogo de Esquema de Autorizacion',
  `NumFirma` int(11) NOT NULL COMMENT 'Numero de de la Firma Requerida',
  `OrganoID` int(11) NOT NULL COMMENT 'Llave Foranea hacia el Catalogo de Organos de Desicion \nQue indica quien puede otorgar el numero de Firma indicado',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria',
  KEY `idx_ORGANOAUTORIZA_1` (`EsquemaID`,`NumFirma`),
  KEY `fk_ORGANOAUTORIZA_1` (`OrganoID`),
  CONSTRAINT `fk_ORGANOAUTORIZA_1` FOREIGN KEY (`OrganoID`) REFERENCES `ORGANODESICION` (`OrganoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Firmas Requeridas por cada esquema de Autorizacion con los O'$$
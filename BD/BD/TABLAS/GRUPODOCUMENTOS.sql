-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPODOCUMENTOS
DELIMITER ;
DROP TABLE IF EXISTS `GRUPODOCUMENTOS`;DELIMITER $$

CREATE TABLE `GRUPODOCUMENTOS` (
  `GrupoDocumentoID` int(11) NOT NULL COMMENT 'id de la tabla',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripción del Grupo ej. Identificación, Comprobante de Ingresos',
  `RequeridoEn` varchar(50) DEFAULT NULL COMMENT 'indica  en que proceso se va a solicitar el grupo de Documentos ejemplo en el CheckList del Cliente, ETC.',
  `TipoPersona` varchar(10) DEFAULT NULL COMMENT 'Indica para el tipo de persona que será valido dicho Grupo de Documento ejemplo: Personas Morales, Físicas, Etc',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`GrupoDocumentoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
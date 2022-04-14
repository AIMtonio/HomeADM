-- CHECKLISTREMESASWS
DELIMITER ;
DROP TABLE IF EXISTS `CHECKLISTREMESASWS`;
DELIMITER $$

CREATE TABLE `CHECKLISTREMESASWS` (
  `CheckListRemWSID` bigint(20) NOT NULL COMMENT 'Numero Identificador de la tabla',
  `RemesaWSID` bigint(20) NOT NULL COMMENT 'Numero Identificador de la tabla REMESASWS ',
  `NumeroID` int(11) NOT NULL COMMENT 'Indica el identificador del tipo de documento',
  `Archivo` varchar(1000) NOT NULL COMMENT 'Indica el Documento a cargar',
  `Descripcion` varchar(200) NOT NULL DEFAULT '' COMMENT 'Indica la Descripcion del Documento a cargar',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`CheckListRemWSID`),
  KEY `FK_CHECKLISTREMESASWS_1` (`RemesaWSID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab:Tabla detalle para almacenar los documentos que conformarán el check list.'$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPORTESXMLTAG
DELIMITER ;
DROP TABLE IF EXISTS `REPORTESXMLTAG`;
DELIMITER $$

CREATE TABLE `REPORTESXMLTAG` (
  `EtiquetaID` int(11) NOT NULL COMMENT 'ID Etiqueta',
  `ReporteID` int(11) NOT NULL COMMENT 'Numero de Reporte ID corresponde a la tabla REPORTESXML',
  `Etiqueta` varchar(45) NOT NULL COMMENT 'Nombre de la etiqueta (tal cual se va mostrar en el xml)',
  `Descripcion` varchar(45) DEFAULT NULL COMMENT 'Descripcion de la etiqueta',
  `Orden` int(11) NOT NULL COMMENT 'Orden',
  `Tipo` int(11) NOT NULL COMMENT '1: Etiqueta\n2: TEXT\n3:Numeric',
  `Nivel` int(11) NOT NULL COMMENT '1: Raiz \n2: HijaRaiz \n3: Principal \n 4 Etiqueta 5 Etiqueta Hija',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`EtiquetaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Etiquetas para el reporte de XML'$$
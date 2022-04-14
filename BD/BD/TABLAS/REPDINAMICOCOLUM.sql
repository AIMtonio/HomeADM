-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPDINAMICOCOLUM
DELIMITER ;
DROP TABLE IF EXISTS `REPDINAMICOCOLUM`;
DELIMITER $$
CREATE TABLE `REPDINAMICOCOLUM` (
  `ReporteID` int(11) NOT NULL COMMENT 'Numero de reporte',
  `Orden` int(11) NOT NULL COMMENT 'Orden',
  `NombreColumna` varchar(45) NOT NULL COMMENT 'Nombre de la columna que se va mostrar en el reporte',
  `Tipo` int(11) NOT NULL COMMENT 'Tipo de Dato 1: Entero 2: Varchar 3: Decimal 4: Fecha',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ReporteID`,`Orden`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Que contiene las columnas para los reportes.'$$
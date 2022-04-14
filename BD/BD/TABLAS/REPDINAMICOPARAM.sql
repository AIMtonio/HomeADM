-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPDINAMICOPARAM
DELIMITER ;
DROP TABLE IF EXISTS `REPDINAMICOPARAM`;
DELIMITER $$
CREATE TABLE `REPDINAMICOPARAM` (
  `ReporteID` int(11) NOT NULL COMMENT 'Numero ID del Reporte',
  `Orden` int(11) NOT NULL COMMENT 'Orden en el que esta en el SP',
  `NombreParametro` varchar(45) NOT NULL COMMENT 'Nombre del Parametro',
  `Tipo` int(11) NOT NULL DEFAULT '2' COMMENT '1: Entero\\n2: Varchar\\n3: Decimal 4: Fecha',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ReporteID`,`Orden`),
  CONSTRAINT `fk_REPDINAMICOPARAM_1` FOREIGN KEY (`ReporteID`) REFERENCES `REPORTEDINAMICO` (`ReporteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla: Tabla con los parametros de la llamada al store'$$
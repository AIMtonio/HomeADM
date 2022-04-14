-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPORTEDINAMICO
DELIMITER ;
DROP TABLE IF EXISTS `REPORTEDINAMICO`;
DELIMITER $$
CREATE TABLE `REPORTEDINAMICO` (
  `ReporteID` int(11) NOT NULL COMMENT 'ID Del reporte',
  `TituloReporte` varchar(100) NOT NULL COMMENT 'Nombre del reporte',
  `NombreArchivo` varchar(45) NOT NULL COMMENT 'Nombre del Archivo ejemplo RepPersonasJuridicas',
  `NombreSP` varchar(29) NOT NULL COMMENT 'Nombre del SP que trae la informacion del reporte.',
  `NombreHoja` varchar(45) NOT NULL COMMENT 'Nombre de la hoja de excel sin espacion sin guiones solo guiones bajos y letras',
  `Vista` varchar(50) NOT NULL COMMENT 'Ruta de la vista ejemplo cliente/clienteRep, este es el archivo JSP que debe existir en el SAFI',
  `RutaPRPT` varchar(100) DEFAULT NULL COMMENT 'Ruta del PRPT',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ReporteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla: Tabla de parametrización de los reportes dinámicos del SAFI'$$
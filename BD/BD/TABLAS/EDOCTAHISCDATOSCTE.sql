-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHISCDATOSCTE
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAHISCDATOSCTE`;
DELIMITER $$

CREATE TABLE `EDOCTAHISCDATOSCTE` (
  `Periodo` int(11) NOT NULL COMMENT 'Periodo definido por año y mes en que se generarón  el reporte de timbrado',
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de Sucursal del Cliente\n',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero identificador  de Cliente',
  `NombreComple` varchar(170) DEFAULT NULL COMMENT 'Nombre Completo del Cliente',
  `RFC` varchar(13) DEFAULT NULL COMMENT 'Clave del RFC correspondiente al contribuyente recptor del timbre.',
  `CFDIUUID` varchar(50) DEFAULT NULL COMMENT 'Folio fiscal del timbre\n\n',
  `CFDIFechaTimbrado` varchar(50) DEFAULT NULL COMMENT 'Fecha de Timbrado para Ingresos\n',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus Timbrado Ingresos:\n1 = No Procesada\n2 = Procesada\n3 = Error al Procesar',
  `CFDITotal` varchar(25) DEFAULT NULL COMMENT 'Cantidad monetaria total timbrada',
  `ProductoCredID` int(11) NOT NULL,
  `CreditoID` bigint(12) NOT NULL,
  `PDFGenerado` char(1) DEFAULT 'N' COMMENT 'N= PDF no Generado\nS= PDF Generado Antes del Timbrado\nD= PDF Generado Despues del Timbrado',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Periodo`,`SucursalID`,`ClienteID`,`ProductoCredID`,`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para guardar informacion de la tabla EDOCTADATOSCTE.'$$

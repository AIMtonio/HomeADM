-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZASCANCELADAS
DELIMITER ;
DROP TABLE IF EXISTS `POLIZASCANCELADAS`;DELIMITER $$

CREATE TABLE `POLIZASCANCELADAS` (
  `Consecutivo` bigint(20) NOT NULL COMMENT 'Numero Consecutivo ',
  `PolizaID` bigint(20) NOT NULL COMMENT 'Numero de Poliza',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa',
  `Fecha` date NOT NULL COMMENT 'Fecha de la \nAfectacion',
  `Tipo` char(1) NOT NULL COMMENT 'Tipo de Poliza:\nManual  .- M\nAutomatica .- A\nProgramada .- P',
  `ConceptoID` int(11) DEFAULT NULL COMMENT 'Corresponde a algun ID de la tabla CONCEPTOSCONTA',
  `Concepto` varchar(150) NOT NULL COMMENT 'Concepto o \nDescripcion de la\nPoliza',
  `NumErr` int(11) NOT NULL COMMENT 'Numero de error',
  `ErrMen` varchar(400) DEFAULT NULL COMMENT 'Mensaje de Error',
  `DescProceso` varchar(400) DEFAULT NULL COMMENT 'Descripcion del proceso que realizo la poliza',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`PolizaID`,`Fecha`,`Consecutivo`),
  KEY `IDXFechaAplicacion` (`Fecha`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Polizas Contables Canceladas por no contener detalles.'$$
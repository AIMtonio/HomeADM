-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMBITACOESTEMP
DELIMITER ;
DROP TABLE IF EXISTS `NOMBITACOESTEMP`;
DELIMITER $$


CREATE TABLE `NOMBITACOESTEMP` (
  `InstitNominaID` int(11) NOT NULL COMMENT 'Institucion de Nomina ID',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente ID',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de Actualizacion',
  `EstatusAnterior` char(1) DEFAULT NULL COMMENT 'Estatus Anterios del empleado',
  `EstatusNuevo` char(1) DEFAULT NULL COMMENT 'Estatus nuevo del empleado de nomina',
  `FechaInicioIncapacidad` date DEFAULT NULL COMMENT 'Fecha de Inicio de Incapacidad',
  `FechaFinIncapacidad` date DEFAULT NULL COMMENT 'Fecha de Fin de Incapacidad',
  `FechaBaja` date DEFAULT NULL COMMENT 'Fecha de Baja del Empleado',
  `MotivoBaja` varchar(50) DEFAULT NULL COMMENT 'Motivo de la baja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bitacora de Cambios Estatus Empleado'$$
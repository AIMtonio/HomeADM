-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMINAEMPLEADOS
DELIMITER ;
DROP TABLE IF EXISTS `NOMINAEMPLEADOS`;
DELIMITER $$


CREATE TABLE `NOMINAEMPLEADOS` (
  `NominaEmpleadoID` int(11) NOT NULL COMMENT 'Identificador de la tabla',
  `InstitNominaID` int(11) NOT NULL COMMENT 'ID de la institucion de Nomina',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del Cliente, puede ser vacio si viene un prospecto',
  `ProspectoID` bigint(20) DEFAULT NULL COMMENT 'ID del prospecto, puede ser vacio si viene un cliente ',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del empleado\nA- Activo\nI- Incapacidad',
  `ConvenioNominaID` bigint unsigned DEFAULT NULL COMMENT 'ID del Convenio de Nomina (Une con tabla CONVENIOSNOMINA)',
  `TipoEmpleadoID` int(11) DEFAULT NULL COMMENT 'Identificador del Tipo de Empleado de la tabla CATTIPOEMPLEADOS',
  `TipoPuestoID` int(11) NOT NULL COMMENT 'ID del Tipo de Puesto del Empleado (Une con tabla TIPOSPUESTOS)',
  `NoEmpleado` varchar(30) DEFAULT NULL COMMENT 'Numero de Empleado en su Empresa de Nomina',
  `QuinquenioID` INT(11) DEFAULT NULL COMMENT 'Quinquenio',
  `CentroAdscripcion` varchar(100) DEFAULT NULL COMMENT 'Centro de Adscripcion',
  `FechaIngreso` date DEFAULT NULL COMMENT 'Fecha de ingreso',
  `FechaInicioInca` date DEFAULT NULL COMMENT 'Fecha de inicio de Incapacidad',
  `FechaFinInca` date DEFAULT NULL COMMENT 'Fecha fin de la incapacidad',
  `FechaBaja` date DEFAULT NULL COMMENT 'Fecha de baja del empleado',
  `MotivoBaja` varchar(200) DEFAULT NULL COMMENT 'Motivo de baja del empleado',
  `NoPension` varchar(25) NOT NULL COMMENT 'Numero de Pension',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`NominaEmpleadoID`),
  KEY `INDEX_InstitNomina` (`InstitNominaID`),
  KEY `FK_NOMINAEMPLEADOS_2_idx` (`TipoPuestoID`),
  KEY `INDEX_NOMINAEMPLEADOS_1` (`TipoEmpleadoID`),
  KEY `INDEX_NOMINAEMPLEADOS_2` (`ClienteID`),
  KEY `INDEX_NOMINAEMPLEADOS_03` (`Estatus`),
  KEY `FK_NOMINAEMPLEADOS_1_idx` (`ConvenioNominaID`),
  CONSTRAINT `FK_NOMINAEMPLEADOS_1` FOREIGN KEY (`ConvenioNominaID`) REFERENCES `CONVENIOSNOMINA` (`ConvenioNominaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_NOMINAEMPLEADOS_2` FOREIGN KEY (`TipoPuestoID`) REFERENCES `TIPOSPUESTOS` (`TipoPuestoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `INDEX_InstitNomina` FOREIGN KEY (`InstitNominaID`) REFERENCES `INSTITNOMINA` (`InstitNominaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Relacion de los empleados de la institucion de nomina'$$

-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EMPLEADOS
DELIMITER ;
DROP TABLE IF EXISTS `EMPLEADOS`;DELIMITER $$

CREATE TABLE `EMPLEADOS` (
  `EmpleadoID` bigint(20) NOT NULL COMMENT 'ID o clave del Empleado',
  `ClavePuestoID` varchar(10) DEFAULT NULL COMMENT 'ID o clave del Puesto',
  `ApellidoPat` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del Empleado',
  `ApellidoMat` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del Empleado',
  `PrimerNombre` varchar(50) DEFAULT NULL COMMENT 'Primer Nombre del Empleado',
  `SegundoNombre` varchar(50) DEFAULT NULL COMMENT 'Segundo Nombre del Empleado (opcional)',
  `FechaNac` date DEFAULT NULL COMMENT 'Fecha de Nacimiento del Empleado',
  `Nacionalidad` char(1) DEFAULT NULL COMMENT 'Nacionalidad del Empleado\n''N'' = Nacional\n''E'' = Extranjero\n',
  `LugarNacimiento` int(11) DEFAULT NULL COMMENT 'Pais de Nacimiento del Empleado',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Estado de Nacimiento del Empleado',
  `Sexo` char(1) DEFAULT NULL COMMENT 'Genero del Empleado\nClave Sexo:\n''M'' = Masculino\n''F''  = Femenino',
  `CURP` char(18) DEFAULT NULL COMMENT 'Clave Unica de Registro Poblacional\n',
  `RFC` varchar(13) DEFAULT NULL COMMENT 'RFC del Empleado',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo del empleado',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal que atiende o a la que pertenece el empleado',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estado del Empleado\nA: Activo\nI: Inactivo',
  `FechaAlta` date DEFAULT NULL COMMENT 'Fecha de Alta del Empleado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`EmpleadoID`),
  KEY `fk_EMPLEADOS_1` (`ClavePuestoID`),
  KEY `fk_EMPLEADOS_2` (`SucursalID`),
  CONSTRAINT `fk_EMPLEADOS_1` FOREIGN KEY (`ClavePuestoID`) REFERENCES `PUESTOS` (`ClavePuestoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Empleados de la Empresa'$$
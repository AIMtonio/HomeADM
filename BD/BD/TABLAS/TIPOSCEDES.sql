-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCEDES
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSCEDES`;
DELIMITER $$


CREATE TABLE `TIPOSCEDES` (
  `TipoCedeID` int(11) NOT NULL COMMENT 'Tipo de Cede ID',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion ',
  `FechaCreacion` date DEFAULT NULL COMMENT 'Fecha de Creacion ',
  `TasaFV` char(1) DEFAULT NULL COMMENT 'Tasa Fija o Variable ',
  `Anclaje` char(1) DEFAULT NULL COMMENT 'Se realiza anclaje S= Si N=No',
  `TasaMejorada` char(1) DEFAULT NULL COMMENT 'Tasa Mejorada ',
  `EspecificaTasa` char(1) DEFAULT NULL COMMENT 'Especificar tasa manualmente ',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'moneda ID',
  `MinimoApertura` decimal(18,2) DEFAULT NULL COMMENT 'Monto minimo de apertura',
  `MontoMinimoAnclaje` decimal(18,2) DEFAULT NULL COMMENT 'Monto minimo de anclaje ',
  `Genero` varchar(4) DEFAULT NULL COMMENT 'Se guardaran generos ej. M,F\n',
  `EstadoCivil` varchar(100) DEFAULT NULL COMMENT 'Se guardaran EstadosCivil ej. S,C,V',
  `MinimoEdad` int(11) DEFAULT NULL COMMENT 'Se guardara el rango minimo de edad debe de ser menor al maximo pero menor que 150',
  `MaximoEdad` int(11) DEFAULT NULL COMMENT 'Se guardara el rango maximo de edad debe de ser mayor al minimo pero menor de 150',
  `ActividadEcon` varchar(750) DEFAULT NULL COMMENT 'Se guardaran ID de las Actividades BMX ',
  `NumRegistroRECA` varchar(100) DEFAULT '' COMMENT 'Se guardara el numero de registro.',
  `FechaInscripcion` date DEFAULT '1900-01-01' COMMENT 'Se guardara la Fecha de Inscripcion',
  `NombreComercial` varchar(100) DEFAULT '' COMMENT 'Guardara la descripcion de como es conocido el producto.',
  `Reinversion` char(1) DEFAULT NULL COMMENT 'Especifica si realiza Reinversion Automatica\nS.- Si realiza Reinversion Automatica\nI.-   Indistinto\nN.- No Realiza Reinversion',
  `Reinvertir` char(3) DEFAULT NULL COMMENT 'Indica si hay Reinversion\nC  =  Solo Capital \nCI =  Capital mas interes \nI   =  Indistinto\nN =   No Reliza Inversion.',
  `DiaInhabil` char(2) DEFAULT NULL COMMENT 'Indica el Dia Inhabil:\nSD = Sabado y Domingo\nD = Domingo',
  `TipoPagoInt` varchar(50) DEFAULT '' COMMENT 'Indica la forma de pago de interes.\nV - Vencimiento\nF - Fin del Mes\nP - Por Periodo',
  `DiasPeriodo` varchar(200) DEFAULT '' COMMENT 'Indica el numero de dias si la forma de pago de interes es por PERIODO.',
  `PagoIntCal` char(2) DEFAULT '' COMMENT 'Indica el tipo de pago de interes.\nI - Iguales\nD - Devengado',
  `ClaveCNBV` varchar(10) DEFAULT NULL COMMENT 'Clave CNBV del Producto de Captacion',
  `ClaveCNBVAmpCred` varchar(10) DEFAULT NULL COMMENT 'Clave Producto que Ampara credito',
  `Estatus` CHAR(2) NOT NULL DEFAULT 'A' COMMENT 'Estatus del Tipo de Cede \nA.-Activo\n I.-Inactivo.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoCedeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
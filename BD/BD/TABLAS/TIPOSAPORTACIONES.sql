-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSAPORTACIONES
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSAPORTACIONES`;DELIMITER $$

CREATE TABLE `TIPOSAPORTACIONES` (
  `TipoAportacionID` int(11) NOT NULL COMMENT 'Tipo de Aportacion ID',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion ',
  `FechaCreacion` date DEFAULT NULL COMMENT 'Fecha de Creacion ',
  `TasaFV` char(1) DEFAULT NULL COMMENT 'Tasa Fija o Variable ',
  `Anclaje` char(1) DEFAULT NULL COMMENT 'Se realiza anclaje S= Si N=No',
  `TasaMejorada` char(1) DEFAULT NULL COMMENT 'Tasa Mejorada ',
  `EspecificaTasa` char(1) DEFAULT NULL COMMENT 'Especificar tasa manualmente ',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'moneda ID',
  `MinimoApertura` decimal(18,2) DEFAULT NULL COMMENT 'Monto minimo de apertura',
  `MontoMinimoAnclaje` decimal(18,2) DEFAULT NULL COMMENT 'Monto minimo de anclaje ',
  `NumRegistroRECA` varchar(100) DEFAULT '' COMMENT 'Se guardara el numero de registro.',
  `FechaInscripcion` date DEFAULT '1900-01-01' COMMENT 'Se guardara la Fecha de Inscripcion',
  `NombreComercial` varchar(100) DEFAULT '' COMMENT 'Guardara la descripcion de como es conocido el producto.',
  `Reinversion` char(1) DEFAULT NULL COMMENT 'Especifica si realiza Reinversion Automatica\nS.- Si realiza Reinversion Automatica\nI.-   Indistinto\nN.- No Realiza Reinversion\nE.- Especificacion Posterior',
  `Reinvertir` char(3) DEFAULT NULL COMMENT 'Indica si hay Reinversion\nC  =  Solo Capital \nCI =  Capital mas interes \nI   =  Indistinto\nN =   No Reliza Inversion.\nE.- Posterior',
  `DiaInhabil` char(2) DEFAULT NULL COMMENT 'Indica el Dia Inhabil:\nSD = Sabado y Domingo\nD = Domingo',
  `TipoPagoInt` varchar(50) DEFAULT '' COMMENT 'Indica la forma de pago de interes.\nV - Vencimiento\nF - Fin del Mes\nP - Por Periodo.\nE - Programado',
  `DiasPeriodo` varchar(200) DEFAULT '' COMMENT 'Indica el numero de dias si la forma de pago de interes es por PERIODO.',
  `PagoIntCal` char(2) DEFAULT '' COMMENT 'Indica el tipo de pago de interes.\nI - Iguales\nD - Devengado',
  `ClaveCNBV` varchar(10) DEFAULT NULL COMMENT 'Clave CNBV del Producto de Captacion',
  `ClaveCNBVAmpCred` varchar(10) DEFAULT NULL COMMENT 'Clave Producto que Ampara credito',
  `MaxPuntos` decimal(14,2) DEFAULT '0.00' COMMENT 'Indica el margen maximo que el usuario tiene permitido para especificar una tasa manual',
  `MinPuntos` decimal(14,2) DEFAULT '0.00' COMMENT 'Indica el margen minimo que el usuario tiene permitido para especificar una tasa manual',
  `DiasPago` varchar(100) DEFAULT '' COMMENT 'Indica los dias de pago de la aportacion',
  `PagoIntCapitaliza` char(1) DEFAULT 'I' COMMENT 'Indica si capitaliza interes S:Si, N:No, I:Indistinto',
  `TasaMontoGlobal` char(1) DEFAULT 'N' COMMENT 'Indica si se selecciona una tasa por el monto conjunto (suma de prod vigentes) que tenga el cliente.\nN: NO (default).\nS: SI',
  `IncluyeGpoFam` char(1) DEFAULT 'N' COMMENT 'Indica que si ademas del monto global del cliente, incluirá los montos de \nlos miembros de su grupo familiar.\nN: NO (default).\nS: SI',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoAportacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para registrar los tipos de APORTACIONES'$$
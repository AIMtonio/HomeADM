-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADERDETCRE
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAHEADERDETCRE`;
DELIMITER $$


CREATE TABLE `EDOCTAHEADERDETCRE` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `AnioMes` int(11) DEFAULT NULL COMMENT 'Anio Mes Proceso Estado de cuenta',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal del Cliente',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero del Cliente',
  `CreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero de Credito',
  `Producto` varchar(100) DEFAULT NULL COMMENT 'Numero del Producto de Credito',
  `NombreProd` varchar(100) DEFAULT NULL COMMENT 'Nombre del Producto de Credito',
  `FechaFormaliza` date DEFAULT NULL COMMENT 'Fecha de Inicializacion del credito',
  `MontoAut` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Credito Autorizado',
  `Plazo` int(11) DEFAULT NULL COMMENT 'Plazo del Credito',
  `Periodicidad` varchar(22) DEFAULT NULL COMMENT 'Periocidad de Pago',
  `CAT` decimal(12,2) DEFAULT NULL COMMENT 'Valor del CAT',
  `TasaOrdinaria` decimal(12,2) DEFAULT NULL COMMENT 'Tasa Ordinaria',
  `TasaMoratoria` decimal(12,2) DEFAULT NULL COMMENT 'Tas Moratoria',
  `Comisiones` decimal(18,2) DEFAULT NULL COMMENT 'Monto de las Comisiones',
  `FrecuenciaPago` int(11) DEFAULT NULL COMMENT 'Frecuencia de Pago',
  `MontoCapital` decimal(18,2) NOT NULL COMMENT 'Desglose del monto de capital',
  `MontoIntereses` decimal(18,2) NOT NULL COMMENT 'Desglose del monto de intereses',
  `IVAs` decimal(18,2) NOT NULL COMMENT 'IVAs generados',
  `MontoPagoTotal` decimal(18,2) NOT NULL COMMENT 'Monto total de pago en el periodo',
  `MonBaseCalIntOrd` decimal(18,2) NOT NULL COMMENT 'Monto base para el calculo de intereses ordinarios',
  `MonBaseCalIntMora` decimal(18,2) NOT NULL COMMENT 'Monto base para el calculo de intereses moratorios',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar el encabezado de los detalles de creditos'$$

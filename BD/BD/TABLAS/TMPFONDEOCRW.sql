-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFONDEOCRW
DELIMITER ;
DROP TABLE IF EXISTS `TMPFONDEOCRW`;
DELIMITER $$

CREATE TABLE `TMPFONDEOCRW` (
  `TmpID` bigint(20) DEFAULT NULL COMMENT 'Numero consecutivo.',
  `SolFondeoID` bigint(20) NOT NULL DEFAULT '0' COMMENT 'ID de la solicitud de Fondeo',
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero de Solicitud o ID',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Fondeo de la Solicitud F .- En Proceso de Fondeo C .- Cancelada N .- Vigente o Inversion Creada',
  `TipoFondeadorID` int(11) DEFAULT NULL COMMENT 'Id del Tipo de Fondeador',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del Cliente',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Numero Consecutivo de Fondeo por Solicitud',
  `TasaPasiva` decimal(8,4) DEFAULT NULL COMMENT 'Tasa Pasiva',
  `MontoFondeo` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Fondeo',
  `PorcentajeFondeo` decimal(10,6) DEFAULT NULL COMMENT 'Porcentaje del Fondeo',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `PorcentajeMora` decimal(8,4) DEFAULT NULL COMMENT 'Porcentaje de Participacion en la Mora',
  `PorcentajeComisi` decimal(8,4) DEFAULT NULL COMMENT 'Porcentaje de Participacion en Comisiones',
  `CuentaAhoID` bigint(11) DEFAULT NULL COMMENT 'Cuenta de Ahorro del Cliente o Inversionista',
  `SucursalOrigen` int(5) DEFAULT NULL COMMENT 'Sucursal Origen',
  `Gat` decimal(12,2) DEFAULT NULL COMMENT 'Calculo GAT',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro Auditoria',
  `FechaActual` date DEFAULT NULL COMMENT 'Parametro Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro Auditoria',
  PRIMARY KEY (`SolFondeoID`),
  KEY `INDEX_TMPFONDEOCRW_1` (`NumTransaccion`),
  KEY `INDEX_TMPFONDEOCRW_2` (`SolicitudCreditoID`,`NumTransaccion`),
  KEY `INDEX_TMPFONDEOCRW_3` (`SolicitudCreditoID`,`TmpID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal usada en el sp CRWFONDEOPRO.'$$

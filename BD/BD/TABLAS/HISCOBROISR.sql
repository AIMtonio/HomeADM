-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCOBROISR
DELIMITER ;
DROP TABLE IF EXISTS `HISCOBROISR`;DELIMITER $$

CREATE TABLE `HISCOBROISR` (
  `Fecha` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Calculo ISR',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ClienteID',
  `InstrumentoID` int(11) NOT NULL DEFAULT '0' COMMENT 'InstrumentoID 2.-Ahorro,	13.-Inversiones,	28.-CEDES',
  `ProductoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID del Producto',
  `PagaISR` char(1) DEFAULT NULL COMMENT 'Indica si el CLiente Paga ISR',
  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'Tasa ISR Actual',
  `SumSaldos` decimal(14,2) DEFAULT NULL COMMENT 'Sumatoria de Saldos del CLiente a la Fecha Actual',
  `SaldoProm` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Promedio del Cliente',
  `InicioPeriodo` date DEFAULT NULL COMMENT 'Fecha de Inicio del Periodo del Cobro',
  `FinPeriodo` date DEFAULT NULL COMMENT 'Fecha de Fin de Periodo de Cobro',
  `ISRTotal` decimal(18,6) DEFAULT NULL COMMENT 'Monto ISR a Cargar',
  `ISR` decimal(18,6) DEFAULT NULL COMMENT 'ISR que Corresponde a a Inversion',
  `Factor` decimal(12,4) DEFAULT NULL COMMENT 'Factor ISR',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus A.-Aplicado N.- No Aplicado',
  `TipoRegistro` char(1) NOT NULL COMMENT 'Manera en el que se Registra el Cobro de ISR\nP.- Proceso en Pantalla\nC.- Proceso de Cierre',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Fecha`,`ClienteID`,`ProductoID`,`InstrumentoID`,`TipoRegistro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Historica de Cobro ISR'$$
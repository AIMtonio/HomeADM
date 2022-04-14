-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMPLDOPEEFEC
DELIMITER ;
DROP TABLE IF EXISTS `PARAMPLDOPEEFEC`;DELIMITER $$

CREATE TABLE `PARAMPLDOPEEFEC` (
  `FolioID` int(11) NOT NULL COMMENT 'Folio de parametros para el sistema de Alertas en el Pago de Remesas y Op. que exceden llos limites mensuales.',
  `MontoRemesaUno` decimal(12,2) NOT NULL COMMENT 'Monto Inicial de Remesas para Solicitar Información del Cliente/Usuario. En Dólares',
  `MontoRemesaDos` decimal(12,2) NOT NULL COMMENT 'Monto Segundo de Remesas para Solicitar Información adicional del Cliente/Usuario. En Dólares',
  `MontoRemesaTres` decimal(12,2) NOT NULL COMMENT 'Monto Tercero de Remesas para Solicitar Información adicional del Cliente/Usuario. En Dólares',
  `MontoLimPagoRem` decimal(12,2) NOT NULL COMMENT 'Monto Limite de Efectivo por Operacion para Transferencia Internacional de Fondos (Pago Remesas).En Dolares.',
  `RemesaMonedaID` int(11) NOT NULL COMMENT 'Clave de moneda del monto limite de Remesas',
  `MontoLimEfecF` decimal(12,2) NOT NULL COMMENT 'Monto Limite para Operaciones en efectivo, por Mes Calendario. Solo Personas Fisicas. En Moneda Nacional',
  `MontoLimEfecM` decimal(12,2) NOT NULL COMMENT 'Monto Limite para Operaciones en efectivo, por Mes Calendario. Personas Fisicas Actividad Empresarial y Morales.  En Moneda Nacional\n\n',
  `MontoLimEfecMes` decimal(12,2) NOT NULL COMMENT 'Monto Limite para Operaciones en efectivo, por Mes Calendario.  En Moneda Nacional',
  `MontoLimMonedaID` int(11) NOT NULL COMMENT 'Clave de moneda del monto limite de Operaciones en Efectivo a Agrupar, al Cierre Mensual',
  `FechaVigencia` date NOT NULL COMMENT 'Fecha de Vigencia',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus\nV=Vigente\nB=Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`FolioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros para operaciones efectivo PLD'$$
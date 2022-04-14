-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RIESGOCOMUNCLIREP
DELIMITER ;
DROP TABLE IF EXISTS `RIESGOCOMUNCLIREP`;DELIMITER $$

CREATE TABLE `RIESGOCOMUNCLIREP` (
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'ID de la Solicitud de Credito',
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Consecutivo de Riesgo',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del Cliente con el que se presenta el riesgo',
  `NombreCompleto` varchar(200) NOT NULL COMMENT 'Nombre del Cliente con el que se presenta riesgo',
  `ClienteIDRel` int(11) NOT NULL COMMENT 'ID del Cliente que realiza la solicitud',
  `NombreCompletoRel` varchar(200) NOT NULL COMMENT 'Nombre del Cliente que realiza la solicitud',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito con el que se presenta el riesgo',
  `Motivo` varchar(100) NOT NULL COMMENT 'Motivo de Riesgo',
  `RiesgoComun` char(2) NOT NULL COMMENT 'Indica si la solicitud presenta Riesgo',
  `PersRelacionada` char(2) NOT NULL COMMENT 'Indica si la Solicitud presenta Persona Relacionada',
  `Procesado` char(2) NOT NULL COMMENT 'Indica si la solicitud ya fue procesada',
  `Comentario` text NOT NULL COMMENT 'Comentarios de la solicitud',
  `ParentescoID` int(11) NOT NULL COMMENT 'Clave del Parentesco de la Persona Relacionada',
  `Descripcion` varchar(50) NOT NULL COMMENT 'Descripcion del Parentesco de la persona relacionada',
  `Clave` int(11) NOT NULL COMMENT 'Clave',
  `Estatus` varchar(10) NOT NULL COMMENT 'Estatus de la Solicitud',
  `MontoAcumulado` decimal(14,2) NOT NULL COMMENT 'Monto Acumulado de Creditos por Cliente'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Riesgo por Cliente'$$
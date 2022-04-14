-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RIESGOCOMUNCLI
DELIMITER ;
DROP TABLE IF EXISTS `RIESGOCOMUNCLI`;DELIMITER $$

CREATE TABLE `RIESGOCOMUNCLI` (
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'ID de la Solicitud de Credito',
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Consecutivo de Riesgo',
  `ClienteIDRel` int(11) NOT NULL COMMENT 'ID del Cliente que realiza la solicitud',
  `ClienteIDDesc` varchar(200) NOT NULL COMMENT 'ID del Cliente que realiza la solicitud indicando si es cliente o prospecto',
  `NombreCompletoRel` varchar(200) NOT NULL COMMENT 'Nombre del Cliente que realiza la solicitud',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del Cliente con el que se presenta el riesgo',
  `NombreCompleto` varchar(200) NOT NULL COMMENT 'Nombre del Cliente con el que se presenta riesgo',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito con el que se presenta el riesgo',
  `Motivo` varchar(100) NOT NULL COMMENT 'Motivo de Riesgo',
  `RiesgoComun` char(1) NOT NULL COMMENT 'Indica si la solicitud presenta Riesgo',
  `Procesado` char(1) NOT NULL COMMENT 'Indica si la solicitud ya fue procesada',
  `Comentario` varchar(1050) NOT NULL COMMENT 'Comentarios de la solicitud',
  `ParentescoID` int(11) NOT NULL COMMENT 'Clave del Parentesco de la Persona Relacionada',
  `Descripcion` varchar(50) NOT NULL COMMENT 'Descripcion del Parentesco de la persona relacionada',
  `Clave` int(11) NOT NULL COMMENT 'Clave',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la Solicitud',
  `MontoAcumulado` decimal(14,2) NOT NULL COMMENT 'Monto Acumulado de Creditos por Cliente',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla donde se almacena los registros de los clientes que presentan riesgo.'$$
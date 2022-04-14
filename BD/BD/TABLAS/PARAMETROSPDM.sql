-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSPDM
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSPDM`;DELIMITER $$

CREATE TABLE `PARAMETROSPDM` (
  `EmpresaID` int(11) NOT NULL COMMENT 'Numero o ID de la Empresa',
  `TimeOut` int(11) DEFAULT NULL COMMENT 'Tiempo de espera para el servidor de Pademobile',
  `UrlWSDLLogin` varchar(200) DEFAULT NULL COMMENT 'URL del WSDL para el login en PADEMOBILE',
  `UrlWSDLLogout` varchar(200) DEFAULT NULL COMMENT 'URL del WSDL para el logout en PADEMOBILE',
  `UrlWSDLAlta` varchar(200) DEFAULT NULL COMMENT 'URL del WSDL para el Alta en PADEMOBILE',
  `UrlWSDLBloqueo` varchar(200) DEFAULT NULL COMMENT 'URL del WSDL para el Bloqueo en PADEMOBILE',
  `UrlWSDLDesBloqueo` varchar(200) DEFAULT NULL COMMENT 'URL del WSDL para el Desbloqueo en PADEMOBILE',
  `NombreServicio` varchar(50) DEFAULT NULL COMMENT 'Numero de Servicio',
  `NumeroPreguntas` int(11) DEFAULT NULL COMMENT 'Numero de Preguntas de Seguridad',
  `NumeroRespuestas` int(11) DEFAULT NULL COMMENT 'Numero de Respuestas de Seguridad',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Tiempo de espera para el servidor de Pademobiel',
  PRIMARY KEY (`EmpresaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena los Parametros de PADEMOBILE'$$
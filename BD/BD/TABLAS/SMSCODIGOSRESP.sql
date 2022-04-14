-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCODIGOSRESP
DELIMITER ;
DROP TABLE IF EXISTS `SMSCODIGOSRESP`;DELIMITER $$

CREATE TABLE `SMSCODIGOSRESP` (
  `CodigoRespID` varchar(10) NOT NULL COMMENT 'ID de codigo de respuesta de sms',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Numero Consecutivo',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion del codigo de Respuesta de sms',
  `CampaniaID` int(11) DEFAULT NULL COMMENT 'campania a la que pertenece el código',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CodigoRespID`),
  KEY `fk_SMSCODIGOSRESP_campania_idx` (`CampaniaID`),
  CONSTRAINT `fk_SMSCODIGOSRESP_campania` FOREIGN KEY (`CampaniaID`) REFERENCES `SMSCAMPANIAS` (`CampaniaID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Codigos de Respuesta de sms'$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSMS
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSSMS`;DELIMITER $$

CREATE TABLE `PARAMETROSSMS` (
  `NumeroInstitu1` varchar(15) DEFAULT NULL COMMENT 'Primer numero telefonico de la intitucion',
  `NumeroInstitu2` varchar(15) DEFAULT NULL COMMENT 'Segundo numero telefonico de la intitucion',
  `NumeroInstitu3` varchar(15) DEFAULT NULL COMMENT 'Tercer numero telefonico de la intitucion',
  `RutaMasivos` varchar(100) DEFAULT NULL COMMENT 'Ruta a donde se suben los archivos para envio masivo de sms',
  `NumDigitosTel` int(10) DEFAULT NULL COMMENT 'Número de  digitos permitidos para un telefono celular',
  `NumMsmEnv` int(10) DEFAULT NULL COMMENT 'Número de mensajes enviados permitidos por minuto',
  `EnviarSiNoCoici` char(1) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de parametros de SMS'$$
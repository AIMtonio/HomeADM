-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPREGSECRETAS
DELIMITER ;
DROP TABLE IF EXISTS `BAMPREGSECRETAS`;DELIMITER $$

CREATE TABLE `BAMPREGSECRETAS` (
  `PreguntaSecretaID` bigint(20) NOT NULL COMMENT 'Identificar  consecutivo de la pregunta secreta',
  `Redaccion` varchar(200) NOT NULL COMMENT 'Texto o redaccion de la pregunta.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PreguntaSecretaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de posibles preguntas secretas que se solicita al ingresar a la Aplicacion, como medida de seguridad.'$$
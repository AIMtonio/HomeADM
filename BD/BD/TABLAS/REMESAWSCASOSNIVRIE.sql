-- REMESAWSCASOSNIVRIE
DELIMITER ;
DROP TABLE IF EXISTS `REMESAWSCASOSNIVRIE`;
DELIMITER $$

CREATE TABLE `REMESAWSCASOSNIVRIE` (
  `CasoID` int(11) NOT NULL COMMENT 'Identificador consecutivo del caso de nivel de riesgo',
  `NivelRiesgo` char(10) NOT NULL COMMENT 'Indica el nivel de riego para la operacion ya sea para personas fisica, fisica con actividad empresarial o moral',
  `TipoPersona` char(10) NOT NULL COMMENT 'Indica el tipo de persona  Fisica(F) , Fisica con Actividad Empresarial(A) y Moral (M) para el cliente o usuario',
  `OperadorMontoMax` char(10) NOT NULL COMMENT 'Indica el operador a usar con el monto maximo',
  `MontoMax` decimal(18,2) DEFAULT NULL COMMENT 'Monto maximo de la Remesa',
  `OperadorMontoMin` char(10) NOT NULL COMMENT 'Indica el operador a usar con el monto minimo',
  `MontoMin` decimal(18,2) DEFAULT NULL COMMENT 'Monto minimo de la Remesa',
  `MonedaID` int(11) NOT NULL COMMENT 'ID del tipo de moneda de los montos minimo y maximo',
  `Descripcion` varchar(500) NOT NULL COMMENT 'Descripcion del caso de nivel de riesgo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`CasoID`),
  KEY `fk_REMESAWSCASOSNIVRIE_1` (`NivelRiesgo`),
  KEY `fk_REMESAWSCASOSNIVRIE_2` (`TipoPersona`),
  KEY `fk_REMESAWSCASOSNIVRIE_3` (`MontoMax`),
  KEY `fk_REMESAWSCASOSNIVRIE_4` (`MontoMin`),
  KEY `fk_REMESAWSCASOSNIVRIE_5` (`MonedaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los casos por nivel de riesgo de remesas WS'$$
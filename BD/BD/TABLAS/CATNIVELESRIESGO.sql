
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATNIVELESRIESGO
DELIMITER ;
DROP TABLE IF EXISTS `CATNIVELESRIESGO`;

DELIMITER $$
CREATE TABLE `CATNIVELESRIESGO` (
  `CodigoNiveles` int(11) NOT NULL COMMENT 'Codigo Identificador del conjunto de valores de los niveles de riesgo.',
  `NivelRiesgoID` char(1) NOT NULL COMMENT 'Id del Nivel de Riesgo \n1 - Bajo\n2 - Medio\n3 - Alto',
  `TipoPersona` char(1) NOT NULL DEFAULT 'F' COMMENT 'Tipo de Persona\nF: Fisica\nA: Fisica con Actividad Empresarial\nM: Moral',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion del Nivel de Riesgo. BAJO , MEDIO, ALTO',
  `Minimo` tinyint(4) NOT NULL COMMENT 'Porcentaje Minimo del Nivel de riesgo 0 - 100',
  `Maximo` tinyint(4) NOT NULL COMMENT 'Porcentaje Maximo del Nivel de riesgo 0 - 100',
  `SeEscala` char(1) NOT NULL COMMENT 'Determina si el nivel de riesgo se escala  S - Si N . No',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del nivel A.- Activo I.- Inactivo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` varchar(45) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`NivelRiesgoID`,`TipoPersona`),
  KEY `IDX_CATNIVELESRIESGO_1` (`NivelRiesgoID`,`TipoPersona`,`NumTransaccion`),
  KEY `IDX_CATNIVELESRIESGO_02` (`TipoPersona`,`Estatus`,`Minimo`,`Maximo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Niveles de Riesgo para la matriz, ALTO,MEDIO,BAJO'$$


-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAISES
DELIMITER ;
DROP TABLE IF EXISTS `PAISES`;
DELIMITER $$

CREATE TABLE `PAISES` (
  `PaisID` int(11) NOT NULL COMMENT 'Numero de Pais, segun el INEGI',
  `PaisCNBV` int(5) DEFAULT NULL,
  `PaisRegSITI` int(11) DEFAULT NULL COMMENT 'Clave de Pais SITI - Regulatorios',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Nombre` varchar(150) NOT NULL COMMENT 'Nombre del Pais',
  `Gentilicio` varchar(100) DEFAULT NULL COMMENT 'Gentilicio',
  `EqBuroCred` varchar(5) DEFAULT NULL COMMENT 'Equivalente a la clave del Pais de acuerdo a los catalogos de Buro de Credito',
  `ClaveCNBV` char(4) DEFAULT NULL COMMENT 'Clave proporcionada por la CNBV para identificar cada pais',
  `ClaveRiesgo` char(1) DEFAULT 'B' COMMENT 'Nivel de Riesgo del País.\nB.-Bajo\nA.- Alto',
  `ClaveSTP` INT(11) NOT NULL COMMENT 'Clave de Pais correspondiente al catalogo de Paises de STP',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PaisID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
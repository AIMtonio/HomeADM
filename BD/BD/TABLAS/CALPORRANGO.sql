-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALPORRANGO
DELIMITER ;
DROP TABLE IF EXISTS `CALPORRANGO`;
DELIMITER $$


CREATE TABLE `CALPORRANGO` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `LimInferior` decimal(12,4) DEFAULT NULL COMMENT 'Limite Inferior de rango de porcentaje de reserva\n',
  `LimSuperior` decimal(12,4) DEFAULT NULL COMMENT 'Limite Superior de rango de porcentaje de reserva\n',
  `TipoInstitucion` varchar(2) DEFAULT NULL COMMENT 'Tipo de Institución: R1 IFNB Regulada y no UCS, R2 IFNB Regulado tipo UCS y N IFNB No regulada \n',
  `Calificacion` char(2) NOT NULL COMMENT 'Calificación o grado de riesgo\n',
  `Tipo` char(2) NOT NULL COMMENT 'Tipo de Registro : R - Dato para reserva, N1 - Analisis Cuantitativo Parte 1 , N2 - Analisis Cuantitativo Parte 2, L - Analisis Cualitativo \\n',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de registro A - Activo I - Inactivo  \n',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'C .- Comercial,\nM.-Com. Microcredito,\n O .- Consumo,\n H .- Hipotecario',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Calificación por rango de reserva \n'$$

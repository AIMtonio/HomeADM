-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PORCRESPERIODO
DELIMITER ;
DROP TABLE IF EXISTS `PORCRESPERIODO`;
DELIMITER $$


CREATE TABLE `PORCRESPERIODO` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `LimInferior` int(11) DEFAULT NULL COMMENT 'Limite Inferior de rango de dias\n',
  `LimSuperior` int(11) DEFAULT NULL COMMENT 'Limite Superior de rango de dias \n',
  `TipoInstitucion` varchar(2) NOT NULL COMMENT 'Tipo de Institución: R1 IFNB Regulada y no UCS, R2 IFNB Regulado tipo UCS y N IFNB No regulada \n',
  `PorResCarSReest` decimal(10,2) NOT NULL COMMENT 'Porcentaje de reserva aplicable a cartera Sin Reestructurar \n',
  `PorResCarReest` decimal(10,2) NOT NULL COMMENT 'Porcentaje de reserva aplicable a cartera que ha sido Reestructurada \n',
  `TipoRango` char(1) DEFAULT 'E' COMMENT 'Tipo de Rango\nE .- Expuesto\nC .- Cubierto',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de registro A - Activo I - Inactivo  \n',
  `Clasificacion` char(1) NOT NULL COMMENT 'C .- Comercial,\nM.-Com. Microcredito,\n O .- Consumo,\n H .- Hipotecario',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Porcentaje de reserva por dias de atraso \n'$$

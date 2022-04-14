-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_EquivalenciasFR_BMX
DELIMITER ;
DROP TABLE IF EXISTS `tmp_EquivalenciasFR_BMX`;DELIMITER $$

CREATE TABLE `tmp_EquivalenciasFR_BMX` (
  `ClaveFRAnterior` bigint(20) DEFAULT NULL,
  `ClaveFRNueva` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
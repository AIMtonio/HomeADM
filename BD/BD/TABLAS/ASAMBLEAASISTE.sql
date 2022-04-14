-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASAMBLEAASISTE
DELIMITER ;
DROP TABLE IF EXISTS `ASAMBLEAASISTE`;DELIMITER $$

CREATE TABLE `ASAMBLEAASISTE` (
  `Fecha` date NOT NULL COMMENT 'Fecha de la Asamblea',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del Cliente o Socio',
  `AsistenciaConfirmada` char(1) DEFAULT NULL COMMENT 'Asistencia Confirmada, Pensaba ir:S .- Si, N -. No',
  `AsistenciaReal` char(1) DEFAULT NULL COMMENT 'Asistencia Real, :S .- Si Asistio, N -. No Asistio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Fecha`,`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Control de Asistencia a las Asambleas de Socios'$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EJERCICIOCONTABLE
DELIMITER ;
DROP TABLE IF EXISTS `EJERCICIOCONTABLE`;DELIMITER $$

CREATE TABLE `EJERCICIOCONTABLE` (
  `EjercicioID` int(11) NOT NULL COMMENT 'Consecutivo de\nEjercicios',
  `TipoEjercicio` char(1) NOT NULL COMMENT 'Tipo de Ejercicio\nS .-Semestral\nA .- Anual\nB .- Bienal\nT .- Trienal',
  `Inicio` date NOT NULL COMMENT 'Inicio del Ejercicio',
  `Fin` date NOT NULL COMMENT 'Fin del Ejercicio',
  `FechaCierre` date DEFAULT NULL COMMENT 'Fecha Real del\nCierre Contable',
  `UsuarioCierre` int(11) NOT NULL COMMENT 'Usuario que\nRealizo el Cierre',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del\nEjercicio\nC .- Cerrado\nN .- No Cerrado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(50) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EjercicioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Informacion de los Ejercicios Contables\nde la Institucion'$$
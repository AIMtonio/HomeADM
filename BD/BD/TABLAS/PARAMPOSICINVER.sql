-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMPOSICINVER
DELIMITER ;
DROP TABLE IF EXISTS `PARAMPOSICINVER`;DELIMITER $$

CREATE TABLE `PARAMPOSICINVER` (
  `RutaExpPDF` varchar(100) NOT NULL,
  `RutaReporte` varchar(100) NOT NULL,
  `MesProceso` varchar(10) NOT NULL,
  `InstitucionID` int(11) NOT NULL,
  `RutaLogo` varchar(100) NOT NULL,
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
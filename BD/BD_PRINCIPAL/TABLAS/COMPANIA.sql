-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMPANIA
DELIMITER ;
DROP TABLE IF EXISTS `COMPANIA`;DELIMITER $$

CREATE TABLE `COMPANIA` (
  `CompaniaID` int(11) NOT NULL COMMENT 'PK tabla Empresa',
  `RazonSocial` varchar(100) DEFAULT NULL COMMENT 'Razon Social de la empresa',
  `DireccionCompleta` varchar(100) DEFAULT NULL COMMENT 'Direccion completa de la empresa',
  `OrigenDatos` varchar(100) DEFAULT NULL COMMENT 'Origen de datos, ',
  `Prefijo` varchar(45) DEFAULT NULL COMMENT 'Prefijo de la Compania',
  `MostrarPrefijo` char(1) DEFAULT NULL,
  `Desplegado` varchar(45) DEFAULT NULL COMMENT 'Leyenda que se mostrara en las pantalla que no necesitan logeo y que definira la BD a la cual hacer las transacciones.',
  `Subdominio` varchar(50) DEFAULT NULL COMMENT 'Subdominio para Multicompañia',
  `EmpresaID` int(11) DEFAULT NULL,
  `Aud_Usuario` int(11) DEFAULT NULL,
  `Aud_FechaActual` datetime DEFAULT NULL,
  `Aud_DireccionIP` varchar(15) DEFAULT NULL,
  `Aud_ProgramaID` varchar(50) DEFAULT NULL,
  `Aud_Sucursal` int(11) DEFAULT NULL,
  `Aud_NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CompaniaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
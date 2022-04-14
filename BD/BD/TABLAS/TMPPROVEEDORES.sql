-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPROVEEDORES
DELIMITER ;
DROP TABLE IF EXISTS `TMPPROVEEDORES`;
DELIMITER $$

CREATE TABLE `TMPPROVEEDORES` (
  `Consecutivo` bigint(20) NOT NULL,
  `FolioCarga` 	int(20) NOT NULL,
  `Nombre` varchar(50) DEFAULT "",
  `ApellidoPaterno` varchar(50) DEFAULT "",
  `RazonSocial` varchar(150) DEFAULT "",
  `RFC` varchar(13) DEFAULT "",
  `TipoPersona` varchar(1) DEFAULT '',
  `FechaNacimiento` date DEFAULT "1900-01-01",
  `NombreCompleto` varchar(1000) DEFAULT '',
  KEY (Consecutivo, FolioCarga)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla para almacenar los proveedores no existentes CARGA MASIVA FACTURAS'$$
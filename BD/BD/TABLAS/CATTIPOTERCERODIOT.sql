-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOTERCERODIOT
DELIMITER ;
DROP TABLE IF EXISTS `CATTIPOTERCERODIOT`;DELIMITER $$

CREATE TABLE `CATTIPOTERCERODIOT` (
  `Clave` varchar(2) NOT NULL,
  `Tercero` varchar(50) NOT NULL,
  `TipoOperacion` varchar(50) NOT NULL COMMENT 'Catalogo Tipo de Terceros\n03- Prestacion de Servicios Profesionales\n06- Arrendamiento de Inmuebles\n85- Otros',
  PRIMARY KEY (`Clave`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
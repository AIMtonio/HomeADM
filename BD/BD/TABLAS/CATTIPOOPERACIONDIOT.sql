-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOOPERACIONDIOT
DELIMITER ;
DROP TABLE IF EXISTS `CATTIPOOPERACIONDIOT`;DELIMITER $$

CREATE TABLE `CATTIPOOPERACIONDIOT` (
  `Clave` varchar(2) NOT NULL,
  `Operacion` varchar(50) NOT NULL,
  `TipoTercero` varchar(50) NOT NULL COMMENT 'Catalogo Tipo Operacion\n04- Proveedor Nacional\n05- Proveedor Extranjero\n15- Proveedor Global',
  PRIMARY KEY (`Clave`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
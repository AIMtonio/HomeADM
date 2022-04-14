-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUROCREDINTFPM
DELIMITER ;
DROP TABLE IF EXISTS `BUROCREDINTFPM`;DELIMITER $$

CREATE TABLE `BUROCREDINTFPM` (
  `CintaID` int(11) NOT NULL COMMENT 'Numero consecutivo de la cinta',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id del Cliente de buro de credito',
  `Clave` varchar(10) DEFAULT NULL COMMENT 'Clave de la institucion del cliente de buro de credito',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en que se genera la cinta',
  `Cinta` varchar(5000) DEFAULT NULL COMMENT 'Informacion de la cinta que se envia a Buro '
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena la Cinta Mensual de PM por Clave y Fecha de Envio'$$
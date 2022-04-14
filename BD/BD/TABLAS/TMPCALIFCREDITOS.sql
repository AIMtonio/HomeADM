-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCALIFCREDITOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCALIFCREDITOS`;DELIMITER $$

CREATE TABLE `TMPCALIFCREDITOS` (
  `CreditoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID del credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID de cliente al que pertenece el credito',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del credito',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de entrega del credito',
  `FechTerminacion` date DEFAULT NULL COMMENT 'Fecha de terminacin',
  `FechaVencimien` date DEFAULT NULL COMMENT 'Fecha de vencimiento',
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena datos temporales para calcular puntajes sobre credi'$$
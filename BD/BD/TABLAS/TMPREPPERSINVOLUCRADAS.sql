-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREPPERSINVOLUCRADAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPREPPERSINVOLUCRADAS`;DELIMITER $$

CREATE TABLE `TMPREPPERSINVOLUCRADAS` (
  `ClavePersonaInv` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(300) DEFAULT NULL,
  `TipoLista` varchar(50) DEFAULT NULL,
  `FechaDeteccion` date DEFAULT NULL,
  `FechaAlta` date DEFAULT NULL,
  `FechaDepInicial` date DEFAULT NULL,
  `NumeroOficio` varchar(20) DEFAULT NULL,
  `OrigenDeteccion` varchar(50) DEFAULT NULL,
  KEY `ClavePersonaInv` (`ClavePersonaInv`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
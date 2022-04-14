-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmpAPORTACIONES
DELIMITER ;
DROP TABLE IF EXISTS `tmpAPORTACIONES`;DELIMITER $$

CREATE TABLE `tmpAPORTACIONES` (
  `ClienteID` int(11) NOT NULL COMMENT 'Id del cliente',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
  `SaldoInicial` decimal(5,2) NOT NULL DEFAULT '0.00',
  `Cargos` decimal(5,2) NOT NULL DEFAULT '0.00',
  `Abonos` decimal(5,2) NOT NULL DEFAULT '0.00',
  `SaldoCorte` decimal(5,2) NOT NULL DEFAULT '0.00',
  `Saldo` decimal(14,1) DEFAULT NULL COMMENT 'Campo que indica el Saldo de la aportacion\n',
  `FechaUltMov` date DEFAULT NULL COMMENT 'Fecha en que se da de alta\n'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
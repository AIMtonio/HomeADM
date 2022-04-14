-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSESTADOSFINAN
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSESTADOSFINAN`;DELIMITER $$

CREATE TABLE `TIPOSESTADOSFINAN` (
  `EstadoFinanID` int(11) NOT NULL COMMENT 'ID del Estado Financiero',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion del Estado Financiero',
  `MostrarPantalla` char(1) DEFAULT NULL COMMENT 'Indica si se va a mostrar en la pantalla de Reportes Financieros',
  PRIMARY KEY (`EstadoFinanID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Estados Financieros'$$
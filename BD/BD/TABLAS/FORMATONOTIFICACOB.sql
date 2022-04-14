-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FORMATONOTIFICACOB
DELIMITER ;
DROP TABLE IF EXISTS `FORMATONOTIFICACOB`;DELIMITER $$

CREATE TABLE `FORMATONOTIFICACOB` (
  `FormatoID` int(11) NOT NULL COMMENT 'Identificador consecutivo de la tabla',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion del formato de notificacion',
  `Reporte` varchar(50) NOT NULL COMMENT 'Nombre del prpt',
  `Tipo` char(1) NOT NULL COMMENT 'A= es notificacion para el aval, C= es notificacion para el cliente solicito credito',
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`FormatoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena formatos de cartas, que utilizan en la emision de notificaciones de cobranza'$$
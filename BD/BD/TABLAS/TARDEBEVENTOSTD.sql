-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBEVENTOSTD
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBEVENTOSTD`;DELIMITER $$

CREATE TABLE `TARDEBEVENTOSTD` (
  `TipoEvenTDID` char(16) NOT NULL COMMENT 'ID del Tipo Evento de la Bitacora',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion libre del Evento de la Bitacora de TDD',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoEvenTDID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Eventos de la Bitacora de Tarjeta de Debito'$$
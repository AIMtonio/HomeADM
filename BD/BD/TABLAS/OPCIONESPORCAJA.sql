-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESPORCAJA
DELIMITER ;
DROP TABLE IF EXISTS `OPCIONESPORCAJA`;DELIMITER $$

CREATE TABLE `OPCIONESPORCAJA` (
  `OpcionCajaID` int(11) NOT NULL COMMENT 'ID de la Opcion en Caja',
  `TipoCaja` char(3) NOT NULL COMMENT 'Tipo de Caja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_SucursaIDD` (`TipoCaja`),
  KEY `fk_OPCIONESPORCAJA_1_idx` (`OpcionCajaID`),
  CONSTRAINT `fk_OPCIONESPORCAJA_1` FOREIGN KEY (`OpcionCajaID`) REFERENCES `OPCIONESCAJA` (`OpcionCajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena Operaciones de Ventanilla por caja'$$
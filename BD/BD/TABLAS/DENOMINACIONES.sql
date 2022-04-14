-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DENOMINACIONES
DELIMITER ;
DROP TABLE IF EXISTS `DENOMINACIONES`;DELIMITER $$

CREATE TABLE `DENOMINACIONES` (
  `DenominacionID` int(11) NOT NULL COMMENT 'Consecutivo de denominación',
  `MonedaID` int(11) NOT NULL COMMENT 'ID o Numero de Caja',
  `Valor` int(11) NOT NULL COMMENT 'Nombre de denominación Por Ejm: 1000 ()',
  `NombreLetra` varchar(100) NOT NULL COMMENT 'Nombre de denominación letra Por Ejm: Mil',
  `TipoDenominacion` char(1) NOT NULL COMMENT 'Tipo de \ndenominación\n M=Moneda,\n B= Billete',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de denominación\nA= Activo , \nI = Inactivo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`DenominacionID`),
  KEY `fk_DENOMINACIONES_1` (`MonedaID`),
  CONSTRAINT `fk_DENOMINACIONES_1` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Denominaciones'$$
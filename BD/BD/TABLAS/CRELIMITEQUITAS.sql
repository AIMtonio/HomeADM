-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRELIMITEQUITAS
DELIMITER ;
DROP TABLE IF EXISTS `CRELIMITEQUITAS`;
DELIMITER $$

CREATE TABLE `CRELIMITEQUITAS` (
  `ProducCreditoID` int(11) NOT NULL COMMENT 'ID del Producto de Credito',
  `ClavePuestoID` varchar(10) NOT NULL COMMENT 'Puesto o Nivel Del Usuario',
  `LimMontoCap` decimal(12,2) DEFAULT NULL COMMENT 'Monto Limite de Condonacion de Capital',
  `LimPorcenCap` decimal(12,4) DEFAULT NULL COMMENT 'Limite de Porcentaje de Condonacion de Capital',
  `LimMontoIntere` decimal(12,2) DEFAULT NULL COMMENT 'Monto Limite de Condonacion de Interes',
  `LimPorcenIntere` decimal(12,4) DEFAULT NULL COMMENT 'Limite de Porcentaje de Condonacion de Interes',
  `LimMontoMorato` decimal(12,2) DEFAULT NULL COMMENT 'Monto Limite de Condonacion de Moratorios',
  `LimPorcenMorato` decimal(12,4) DEFAULT NULL COMMENT 'Limite de Porcentaje de Condonacion de Moratorios',
  `LimMontoAccesorios` decimal(12,2) DEFAULT NULL COMMENT 'Monto Limite de Condonacion de Accesorios (Comisiones)',
  `LimPorcenAccesorios` decimal(12,4) DEFAULT NULL COMMENT 'Limite de Porcentaje de Condonacion de Accesorios (Comisiones)',
  `LimMontoNotasCargos` decimal(12,2) DEFAULT NULL COMMENT 'Monto Limite de Condonacion de Notas cargos',
  `LimPorcenNotasCargos` decimal(12,4) DEFAULT NULL COMMENT 'Limite de Porcentaje de Condonacion de Notas Cargos',
  `NumMaxCondona` int(11) DEFAULT NULL COMMENT 'Numero Maximo de Condonaciones por Credito',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProducCreditoID`,`ClavePuestoID`),
  KEY `fk_CRELIMITEQUITAS_1` (`ProducCreditoID`),
  KEY `fk_CRELIMITEQUITAS_2` (`ClavePuestoID`),
  CONSTRAINT `fk_CRELIMITEQUITAS_1` FOREIGN KEY (`ProducCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CRELIMITEQUITAS_2` FOREIGN KEY (`ClavePuestoID`) REFERENCES `PUESTOS` (`ClavePuestoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Limites para Quitas o Condonaciones de Credito'$$
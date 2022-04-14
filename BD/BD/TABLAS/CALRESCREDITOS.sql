-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALRESCREDITOS
DELIMITER ;
DROP TABLE IF EXISTS `CALRESCREDITOS`;
DELIMITER $$


CREATE TABLE `CALRESCREDITOS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Fecha` datetime NOT NULL COMMENT 'Fecha calificación \n',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id Credito\n',
  `Capital` decimal(12,2) DEFAULT NULL COMMENT 'Monto capital \n',
  `Interes` decimal(12,2) DEFAULT NULL COMMENT 'Monto interes \n',
  `IVA` decimal(12,2) DEFAULT NULL COMMENT 'Monto IVA \n',
  `Total` decimal(12,2) DEFAULT NULL COMMENT 'Monto total \n',
  `DiasAtraso` int(4) NOT NULL COMMENT 'Dias Atraso \n',
  `Calificacion` varchar(2) DEFAULT NULL COMMENT 'Calificacion o grado de riesgo\n',
  `PorcReservaExp` decimal(14,4) DEFAULT NULL COMMENT 'Porcentaje de reserva Expuesta\n',
  `PorcReservaCub` decimal(14,4) DEFAULT NULL COMMENT 'Porcentaje de reserva de la parte cubierta',
  `Reserva` decimal(12,2) DEFAULT NULL COMMENT 'Monto de reserva \n',
  `TipoCalificacion` varchar(1) DEFAULT NULL COMMENT 'Tipo de calificación \nE .- Expuesta\nC .- Cubierta',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id Cliente Tipo\n',
  `GarantiaID` int(11) DEFAULT NULL COMMENT 'Id Garantia Tipo\n',
  `FechaValuacion` datetime DEFAULT NULL COMMENT 'Fecha Valuacion \n',
  `TipoGarantiaID` int(11) DEFAULT NULL COMMENT 'Id Tipo garantia \n',
  `MontoGarantia` decimal(12,2) DEFAULT NULL COMMENT 'Valor de garantía \n',
  `GradoPrelacion` int(11) DEFAULT NULL COMMENT 'Grado prelación garantía \n',
  `Metodologia` char(1) DEFAULT NULL COMMENT 'Metodologia de calificacion P .- Parametrico o Experiencia Pago I .- Individual \n',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda o Divisa',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'Producto de Credito',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'Clasificacion\nC .- Comercial\nO .- Consumo\nH .- Hipotecario',
  `AplicaConta` char(1) DEFAULT NULL COMMENT 'Especifica si aplico Contabilidad o Solo Estimacion\nS .- SI aplico la conta\nN .- NO aplico la conta',
  `ReservaInteres` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Reserva que Corresponde al Interes',
  `ReservaCapital` decimal(14,2) DEFAULT NULL COMMENT 'Es la reserva de Capital = Reserva - Reserva de Interes.\n',
  `SaldoResCapital` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de la Reserva de Capital. Nace con el mismo Valor de la Reserva de Capital y se puede disminuir con condonaciones y castigos',
  `SaldoResInteres` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de la Reserva de Interes. Nace con el mismo Valor de la Reserva de Interes y se puede disminuir con Traspasos a Vencido Y Reestructuras',
  `ReservaTotCubierto` decimal(12,2) DEFAULT NULL COMMENT 'Monto a Reservar de la parte Cubierta',
  `ReservaTotExpuesto` decimal(12,2) DEFAULT NULL COMMENT 'Monto a Reservar de la parte Expuesta',
  `ZonaMarginada` char(1) DEFAULT NULL COMMENT 'Es la reserva de Capital',
  `MontoBaseEstCub` decimal(14,2) DEFAULT NULL COMMENT 'Monto base sobre el cual se realizo la estimacion de la parte Cubierta.',
  `MontoBaseEstExp` decimal(14,2) DEFAULT NULL COMMENT 'Monto base sobre el cual se realizo la estimacion de la parte Expuesta',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `index1` (`Fecha`),
  KEY `fk_CALRESCREDITOS_1` (`CreditoID`),
  CONSTRAINT `fk_CALRESCREDITOS_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Calificación y reserva mensual \n'$$

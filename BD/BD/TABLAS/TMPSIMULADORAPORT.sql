-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSIMULADORAPORT
DELIMITER ;
DROP TABLE IF EXISTS `TMPSIMULADORAPORT`;
DELIMITER $$


CREATE TABLE `TMPSIMULADORAPORT` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Número de Transaccion.',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Consecutivo.',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha Calculo.',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha de pago.',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Monto de Capital.',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Interes.',
  `ISR` decimal(18,2) DEFAULT NULL COMMENT 'Monto de ISR.',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Monto Total.',
  `Dias` int(11) DEFAULT NULL COMMENT 'Dias que hay entre la fecha de inicio y la de vencimiento.',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de inicio de la aportación.',
  `SaldoCap` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo capital para aportaciones que permiten capitalizacion',
  `TipoPeriodo` char(1) DEFAULT '' COMMENT 'Tipo de Periodo para el Cálculo de Interés e ISR.\nR.- Periodo Regular.\nI.- Periodo Irregular.',
  KEY `INDEX_TMPSIMULADORAPORT_1` (`NumTransaccion`,`Consecutivo`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Almacena la simulacion de las Aportaciones.'$$

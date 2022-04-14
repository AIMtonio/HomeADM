-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPARRENDAPAGOSIM
DELIMITER ;
DROP TABLE IF EXISTS `TMPARRENDAPAGOSIM`;DELIMITER $$

CREATE TABLE `TMPARRENDAPAGOSIM` (
  `Tmp_Consecutivo` int(11) NOT NULL,
  `Tmp_Dias` int(11) DEFAULT NULL,
  `Tmp_FecIni` date DEFAULT NULL,
  `Tmp_FecFin` date DEFAULT NULL,
  `Tmp_FecExi` date DEFAULT NULL,
  `Tmp_Estatus` char(1) NOT NULL DEFAULT 'I' COMMENT 'Indica el estatus de la cuota',
  `Tmp_Capital` decimal(16,2) DEFAULT NULL,
  `Tmp_Interes` decimal(16,2) DEFAULT NULL,
  `Tmp_Renta` decimal(16,2) DEFAULT NULL,
  `Tmp_Iva` decimal(16,2) DEFAULT NULL,
  `Tmp_Insoluto` decimal(16,2) DEFAULT NULL,
  `Tmp_MontoSeg` decimal(14,2) DEFAULT NULL COMMENT 'Es el monto del seguro Anual de contado',
  `Tmp_MontoSegIva` decimal(14,2) DEFAULT NULL,
  `Tmp_MontoSegVida` decimal(14,2) DEFAULT NULL COMMENT 'Es el monto del seguro de Vida Anual de contado',
  `Tmp_MontoSegVidaIva` decimal(14,2) DEFAULT NULL,
  `Tmp_PagoTotal` decimal(16,2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`Tmp_Consecutivo`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para temporal de amortizaciones'$$
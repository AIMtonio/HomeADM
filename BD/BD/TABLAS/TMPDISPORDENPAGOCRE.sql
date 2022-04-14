-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDISPORDENPAGOCRE
DELIMITER ;
DROP TABLE IF EXISTS `TMPDISPORDENPAGOCRE`;DELIMITER $$

CREATE TABLE `TMPDISPORDENPAGOCRE` (
  `Detalle` char(1) DEFAULT NULL,
  `Alta` char(1) DEFAULT NULL,
  `CtaNum` varchar(50) DEFAULT NULL,
  `Concepto` varchar(30) DEFAULT NULL,
  `PagoVentanilla` char(3) DEFAULT NULL,
  `CodPagoVent` int(11) DEFAULT NULL,
  `NoPagosInter` varchar(50) DEFAULT NULL,
  `Referencia` varchar(40) DEFAULT NULL,
  `Beneficiario` varchar(40) DEFAULT NULL,
  `Identificacion` int(11) DEFAULT NULL,
  `Divisa` char(3) DEFAULT NULL,
  `Monto` varchar(40) DEFAULT NULL,
  `Confirmacion` char(2) DEFAULT NULL,
  `CorreoCel` varchar(50) DEFAULT NULL,
  `FechaDisp` varchar(50) DEFAULT NULL,
  `FechaVen` varchar(50) DEFAULT NULL,
  `Estatus` char(5) DEFAULT NULL,
  `DescEstatus` varchar(50) DEFAULT NULL,
  `TipoMovDisp` int(11) DEFAULT NULL,
  `FormaPago` int(11) DEFAULT NULL,
  `MontoReal` decimal(14,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
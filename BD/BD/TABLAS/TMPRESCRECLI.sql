-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPRESCRECLI
DELIMITER ;
DROP TABLE IF EXISTS `TMPRESCRECLI`;DELIMITER $$

CREATE TABLE `TMPRESCRECLI` (
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `Tmp_CreditoID` bigint(20) NOT NULL COMMENT 'Numero de Credito',
  `Tmp_ProdCre` int(11) DEFAULT NULL COMMENT 'Producto de Credito',
  `Tmp_MontoCred` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Credito',
  `Tmp_FechaMinis` date DEFAULT NULL COMMENT 'Fecha de Ministracion',
  `Tmp_FechaVenc` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `Tmp_MontoSol` decimal(14,2) DEFAULT NULL COMMENT 'Monto Solicitado',
  `Tmp_SaldoTot` varchar(30) DEFAULT NULL COMMENT 'Saldo Total del Credito',
  `Tmp_MontoExi` varchar(30) DEFAULT NULL COMMENT 'Monto Exigible',
  `Tmp_ProxVenc` varchar(30) DEFAULT NULL COMMENT 'Proxima Fecha de Vencimiento',
  `Tmp_FechaSolici` date DEFAULT NULL COMMENT 'Fecha de Solicitud del Credito',
  `Tmp_Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del crédito',
  `Tmp_Descripcion` varchar(45) DEFAULT NULL COMMENT 'Descripción del producto de crédito',
  PRIMARY KEY (`NumTransaccion`,`Tmp_CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal Para Resumen de Creditos por Cliente'$$
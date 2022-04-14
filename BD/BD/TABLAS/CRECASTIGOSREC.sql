-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOSREC
DELIMITER ;
DROP TABLE IF EXISTS `CRECASTIGOSREC`;DELIMITER $$

CREATE TABLE `CRECASTIGOSREC` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito Castigado',
  `NumMovimiento` bigint(20) NOT NULL,
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de la operacion',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Cantidad del Credito pagado por el Cliente',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Caja donde se realiza la transaccion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`,`NumMovimiento`),
  CONSTRAINT `fk_CRECASTIGOSREC_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Recuperacion de Cartera Castigada'$$
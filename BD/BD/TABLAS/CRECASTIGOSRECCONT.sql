-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOSRECCONT
DELIMITER ;
DROP TABLE IF EXISTS `CRECASTIGOSRECCONT`;DELIMITER $$

CREATE TABLE `CRECASTIGOSRECCONT` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito Castigado',
  `NumMovimiento` bigint(20) NOT NULL COMMENT 'Numero de Movimiento',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de la operacion',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Cantidad del Credito pagado por el Cliente',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Caja donde se realiza la transaccion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`CreditoID`,`NumMovimiento`),
  CONSTRAINT `fk_CRECASTIGOSRECCONT_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que almacena Recuperacion de Cartera Castigada Contingente'$$
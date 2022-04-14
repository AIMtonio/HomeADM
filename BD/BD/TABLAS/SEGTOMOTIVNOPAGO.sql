-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOMOTIVNOPAGO
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOMOTIVNOPAGO`;DELIMITER $$

CREATE TABLE `SEGTOMOTIVNOPAGO` (
  `MotivoNPID` int(11) NOT NULL COMMENT 'Id de motivo de No Pago',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion del motivo de No Pago',
  `ImputableID` char(1) DEFAULT NULL COMMENT 'A quien se le imputa el motivo de No Pago C=Cliente, M=Mercado, I=Financiera, T=Terceros, F=Fortuito',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del motivo de no pago V.-Vigente  C.-Cancelado\n',
  `EmpresaID` int(111) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`MotivoNPID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de motivos de NO PAGO'$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJATIPOSOPERA
DELIMITER ;
DROP TABLE IF EXISTS `CAJATIPOSOPERA`;DELIMITER $$

CREATE TABLE `CAJATIPOSOPERA` (
  `Numero` int(11) NOT NULL COMMENT 'Numero del\ntipo de Operacion',
  `Descripcion` varchar(200) NOT NULL COMMENT 'Descripcion \ndel tipo de\n Operacion',
  `Naturaleza` int(11) NOT NULL COMMENT 'Naturaleza \nde la Operacion\n1 .- Entrada \n2 .- Salida',
  `DescCorta` varchar(20) NOT NULL COMMENT 'Es la decripcion corta de Descripcion',
  `Orden` int(2) DEFAULT NULL COMMENT 'Orden para la tira auditora',
  `EsEfectivo` char(1) DEFAULT NULL COMMENT 'Indica si el tipo de operacion es Efectivo o no',
  `Origen` char(1) DEFAULT NULL COMMENT 'Indica si el tipo de Operaccion es el Origen de la operacion realizada.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Operaciones de la Caja o Ventanilla'$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ctascontables
DELIMITER ;
DROP TABLE IF EXISTS `ctascontables`;DELIMITER $$

CREATE TABLE `ctascontables` (
  `EmpresaID` tinytext,
  `CuentaCompleta` char(15) NOT NULL COMMENT 'Cuenta Contable Completa',
  `CuentaMayor` char(4) NOT NULL COMMENT 'Cuenta de Mayor',
  `Descripcion` varchar(250) NOT NULL COMMENT 'Descripción de la\nCuenta\n',
  `DescriCorta` varchar(250) NOT NULL COMMENT 'Descripcion Corta\nde la Cuenta\n',
  `Naturaleza` char(1) NOT NULL COMMENT 'Naturaleza de la\nCuenta\nA .-  Acreedora\nD .-  Deudora',
  `Grupo` char(1) NOT NULL COMMENT 'Nivel de Desglose\nE= ''Encabezado'' \nD= ''Detalle''     ',
  `TipoCuenta` char(1) NOT NULL COMMENT 'Tipo de Cuenta\n1 .- Activo\n2 .- Pasivo\n3 .- Complementaria de Activo\n4.- Capital y Reserva\n5 .- Resultados (Ingresos)\n6 .- Resultados (Gastos)\n7 .- Orden Deudora\n8 .- Orden Acreedora',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda ID',
  `Restringida` char(1) NOT NULL COMMENT 'Si la Cuenta es\nRestringida\nS .- Si es\nrestringida y\nnecesita un\nusuario\nautorizado para\nhacerle cargos o \nabonos\nN .- No es\nReestringida',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CuentaCompleta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Maestro o Catalogo de Cuentas Contables\nGenerales de la Apli'$$
DELIMITER ;
DROP TABLE IF EXISTS `CIFRASCREDITOSVENTACAR`;
DELIMITER $$

CREATE TABLE `CIFRASCREDITOSVENTACAR` (
  `Fecha` date NOT NULL COMMENT 'Fecha del sistema en que se realiza la venta ',
  `NumProcesados` int(11) NOT NULL COMMENT 'Numero de creditos procesados',
  `NumExitosos` int(11) NOT NULL COMMENT 'Numero de creditos procesados exitosos',
  `NumFallidos` int(11) NOT NULL COMMENT 'Numero de creditos procesados fallidos',

  `SaldoCapVigente` DECIMAL(14,2) NOT NULL COMMENT 'Saldo de capital Vigente',
  `SaldoCapAtrasa`  DECIMAL(14,2) NOT NULL COMMENT 'Saldo de capital Atrasado',
  `SaldoInteresOrd` DECIMAL(14,2) NOT NULL COMMENT 'Saldo de Interes Ordinario ',
  `SaldoInteresAtr` DECIMAL(14,2) NOT NULL COMMENT 'Saldo de Interes Atrasado',
  `SaldoInteresPro` DECIMAL(14,2) NOT NULL COMMENT 'Saldo de Interes Provisionado',
  `SaldoMoratorios` DECIMAL(14,2) ,
  `SalMoraVencido` DECIMAL(14,2),
  `SalMoraCarVen` DECIMAL(14,2) ,
  `SaldoComFaltaPa` DECIMAL(14,2) ,
  `SaldoOtrasComis` DECIMAL(14,2) ,
  `SaldoCapVenNExi` DECIMAL(14,2) ,
  `SaldoCapVencido` DECIMAL(14,2) ,
  `SaldoInteresVen` DECIMAL(14,2) ,
  `SaldoIntNoConta` DECIMAL(14,2) ,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria'
)COMMENT='se almacenará las cifras control de los creditos vendidos ';$$

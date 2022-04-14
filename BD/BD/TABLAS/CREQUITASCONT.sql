-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREQUITASCONT
DELIMITER ;
DROP TABLE IF EXISTS `CREQUITASCONT`;
DELIMITER $$

CREATE TABLE `CREQUITASCONT` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID o Numero de Credito',
  `Consecutivo` int(11) NOT NULL COMMENT 'Consecutivo de Condonacion por Credito',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'ID o Numero de Usuario',
  `PuestoID` varchar(10) DEFAULT NULL COMMENT 'Clave del Puesto de quien condona',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha de Registro',
  `MontoComisiones` decimal(14,2) DEFAULT NULL COMMENT 'Monto Condonado de Comisiones',
  `PorceComisiones` decimal(12,4) DEFAULT NULL COMMENT 'Porcentaje Condonado de Comisiones',
  `MontoMoratorios` decimal(14,2) DEFAULT NULL COMMENT 'Monto Condonado de Moratorios',
  `PorceMoratorios` decimal(12,4) DEFAULT NULL COMMENT 'Porcentaje Condonado de Moratorios',
  `MontoInteres` decimal(14,2) DEFAULT NULL COMMENT 'Monto Condonado de Interes',
  `PorceInteres` decimal(12,4) DEFAULT NULL COMMENT 'Porcentaje Condonado de Interes',
  `MontoCapital` decimal(14,2) DEFAULT NULL COMMENT 'Monto Condonado de Capital',
  `PorceCapital` decimal(12,4) DEFAULT NULL COMMENT 'Porcentaje Condonado de Capital',
  `SaldoCapital` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital al momento de la Condonacion',
  `SaldoInteres` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Interes al momento de la Condonacion',
  `SaldoMoratorios` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Moratorios al momento de la Condonacion',
  `SaldoAccesorios` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Accesorios al momento de la Condonacion',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`,`Consecutivo`),
  KEY `fk_CREQUITASCONT_1` (`CreditoID`),
  KEY `fk_CREQUITASCONT_2` (`UsuarioID`),
  KEY `fk_CREQUITASCONT_3` (`PuestoID`),
  CONSTRAINT `fk_CREQUITASCONT_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOSCONT` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREQUITASCONT_2` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREQUITASCONT_3` FOREIGN KEY (`PuestoID`) REFERENCES `PUESTOS` (`ClavePuestoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Quitas Contingentes o Condonacion por CrÃ©dito'$$
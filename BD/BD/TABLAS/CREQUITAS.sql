-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREQUITAS
DELIMITER ;
DROP TABLE IF EXISTS `CREQUITAS`;
DELIMITER $$

CREATE TABLE `CREQUITAS` (
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
  `SaldoNotasCargo` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Notas Cargos al momento de la Condonacion',
  `MontoNotasCargo` decimal(14,2) DEFAULT NULL COMMENT 'Monto Condonado de Notas cargos',
  `PorceNotasCargo` decimal(12,4) DEFAULT NULL COMMENT 'Porcentaje Condonado de Notas Cargos',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`,`Consecutivo`),
  KEY `fk_CREQUITAS_1` (`CreditoID`),
  KEY `fk_CREQUITAS_2` (`UsuarioID`),
  KEY `fk_CREQUITAS_3` (`PuestoID`),
  CONSTRAINT `fk_CREQUITAS_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREQUITAS_2` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREQUITAS_3` FOREIGN KEY (`PuestoID`) REFERENCES `PUESTOS` (`ClavePuestoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Quitas o Condonacion por CrÃ©dito'$$
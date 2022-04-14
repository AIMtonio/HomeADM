-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFOADICIONALCREDWS

DELIMITER ;
DROP TABLE IF EXISTS `INFOADICIONALCREDWS`;
DELIMITER $$

CREATE TABLE INFOADICIONALCREDWS (
	`InfoAdicionalWSID`	INT(11)			NOT NULL COMMENT 'Id de la tabla INFOADICIONALCREDWS',
	`CreditoID`			BIGINT(20)		NOT 	NULL COMMENT 'Numero de Credito',
	`Institucion`		INT(11)	 		NOT NULL COMMENT 'Numero de la institucion Bancaria donde se recibe el pago',
    `Cuenta`			BIGINT(11)	 	NOT NULL COMMENT 'Numero de la Cuenta de Banco donde se recibe el pago',
	`Fecha` 			DATE			NOT NULL COMMENT 'Fecha de recaudacion',
    `PreConsumidos` 	DECIMAL(14,2)	NOT NULL COMMENT 'Precio por litro por los litros consumidos (monto recaudado, monto de pago del credito)',
    `LitConsumidos`		DECIMAL(14,2)	NOT NULL COMMENT 'Consumo total de litros',
	`EmpresaID` 		INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
  	`Usuario` 			INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
  	`FechaActual` 		DATE 			NOT NULL COMMENT 'Campo de Auditoria',
  	`DireccionIP` 		VARCHAR(15) 	NOT NULL COMMENT 'Campo de Auditoria',
  	`ProgramaID`	 	VARCHAR(50) 	NOT NULL COMMENT 'Campo de Auditoria',
  	`Sucursal` 			INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
  	`NumTransaccion`	BIGINT(20)	 	NOT NULL COMMENT 'Campo de Auditoria',
    PRIMARY KEY (`InfoAdicionalWSID`),
    KEY `fk_RELACIONCREDITOINFOADICWS_1` (`CreditoID`),
	CONSTRAINT `fk_RELACIONCREDITOINFOADICWS_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE= InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Tabla de Informacion Adicional de Credito del WS'$$

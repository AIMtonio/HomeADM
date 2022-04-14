-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFOADICIONALCRED

DELIMITER ;
DROP TABLE IF EXISTS `INFOADICIONALCRED`;
DELIMITER $$

CREATE TABLE INFOADICIONALCRED (
	`InfoAdicionalID`	INT(11)			NOT NULL COMMENT 'Id de la tabla INFOADICIONALCRED',
	`CreditoID`			BIGINT(20)		NOT NULL COMMENT 'Numero de Credito',
	`Placa`				VARCHAR(7)	 	NOT NULL COMMENT 'Placa del Automovil',
	`GNV` 				INT(11)			NOT NULL COMMENT 'Litros Consumidos del Vehiculo',
    `Vin` 				VARCHAR(250)	NOT NULL COMMENT 'Vin del Vehiculo',
    `EstatusWS`			CHAR(1)			NOT NULL COMMENT 'Estatus del Envio A-Aceptado, P-Pendiente, E-Erroneo',
    `Plazo`				DECIMAL(14,2)	NOT NULL COMMENT 'Plazo del Credito',
    `Recaudo`			DECIMAL(14,4)	NOT NULL COMMENT 'Recaudo es la formula para el envio hacia el WS',
	`EmpresaID` 		INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
  	`Usuario` 			INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
  	`FechaActual` 		DATE 			NOT NULL COMMENT 'Campo de Auditoria',
  	`DireccionIP` 		VARCHAR(15) 	NOT NULL COMMENT 'Campo de Auditoria',
  	`ProgramaID`	 	VARCHAR(50) 	NOT NULL COMMENT 'Campo de Auditoria',
  	`Sucursal` 			INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
  	`NumTransaccion`	BIGINT(20)	 	NOT NULL COMMENT 'Campo de Auditoria',
    PRIMARY KEY (`InfoAdicionalID`),
	KEY `fk_RELACIONCREDITOINFOADIC_1` (`CreditoID`),
	CONSTRAINT `fk_RELACIONCREDITOINFOADIC_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE= InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Tabla de Informacion Adicional de Credito'$$

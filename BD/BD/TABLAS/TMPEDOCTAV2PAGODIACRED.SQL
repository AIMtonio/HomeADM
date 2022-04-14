DELIMITER ;
DROP TABLE IF EXISTS TMPEDOCTAV2PAGODIACRED;
DELIMITER $$

CREATE TABLE TMPEDOCTAV2PAGODIACRED (
	`CreditoID`					BIGINT(12)			NOT NULL	COMMENT 'Identificacion de credito',
	`ComisionesPagadas`			DECIMAL(14,2)		NOT NULL	COMMENT 'Comisiones pagadas en un periodo. La informacion se obtiene de la tabla SALDOSCREDITOS.',
	`InteresesPagados`			DECIMAL(14,2)		NOT NULL	COMMENT 'Intereses pagados en un periodo. La informacion se obtiene de la tabla SALDOSCREDITOS.',
	PRIMARY KEY(`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para obtener las comisiones pagadas en un periodo'$$

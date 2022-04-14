-- BITACORACREMOVSWS
DELIMITER ;

DROP TABLE IF EXISTS BITACORACREMOVSWS;

DELIMITER $$

CREATE TABLE BITACORACREMOVSWS (
    BitacoraMovsWSID  		BIGINT(20)			NOT NULL	COMMENT 'Identificador del registro de bitacora de WS (Une con tabla BITACORAMOVSWS)',
    CreditoID				BIGINT(12)  		NOT NULL 	COMMENT 'Numero de Credito (Une con CREDITOS)',
    AmortizacionID			INT(11)				NOT NULL	COMMENT 'Numero de Amortizacion',
    MontoCuota				DECIMAL(12,2)		NOT NULL	COMMENT 'Monto de la cuota no pagada',
    DiasMoratorio			INT(11)				NOT NULL	COMMENT 'No de dias de mora',
    
    EmpresaID				INT(11) 			NOT NULL 	COMMENT 'Parametro de auditoria',
    Usuario 				INT(11) 			NOT NULL 	COMMENT 'Parametro de auditoria',
    FechaActual				DATETIME 			NOT NULL 	COMMENT 'Parametro de auditoria',
    DireccionIP 			VARCHAR(15) 		NOT NULL 	COMMENT 'Parametro de auditoria',
    ProgramaID				VARCHAR(50) 		NOT NULL 	COMMENT 'Parametro de auditoria',
    Sucursal 				INT(11) 			NOT NULL 	COMMENT 'Parametro de auditoria',
    NumTransaccion			BIGINT(20) 			NOT NULL	COMMENT 'Parametro de auditoria',
    
    PRIMARY KEY(BitacoraMovsWSID, CreditoID, AmortizacionID),
    INDEX(BitacoraMovsWSID, CreditoID),
    INDEX (CreditoID),
    INDEX (NumTransaccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de bitacora para las amortizacion de un credito sin pagar.'$$

-- BITACORAMOVSWS
DELIMITER ;
DROP TABLE IF EXISTS BITACORAMOVSWS;
DELIMITER $$

CREATE TABLE BITACORAMOVSWS (
    BitacoraMovsWSID  		BIGINT(20)			NOT NULL	COMMENT 'Identificador de la tabla',
    CreditoID				BIGINT(12)  		NOT NULL 	COMMENT 'Numero de Credito (Une con CREDITOS)',
    ClienteID   			INT(11) 			NOT NULL 	COMMENT 'Numero de Cliente (Une con CLIENTES)',
    Fecha					DATE 				NOT NULL 	COMMENT 'Fecha en que se intenta realizar el acceso al SAFI',
    Hora					TIME 				NOT NULL 	COMMENT 'Hora que se intenta realizar acceso al SAFI',
    TipoMov					CHAR(2) 			NOT NULL 	COMMENT 'Tipo De movimiento (Pago de Credito = PC, Impago de Credito = IC, Registro de Cliente = RC)',
    CatRazonImpagoID 		INT(11) 			NOT NULL 	COMMENT 'Numero de la razon de no pago (Une con CATRAZONIMPAGOCRE)', 
    MontoPago		 	 	DECIMAL(12, 2) 		NOT NULL 	COMMENT 'Monto del pago', 
    PromotorID				INT(11) 			NOT NULL 	COMMENT 'Numero de promotor',
    UsuarioID				INT(11) 			NOT NULL 	COMMENT 'Numero de la sucursal', 
    CajaID					INT(11) 			NOT NULL	COMMENT 'ID de la Caja (Une CAJASVENTANILLA)',
    CuentaAhoID				BIGINT(12) 			NOT NULL	COMMENT 'ID de la Caja (Une CUENTASAHO)',
    EmpresaID				INT(11) 			NOT NULL 	COMMENT 'Parametro de auditoria',
    Usuario 				INT(11) 			NOT NULL 	COMMENT 'Parametro de auditoria',
    FechaActual				DATETIME 			NOT NULL 	COMMENT 'Parametro de auditoria',
    DireccionIP 			VARCHAR(15) 		NOT NULL 	COMMENT 'Parametro de auditoria',
    ProgramaID				VARCHAR(50) 		NOT NULL 	COMMENT 'Parametro de auditoria',
    Sucursal 				INT(11) 			NOT NULL 	COMMENT 'Parametro de auditoria',
    NumTransaccion			BIGINT(20) 			NOT NULL	COMMENT 'Parametro de auditoria',
    
    PRIMARY KEY(BitacoraMovsWSID),
    INDEX (CreditoID),
    INDEX (ClienteID),
    INDEX (TipoMov),
    INDEX (ClienteID, CreditoID, NumTransaccion),
    INDEX (NumTransaccion),
    INDEX (CatRazonImpagoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de bitacora para los WS de Pago de Credito y alta de Clientes.'$$

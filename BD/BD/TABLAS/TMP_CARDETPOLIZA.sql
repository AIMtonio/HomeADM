-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_CARDETPOLIZA
DELIMITER ;
DROP TABLE IF EXISTS TMP_CARDETPOLIZA;
DELIMITER $$

CREATE TABLE TMP_CARDETPOLIZA (
    ID 					BIGINT(20)  NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la tabla',
    CreditoID 			BIGINT(12) 							COMMENT 'ID del Credito',
	EmpresaID 			INT(11)								COMMENT 'Empresa ID',
	PolizaID 			BIGINT(20)							COMMENT 'Numero de la Poliza',
	Fecha 				DATE 								COMMENT 'Fecha de la Poliza',
	CentroCostoID 		INT(11)								COMMENT 'Centro de Costos',
	CuentaCompleta 		VARCHAR(50) 						COMMENT 'Cuenta Contable Completa',
	Instrumento 		VARCHAR(20) 						COMMENT 'Instrumento que origino el movimiento',
	MonedaID 			INT(11) 							COMMENT 'ID de la Moneda',
	Cargos 				DECIMAL(14,4) 						COMMENT 'Monto del Cargo',
	Abonos 				DECIMAL(14,4) 						COMMENT 'Monto del Abono',
	Descripcion 		VARCHAR(150) 						COMMENT 'Descripcion del Movimiento',
	Referencia 			VARCHAR(250) 						COMMENT 'Referencia',
	ProcedimientoCont 	VARCHAR(30) 						COMMENT 'Procedimiento Contable que Arma la Cuenta Contable',
	TipoInstrumentoID 	INT(11) 							COMMENT 'ID del tipo de Instrumento que genera el movimiento.',
	RFC 				CHAR(13) 							COMMENT 'Registro Federal de Contribuyentes del Cliente',
	TotalFactura 		DECIMAL(14,2) 						COMMENT 'Monto Total Neto a Pagar de la Factura',
	FolioUUID 			VARCHAR(100) 						COMMENT 'Folio Fiscal o UUID del CFDI',
    NumTransaccion 		BIGINT(20)							COMMENT 'Numero de Transaccion',

    INDEX(CreditoID),
    INDEX(NumTransaccion),
    INDEX(CreditoID, NumTransaccion),
    INDEX(PolizaID),
    PRIMARY KEY(ID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Para guardar la información de la poliza para cambio de fuente de fondeo.'$$
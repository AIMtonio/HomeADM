-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBASIGNADAS
DELIMITER ;
DROP TABLE IF EXISTS TARDEBASIGNADAS;
DELIMITER $$


CREATE TABLE TARDEBASIGNADAS (
	NumTarjeta          VARCHAR(18)                 NOT NULL			COMMENT 'Numero de tarjeta generado',
    NumBin              VARCHAR(8)                  NOT NULL			COMMENT 'BIN de la tarjeta',
    NumSubBin 			VARCHAR(2)					NOT NULL			COMMENT 'SubBIN de la tarjeta',
    LoteDebSAFIID 		INT(11)						NOT NULL 			COMMENT 'ID Lote de TARJETAS.',
    
    
	Usuario 			INT(11) 					NOT NULL			COMMENT 'Parametro de Auditoria',
	FechaActual 		DATETIME 					NOT NULL			COMMENT 'Parametro de Auditoria',
	DireccionIP 		varchar(15) 				NOT NULL			COMMENT 'Parametro de Auditoria',
	ProgramaID 			varchar(50) 				NOT NULL			COMMENT 'Parametro de Auditoria',
	Sucursal 			INT(11) 					NOT NULL			COMMENT 'Parametro de Auditoria',
	NumTransaccion 		BIGINT(20) 					NOT NULL			COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (NumTarjeta),
	INDEX IDX_TARDEBASIGNADAS_LOTE(LoteDebSAFIID),
	INDEX IDX_TARDEBASIGNADAS_BIN(NumBin),
	INDEX IDX_TARDEBASIGNADAS_SUBBIN(NumSubBin),
	INDEX IDX_TARDEBASIGNADAS_Tran(NumTransaccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los numero de tarjetas generados.'$$

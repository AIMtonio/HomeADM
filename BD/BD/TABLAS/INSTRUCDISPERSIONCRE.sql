-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- Creditos
DELIMITER ;
DROP TABLE IF EXISTS INSTRUCDISPERSIONCRE;

DELIMITER $$

CREATE TABLE INSTRUCDISPERSIONCRE (
	SolicitudCreditoID	BIGINT(20) 		NOT NULL				COMMENT 'Número de Solicitud',
	MontoDispersion		DECIMAL(12,2)	NOT NULL DEFAULT 0		COMMENT 'Monto de Dispersion',
	Estatus				CHAR(1)			NOT NULL DEFAULT 'R'	COMMENT 'Estatus de la Instruccion de Dispersion: R = Resgistrado / A = Autorizado',
	EmpresaID			INT(11)			NOT NULL 				COMMENT 'Campo de Auditoria',
	Usuario				INT(11)			NOT NULL 				COMMENT 'Campo de Auditoria',
	FechaActual			DATETIME		NOT NULL 				COMMENT 'Campo de Auditoria',
	DireccionIP			VARCHAR(15)		NOT NULL 				COMMENT 'Campo de Auditoria',
	ProgramaID			VARCHAR(50)		NOT NULL 				COMMENT 'Campo de Auditoria',
	Sucursal			INT(11)			NOT NULL 				COMMENT 'Campo de Auditoria',
	NumTransaccion		BIGINT(20)		NOT NULL 				COMMENT 'Campo de Auditoria',
	PRIMARY KEY (SolicitudCreditoID),
	UNIQUE KEY INDEX_INSTRUCDISPERSIONCRE_1 (SolicitudCreditoID),
	CONSTRAINT FK_INSTRUCDISPERSIONCRE_1 FOREIGN KEY (SolicitudCreditoID) REFERENCES SOLICITUDCREDITO (SolicitudCreditoID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Almacena la informacion de las intrucciones de dispersion de un credito'
$$
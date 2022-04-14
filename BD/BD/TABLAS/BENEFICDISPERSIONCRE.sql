-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- Creditos
DELIMITER ;
DROP TABLE IF EXISTS BENEFICDISPERSIONCRE;

DELIMITER $$

CREATE TABLE BENEFICDISPERSIONCRE (
	SolicitudCreditoID	BIGINT(12) 		NOT NULL				COMMENT 'Número de Solicitud de crédito',
	BenefiDisperID		INT(11)			NOT NULL				COMMENT 'Consecutivo del beneficiario de acuerdo con la solicitud de credito',
	TipoDispersionID	CHAR(1)			NOT NULL				COMMENT 'Tipo de Dispersion: S .- SPEI, C .- Cheque O .- Orden de Pago 	E.- Efectivo, T.- TRAN. SANTANDER',
	Beneficiario		VARCHAR(250)	NOT NULL				COMMENT 'Nombre del Beneficiario',
	Cuenta				VARCHAR(20)		NOT NULL				COMMENT 'Cuenta del Beneficiario para la Dispersion',
	MontoDispersion		DECIMAL(12,2) 	NOT NULL				COMMENT 'Monto a Dispersar para el Beneficiario',
	PermiteModificar	INT(11)			NOT NULL	DEFAULT 1	COMMENT 'Indica el nivel de datos que se pueden modicar 1.- Permiter todo en Nuevos, 2.- Permite Monto en externas, 3.- No permite modificar nada para internas',
	EmpresaID			INT(11)			NOT NULL				COMMENT 'Campo de Auditoria',
	Usuario				INT(11)			NOT NULL				COMMENT 'Campo de Auditoria',
	FechaActual			DATETIME		NOT NULL				COMMENT 'Campo de Auditoria',
	DireccionIP			VARCHAR(15)		NOT NULL				COMMENT 'Campo de Auditoria',
	ProgramaID			VARCHAR(50)		NOT NULL				COMMENT 'Campo de Auditoria',
	Sucursal			INT(11)			NOT NULL				COMMENT 'Campo de Auditoria',
	NumTransaccion		BIGINT(20)		NOT NULL				COMMENT 'Campo de Auditoria',
	PRIMARY KEY (SolicitudCreditoID, BenefiDisperID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Almacena la informacion de las intrucciones de dispersion de un crédito'
$$
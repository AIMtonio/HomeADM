

-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
--  CONSOLIDACARTALIQDET
DELIMITER ;
DROP TABLE IF EXISTS CONSOLIDACARTALIQDET;

DELIMITER $$

CREATE TABLE CONSOLIDACARTALIQDET (
	ConsolidaCartaID	INT(11) 		NOT NULL				COMMENT 'ID de consolidación de acuerdo con la solicitud de en CONSOLIDACIONCARTALIQ',
	AsignacionCartaID	INT(11)			NOT NULL				COMMENT 'Identificador de la Carta de liquidacion en ASIGCARTASLIQUIDACION',
	CartaLiquidaID		INT(11)			NOT NULL				COMMENT 'Identificador de la Carta de liquidacion en CARTALIQUIDACION',
	TipoCarta			CHAR(1)			NOT NULL				COMMENT 'Tipo de Carta de liquidacion I = Internas E = Externas',
	ArchivoIDCarta		INT(11)			NOT NULL	DEFAULT 0	COMMENT 'ID de la carta interna en el expediente de la solicitud',
	EmpresaID			INT(11)			NOT NULL				COMMENT 'Campo de Auditoria',
	Usuario				INT(11)			NOT NULL				COMMENT 'Campo de Auditoria',
	FechaActual			DATETIME		NOT NULL				COMMENT 'Campo de Auditoria',
	DireccionIP			VARCHAR(15)		NOT NULL				COMMENT 'Campo de Auditoria',
	ProgramaID			VARCHAR(50)		NOT NULL				COMMENT 'Campo de Auditoria',
	Sucursal			INT(11)			NOT NULL				COMMENT 'Campo de Auditoria',
	NumTransaccion		BIGINT(20)		NOT NULL				COMMENT 'Campo de Auditoria',
	PRIMARY KEY (ConsolidaCartaID, AsignacionCartaID, CartaLiquidaID)

) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Almacena la relacion entre el folio de consolidacion y las cartas de liquidacion internas o externas'
$$
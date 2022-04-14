DELIMITER ;
DROP TABLE IF EXISTS TMPASIGCARTASLIQUIDA;

-- -----------------------------------------------------
-- Table TMPASIGCARTASLIQUIDA
-- -----------------------------------------------------

DELIMITER $$
CREATE TABLE TMPASIGCARTASLIQUIDA (
	ConsolidaCartaID	INT(11)			NOT NULL						COMMENT 'Folio de consilidación de créditos',
	Consecutivo			INT(11)			NOT NULL						COMMENT 'Consecutivo de la tabla',
	CasaComercialID		BIGINT(12)		NOT NULL						COMMENT 'ID de la Casa Comercial.',
	Monto				DECIMAL(18,2)	NOT NULL DEFAULT 0				COMMENT 'Monto de la Carta de Liquidación.',
	FechaVigencia		DATETIME		NOT NULL DEFAULT '1900-01-01'	COMMENT 'Fecha de Vencimiento de la Carta de Liquidación.',
	TipoDocCarta		INT(11)			NOT NULL 						COMMENT 'Tipo de carta de acuerdo con el CAT de TIpo de Documentos. Para las cartas Externas el tipo de documento sera el existente 9996',
	ModificaArchCarta	CHAR(1)			NOT NULL DEFAULT 'S'			COMMENT 'Indica si el proceso dara de baja archivos existentes. S: Si elimina  N: No Elimina. Para los nuevos siempre es SI',
	RecursoCarta		MEDIUMBLOB		NULL							COMMENT 'Almancena la carta externa de manera binaria',
	ExtencionCarta		VARCHAR(15)		NOT NULL						COMMENT 'Extension del archivo',
	ComentarioCarta		VARCHAR(250)	NOT NULL						COMMENT 'Comentario de la Carta',
	TipoDocPagare		INT(11)			NOT NULL						COMMENT 'Para los pagare el tipo de documento sera el existente 9997',
	ModificaArchPago	CHAR(1)			NOT NULL DEFAULT 'S'			COMMENT 'Indica si el proceso dara de baja archivos existentes. S: Si elimina N: No Elimina Para los nuevos siempre es SI.',
	RecursoPagare		MEDIUMBLOB		NULL							COMMENT 'Almancena el documento de pagaré de la carta externa, de manera binaria.',
	ExtencionPagare		VARCHAR(15)		NOT NULL						COMMENT 'Extension del archivo',
	ComentarioPagare	VARCHAR(250)	NOT NULL						COMMENT 'Comentario deL pagaré',
	EmpresaID			INT(11)			NOT NULL						COMMENT 'Campo de Auditoria',
	Usuario				INT(11)			NOT NULL						COMMENT 'Campo de Auditoria',
	FechaActual			DATETIME		NOT NULL						COMMENT 'Campo de Auditoria',
	DireccionIP			VARCHAR(15)		NOT NULL						COMMENT 'Campo de Auditoria',
	ProgramaID			VARCHAR(50)		NOT NULL						COMMENT 'Campo de Auditoria',
	Sucursal			INT(11)			NOT NULL						COMMENT 'Campo de Auditoria',
	NumTransaccion		BIGINT(20)		NOT NULL						COMMENT 'Campo de Auditoria',
  PRIMARY KEY (ConsolidaCartaID, Consecutivo)
  ) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla temporal para las cartas de liquidacion internas relacionadas con el folio de consolidación'

$$



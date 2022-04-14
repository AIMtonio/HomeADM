-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIRECEPCIONESPEN
DELIMITER ;
DROP TABLE IF EXISTS SPEIRECEPCIONESPEN;
DELIMITER $$

CREATE TABLE SPEIRECEPCIONESPEN (
	SpeiRecepcionPenID 			BIGINT(20) 		NOT NULL COMMENT 'Identificador de la tabla',
	TipoPagoID 					INT(2) 			NOT NULL COMMENT 'Tipo de pago spei',
	TipoCuentaOrd 				INT(2) 			NOT NULL COMMENT 'Tipo de cuenta ordenante',
	CuentaOrd 					BLOB 			NOT NULL COMMENT 'Numero de CLABE, Numero de tarjeta o Numero de celular.',
	NombreOrd 					BLOB 			NOT NULL COMMENT 'Nombre del ordenante',
	RFCOrd 						BLOB 			NOT NULL COMMENT 'RFC del Ordenante',
	TipoOperacion 				INT(2) 			NOT NULL COMMENT 'Tipo de Operacion spei.',
	MontoTransferir 			BLOB 			NOT NULL COMMENT 'Monto de la transferencia',
	IVAComision 				DECIMAL(16,2) 	NOT NULL COMMENT 'Iva Comision SPEI',
	InstiRemitenteID 			INT(5) 			NOT NULL COMMENT 'Institucion remitente u ordenante',
	InstiReceptoraID 			INT(5) 			NOT NULL COMMENT 'Institucion receptora',
	CuentaBeneficiario 			BLOB 			NOT NULL COMMENT 'Cuenta del Beneficiario',
	NombreBeneficiario 			BLOB 			NOT NULL COMMENT 'Nombre del Benefiaciario',
	RFCBeneficiario 			BLOB 			NOT NULL COMMENT 'RFC del Beneficiario',
	TipoCuentaBen 				INT(2) 			NOT NULL COMMENT 'Tipo de Cuenta del beneficiario.',
	ConceptoPago 				BLOB 			NOT NULL COMMENT 'Concepto de la transferencia',
	ClaveRastreo 				VARCHAR(30) 	NOT NULL COMMENT 'Clave de rastreo.',
	CuentaBenefiDos 			VARCHAR(20) 	NOT NULL COMMENT 'Cuenta del Beneficiario Dos',
	NombreBenefiDos 			VARCHAR(40) 	NOT NULL COMMENT 'Nombre del Benefiaciario Dos',
	RFCBenefiDos 				VARCHAR(18) 	NOT NULL COMMENT 'RFC del Beneficiario Dos',
	TipoCuentaBenDos 			INT(2) 			NOT NULL COMMENT 'Tipo de Cuenta Beneficiario dos',
	ConceptoPagoDos 			VARCHAR(40) 	NOT NULL COMMENT 'Concepto de la transferencia',
	ClaveRastreoDos 			VARCHAR(30) 	NOT NULL COMMENT 'Clave de rastreo dos.',
	ReferenciaCobranza 			VARCHAR(40) 	NOT NULL COMMENT 'Referencia de cobranza',
	ReferenciaNum 				INT(7) 			NOT NULL COMMENT 'Referencia Numerica',
	Estatus 					VARCHAR(2) 		NOT NULL COMMENT 'Estatus de recepcion (R = Registrada, A = Aplicado, NA = No Aplicado)',
	Prioridad 					INT(1) 			NOT NULL COMMENT 'Prioridad',
	FechaOperacion 				DATE 			NOT NULL COMMENT 'Fecha de abono',
	FechaCaptura 				DATETIME 		NOT NULL COMMENT 'Fecha de captura',
	ClavePago 					VARCHAR(10) 	NOT NULL COMMENT 'Clave de pago',
	AreaEmiteID 				INT(2) 			NOT NULL COMMENT 'Area que emite',
	EstatusRecep 				INT(3) 			NOT NULL COMMENT 'Estatus de recepcion',
	CausaDevol 					INT(2) 			NOT NULL COMMENT 'Causa devolucion',
	InfAdicional 				VARCHAR(100) 	NOT NULL COMMENT 'informacion adicional',
	RepOperacion 				CHAR(1) 		NOT NULL COMMENT 'Indica si ya fue reportada la operacion a banxico:\nS) Si, Ya se reporto si fue abonada o devuelta\nN) No, No se ha reportado',
	Firma 						VARCHAR(250) 	NOT NULL COMMENT 'Firma',
	Folio 						BIGINT(20) 		NOT NULL COMMENT 'Folio emisor',
	FolioBanxico 				BIGINT(20) 		NOT NULL COMMENT 'Folio banco de Mexico',
	FolioPaquete 				BIGINT(20) 		NOT NULL COMMENT 'Folio del paquete',
	FolioServidor 				BIGINT(20) 		NOT NULL COMMENT 'Folio del servidor',
	Topologia 					CHAR(1) 		NOT NULL COMMENT 'Topologia: (T = Topologia T, V = Topologia V)',
	Empresa 					VARCHAR(50) 	NOT NULL COMMENT 'Nombre de la empresa beneficiaria que esta configurada en STP',

	FechaProceso 				DATETIME 		NOT NULL COMMENT 'Fecha en la que se intento realizar la recepcion, nace vacio.',
	NumTransaccionReg			BIGINT(20) 		NOT NULL COMMENT 'Numero de transaccion del registro',
	NumTransaccionRec 			BIGINT(20) 		NOT NULL COMMENT 'Numero de transaccion del la recepcion, nace vacio y se asigna una vez realizado la recepcion.',
	FolioSpeiRecID 				BIGINT(20) 		NOT NULL COMMENT 'Folio de SpeiRecepcion, nace vacio y se asigna una vez realizado la recepcion.',
	PIDTarea					VARCHAR(50)		NOT NULL COMMENT 'ID del Hilo de tarea para el Demonio.',

	EmpresaID 					INT(11) 		DEFAULT NULL COMMENT 'Campo de Auditoria',
	Usuario 					INT(11) 		DEFAULT NULL COMMENT 'Campo de Auditoria',
	FechaActual 				DATETIME 		DEFAULT NULL COMMENT 'Campo de Auditoria',
	DireccionIP 				VARCHAR(20) 	DEFAULT NULL COMMENT 'Campo de Auditoria',
	ProgramaID 					VARCHAR(50) 	DEFAULT NULL COMMENT 'Campo de Auditoria',
	Sucursal 					INT(11) 		DEFAULT NULL COMMENT 'Campo de Auditoria',
	NumTransaccion 				BIGINT(20) 		DEFAULT NULL COMMENT 'Campo de Auditoria',

	PRIMARY KEY(SpeiRecepcionPenID),
	INDEX(ClaveRastreo),
	INDEX(FolioBanxico),
	INDEX(ClaveRastreo, InstiRemitenteID, FechaOperacion),
	CONSTRAINT `fk_SPEIRECEPCIONESPEN_1` FOREIGN KEY (`TipoPagoID`) REFERENCES `TIPOSPAGOSPEI` (`TipoPagoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  	CONSTRAINT `fk_SPEIRECEPCIONESPEN_2` FOREIGN KEY (`InstiRemitenteID`) REFERENCES `INSTITUCIONESSPEI` (`InstitucionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  	CONSTRAINT `fk_SPEIRECEPCIONESPEN_3` FOREIGN KEY (`InstiReceptoraID`) REFERENCES `INSTITUCIONESSPEI` (`InstitucionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  	CONSTRAINT `fk_SPEIRECEPCIONESPEN_4` FOREIGN KEY (`AreaEmiteID`) REFERENCES `AREASEMITESPEI` (`AreaEmiteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab:Tabla para almacenar las recepciones de SPEI antes de ser efectuadas realmente.'$$

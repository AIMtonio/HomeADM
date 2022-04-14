-- TMPCREDITOSGRUPOSAGRO
DELIMITER ;
DROP TABLE IF EXISTS TMPCREDITOSGRUPOSAGRO;
DELIMITER $$

CREATE TABLE TMPCREDITOSGRUPOSAGRO(
	SolicitudGrupID 		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Identificador de la tabla',
	SolCreditoID    		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Identificador de la solicitud de credito',
	ClienteID       		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Identificador del cleinte',
	ProductoCred    		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'ID del producto de credito',
	MontoAut        		DECIMAL(16,2)		NOT NULL DEFAULT '0.0'	COMMENT 'Monto autorizado del credito',
	MonedaID        		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Moneda ID',
	FacMora         		DECIMAL(12,2)		NOT NULL DEFAULT '0.0'	COMMENT 'Factor moratorio',
	CalcInter       		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Calculo interes',
	TasaFija        		DECIMAL(12,4)		NOT NULL DEFAULT '0.0'	COMMENT 'Tasa fija del credito',
	TasaBase        		DECIMAL(12,4)		NOT NULL DEFAULT '0.0'	COMMENT 'Tasa base del credito',
	SobreTasa       		DECIMAL(12,4)		NOT NULL DEFAULT '0.0'	COMMENT 'Sobre tasa',
	PisoTasa        		DECIMAL(12,4)		NOT NULL DEFAULT '0.0'	COMMENT 'Piso, Si es formula tres',
	TechTasa        		DECIMAL(12,4)		NOT NULL DEFAULT '0.0'	COMMENT 'Techo, Si es formula tres',
	FrecCap         		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Frencuencia del capital',
	PeriodCap       		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Periodo capital',
	FrecInter       		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Frecuencia interes',
	PeriodInt       		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Periodo interes',
	TipoPagCap      		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Tipo de pago capital',
	NumAmorti       		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Numero de amortizaciones',
	FechInha        		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'En Fecha Inhabil Tomar:\nS.- Siguiente\nA.- Anterior',
	CalIrreg        		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Calculo irregulades',
	DiaPagIn        		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Dia de pago del interes',
	DiaPagCap       		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Dia del pago capital',
	DiaMesIn        		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Dia del mes de interes',
	DiaMesCap       		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Dia del mes de capital',
	AjFeUlVA        		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Ajustar la fecha de vencimiento de la ultima \namortizacion a fecha de vencimiento de credito\nS.- Si\nN.- No',
	AjFecExV        		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Ajustar Fecha de exigibilidad a fecha de vencimiento\nS.- Si\nN.- No\n',
	NumTrSim        		BIGINT(20)			NOT NULL DEFAULT '0'	COMMENT 'Numero de transaccion en el simulador de amortizaciones\n',
	TipoFond        		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Tipo de Fondeo:\nP .- Recursos Propios\nF .- Institucion de Fondeo',
	MonComA         		DECIMAL(12,4)		NOT NULL DEFAULT '0.0'	COMMENT 'Monto comision por apertura',
	IVAComA         		DECIMAL(12,4)		NOT NULL DEFAULT '0.0'	COMMENT 'IVA de la comision por apertura',
	CAT             		DECIMAL(12,4)		NOT NULL DEFAULT '0.0'	COMMENT 'Costo Anual Total',
	Plazo           		VARCHAR(20)			NOT NULL DEFAULT '0'	COMMENT 'Plazo del credito',
	TipoDisper      		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Tipo de Dispersion\\n	S .- SPEI\\n	C .- Cheque\\n	O .- Orden de Pago\\n	E.- Efectivo',
	CuentaCLABE     		CHAR(18)			NOT NULL DEFAULT ''		COMMENT 'No de Cuenta Clabe del Credito',
	DestCred        		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Destino del credito',
	TipoCalIn       		INT(11)				NOT NULL DEFAULT '0'	COMMENT '1 .- Saldos Insolutos\n2 .- Monto Original (Saldos Globales)',
	InstutFond      		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Insitucion de Fondeo, puede no escoger linea de fondeo',
	LineaFon        		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Si escoge una institucion de fondeo, debe escoger sobre \nQue linea De fondeo (LINEAFONDEADOR)\n',
	NumAmoInt       		INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Numero de Amortizaciones o Cuotas (de Capital)',
	EstSolici       		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Estatus de la solicitud',
	AporteCte       		DECIMAL(14,2)		NOT NULL DEFAULT '0.0'	COMMENT 'Aporte del cliente',
	MonSegVida      		DECIMAL(14,2)		NOT NULL DEFAULT '0.0'	COMMENT 'Monto del seguro de vida',
	ClasiDestinCred 		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Clasificacion del destino de credito',
	ForCobroSegVida 		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'A: Anticipado, D: Deduccion, F: Financiamiento',
	DescSeguro      		DECIMAL(12,2)		NOT NULL DEFAULT '0.0'	COMMENT 'Monto de seguro de vida con descuento',
	MontoSegOri     		DECIMAL(12,2)		NOT NULL DEFAULT '0.0'	COMMENT 'Monto de seguro de vida original',
	CobraSegCuota   		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'Cobra del seguro de cuota',
	CobraIVASegCuo  		CHAR(1)				NOT NULL DEFAULT ''		COMMENT 'IVA del Cobra seguro cuota',
	MontoSegCuota   		DECIMAL(12,2)		NOT NULL DEFAULT '0.0'	COMMENT 'Monto del seguro Cuota',
	TipoConsultaSIC 		CHAR(2)				NOT NULL DEFAULT ''		COMMENT 'Tipo de consulta SIC',
	FolioConsultaBC 		VARCHAR(30)			NOT NULL DEFAULT '0'	COMMENT 'Folio de consulta buro de credito',
	FolioConsultaCC 		VARCHAR(30)			NOT NULL DEFAULT '0'	COMMENT 'Folio de consulta circulo de credito',
	GrupoID					INT(11)				NOT NULL DEFAULT '0'	COMMENT 'Identificador del grupo',
	TasaPasiva				DECIMAL(14,4)		NOT NULL DEFAULT '0.0'	COMMENT 'Tasa pasiva',
	NumTransaccion			BIGINT(20)			NOT NULL DEFAULT '0'	COMMENT 'Parametro de auditoria',
PRIMARY KEY (SolicitudGrupID, NumTransaccion, SolCreditoID),
KEY `IDX_CREDGRUP_1` (NumTransaccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla auxiliar para almacenar los creditos grupales'$$
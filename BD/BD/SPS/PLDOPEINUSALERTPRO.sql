
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINUSALERTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINUSALERTPRO`;

DELIMITER $$
CREATE PROCEDURE `PLDOPEINUSALERTPRO`(
/* SP que detecta las operaciones inusuales de manera automatica en el cierre diario */
	Par_FechaActual			DATETIME,			-- Fecha de Cierre
	Par_Salida				CHAR(1),			-- Salida S:Si N:No
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error
	Par_EmpresaID			INT(11),			-- Numero de empresa

	Aud_Usuario				INT(11),			-- Auditoria
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Variables --
	DECLARE VarControl                  VARCHAR(200);
	DECLARE Var_DiasAntesDeVen			DECIMAL(11);
	DECLARE Var_EmpresaDefault			INT(11);
	DECLARE Var_FecFinMes				DATE;
	DECLARE Var_FecIniMes               DATE;
	DECLARE Var_FechaSig	   			DATE;
	DECLARE Var_Institucion				INT(11);
	DECLARE Var_LiquidAnticipad			CHAR(1);
	DECLARE Var_PorcDiasLiqAnt			DECIMAL(14,2);
	DECLARE Var_PorcLiqAnt				DECIMAL(14,2);
	DECLARE Var_MontoCredito			DECIMAL(18,2);
	DECLARE Var_MaxIdConsec				INT(11);
	DECLARE Var_MensualMonedaID			INT(11);
	DECLARE Var_MonMaxOpeMensual		DECIMAL(18,2);
	DECLARE Var_MontoMensual			DECIMAL(18,2);
	DECLARE Var_MontoTransac			DECIMAL(18,2);
	DECLARE Var_NombreInstitucion		VARCHAR(150);
	DECLARE Var_NumClienAhorro			INT(11);
	DECLARE Var_NumClienCheques			INT(11);
	DECLARE Var_NumClienDepRef			INT(11);
	DECLARE Var_NumClienTransfer		INT(11);
	DECLARE Var_PctMayPagPerfCte		DECIMAL(8,2);
	DECLARE Var_PctMayPerfCte			DECIMAL(8,2);
	DECLARE Var_TipoCamDofMonMen		DECIMAL(18,2);
	DECLARE Var_TipoCamDofTransa		DECIMAL(18,2);
	DECLARE Var_TipoInstruMonID			VARCHAR(10);
	DECLARE Var_TransacMonedaID			INT(11);
	DECLARE Var_NombreCorto				VARCHAR(45);	-- Nombre corto del tipo de institucion financiera
	DECLARE Var_EntidadRegulada			VARCHAR(2);		-- Indica si la financiera es una entidad regulada,

	-- Declaracion de Constantes --
	DECLARE AlertasAutomati				CHAR(10);
	DECLARE CNVBChequeDeCaja			CHAR(2);
	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE TipoMov_Cheque						CHAR(1);
	DECLARE Cheque_Externo				CHAR(1);
	DECLARE ClaveSistemaAut				INT(11);
	DECLARE Cliente						INT(1);
	DECLARE Cre_StaPagado				CHAR(1);
	DECLARE Credito						INT(1);
	DECLARE Cuenta						INT(1);
	DECLARE Decimal_Cero				DECIMAL(14,2);
	DECLARE DescriExcedeFrecTran		VARCHAR(150);
	DECLARE DescriExcedeMontoMensual	VARCHAR(150);
	DECLARE DescriExcedeMontoTransac	VARCHAR(150);
	DECLARE DescriExcedeMontoTransacPF	VARCHAR(150);
	DECLARE DescriExcedeNumTran			VARCHAR(150);
	DECLARE DescriLiquidAnt				VARCHAR(150);
	DECLARE DescriPagoAnticipado		VARCHAR(150);
	DECLARE DescriPagoMayoQueExig		VARCHAR(150);
	DECLARE Desc_LiqAntXDias			VARCHAR(150);
	DECLARE Desc_PagoSupExig			VARCHAR(150);

	DECLARE Des_PerfilExcedeMontoDepositos		VARCHAR(100);
	DECLARE Des_PerfilExcedeMontoRetiros		VARCHAR(100);
	DECLARE Des_PerfilExcedeNumDepositos		VARCHAR(100);
	DECLARE Des_PerfilExcedeNumRetiros			VARCHAR(100);

	DECLARE DiaUnoDelMes				CHAR(2);
	DECLARE TipoMov_Efectivo			CHAR(1);
	DECLARE Entero_Cero					INT(11);
	DECLARE Entero_Uno					INT(11);
	DECLARE Es_DiaHabil					CHAR(1);									# almacensa S= Si, N=No es dia habil
	DECLARE Esta_Aplicado				CHAR(1);
	DECLARE Esta_Autorizado				CHAR(1);
	DECLARE EstatusDesembolso			CHAR(1);
	DECLARE EstatusOpeCapturada			INT(11);
	DECLARE FechaVacia					DATE;
	DECLARE For_TipoCredito				INT(1);
	DECLARE For_TipoDocumento			INT(1);
	DECLARE For_TipoEfectivo			INT(1);
	DECLARE For_TipoTransferencia		INT(1);
	DECLARE MonedaDolares				INT(11);
	DECLARE MotivoAlertaAut				CHAR(4);
	DECLARE MotivoAlertaTran			CHAR(4);
	DECLARE Nat_Abono					CHAR(1);
	DECLARE Nat_Cargo					CHAR(1);
	DECLARE NaturaOpeSuma				CHAR(1);
	DECLARE NombreDefaultSistema		VARCHAR(4);
	DECLARE OpeCNBVDep					CHAR(2);
	DECLARE ParametroVigente			CHAR(1);
	DECLARE Str_NO						CHAR(1);
	DECLARE Str_SI						CHAR(1);
	DECLARE TipoOpePagoCredito			CHAR(2);
	DECLARE TipoOpeLiqCredito			CHAR(2);
	DECLARE TipoPersonaSAFICTE			VARCHAR(3);
	DECLARE TmpMonedaBase				INT(11);
	DECLARE TmpMonedaExtrangera			INT(11);
	DECLARE Trans_EntreCtas				INT(1);
	DECLARE TipoMov_Transferencia		CHAR(1);
	DECLARE ValorDlsPorMes				DECIMAL(18,2);
	DECLARE ValorDlsPorOperacion		DECIMAL(18,2);
	DECLARE TipoSocap					VARCHAR(10);
	DECLARE TipoSofipo					VARCHAR(10);
	DECLARE TipoSofom					VARCHAR(10);


	-- Asignacion de Constantes --
	SET AlertasAutomati 				:= 'PR-SIS-000';		-- Clave de Alerta automatica segun catalogo PLDCATPROCEDINT --
	SET CNVBChequeDeCaja				:= '05';				-- Deposito de cheque SBC segun la CNBV --
	SET Cadena_Vacia					:= '';					-- Constante Vacio --
	SET TipoMov_Cheque					:= 'H';					-- Forma de pago Cheque --
	SET Cheque_Externo					:= 'E';					-- Es Cheque Externo --
	SET ClaveSistemaAut					:= 3;					-- Clave de Sistema Automatico
	SET Cliente							:= 3;					-- Tipo Canal Cliente
	SET Cre_StaPagado					:= 'P';					-- Estatus Pagado
	SET Credito							:= 1;					-- Tipo Canal Credito
	SET Cuenta							:= 2;					-- Tipo Canal Cuenta
	SET Decimal_Cero					:= 0.0;					-- Constante Cero punto Cero
	SET Des_PerfilExcedeMontoDepositos	:= 'EXCEDE MONTO DE DEPOSITOS DECLARADO EN SU PERFIL TRANSACCIONAL';		-- OPERACION INUSUAL PARA PERFIL TRANSACCIONAL
	SET Des_PerfilExcedeMontoRetiros	:= 'EXCEDE MONTO DE RETIROS DECLARADO EN SU PERFIL TRANSACCIONAL';			-- OPERACION INUSUAL PARA PERFIL TRANSACCIONAL
	SET Des_PerfilExcedeNumDepositos	:= 'EXCEDE NUMERO DE DEPOSITOS DECLARADOS EN EL PERFIL TRANSACCIONAL';		-- OPERACION INUSUAL PARA PERFIL TRANSACCIONAL
	SET Des_PerfilExcedeNumRetiros		:= 'EXCEDE NUMERO DE RETIROS DECLARADOS EN EL PERFIL TRANSACCIONAL';		-- OPERACION INUSUAL PARA PERFIL TRANSACCIONAL
	SET DescriLiquidAnt					:= 'CREDITO LIQUIDADO ANTICIPADAMENTE POR MONTO.';							-- Descripcion Credito liquidado anticipadamente --
	SET DescriPagoAnticipado			:= 'PAGO DE CREDITO CON MUCHOS DIAS DE ANTICIPACION';						-- Descripcion Pago de CrÃ©dito con mnuchos dias de anticipacion --
	SET DescriPagoMayoQueExig			:= 'PAGO DE CREDITO MAYOR A EXIGIBLE';										-- Descripcion Pago de Credito Mayor a Exigible --
	SET Desc_LiqAntXDias				:= 'CREDITO LIQUIDADO ANTICIPADAMENTE POR DIAS.';							-- Descripcion Credito liquidado anticipadamente --
	SET Desc_PagoSupExig				:= 'PAGO DE CREDITO ANTICIPADO SUPERIOR AL EXIGIBLE.';										-- Descripcion Pago de Credito Superior al Exigible.
	SET DiaUnoDelMes					:= '01';				-- Constante 01 sirve para concatenar la fecha inicio de mes --
	SET TipoMov_Efectivo				:= 'E';					-- Forma de pago efectivo --
	SET Entero_Cero						:= 0;					-- Constante Cero
	SET Entero_Uno						:= 1;					-- Constante Uno
	SET Esta_Aplicado					:= 'A';					-- Estatus aplicado --
	SET Esta_Autorizado					:= 'A'; 				-- Estatus Autorizado --
	SET EstatusDesembolso				:= 'D';					-- Estatus desembolsado de una reestructura o renovacion
	SET EstatusOpeCapturada				:= 1;					-- Estatus de Operacion Capturada
	SET FechaVacia						:= '1900-01-01';		-- Constante 1900-01-01 --
	SET For_TipoCredito					:= 3;					-- Tipo Instrumento Monetario Credito --
	SET For_TipoDocumento				:= 2;					-- Tipo Instrumento Monetario Documento --
	SET For_TipoEfectivo				:= 1; 					-- Tipo Instrumento Monetario Efectivo --
	SET For_TipoTransferencia			:= 4;					-- Tipo Instrumento Monetario Transferencia --
	SET MonedaDolares					:= 1;					-- Moneda Dolares
	SET MotivoAlertaAut 				:= 'SIS1';				-- Clave de motivo de alerta automatica segun PLDCATMOTIVINU
	SET MotivoAlertaTran 				:= 'SIS2';				-- Clave de motivo de alerta automatica segun PLDCATMOTIVINU
	SET Nat_Abono						:= 'A';					-- Naturaleza Abono
	SET Nat_Cargo						:= 'C';					-- Naturaleza Cargo
	SET NaturaOpeSuma 					:= 'S';					-- Naturaleza Operacion Suma, se usa para obtener operaciones mensuales
	SET NombreDefaultSistema			:= 'SAFI';				-- Nombre default del sistema
	SET OpeCNBVDep						:= '01';				-- Tipo Operacion Deposito segun la CNBV --
	SET Par_ErrMen						:= Cadena_Vacia;		-- Mensaje de error vacio --
	SET Par_NumErr						:= 1;					-- Numero error 1
	SET ParametroVigente				:= 'V';					-- Indica Estatus Vigente en pantalla
	SET Str_NO							:= 'N';					-- Constante N
	SET Str_SI							:= 'S';					-- Constante S
	SET TipoOpePagoCredito				:= '09';				-- Tipo de operacion Pago de Credito
	SET TipoOpeLiqCredito				:= '41';				-- Tipo de operacion Liquidación de Credito
	SET TipoPersonaSAFICTE				:= 'CTE';				-- Tipo de Persona Cliente
	SET Trans_EntreCtas					:= 12;					-- Tipo de Moviemiento Transferencia entre Cuentas --
	SET TipoMov_Transferencia			:= 'T';					-- Tipo de deposito Transferencia --
	SET ValorDlsPorMes					:= 10000;				-- Valor Dolares por mes
	SET ValorDlsPorOperacion			:= 500;					-- Valor Dolares por Operacion --
	SET TipoSocap						:= 'scap';				-- Tipo SOCAP, corresponde a la tabla TIPOSINSTITUCION
	SET TipoSofipo						:= 'sofipo';			-- Tipo SOFIPO, corresponde a la tabla TIPOSINSTITUCION
	SET TipoSofom						:= 'sofom';				-- Tipo SOFOM, corresponde a la tabla TIPOSINSTITUCION

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-PLDOPEINUSALERTPRO[',@Var_SQLState,'-' , @Var_SQLMessage,']');
			SET VarControl := 'sqlException';
		END;

		# 1. ASIGNAR VALORES A LAS VARIABLES
		-- Obtener Valores de la Institucion
		SET	Var_EmpresaDefault		:= (SELECT MAX(EmpresaDefault) FROM PARAMETROSSIS );
		SET	Var_Institucion			:= (SELECT InstitucionID FROM PARAMETROSSIS WHERE  EmpresaID = Var_EmpresaDefault);
		SET	Var_NombreInstitucion	:= (SELECT NombreCorto FROM INSTITUCIONES WHERE InstitucionID = Var_Institucion);
		SET Var_NombreCorto			:= (SELECT Tip.NombreCorto FROM PARAMETROSSIS Par
											INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
											INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID);
		SET Var_EntidadRegulada		:= (SELECT Tip.EntidadRegulada FROM PARAMETROSSIS Par
											INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
											INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID);
		SET	Var_NombreInstitucion	:= IFNULL(Var_NombreInstitucion, NombreDefaultSistema);
		SET	Var_NombreCorto			:= IFNULL(Var_NombreCorto, Cadena_Vacia);
		SET	Var_EntidadRegulada		:= IFNULL(Var_EntidadRegulada, Cadena_Vacia);
		-- Calcular la Fecha de Inicio y Fin del Mes en curso a partir de la Fecha de sistema
		SET	Var_FecIniMes			:= DATE(CONCAT(CAST(YEAR(Par_FechaActual) AS CHAR),'-',CAST(MONTH(Par_FechaActual) AS CHAR),'-01'));
		SET Var_FecFinMes           := LAST_DAY(Par_FechaActual);

		DROP TABLE IF EXISTS TMPPLDMOVIMIENTOSCTA;
		CREATE TABLE `TMPPLDMOVIMIENTOSCTA` (
			IDPLDMov INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
			`SucursalOrigen` int(11) DEFAULT NULL COMMENT 'Clave de la sucursal del personal involucrado\nSegun el Catalogo\nSUCURSALES',
			`ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
			`NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
			`SoloNombres` varchar(500) DEFAULT NULL COMMENT 'Primer Nombre, Segundo Nombre y Tercer Nombre',
			`ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del Cliente\n',
			`ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del Cliente\n',
			`Fecha` date NOT NULL COMMENT 'fecha del movimiento',
			  `CuentaAhoID` bigint(12) DEFAULT NULL,
			  `TipoMovAhoID` char(4) NOT NULL COMMENT 'ID del Tipo de \nMovimiento de \nAhorro\n',
			  `TipoOpeCNBV` char(2) DEFAULT NULL COMMENT 'Tipo de Operacion de Acuerdo a Catalogo de CNBV\n01=DepÃ³sito\n02=Retiro\n03=Compra Divisas\n04=Venta Divisas\n05=Cheques de Caja\n06=Giros\n07=Ordenes de Pago\n08=Otorgamiento de CrÃ©dito\n09=Pago de CrÃ©dito\n10=Pago de Primas u OperaciÃ³n de Reaseguro\n11=Aportac',
			  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion del\nTipo de Movimiento\nDe Ahorro',
			  `DescripcionMov` varchar(150) NOT NULL COMMENT 'Descripcion del movimiento en estado de cuenta',
			  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del Movimiento C cargo A abono',
			  `CantidadMov` decimal(12,2) DEFAULT NULL,
			  `MonedaID` int(11) NOT NULL,
			  `DetecPLD` char(1) DEFAULT 'N' COMMENT 'Aplica la opeacion para la detección de operaciones Inusuales PLD',
			  `EsEfectivo` char(1) NOT NULL COMMENT 'Indica si el tipo de \nMovimiento\nes en Efectivo\n\nSi - '' S ''\nNo - ''N''',
			  `EsCredito` char(1) DEFAULT 'N' COMMENT 'Es Instrumento de Crédito',
			  `EsDocumentos` char(1) DEFAULT 'N' COMMENT 'Define si la operacion es por el instrumento de Documentos.\nS:Si N:No',
			  `EsTransferencia` char(1) DEFAULT 'N' COMMENT 'Define si el tipo de movimiento es por transferencia.',
			  `DepositosMax` decimal(16,2) DEFAULT NULL COMMENT 'Monto Máximo de Abonos y Retiros por Operación.',
			  `RetirosMax` decimal(16,2) DEFAULT NULL COMMENT 'Número Máximo de Transacciones',
			  `NumDepositos` int(11) DEFAULT NULL COMMENT 'Número de Depositos Maximos realizados en un periodo de un Mes',
			  `NumRetiros` int(11) DEFAULT NULL COMMENT 'Número de Retiros Maximos realizados en un periodo de un Mes',
			  `NumeroMov` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
			  `DepositosHolg` decimal(16,2) DEFAULT NULL COMMENT 'Monto Máximo de Abonos y Retiros por Operación.',
			  `DetectExcDepositos` CHAR(1) DEFAULT NULL COMMENT 'Deteccion Monto de Depositos',
			  `SumCantidadDepoMov` decimal(18,2) DEFAULT NULL,
			  `RetirosMaxHolg` decimal(16,2) DEFAULT NULL COMMENT 'Número Máximo de Transacciones',
			  `DetectExcRetiros` CHAR(1) DEFAULT NULL COMMENT 'Deteccion Monto de Retiros',
			  `SumCantidadRetoMov` decimal(18,2) DEFAULT NULL,
			  `NumDepositosHolg` DECIMAL(12,2) DEFAULT NULL COMMENT 'Número de Depositos Maximos realizados en un periodo de un Mes',
			  `DetectNDepositos` CHAR(1) DEFAULT NULL COMMENT 'Deteccion Numero de Depositos',
			  `NDeposito` int(5) NOT NULL DEFAULT '0',
			  `NumRetirosHolg` DECIMAL(12,2) DEFAULT NULL COMMENT 'Número de Retiros Maximos realizados en un periodo de un Mes',
			  `DetectNRetiros` CHAR(1) DEFAULT NULL COMMENT 'Deteccion Numero de Retiros',
			  `NRetiro` int(5) NOT NULL DEFAULT '0',
			   KEY `IDX_TMPPLDMOVIMIENTOSCTA_1` (`ClienteID`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1;

		# Inserta los movimientos de la CTA de todo el mes
		INSERT INTO TMPPLDMOVIMIENTOSCTA(
			ClienteID,			NDeposito,  		NRetiro,  			CuentaAhoID, 		TipoMovAhoID,
			Descripcion,		DescripcionMov,  	NatMovimiento,  	CantidadMov,  		DetecPLD,
			EsEfectivo,  		EsCredito,  		EsDocumentos,  		EsTransferencia,  DepositosMax,
			DepositosHolg,  	RetirosMax,  		RetirosMaxHolg,		NumDepositos,		NumDepositosHolg,
			NumRetiros,  		NumRetirosHolg,		NumeroMov,			Fecha,				MonedaID,
			TipoOpeCNBV)
		SELECT
			CTA.ClienteID,		99999 AS NDeposito,	99999 AS NRetiro,	MOV.CuentaAhoID,	TIP.TipoMovAhoID,
			TIP.Descripcion,	MOV.DescripcionMov,	MOV.NatMovimiento,	MOV.CantidadMov,	TIP.DetecPLD,
			TIP.EsEfectivo,		TIP.EsCredito,		TIP.EsDocumentos,	TIP.EsTransferencia,0,
			0,					0,					0,					0,					0,
			0,					0,					MOV.NumeroMov,		MOV.Fecha,			MOV.MonedaID,
			TIP.TipoOpeCNBV
		FROM CUENTASAHOMOV AS MOV
		INNER JOIN CUENTASAHO AS CTA ON MOV.CuentaAhoID = CTA.CuentaAhoID
		INNER JOIN TIPOSMOVSAHO AS TIP ON MOV.TipoMovAhoID=TIP.TipoMovAhoID
		WHERE MOV.Fecha BETWEEN Var_FecIniMes AND Par_FechaActual
		AND TIP.DetecPLD = 'S'
		ORDER BY CTA.ClienteID,MOV.Fecha, MOV.NumeroMov, MOV.FechaActual;

		UPDATE CLIENTES SET NivelRiesgo = 'B' WHERE NivelRiesgo = '' OR NivelRiesgo IS NULL;

		DROP TABLE IF EXISTS TMPPLDHISPERFDETEC;
		CREATE TABLE `TMPPLDHISPERFDETEC` (
		  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente ID',
		  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de transaccion del Registro',
		  PRIMARY KEY (`ClienteID`,`TransaccionID`),
		  KEY `IDX_TMPPLDHISPERFDETEC_1` (`ClienteID`,`TransaccionID`),
		  KEY `IDX_TMPPLDHISPERFDETEC_2` (`TransaccionID`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena el historico del perfil transaccional';

		INSERT INTO TMPPLDHISPERFDETEC(
			ClienteID,    		TransaccionID)
		SELECT
			PLD.ClienteID,		MAX(PLD.TransaccionID)
		FROM PLDHISPERFILTRANS AS PLD
		WHERE PLD.FechaAct <= Par_FechaActual
		GROUP BY PLD.ClienteID;

		# Actuazimos datos del Perfil Transaccional
		UPDATE TMPPLDMOVIMIENTOSCTA AS CTA INNER JOIN CLIENTES AS CTE ON CTA.ClienteID = CTE.ClienteID
			INNER JOIN PLDHISPERFILTRANS AS PER ON CTA.ClienteID = PER.ClienteID
			INNER JOIN TMPPLDHISPERFDETEC AS HIS ON PER.ClienteID = HIS.ClienteID AND PER.TransaccionID = HIS.TransaccionID
			INNER JOIN PLDPARALEOPINUS AS PAR ON CTE.TipoPersona = PAR.TipoPersona AND CTE.NivelRiesgo = PAR.NivelRiesgo SET
			CTA.DepositosMax = PER.DepositosMax,
			CTA.DepositosHolg = (PER.DepositosMax * (1+(PAR.VarPTrans/100))),
			CTA.RetirosMax = PER.RetirosMax,
			CTA.RetirosMaxHolg = (PER.RetirosMax * (1+(PAR.VarPagos/100))),
			CTA.NumDepositos = PER.NumDepositos,
			CTA.NumDepositosHolg = (PER.NumDepositos * (1+(PAR.VarNumDep/100))),
			CTA.NumRetiros = PER.NumRetiros,
			CTA.NumRetirosHolg = (PER.NumRetiros * (1+(PAR.VarNumRet/100)))
			WHERE
			CTA.ClienteID = CTE.ClienteID;

		SET @NDeposito := 0;
		SET @NRetiro := 0;
		SET @NClienteID := 0;
		SET @MontoDepo := 0;
		SET @MontoReto := 0;
		DROP TABLE IF EXISTS TMPPLDNUMDEPORETO;
		CREATE TEMPORARY TABLE TMPPLDNUMDEPORETO
		SELECT CTA.IDPLDMov,CTA.ClienteID, CTA.NatMovimiento,
		CTA.CantidadMov,
		IF(@NClienteID!=CTA.ClienteID,IF(CTA.NatMovimiento = 'A',@NDeposito := 1,@NDeposito := 0),IF(CTA.NatMovimiento = 'A',@NDeposito := @NDeposito+1,0)) AS NDeposito,
		IF(@NClienteID!=CTA.ClienteID,IF(CTA.NatMovimiento = 'A',@MontoDepo := CTA.CantidadMov,@MontoDepo := 0),IF(CTA.NatMovimiento = 'A',@MontoDepo := @MontoDepo+CTA.CantidadMov,0)) AS MontoDepo,
		IF(@NClienteID!=CTA.ClienteID,IF(CTA.NatMovimiento = 'C',@NRetiro := 1,@NRetiro := 0),IF(CTA.NatMovimiento = 'C',@NRetiro := @NRetiro+1,0)) AS NRetiro,
		IF(@NClienteID!=CTA.ClienteID,IF(CTA.NatMovimiento = 'C',@MontoReto := CTA.CantidadMov,@MontoReto := 0),IF(CTA.NatMovimiento = 'C',@MontoReto := @MontoReto+CTA.CantidadMov,0)) AS MontoReto,
		IF(@NClienteID != CTA.ClienteID,@NClienteID := CTA.ClienteID,@NClienteID) AS CtaAnterior
		FROM TMPPLDMOVIMIENTOSCTA AS CTA;

		ALTER TABLE `TMPPLDNUMDEPORETO`
			ADD COLUMN `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;

		UPDATE TMPPLDMOVIMIENTOSCTA AS CTA INNER JOIN TMPPLDNUMDEPORETO AS TMP ON CTA.IDPLDMov = TMP.IDPLDMov SET
		CTA.NDeposito = TMP.NDeposito,
		CTA.NRetiro = TMP.NRetiro,
		CTA.DetectNDepositos = IF(TMP.NDeposito>CTA.NumDepositosHolg,'S','N'),
		CTA.DetectNRetiros = IF(TMP.NRetiro>CTA.NumRetirosHolg,'S','N'),
		CTA.DetectExcDepositos = IF(TMP.MontoDepo>CTA.DepositosHolg,'S','N'),
		CTA.SumCantidadDepoMov = IF(TMP.MontoDepo>CTA.DepositosHolg,MontoDepo,0),
		CTA.DetectExcRetiros = IF(TMP.MontoReto>CTA.RetirosMaxHolg,'S','N'),
		CTA.SumCantidadRetoMov = IF(TMP.MontoReto>CTA.RetirosMaxHolg,MontoReto,0);

		UPDATE TMPPLDMOVIMIENTOSCTA AS CTA INNER JOIN CLIENTES AS CTE ON CTA.ClienteID = CTE.ClienteID SET
		CTA.SucursalOrigen = CTE.SucursalOrigen,
		CTA.NombreCompleto = CTE.NombreCompleto,
		CTA.SoloNombres = CTE.SoloNombres,
		CTA.ApellidoPaterno = CTE.ApellidoPaterno,
		CTA.ApellidoMaterno = CTE.ApellidoMaterno
		;

		# Eliminamos todas las que no superen lo declarado en el perfil transaccional + holgura
		DROP TABLE IF EXISTS TMPREGOPEINU;
		CREATE  TABLE TMPREGOPEINU(
			Tmp_OpeInisial 				INT(11) NOT NULL AUTO_INCREMENT PRIMARY key,
			Tmp_Fecha					DATE,
			Tmp_ClaveRegistra			INT(11),
			Tmp_NombreReg				VARCHAR(70),
			Tmp_CatProcedIntID			CHAR(10),
			Tmp_CatMotivInuID			CHAR(4),
			Tmp_FechaDeteccion			DATE,
			Tmp_SucursalID				INT(11),
			Tmp_ClavePersonaInv			INT(11),
			Tmp_NomPersonaInv			VARCHAR(250),
			Tmp_EmpInvolucrado			CHAR(1),
			Tmp_Frecuencia				CHAR(1),
			Tmp_DesFrecuencia			CHAR(1),
			Tmp_DesOperacion			VARCHAR(180),
			Tmp_Estatus					INT(11),
			Tmp_ComentarioOC			CHAR(1),
			Tmp_FechaCierre				DATE,
			Tmp_CreditoID				BIGINT(12),
			Tmp_CuentaID				BIGINT(12),
			Tmp_TransaccionOpe			INT(11),
			Tmp_NaturalezaOpe			CHAR(1),
			Tmp_MontoOperacion			DECIMAL(18,2),
			Tmp_MonedaID				INT(11),
			Tmp_TipoOpeCNBV				CHAR(2),
			Tmp_FormaPago				CHAR(1),
			Tmp_TipoPersonaSAFI 		VARCHAR(3) ,
			Tmp_NombresPersonaInv 		VARCHAR(150),
			Tmp_ApPaternoPersonaInv		VARCHAR(50),
			Tmp_ApMaternoPersonaInv		VARCHAR(50)) ;

		# Insertamos todas las operaciones que superaron lo declarado en el perfil transaccion por deposito.
		# DEPOSITOS MAX
		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		SELECT
			TMP.Fecha,						ClaveSistemaAut,				Var_NombreInstitucion,							AlertasAutomati,								MotivoAlertaAut,
			DATE(Par_FechaActual),			TMP.SucursalOrigen,				TMP.ClienteID,									TMP.NombreCompleto,								Cadena_Vacia,
			Str_NO,							Cadena_Vacia,					LEFT(Des_PerfilExcedeMontoDepositos,180),		EstatusOpeCapturada,							Cadena_Vacia,
			FechaVacia,						Entero_Cero,					TMP.CuentaAhoID,								TMP.NumeroMov,									TMP.NatMovimiento,
			TMP.CantidadMov,				TMP.MonedaID,					TMP.TipoOpeCNBV,								CASE
																																WHEN TMP.EsTransferencia = 'S' THEN 'T'
																																WHEN TMP.EsDocumentos = 'S' THEN 'H'
																																WHEN TMP.EsCredito = 'S' THEN 'C'
																																WHEN TMP.EsEfectivo = 'S' THEN 'E'
																																ELSE 'E'
																																END,	TipoPersonaSAFICTE,
			TMP.SoloNombres,				TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM TMPPLDMOVIMIENTOSCTA AS TMP
				WHERE DetectExcDepositos = 'S';

		#RETIROS MAX
		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,									Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,							Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,								Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,									Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,								Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		SELECT
			TMP.Fecha,					ClaveSistemaAut,				Var_NombreInstitucion,							AlertasAutomati,								MotivoAlertaAut,
			DATE(Par_FechaActual),		TMP.SucursalOrigen,				TMP.ClienteID,									TMP.NombreCompleto,								Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					LEFT(Des_PerfilExcedeMontoRetiros,180),		EstatusOpeCapturada,							Cadena_Vacia,
			FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,								TMP.NumeroMov,									TMP.NatMovimiento,
			TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,								CASE
																															WHEN TMP.EsTransferencia = 'S' THEN 'T'
																															WHEN TMP.EsDocumentos = 'S' THEN 'H'
																															WHEN TMP.EsCredito = 'S' THEN 'C'
																															WHEN TMP.EsEfectivo = 'S' THEN 'E'
																															ELSE 'E'
																															END,	TipoPersonaSAFICTE,
			TMP.SoloNombres,				TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM TMPPLDMOVIMIENTOSCTA AS TMP
				WHERE DetectExcRetiros = 'S';

		#NUMERO DE DEPOSITOS
		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,									Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,							Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,								Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,									Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,								Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		SELECT
			TMP.Fecha,					ClaveSistemaAut,				Var_NombreInstitucion,							AlertasAutomati,								MotivoAlertaAut,
			DATE(Par_FechaActual),		TMP.SucursalOrigen,				TMP.ClienteID,									TMP.NombreCompleto,								Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					LEFT(Des_PerfilExcedeNumDepositos,180),		EstatusOpeCapturada,							Cadena_Vacia,
			FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,								TMP.NumeroMov,									TMP.NatMovimiento,
			TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,								CASE
																															WHEN TMP.EsTransferencia = 'S' THEN 'T'
																															WHEN TMP.EsDocumentos = 'S' THEN 'H'
																															WHEN TMP.EsCredito = 'S' THEN 'C'
																															WHEN TMP.EsEfectivo = 'S' THEN 'E'
																															ELSE 'E'
																															END,	TipoPersonaSAFICTE,
			TMP.SoloNombres,				TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM TMPPLDMOVIMIENTOSCTA AS TMP
				WHERE DetectNDepositos = 'S';

		#NUMERO DE RETIROS
		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,									Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,							Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,								Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,									Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,								Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		SELECT
			TMP.Fecha,					ClaveSistemaAut,				Var_NombreInstitucion,							AlertasAutomati,								MotivoAlertaAut,
			DATE(Par_FechaActual),		TMP.SucursalOrigen,				TMP.ClienteID,									TMP.NombreCompleto,								Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					LEFT(Des_PerfilExcedeNumRetiros,180),		EstatusOpeCapturada,							Cadena_Vacia,
			FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,								TMP.NumeroMov,									TMP.NatMovimiento,
			TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,								CASE
																															WHEN TMP.EsTransferencia = 'S' THEN 'T'
																															WHEN TMP.EsDocumentos = 'S' THEN 'H'
																															WHEN TMP.EsCredito = 'S' THEN 'C'
																															WHEN TMP.EsEfectivo = 'S' THEN 'E'
																															ELSE 'E'
																															END,	TipoPersonaSAFICTE,
			TMP.SoloNombres,				TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM TMPPLDMOVIMIENTOSCTA AS TMP
				WHERE DetectNRetiros = 'S';

		# Plazo Mínimo de Pago Anticipado en Cuotas Exigibles --------------------------------------------------------------------------
		# ------------------------------------------------------------------------------------------------------------------------------
		# Se Registran como alertas, todos los pagos que se registraton  'W' dias antes de su exigibilidad
		# Siempre y cuando el monto total de pago anticipado supere el monto del perfil transaccional	mas el porcentaje de tolerancia
		DROP TABLE IF EXISTS TMPPLDDETECDIASMAX;
		CREATE TABLE `TMPPLDDETECDIASMAX` (
		  `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
		  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
		  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'ID de la Cuenta',
		  `PorcDiasMax` decimal(14,2) DEFAULT '0.00' COMMENT 'Porcentaje de holgura para Dias de pago anticipado.',
		  `AmortizacionID` int(4) NOT NULL COMMENT 'No\nAmortizacion',
		  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
		  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio\n',
		  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha Exigible\nde Pago\n',
		  `FechaPago` date NOT NULL COMMENT 'Fecha de\nVencimiento',
		  `FormaPago` char(1) DEFAULT NULL COMMENT 'Guarda forma de pago \nE = Efectivo\nC = Cargo a cuenta',
		  `Dias` bigint(21) DEFAULT NULL,
		  `DiasAnt` bigint(21) DEFAULT NULL,
		  `DiasHolgura` decimal(35,2) DEFAULT NULL,
		  KEY `IDX_TMPPLDDETECDIASMAX_1` (`Transaccion`),
		  KEY `IDX_TMPPLDDETECDIASMAX_2` (`ClienteID`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1;

		INSERT INTO TMPPLDDETECDIASMAX(
			Transaccion,		CreditoID,		CuentaAhoID,		PorcDiasMax,		AmortizacionID,
			ClienteID,			FechaInicio,	FechaExigible,		FechaPago,			Dias,
			DiasAnt,			DiasHolgura,	FormaPago)
		SELECT
			DET.Transaccion,	DET.CreditoID,		CRED.CuentaID,	PAR.PorcDiasMax,	AMO.AmortizacionID,	CRED.ClienteID,
			AMO.FechaInicio,	AMO.FechaExigible,	DET.FechaPago,
			TIMESTAMPDIFF(DAY,AMO.FechaInicio,AMO.FechaExigible) AS Dias,
			TIMESTAMPDIFF(DAY,DET.FechaPago,AMO.FechaExigible) AS DiasAnt,
			ROUND(TIMESTAMPDIFF(DAY,AMO.FechaInicio,AMO.FechaExigible)*((PAR.PorcDiasMax/100)),2) AS DiasHolgura,
			DET.FormaPago
		FROM DETALLEPAGCRE AS DET
			INNER JOIN AMORTICREDITO AS AMO ON DET.CreditoID = AMO.CreditoID AND DET.AmortizacionID = AMO.AmortizacionID
			INNER JOIN CREDITOS AS CRED ON DET.CreditoID = CRED.CreditoID
			INNER JOIN CLIENTES AS CTE ON CRED.ClienteID = CTE.ClienteID
			INNER JOIN PLDPARALEOPINUS AS PAR ON CTE.TipoPersona = PAR.TipoPersona AND CTE.NivelRiesgo = PAR.NivelRiesgo
		WHERE FechaPago = Par_FechaActual
			AND TIMESTAMPDIFF(DAY,DET.FechaPago,AMO.FechaExigible) >0;

		DROP TABLE IF EXISTS TMPPLDDIASANTICIPADO;
		CREATE TABLE `TMPPLDDIASANTICIPADO` (
		  `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
		  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
		  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'ID de la Cuenta',
		  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
		  KEY `IDX_TMPPLDDIASANTICIPADO_1` (`Transaccion`,CreditoID)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1;

		INSERT INTO TMPPLDDIASANTICIPADO(
			Transaccion, CreditoID,CuentaAhoID, ClienteID)
		SELECT DISTINCT
			Transaccion, CreditoID,CuentaAhoID, ClienteID
		FROM TMPPLDDETECDIASMAX
			WHERE DiasAnt > DiasHolgura;

		DROP TABLE IF EXISTS TMPPLDMONTOTOTALCRED;
		CREATE TABLE `TMPPLDMONTOTOTALCRED` (
		  `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
		  `MontoTotal` decimal(14,2) DEFAULT NULL COMMENT 'Monto Total Pagado',
		  `FormaPago` char(1) DEFAULT NULL COMMENT 'Guarda forma de pago \nE = Efectivo\nC = Cargo a cuenta',
		  KEY `IDX_TMPPLDMONTOTOTALCRED_1` (`Transaccion`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1;

		INSERT INTO TMPPLDMONTOTOTALCRED(
			Transaccion, MontoTotal,		FormaPago)
		SELECT
			Transaccion, SUM(MontoTotPago),	MAX(FormaPago)
		FROM DETALLEPAGCRE WHERE Transaccion IN (SELECT DISTINCT Transaccion FROM TMPPLDDIASANTICIPADO)
		GROUP BY Transaccion;

		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		SELECT
			Par_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			Par_FechaActual,			CLI.SucursalOrigen,				CLI.ClienteID,						CLI.NombreCompleto,			Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					DescriPagoAnticipado,				EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					TMP.CreditoID,					TMP.CuentaAhoID,					TMP.Transaccion,			Nat_Abono,
			TOTAL.MontoTotal,			1,								TipoOpePagoCredito,					IF(TOTAL.FormaPago=TipoMov_Efectivo,TipoMov_Efectivo,TipoMov_Transferencia),TipoPersonaSAFICTE,
			CLI.SoloNombres,			CLI.ApellidoPaterno,			CLI.ApellidoMaterno
		FROM TMPPLDDIASANTICIPADO AS TMP
			INNER JOIN TMPPLDMONTOTOTALCRED AS TOTAL ON TMP.Transaccion = TOTAL.Transaccion
			INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
		WHERE TMP.CreditoID NOT IN (SELECT CreditoOrigenID FROM REESTRUCCREDITO
													WHERE FechaRegistro = Par_FechaActual
														AND EstatusReest = EstatusDesembolso);

		/** LIQUIDACIÓN ANTICIPADA.
		 ** SE GENERAN ALERTAS DE ACUERDO AL PORCENTAJE RESPECTO AL MONTO TOTAL DEL CRÉDITO
		 ** Y AL PORCENTAJE EN LOS DÍAS RESTANTES DE LA FECHA DE PAGO A LA FECHA DE VENCIMIENTO.
		 ** AMBAS ALERTAS SON INDEPENDIENTES.
		 ***/
		DELETE FROM TMPPLDLIQUIDAANTTRAN;
		DELETE FROM TMPPLDCREDMONTOLA;

		INSERT INTO TMPPLDLIQUIDAANTTRAN(
			Transaccion,			CreditoID,				CuentaAhoID,
			ClienteID,				TotalPago,				NumTransaccion,
			FormaPago,				MontoTotal,				PlazoDias,
			PlazoAlPago,			MontoLimite,			PlazoLimite,
			PorcLiqAnt,				PorcDiasLiqAnt,			AlertaXMonto,
			AlertaXDias)
		SELECT
			MAX(DET.Transaccion),	CRED.CreditoID,			MAX(CRED.CuentaID),
			MAX(CRED.ClienteID),	SUM(DET.MontoTotPago),	Aud_NumTransaccion,

			MAX(DET.FormaPago),		Entero_Cero,
			DATEDIFF(MAX(CRED.FechaVencimien),MAX(CRED.FechaInicio)),

			DATEDIFF(MAX(CRED.FechaVencimien),MAX(DET.FechaPago)),
			Entero_Cero,			Entero_Cero,

			MAX(PAR.PorcLiqAnt),	MAX(PAR.PorcDiasLiqAnt),Str_NO,
			Str_NO
		FROM CREDITOS AS CRED
			INNER JOIN DETALLEPAGCRE AS DET ON CRED.CreditoID = DET.CreditoID
			INNER JOIN CLIENTES AS CTE ON CRED.ClienteID = CTE.ClienteID
			INNER JOIN PLDPARALEOPINUS AS PAR ON CTE.TipoPersona = PAR.TipoPersona AND CTE.NivelRiesgo = PAR.NivelRiesgo
		WHERE CRED.Estatus = 'P'
			AND CRED.FechaVencimien > CRED.FechTerminacion
			AND CRED.FechTerminacion = Par_FechaActual
			AND DET.FechaPago = Par_FechaActual
			AND PAR.LiquidAnticipad = Str_SI
		GROUP BY CRED.CreditoID;

		# SE OBTIENE EL MONTO TOTAL DE LOS CRÉDITOS (CAPITAL, INTERÉS E IVA).
		INSERT INTO TMPPLDCREDMONTOLA(
			CreditoID,		MontoTotal,		NumTransaccion)
		SELECT
			AMO.CreditoID,
			SUM(IFNULL(AMO.Capital,Entero_Cero) + IFNULL(AMO.Interes,Entero_Cero) + IFNULL(AMO.IVAInteres,Entero_Cero) +
				IFNULL(AMO.MontoSeguroCuota,Entero_Cero) + IFNULL(AMO.IVASeguroCuota,Entero_Cero)),
			Aud_NumTransaccion
		FROM TMPPLDLIQUIDAANTTRAN TMP
			INNER JOIN AMORTICREDITO AS AMO ON TMP.CreditoID = AMO.CreditoID
		WHERE TMP.NumTransaccion = Aud_NumTransaccion
		GROUP BY AMO.CreditoID;

		UPDATE TMPPLDLIQUIDAANTTRAN LQA
			INNER JOIN TMPPLDCREDMONTOLA TMP ON LQA.CreditoID = TMP.CreditoID
		SET
			LQA.MontoTotal		= TMP.MontoTotal,
			LQA.MontoLimite		= ROUND(TMP.MontoTotal*(LQA.PorcLiqAnt/100),2),
			LQA.PlazoLimite		= ROUND(LQA.PlazoDias*(LQA.PorcDiasLiqAnt/100)),
			LQA.AlertaXMonto	= IF(LQA.TotalPago>ROUND(TMP.MontoTotal*(LQA.PorcLiqAnt/100),2),Str_SI,Str_NO),
			LQA.AlertaXDias		= IF(LQA.PlazoAlPago>ROUND(LQA.PlazoDias*(LQA.PorcDiasLiqAnt/100)),Str_SI,Str_NO)
		WHERE LQA.NumTransaccion = Aud_NumTransaccion;

		# ALERTA POR CREDITO LIQUIDADO ANTICIPADAMENTE POR MONTO.
		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		SELECT
			Par_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			Par_FechaActual,			CLI.SucursalOrigen,				CLI.ClienteID,						CLI.NombreCompleto,			Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					DescriLiquidAnt,					EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					TMP.CreditoID,					TMP.CuentaAhoID,					TMP.Transaccion,			Nat_Abono,
			TMP.TotalPago,				1,								TipoOpeLiqCredito,					IF(TMP.FormaPago=TipoMov_Efectivo,TipoMov_Efectivo,TipoMov_Transferencia),TipoPersonaSAFICTE,
			CLI.SoloNombres,			CLI.ApellidoPaterno,			CLI.ApellidoMaterno
		FROM TMPPLDLIQUIDAANTTRAN AS TMP
			INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
		WHERE TMP.AlertaXMonto = Str_SI
			AND TMP.NumTransaccion = Aud_NumTransaccion;

		# ALERTA POR CREDITO LIQUIDADO ANTICIPADAMENTE POR DIAS.
		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		SELECT
			Par_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			Par_FechaActual,			CLI.SucursalOrigen,				CLI.ClienteID,						CLI.NombreCompleto,			Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					Desc_LiqAntXDias,					EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					TMP.CreditoID,					TMP.CuentaAhoID,					TMP.Transaccion,			Nat_Abono,
			TMP.TotalPago,				1,								TipoOpeLiqCredito,					IF(TMP.FormaPago=TipoMov_Efectivo,TipoMov_Efectivo,TipoMov_Transferencia),TipoPersonaSAFICTE,
			CLI.SoloNombres,			CLI.ApellidoPaterno,			CLI.ApellidoMaterno
		FROM TMPPLDLIQUIDAANTTRAN AS TMP
			INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
		WHERE TMP.AlertaXDias = Str_SI
			AND TMP.NumTransaccion = Aud_NumTransaccion;

		DELETE FROM TMPPLDOPEINUMAYEXITRAN;
		DELETE FROM TMPPLDEXIGIBLETRAN;
		DELETE FROM TMPTOTALPAGOTRAN;
		-- En caso de que se evaluen los creditos --
		-- Tabla Temporal de Detalle de Pagos de Credito realizados el dia actual
		/*PAGO MAYOR AL EXIGIBLE ---------------------------------------------------------------------------------------- */
		/*--------------------------------------------------------------------------------------------------------------- */
		INSERT INTO TMPPLDOPEINUMAYEXITRAN (
			Transaccion,	CreditoID,	ClienteID,		CuentaAhoID,	AmortizacionID,
			MontoCuota,		VarPagos,	MontoHolgura,	MontoTotPago,	Estatus,
			NumTransaccion,	FormaPago,	PorcAmoAnt,		MontoHolguraPA,	AlertaXCuota1)
		SELECT
			DET.Transaccion,	DET.CreditoID,	CRED.ClienteID,	CRED.CuentaID,	DET.AmortizacionID,
			ROUND(AMO.Capital + AMO.Interes + AMO.IVAInteres + IFNULL(AMO.MontoSeguroCuota,0) + IFNULL(AMO.IVASeguroCuota,0),2) AS MontoCuota,
			PAR.VarPagos,
			ROUND(ROUND(AMO.Capital + AMO.Interes + AMO.IVAInteres + IFNULL(AMO.MontoSeguroCuota,0) + IFNULL(AMO.IVASeguroCuota,0),2) * (1+(PAR.PorcAmoAnt)/100),2) AS MontoHolgura,
			DET.MontoTotPago,	AMO.Estatus,	Aud_NumTransaccion,		DET.FormaPago,
			PAR.PorcAmoAnt,
			ROUND(ROUND(AMO.Capital + AMO.Interes + AMO.IVAInteres + IFNULL(AMO.MontoSeguroCuota,0) + IFNULL(AMO.IVASeguroCuota,0),2) * (1+(PAR.PorcAmoAnt)/100),2) AS MontoHolguraPA,
			IF(DET.MontoTotPago > ROUND(ROUND(AMO.Capital + AMO.Interes + AMO.IVAInteres + IFNULL(AMO.MontoSeguroCuota,0) + IFNULL(AMO.IVASeguroCuota,0),2) * (PAR.VarPagos/100),2),
				Str_SI,Str_NO) AS AlertaXCuota1
		FROM DETALLEPAGCRE AS DET
			INNER JOIN AMORTICREDITO AS AMO ON DET.CreditoID = AMO.CreditoID AND DET.AmortizacionID = AMO.AmortizacionID
			INNER JOIN CREDITOS AS CRED ON DET.CreditoID = CRED.CreditoID
			INNER JOIN CLIENTES AS CLI ON CRED.ClienteID = CLI.ClienteID
			INNER JOIN PLDPARALEOPINUS AS PAR ON CLI.TipoPersona = PAR.TipoPersona AND CLI.NivelRiesgo = PAR.NivelRiesgo
		WHERE DET.FechaPago = Par_FechaActual
			AND DET.FechaPago<AMO.FechaExigible;

		INSERT INTO TMPPLDEXIGIBLETRAN(
			Transaccion,		CreditoID,		ClienteID,		CuentaAhoID,		NumTransaccion,
			AlertaXCuota1)
		SELECT DISTINCT
			TMP1.Transaccion,	TMP1.CreditoID,	TMP1.ClienteID,	TMP1.CuentaAhoID,	Aud_NumTransaccion,
			TMP1.AlertaXCuota1
		FROM TMPPLDOPEINUMAYEXITRAN TMP1
		WHERE TMP1.NumTransaccion = Aud_NumTransaccion;

		INSERT TMPTOTALPAGOTRAN (
			Transaccion,	CreditoID,	MontoTotal,			NumTransaccion,		FormaPago)
		SELECT
			Transaccion,	CreditoID,	SUM(MontoTotPago),	Aud_NumTransaccion,	MAX(FormaPago)
		FROM DETALLEPAGCRE WHERE Transaccion IN(SELECT Transaccion FROM TMPPLDEXIGIBLETRAN WHERE NumTransaccion = Aud_NumTransaccion)
		GROUP BY Transaccion, CreditoID;

		UPDATE TMPPLDOPEINUMAYEXITRAN TME
			INNER JOIN TMPTOTALPAGOTRAN TPG ON TME.CreditoID = TPG.CreditoID
		SET
			TME.TotalPagado = TPG.MontoTotal,
			TME.AlertaXCuota2 = Str_SI,
			TPG.AlertaXCuota2 = Str_SI
		WHERE TPG.NumTransaccion = Aud_NumTransaccion
			AND TPG.MontoTotal > TME.MontoHolguraPA;

		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,							Tmp_ClaveRegistra,						Tmp_NombreReg,								Tmp_CatProcedIntID	,						Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,					Tmp_SucursalID,							Tmp_ClavePersonaInv,						Tmp_NomPersonaInv,							Tmp_EmpInvolucrado,
			Tmp_Frecuencia,						Tmp_DesFrecuencia,						Tmp_DesOperacion,							Tmp_Estatus,								Tmp_ComentarioOC,
			Tmp_FechaCierre,					Tmp_CreditoID,							Tmp_CuentaID,								Tmp_TransaccionOpe,							Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,					Tmp_MonedaID,							Tmp_TipoOpeCNBV,							Tmp_FormaPago,								Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,				Tmp_ApPaternoPersonaInv,				Tmp_ApMaternoPersonaInv)
		SELECT
			Par_FechaActual AS Fecha,			ClaveSistemaAut AS ClaveRegistra ,		Var_NombreInstitucion AS NombreReg,			AlertasAutomati AS CatProcedIntID,			MotivoAlertaAut AS CatMotivInuID,
			Par_FechaActual AS FechaDeteccion,	Cli.SucursalOrigen AS SucursalID,		Cli.ClienteID AS ClavePersonaInv,			Cli.NombreCompleto AS NomPersonaInv,		Cadena_Vacia AS EmpInvolucrado,
			Str_NO AS Frecuencia,				Cadena_Vacia AS DesFrecuencia,			DescriPagoMayoQueExig AS DesOperacion,		EstatusOpeCapturada AS Estatus,				Cadena_Vacia AS ComentarioOC,
			FechaVacia AS FechaCierre,			Tmp.CreditoID AS CreditoID,				Tmp.CuentaAhoID AS CuentaID,				Tmp.Transaccion AS TransaccionOpe,			'A' AS NaturalezaOpe,
			TOTAL.MontoTotal AS MontoOperacion,	Cue.MonedaID AS MonedaID,				TipoOpePagoCredito,							IF(TOTAL.FormaPago=TipoMov_Efectivo,TipoMov_Efectivo,TipoMov_Transferencia),TipoPersonaSAFICTE,
			Cli.SoloNombres,					Cli.ApellidoPaterno,					Cli.ApellidoMaterno
		FROM TMPPLDEXIGIBLETRAN Tmp
			INNER JOIN TMPTOTALPAGOTRAN AS TOTAL ON Tmp.Transaccion = TOTAL.Transaccion AND Tmp.CreditoID = TOTAL.CreditoID
			INNER JOIN CLIENTES Cli ON Tmp.ClienteID = Cli.ClienteID
			INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Tmp.CuentaAhoID
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND Tmp.AlertaXCuota1 = Str_SI;

		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,							Tmp_ClaveRegistra,						Tmp_NombreReg,								Tmp_CatProcedIntID	,						Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,					Tmp_SucursalID,							Tmp_ClavePersonaInv,						Tmp_NomPersonaInv,							Tmp_EmpInvolucrado,
			Tmp_Frecuencia,						Tmp_DesFrecuencia,						Tmp_DesOperacion,							Tmp_Estatus,								Tmp_ComentarioOC,
			Tmp_FechaCierre,					Tmp_CreditoID,							Tmp_CuentaID,								Tmp_TransaccionOpe,							Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,					Tmp_MonedaID,							Tmp_TipoOpeCNBV,							Tmp_FormaPago,								Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,				Tmp_ApPaternoPersonaInv,				Tmp_ApMaternoPersonaInv)
		SELECT
			Par_FechaActual AS Fecha,			ClaveSistemaAut AS ClaveRegistra ,		Var_NombreInstitucion AS NombreReg,			AlertasAutomati AS CatProcedIntID,			MotivoAlertaAut AS CatMotivInuID,
			Par_FechaActual AS FechaDeteccion,	Cli.SucursalOrigen AS SucursalID,		Cli.ClienteID AS ClavePersonaInv,			Cli.NombreCompleto AS NomPersonaInv,		Cadena_Vacia AS EmpInvolucrado,
			Str_NO AS Frecuencia,				Cadena_Vacia AS DesFrecuencia,			Desc_PagoSupExig AS DesOperacion,		EstatusOpeCapturada AS Estatus,				Cadena_Vacia AS ComentarioOC,
			FechaVacia AS FechaCierre,			Tmp.CreditoID AS CreditoID,				Tmp.CuentaAhoID AS CuentaID,				Tmp.Transaccion AS TransaccionOpe,			'A' AS NaturalezaOpe,
			TOTAL.MontoTotal AS MontoOperacion,	Cue.MonedaID AS MonedaID,				TipoOpePagoCredito,							IF(TOTAL.FormaPago=TipoMov_Efectivo,TipoMov_Efectivo,TipoMov_Transferencia),TipoPersonaSAFICTE,
			Cli.SoloNombres,					Cli.ApellidoPaterno,					Cli.ApellidoMaterno
		FROM TMPPLDEXIGIBLETRAN Tmp
			INNER JOIN TMPTOTALPAGOTRAN AS TOTAL ON Tmp.Transaccion = TOTAL.Transaccion AND Tmp.CreditoID = TOTAL.CreditoID
			INNER JOIN CLIENTES Cli ON Tmp.ClienteID = Cli.ClienteID
			INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Tmp.CuentaAhoID
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND TOTAL.AlertaXCuota2 = Str_SI;

		SET	@Var_MaxIdConsec	:= (SELECT MAX(OpeInusualID) FROM PLDOPEINUSUALES);
		SET	@Var_MaxIdConsec	:= IFNULL(@Var_MaxIdConsec, Entero_Cero);

		DELETE TMP FROM TMPREGOPEINU AS TMP INNER JOIN PLDOPEINUSUALES AS PLD ON
			TMP.Tmp_ClavePersonaInv = PLD.ClavePersonaInv AND
			/*TMP.Tmp_SucursalID = PLD.SucursalID AND */
			TMP.Tmp_NomPersonaInv = PLD.NomPersonaInv AND
			TMP.Tmp_DesOperacion = PLD.DesOperacion AND
			TMP.Tmp_CreditoID = PLD.CreditoID AND
			TMP.Tmp_CuentaID = PLD.CuentaAhoID AND
			TMP.Tmp_TransaccionOpe = PLD.TransaccionOpe AND
			TMP.Tmp_NaturalezaOpe = PLD.NaturaOperacion AND
			TMP.Tmp_MontoOperacion = PLD.MontoOperacion AND
			TMP.Tmp_FormaPago = PLD.FormaPago AND
			TMP.Tmp_TipoPersonaSAFI = PLD.TipoPersonaSAFI AND
			TMP.Tmp_Fecha = PLD.Fecha
			WHERE PLD.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes;

		INSERT INTO PLDOPEINUSUALES(
			Fecha, 						OpeInusualID,  					ClaveRegistra, 						NombreReg, 				CatProcedIntID,
			CatMotivInuID,				FechaDeteccion, 				SucursalID, 						ClavePersonaInv, 		NomPersonaInv,
			EmpInvolucrado, 			Frecuencia,						DesFrecuencia, 						DesOperacion, 			Estatus,
			ComentarioOC,				FechaCierre, 					CreditoID,							CuentaAhoID,			TransaccionOpe,
			NaturaOperacion,			MontoOperacion,					MonedaID,							FolioInterno,			TipoOpeCNBV,
			FormaPago,					TipoPersonaSAFI,				NombresPersonaInv,					ApPaternoPersonaInv,	ApMaternoPersonaInv,
			ProcesoDetec,				EmpresaID,						Usuario,							FechaActual,			DireccionIP,
			ProgramaID,					Sucursal,						NumTransaccion)
		SELECT
			IFNULL(TMP.Tmp_Fecha,FechaVacia),
			@Var_MaxIdConsec:=@Var_MaxIdConsec+1,
			IFNULL(CAST(TMP.Tmp_ClaveRegistra AS CHAR),Cadena_Vacia),
			IFNULL(TMP.Tmp_NombreReg,Cadena_Vacia),
			IFNULL(TMP.Tmp_CatProcedIntID,Cadena_Vacia),
			IFNULL(TMP.Tmp_CatMotivInuID,Cadena_Vacia),
			IFNULL(DATE(Par_FechaActual), FechaVacia),
			IFNULL(TMP.Tmp_SucursalID,Entero_Cero),
			IFNULL(TMP.Tmp_ClavePersonaInv,Entero_Cero),
			IFNULL(TMP.Tmp_NomPersonaInv,Cadena_Vacia),
			IFNULL(TMP.Tmp_EmpInvolucrado,Cadena_Vacia),
			IFNULL(TMP.Tmp_Frecuencia,Cadena_Vacia),
			IFNULL(TMP.Tmp_DesFrecuencia,Cadena_Vacia),
			IFNULL(TMP.Tmp_DesOperacion,Cadena_Vacia),
			IFNULL(TMP.Tmp_Estatus,Entero_Cero),
			IFNULL(TMP.Tmp_ComentarioOC,Cadena_Vacia),
			IFNULL(TMP.Tmp_FechaCierre,FechaVacia),
			IFNULL(TMP.Tmp_CreditoID,Entero_Cero),
			IFNULL(TMP.Tmp_CuentaID,Entero_Cero),
			IFNULL(TMP.Tmp_TransaccionOpe,0),
			IFNULL(TMP.Tmp_NaturalezaOpe,Cadena_Vacia),
			IFNULL(TMP.Tmp_MontoOperacion,Decimal_Cero),
			IFNULL(TMP.Tmp_MonedaID,Entero_Cero),
			Entero_Cero AS FolioInterno,
			IFNULL(TMP.Tmp_TipoOpeCNBV,Cadena_Vacia),
			IFNULL(TMP.Tmp_FormaPago,Cadena_Vacia),
			IFNULL(TMP.Tmp_TipoPersonaSAFI, Cadena_Vacia),
			IFNULL(TMP.Tmp_NombresPersonaInv,Cadena_Vacia),
			IFNULL(TMP.Tmp_ApPaternoPersonaInv,Cadena_Vacia),
			IFNULL(TMP.Tmp_ApMaternoPersonaInv,Cadena_Vacia),
			2,
			Par_EmpresaID,
			Aud_Usuario,
			Aud_FechaActual,
			Aud_DireccionIP,
			Aud_ProgramaID,
			Aud_Sucursal,
			Aud_NumTransaccion
		FROM TMPREGOPEINU AS TMP;

		DROP TABLE IF EXISTS TMPREGOPEINU;
		TRUNCATE TEMPPLDOPEINUSALERT;

		DELETE FROM TMPPLDLIQUIDAANTTRAN WHERE NumTransaccion = Aud_NumTransaccion;
		DELETE FROM TMPPLDCREDMONTOLA WHERE NumTransaccion = Aud_NumTransaccion;
		DELETE FROM TMPPLDOPEINUMAYEXITRAN WHERE NumTransaccion = Aud_NumTransaccion;
		DELETE FROM TMPPLDEXIGIBLETRAN WHERE NumTransaccion = Aud_NumTransaccion;
		DELETE FROM TMPTOTALPAGOTRAN WHERE NumTransaccion = Aud_NumTransaccion;

		-- Al Cierre Mensual, borrar Tabla que Almacena Los Movimientos Excedidos en Num Abonos, Num Retiros
		-- Actualiza Num Depositos Aplicados y Num Retiros Aplicados en CONOCIMIENTOCTA, para iniciar Mes en O
		CALL DIASFESTIVOSCAL(
				Par_FechaActual,	Entero_Uno,			Var_FechaSig,			Es_DiaHabil,		Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID, 	Aud_Sucursal,
				Aud_NumTransaccion);

		IF(MONTH(Par_FechaActual) != MONTH(Var_FechaSig))THEN
			TRUNCATE TABLE PLDOPEINUSALERTNUM;
			UPDATE PLDPERFILTRANS	SET
				NumDepoApli=0,
				NumRetiApli=0,
				NumDepoEfecApli=0,
				NumDepoCheApli=0,
				NumDepoTranApli=0,
				NumRetirosEfecApli=0,
				NumRetirosCheApli=0,
				NumRetirosTranApli=0;
		END IF;

		SET	Par_NumErr	:= Entero_Cero;
		SET	Par_ErrMen	:= CONCAT("Proceso de Alertas Automaticas de Operaciones Inusuales Finalizado con Exito");

	END ManejoErrores;

	IF Par_Salida = Str_SI THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			'opeInusualID' AS control,
			Aud_NumTransaccion AS consecutivo;
	END IF;
END TerminaStore$$


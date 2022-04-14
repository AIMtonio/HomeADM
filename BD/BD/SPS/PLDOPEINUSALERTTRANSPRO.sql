
-- PLDOPEINUSALERTTRANSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINUSALERTTRANSPRO`;

DELIMITER $$
CREATE PROCEDURE `PLDOPEINUSALERTTRANSPRO`(
-- ----------------------------------------------------------------------------------------------
-- SP que detecta las operaciones inusuales de manera automatica al momento de la transaccion ---
-- ----------------------------------------------------------------------------------------------
    Par_TipoOperacion	    INT(11), 		-- Tipo de operacion 1 = Abonos y cargos cuenta,2= Pago de credito
    Par_ClienteID           INT(11),		-- ID de cliente
    Par_CuentaAhoID         BIGINT(12),		-- ID de la cuenta ahorro
    Par_TipoMovAhoID        CHAR(4),		-- Tipo de movimiento de cuenta
    Par_NatMovimiento       CHAR(1),		-- Naturaleza del movimiento cargo o abono

    Par_CreditoID			BIGINT(12),		-- ID de credito
	Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error
	Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa

	Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal

	Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
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
	DECLARE Var_FechaActual				DATE;			-- Fecha de Cierre
  	DECLARE Var_NumOperaciones			INT(11);
	DECLARE Var_EjecutaDetecOpeInusual	VARCHAR(200);
    DECLARE Var_Aux						INT(11);
    DECLARE Var_MaxConsecutivo			INT(11);
    DECLARE Var_OpeInusualID			BIGINT(20);		-- Numero de Operacion inusual
	DECLARE Var_DetecOpeInusual			CHAR(1);
	DECLARE Var_DetecPLD				CHAR(1);

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
	DECLARE OpeCNBV_Dep					CHAR(2);
	DECLARE OpeCNBV_Ret					CHAR(2);
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
	DECLARE	EjecutaOpInu_Transaccion	CHAR(1);
	DECLARE TipoMov_SPEI				CHAR(4);

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
	SET DescriLiquidAnt					:= 'CREDITO LIQUIDADO ANTICIPADAMENTE POR MONTO.';										-- Descripcion Credito liquidado anticipadamente --
	SET DescriPagoAnticipado			:= 'PAGO DE CREDITO CON MUCHOS DIAS DE ANTICIPACION';						-- Descripcion Pago de CrÃ©dito con mnuchos dias de anticipacion --
	SET DescriPagoMayoQueExig			:= 'PAGO DE CREDITO MAYOR A EXIGIBLE.';										-- Descripcion Pago de Credito Mayor a Exigible --
	SET Desc_LiqAntXDias				:= 'CREDITO LIQUIDADO ANTICIPADAMENTE POR DIAS.';										-- Descripcion Credito liquidado anticipadamente --
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
	SET OpeCNBV_Dep						:= '01';				-- Tipo Operacion Deposito segun la CNBV --
	SET OpeCNBV_Ret						:= '02';				-- Tipo Operacion Retiro segun la CNBV --
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
	SET EjecutaOpInu_Transaccion		:= 'T';					-- Ejecuta proceso de alertas inusuales al momento de la transaccion
	SET TipoMov_SPEI					:= '224';				-- TIPO DE MOVIMIENTO DE AHORRO PARA SPEI.

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-PLDOPEINUSALERTTRANSPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']');
			SET VarControl := 'sqlException';
		END;

		SELECT
			FechaSistema,		DetecOpeInusual
		INTO
			Var_FechaActual,	Var_DetecOpeInusual
		FROM PARAMETROSSIS;
		SET Var_DetecOpeInusual			:= IFNULL(Var_DetecOpeInusual,Str_NO);

        -- Parametro para ejecutar proceso de deteccion de operaciones inusuales en el cierre de dia o al momento de la transaccion
        SET Var_EjecutaDetecOpeInusual	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'EjecutaDetecOpeInusual');
		SET Var_EjecutaDetecOpeInusual	:= IFNULL(Var_EjecutaDetecOpeInusual,Cadena_Vacia);

		# SE VALIDA SI EL SISTEMA DETECTA OPERACIONES INUSUALES.
		IF(Var_DetecOpeInusual = Str_SI)THEN
			-- INICIO DE DETECCION DE OPERACIONES POR TRANSACCION
			IF(Var_EjecutaDetecOpeInusual = EjecutaOpInu_Transaccion)THEN

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
				SET	Var_FecIniMes			:= DATE_FORMAT(Var_FechaActual,'%Y-%m-01');
				SET Var_FecFinMes			:= LAST_DAY(Var_FechaActual);

				-- 1.- Abonos y cargos cuenta
				IF(Par_TipoOperacion = 1)THEN
					# SE OBTIENE SI EL TIPO DE MOVIMIENTO ES DETECTADO POR PLD.
					SET Var_DetecPLD := (SELECT DetecPLD FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Par_TipoMovAhoID);
					SET Var_DetecPLD := IFNULL(Var_DetecPLD,Str_NO);

					IF(Var_DetecPLD = Str_SI)THEN
						# Inserta el movimiento de la CTA
						INSERT INTO TMPPLDMOVIMIENCTATRAN(
							ClienteID,			NDeposito,  		NRetiro,  			CuentaAhoID, 		TipoMovAhoID,
							Descripcion,		DescripcionMov,  	NatMovimiento,  	CantidadMov,  		DetecPLD,
							EsEfectivo,  		EsCredito,  		EsDocumentos,  		EsTransferencia,  DepositosMax,
							DepositosHolg,  	RetirosMax,  		RetirosMaxHolg,		NumDepositos,		NumDepositosHolg,
							NumRetiros,  		NumRetirosHolg,		NumeroMov,			Fecha,				MonedaID,
							TipoOpeCNBV,		NumTransaccion)
						SELECT
							CTA.ClienteID,		99999 AS NDeposito,	99999 AS NRetiro,	MOV.CuentaAhoID,	TIP.TipoMovAhoID,
							TIP.Descripcion,	MOV.DescripcionMov,	MOV.NatMovimiento,	MOV.CantidadMov,	TIP.DetecPLD,
							TIP.EsEfectivo,		TIP.EsCredito,		TIP.EsDocumentos,	TIP.EsTransferencia,0,
							0,					0,					0,					0,					0,
							0,					0,					MOV.NumeroMov,		MOV.Fecha,			MOV.MonedaID,
							CASE MOV.TipoMovAhoID
								WHEN TipoMov_SPEI THEN IF(MOV.NatMovimiento = Nat_Abono,OpeCNBV_Dep,OpeCNBV_Ret)
								ELSE TIP.TipoOpeCNBV
							END,
							Aud_NumTransaccion
						FROM CUENTASAHOMOV AS MOV
							INNER JOIN CUENTASAHO AS CTA ON MOV.CuentaAhoID = CTA.CuentaAhoID
							INNER JOIN TIPOSMOVSAHO AS TIP ON MOV.TipoMovAhoID=TIP.TipoMovAhoID
						WHERE MOV.Fecha BETWEEN Var_FecIniMes AND Var_FechaActual
							AND CTA.ClienteID = Par_ClienteID
							AND TIP.DetecPLD = 'S'
							AND MOV.NatMovimiento = Par_NatMovimiento
						ORDER BY CTA.ClienteID,MOV.Fecha, MOV.NumeroMov, MOV.FechaActual;

						UPDATE CLIENTES SET
							NivelRiesgo = 'B'
						WHERE ClienteID = Par_ClienteID
							AND NivelRiesgo = ''
							OR NivelRiesgo IS NULL;

						INSERT INTO TMPPLDHISPERFDETECTRAN(
							ClienteID,    		TransaccionID, NumTransaccion)
						SELECT
							PLD.ClienteID,		MAX(PLD.TransaccionID), Aud_NumTransaccion
						FROM PLDHISPERFILTRANS AS PLD
						WHERE PLD.ClienteID = Par_ClienteID
						GROUP BY PLD.ClienteID;


						# Actuazimos datos del Perfil Transaccional
						UPDATE TMPPLDMOVIMIENCTATRAN AS CTA
							INNER JOIN CLIENTES AS CTE ON CTA.ClienteID = CTE.ClienteID
							INNER JOIN PLDHISPERFILTRANS AS PER ON CTA.ClienteID = PER.ClienteID
							INNER JOIN TMPPLDHISPERFDETECTRAN AS HIS ON PER.ClienteID = HIS.ClienteID AND PER.TransaccionID = HIS.TransaccionID AND HIS.NumTransaccion = Aud_NumTransaccion
							INNER JOIN PLDPARALEOPINUS AS PAR ON CTE.TipoPersona = PAR.TipoPersona AND CTE.NivelRiesgo = PAR.NivelRiesgo
						SET
							CTA.DepositosMax = PER.DepositosMax,
							CTA.DepositosHolg = (PER.DepositosMax * (1+(PAR.VarPTrans/100))),
							CTA.RetirosMax = PER.RetirosMax,
							CTA.RetirosMaxHolg = (PER.RetirosMax * (1+(PAR.VarPTrans/100))),
							CTA.NumDepositos = PER.NumDepositos,
							CTA.NumDepositosHolg = (PER.NumDepositos * (1+(PAR.VarNumDep/100))),
							CTA.NumRetiros = PER.NumRetiros,
							CTA.NumRetirosHolg = (PER.NumRetiros * (1+(PAR.VarNumRet/100)))
						WHERE CTA.ClienteID = CTE.ClienteID
							AND CTA.NumTransaccion = Aud_NumTransaccion;



						SET @NDeposito := 0;
						SET @NRetiro := 0;
						SET @NClienteID := 0;
						SET @MontoDepo := 0;
						SET @MontoReto := 0;
						SET @RegistroID := 0;

						INSERT INTO TMPPLDNUMDEPORETOTRAN(
							IDPLDMov,	ClienteID,	NatMovimiento,	CantidadMov,	NDeposito,
							MontoDepo,	NRetiro,	MontoReto,		CtaAnterior,	NumTransaccion)
						SELECT
							CTA.IDPLDMov,CTA.ClienteID, CTA.NatMovimiento,
							CTA.CantidadMov,
							IF(@NClienteID!=CTA.ClienteID,IF(CTA.NatMovimiento = 'A',@NDeposito := 1,@NDeposito := 0),IF(CTA.NatMovimiento = 'A',@NDeposito := @NDeposito+1,0)) AS NDeposito,
							IF(@NClienteID!=CTA.ClienteID,IF(CTA.NatMovimiento = 'A',@MontoDepo := CTA.CantidadMov,@MontoDepo := 0),IF(CTA.NatMovimiento = 'A',@MontoDepo := @MontoDepo+CTA.CantidadMov,0)) AS MontoDepo,
							IF(@NClienteID!=CTA.ClienteID,IF(CTA.NatMovimiento = 'C',@NRetiro := 1,@NRetiro := 0),IF(CTA.NatMovimiento = 'C',@NRetiro := @NRetiro+1,0)) AS NRetiro,
							IF(@NClienteID!=CTA.ClienteID,IF(CTA.NatMovimiento = 'C',@MontoReto := CTA.CantidadMov,@MontoReto := 0),IF(CTA.NatMovimiento = 'C',@MontoReto := @MontoReto+CTA.CantidadMov,0)) AS MontoReto,
							IF(@NClienteID != CTA.ClienteID,@NClienteID := CTA.ClienteID,@NClienteID) AS CtaAnterior, Aud_NumTransaccion
						FROM TMPPLDMOVIMIENCTATRAN AS CTA
						WHERE CTA.NumTransaccion = Aud_NumTransaccion;

						UPDATE TMPPLDMOVIMIENCTATRAN AS CTA INNER JOIN TMPPLDNUMDEPORETOTRAN AS TMP ON CTA.IDPLDMov = TMP.IDPLDMov AND TMP.NumTransaccion = Aud_NumTransaccion SET
							CTA.NDeposito = TMP.NDeposito,
							CTA.NRetiro = TMP.NRetiro,
							CTA.DetectNDepositos = IF(TMP.NDeposito>CTA.NumDepositosHolg,'S','N'),
							CTA.DetectNRetiros = IF(TMP.NRetiro>CTA.NumRetirosHolg,'S','N'),
							CTA.DetectExcDepositos = IF(TMP.MontoDepo>CTA.DepositosHolg,'S','N'),
							CTA.SumCantidadDepoMov = IF(TMP.MontoDepo>CTA.DepositosHolg,MontoDepo,0),
							CTA.DetectExcRetiros = IF(TMP.MontoReto>CTA.RetirosMaxHolg,'S','N'),
							CTA.SumCantidadRetoMov = IF(TMP.MontoReto>CTA.RetirosMaxHolg,MontoReto,0)
						WHERE CTA.NumTransaccion = Aud_NumTransaccion;


						UPDATE TMPPLDMOVIMIENCTATRAN AS CTA INNER JOIN CLIENTES AS CTE ON CTA.ClienteID = CTE.ClienteID SET
							CTA.SucursalOrigen = CTE.SucursalOrigen,
							CTA.NombreCompleto = CTE.NombreCompleto,
							CTA.SoloNombres = CTE.SoloNombres,
							CTA.ApellidoPaterno = CTE.ApellidoPaterno,
							CTA.ApellidoMaterno = CTE.ApellidoMaterno
						WHERE CTA.NumTransaccion = Aud_NumTransaccion;


						# Insertamos todas las operaciones que superaron lo declarado en el perfil transaccion por deposito.

						-- INICIO OPERACIONES ABONOS
						IF(IFNULL(Par_NatMovimiento,Cadena_Vacia) = Nat_Abono)THEN
							# DEPOSITOS MAX
							INSERT INTO TMPREGOPEINUTRAN (
								Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
								Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
								Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
								Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
								Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
								Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv,			NumTransaccion)
							SELECT
								TMP.Fecha,						ClaveSistemaAut,				Var_NombreInstitucion,							AlertasAutomati,								MotivoAlertaAut,
								Var_FechaActual,				TMP.SucursalOrigen,				TMP.ClienteID,									TMP.NombreCompleto,								Cadena_Vacia,
								Str_NO,							Cadena_Vacia,					LEFT(Des_PerfilExcedeMontoDepositos,180),		EstatusOpeCapturada,							Cadena_Vacia,
								FechaVacia,						Entero_Cero,					TMP.CuentaAhoID,								TMP.NumeroMov,									TMP.NatMovimiento,
								TMP.CantidadMov,				TMP.MonedaID,					TMP.TipoOpeCNBV,								CASE
																																					WHEN TMP.EsTransferencia = 'S' THEN 'T'
																																					WHEN TMP.EsDocumentos = 'S' THEN 'H'
																																					WHEN TMP.EsCredito = 'S' THEN 'C'
																																					WHEN TMP.EsEfectivo = 'S' THEN 'E'
																																					ELSE 'E'
																																					END,	TipoPersonaSAFICTE,
								TMP.SoloNombres,				TMP.ApellidoPaterno,			TMP.ApellidoMaterno,			Aud_NumTransaccion
								FROM TMPPLDMOVIMIENCTATRAN AS TMP
								WHERE DetectExcDepositos = 'S'
									AND NumeroMov = Aud_NumTransaccion
									AND TMP.NumTransaccion = Aud_NumTransaccion;


							#NUMERO DE DEPOSITOS
							INSERT INTO TMPREGOPEINUTRAN (
								Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,									Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
								Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,							Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
								Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,								Tmp_Estatus,				Tmp_ComentarioOC,
								Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,									Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
								Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,								Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
								Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv,						NumTransaccion)
							SELECT
								TMP.Fecha,					ClaveSistemaAut,				Var_NombreInstitucion,							AlertasAutomati,								MotivoAlertaAut,
								Var_FechaActual,			TMP.SucursalOrigen,				TMP.ClienteID,									TMP.NombreCompleto,								Cadena_Vacia,
								Str_NO,						Cadena_Vacia,					LEFT(Des_PerfilExcedeNumDepositos,180),		EstatusOpeCapturada,							Cadena_Vacia,
								FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,								TMP.NumeroMov,									TMP.NatMovimiento,
								TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,								CASE
																																				WHEN TMP.EsTransferencia = 'S' THEN 'T'
																																				WHEN TMP.EsDocumentos = 'S' THEN 'H'
																																				WHEN TMP.EsCredito = 'S' THEN 'C'
																																				WHEN TMP.EsEfectivo = 'S' THEN 'E'
																																				ELSE 'E'
																																				END,	TipoPersonaSAFICTE,
								TMP.SoloNombres,				TMP.ApellidoPaterno,			TMP.ApellidoMaterno,						Aud_NumTransaccion
								FROM TMPPLDMOVIMIENCTATRAN AS TMP
								WHERE DetectNDepositos = 'S'
									AND NumeroMov = Aud_NumTransaccion
									AND TMP.NumTransaccion = Aud_NumTransaccion;
						END IF; -- FIN OPERACIONES ABONOS

						-- INICIO OPERACIONES CARGOS
						IF(IFNULL(Par_NatMovimiento,Cadena_Vacia) = Nat_Cargo)THEN

							#RETIROS MAX
							INSERT INTO TMPREGOPEINUTRAN (
								Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,									Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
								Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,							Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
								Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,								Tmp_Estatus,				Tmp_ComentarioOC,
								Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,									Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
								Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,								Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
								Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv,						NumTransaccion)
							SELECT
								TMP.Fecha,					ClaveSistemaAut,				Var_NombreInstitucion,							AlertasAutomati,								MotivoAlertaAut,
								Var_FechaActual,			TMP.SucursalOrigen,				TMP.ClienteID,									TMP.NombreCompleto,								Cadena_Vacia,
								Str_NO,						Cadena_Vacia,					LEFT(Des_PerfilExcedeMontoRetiros,180),		EstatusOpeCapturada,							Cadena_Vacia,
								FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,								TMP.NumeroMov,									TMP.NatMovimiento,
								TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,								CASE
																																				WHEN TMP.EsTransferencia = 'S' THEN 'T'
																																				WHEN TMP.EsDocumentos = 'S' THEN 'H'
																																				WHEN TMP.EsCredito = 'S' THEN 'C'
																																				WHEN TMP.EsEfectivo = 'S' THEN 'E'
																																				ELSE 'E'
																																				END,	TipoPersonaSAFICTE,
								TMP.SoloNombres,				TMP.ApellidoPaterno,			TMP.ApellidoMaterno,						Aud_NumTransaccion
								FROM TMPPLDMOVIMIENCTATRAN AS TMP
								WHERE DetectExcRetiros = 'S'
									AND NumeroMov = Aud_NumTransaccion
									AND TMP.NumTransaccion = Aud_NumTransaccion;


							#NUMERO DE RETIROS
							INSERT INTO TMPREGOPEINUTRAN (
								Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,									Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
								Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,							Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
								Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,								Tmp_Estatus,				Tmp_ComentarioOC,
								Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,									Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
								Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,								Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
								Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv,						NumTransaccion)
							SELECT
								TMP.Fecha,					ClaveSistemaAut,				Var_NombreInstitucion,							AlertasAutomati,								MotivoAlertaAut,
								Var_FechaActual,			TMP.SucursalOrigen,				TMP.ClienteID,									TMP.NombreCompleto,								Cadena_Vacia,
								Str_NO,						Cadena_Vacia,					LEFT(Des_PerfilExcedeNumRetiros,180),		EstatusOpeCapturada,							Cadena_Vacia,
								FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,								TMP.NumeroMov,									TMP.NatMovimiento,
								TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,								CASE
																																				WHEN TMP.EsTransferencia = 'S' THEN 'T'
																																				WHEN TMP.EsDocumentos = 'S' THEN 'H'
																																				WHEN TMP.EsCredito = 'S' THEN 'C'
																																				WHEN TMP.EsEfectivo = 'S' THEN 'E'
																																				ELSE 'E'
																																				END,	TipoPersonaSAFICTE,
								TMP.SoloNombres,				TMP.ApellidoPaterno,			TMP.ApellidoMaterno,						Aud_NumTransaccion
								FROM TMPPLDMOVIMIENCTATRAN AS TMP
								WHERE DetectNRetiros = 'S'
									AND NumeroMov = Aud_NumTransaccion
									AND TMP.NumTransaccion = Aud_NumTransaccion;

						END IF;-- FIN OPERACIONES CARGOS
					END IF;# DETECCIÓN PLD SI
				END IF; -- FIN ABONOS Y CARGOS

				-- 2.- INICIO PAGO DE CREDITO
				IF(Par_TipoOperacion = 2)THEN
					# SE OBTIENEN LOS PARÁMETROS PARA DETECCIÓN POR LIQUIDACIÓN DE CŔEDITO.
					SELECT
						LiquidAnticipad,	PorcDiasLiqAnt,		PorcLiqAnt
					INTO
						Var_LiquidAnticipad,Var_PorcDiasLiqAnt,	Var_PorcLiqAnt
					FROM CREDITOS AS CRED
						INNER JOIN CLIENTES AS CTE ON CRED.ClienteID = CTE.ClienteID
						INNER JOIN PLDPARALEOPINUS AS PAR ON CTE.TipoPersona = PAR.TipoPersona AND CTE.NivelRiesgo = PAR.NivelRiesgo
					WHERE CRED.CreditoID = Par_CreditoID
						AND CRED.Estatus = Cre_StaPagado;

					SET Var_LiquidAnticipad	:= IFNULL(Var_LiquidAnticipad,Str_NO);
					SET Var_PorcDiasLiqAnt	:= IFNULL(Var_PorcDiasLiqAnt,Entero_Cero);
					SET Var_PorcLiqAnt		:= IFNULL(Var_PorcLiqAnt,Entero_Cero);

					# Plazo Mínimo de Pago Anticipado en Cuotas Exigibles --------------------------------------------------------------------------
					# ------------------------------------------------------------------------------------------------------------------------------
					# Se Registran como alertas, todos los pagos que se registraton  'W' dias antes de su exigibilidad
					# Siempre y cuando el monto total de pago anticipado supere el monto del perfil transaccional	mas el porcentaje de tolerancia

					INSERT INTO TMPPLDDETECDIASMAXTRAN(
						Transaccion,		CreditoID,		CuentaAhoID,		PorcDiasMax,		AmortizacionID,
						ClienteID,			FechaInicio,	FechaExigible,		FechaPago,			Dias,
						DiasAnt,			DiasHolgura,	NumTransaccion,		FormaPago)
					SELECT
						DET.Transaccion,	DET.CreditoID,		CRED.CuentaID,	PAR.PorcDiasMax,	AMO.AmortizacionID,	CRED.ClienteID,
						AMO.FechaInicio,	AMO.FechaExigible,	DET.FechaPago,
						TIMESTAMPDIFF(DAY,AMO.FechaInicio,AMO.FechaExigible) AS Dias,
						TIMESTAMPDIFF(DAY,DET.FechaPago,AMO.FechaExigible) AS DiasAnt,
						ROUND(TIMESTAMPDIFF(DAY,AMO.FechaInicio,AMO.FechaExigible)*((PAR.PorcDiasMax/100)),2) AS DiasHolgura,
						Aud_NumTransaccion,	DET.FormaPago
					FROM DETALLEPAGCRE AS DET
						INNER JOIN AMORTICREDITO AS AMO ON DET.CreditoID = AMO.CreditoID AND DET.AmortizacionID = AMO.AmortizacionID
						INNER JOIN CREDITOS AS CRED ON DET.CreditoID = CRED.CreditoID
						INNER JOIN CLIENTES AS CTE ON CRED.ClienteID = CTE.ClienteID
						INNER JOIN PLDPARALEOPINUS AS PAR ON CTE.TipoPersona = PAR.TipoPersona AND CTE.NivelRiesgo = PAR.NivelRiesgo
					WHERE FechaPago = Var_FechaActual
						AND TIMESTAMPDIFF(DAY,DET.FechaPago,AMO.FechaExigible) > 0
						AND CRED.CreditoID = Par_CreditoID;

					INSERT INTO TMPPLDDIASANTICITRAN(
						Transaccion, CreditoID,CuentaAhoID, ClienteID, NumTransaccion)
					SELECT DISTINCT
						Transaccion, CreditoID,CuentaAhoID, ClienteID, Aud_NumTransaccion
					FROM TMPPLDDETECDIASMAXTRAN
						WHERE DiasAnt > DiasHolgura
							AND NumTransaccion = Aud_NumTransaccion;

					INSERT INTO TMPPLDMONTOTCREDTRAN(
						Transaccion,	MontoTotal,			NumTransaccion,		FormaPago)
					SELECT
						Transaccion,	SUM(MontoTotPago),	Aud_NumTransaccion,	MAX(FormaPago)
					FROM DETALLEPAGCRE WHERE Transaccion IN (SELECT DISTINCT Transaccion FROM TMPPLDDIASANTICITRAN WHERE NumTransaccion = Aud_NumTransaccion)
					GROUP BY Transaccion;

					INSERT INTO TMPREGOPEINUTRAN (
						Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
						Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
						Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
						Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
						Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
						Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv,			NumTransaccion)
					SELECT
						Var_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
						Var_FechaActual,			CLI.SucursalOrigen,				CLI.ClienteID,						CLI.NombreCompleto,			Cadena_Vacia,
						Str_NO,						Cadena_Vacia,					DescriPagoAnticipado,				EstatusOpeCapturada,		Cadena_Vacia,
						FechaVacia,					TMP.CreditoID,					TMP.CuentaAhoID,					TMP.Transaccion,			Nat_Abono,
						TOTAL.MontoTotal,			1,								TipoOpePagoCredito,					IF(TOTAL.FormaPago=TipoMov_Efectivo,TipoMov_Efectivo,TipoMov_Transferencia),TipoPersonaSAFICTE,
						CLI.SoloNombres,			CLI.ApellidoPaterno,			CLI.ApellidoMaterno,				Aud_NumTransaccion
					FROM TMPPLDDIASANTICITRAN AS TMP
						INNER JOIN TMPPLDMONTOTCREDTRAN AS TOTAL ON TMP.Transaccion = TOTAL.Transaccion AND TOTAL.NumTransaccion = Aud_NumTransaccion
						INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
					WHERE TMP.CreditoID NOT IN (SELECT CreditoOrigenID FROM REESTRUCCREDITO
																WHERE FechaRegistro = Var_FechaActual
																	AND EstatusReest = EstatusDesembolso)
						AND TMP.NumTransaccion = Aud_NumTransaccion;

					/** LIQUIDACIÓN ANTICIPADA.
					 ** SE GENERAN ALERTAS DE ACUERDO AL PORCENTAJE RESPECTO AL MONTO TOTAL DEL CRÉDITO
					 ** Y AL PORCENTAJE EN LOS DÍAS RESTANTES DE LA FECHA DE PAGO A LA FECHA DE VENCIMIENTO.
					 ** AMBAS ALERTAS SON INDEPENDIENTES.
					 ***/
					IF(Var_LiquidAnticipad = Str_SI)THEN
						# Monto Total del Crédito que incluye el capital, intereses e IVA.
						SET Var_MontoCredito := (SELECT SUM(IFNULL(Capital,Entero_Cero) + IFNULL(Interes,Entero_Cero) + IFNULL(IVAInteres,Entero_Cero) +
															IFNULL(MontoSeguroCuota,Entero_Cero) + IFNULL(IVASeguroCuota,Entero_Cero))
													FROM AMORTICREDITO WHERE CreditoID IN (Par_CreditoID));
						SET Var_MontoCredito := IFNULL(Var_MontoCredito,Entero_Cero);

						INSERT INTO TMPPLDLIQUIDAANTTRAN(
							Transaccion,			CreditoID,				CuentaAhoID,
							ClienteID,				TotalPago,				NumTransaccion,
							FormaPago,				MontoTotal,				PlazoDias,
							PlazoAlPago,			MontoLimite,			PlazoLimite,
							PorcLiqAnt,				PorcDiasLiqAnt,			AlertaXMonto,
							AlertaXDias)
						SELECT
							MAX(DET.Transaccion),	CRED.CreditoID,			CRED.CuentaID,
							CRED.ClienteID,			SUM(DET.MontoTotPago),	Aud_NumTransaccion,
							MAX(DET.FormaPago),		Var_MontoCredito,		DATEDIFF(MAX(CRED.FechaVencimien),MAX(CRED.FechaInicio)),

							DATEDIFF(MAX(CRED.FechaVencimien),MAX(DET.FechaPago)),
							ROUND(Var_MontoCredito*(Var_PorcLiqAnt/100),2),
							ROUND(DATEDIFF(MAX(CRED.FechaVencimien),MAX(CRED.FechaInicio))*(Var_PorcDiasLiqAnt/100)),

							Var_PorcLiqAnt,			Var_PorcDiasLiqAnt,		Str_NO,
							Str_NO
						FROM CREDITOS AS CRED
							INNER JOIN DETALLEPAGCRE AS DET ON CRED.CreditoID = DET.CreditoID
						WHERE CRED.CreditoID = Par_CreditoID
							AND CRED.Estatus = 'P'
							AND CRED.FechaVencimien > CRED.FechTerminacion
							AND CRED.FechTerminacion = Var_FechaActual
							AND DET.FechaPago = Var_FechaActual
						GROUP BY CRED.CreditoID, CRED.CuentaID, CRED.ClienteID;

						UPDATE TMPPLDLIQUIDAANTTRAN
						SET
							AlertaXMonto	= IF(TotalPago>MontoLimite,Str_SI,Str_NO),
							AlertaXDias		= IF(PlazoAlPago>PlazoLimite,Str_SI,Str_NO)
						WHERE CreditoID = Par_CreditoID
							AND NumTransaccion = Aud_NumTransaccion;

						# ALERTA POR CREDITO LIQUIDADO ANTICIPADAMENTE POR MONTO.
						INSERT INTO TMPREGOPEINUTRAN (
							Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
							Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
							Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
							Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
							Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
							Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv,			NumTransaccion)
						SELECT
							Var_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
							Var_FechaActual,			CLI.SucursalOrigen,				CLI.ClienteID,						CLI.NombreCompleto,			Cadena_Vacia,
							Str_NO,						Cadena_Vacia,					DescriLiquidAnt,					EstatusOpeCapturada,		Cadena_Vacia,
							FechaVacia,					TMP.CreditoID,					TMP.CuentaAhoID,					TMP.Transaccion,			Nat_Abono,
							TMP.TotalPago,				1,								TipoOpeLiqCredito,					IF(TMP.FormaPago=TipoMov_Efectivo,TipoMov_Efectivo,TipoMov_Transferencia),TipoPersonaSAFICTE,
							CLI.SoloNombres,			CLI.ApellidoPaterno,			CLI.ApellidoMaterno,				Aud_NumTransaccion
						FROM TMPPLDLIQUIDAANTTRAN AS TMP
							INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
						WHERE TMP.AlertaXMonto = Str_SI
							AND TMP.NumTransaccion = Aud_NumTransaccion;

						# ALERTA POR CREDITO LIQUIDADO ANTICIPADAMENTE POR DIAS.
						INSERT INTO TMPREGOPEINUTRAN (
							Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
							Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
							Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
							Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
							Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
							Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv,			NumTransaccion)
						SELECT
							Var_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
							Var_FechaActual,			CLI.SucursalOrigen,				CLI.ClienteID,						CLI.NombreCompleto,			Cadena_Vacia,
							Str_NO,						Cadena_Vacia,					Desc_LiqAntXDias,					EstatusOpeCapturada,		Cadena_Vacia,
							FechaVacia,					TMP.CreditoID,					TMP.CuentaAhoID,					TMP.Transaccion,			Nat_Abono,
							TMP.TotalPago,				1,								TipoOpeLiqCredito,					IF(TMP.FormaPago=TipoMov_Efectivo,TipoMov_Efectivo,TipoMov_Transferencia),TipoPersonaSAFICTE,
							CLI.SoloNombres,			CLI.ApellidoPaterno,			CLI.ApellidoMaterno,				Aud_NumTransaccion
						FROM TMPPLDLIQUIDAANTTRAN AS TMP
							INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
						WHERE TMP.AlertaXDias = Str_SI
							AND TMP.NumTransaccion = Aud_NumTransaccion;
					END IF;

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
						ROUND(ROUND(AMO.Capital + AMO.Interes + AMO.IVAInteres + IFNULL(AMO.MontoSeguroCuota,0) + IFNULL(AMO.IVASeguroCuota,0),2) * (PAR.VarPagos/100),2) AS MontoHolgura,
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
					WHERE DET.FechaPago = Var_FechaActual
						AND DET.FechaPago<AMO.FechaExigible
						AND CRED.CreditoID = Par_CreditoID;

					INSERT INTO TMPPLDEXIGIBLETRAN(
						Transaccion,		CreditoID,		ClienteID,		CuentaAhoID,		NumTransaccion,
						AlertaXCuota1)
					SELECT DISTINCT
						TMP1.Transaccion,	TMP1.CreditoID,	TMP1.ClienteID,	TMP1.CuentaAhoID,	Aud_NumTransaccion,
						TMP1.AlertaXCuota1
					FROM TMPPLDOPEINUMAYEXITRAN TMP1
					WHERE TMP1.NumTransaccion = Aud_NumTransaccion
						AND TMP1.AlertaXCuota1 = Str_SI;

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

					# GENERACIÓN DE ALERTA: PAGO DE CREDITO MAYOR A EXIGIBLE.
					INSERT INTO TMPREGOPEINUTRAN (
						Tmp_Fecha,							Tmp_ClaveRegistra,						Tmp_NombreReg,								Tmp_CatProcedIntID	,						Tmp_CatMotivInuID,
						Tmp_FechaDeteccion,					Tmp_SucursalID,							Tmp_ClavePersonaInv,						Tmp_NomPersonaInv,							Tmp_EmpInvolucrado,
						Tmp_Frecuencia,						Tmp_DesFrecuencia,						Tmp_DesOperacion,							Tmp_Estatus,								Tmp_ComentarioOC,
						Tmp_FechaCierre,					Tmp_CreditoID,							Tmp_CuentaID,								Tmp_TransaccionOpe,							Tmp_NaturalezaOpe,
						Tmp_MontoOperacion,					Tmp_MonedaID,							Tmp_TipoOpeCNBV,							Tmp_FormaPago,								Tmp_TipoPersonaSAFI,
						Tmp_NombresPersonaInv,				Tmp_ApPaternoPersonaInv,				Tmp_ApMaternoPersonaInv,					NumTransaccion)
					SELECT
						Var_FechaActual AS Fecha,			ClaveSistemaAut AS ClaveRegistra ,		Var_NombreInstitucion AS NombreReg,			AlertasAutomati AS CatProcedIntID,			MotivoAlertaAut AS CatMotivInuID,
						Var_FechaActual AS FechaDeteccion,	Cli.SucursalOrigen AS SucursalID,		Cli.ClienteID AS ClavePersonaInv,			Cli.NombreCompleto AS NomPersonaInv,		Cadena_Vacia AS EmpInvolucrado,
						Str_NO AS Frecuencia,				Cadena_Vacia AS DesFrecuencia,			DescriPagoMayoQueExig AS DesOperacion,		EstatusOpeCapturada AS Estatus,				Cadena_Vacia AS ComentarioOC,
						FechaVacia AS FechaCierre,			Tmp.CreditoID AS CreditoID,				Tmp.CuentaAhoID AS CuentaID,				Tmp.Transaccion AS TransaccionOpe,			'A' AS NaturalezaOpe,
						TOTAL.MontoTotal AS MontoOperacion,	Cue.MonedaID AS MonedaID,				TipoOpePagoCredito,							IF(TOTAL.FormaPago=TipoMov_Efectivo,TipoMov_Efectivo,TipoMov_Transferencia),TipoPersonaSAFICTE,
						Cli.SoloNombres,					Cli.ApellidoPaterno, 					Cli.ApellidoMaterno,						Aud_NumTransaccion
					FROM TMPPLDEXIGIBLETRAN Tmp
						INNER JOIN TMPTOTALPAGOTRAN AS TOTAL ON Tmp.Transaccion = TOTAL.Transaccion AND Tmp.CreditoID = TOTAL.CreditoID AND TOTAL.NumTransaccion = Aud_NumTransaccion
						INNER JOIN CLIENTES Cli ON Tmp.ClienteID = Cli.ClienteID
						INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Tmp.CuentaAhoID
					WHERE Tmp.NumTransaccion = Aud_NumTransaccion
						AND Tmp.AlertaXCuota1 = Str_SI;

					# GENERACIÓN DE ALERTA: PAGO DE CREDITO ANTICIPADO SUPERIOR AL EXIGIBLE.
					INSERT INTO TMPREGOPEINUTRAN (
						Tmp_Fecha,							Tmp_ClaveRegistra,						Tmp_NombreReg,								Tmp_CatProcedIntID	,						Tmp_CatMotivInuID,
						Tmp_FechaDeteccion,					Tmp_SucursalID,							Tmp_ClavePersonaInv,						Tmp_NomPersonaInv,							Tmp_EmpInvolucrado,
						Tmp_Frecuencia,						Tmp_DesFrecuencia,						Tmp_DesOperacion,							Tmp_Estatus,								Tmp_ComentarioOC,
						Tmp_FechaCierre,					Tmp_CreditoID,							Tmp_CuentaID,								Tmp_TransaccionOpe,							Tmp_NaturalezaOpe,
						Tmp_MontoOperacion,					Tmp_MonedaID,							Tmp_TipoOpeCNBV,							Tmp_FormaPago,								Tmp_TipoPersonaSAFI,
						Tmp_NombresPersonaInv,				Tmp_ApPaternoPersonaInv,				Tmp_ApMaternoPersonaInv,					NumTransaccion)
					SELECT
						Var_FechaActual AS Fecha,			ClaveSistemaAut AS ClaveRegistra ,		Var_NombreInstitucion AS NombreReg,			AlertasAutomati AS CatProcedIntID,			MotivoAlertaAut AS CatMotivInuID,
						Var_FechaActual AS FechaDeteccion,	Cli.SucursalOrigen AS SucursalID,		Cli.ClienteID AS ClavePersonaInv,			Cli.NombreCompleto AS NomPersonaInv,		Cadena_Vacia AS EmpInvolucrado,
						Str_NO AS Frecuencia,				Cadena_Vacia AS DesFrecuencia,			Desc_PagoSupExig AS DesOperacion,		EstatusOpeCapturada AS Estatus,				Cadena_Vacia AS ComentarioOC,
						FechaVacia AS FechaCierre,			Tmp.CreditoID AS CreditoID,				Tmp.CuentaAhoID AS CuentaID,				Tmp.Transaccion AS TransaccionOpe,			'A' AS NaturalezaOpe,
						TOTAL.MontoTotal AS MontoOperacion,	Cue.MonedaID AS MonedaID,				TipoOpePagoCredito,							IF(TOTAL.FormaPago=TipoMov_Efectivo,TipoMov_Efectivo,TipoMov_Transferencia),TipoPersonaSAFICTE,
						Cli.SoloNombres,					Cli.ApellidoPaterno, 					Cli.ApellidoMaterno,						Aud_NumTransaccion
					FROM TMPPLDEXIGIBLETRAN Tmp
						INNER JOIN TMPTOTALPAGOTRAN AS TOTAL ON Tmp.Transaccion = TOTAL.Transaccion AND Tmp.CreditoID = TOTAL.CreditoID AND TOTAL.NumTransaccion = Aud_NumTransaccion
						INNER JOIN CLIENTES Cli ON Tmp.ClienteID = Cli.ClienteID
						INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Tmp.CuentaAhoID
					WHERE Tmp.NumTransaccion = Aud_NumTransaccion
						AND TOTAL.AlertaXCuota2 = Str_SI;


				END IF; -- FIN PAGO DE CREDITO

				DELETE TMP FROM TMPREGOPEINUTRAN AS TMP INNER JOIN PLDOPEINUSUALES AS PLD ON
					TMP.Tmp_ClavePersonaInv = PLD.ClavePersonaInv AND
					-- TMP.Tmp_SucursalID = PLD.SucursalID AND
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
				WHERE PLD.Fecha BETWEEN Var_FecIniMes AND Var_FechaActual
					AND TMP.NumTransaccion = Aud_NumTransaccion;

				SET Var_NumOperaciones := (SELECT COUNT(Tmp_OpeInisial) FROM TMPREGOPEINUTRAN WHERE NumTransaccion = Aud_NumTransaccion);

				IF(IFNULL(Var_NumOperaciones,Entero_Cero) > Entero_Cero)THEN

					SET	@Var_MaxIdConsec	:= (SELECT MAX(OpeInusualID) FROM PLDOPEINUSUALES);
					SET	@Var_MaxIdConsec	:= IFNULL(@Var_MaxIdConsec, Entero_Cero);

					UPDATE TMPREGOPEINUTRAN SET
						Tmp_OpeInusualID = @Var_MaxIdConsec:=@Var_MaxIdConsec+1
					WHERE NumTransaccion = Aud_NumTransaccion;

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
						Tmp_OpeInusualID,
						IFNULL(CAST(TMP.Tmp_ClaveRegistra AS CHAR),Cadena_Vacia),
						IFNULL(TMP.Tmp_NombreReg,Cadena_Vacia),
						IFNULL(TMP.Tmp_CatProcedIntID,Cadena_Vacia),
						IFNULL(TMP.Tmp_CatMotivInuID,Cadena_Vacia),
						IFNULL(Var_FechaActual, FechaVacia),
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
					FROM TMPREGOPEINUTRAN AS TMP
					WHERE TMP.NumTransaccion = Aud_NumTransaccion;

	                -- ENVIO DE CORREO POR OPERACION DETECTADA

	                INSERT INTO TMPOPERINUDETEEMAILTRAN(OpeInusualID, Transaccion, NumTransaccion)
					SELECT DISTINCT PLD.OpeInusualID, PLD.NumTransaccion, Aud_NumTransaccion
	                FROM PLDOPEINUSUALES PLD
						INNER JOIN TMPREGOPEINUTRAN TMP
							ON PLD.OpeInusualID = TMP.Tmp_OpeInusualID
								AND TMP.NumTransaccion = Aud_NumTransaccion
					WHERE PLD.NumTransaccion = Aud_NumTransaccion;

	                SET Var_Aux := Entero_Uno;
					SET Var_MaxConsecutivo := (SELECT MAX(ConsecutivoID) FROM TMPOPERINUDETEEMAILTRAN WHERE NumTransaccion = Aud_NumTransaccion);
					WHILE (Var_Aux <= Var_MaxConsecutivo) DO

	                    SET Var_OpeInusualID := (SELECT OpeInusualID FROM TMPOPERINUDETEEMAILTRAN WHERE ConsecutivoID = Var_Aux AND NumTransaccion = Aud_NumTransaccion);
	                    IF(IFNULL(Var_OpeInusualID, Entero_Cero) > Entero_Cero)THEN
							CALL PLDALERTAINUSPRO(
								Var_OpeInusualID,
	                            Str_NO,				Par_NumErr,			Par_ErrMen, 		Par_EmpresaID,		Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
							);

	                        IF(Par_NumErr <> Entero_Cero)THEN
								LEAVE ManejoErrores;
	                        END IF;
	                    END IF;

	                    SET Var_OpeInusualID := Entero_Cero;
						SET Var_Aux := Var_Aux + Entero_Uno;
					END WHILE;


				END IF;

				DELETE FROM TMPREGOPEINUTRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;
				DELETE FROM TMPPLDMOVIMIENCTATRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;
				DELETE FROM TMPPLDHISPERFDETECTRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;
				DELETE FROM TMPPLDNUMDEPORETOTRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;
				DELETE FROM TMPPLDDETECDIASMAXTRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;
				DELETE FROM TMPPLDDIASANTICITRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;
				DELETE FROM TMPPLDMONTOTCREDTRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;
				DELETE FROM TMPPLDLIQUIDAANTTRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;
				DELETE FROM TMPPLDOPEINUMAYEXITRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;
				DELETE FROM TMPPLDEXIGIBLETRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;
				DELETE FROM TMPTOTALPAGOTRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;
				DELETE FROM TMPOPERINUDETEEMAILTRAN
	            WHERE NumTransaccion = Aud_NumTransaccion;



				-- TRUNCATE TEMPPLDOPEINUSALERT;

			END IF;-- FIN DE DETECCION DE OPERACIONES POR TRANSACCION
		END IF;-- FIN DE DETECCION DE OPERACIONES INUSUALES.

		SET	Par_NumErr	:= Entero_Cero;
		SET	Par_ErrMen	:= CONCAT("Proceso de Alertas Automaticas de Operaciones Inusuales Finalizado con Exito. Credito:",Par_CreditoID," Transaccion:",Aud_NumTransaccion);

	END ManejoErrores;

	IF Par_Salida = Str_SI THEN
		SELECT	'000' AS NumErr,
				Par_ErrMen AS ErrMen,
				'opeInusualID	' AS control,
				Entero_Cero	AS consecutivo;
	END IF;
END TerminaStore$$


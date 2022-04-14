-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- inusuales
DELIMITER ;
DROP PROCEDURE IF EXISTS `inusuales`;DELIMITER $$

CREATE PROCEDURE `inusuales`(
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
	DECLARE Var_LiquidaAnticip			CHAR(1);
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
	DECLARE TipoPersonaSAFICTE			VARCHAR(3);
	DECLARE TmpMonedaBase				INT(11);
	DECLARE TmpMonedaExtrangera			INT(11);
	DECLARE Trans_EntreCtas				INT(1);
	DECLARE TipoMov_Transferencia				CHAR(1);
	DECLARE ValorDlsPorMes				DECIMAL(18,2);
	DECLARE ValorDlsPorOperacion		DECIMAL(18,2);

	-- Asignacion de Constantes --



	SET AlertasAutomati 				:= 'PR-SIS-000';															-- Clave de Alerta automatica segun catalogo PLDCATPROCEDINT --
	SET CNVBChequeDeCaja				:= '05';																	-- Deposito de cheque SBC segun la CNBV --
	SET Cadena_Vacia					:= '';																		-- Constante Vacio --
	SET TipoMov_Cheque					:= 'H';																		-- Forma de pago Cheque --
	SET Cheque_Externo					:= 'E';																		-- Es Cheque Externo --
	SET ClaveSistemaAut					:= 3;																		-- Clave de Sistema Automatico
	SET Cliente							:= 3;																		-- Tipo Canal Cliente
	SET Cre_StaPagado					:= 'P';																		-- Estatus Pagado
	SET Credito							:= 1;																		-- Tipo Canal Credito
	SET Cuenta							:= 2;																		-- Tipo Canal Cuenta
	SET Decimal_Cero					:= 0.0;																		-- Constante Cero punto Cero
	SET Des_PerfilExcedeMontoDepositos	:= 'EXCEDE MONTO DE DEPOSITOS DECLARADO EN SU PERFIL TRANSACCIONAL';		-- OPERACION INUSUAL PARA PERFIL TRANSACCIONAL
	SET Des_PerfilExcedeMontoRetiros	:= 'EXCEDE MONTO DE RETIROS DECLARADO EN SU PERFIL TRANSACCIONAL';			-- OPERACION INUSUAL PARA PERFIL TRANSACCIONAL
	SET Des_PerfilExcedeNumDepositos	:= 'EXCEDE NÚMERO DE DEPOSITOS DECLARADOS EN EL PERFIL TRANSACCIONAL';		-- OPERACION INUSUAL PARA PERFIL TRANSACCIONAL
	SET Des_PerfilExcedeNumRetiros		:= 'EXCEDE NÚMERO DE RETIROS DECLARADOS EN EL PERFIL TRANSACCIONAL';		-- OPERACION INUSUAL PARA PERFIL TRANSACCIONAL
	SET DescriLiquidAnt					:= 'CREDITO LIQUIDADO ANTICIPADAMENTE';										-- Descripcion Credito liquidado anticipadamente --
	SET DescriPagoAnticipado			:= 'PAGO DE CREDITO CON MUCHOS DIAS DE ANTICIPACION';						-- Descripcion Pago de CrÃ©dito con mnuchos dias de anticipacion --
	SET DescriPagoMayoQueExig			:= 'PAGO DE CREDITO MAYOR A EXIGIBLE';										-- Descripcion Pago de Credito Mayor a Exigible --
	SET DiaUnoDelMes					:= '01';																	-- Constante 01 sirve para concatenar la fecha inicio de mes --
	SET TipoMov_Efectivo				:= 'E';																		-- Forma de pago efectivo --
	SET Entero_Cero						:= 0;																		-- Constante Cero
	SET Entero_Uno						:= 1;																		-- Constante Uno
	SET Esta_Aplicado					:= 'A';																		-- Estatus aplicado --
	SET Esta_Autorizado					:= 'A'; 																	-- Estatus Autorizado --
	SET EstatusDesembolso				:= 'D';																		-- Estatus desembolsado de una reestructura o renovacion
	SET EstatusOpeCapturada				:= 1;																		-- Estatus de Operacion Capturada
	SET FechaVacia						:= '1900-01-01';															-- Constante 1900-01-01 --
	SET For_TipoCredito					:= 3;																		-- Tipo Instrumento Monetario Credito --
	SET For_TipoDocumento				:= 2;																		-- Tipo Instrumento Monetario Documento --
	SET For_TipoEfectivo				:= 1; 																		-- Tipo Instrumento Monetario Efectivo --
	SET For_TipoTransferencia			:= 4;																		-- Tipo Instrumento Monetario Transferencia --
	SET MonedaDolares					:= 1;																		-- Moneda Dolares
	SET MotivoAlertaAut 				:= 'SIS1';																	-- Clave de motivo de alerta automatica segun PLDCATMOTIVINU
	SET MotivoAlertaTran 				:= 'SIS2';																	-- Clave de motivo de alerta automatica segun PLDCATMOTIVINU
	SET Nat_Abono						:= 'A';																		-- Naturaleza Abono
	SET Nat_Cargo						:= 'C';																		-- Naturaleza Cargo
	SET NaturaOpeSuma 					:= 'S';																		-- Naturaleza Operacion Suma, se usa para obtener operaciones mensuales
	SET NombreDefaultSistema			:= 'SAFI';																	-- Nombre default del sistema
	SET OpeCNBVDep						:= '01';																	-- Tipo Operacion Deposito segun la CNBV --
	SET Par_ErrMen						:= Cadena_Vacia;															-- Mensaje de error vacio --
	SET Par_NumErr						:= 1;																		-- Numero error 1
	SET ParametroVigente			:= 'V';																		-- Indica Estatus Vigente en pantalla
	SET Str_NO						:= 'N';																		-- Constante N
	SET Str_SI						:= 'S';																		-- Constante S
	SET TipoOpePagoCredito			:= '09';																	-- Tipo de operacion Pago de Credito
	SET TipoPersonaSAFICTE			:= 'CTE';																	-- Tipo de Persona Cliente
	SET Trans_EntreCtas				:= 12;																		-- Tipo de Moviemiento Transferencia entre Cuentas --
	SET TipoMov_Transferencia				:= 'T';																		-- Tipo de deposito Transferencia --
	SET ValorDlsPorMes				:= 10000;																	-- Valor Dolares por mes
	SET ValorDlsPorOperacion		:= 500;																		-- Valor Dolares por Operacion --

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-PLDOPEINUSALERTPRO');
			SET VarControl := 'sqlException';
		END;

		# 1. ASIGNAR VALORES A LAS VARIABLES
		-- Obtener Valores de la Institucion
		SET	Var_EmpresaDefault		:= (SELECT MAX(EmpresaDefault) FROM PARAMETROSSIS );
		SET	Var_Institucion			:= (SELECT InstitucionID FROM PARAMETROSSIS WHERE  EmpresaID = Var_EmpresaDefault);
		SET	Var_NombreInstitucion	:= (SELECT NombreCorto FROM INSTITUCIONES WHERE InstitucionID = Var_Institucion);
		SET	Var_NombreInstitucion	:= IFNULL(Var_NombreInstitucion, NombreDefaultSistema);
		-- Calcular la Fecha de Inicio y Fin del Mes en curso a partir de la Fecha de sistema
		SET	Var_FecIniMes			:= DATE(CONCAT(CAST(YEAR(Par_FechaActual) AS CHAR),'-',CAST(MONTH(Par_FechaActual) AS CHAR),'-01'));
		SET Var_FecFinMes           := LAST_DAY(Par_FechaActual);

		# 2. LLENAR LA TABLA CON LOS MOVIMIENTOS EN LA CUENTA
		TRUNCATE TEMPPLDOPEINUSALERT;
		INSERT INTO `TEMPPLDOPEINUSALERT`(
			TransaccionID,			Fecha,				ClienteID,				TipoPersona,			NivelRiesgo,
			CuentaAhoID,			NumeroMov,			NatMovimiento,			CantidadMov,			DescripcionMov,
			TipoMovAhoID,			MonedaID,			TipoOpeCNBV,			EsEfectivo,				EsTransferencia,
			EsDocumentos,			EsCredito,			DepositosMax,			RetirosMax,				SucursalOrigen,
			NombreCompleto,			SoloNombres,		ApellidoPaterno,		ApellidoMaterno
		  )
		SELECT
			Aud_NumTransaccion,		MOV.Fecha,			CTA.ClienteID,			CTE.TipoPersona,		CTE.NivelRiesgo,
			MOV.CuentaAhoID,		MOV.NumeroMov,		MOV.NatMovimiento,		MOV.CantidadMov,		MOV.DescripcionMov,
			MOV.TipoMovAhoID,		MOV.MonedaID,		TIP.TipoOpeCNBV,		TIP.EsEfectivo,			TIP.EsTransferencia,
			TIP.EsDocumentos,		TIP.EsCredito,		PER.DepositosMax,		PER.RetirosMax,			CTE.SucursalOrigen,
			CTE.NombreCompleto,		CTE.SoloNombres,	CTE.ApellidoPaterno,	CTE.ApellidoMaterno
			FROM
				(SELECT
					ClienteID,MAX(NumeroMov) AS Movimiento, MAX(Fecha) Fecha, SUM(CantidadMov) AS Cantidad
					FROM CUENTASAHOMOV AS MOV INNER JOIN CUENTASAHO AS CTA ON MOV.CuentaAhoID = CTA.CuentaAhoID
					WHERE MOV.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes AND MOV.NatMovimiento='A' GROUP BY CTA.ClienteID) AS SUMATORIA
				INNER JOIN
				CUENTASAHOMOV AS MOV ON SUMATORIA.Movimiento = MOV.NumeroMov  INNER JOIN
				TIPOSMOVSAHO AS TIP ON MOV.TipoMovAhoID = TIP.TipoMovAhoID INNER JOIN
				CUENTASAHO AS CTA ON MOV.CuentaAhoID = CTA.CuentaAhoID INNER JOIN
				CLIENTES AS CTE ON CTA.ClienteID = CTE.ClienteID INNER JOIN
				PLDPERFILTRANS AS PER ON CTE.ClienteID = PER.ClienteID INNER JOIN
				PLDPARALEOPINUS AS PAR ON CTE.TipoPersona = PAR.TipoPersona AND CTE.NivelRiesgo = PAR.NivelRiesgo
				WHERE
					DetecPLD = 'S' AND
					SUMATORIA.Cantidad >IF(MOV.NatMovimiento='A',(PER.DepositosMax*(1+(VarPTrans/100))),(PER.RetirosMax*(1+(VarPTrans/100))))
					ORDER BY  MOV.FechaActual,CTE.ClienteID DESC;


		INSERT INTO `TEMPPLDOPEINUSALERT`(
			TransaccionID,			Fecha,				ClienteID,				TipoPersona,			NivelRiesgo,
			CuentaAhoID,			NumeroMov,			NatMovimiento,			CantidadMov,			DescripcionMov,
			TipoMovAhoID,			MonedaID,			TipoOpeCNBV,			EsEfectivo,				EsTransferencia,
			EsDocumentos,			EsCredito,			DepositosMax,			RetirosMax,				SucursalOrigen,
			NombreCompleto,			SoloNombres,		ApellidoPaterno,		ApellidoMaterno
		  )
		SELECT
			Aud_NumTransaccion,		MOV.Fecha,			CTA.ClienteID,			CTE.TipoPersona,		CTE.NivelRiesgo,
			MOV.CuentaAhoID,		MOV.NumeroMov,		MOV.NatMovimiento,		MOV.CantidadMov,		MOV.DescripcionMov,
			MOV.TipoMovAhoID,		MOV.MonedaID,		TIP.TipoOpeCNBV,		TIP.EsEfectivo,			TIP.EsTransferencia,
			TIP.EsDocumentos,		TIP.EsCredito,		PER.DepositosMax,		PER.RetirosMax,			CTE.SucursalOrigen,
			CTE.NombreCompleto,		CTE.SoloNombres,	CTE.ApellidoPaterno,	CTE.ApellidoMaterno
			FROM
				(SELECT
					ClienteID,MAX(NumeroMov) AS Movimiento, MAX(Fecha) Fecha, SUM(CantidadMov) AS Cantidad
					FROM CUENTASAHOMOV AS MOV INNER JOIN CUENTASAHO AS CTA ON MOV.CuentaAhoID = CTA.CuentaAhoID
					WHERE MOV.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes AND MOV.NatMovimiento='C' GROUP BY CTA.ClienteID) AS SUMATORIA
				INNER JOIN
				CUENTASAHOMOV AS MOV ON SUMATORIA.Movimiento = MOV.NumeroMov  INNER JOIN
				TIPOSMOVSAHO AS TIP ON MOV.TipoMovAhoID = TIP.TipoMovAhoID INNER JOIN
				CUENTASAHO AS CTA ON MOV.CuentaAhoID = CTA.CuentaAhoID INNER JOIN
				CLIENTES AS CTE ON CTA.ClienteID = CTE.ClienteID INNER JOIN
				PLDPERFILTRANS AS PER ON CTE.ClienteID = PER.ClienteID INNER JOIN
				PLDPARALEOPINUS AS PAR ON CTE.TipoPersona = PAR.TipoPersona AND CTE.NivelRiesgo = PAR.NivelRiesgo
				WHERE
					DetecPLD = 'S' AND
					SUMATORIA.Cantidad >(PER.RetirosMax*(1+(VarPTrans/100)))
					ORDER BY  MOV.FechaActual,CTE.ClienteID DESC;

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
		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		# INSTRUMENTO EFECTIVO
		 SELECT
			DATE(Par_FechaActual),			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			DATE(Par_FechaActual),			TMP.SucursalOrigen,				TMP.ClienteID,						TMP.NombreCompleto,			Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					LEFT(Des_PerfilExcedeMontoDepositos,180),		EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,					TMP.NumeroMov,				TMP.NatMovimiento,
			TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,					TipoMov_Efectivo,					TipoPersonaSAFICTE,
			TMP.SoloNombres,			TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM
				TEMPPLDOPEINUSALERT AS TMP INNER JOIN
				PLDPARALEOPINUS AS PAR ON TMP.TipoPersona = PAR.TipoPersona AND TMP.NivelRiesgo = PAR.NivelRiesgo
				WHERE
					  LOCATE(For_TipoEfectivo, PAR.TipoInstruMonID) > Entero_Cero
					 AND TMP.EsEfectivo='S'
					 AND TMP.NatMovimiento = 'A';

		  INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		  # INSTRUMENTO TRANSFERENCIAS
		  SELECT
			Par_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			Par_FechaActual,			TMP.SucursalOrigen,				TMP.ClienteID,						TMP.NombreCompleto,			Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					Des_PerfilExcedeMontoDepositos,		EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,					TMP.NumeroMov,				TMP.NatMovimiento,
			TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,					TipoMov_Transferencia,		TipoPersonaSAFICTE,
			TMP.SoloNombres,			TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM
				TEMPPLDOPEINUSALERT AS TMP INNER JOIN
				PLDPARALEOPINUS AS PAR ON TMP.TipoPersona = PAR.TipoPersona AND TMP.NivelRiesgo = PAR.NivelRiesgo
				WHERE
					 LOCATE(For_TipoTransferencia, PAR.TipoInstruMonID) > Entero_Cero
					 AND TMP.EsTransferencia='S'
					 AND TMP.NatMovimiento = 'A';

		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		  # INSTRUMENTO DOCUMENTOS
		  SELECT
			Par_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			Par_FechaActual,			TMP.SucursalOrigen,				TMP.ClienteID,						TMP.NombreCompleto,			Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					Des_PerfilExcedeMontoDepositos,		EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,					TMP.NumeroMov,				TMP.NatMovimiento,
			TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,					TipoMov_Cheque,				TipoPersonaSAFICTE,
			TMP.SoloNombres,			TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM
				TEMPPLDOPEINUSALERT AS TMP INNER JOIN
				PLDPARALEOPINUS AS PAR ON TMP.TipoPersona = PAR.TipoPersona AND TMP.NivelRiesgo = PAR.NivelRiesgo
				WHERE
					 LOCATE(For_TipoDocumento, PAR.TipoInstruMonID) > Entero_Cero
					 AND TMP.EsDocumentos='S'
					 AND TMP.NatMovimiento = 'A';

		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		  # INSTRUMENTO CREDITOS
		  SELECT
			Par_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			Par_FechaActual,			TMP.SucursalOrigen,				TMP.ClienteID,						TMP.NombreCompleto,			Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					Des_PerfilExcedeMontoDepositos,		EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,					TMP.NumeroMov,				TMP.NatMovimiento,
			TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,					TipoMov_Efectivo,			TipoPersonaSAFICTE,
			TMP.SoloNombres,			TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM
				TEMPPLDOPEINUSALERT AS TMP INNER JOIN
				PLDPARALEOPINUS AS PAR ON TMP.TipoPersona = PAR.TipoPersona AND TMP.NivelRiesgo = PAR.NivelRiesgo
				WHERE
					 LOCATE(For_TipoCredito, PAR.TipoInstruMonID) > Entero_Cero
					 AND TMP.EsCredito='S'
					 AND TMP.NatMovimiento = 'A';

		# RETIRO ---------------------------------------------------------------------------------------------------------------------------
		# ----------------------------------------------------------------------------------------------------------------------------------
		# ----------------------------------------------------------------------------------------------------------------------------------
		# Insertamos todas las operaciones que superaron lo declarado en el perfil transaccion por deposito.
		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		# INSTRUMENTO EFECTIVO
		  SELECT
			Par_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			Par_FechaActual,			TMP.SucursalOrigen,				TMP.ClienteID,						TMP.NombreCompleto,			Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					Des_PerfilExcedeMontoRetiros,		EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,					TMP.NumeroMov,				TMP.NatMovimiento,
			TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,					TipoMov_Efectivo,					TipoPersonaSAFICTE,
			TMP.SoloNombres,			TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM
				TEMPPLDOPEINUSALERT AS TMP INNER JOIN
				PLDPARALEOPINUS AS PAR ON TMP.TipoPersona = PAR.TipoPersona AND TMP.NivelRiesgo = PAR.NivelRiesgo
				WHERE
					 LOCATE(For_TipoEfectivo, PAR.TipoInstruMonID) > Entero_Cero
					 AND TMP.EsEfectivo='S'
					 AND TMP.NatMovimiento = 'C'
		  UNION ALL
		  # INSTRUMENTO TRANSFERENCIAS
		  SELECT
			Par_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			Par_FechaActual,			TMP.SucursalOrigen,				TMP.ClienteID,						TMP.NombreCompleto,			Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					Des_PerfilExcedeMontoRetiros,		EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,					TMP.NumeroMov,				TMP.NatMovimiento,
			TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,					TipoMov_Transferencia,		TipoPersonaSAFICTE,
			TMP.SoloNombres,			TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM
				TEMPPLDOPEINUSALERT AS TMP INNER JOIN
				PLDPARALEOPINUS AS PAR ON TMP.TipoPersona = PAR.TipoPersona AND TMP.NivelRiesgo = PAR.NivelRiesgo
				WHERE
					 LOCATE(For_TipoTransferencia, PAR.TipoInstruMonID) > Entero_Cero
					 AND TMP.EsTransferencia='S'
					 AND TMP.NatMovimiento = 'C'
		  UNION ALL
		  # INSTRUMENTO DOCUMENTOS
		  SELECT
			Par_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			Par_FechaActual,			TMP.SucursalOrigen,				TMP.ClienteID,						TMP.NombreCompleto,			Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					Des_PerfilExcedeMontoRetiros,		EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,					TMP.NumeroMov,				TMP.NatMovimiento,
			TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,					TipoMov_Cheque,				TipoPersonaSAFICTE,
			TMP.SoloNombres,			TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM
				TEMPPLDOPEINUSALERT AS TMP INNER JOIN
				PLDPARALEOPINUS AS PAR ON TMP.TipoPersona = PAR.TipoPersona AND TMP.NivelRiesgo = PAR.NivelRiesgo
				WHERE
					 LOCATE(For_TipoDocumento, PAR.TipoInstruMonID) > Entero_Cero
					 AND TMP.EsDocumentos='S'
					 AND TMP.NatMovimiento = 'C'
		  UNION ALL
		  # INSTRUMENTO CREDITOS
		  SELECT
			Par_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			Par_FechaActual,			TMP.SucursalOrigen,				TMP.ClienteID,						TMP.NombreCompleto,			Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					Des_PerfilExcedeMontoRetiros,		EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					Entero_Cero,					TMP.CuentaAhoID,					TMP.NumeroMov,				TMP.NatMovimiento,
			TMP.CantidadMov,			TMP.MonedaID,					TMP.TipoOpeCNBV,					TipoMov_Efectivo,			TipoPersonaSAFICTE,
			TMP.SoloNombres,			TMP.ApellidoPaterno,			TMP.ApellidoMaterno
			FROM
				TEMPPLDOPEINUSALERT AS TMP INNER JOIN
				PLDPARALEOPINUS AS PAR ON TMP.TipoPersona = PAR.TipoPersona AND TMP.NivelRiesgo = PAR.NivelRiesgo
				WHERE
					 LOCATE(For_TipoCredito, PAR.TipoInstruMonID) > Entero_Cero
					 AND TMP.EsCredito='S'
					 AND TMP.NatMovimiento = 'C';







		# Plazo Mínimo de Pago Anticipado en Cuotas Exigibles --------------------------------------------------------------------------
		# ------------------------------------------------------------------------------------------------------------------------------
		# Se Registran como alertas, todos los pagos que se registraton  'W' dias antes de su exigibilidad
		# Siempre y cuando el monto total de pago anticipado supere el monto del perfil transaccional	mas el porcentaje de tolerancia
		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		  SELECT
			Par_FechaActual,			ClaveSistemaAut,				Var_NombreInstitucion,				AlertasAutomati,			MotivoAlertaAut,
			Par_FechaActual,			MAX(CLI.SucursalOrigen),		MAX(CLI.ClienteID),					MAX(CLI.NombreCompleto),	Cadena_Vacia,
			Str_NO,						Cadena_Vacia,					DescriPagoAnticipado,				EstatusOpeCapturada,		Cadena_Vacia,
			FechaVacia,					MAX(CRED.CreditoID),			MAX(CRED.CuentaID),					DET.Transaccion,			Nat_Abono,
			SUM(DET.MontoTotPago),		1,								TipoOpePagoCredito,					TipoMov_Efectivo,			TipoPersonaSAFICTE,
			MAX(CLI.SoloNombres),		MAX(CLI.ApellidoPaterno),		MAX(CLI.ApellidoMaterno)
		  FROM
			DETALLEPAGCRE AS DET INNER JOIN
			AMORTICREDITO AS AMOR ON DET.CreditoID = AMOR.CreditoID AND AMOR.AmortizacionID = DET.AmortizacionID INNER JOIN
			CREDITOS AS CRED ON DET.CreditoID = CRED.CreditoID INNER JOIN
			CLIENTES AS CLI ON CRED.ClienteID = CLI.ClienteID INNER JOIN
			PLDPERFILTRANS AS PLD ON CLI.ClienteID = PLD.ClienteID INNER JOIN
			PLDPARALEOPINUS AS PAR ON CLI.TipoPersona = PAR.TipoPersona AND CLI.NivelRiesgo = PAR.NivelRiesgo
			WHERE
			DATEDIFF(AMOR.FechaExigible,DET.FechaPago)>PAR.VarPlazo AND
			DET.FechaPago = Par_FechaActual AND
			CRED.CreditoID NOT IN (SELECT CreditoOrigenID FROM REESTRUCCREDITO
													WHERE FechaRegistro = Par_FechaActual
														AND EstatusReest = EstatusDesembolso)
			GROUP BY DET.Transaccion;

		#  Liquidación Anticipada -----------------------------------------------------------------------------------------------------
		# ------------------------------------------------------------------------------------------------------------------------------
		# Se Registran como alertas, todos los pagos que se registraton  'W' dias antes de su exigibilidad
		# Siempre y cuando el monto total de pago anticipado supere el monto del perfil transaccional	mas el porcentaje de tolerancia
		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,				Tmp_NombreReg,						Tmp_CatProcedIntID,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,					Tmp_ClavePersonaInv,				Tmp_NomPersonaInv,			Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,				Tmp_DesOperacion,					Tmp_Estatus,				Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,					Tmp_CuentaID,						Tmp_TransaccionOpe,			Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,					Tmp_TipoOpeCNBV,					Tmp_FormaPago,				Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,		Tmp_ApMaternoPersonaInv)
		  SELECT
			MAX(Par_FechaActual),			MAX(ClaveSistemaAut),				MAX(Var_NombreInstitucion),				MAX(AlertasAutomati),			MotivoAlertaAut,
			MAX(Par_FechaActual),			MAX(CLI.SucursalOrigen),			CLI.ClienteID,							MAX(CLI.NombreCompleto),			Cadena_Vacia,
			Str_NO,							MAX(Cadena_Vacia),					DescriLiquidAnt,						EstatusOpeCapturada,		Cadena_Vacia,
			MAX(FechaVacia),				CRED.CreditoID,						MAX(CRED.CuentaID),						MAX(DET.Transaccion),			Nat_Abono,
			MAX(DET.MontoTotPago),			1,									TipoOpePagoCredito,						TipoMov_Efectivo,			TipoPersonaSAFICTE,
			MAX(CLI.SoloNombres),			MAX(CLI.ApellidoPaterno),			MAX(CLI.ApellidoMaterno)
			FROM
				CREDITOS AS CRED INNER JOIN
				CLIENTES AS CLI ON CRED.ClienteID = CLI.ClienteID INNER JOIN
				PLDPARALEOPINUS AS PAR ON CLI.TipoPersona = PAR.TipoPersona AND CLI.NivelRiesgo = PAR.NivelRiesgo LEFT JOIN
				DETALLEPAGCRE AS DET ON DET.CreditoID AND CRED.NumTransaccion = DET.NumTransaccion
				WHERE
					PAR.LiquidAnticipad = 'S' AND
					CRED.FechTerminacion = Par_FechaActual AND
					CRED.FechaVencimien > CRED.FechTerminacion AND
					CRED.Estatus = 'P'
					GROUP BY CRED.CreditoID,CLI.ClienteID;

		-- Registrar las alertas para los casos donde el NUmero de Depositos o Retiros sobre las Cuentas
		-- supere lo indicado en la trasnaccionalidad y los parametros de Alertas
		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,			Tmp_NombreReg,					Tmp_CatProcedIntID	,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,				Tmp_ClavePersonaInv,			Tmp_NomPersonaInv,				Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,			Tmp_DesOperacion,				Tmp_Estatus,					Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,				Tmp_CuentaID,					Tmp_TransaccionOpe,				Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,				Tmp_TipoOpeCNBV,        		Tmp_FormaPago,					Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,	Tmp_ApMaternoPersonaInv)
			SELECT
			DISTINCT
			Par_FechaActual,			ClaveSistemaAut,			Var_NombreInstitucion,			AlertasAutomati,				MotivoAlertaTran,
			Par_FechaActual,			tmp.SucursalCli,			tmp.ClienteID,					tmp.NombreCliente,				Cadena_Vacia,
			Str_NO,						Cadena_Vacia,				Des_PerfilExcedeNumDepositos,	EstatusOpeCapturada,			Cadena_Vacia,
			FechaVacia,					Entero_Cero,				tmp.CuentasAhoID,				tmp.NumeroMov,					tmp.NatMovimiento,
			tmp.CantidadMov,			tmp.MonedaID,				tmp.TipoOpeCNBV,				tmp.FormaPago,					TipoPersonaSAFICTE,
			CTE.SoloNombres,			CTE.ApellidoPaterno,		CTE.ApellidoMaterno
			FROM PLDOPEINUSALERTNUM AS tmp INNER JOIN
				CLIENTES AS CTE ON tmp.ClienteID = CTE.ClienteID INNER JOIN
				PLDPERFILTRANS AS PLD ON CTE.ClienteID = PLD.ClienteID INNER JOIN
				PLDPARALEOPINUS AS PAR ON CTE.TipoPersona = PAR.TipoPersona AND CTE.NivelRiesgo = CTE.NivelRiesgo
				WHERE
					tmp.Fecha = Par_FechaActual AND
					tmp.NatMovimiento = 'A' AND
					PLD.NumDepoApli >(PLD.NumDepositos*(1+(PAR.VarNumDep/100)))
					ORDER BY tmp.ClienteID, tmp.CuentasAhoID;


		INSERT INTO TMPREGOPEINU (
			Tmp_Fecha,					Tmp_ClaveRegistra,			Tmp_NombreReg,					Tmp_CatProcedIntID	,			Tmp_CatMotivInuID,
			Tmp_FechaDeteccion,			Tmp_SucursalID,				Tmp_ClavePersonaInv,			Tmp_NomPersonaInv,				Tmp_EmpInvolucrado,
			Tmp_Frecuencia,				Tmp_DesFrecuencia,			Tmp_DesOperacion,				Tmp_Estatus,					Tmp_ComentarioOC,
			Tmp_FechaCierre,			Tmp_CreditoID,				Tmp_CuentaID,					Tmp_TransaccionOpe,				Tmp_NaturalezaOpe,
			Tmp_MontoOperacion,			Tmp_MonedaID,				Tmp_TipoOpeCNBV,        		Tmp_FormaPago,					Tmp_TipoPersonaSAFI,
			Tmp_NombresPersonaInv,		Tmp_ApPaternoPersonaInv,	Tmp_ApMaternoPersonaInv)
			SELECT
			DISTINCT
			Par_FechaActual,			ClaveSistemaAut,			Var_NombreInstitucion,			AlertasAutomati,				MotivoAlertaTran,
			Par_FechaActual,			tmp.SucursalCli,			tmp.ClienteID,					tmp.NombreCliente,				Cadena_Vacia,
			Str_NO,						Cadena_Vacia,				Des_PerfilExcedeNumRetiros,		EstatusOpeCapturada,			Cadena_Vacia,
			FechaVacia,					Entero_Cero,				tmp.CuentasAhoID,				tmp.NumeroMov,					tmp.NatMovimiento,
			tmp.CantidadMov,			tmp.MonedaID,				tmp.TipoOpeCNBV,				tmp.FormaPago,					TipoPersonaSAFICTE,
			CTE.SoloNombres,			CTE.ApellidoPaterno,		CTE.ApellidoMaterno
			FROM PLDOPEINUSALERTNUM AS tmp INNER JOIN
				CLIENTES AS CTE ON tmp.ClienteID = CTE.ClienteID INNER JOIN
				PLDPERFILTRANS AS PLD ON CTE.ClienteID = PLD.ClienteID INNER JOIN
				PLDPARALEOPINUS AS PAR ON CTE.TipoPersona = PAR.TipoPersona AND CTE.NivelRiesgo = CTE.NivelRiesgo
				WHERE
					tmp.Fecha = Par_FechaActual AND
					tmp.NatMovimiento = 'C' AND
					PLD.NumRetiApli >(PLD.NumRetiros*(1+(PAR.VarNumRet/100)))
					ORDER BY tmp.ClienteID, tmp.CuentasAhoID;


	-- En caso de que se evaluen los creditos --

		-- Tabla Temporal de Detalle de Pagos de Credito realizados el dia actual
		DROP TABLE IF EXISTS TMPDETALLEPAGCRE;
		CREATE TEMPORARY TABLE TMPDETALLEPAGCRE AS
		SELECT	Pag.ClienteID AS ClienteID
				,Pag.CreditoID AS CreditoID
				,Amo.CuentaID AS CuentaID
				,MIN(Pag.NumTransaccion) AS NumTransaccion
				,SUM(Pag.MontoTotPago) AS MontoPagado
				,SUM(CASE WHEN Amo.FechaExigible <= Par_FechaActual THEN MontoTotPago ELSE Decimal_Cero END) AS MontoExigible
				,MAX(FechaExigible) AS Exigibilidad
				,DATEDIFF(MAX(FechaExigible), Par_FechaActual) AS DiasAnticipacion
		FROM DETALLEPAGCRE	Pag
		INNER JOIN AMORTICREDITO Amo ON Pag.CreditoId = Amo.CreditoID AND Pag.AmortizacionID = Amo.AmortizacionID
		INNER JOIN CREDITOS	Cre ON Pag.CreditoID = Cre.CreditoID
		WHERE Pag.FechaPago = Par_FechaActual
		AND Pag.CreditoID NOT IN (SELECT CreditoOrigenID FROM REESTRUCCREDITO WHERE FechaRegistro = Par_FechaActual AND EstatusReest = EstatusDesembolso)  -- se excluyen los pagos por Reestructura o renovacion
		GROUP BY Pag.ClienteID, Pag.CreditoID,  Amo.CuentaID;

		-- Se Registran como alertas, todos los pagos que superan el monto exigible mas el 'Y' porcentaje de tolerancia
		-- Siempre y cuando el monto total de pago supere el monto del perfil transaccional	mas el porcentaje de tolerancia
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
			FechaVacia AS FechaCierre,			Tmp.CreditoID AS CreditoID,				Tmp.CuentaID AS CuentaID,					Tmp.NumTransaccion AS TransaccionOpe,		'A' AS NaturalezaOpe,
			Tmp.MontoPagado AS MontoOperacion,	Cue.MonedaID AS MonedaID,				TipoOpePagoCredito,							'E',								TipoPersonaSAFICTE,
			CONCAT(RTRIM(LTRIM(IFNULL(Cli.PrimerNombre, ''))),
				CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Cli.SegundoNombre, ''))))  > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Cli.SegundoNombre, '')))) ELSE '' END,
				CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Cli.TercerNombre, ''))))   > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Cli.TercerNombre, '')))) ELSE '' END) AS NombresPersonaInv,
												Cli.ApellidoPaterno, 					Cli.ApellidoMaterno
				FROM TMPDETALLEPAGCRE Tmp
				INNER JOIN CLIENTES Cli ON Cli.ClienteID = Tmp.ClienteID
				INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Tmp.CuentaID
				INNER JOIN PLDPERFILTRANS Per ON Per.ClienteID = Tmp.ClienteID
				INNER JOIN PLDPARALEOPINUS PLD ON Cli.TipoPersona = PLD.TipoPersona AND Cli.NivelRiesgo = PLD.NivelRiesgo
				AND Tmp.MontoPagado > ((1+(PLD.VarPagos/100))*IFNULL(Per.DepositosMax, 0))
				AND LOCATE(For_TipoCredito, PLD.TipoInstruMonID) > Entero_Cero;


		SET	Var_MaxIdConsec	:= (SELECT MAX(OpeInusualID) FROM PLDOPEINUSUALES);
		SET	Var_MaxIdConsec	:= IFNULL(Var_MaxIdConsec, Entero_Cero);


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
			IFNULL((TMP.Tmp_OpeInisial+Var_MaxIdConsec),Entero_Cero),
			IFNULL(CAST(TMP.Tmp_ClaveRegistra AS CHAR),Cadena_Vacia),
			IFNULL(TMP.Tmp_NombreReg,Cadena_Vacia),
			IFNULL(TMP.Tmp_CatProcedIntID,Cadena_Vacia),
			IFNULL(TMP.Tmp_CatMotivInuID,Cadena_Vacia),
			IFNULL(TMP.Tmp_FechaDeteccion,Cadena_Vacia),
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
			IFNULL(TMP.Tmp_TransaccionOpe,Cadena_Vacia),
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
		FROM TMPREGOPEINU AS TMP LEFT JOIN
			PLDOPEINUSUALES AS PLD ON
			TMP.Tmp_ClavePersonaInv = PLD.ClavePersonaInv AND
			TMP.Tmp_SucursalID = PLD.SucursalID AND
			TMP.Tmp_NomPersonaInv = PLD.NomPersonaInv AND
			TMP.Tmp_MonedaID = PLD.MonedaID AND
			TMP.Tmp_CatProcedIntID = PLD.CatProcedIntID AND
			TMP.Tmp_CatMotivInuID = PLD.CatMotivInuID AND
			TMP.Tmp_DesOperacion = PLD.DesOperacion AND
			TMP.Tmp_CreditoID = PLD.CreditoID AND
			TMP.Tmp_CuentaID = PLD.CuentaAhoID AND
			TMP.Tmp_TransaccionOpe = PLD.TransaccionOpe AND
			TMP.Tmp_NaturalezaOpe = PLD.NaturaOperacion AND
			TMP.Tmp_MontoOperacion = PLD.MontoOperacion AND
			TMP.Tmp_FormaPago = PLD.FormaPago AND
			TMP.Tmp_TipoPersonaSAFI = PLD.TipoPersonaSAFI AND
			TMP.Tmp_TipoOpeCNBV = PLD.TipoOpeCNBV AND
			(PLD.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes)
			WHERE PLD.DesOperacion IS null;


		DROP TABLE IF EXISTS TMPREGOPEINU;
		TRUNCATE TEMPPLDOPEINUSALERT;


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

		IF Par_Salida = Str_SI THEN
			SELECT	'000' AS NumErr,
					Par_ErrMen AS ErrMen,
					'opeInusualID	' AS control,
					Entero_Cero	AS consecutivo;
		END IF;
		LEAVE ManejoErrores;

	END ManejoErrores;

END TerminaStore$$
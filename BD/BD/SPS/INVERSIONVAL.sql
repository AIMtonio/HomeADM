-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONVAL`;
DELIMITER $$


CREATE PROCEDURE `INVERSIONVAL`(
-- SP de Validacion para las inversiones
		Par_InversionID				 INT,
		Par_CuentaAhoID				BIGINT(12),				-- Cuenta de ahorro
		Par_ClienteID				INT,				-- Cliente ID
		Par_TipoInversionID			INT,				-- Tipo de Producto
		Par_FechaInicio				DATE,				-- Fecha de Inicio
		Par_FechaVencimiento		DATE,				-- Fecha de Vencimiento

		Par_Monto					DECIMAL(12,2),
		Par_Plazo					INT,
		Par_Tasa					DECIMAL(8,4),
		Par_TasaISR					DECIMAL(8,4),
		Par_TasaNeta				DECIMAL(8,4),

		Par_InteresGenerado			DECIMAL(12,2),
		Par_InteresRecibir			DECIMAL(12,2),
		Par_InteresRetener			DECIMAL(12,2),
		Par_Reinvertir				VARCHAR(5),
		Par_Usuario					INT,

		Par_TipoAlta				INT,
		Par_ReinversionId			INT,
		Par_MonedaID				INT,
		Par_Etiqueta				VARCHAR(100),
		 Par_Beneficiario				CHAR(1), -- Tipo de Beneficiario(Cuenta Socio o Propio de inversion)
			Par_UsuarioClave			VARCHAR(25),
		Par_ContraseniaAut			VARCHAR(45),

			Par_Salida					CHAR(1),			-- Salida S: Si N:No
		INOUT Par_NumErr			INT(11),			-- Numero de error
		INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de error
		Par_EmpresaID				INT,
		Par_FechaActual				DATETIME,

		Par_DireccionIP				VARCHAR(15),
		Par_ProgramaID				VARCHAR(50),
		Par_Sucursal				INT,
		Par_NumeroTransaccion		BIGINT

)

TerminaStore: BEGIN
-- Declaracion de Variables
/* DECLARACION DE CONSTANTES */
DECLARE VarStatusInversion			CHAR(5);
DECLARE VarFechaVencimiento			DATE;
DECLARE Var_MontoOriginal			DECIMAL(12, 2);
DECLARE Var_InteresRecibir			DECIMAL(12, 2);
DECLARE Var_InteresGenerado			DECIMAL(12, 2);
DECLARE InteresGeneradoMN			DECIMAL(12, 2);
DECLARE Var_InteresRetener			DECIMAL(12, 2);
DECLARE Var_PolizaID				BIGINT(20);

DECLARE Var_Cue_Saldo				DECIMAL(12, 2);
DECLARE Var_CueMoneda				INT(11);
DECLARE Var_CueEstatus				CHAR(1);
DECLARE Var_CueClienteID			BIGINT(20);
DECLARE Var_MonTipoInv				INT(11);
DECLARE Var_TasaISR					DECIMAL(8, 4);
DECLARE Var_PagaISR					CHAR(1);
DECLARE Var_DiasInversion			DECIMAL(12,4);
DECLARE Var_MovIntere				VARCHAR(4);
DECLARE Var_Provision				DECIMAL(12, 2);
DECLARE Var_MonedaBase				INT(11);
DECLARE Var_TipCamCom				DECIMAL(8,4);
DECLARE Var_TipCamVen				DECIMAL(8,4);
DECLARE Var_Instrumento				VARCHAR(20);
DECLARE Var_CuentaStr				VARCHAR(20);
DECLARE Var_IntGenOriginal			DECIMAL(12, 2);
DECLARE Var_IntRetMN				DECIMAL(12, 2);
DECLARE Cue_PagIntere 				CHAR(50);
DECLARE Var_FechaSis				DATE;
DECLARE Var_TotDispon				DECIMAL(12, 2);
DECLARE Var_Estatus					CHAR(1);
DECLARE Cal_GATReal					DECIMAL(12,2);
DECLARE Var_SaldoProvision			DECIMAL(12,2);
DECLARE Var_ValorUMA				DECIMAL(12,4);
DECLARE Var_TipoPersona				CHAR(1);

DECLARE Entero_Cero					INT(11);
DECLARE Fecha_Vacia					DATE;
DECLARE Factor_Porcen				DECIMAL(12,2);
DECLARE Cadena_Vacia				CHAR(1);
DECLARE Decimal_Cero				DECIMAL(12,2);
DECLARE Alta_Inversion				INT(11);
DECLARE Alta_ReInversion			INT(11);
DECLARE Pol_Automatica				CHAR(1);
DECLARE AltPoliza_NO				CHAR(1);
DECLARE Salida_NO					CHAR(1);
DECLARE StaAlta						CHAR(1);
DECLARE StaInvVigente				CHAR(1);
DECLARE StaInvPagada				CHAR(1);
DECLARE SI_PagaISR					CHAR(1);
DECLARE Nat_Cargo					CHAR(1);
DECLARE Nat_Abono					CHAR(1);
DECLARE Var_MovPagInv				VARCHAR(4);
DECLARE Var_MovIntExe				VARCHAR(4);
DECLARE Var_MovIntGra				VARCHAR(4);
DECLARE Var_MovRetenc				VARCHAR(4);
DECLARE Var_Reinversion				VARCHAR(4);
DECLARE Var_ConInvCapi				INT(11);
DECLARE Var_ConInvISR				INT(11);
DECLARE Var_ConInvProv 				INT(11);
DECLARE Var_ConConInv				INT(11);
DECLARE Var_ConConReinv				INT(11);
DECLARE Var_ConAhoCapi				INT(11);
DECLARE Var_DescriReinv				VARCHAR(50);
DECLARE Var_Referencia				VARCHAR(50);
DECLARE Var_NoImpresa				CHAR(1);
DECLARE Ope_Interna					CHAR(1);
DECLARE Tip_Venta					CHAR(1);
DECLARE Tip_Compra					CHAR(1);
DECLARE Tipo_Provision				CHAR(4);
DECLARE Cue_PagIntExe 				CHAR(50);
DECLARE Cue_PagIntGra 				CHAR(50);
DECLARE Cue_RetInver				CHAR(50);
DECLARE Mov_AhorroSI				CHAR(1);
DECLARE Mov_AhorroNO				CHAR(1);
DECLARE Var_SalMinDF				DECIMAL(12,2);	/*Salario minimo segun el df*/
DECLARE Var_SalMinAn				DECIMAL(12,2);	/*Salario minimo anualizado segun el df*/
DECLARE Cal_GAT						DECIMAL(12,2);
DECLARE Bene_CtaSocio				CHAR(1); -- Beneficiario de la cuenta socio --
DECLARE Usuario						CHAR(2);
DECLARE Bene_Inversion				CHAR(1);
DECLARE Inactivo					CHAR(1);
DECLARE MenorEdad					CHAR(1);
DECLARE Var_FuncionHuella			CHAR(1);
DECLARE Var_ReqHuellaProductos		CHAR(1);
DECLARE Huella_SI					CHAR(1);
DECLARE Var_Control					VARCHAR(30);
DECLARE Var_Consecutivo				VARCHAR(30);
DECLARE Salida_SI					CHAR(1);
DECLARE Var_VencimientoAnticipado 	INT(1);
DECLARE Var_CancelaInversion	 	INT(11);
DECLARE Var_CancelaReinversion		INT(11);
DECLARE Var_Autoriza				INT(11);
DECLARE Var_ImprimePagare		 	INT(11);
DECLARE Var_InverEnGar				INT(11);
DECLARE NombreProceso		 		VARCHAR(16);
DECLARE SalidaNO					CHAR(1);
DECLARE Estatus_Vigente				CHAR(2);

DECLARE Estatus_Alta				CHAR(2);
DECLARE Estatus_Pagada				CHAR(2);
DECLARE Estatus_Cancel				CHAR(2);
DECLARE Var_FechaSucursal		 	DATE;
DECLARE Var_Cuenta					BIGINT(12);
DECLARE VarControl					CHAR(15);
DECLARE Var_Monto					DECIMAL(14,2);
DECLARE Var_InteresOriginal			DECIMAL(14,2);
DECLARE Var_InverFecIni				DATE;
DECLARE Var_EstatusImp			 	CHAR(1);
DECLARE Var_Cliente				 	BIGINT(20);
DECLARE Var_Moneda					INT(11);
DECLARE Var_IntRetener			 	DECIMAL(14,2);
DECLARE Var_SalProvision			DECIMAL(14,2);
DECLARE Var_InteresGen			 	DECIMAL(14,2);
DECLARE Cue_PagIntAntiExe		 	CHAR(50);
DECLARE Cue_PagIntAntiGra		 	CHAR(50);
DECLARE Var_Vencim_Anticipada		INT(11);
DECLARE Var_ClienteID				INT(11);
DECLARE Var_Beneficiario			CHAR(1);
DECLARE Var_EstatusCli				CHAR(1);


DECLARE AltPoliza_SI				CHAR(1);
DECLARE Pagare_Impreso_SI			CHAR(1);
DECLARE Pagare_Impreso_NO			CHAR(1);


DECLARE Con_Capital					INT(11);
DECLARE Var_ConAltInv		 		INT(11);
DECLARE Var_ConCanInv		 		INT(11);
DECLARE Var_PagoInver		 		INT(11);
DECLARE Var_PagoInverAnti			INT(11);
DECLARE Mov_ApeInver				VARCHAR(4);
DECLARE Mov_PagInvCap		 		VARCHAR(4);
DECLARE	Mov_PagInvrAnti	 			VARCHAR(4);
DECLARE Mov_PagIntExe		 		VARCHAR(4);
DECLARE Mov_PagIntGra		 		VARCHAR(4);
DECLARE Mov_PagInvRet		 		VARCHAR(4);
DECLARE Mov_CanInver				VARCHAR(4);
DECLARE No_Reinvertir		 		CHAR(1);
DECLARE SalidaSI					CHAR(1);
DECLARE Var_RefPagoInv				VARCHAR(100);
DECLARE Var_RefPagoAnti				VARCHAR(100);
DECLARE Var_DiasTrascurrido 		INT(11);
DECLARE Var_Plazo					INT(11);
DECLARE Var_Tasa					DECIMAL(12,2);
DECLARE Var_UsuarioID				INT(11);
DECLARE Var_Contrasenia 			VARCHAR(45);
DECLARE TipoBenefInver				CHAR(1);
DECLARE AltaEncPolizaSi				CHAR(1);
DECLARE VarProcesoCancel			VARCHAR(100);

DECLARE Act_LiberarInver			INT(11);
DECLARE ValorUMA					VARCHAR(15);
/* ASIGNACION DE CONSTANTES */
SET	Entero_Cero					:= 	0;
SET	Cadena_Vacia				:= 	'';
SET	Decimal_Cero				:= 	0;
SET	Salida_NO					:= 	'N';			-- Salida No
SET	Salida_SI					:= 	'S';			-- Salida SI
SET	Fecha_Vacia					:= 	'1900-01-01';
SET	Factor_Porcen				:= 	100.00;
SET	Alta_Inversion				:= 	1;
SET	Alta_ReInversion 			:= 	3;
SET	AltPoliza_NO				:= 	'N';
SET	Salida_NO					:= 	'N';
SET	Pol_Automatica				:= 	'A';
SET	StaAlta						:= 	'A';
SET	StaInvVigente				:= 	'N';
SET	StaInvPagada				:= 	'P';
SET	SI_PagaISR					:= 	'S';
SET	Nat_Cargo					:= 	'C';
SET	Nat_Abono					:= 	'A';
SET	Var_NoImpresa				:= 	'N';

SET	Ope_Interna					:= 	'I';
SET	Tip_Venta					:= 	'V';
SET	Tip_Compra					:= 	'C';

SET	Var_MovPagInv				:= 	'61';
SET	Var_MovIntGra				:= 	'62';
SET	Var_MovIntExe				:= 	'63';
SET	Var_MovRetenc				:= 	'64';
SET	Var_Reinversion				:= 	'65';

SET	Var_ConInvCapi				:= 	1;
SET	Var_ConInvISR				:= 	4;
SET	Var_ConInvProv				:= 	5;

SET	Var_ConAhoCapi 				:= 	1;
SET	Var_ConConInv				:= 	10;
SET	Var_ConConReinv				:= 	11;
SET	Tipo_Provision				:= 	'100';

SET	Mov_AhorroSI				:= 	'S';
SET	Mov_AhorroNO				:= 	'N';

SET	Cue_PagIntExe 				:= 	'Pago Inversion. Interes Excento';
SET	Cue_PagIntGra 				:= 	'Pago Inversion. Interes Gravado';
SET	Cue_RetInver				:= 	'Retencion ISR Inversion';
SET	NombreProceso				:= 	'INVERSION';

SET	Var_DescriReinv				:= 	'Reinversion Individual';
SET	Var_Referencia				:= 	'Rendimiento Inversion';
SET	Cal_GAT						:=	0.00;
SET	Bene_CtaSocio				:= 	'S'; -- Beneficiario de la cuenta socio

SET	VarStatusInversion			:= 	'';
SET	Var_MontoOriginal			:= 	0.0;
SET	Var_InteresRecibir			:= 	0.0;

SET	Par_ErrMen					:= 	'';
SET	Usuario						:= 	'';
SET	Bene_Inversion				:=	'I';		-- Beneficiario propio de la inversion

SET	Par_FechaActual 			:= 	NOW();
SET	Inactivo					:=	'I';
SET	MenorEdad					:=	"S";
SET	Huella_SI					:=	"S";
SET	Var_VencimientoAnticipado	:= 	8;
SET	Var_CancelaInversion	 	:= 	2;
SET	Var_CancelaReinversion		:= 	4;
SET	Var_Autoriza				:= 	6;
SET	Var_ImprimePagare		 	:= 	7;
SET	SalidaNO		 			:= 	'N';
SET	Estatus_Alta	 			:= 	'A';
SET	Estatus_Vigente 			:= 	'N';
SET	Estatus_Pagada				:= 	'P';
SET	Estatus_Cancel				:= 	'C';
	 SELECT FechaSucursal INTO Var_FechaSucursal
	FROM SUCURSALES
	WHERE SucursalID = Par_Sucursal;

SET	Var_CancelaInversion	 	:= 	2;
SET	Var_CancelaReinversion		:= 	4;
SET	Var_Autoriza				:= 	6;
SET	Var_ImprimePagare		 	:= 	7;
SET	Var_Vencim_Anticipada		:= 	8;

SET	AltPoliza_SI		 		:= 	'S';
SET	AltPoliza_NO				:= 	'N';
SET	Pagare_Impreso_SI			:= 	'S';
SET	Pagare_Impreso_NO			:= 	'N';
SET	Mov_AhorroSI				:= 	'S';
SET	Mov_AhorroNO				:= 	'N';
SET	Cadena_Vacia				:= 	'';
SET	Entero_Cero					:= 	0;
SET	Decimal_Cero				:=	0.00;
SET	Con_Capital					:= 	1;
SET	Var_ConInvCapi				:= 	1;
SET	Var_ConInvProv				:= 	5;
SET	Var_ConInvISR		 		:= 	4;

SET	Var_ConAltInv		 		:= 	10;
SET	Var_ConCanInv		 		:= 	12;
SET	Var_PagoInver		 		:= 	15;
SET	Var_PagoInverAnti			:= 	16;

SET	Factor_Porcen				:= 	100.00;


SET	Mov_ApeInver				:= 	'60';
SET	Mov_PagInvCap		 		:= 	'61';
SET	Mov_PagInvrAnti		 		:= 	'68';

SET	Mov_PagIntGra		 		:= 	'62';
SET	Mov_PagIntExe		 		:= 	'63';
SET	Mov_PagInvRet		 		:= 	'64';
SET	Mov_CanInver				:= 	'67';


SET	Estatus_Alta	 			:= 	'A';
SET	Estatus_Vigente 			:= 	'N';
SET	No_Reinvertir				:= 	'N';
SET	Estatus_Pagada				:= 	'P';
SET	Estatus_Cancel				:= 	'C';
SET	Nat_Cargo		 			:= 	'C';
SET	Nat_Abono		 			:= 	'A';
SET	SalidaSI					:= 	'S';
SET	SalidaNO		 			:= 	'N';
SET	Tipo_Provision 				:= 	'100';
SET	Pol_Automatica				:= 	'A';
SET	Ope_Interna					:= 	'I';
SET	Tip_Compra					:= 	'C';
SET	SI_PagaISR					:= 	'S';

SET	Var_RefPagoInv				:= 	'PAGO DE INVERSION';
SET	Var_RefPagoAnti				:= 	'VENCIMIENTO ANTICIPADO INVERSION';
SET	NombreProceso				:= 	'INVERSION';
SET	Cue_PagIntExe				:= 	'PAGO INVERSION. INTERES EXCENTO';
SET	Cue_PagIntGra				:= 	'PAGO INVERSION. INTERES GRAVADO';
SET	Cue_PagIntAntiExe			:= 	'VENCIMIENTO ANTICIPADO INVERSION. INTERES EXCENTO';
SET	Cue_PagIntAntiGra			:= 	'VENCIMIENTO ANTICIPADO INVERSION. INTERES GRAVADO';
SET	Cue_RetInver	 			:= 	'RETENCION ISR INVERSION';
SET	TipoBenefInver				:=	'I';
SET	Inactivo					:=	'I';
SET	AltaEncPolizaSi				:=	'S';
SET	Act_LiberarInver			:= 	4;


SET	Par_NumErr			:= Entero_Cero;
SET	Par_ErrMen			:= Cadena_Vacia;
SET	Var_MontoOriginal	:= Entero_Cero;
SET	Var_InteresOriginal := Entero_Cero;
SET	VarProcesoCancel 	:= 'CLIENTESCANCELCTAPRO';
SET	Huella_SI				:="S";
SET ValorUMA			:= 'ValorUMABase';
	 -- MANEJO DE EXCEPCIONES ----------------------------------------------------------------------------------------------------
	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET	Par_NumErr = 999;
            SET	Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
			concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-INVERSIONVAL');
		END;
			SELECT	CuentaAhoID,	 Monto,		Estatus,			FechaInicio,			EstatusImpresion,
		ClienteID,		MonedaID,	InteresRetener, SaldoProvision,		InteresGenerado
		INTO
			Var_Cuenta,		Var_Monto,	Var_Estatus,	 Var_InverFecIni,	 Var_EstatusImp,
			Var_Cliente,	 Var_Moneda, Var_IntRetener, Var_SalProvision,	Var_InteresGen
		FROM INVERSIONES
		WHERE InversionID = Par_InversionID;

			IF(Par_TipoAlta = Var_Autoriza)THEN
			IF EXISTS (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID AND EsMenorEdad = MenorEdad) THEN
						SET	Par_NumErr		:= 021;
						SET	Par_ErrMen		:= 'El Cliente es Menor de Edad.';
						SET	Var_Control 	:= 'clienteID';
						SET	Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
						SET	Par_NumErr		:= 020;
						SET	Par_ErrMen		:= 'El Numero de Cliente se Encuentra Vacio.';
						SET	Var_Control 	:= 'clienteID';
						SET	Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;
			SELECT Estatus INTO Var_Estatus
				FROM CLIENTES
					WHERE ClienteID=Par_ClienteID;

			IF(Var_Estatus = Inactivo) THEN
						SET	Par_NumErr		:= 001;
						SET	Par_ErrMen		:= 'El Cliente se Encuentra Inactivo.';
						SET	Var_Control 	:= 'clienteID';
						SET	Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CuentaAhoID, Entero_Cero)) = Entero_Cero THEN
						SET	Par_NumErr		:= 001;
						SET	Par_ErrMen		:= 'El Numero Cuenta esta Vacio.';
						SET	Var_Control 	:= 'clienteID';
						SET	Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;


			-- Consulta a la cuenta de ahorro del cliente
			CALL SALDOSAHORROCON(Var_CueClienteID, Var_Cue_Saldo, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);

			IF(IFNULL(Var_CueEstatus, Cadena_Vacia)) != StaAlta THEN
						SET Par_NumErr		:= 002;
						SET Par_ErrMen		:= 'La Cuenta no Existe o no Esta Activa.';
						SET Var_Control 	:= 'cuentaAhoID';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_CueClienteID, Entero_Cero)) != Par_ClienteID THEN
						SET Par_NumErr		:= 003;
						SET Par_ErrMen		:= 'La Cuenta no pertenece al Cliente.';
						SET Var_Control 	:= 'clienteID';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_CueMoneda, Entero_Cero)) != Par_MonedaID THEN
						SET Par_NumErr		:= 004;
						SET Par_ErrMen		:= 'La Moneda no corresponde con la Cuenta.';
						SET Var_Control 	:= 'monto';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			IF(Par_TipoAlta = Alta_Inversion) THEN
				IF(IFNULL(Var_Cue_Saldo, Entero_Cero)) < Par_Monto THEN
						SET Par_NumErr		:= 005;
						SET Par_ErrMen		:= 'Saldo Insuficiente en la Cuenta del Cliente.';
						SET Var_Control 	:= 'monto';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
				END IF;
			END IF;


			SELECT 	MonedaId INTO Var_MonTipoInv
				FROM	CATINVERSION
				WHERE	TipoInversionID	 = Par_TipoInversionID;

			IF(IFNULL( Var_MonTipoInv, Entero_Cero)) = Entero_Cero THEN
						SET Par_NumErr		:= 006;
						SET Par_ErrMen		:= 'El Tipo de Inversion no Existe.';
						SET Var_Control 	:= 'tipoInversionID';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			IF(Var_MonTipoInv != Var_CueMoneda) THEN
						SET Par_NumErr		:= 007;
						SET Par_ErrMen		:= 'La Moneda de la Inversion no Corresponde con la Cuenta.';
						SET Var_Control 	:= 'tipoInversionID';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;


			IF(IFNULL( Par_FechaInicio, Fecha_Vacia)) = Fecha_Vacia THEN
						SET Par_NumErr		:= 008;
						SET Par_ErrMen		:= 'La Fecha de inicio esta vacia.';
						SET Var_Control 	:= 'fechaVencimiento';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			IF(IFNULL( Par_FechaVencimiento, Fecha_Vacia)) = Fecha_Vacia THEN
						SET Par_NumErr		:= 009;
						SET Par_ErrMen		:= 'La Fecha de Vencimiento esta Vacio.';
						SET Var_Control 	:= 'fechaVencimiento';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			SET Par_Plazo	= DATEDIFF(Par_FechaVencimiento, Par_FechaInicio);

			IF(IFNULL(Par_Plazo, Entero_Cero)) <= Entero_Cero THEN
						SET Par_NumErr		:= 010;
						SET Par_ErrMen		:= 'Plazo en Dias Incorrecto.';
						SET Var_Control 	:= 'plazo';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Monto , Decimal_Cero)) = Decimal_Cero THEN
						SET Par_NumErr		:= 011;
						SET Par_ErrMen		:= 'El Monto de Inversion esta Vacio.';
						SET Var_Control 	:= 'monto';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			SELECT FuncionHuella,ReqHuellaProductos INTO Var_FuncionHuella,Var_ReqHuellaProductos FROM PARAMETROSSIS;
			IF (Var_FuncionHuella = Huella_SI AND Var_ReqHuellaProductos=Huella_SI) THEN
				IF NOT EXISTS(SELECT * FROM HUELLADIGITAL Hue WHERE Hue.TipoPersona="C" AND Hue.PersonaID=Par_ClienteID) THEN
						SET Par_NumErr		:= 012;
						SET Par_ErrMen		:= 'El Cliente no tiene Huella Registrada.';
						SET Var_Control 	:= 'clienteID';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
				END IF;
			END IF;



			/* Se consulta para saber si el cliente paga o no ISR
				y se obtiene el valor de TasaISR*/
			SELECT 	Suc.TasaISR, 	PagaISR,	TipoPersona
			 INTO 	Var_TasaISR, 	Var_PagaISR,	Var_TipoPersona
				FROM	CLIENTES Cli,
						SUCURSALES Suc
				WHERE 	Cli.ClienteID = Par_ClienteID
				AND 	Suc.SucursalID = Cli.SucursalOrigen;

			IF(IFNULL( Var_PagaISR, Cadena_Vacia)) = Cadena_Vacia THEN
						SET Par_NumErr		:= 013;
						SET Par_ErrMen		:= 'Error al Consultar si el Cliente Paga ISR.';
						SET Var_Control 	:= 'clienteID';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			SELECT 	DiasInversion, 		MonedaBaseID,	FechaSistema, SalMinDF
			 INTO 	Var_DiasInversion, 	Var_MonedaBase,	Var_FechaSis, Var_SalMinDF
				FROM PARAMETROSSIS;

			SET Var_DiasInversion	:= IFNULL(Var_DiasInversion , Entero_Cero);
			SET Var_SalMinDF 		:= IFNULL(Var_SalMinDF , Decimal_Cero);
			SET Var_TasaISR 		:= IFNULL(Var_TasaISR , Decimal_Cero);
			SET Par_Tasa 			:= ROUND(FUNCIONTASA(Par_TipoInversionID, Par_Plazo , Par_Monto),4);

			IF(Par_Tasa<Entero_Cero) THEN
				SET Par_Tasa	:= Entero_Cero;
			END IF;

			IF(IFNULL(Par_Tasa , Decimal_Cero)) = Decimal_Cero THEN
						SET Par_NumErr		:= 014;
						SET Par_ErrMen		:= 'No existe una Tasa para el Plazo y Monto.';
						SET Var_Control 	:= 'tasaNeta';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;


		SELECT ValorParametro
			INTO Var_ValorUMA
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;



			SET Par_TasaNeta := ROUND(Par_Tasa - Par_TasaISR, 4);

			SET Par_InteresGenerado := ROUND((Par_Monto * Par_Plazo * Par_Tasa) / (Factor_Porcen * Var_DiasInversion), 2);

			SET Var_SalMinAn := Var_SalMinDF * 5 * Var_ValorUMA; /* Salario minimo General Anualizado*/

			/* SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
				* entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
				* si no es CERO */

			/* Si el cliente paga ISR entonces se calcula el interes a Retener , sino su valor sera cero*/
			/* Cuando sea persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exencion alguna. */
			IF (Var_PagaISR = SI_PagaISR) THEN
				IF( Par_Monto > Var_SalMinAn OR Var_TipoPersona = 'M')THEN
					IF(Var_TipoPersona = 'M')THEN
						SET Par_InteresRetener = ROUND((Par_Monto * Par_Plazo * Par_TasaISR) / (Factor_Porcen * Var_DiasInversion), 2);
					ELSE
						SET Par_InteresRetener = ROUND(((Par_Monto-Var_SalMinAn) * Par_Plazo * Par_TasaISR) / (Factor_Porcen * Var_DiasInversion), 2);
					END IF;
				ELSE
					SET Par_InteresRetener = Decimal_Cero;
				END IF;
			ELSE
				SET Par_InteresRetener = Decimal_Cero;
			END IF;

			SET Par_InteresRecibir = ROUND(Par_InteresGenerado - Par_InteresRetener, 2);

			IF(IFNULL( Par_InteresGenerado, Decimal_Cero)) = Decimal_Cero THEN
						SET Par_NumErr		:= 015;
						SET Par_ErrMen		:= 'El Interes Generado esta Vacio.';
						SET Var_Control 	:= 'interesGenerado';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_InteresRecibir ,Decimal_Cero)) = Decimal_Cero THEN
						SET Par_NumErr		:= 016;
						SET Par_ErrMen		:= 'El Interes a Recibir esta Vacio.';
						SET Var_Control 	:= 'interesRecibir';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;


			IF(IFNULL( Par_Usuario , Entero_Cero)) = Entero_Cero THEN
						SET Par_NumErr		:= 017;
						SET Par_ErrMen		:= 'El Usuario no esta logeado.';
						SET Var_Control 	:= 'inversionID';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;

			IF(Var_FechaSis != Par_FechaInicio AND Par_TipoAlta!=Var_VencimientoAnticipado)THEN
						SET Par_NumErr		:= 018;
						SET Par_ErrMen		:= 'La Fecha de Inicio es Incorrecta.';
						SET Var_Control 	:= 'inversionID';
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
			END IF;
				CALL DETESCALAINTPLDPRO (
							Par_InversionID,	Entero_Cero,		NombreProceso,	Entero_Cero,	SalidaNO,		Par_NumErr,
							Par_ErrMen,			Par_EmpresaID,	Par_Usuario,	Par_FechaActual,	Par_DireccionIP,
							Par_ProgramaID,		Par_Sucursal,		Par_NumeroTransaccion);
			IF(Par_NumErr!=Entero_Cero AND Par_NumErr != 502) THEN
					LEAVE ManejoErrores;
			ELSE
				SET Par_NumErr := 0;
			END IF;

			END IF;
		# FINALIZAN VALIDACIONES PARA ALTA DE INVERSIONES
		IF(Par_TipoAlta = Var_CancelaInversion )THEN
		IF (Var_Estatus != Estatus_Vigente AND Var_Estatus != Estatus_Alta) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= CONCAT('La Inversion no puede ser Cancelada (Revisar Estatus)');
			SET Var_Control	:= 'inversionID';
			LEAVE ManejoErrores;
		END IF;

		IF (DATEDIFF(Var_FechaSucursal,Var_InverFecIni)) != 0 THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= CONCAT('La Inversion no es del Dia de Hoy');
			SET Var_Control	:= 'inversionID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL( Par_Usuario, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= CONCAT('El Usuario no esta logeado');
			SET Var_Control	:= 'inversionID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_InverEnGar	:= (SELECT COUNT(InversionID)
								FROM CREDITOINVGAR
								WHERE InversionID = Par_InversionID);
		SET Var_InverEnGar	:= IFNULL(Var_InverEnGar, Entero_Cero);

		IF(Var_InverEnGar >Entero_Cero)THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= CONCAT('No se puede Cancelar la Inversion porque esta Comprometida con un Credito que No esta Liquidado.');
			SET Var_Control	:= 'inversionID';
			LEAVE ManejoErrores;
		END IF;
			SET Par_NumErr := 0;
	END IF;

		-- ALTA REINVERSION.
		IF(Par_TipoAlta = Alta_ReInversion)THEN

			SELECT 	Estatus, 			FechaVencimiento, 		Monto, 				InteresGenerado,
					InteresRecibir, 	InteresRetener,			SaldoProvision
					INTO
					VarStatusInversion,	VarFechaVencimiento,	Var_MontoOriginal,	Var_InteresGenerado,
					Var_InteresRecibir,	Var_InteresRetener, 	Var_Provision
				FROM INVERSIONES
				WHERE InversionID = Par_ReinversionId;

			IF(IFNULL(VarStatusInversion, Cadena_Vacia)) = Cadena_Vacia THEN
					 SET Par_NumErr		:= 014;
							SET Par_ErrMen		:= 'La Inversion a Renovar no Existe.';
							SET Var_Control 	:= 'inversionID';
							SET Var_Consecutivo := '0';
					LEAVE ManejoErrores;
			END IF;

			IF(VarStatusInversion != StaInvVigente )THEN
					SET Par_NumErr		:= 014;
							SET Par_ErrMen		:= 'La Inversion a Renovar no esta Vigente.';
							SET Var_Control 	:= 'inversionID';
							SET Var_Consecutivo := '0';
					LEAVE ManejoErrores;

			END IF;

			SET Var_InteresRecibir = IFNULL(Var_InteresRecibir, Entero_Cero);
			SET Var_InteresGenerado = IFNULL(Var_InteresGenerado, Entero_Cero);
			SET Var_InteresRetener = IFNULL(Var_InteresRetener, Entero_Cero);
			SET Var_Cue_Saldo = IFNULL(Var_Cue_Saldo, Entero_Cero);
			SET Var_Provision = IFNULL(Var_Provision, Entero_Cero);


			SET	Var_TotDispon = Var_Cue_Saldo + Var_MontoOriginal + Var_InteresGenerado - Var_InteresRetener;
			SET Var_TotDispon = ROUND(Var_TotDispon, 2);

			IF(Var_TotDispon< Par_Monto) THEN
					 SET Par_NumErr		:= 019;
							SET Par_ErrMen		:= 'Saldo Insuficiente en la Cuenta del Cliente.';
							SET Var_Control 	:= 'monto';
							SET Var_Consecutivo := '0';
					LEAVE ManejoErrores;
			END IF;
		END IF;


		IF(Par_TipoAlta = Var_Vencim_Anticipada)THEN
			IF (Var_Estatus != Estatus_Vigente) THEN
				SET Par_NumErr	:= 3;
				SET Par_ErrMen	:= CONCAT('La Inversion no puede ser Cancelada (Revisar Estatus)');
				SET varControl	:= 'inversionID';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ProgramaID != VarProcesoCancel)THEN
				IF(IFNULL( Par_Usuario, Entero_Cero)) = Entero_Cero THEN
					SET Par_NumErr	:= 3;
					SET Par_ErrMen	:= CONCAT('El Usuario no esta logeado');
					SET varControl	:= 'inversionID';
					LEAVE ManejoErrores;
				END IF;

				SELECT	UsuarioID , Contrasenia INTO	Var_UsuarioID,Var_Contrasenia
					FROM USUARIOS
					WHERE Clave = Par_UsuarioClave;
				SET Var_Contrasenia	:= IFNULL(Var_Contrasenia, Cadena_Vacia);

				IF(Var_UsuarioID = Par_Usuario)THEN
					SET Par_NumErr	:= 3;
					SET Par_ErrMen	:= CONCAT('El usuario que realiza la Transaccion no puede ser el mismo que	Autoriza.');
					SET varControl	:= 'inversionID';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_ContraseniaAut != Var_Contrasenia)THEN
					SET	 Par_NumErr := 5;
					SET	Par_ErrMen := 'Contrasena o Usuario Incorrecto.';
					SET varControl	:= 'inversionID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

		END IF;
		IF(Par_TipoAlta = Var_CancelaReinversion)THEN

			SET Var_InverEnGar	:= (SELECT COUNT(InversionID)
									FROM CREDITOINVGAR
									WHERE InversionID = Par_InversionID);
			SET Var_InverEnGar	:= IFNULL(Var_InverEnGar, Entero_Cero);

			IF(Var_InverEnGar >Entero_Cero)THEN
				SET Par_NumErr	:= 4;
                SET	Par_ErrMen	:= CONCAT('No se puede Reinvertir la Inversion porque esta Comprometida con un Credito que No esta Liquidado.');
				SET Var_Control	:= 'inversionID';
				LEAVE ManejoErrores;
			END IF;
				SET Par_NumErr := 0;
		END IF;



	END ManejoErrores;
	-- FIN MANEJO DE EXCEPCIONES ----------------------------------------------------------------------------------------------------
	 IF(Par_Salida =Salida_SI) THEN
	SELECT	CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	 END IF;


END TerminaStore$$
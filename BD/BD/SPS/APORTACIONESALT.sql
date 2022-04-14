
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONESALT`;

DELIMITER $$
CREATE PROCEDURE `APORTACIONESALT`(
# ==============================================================
# ------------ SP PARA REGISTRAR LOS APORTACIONES---------------
# ==============================================================
	Par_TipoAportacionID		INT(11), 				-- ID del Tipo de Aportación
	Par_CuentaAhoID				BIGINT(12),				-- ID de la cuenta de ahorro
	Par_ClienteID				INT(11),				-- ID del Cliente
	Par_FechaInicio				DATE,					-- Fecha de Alta de la Aportación
	Par_FechaVencimiento		DATE,					-- Fecha de Vencimiento de la Aportación

	Par_Monto					DECIMAL(18,2),			-- Monto de la Aportación
	Par_Plazo					INT(11),				-- Plazo en dias de la Aportación
	Par_TasaFija				DECIMAL(12,4),			-- Tasa Fija de la Aportación
	Par_TasaISR					DECIMAL(12,4),			-- Tasa ISR
	Par_TasaNeta				DECIMAL(12,4),			-- Tasa Neta

	Par_InteresGenerado			DECIMAL(18,2),			-- Interes Generado
	Par_InteresRecibir			DECIMAL(18,2),			-- Interes a Recibir
	Par_InteresRetener			DECIMAL(18,2),			-- Interes a Retener
	Par_SaldoProvision			DECIMAL(18,2),			-- Saldo provisional
	Par_ValorGat				DECIMAL(18,2),			-- Valor del Gat

	Par_ValorGatReal			DECIMAL(18,2),			-- Valor REAL del Gat
	Par_MonedaID				INT(11),				-- ID del tipo de Moneda
	Par_FechaVenAnt				DATE,					-- Fecha de Vencimiento Anticipado
	Par_TipoPagoInt				CHAR(1),				-- Tipo de Pago de Interes
	Par_DiasPeriodo				INT(11),				-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo

	Par_PagoIntCal				CHAR(2),				-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
	Par_CalculoInteres			INT(11),				-- Calculo de Interes
	Par_TasaBaseID				INT(11),				-- Tasa Base
	Par_SobreTasa				DECIMAL(12,4),			-- Sobre Tasa
	Par_PisoTasa				DECIMAL(12,4),			-- Piso Tasa

	Par_TechoTasa				DECIMAL(12,4),			-- Techo Tasa
	Par_ProductoSAFI			INT(11),				-- Total de Productos SAFI
	Par_Reinversion				CHAR(1),				-- Indica si el ap se reinvierte
	Par_Reinvertir				CHAR(3),				-- Indica si se reinvierte solo capital o capital mas intereses
	Par_TipoAlta				INT(11),				-- Indica que se da de alta un ap

	Par_CajaRetiro				INT(11),				-- La caja en la que se realizo el retiro
	Par_PlazoOriginal			INT(11),				-- Indica el plazo completo del ap
    Par_DiasPago				INT(11),				-- Indica el dia de pago de la aportacion
    Par_PagoIntCapitaliza		CHAR(1),				-- Capitaliza interes, S:Si, N:No, I:Indistinto
    Par_OpcionAportacion		VARCHAR(50),			-- Opcion de la aportacion

    Par_CantRenovacion			DECIMAL(14,2),			-- Cantidad de la renovacion de la aportacion
    Par_InvRenovar				INT(11),				-- Inv. renovar aportacion
    Par_Notas					VARCHAR(500),			-- Notas de la aportacion
    Par_AperturaAport			CHAR(2),				-- Apertura de aportacion. FA: Fecha Actual / FP: Fecha Posterior
	INOUT Par_AportacionID 		INT(11),				-- Parametro que indica el numero de ap
	Par_Salida 					CHAR(1), 				-- Salida en Pantalla

	INOUT Par_NumErr 			INT(11),				-- Parametro de numero de error
	INOUT Par_ErrMen 			VARCHAR(400),			-- Parametro de mensaje de error
	Par_EmpresaID				INT(11),				-- Parametro de Auditoria
	Aud_Usuario					INT(11),				-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,				-- Parametro de Auditoria

	Aud_DireccionIP				VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal				INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes*
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;				-- Constante Fecha Vacia
	DECLARE	Entero_Cero				INT(11);			-- Constante Entero Cero
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Constante DECIMAL Cero
	DECLARE Factor_Porcen			DECIMAL(16,2);		-- Factor de Porcentaje
	DECLARE StaAlta					CHAR(1);			-- Si esta con estatus alta
	DECLARE Inactivo				CHAR(1);			-- Estatus Inactivo
	DECLARE Con_TasaFija			CHAR(1);			-- Tasa Fija
	DECLARE TasaVariable			CHAR(1);			-- Tasa variable
	DECLARE Tipo_PersonaCliente 	CHAR(1);			-- Tipo persona cliente
	DECLARE Var_Si					CHAR(1);			-- VALOR S
	DECLARE Var_No					CHAR(1);			-- VALOR N
	DECLARE	PagoIntPeriodo			CHAR(1);			-- Indica pago de interes por periodo
	DECLARE PagoIntMes				CHAR(1);			-- Indica pago de interes al fin de mes
	DECLARE ValorUMA				VARCHAR(15);
	DECLARE Per_Moral				CHAR(1);			-- Persona Moral
	DECLARE Per_Fisica				CHAR(1);			-- Persona Física
    DECLARE Per_Emp					CHAR(1);			-- Persona Física con Actividad Empresarial
    DECLARE Cons_PagoProg			CHAR(1);
    DECLARE Cons_CapInte			CHAR(1);
    DECLARE Cons_AperFP				CHAR(2);			-- Apertura de aportacion en fecha posterior 'FP'
	DECLARE Cons_No					CHAR(1);			-- Constante Si
    DECLARE	Cons_Si					CHAR(1);			-- Constante No
	DECLARE	TipoReg_Aport			INT(11);

	-- Declaracion de Variables
	DECLARE Var_Estatus				CHAR(1);			-- Estatus de la Cliente
	DECLARE Var_CueClienteID		BIGINT(12);			-- Cliente
	DECLARE Var_Cue_Saldo			DECIMAL(12,2);		-- Saldo de la cuenta
	DECLARE Var_CueMoneda			INT(11);			-- Tipo de Moneda de Cuenta
	DECLARE Var_CueEstatus			CHAR(1);			-- Estatus de la cuenta de ahorro
	DECLARE Var_FuncionHuella		CHAR(1);			-- Funcion Huella
	DECLARE Var_ReqHuellaProductos	CHAR(1);			-- Requiere Huella de Producto
	DECLARE Var_TasaISR				DECIMAL(18, 2);		-- Tasa ISR
	DECLARE Var_PagaISR				CHAR(1);			-- Si paga ISR
	DECLARE Var_DiasInversion		DECIMAL(12,4);		-- Variable que almacena los dias de Inversion
	DECLARE Var_MonedaBase			INT(11);			-- Variable que almacena el tipo de moneda
	DECLARE Var_FechaSis			DATE;				-- Variable que almacena la Fecha del sistema
	DECLARE Var_TasaFV				CHAR(1);			-- variable de Tasa Fija o Variable
	DECLARE Var_SalMinDF			DECIMAL(16,2);		-- Salario minimo segun el df
	DECLARE Var_SalMinAn			DECIMAL(16,2);		-- Salario minimo anualizado segun el df
	DECLARE Var_AportacionID		INT(11);			-- Consecutivo del Numero de Registro de la Tabla APORTACIONES
	DECLARE Var_MinApertura			DECIMAL(14,2);		-- Monto minimo de apertura
	DECLARE VarPerfilAports			INT(11);
	DECLARE VarValTasasAports		INT(11);
	DECLARE Var_Control				VARCHAR(50);
	DECLARE Var_DiaInhabil			CHAR(2);			-- Almacena el Dia Inhabil
	DECLARE Var_FechaSistema		DATE;				-- Almacena la Fecha del Sistema
	DECLARE Var_FecSal				DATE;				-- Almacena la Fecha de Salida
	DECLARE Var_EsHabil				CHAR(1);			-- Almacena si el dia es habil o no
	DECLARE VarDiaSabDom			CHAR(2);
	DECLARE VarFechaPago			DATE;
	DECLARE Var_MenorEdad			CHAR(1);			-- Almacena si el cliente es menor de edad
	DECLARE Alta_Aport				INT(11);
	DECLARE Var_ValorUMA			DECIMAL(12,4);
	DECLARE Var_TipoPersona			CHAR(1);
    DECLARE Var_TasaBruta			DECIMAL(12,4);		-- Tasa original de la aportacion
    DECLARE Var_Calific				CHAR(1);			-- Calificacion del cliente
	DECLARE Var_MontoGlobal			DECIMAL(18,2);		-- MONTO GLOBAL DEL CLIENTE Y SU GRUPO.
	DECLARE Var_TasaMontoGlobal		CHAR(1);			-- INDICA SI CALCULA LA TASA POR EL MONTO GLOBAL.
	DECLARE Var_IncluyeGpoFam		CHAR(1);			-- INDICA SI INCLUYE A SU GRUPO FAM EN EL MONTO.
    DECLARE Var_EspTasa				CHAR(1);			-- Guarda si la aportacion especifica tasa o no
    DECLARE Var_RFCOficial			CHAR(13);			-- RFC de la Persona
    DECLARE Cons_Vencimi			CHAR(1);			-- Tipo pago interes al vencimiento
	DECLARE Var_DetecNoDeseada	    CHAR(1);			-- Valida si el proceso de Persona No deseadas se encuentra activado

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';				-- Constante Cadena Vacia
	SET	Fecha_Vacia					:= '1900-01-01';	-- Constante Fecha Vacia
	SET	Entero_Cero					:= 0;				-- Constante Entero Cero
	SET	Decimal_Cero				:= 0.0;				-- Constante DECIMAL Cero
	SET Factor_Porcen				:= 100.00;			-- Constante Cien
	SET StaAlta						:= 'A';				-- Estatus Alta
	SET Inactivo					:= 'I';				-- Constante Inactivo
	SET Con_TasaFija				:= 'F';				-- Constante Tasa Fija
	SET TasaVariable				:= 'V';				-- Constante Tasa Variable
	SET Tipo_PersonaCliente			:= 'C';				-- Tipo persona cliente
	SET Var_Si						:= 'S';				-- Salida Si
	SET Var_No						:= 'N';				-- Salida No
	SET Var_AportacionID					:= 0;				-- AportacionID
	SET VarPerfilAports				:= 3;				-- Num Validacion
	SET VarValTasasAports			:= 5;				-- Num Validacion
	SET	Alta_Aport					:= 1;
	SET Aud_FechaActual				:= NOW();			-- Fecha Actual
	SET VarDiaSabDom				:= 'SD'; 			-- Dia sabado y domingo
	SET PagoIntPeriodo				:= 'P';
	SET PagoIntMes					:= 'F';
	SET ValorUMA					:='ValorUMABase';
	SET Per_Moral					:= 'M';
    SET Per_Fisica					:= 'F';
	SET Per_Emp						:= 'A';
    SET Cons_PagoProg		:= 'E';						-- Constante Forma de pago interes Programado
    SET Cons_CapInte		:= 'I';						-- Capitaliza interes: Indistinto
    SET Cons_Vencimi			:= 'V';					-- Tipo de pago interes al vencimiento
    SET Cons_AperFP			:= 'FP';					-- Apertura de aportacion en fecha posterior
	SET Cons_No						:= 'N';
    SET Cons_Si						:= 'S';
	SET	TipoReg_Aport				:= 01;				-- Tipo de Registro Alta de aportaciones.

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr :=	999;
				SET Par_ErrMen :=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-APORTACIONESALT');
			END;

		SET Par_ProductoSAFI := IFNULL(Par_ProductoSAFI, Entero_Cero);

		SELECT
			TasaFV,		MinimoApertura,		DiaInhabil,		TasaMontoGlobal,	IncluyeGpoFam
		INTO
			Var_TasaFV,	Var_MinApertura,	Var_DiaInhabil,	Var_TasaMontoGlobal,Var_IncluyeGpoFam
			FROM 	TIPOSAPORTACIONES
			WHERE	TipoAportacionID	= Par_TipoAportacionID;


		SELECT 	FechaSistema,		FuncionHuella,		ReqHuellaProductos,		DiasInversion,		MonedaBaseID,
				FechaSistema, 		SalMinDF
		INTO 	Var_FechaSistema,	Var_FuncionHuella,	Var_ReqHuellaProductos,	Var_DiasInversion,	Var_MonedaBase,
				Var_FechaSis,		Var_SalMinDF
			FROM PARAMETROSSIS;

		SELECT ValorParametro
			INTO Var_ValorUMA
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;


		IF(Var_DiaInhabil = VarDiaSabDom)THEN
			CALL DIASFESTIVOSABDOMCAL(
				Var_FechaSistema,	Entero_Cero, 		Var_FecSal, 		Var_EsHabil,		Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion	);

			IF(Var_EsHabil = Var_No)THEN
				SET Par_NumErr	:=	1;
				SET Par_ErrMen	:=	CONCAT('El Tipo de Aportacion ', Par_TipoAportacionID,' Tiene Parametrizado Dia Inhabil: Sabado y Domingo ',
											'por tal Motivo No se Puede Registrar la Aportacion.');
				SET Var_Control	:=	'tipoAportacionID';
			END IF;
		END IF;

		CALL SALDOSAHORROCON(Var_CueClienteID, Var_Cue_Saldo, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);

		SELECT 	Suc.TasaISR, 	Cli.PagaISR, 	Cli.EsMenorEdad,	Cli.Estatus,	Cli.TipoPersona
		INTO 	Var_TasaISR, 	Var_PagaISR, 	Var_MenorEdad,		Var_Estatus,	Var_TipoPersona
			FROM	CLIENTES Cli,
					SUCURSALES Suc
			WHERE 	Cli.ClienteID 	= Par_ClienteID
			AND		Suc.SucursalID 	= Cli.SucursalOrigen;

		SET Var_DiasInversion	:= IFNULL(Var_DiasInversion , Entero_Cero);
		SET Var_SalMinDF 		:= IFNULL(Var_SalMinDF , Decimal_Cero);
		SET Var_TasaISR 		:= IFNULL(Var_TasaISR , Decimal_Cero);
		SET Par_TipoPagoInt 	:= IFNULL(Par_TipoPagoInt,Cadena_Vacia);
		SET Par_DiasPeriodo		:= IFNULL(Par_DiasPeriodo,Entero_Cero);
		SET	Par_PagoIntCal		:= IFNULL(Par_PagoIntCal,Cadena_Vacia);
		SET	Var_TasaMontoGlobal	:= IFNULL(Var_TasaMontoGlobal,Cadena_Vacia);
		SET	Var_IncluyeGpoFam	:= IFNULL(Var_IncluyeGpoFam,Cadena_Vacia);

		IF(IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:=	2;
			SET Par_ErrMen	:=	'El Numero de safilocale.cliente se Encuentra Vacio.';
			SET Var_Control	:=	'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_Estatus = Inactivo) THEN
			SET Par_NumErr	:=	3;
			SET Par_ErrMen	:=	'El safilocale.cliente se Encuentra Inactivo.';
			SET Var_Control	:=	'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_CuentaAhoID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:=	4;
			SET Par_ErrMen	:=	'El Numero Cuenta esta Vacio.';
			SET Var_Control	:=	'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_CueEstatus,Cadena_Vacia) != StaAlta ) THEN
			SET Par_NumErr	:=	5;
			SET Par_ErrMen	:=	'La Cuenta no Existe o no esta Activa.';
			SET Var_Control	:=	'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CueClienteID,Entero_Cero) != Par_ClienteID) THEN
			SET Par_NumErr	:=	6;
			SET Par_ErrMen	:=	'La Cuenta no pertenece al safilocale.cliente .';
			SET Var_Control	:=	'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_CueMoneda,Entero_Cero) != Par_MonedaID) THEN
			SET Par_NumErr	:=	7;
			SET Par_ErrMen	:=	'La Moneda no corresponde con la Cuenta.';
			SET Var_Control	:=	'monto';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_Cue_Saldo,Entero_Cero) < Par_Monto AND Par_AperturaAport <> Cons_AperFP) THEN
			SET Par_NumErr	:=	8;
			SET Par_ErrMen	:=	'Saldo Insuficiente en la Cuenta del safilocale.cliente .';
			SET Var_Control	:=	'monto';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaInicio,Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr	:=	9;
			SET Par_ErrMen	:=	'La Fecha de Inicio esta Vacia.';
			SET Var_Control	:=	'fechaInicio';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaVencimiento,Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr	:=	10;
			SET Par_ErrMen	:=	'La Fecha de Vencimiento esta Vacia.';
			SET Var_Control	:=	'fechaVencimiento';
			LEAVE ManejoErrores;
		END IF;


		IF (DATEDIFF(Par_FechaVencimiento,Par_FechaInicio) <= Entero_Cero) THEN
			SET Par_NumErr	:=	11;
			SET Par_ErrMen	:=	'Plazo de Dias Incorrecto.';
			SET Var_Control	:=	'plazoOriginal';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_Monto,Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr	:=	12;
			SET Par_ErrMen	:=	'El Monto de la Inversion esta Vacio.';
			SET Var_Control	:=	'monto';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_FuncionHuella = Var_Si AND Var_ReqHuellaProductos = Var_Si) THEN
			IF NOT EXISTS (SELECT *
							FROM HUELLADIGITAL Hue
							WHERE Hue.TipoPersona = Tipo_PersonaCliente AND Hue.PersonaID = Par_ClienteID) THEN
				SET Par_NumErr	:=	13;
				SET Par_ErrMen	:=	'El safilocale.cliente no tiene Huella Registrada.';
				SET Var_Control	:=	'clienteID';
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF (IFNULL(Var_PagaISR,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr	:=	14;
			SET Par_ErrMen	:=	'Error al Consultar si el safilocale.cliente Paga ISR.';
			SET Var_Control	:=	'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_TasaFija,Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr	:=	15;
			SET Par_ErrMen	:=	'La Tasa esta Vacia.';
			SET Var_Control	:=	'tasaNeta';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_FechaSis != Par_FechaInicio AND Par_AperturaAport <> Cons_AperFP) THEN
			SET Par_NumErr	:=	16;
			SET Par_ErrMen	:=	CONCAT('La Fecha de Inicio ', Par_FechaInicio, ' es Incorrecta.');
			SET Var_Control	:=	'fechaInicio';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoPagoInt = Cadena_Vacia) THEN
			SET Par_NumErr	:=	17;
			SET Par_ErrMen	:=	'El Tipo de Pago esta Vacio.';
			SET Var_Control	:=	'tipoPagoInt';
			LEAVE ManejoErrores;
		END IF;

		IF ( IFNULL(Par_Reinversion,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr	:=	18;
			SET Par_ErrMen	:=	'El Tipo de Reinversion esta Vacio.';
			SET Var_Control	:=	'';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_Reinvertir,Cadena_Vacia) = Cadena_Vacia AND IFNULL(Par_Reinversion,Cadena_Vacia) != Var_No) THEN
			SET Par_NumErr	:=	19;
			SET Par_ErrMen	:=	'El Tipo de Reinversion Automatica esta Vacio.';
			SET Var_Control	:=	'';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL( Par_CajaRetiro, Entero_Cero) > Entero_Cero )THEN
			IF NOT EXISTS(
				SELECT SucursalID
					FROM SUCURSALES
						WHERE SucursalID = Par_CajaRetiro) THEN
				SET Par_NumErr	:= 020;
				SET Par_ErrMen	:= 'La Caja de Retiro No Existe.' ;
				SET Var_Control	:= 'cajaRetiro';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPagoInt = PagoIntPeriodo) THEN
			IF(IFNULL(Par_DiasPeriodo,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 023;
				SET Par_ErrMen := 'El Numero de Dias del Periodo Esta Vacio.' ;
				SET Var_Control:= 'diasPeriodo' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF ((Par_TipoPagoInt = PagoIntPeriodo)OR(Par_TipoPagoInt = PagoIntMes)) THEN
			IF(IFNULL(Par_PagoIntCal,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 024;
				SET Par_ErrMen := 'El Tipo de pago de Interes esta Vacio.' ;
				SET Var_Control:= 'pagoIntCal' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPagoInt = Cons_PagoProg) THEN
			IF(IFNULL(Par_DiasPago,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 025;
				SET Par_ErrMen := 'El Numero de Dias de Pago Esta Vacio.' ;
				SET Var_Control:= 'diasPago' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;
        -- INICIO VALIDACIÓN DE PERSONAS NO DESEADAS
        SET Var_DetecNoDeseada := IFNULL((SELECT  PersonNoDeseadas FROM PARAMETROSSIS LIMIT 1),Cons_No);
        IF(Var_DetecNoDeseada = Cons_Si) THEN
         IF(Var_TipoPersona = Per_Moral) THEN
			SELECT 	Cli.RFCpm
			INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
			WHERE 	Cli.ClienteID 	= Par_ClienteID
			AND		Suc.SucursalID 	= Cli.SucursalOrigen;
        END IF;

        IF(Var_TipoPersona = Per_Fisica OR Var_TipoPersona = Per_Emp ) THEN
			SELECT 	Cli.RFC
			INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
			WHERE 	Cli.ClienteID 	= Par_ClienteID
			AND		Suc.SucursalID 	= Cli.SucursalOrigen;
        END IF;

          CALL PLDDETECPERSNODESEADASPRO(
				Entero_Cero,	Var_RFCOficial,	Var_TipoPersona,	Var_No,	Par_NumErr,
                Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,	Aud_FechaActual,
                Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr			:= 050;
				SET Par_ErrMen			:= Par_ErrMen;
				LEAVE ManejoErrores;
			END IF;
		END IF;
		-- FIN VALIDACIÓN DE PERSONAS NO DESEADAS
        SET Par_DiasPago			:=  IFNULL(Par_DiasPago,Entero_Cero);
        SET Par_PagoIntCapitaliza	:=  IFNULL(Par_PagoIntCapitaliza,Var_No);
        IF(Par_TipoPagoInt = Cons_Vencimi)THEN
			SET Par_PagoIntCapitaliza	:= Var_No;
        END IF;

        SET Par_OpcionAportacion	:=  IFNULL(Par_OpcionAportacion,Cadena_Vacia);
        SET Par_CantRenovacion		:=  IFNULL(Par_CantRenovacion,Entero_Cero);
        SET Par_InvRenovar			:=  IFNULL(Par_InvRenovar,Entero_Cero);
        SET Par_Notas				:=  IFNULL(Par_Notas,Cadena_Vacia);

		SET VarFechaPago 	:= Par_FechaVencimiento;

		IF(Par_TipoAlta = Alta_Aport) THEN

			SET Var_MinApertura := IFNULL(Var_MinApertura, Entero_Cero);

			IF (IFNULL(Par_Monto,Decimal_Cero) < Var_MinApertura) THEN
				SET Par_NumErr	:=	22;
				SET Par_ErrMen	:=	CONCAT('El Monto Minimo de Contratacion de una Aportacion es: $', FORMAT(Var_MinApertura, 2));
				SET Var_Control	:=	'monto';
				LEAVE ManejoErrores;
			END IF;

			IF (Var_TasaFV = TasaVariable) THEN
				SET Par_TasaFija	:=	FNTASAAPORTACIONES(Par_CalculoInteres,	Par_TasaBaseID,	Par_SobreTasa,	Par_PisoTasa,	Par_TechoTasa);
			END IF;

			SET Par_TasaNeta		:= ROUND(Par_TasaFija - Par_TasaISR, 4);

			SET Var_SalMinAn := Var_SalMinDF * 5 * Var_ValorUMA;

			IF (IFNULL(Par_InteresGenerado,Decimal_Cero) = Decimal_Cero) THEN
				SET Par_NumErr	:=	20;
				SET Par_ErrMen	:=	'El Interes Generado esta Vacio';
				SET Var_Control	:=	'interesGenerado';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_InteresRecibir,Decimal_Cero) = Decimal_Cero) THEN
				SET Par_NumErr	:=	21;
				SET Par_ErrMen	:=	'El Interes a Recibir esta Vacio';
				SET Var_Control	:=	'interesRecibir';
				LEAVE ManejoErrores;
			END IF;

			CALL VALIDATASASPRODUCTOS (
				Par_ClienteID,		Par_TipoAportacionID,	Par_ProductoSAFI,	Aud_Sucursal,		VarValTasasAports,
				Var_No,				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual, 	Aud_DireccionIP,		Aud_ProgramaID, 	Aud_Sucursal,	    Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				SET Var_Control	:=	'clienteID';
				LEAVE ManejoErrores;
			END IF;



			SET Par_ValorGat	:=	FUNCIONCALCTAGATAPORTACION(Par_FechaVencimiento,Par_FechaInicio,Par_TasaFija);
			SET Par_ValorGatReal:=	FUNCIONCALCGATREAL(Par_ValorGat,(SELECT InflacionProy AS ValorGatHis
																		FROM INFLACIONACTUAL
																		WHERE FechaActualizacion = (SELECT MAX(FechaActualizacion)
																										FROM INFLACIONACTUAL)));
		END IF;

		SET Var_MontoGlobal		:= (FNAPORTMONTOGLOBAL(Par_TipoAportacionID,Par_ClienteID)+Par_Monto);
		SET Var_AportacionID 	:= (SELECT IFNULL(MAX(AportacionID), Entero_Cero) + 1 FROM APORTACIONES);
		SET Par_AportacionID	:=	Var_AportacionID;

		INSERT INTO APORTACIONES(
			AportacionID,			TipoAportacionID,	CuentaAhoID,			ClienteID,				FechaInicio,
			FechaVencimiento,		FechaPago,			Monto,					Plazo,					TasaFija,
			TasaISR,				TasaNeta,			CalculoInteres,			TasaBase,				SobreTasa,
			PisoTasa,				TechoTasa,			InteresGenerado,		InteresRecibir,			InteresRetener,
			SaldoProvision,			ValorGat,			ValorGatReal,			EstatusImpresion,		MonedaID,
			FechaVenAnt,			FechaApertura,		Estatus,				TipoPagoInt,			DiasPeriodo,
			PagoIntCal,				PlazoOriginal,		Reinversion,			Reinvertir,				CajaRetiro,
			MontoGlobal,			TasaMontoGlobal,	IncluyeGpoFam,			DiasPago, 				PagoIntCapitaliza,
			OpcionAport,			CantidadReno,		InvRenovar,				Notas,					AperturaAport,
            EmpresaID,				UsuarioID,			FechaActual,			DireccionIP,			ProgramaID,
            Sucursal,				NumTransaccion)
		VALUES(
			Var_AportacionID,		Par_TipoAportacionID,Par_CuentaAhoID,		Par_ClienteID,			Par_FechaInicio,
			Par_FechaVencimiento,	VarFechaPago,		Par_Monto,				Par_Plazo,				Par_TasaFija,
			Par_TasaISR,			Par_TasaNeta,		Par_CalculoInteres,		Par_TasaBaseID,			Par_SobreTasa,
			Par_PisoTasa,			Par_TechoTasa,		Par_InteresGenerado,	Par_InteresRecibir,	 	Par_InteresRetener,
			Decimal_Cero,			Par_ValorGat,		Par_ValorGatReal,		Var_No,					Par_MonedaID,
			Par_FechaVenAnt,		Fecha_Vacia,		StaAlta,				Par_TipoPagoInt,		Par_DiasPeriodo,
			Par_PagoIntCal,			Par_PlazoOriginal,	Par_Reinversion,		Par_Reinvertir,			Par_CajaRetiro,
			Var_MontoGlobal,		Var_TasaMontoGlobal,Var_IncluyeGpoFam,		Par_DiasPago,			Par_PagoIntCapitaliza,
			Par_OpcionAportacion,	Par_CantRenovacion,	Par_InvRenovar,			Par_Notas,				Par_AperturaAport,
            Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
            Aud_Sucursal,			Aud_NumTransaccion);

        -- Consulta para obtener si la aportacion especifica tasa
        SELECT EspecificaTasa
		INTO Var_EspTasa
		FROM TIPOSAPORTACIONES
		WHERE TipoAportacionID=Par_TipoAportacionID;
        SET Var_EspTasa :=IFNULL(Var_EspTasa,Var_No);

        -- Si la aportacion cambio de tasa manualmente, se hace el insert a la tabla CAMBIOTASAAPORT
		IF (Var_TasaFV = Con_TasaFija AND Var_EspTasa=Var_Si) THEN
			SET Var_Calific 	:= (SELECT CalificaCredito FROM CLIENTES WHERE ClienteID=Par_ClienteID);
			SET Var_TasaBruta	:= ROUND(FUNCIONTASAAPORTACION(Par_TipoAportacionID , Par_PlazoOriginal , Var_MontoGlobal, Var_Calific, Aud_Sucursal),2);
            -- Var_TasaBruta: es el valor de la tasa calculado por SAFI
			-- Par_TasaFija es el valor de la tasa ingresada desde la pantalla Aportaciones
			IF(Var_TasaBruta <> Par_TasaFija)THEN
				CALL CAMBIOTASAAPORTALT(
					Var_AportacionID,	Var_TasaBruta,		Par_TasaFija, 		TipoReg_Aport,		Var_No,
					Par_NumErr,			Par_ErrMen,			Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
			END IF;
		END IF;

		SET Par_NumErr	:= 	0;
		SET Par_ErrMen	:=	CONCAT('Aportacion Agregada Exitosamente: ', CONVERT(Var_AportacionID, CHAR),'.');
		SET Var_Control	:=	'aportacionID';

	END ManejoErrores;

	IF(Par_Salida = Var_Si)THEN
		SELECT 	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Par_AportacionID 	AS consecutivo;
	END IF;

END TerminaStore$$



-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONESMOD`;

DELIMITER $$
CREATE PROCEDURE `APORTACIONESMOD`(
# ==============================================================
# ----------------- SP PARA MODIFICAR LOS APORTACIONES-----------------
# ==============================================================
	Par_AportacionID			INT(11),				-- NÚMERO DE APORTACIÓN.
	Par_TipoAportacionID		INT(11),				-- TIPO DE APORTACIÓN.
	Par_CuentaAhoID				BIGINT(12),				-- NÚM. DE CUENTA.
	Par_ClienteID				INT(11),				-- NÚMERO DE CLIENTE,¿.
	Par_FechaInicio				DATE,					-- FECHA DE INICIO.

	Par_FechaVencimiento		DATE,					-- FECHA DE VENCIMIENTO.
	Par_Monto					DECIMAL(18,2),			-- MONTO DE LA APORTACIÓN.
	Par_Plazo					INT(11),				-- PLAZO ID.
	Par_TasaFija				DECIMAL(12,4),			-- TASA FIJA.
	Par_TasaISR					DECIMAL(12,4),			-- TASA ISR.

	Par_TasaNeta				DECIMAL(12,4),			-- TASA NETA.
	Par_InteresGenerado			DECIMAL(18,2),			-- INTERES GENERADO.
	Par_InteresRecibir			DECIMAL(18,2),			-- INTERES RECIBIR.
	Par_InteresRetener			DECIMAL(18,2),			-- INTERES RETENER.
	Par_SaldoProvision			DECIMAL(18,2),			-- SALDO PROVISION.

	Par_ValorGat				DECIMAL(12,4),			-- VALOR GAT.
	Par_ValorGatReal			DECIMAL(12,4),			-- VALOR GAT REAL.
	Par_MonedaID				INT(11),				-- ID DE LA MONEDA.
	Par_FechaVenAnt				DATE,					-- FECHA DE VENC. ANTICIPADO.
	Par_TipoPagoInt				CHAR(1),				-- TIPO DE PAGO DE INTERÉS.

	Par_DiasPeriodo				INT(11),				-- ESPECIFICA LOS DIAS POR PERIODO CUANDO LA FORMA DE PAGO DE INTERES ES POR PERIODO
	Par_PagoIntCal				CHAR(2),				-- ESPECIFICA EL TIPO DE PAGO DE INTERES D - DEVENGADO, I - IGUALES
	Par_CalculoInteres			INT(1),					-- CALCULO DE INTERES
	Par_TasaBaseID				INT(2),					-- TASA BASE
	Par_SobreTasa				DECIMAL(12,4),			-- SOBRE TASA

	Par_PisoTasa				DECIMAL(12,4),			-- PISO TASA
	Par_TechoTasa				DECIMAL(12,4),			-- TECHO TASA
	Par_ProductoSAFI			INT(11),				-- TOTAL DE PRODUCTOS SAFI
	Par_PlazoOriginal			INT(11),				-- ID DEL PLAZO ORIGINAL.
	Par_Reinversion				CHAR(1),				-- ES REINVERSION.

	Par_Reinvertir				CHAR(3),				-- ¿REINVIERTE?
	Par_CajaRetiro				INT(11),				-- SUCURSAL DONDE SE REALIZARA EL RETIRO DESPUES DEL VENCIMIENTO
    Par_DiasPago				INT(11),				-- Indica el dia de pago de la aportacion
    Par_PagoIntCapitaliza		CHAR(1),				-- Capitaliza interes, S:Si, N:No, I:Indistinto
    Par_OpcionAportacion		VARCHAR(50),			-- Opcion de la aportacion

    Par_CantRenovacion			DECIMAL(14,2),			-- Cantidad de la renovacion de la aportacion
    Par_InvRenovar				INT(11),				-- Inv. renovar aportacion
    Par_Notas					VARCHAR(500),			-- Notas de la aportacion
    Par_AperturaAport			CHAR(2),				-- Apertura de aportacion. FA: Fecha Actual / FP: Fecha Posterior

	Par_Salida 					CHAR(1), 				-- SALIDA EN PANTALLA
	INOUT Par_NumErr 			INT(11),				-- NÚM. DE ERROR.

	INOUT Par_ErrMen 			VARCHAR(400),			-- MENSAJE DE ERROR.

	 /* Parámetros de Auditoría */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),

	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_CueClienteID		BIGINT(12);
	DECLARE Var_Cue_Saldo			DECIMAL(12,2);
	DECLARE Var_CueMoneda			INT(11);
	DECLARE Var_CueEstatus			CHAR(1);
	DECLARE Var_Estatus				CHAR(1);
	DECLARE Var_MonTipoInv			INT(11);
	DECLARE Var_FuncionHuella		CHAR(1);
	DECLARE Var_ReqHuellaProductos	CHAR(1);
	DECLARE Var_TasaISR				DECIMAL(12,4);
	DECLARE Var_PagaISR				CHAR(1);
	DECLARE Var_DiasInversion		DECIMAL(12,4);
	DECLARE Var_MonedaBase			INT(11);
	DECLARE Var_FechaSis			DATE;
	DECLARE Var_TasaFV				CHAR(1);
	DECLARE Var_SalMinDF			DECIMAL(12,2);	-- Salario minimo segun el df
	DECLARE Var_SalMinAn			DECIMAL(12,2);	-- Salario minimo anualizado segun el df
	DECLARE Cal_GATReal				DECIMAL(12,2);
	DECLARE Var_Reinversion			CHAR(1);
	DECLARE Var_ReinvertirAport		CHAR(3);
	DECLARE Var_DiaInhabil			CHAR(2);		-- Almacena el Dia Inhabil
	DECLARE VarDiaGenerado			DATE;
	DECLARE FechaVig				DATE;
	DECLARE VarFechaPago			DATE;
	DECLARE Var_Control				VARCHAR(20);	-- ID del contorl en pantalla
	DECLARE Var_ValorUMA			DECIMAL(12,4);
	DECLARE Var_TipoPersona			CHAR(1);
    DECLARE Var_TasaBruta			DECIMAL(12,4);		-- Tasa original de la aportacion
    DECLARE Var_Calific				CHAR(1);			-- Calificacion del cliente
    DECLARE Var_TasaExistente		DECIMAL(14,2);		-- Tasa existente de la aportacion
	DECLARE Var_MontoGlobal			DECIMAL(18,2);		-- MONTO GLOBAL DEL CLIENTE Y SU GRUPO.
	DECLARE Var_TasaMontoGlobal		CHAR(1);			-- INDICA SI CALCULA LA TASA POR EL MONTO GLOBAL.
	DECLARE Var_IncluyeGpoFam		CHAR(1);			-- INDICA SI INCLUYE A SU GRUPO FAM EN EL MONTO.
    DECLARE Var_EspTasa				CHAR(1);			-- Guarda si la aportacion especifica tasa o no

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Factor_Porcen			DECIMAL(12,2);
	DECLARE Salida_NO				CHAR(1);
	DECLARE Salida_SI				CHAR(1);
	DECLARE StaAlta					CHAR(1);
	DECLARE SI_PagaISR				CHAR(1);
	DECLARE Inactivo				CHAR(1);
	DECLARE MenorEdad				CHAR(1);
	DECLARE Huella_SI				CHAR(1);
	DECLARE Cons_TasaFija			CHAR(1);
	DECLARE TasaVariable			CHAR(1);
	DECLARE Cal_GAT					DECIMAL(12,2);
	DECLARE Var_AportacionID		INT(11);
	DECLARE NumValidacion			INT(1);
	DECLARE Num_Validacion			INT(1);
	DECLARE ConsNo 					CHAR(1);		-- Constante No
	DECLARE Dia_SD					CHAR(2);
	DECLARE Dia_D					CHAR(2);
	DECLARE Var_Consecutivo			VARCHAR(50);	-- Valor consecutivo del control
	DECLARE	PagoIntPeriodo			CHAR(1);		-- Indica pago de interes por periodo
	DECLARE PagoIntMes				CHAR(1);		-- Indica pago de interes al fin de mes
	DECLARE ValorUMA				VARCHAR(15);
	DECLARE Per_Moral				CHAR(1);
    DECLARE Cons_PagoProg			CHAR(1);
    DECLARE Cons_CapInte			CHAR(1);
    DECLARE Cons_SI					CHAR(1);		-- Constante si
    DECLARE Cons_Vencimi			CHAR(1);			-- Tipo pago interes al vencimiento
	DECLARE Cons_AperFP				CHAR(2);			-- Apertura de aportacion en fecha posterior 'FP'
	DECLARE	TipoReg_Aport			INT(11);

	-- Asignacion de constantes
	SET	Cadena_Vacia				:= '';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET	Entero_Cero					:= 0;
	SET	Decimal_Cero				:= 0.0;
	SET Factor_Porcen				:= 100.00;
	SET Salida_NO					:= 'N';
	SET Salida_SI					:= 'S';
	SET StaAlta						:= 'A';
	SET SI_PagaISR					:= 'S';
	SET Inactivo					:= 'I';
	SET MenorEdad					:= 'S';
	SET Huella_SI					:= 'S';
	SET Cons_TasaFija				:= 'F';
	SET TasaVariable				:= 'V';
	SET Cal_GAT						:= 0.00;
	SET Var_AportacionID			:= 0;
	SET NumValidacion				:= 3;
	SET Num_Validacion				:= 5;
	SET ConsNo						:= 'N';
	SET Dia_SD						:= 'SD'; 					-- Dia sabado y domingo
	SET Dia_D						:= 'D';		 					-- Dia domingo
	SET Aud_FechaActual				:= NOW();
	SET Par_ProductoSAFI 			:= IFNULL(Par_ProductoSAFI, Entero_Cero);
	SET Var_Consecutivo				:= Entero_Cero;
	SET PagoIntPeriodo				:= 'P';
	SET PagoIntMes					:= 'F';				-- Constante forma de pago interes fin de mes
	SET ValorUMA					:='ValorUMABase';
	SET Per_Moral					:= 'M';
    SET Cons_PagoProg				:= 'E';					-- Constante Forma de pago interes Programado
    SET Cons_CapInte				:= 'I';					-- Capitaliza interes: Indistinto
    SET Cons_SI						:= 'S';					-- Constante Si
    SET Cons_Vencimi				:= 'V';					-- Tipo de pago interes al vencimiento
	SET Cons_AperFP					:= 'FP';				-- Apertura de aportacion en fecha posterior
	SET	TipoReg_Aport				:= 01;					-- Tipo de Registro Alta de aportaciones.

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-APORTACIONESMOD');
			SET Var_Control:= 'SQLEXCEPTION';
		END;

		IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 20;
			SET Par_ErrMen	:= 'El Numero de safilocale.cliente se Encuentra Vacio.' ;
			SET Var_Control	:= 'clienteID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT 		Estatus,		TipoPersona
			INTO 	Var_Estatus ,	Var_TipoPersona
		FROM CLIENTES
		WHERE ClienteID=Par_ClienteID;

		IF(Var_Estatus = Inactivo) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El safilocale.cliente se Encuentra Inactivo.' ;
			SET Var_Control	:= 'cuentaAhoID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_CuentaAhoID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'El Numero Cuenta esta Vacio.' ;
			SET Var_Control	:= 'cuentaAhoID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		SELECT
			TasaFV,		TasaMontoGlobal,		IncluyeGpoFam
		INTO
			Var_TasaFV,	Var_TasaMontoGlobal,	Var_IncluyeGpoFam
			FROM TIPOSAPORTACIONES
				WHERE	TipoAportacionID	 = Par_TipoAportacionID;


		CALL SALDOSAHORROCON(Var_CueClienteID, Var_Cue_Saldo, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);


		IF(IFNULL(Var_CueEstatus, Cadena_Vacia)) != StaAlta THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'La Cuenta no Existe o no Esta Activa.' ;
			SET Var_Control	:= 'cuentaAhoID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CueClienteID, Entero_Cero)) != Par_ClienteID THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= 'La Cuenta no pertenece al safilocale.cliente .' ;
			SET Var_Control	:= 'clienteID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CueMoneda, Entero_Cero)) != Par_MonedaID THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= 'La Moneda no corresponde con la Cuenta.' ;
			SET Var_Control	:= 'monto';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Var_Cue_Saldo, Entero_Cero)) < Par_Monto AND Par_AperturaAport <> Cons_AperFP THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= 'Saldo Insuficiente en la Cuenta del safilocale.cliente .' ;
			SET Var_Control	:= 'monto';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_MonTipoInv != Par_MonedaID) THEN
			SET Par_NumErr	:= 006;
			SET Par_ErrMen	:= 'La Moneda de la Inversion no Corresponde con la Cuenta.' ;
			SET Var_Control	:= 'tipoInversionID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL( Par_FechaInicio, Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr	:= 008;
			SET Par_ErrMen	:= 'La Fecha de Inicio esta Vacia.' ;
			SET Var_Control	:= 'fechaInicio';
			SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL( Par_FechaVencimiento, Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr	:= 009;
			SET Par_ErrMen	:= 'La Fecha de Vencimiento esta Vacia.' ;
			SET Var_Control	:= 'fechaVencimiento';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Par_Plazo	:= DATEDIFF(Par_FechaVencimiento, Par_FechaInicio);

		IF(IFNULL(Par_Plazo, Entero_Cero)) <= Entero_Cero THEN
			SET Par_NumErr	:= 010;
			SET Par_ErrMen	:= 'Plazo en Dias Incorrecto.' ;
			SET Var_Control	:= 'plazo';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto , Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr	:= 011;
			SET Par_ErrMen	:= 'El Monto de Inversion esta Vacio.' ;
			SET Var_Control	:= 'monto';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT FuncionHuella,ReqHuellaProductos
		INTO Var_FuncionHuella,Var_ReqHuellaProductos
		FROM PARAMETROSSIS;
		IF (Var_FuncionHuella = Huella_SI AND Var_ReqHuellaProductos=Huella_SI) THEN
			IF NOT EXISTS(SELECT * FROM HUELLADIGITAL Hue WHERE Hue.TipoPersona="C" AND Hue.PersonaID=Par_ClienteID) THEN
				SET Par_NumErr	:= 012;
				SET Par_ErrMen	:= 'El safilocale.cliente no tiene Huella Registrada.' ;
				SET Var_Control	:= 'clienteID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		/* Se consulta para saber si el cliente paga o no ISR
		y se obtiene el valor de TasaISR*/
		SELECT 	Suc.TasaISR, 	PagaISR
			INTO 	Var_TasaISR, 	Var_PagaISR
			FROM	CLIENTES Cli,
				SUCURSALES Suc
				WHERE 	Cli.ClienteID = Par_ClienteID
					AND 	Suc.SucursalID = Cli.SucursalOrigen;

		IF(IFNULL( Var_PagaISR, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr	:= 013;
			SET Par_ErrMen	:= 'Error al Consultar si el safilocale.cliente  Paga ISR.' ;
			SET Var_Control	:= 'clienteID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT 	DiasInversion, 		MonedaBaseID,	FechaSistema, SalMinDF
		INTO 	Var_DiasInversion, 	Var_MonedaBase,	Var_FechaSis, Var_SalMinDF
		FROM PARAMETROSSIS;


		SELECT ValorParametro
			INTO Var_ValorUMA
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;


		SET Var_DiasInversion	:= IFNULL(Var_DiasInversion , Entero_Cero);
		SET Var_SalMinDF 		:= IFNULL(Var_SalMinDF , Decimal_Cero);
		SET Var_TasaISR 		:= IFNULL(Var_TasaISR , Decimal_Cero);

		IF(IFNULL(Par_TasaFija , Decimal_Cero)) = Decimal_Cero AND Var_TasaFV=Cons_TasaFija THEN
			SET Par_NumErr	:= 014;
			SET Par_ErrMen	:= 'No existe una Tasa para el Plazo y Monto.' ;
			SET Var_Control	:= 'tasaNeta';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_TasaFV=Cons_TasaFija) THEN
			SET Par_TasaNeta 		:= ROUND(Par_TasaFija - Par_TasaISR, 4);
		END IF;

		SET Var_SalMinAn := Var_SalMinDF * 5 * Var_ValorUMA;

		IF(IFNULL( Par_InteresGenerado, Decimal_Cero)) = Decimal_Cero AND Var_TasaFV=Cons_TasaFija THEN
			SET Par_NumErr	:= 015;
			SET Par_ErrMen	:= 'El Interes Generado esta Vacio.' ;
			SET Var_Control	:= 'interesGenerado';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_InteresRecibir ,Decimal_Cero)) = Decimal_Cero AND Var_TasaFV=Cons_TasaFija THEN
			SET Par_NumErr	:= 016;
			SET Par_ErrMen	:= 'El Interes a Recibir esta Vacio.' ;
			SET Var_Control	:= 'interesRecibir';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_FechaSis != Par_FechaInicio AND Par_AperturaAport <> Cons_AperFP)THEN
			SET Par_NumErr	:= 017;
			SET Par_ErrMen	:= CONCAT ('La Fecha de Inicio ', Par_FechaInicio, ' es incorrecta');
			SET Var_Control	:= 'aportacionID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Par_TipoPagoInt := IFNULL(Par_TipoPagoInt,Cadena_Vacia);

		IF(Par_TipoPagoInt =Cadena_Vacia) THEN
			SET Par_NumErr	:= 018;
			SET Par_ErrMen	:= 'El Tipo de Pago Viene Vacio.' ;
			SET Var_Control	:= 'tipoPagoInt';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Reinversion, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr	:= 022;
			SET Par_ErrMen	:= 'El Tipo de Reinversion esta Vacio.' ;
			SET Var_Control	:= 'tipoPagoInt';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL( Par_CajaRetiro, Entero_Cero) > Entero_Cero )THEN
			IF NOT EXISTS(
				SELECT SucursalID
					FROM SUCURSALES
						WHERE SucursalID = Par_CajaRetiro) THEN
				SET Par_NumErr	:= 23;
				SET Par_ErrMen	:= 'La Caja de Retiro No Existe.' ;
				SET Var_Control	:= 'cajaRetiro';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPagoInt = PagoIntPeriodo) THEN
			IF(IFNULL(Par_DiasPeriodo,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr = 024;
				SET Par_ErrMen = 'El Numero de Dias del Periodo Esta Vacio.' ;
				SET Var_Control= 'diasPeriodo' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF ((Par_TipoPagoInt = PagoIntPeriodo)OR(Par_TipoPagoInt = PagoIntMes)) THEN
			IF(IFNULL(Par_PagoIntCal,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr = 025;
				SET Par_ErrMen = 'El Tipo de pago de Interes esta Vacio.' ;
				SET Var_Control= 'pagoIntCal' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

        IF(Par_TipoPagoInt = Cons_PagoProg) THEN
			IF(IFNULL(Par_DiasPago,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr = 026;
				SET Par_ErrMen = 'El Numero de Dias de Pago Esta Vacio.' ;
				SET Var_Control= 'diasPago' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

        SET Par_DiasPago			:=  IFNULL(Par_DiasPago,Entero_Cero);
        SET Par_PagoIntCapitaliza	:=  IFNULL(Par_PagoIntCapitaliza,ConsNo);
        IF(Par_TipoPagoInt = Cons_Vencimi)THEN
			SET Par_PagoIntCapitaliza	:= ConsNo;
        END IF;

        SET Par_OpcionAportacion	:=  IFNULL(Par_OpcionAportacion,Cadena_Vacia);
        SET Par_CantRenovacion		:=  IFNULL(Par_CantRenovacion,Entero_Cero);
        SET Par_InvRenovar			:=  IFNULL(Par_InvRenovar,Entero_Cero);
        SET Par_Notas				:=  IFNULL(Par_Notas,Cadena_Vacia);

		IF(IFNULL(Par_Reinvertir, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_Reinvertir := ConsNo;
		END IF;

		/* Calculos de GatReal para Aportaciones */
		SET Var_AportacionID := (SELECT IFNULL(MAX(AportacionID), Entero_Cero) + 1 FROM APORTACIONES);

		IF(Var_TasaFV=Cons_TasaFija) THEN
			SET Cal_GAT := FUNCIONCALCTAGATAPORTACION(Par_FechaVencimiento,Par_FechaInicio,Par_TasaFija);

			-- Calculo del GAT REAL tomando como parametro el GAT Nominal
			SET Cal_GATReal := FUNCIONCALCGATREAL(Cal_GAT,(SELECT InflacionProy AS ValorGatHis
				FROM INFLACIONACTUAL
					WHERE FechaActualizacion =
						(SELECT MAX(FechaActualizacion)
						FROM INFLACIONACTUAL)));
		END IF;

		IF(Var_TasaFV=TasaVariable) THEN
			SET Cal_GAT := Par_ValorGat;

			-- Calculo del GAT REAL tomando como parametro el GAT Nominal
			SET Cal_GATReal := Par_ValorGatReal;
		END IF;

		/*Validacion de Tasas de Ahorro */
		CALL VALIDATASASPRODUCTOS (
			Par_ClienteID,		Par_TipoAportacionID,	Par_ProductoSAFI,	Aud_Sucursal,		Num_Validacion,
			Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,	    Aud_Usuario,
			Aud_FechaActual, 	Aud_DireccionIP,		Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		SELECT Reinversion, Reinvertir
			INTO Var_Reinversion, Var_ReinvertirAport
			FROM	TIPOSAPORTACIONES
			WHERE 	TipoAportacionID = Par_TipoAportacionID;


		/* Obtener fecha de pago segun parametrizacion del producto y recorrer la fecha de pago al dia habil
		anterior si originalmente cae en dia inhabil o festivo. */


		SELECT DiaInhabil
			INTO Var_DiaInhabil
			FROM TIPOSAPORTACIONES
				WHERE TipoAportacionID= Par_TipoAportacionID;

        -- Se obtiene la tasa fija antes del cambio
       SET Var_TasaExistente := (SELECT ROUND(TasaFija,2) FROM APORTACIONES WHERE AportacionID=Par_AportacionID);
		SET Var_MontoGlobal := (FNAPORTMONTOGLOBAL(Par_TipoAportacionID,Par_ClienteID)+Par_Monto);

		-- Se Actualiza la Aportación
		UPDATE APORTACIONES SET
				TipoAportacionID	= Par_TipoAportacionID,
				CuentaAhoID			= Par_CuentaAhoID,
				ClienteID 	 		= Par_ClienteID,
				FechaInicio 		= Par_FechaInicio,
				FechaVencimiento	= Par_FechaVencimiento,
				FechaPago			= Par_FechaVencimiento,
				Monto 				= Par_Monto,
				Plazo 				= Par_Plazo,
				TasaFija 			= Par_TasaFija,
				TasaISR 			= Par_TasaISR,
				TasaNeta 			= Par_TasaNeta,

				InteresGenerado		= Par_InteresGenerado,
				InteresRecibir		= Par_InteresRecibir,
				InteresRetener		= Par_InteresRetener,
				ValorGat			= Cal_GAT,
				ValorGatReal		= Cal_GATReal,
				MonedaID			= Par_MonedaID,
				FechaVenAnt			= Par_FechaVenAnt,
				TipoPagoInt			= Par_TipoPagoInt,
				DiasPeriodo			= Par_DiasPeriodo,
				PagoIntCal			= Par_PagoIntCal,

				CalculoInteres 		= Par_CalculoInteres,
				TasaBase			= Par_TasaBaseID,
				SobreTasa			= Par_SobreTasa,
				PisoTasa			= Par_PisoTasa,
				TechoTasa			= Par_TechoTasa,
				PlazoOriginal	 	= Par_PlazoOriginal,

				Reinversion			= Par_Reinversion,
				Reinvertir			= Par_Reinvertir,
				CajaRetiro 			= Par_CajaRetiro,
				MontoGlobal			= Var_MontoGlobal,
				TasaMontoGlobal		= Var_TasaMontoGlobal,
				IncluyeGpoFam		= Var_IncluyeGpoFam,

                DiasPago			= Par_DiasPago,
				PagoIntCapitaliza	= Par_PagoIntCapitaliza,
                OpcionAport			= Par_OpcionAportacion,
                CantidadReno 		= Par_CantRenovacion,
                InvRenovar			= Par_InvRenovar,
                Notas 				= Par_Notas,
                AperturaAport		= Par_AperturaAport,

				EmpresaID			= Par_EmpresaID,
				UsuarioID			= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
		WHERE 	AportacionID				= Par_AportacionID;

        -- Consulta para obtener si la aportacion especifica tasa
        SELECT EspecificaTasa
		INTO Var_EspTasa
		FROM TIPOSAPORTACIONES
		WHERE TipoAportacionID=Par_TipoAportacionID;
        SET Var_EspTasa :=IFNULL(Var_EspTasa,ConsNo);

        -- Si la aportacion cambio de tasa manualmente se hace el insert a la tabla CAMBIOTASAAPORT
		IF (Var_TasaFV = Cons_TasaFija AND Var_EspTasa=Cons_SI) THEN
			SET Var_Calific 	:= (SELECT CalificaCredito FROM CLIENTES WHERE ClienteID=Par_ClienteID);
			SET Var_TasaBruta	:= ROUND(FUNCIONTASAAPORTACION(Par_TipoAportacionID , Par_PlazoOriginal , Var_MontoGlobal, Var_Calific, Aud_Sucursal),2);

			IF(Var_TasaBruta <> Par_TasaFija AND Var_TasaExistente <> ROUND(Par_TasaFija,2))THEN
				CALL CAMBIOTASAAPORTALT(
					Par_AportacionID,	Var_TasaBruta,		Par_TasaFija, 		TipoReg_Aport,		Salida_NO,
					Par_NumErr,			Par_ErrMen,			Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
			END IF;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT("Aportacion Modificada Exitosamente: ", CONVERT(Par_AportacionID,CHAR),'.') ;
		SET Var_Control	:= 'aportacionID';
		SET Var_Consecutivo := Par_AportacionID;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI)THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$


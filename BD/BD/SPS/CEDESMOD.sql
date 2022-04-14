-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESMOD`;
DELIMITER $$


CREATE PROCEDURE `CEDESMOD`(
# ==============================================================
# ----------------- SP PARA MODIFICAR LOS CEDES-----------------
# ==============================================================
	Par_CedeID					INT(11),
	Par_TipoCedeID				INT(11),
	Par_CuentaAhoID				BIGINT(12),
	Par_ClienteID				INT(11),
	Par_FechaInicio				DATE,

	Par_FechaVencimiento		DATE,
	Par_Monto					DECIMAL(18,2),
	Par_Plazo					INT(11),
	Par_TasaFija				DECIMAL(12,4),
	Par_TasaISR					DECIMAL(12,4),

	Par_TasaNeta				DECIMAL(12,4),
	Par_InteresGenerado			DECIMAL(18,2),
	Par_InteresRecibir			DECIMAL(18,2),
	Par_InteresRetener			DECIMAL(18,2),
	Par_SaldoProvision			DECIMAL(18,2),

	Par_ValorGat				DECIMAL(12,4),
	Par_ValorGatReal			DECIMAL(12,4),
	Par_MonedaID				INT(11),
	Par_FechaVenAnt				DATE,
	Par_TipoPagoInt				CHAR(1),

    Par_DiasPeriodo				INT(11),				-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	Par_PagoIntCal				CHAR(2),				-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
    Par_CalculoInteres			INT(1),					-- Calculo de Interes
	Par_TasaBaseID				INT(2),					-- Tasa Base
	Par_SobreTasa				DECIMAL(12,4),			-- Sobre Tasa

	Par_PisoTasa				DECIMAL(12,4),			-- Piso Tasa
	Par_TechoTasa				DECIMAL(12,4),			-- Techo Tasa
	Par_ProductoSAFI			INT(11),				-- Total de Productos SAFI
	Par_PlazoOriginal			INT(11),
	Par_Reinversion				CHAR(1),

	Par_Reinvertir				CHAR(3),
	Par_CajaRetiro				INT(11),				-- Sucursal donde se realizara el retiro despues del vencimiento

	Par_Salida 					CHAR(1), 				-- Salida en Pantalla
	INOUT	Par_NumErr 			INT(11),
	INOUT	Par_ErrMen 			VARCHAR(400),

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
	DECLARE Var_ReinvertirCede		CHAR(3);
	DECLARE Var_DiaInhabil			CHAR(2);		-- Almacena el Dia Inhabil
	DECLARE VarDiaGenerado			DATE;
	DECLARE FechaVig				DATE;
	DECLARE VarFechaPago			DATE;
 	DECLARE Var_Control				VARCHAR(20);	-- ID del contorl en pantalla
	DECLARE Var_ValorUMA			DECIMAL(12,4);
    DECLARE Var_TipoPersona			CHAR(1);
	DECLARE Var_EstatusTipoCede		CHAR(2);		-- Estatus del Tipo Cede
	DECLARE Var_Descripcion			VARCHAR(200);	-- Descripcion Tipo Cede



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
	DECLARE TasaFija				CHAR(1);
	DECLARE TasaVariable			CHAR(1);
	DECLARE Cal_GAT					DECIMAL(12,2);
	DECLARE Var_CedeID				INT(11);
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
	SET TasaFija					:= 'F';
	SET TasaVariable				:= 'V';
	SET Cal_GAT						:= 0.00;
	SET Var_CedeID					:= 0;
	SET NumValidacion				:= 3;
	SET Num_Validacion				:= 4;
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

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-CEDESMOD');
			SET Var_Control= 'SQLEXCEPTION';
		END;

		IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 20;
			SET Par_ErrMen	:= 'El Numero de safilocale.cliente se Encuentra Vacio.' ;
			SET Var_Control	:= 'clienteID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF EXISTS (SELECT ClienteID
					FROM CLIENTES
					WHERE ClienteID = Par_ClienteID
					AND EsMenorEdad = MenorEdad)THEN
			SET Par_NumErr	:= 21;
			SET Par_ErrMen	:= 'El safilocale.cliente es Menor de Edad.' ;
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


		SELECT TasaFV,				Estatus,				Descripcion
				INTO Var_TasaFV,	 Var_EstatusTipoCede,	Var_Descripcion
			FROM TIPOSCEDES
				WHERE	TipoCedeID	 = Par_TipoCedeID;


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


		IF(IFNULL(Var_Cue_Saldo, Entero_Cero)) < Par_Monto THEN
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

		SET Par_Plazo	= DATEDIFF(Par_FechaVencimiento, Par_FechaInicio);

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

		IF(IFNULL(Par_TasaFija , Decimal_Cero)) = Decimal_Cero AND Var_TasaFV=TasaFija THEN
			SET Par_NumErr	:= 014;
			SET Par_ErrMen	:= 'No existe una Tasa para el Plazo y Monto.' ;
			SET Var_Control	:= 'tasaNeta';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(Var_TasaFV=TasaFija) THEN
			SET Par_TasaNeta 		:= ROUND(Par_TasaFija - Par_TasaISR, 4);
			SET Par_InteresGenerado := ROUND((Par_Monto * Par_Plazo * Par_TasaFija) / (Factor_Porcen * Var_DiasInversion), 2);
		END IF;

		SET Var_SalMinAn := Var_SalMinDF * 5 * Var_ValorUMA;


		/* SI EL MONTO DE LA CEDE es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
		* entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
		* si no es CERO */

		/* Si el cliente paga ISR entonces se calcula el interes a Retener , sino su valor sera cero*/
        /* Cuando sea persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exencion alguna. */
		IF (Var_PagaISR = SI_PagaISR) THEN
			IF( Par_Monto > Var_SalMinAn OR Var_TipoPersona = Per_Moral )THEN
				IF(Var_TipoPersona = Per_Moral)THEN
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


		IF(Var_TasaFV=TasaFija) THEN
		SET Par_InteresRecibir = ROUND(Par_InteresGenerado - Par_InteresRetener, 2);
		END IF;


		IF(IFNULL( Par_InteresGenerado, Decimal_Cero)) = Decimal_Cero AND Var_TasaFV=TasaFija THEN
			SET Par_NumErr	:= 015;
			SET Par_ErrMen	:= 'El Interes Generado esta Vacio.' ;
			SET Var_Control	:= 'interesGenerado';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_InteresRecibir ,Decimal_Cero)) = Decimal_Cero AND Var_TasaFV=TasaFija THEN
			SET Par_NumErr	:= 016;
			SET Par_ErrMen	:= 'El Interes a Recibir esta Vacio.' ;
			SET Var_Control	:= 'interesRecibir';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_FechaSis != Par_FechaInicio)THEN
			SET Par_NumErr	:= 017;
			SET Par_ErrMen	:= CONCAT ('La Fecha de Inicio ', Par_FechaInicio, ' es incorrecta');
			SET Var_Control	:= 'cedeID';
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

		IF(Var_EstatusTipoCede = Inactivo) THEN
			SET Par_NumErr	:=	025;
			SET Par_ErrMen	:=	CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control	:=	'tipoCedeID';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Reinvertir, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_Reinvertir := ConsNo;
		END IF;

		/* Calculos de GatReal para insertar CEDE */
		SET Var_CedeID := (SELECT IFNULL(MAX(CedeID), Entero_Cero) + 1 FROM CEDES);

		IF(Var_TasaFV=TasaFija) THEN
			SET Cal_GAT := FUNCIONCALCTAGATCEDE(Par_FechaVencimiento,Par_FechaInicio,Par_TasaFija);

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

		CALL VALPRODUCPERFIL(
			Par_ClienteID,		Par_TipoCedeID,			NumValidacion,		Salida_NO, 			Par_NumErr,
            Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		/*Validacion de Tasas de Ahorro */
		CALL VALIDATASASPRODUCTOS (
			Par_ClienteID,		Par_TipoCedeID,		Par_ProductoSAFI,	Aud_Sucursal,		Num_Validacion,
            Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	    Aud_Usuario,
            Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		SELECT Reinversion, Reinvertir
			INTO Var_Reinversion, Var_ReinvertirCede
			FROM	TIPOSCEDES
            WHERE 	TipoCedeID = Par_TipoCedeID;


		/* Obtener fecha de pago segun parametrizacion del producto y recorrer la fecha de pago al dia habil
		anterior si originalmente cae en dia inhabil o festivo. */


		SELECT DiaInhabil
			INTO Var_DiaInhabil
			FROM TIPOSCEDES
				WHERE TipoCedeID= Par_TipoCedeID;

		SET VarDiaGenerado	:= Par_FechaVencimiento ;


		IF (Var_DiaInhabil= Dia_SD)THEN

			CALL DIASHABILSDANTERCAL(
				VarDiaGenerado,		Entero_Cero, 		FechaVig, 		Par_EmpresaID, 	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			SET VarFechaPago	:= FechaVig;

			CALL DIASHABILANTERCAL(
				VarFechaPago, 		Entero_Cero, 		FechaVig, 		Par_EmpresaID, 	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			SET VarFechaPago:=FechaVig;
		 ELSE
			IF (Var_DiaInhabil= Dia_D)THEN

				CALL DIASHABILANTERCAL(
					VarDiaGenerado, 	Entero_Cero, 		FechaVig, 		Par_EmpresaID, 	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

				SET VarFechaPago:=FechaVig;
			END IF;
		END IF;

		/* Se Actualiza CEDE */

		UPDATE CEDES SET
				TipoCedeID			= Par_TipoCedeID,
				CuentaAhoID			= Par_CuentaAhoID,
				ClienteID 	 		= Par_ClienteID,
				FechaInicio 		= Par_FechaInicio,
				FechaVencimiento	= Par_FechaVencimiento,
				FechaPago			= VarFechaPago,
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

				EmpresaID			= Par_EmpresaID,
				UsuarioID			= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
		WHERE 	CedeID				= Par_CedeID;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT("CEDE Modificado Exitosamente: ", CONVERT(Par_CedeID,CHAR)) ;
		SET Var_Control	:= 'cedeID';
		SET Var_Consecutivo := Par_CedeID;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI)THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$
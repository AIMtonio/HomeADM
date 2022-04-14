-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCEDESWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCEDESWSPRO`;DELIMITER $$

CREATE PROCEDURE `CRCBCEDESWSPRO`(
# =====================================================================================
# ------- STORE PARA REALIZAR ALTA Y AUTORIZACION DE UN CEDE CREDICLUB ---------
# =====================================================================================
	Par_ClienteID			INT(11), 			-- numero del cliente
	Par_CuentaAhoID			BIGINT(12),			-- numero de cuenta del cliente
	Par_TipoCedeID			INT(11), 			-- tipo de CEDE a dar de alta
	Par_TipoPago			CHAR(2), 			-- tipo de pago VENCIMIENTO, FIN DE MES, perido
	Par_DiasPeriodo			INT(11), 			-- indica los dias que transcurrira de una fecha a otra para el pago del interes periodico.

	Par_Monto				DECIMAL(12,2), 		-- monto de la cede
	Par_Plazo				INT(11),			-- numero de dias de la  cede
	Par_Tasa				DECIMAL(12,4),		-- tasa de la cede
	Par_Reinvertir			CHAR(2), 			-- tipo de pago VENCIMIENTO, FIN DE MES
	Par_TipoReinversion		CHAR(2), 			-- tipo de reinversion C: capital, CI capital mas intereses
    INOUT Par_Poliza		BIGINT(20),			-- Numero de poliza

	Par_Salida				CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr   		INT(11),			-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Descripcion del Error

	Par_EmpresaID			INT(11),			-- EmpresaID
	Aud_Usuario				INT(11),	        -- Usuario ID
	Aud_FechaActual			DATETIME,           -- Fecha Actual
	Aud_DireccionIP			VARCHAR(15),        -- Direccion IP
	Aud_ProgramaID			VARCHAR(50),        -- Nombre de programa
	Aud_Sucursal			INT(11),            -- Sucursal ID
	Aud_NumTransaccion		BIGINT(20)          -- Numero de transaccion
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control	    		VARCHAR(100);  		-- variable de control
	DECLARE Var_SaldoDisponible		DECIMAL(14,2);		-- saldo disponible
	DECLARE Var_MonedaID			INT(11);			-- ID de la moneda de la cuenta
	DECLARE Var_SucurCli			INT(11);			-- Sucursal del cliente
	DECLARE Var_FechaSis			DATE;				-- fecha del sistema
	DECLARE Var_TasaFija			DECIMAL(14,2);		-- valor de la tasa fija
    DECLARE Var_EmpresaID			INT(11);			-- empresa ID
    DECLARE Var_ClienteID			INT(11);			-- ID del cliente
    DECLARE Var_EstatusC			CHAR(1);			-- estatus de la cuenta
    DECLARE Var_CuentaID			BIGINT(12);			-- numero de cuneta de ahorro
    DECLARE Var_EstatusCli			CHAR(1);			-- estatus del cliente
	DECLARE Var_SucursalUsuario		INT(11);			-- sucursal del usuario
    DECLARE Var_UsuarioID			INT(11);			-- ID del usuario
    DECLARE Var_Consecutivo			BIGINT(12);			-- consecutivo
    DECLARE Var_TipoCedeID			INT(11);			-- tipo de cede
    DECLARE Var_MonedaIDCede		INT(11);			-- moneda de la cede
    DECLARE Var_TasaAnualizada		DECIMAL(12,4);		-- tasa anualizada
	DECLARE Var_ValorGat			DECIMAL(12,4);		-- valor del GAT
	DECLARE Var_ValorGatReal		DECIMAL(12,4);		-- valor del gat REAL
	DECLARE Var_Inflacion			DECIMAL(12,4);		-- valor de inflacio
	DECLARE Var_UltimaFechaAct		DATE;				-- ultima fecha de actualizacion
	DECLARE Var_Plazo				INT(11);			-- valor del plazo
	DECLARE Var_EsMenor				CHAR(1);			-- indica si el cliente es menor de edad
	DECLARE Var_Reinversion			CHAR(3);			-- indica si reinvierte
	DECLARE Var_FechaVencim			DATE;				-- fecha de vencimiento
	DECLARE Var_FechaVenCal			DATE;				-- fecha de vencimeinto calculada
	DECLARE Var_EsHabil				CHAR(1);			-- es dia habil
	DECLARE Var_TasaISR				DECIMAL(12,4);		-- tasa ISR
	DECLARE Var_PagaISR				CHAR(1);			-- paga ISR
	DECLARE Var_Poliza				BIGINT(20);			-- NUMERO DE POLIZA
	DECLARE Var_CedeID 		 		INT(11);			-- ID de cede
	DECLARE	Var_ISRReal				DECIMAL(12,4);		-- valor ISR
    DECLARE Var_InteresGenerado		DECIMAL(12,4);		-- Interes generado
	DECLARE	Var_InteresRecibir		DECIMAL(12,4);		-- interes recibir
    DECLARE Var_Monto				DECIMAL(12,4);		-- MONTO TOTAL
    DECLARE Var_FechaVencimiento 	DATE;				-- Fecha de vencimiento
    DECLARE Var_TasaFV				CHAR(1);			-- Valor tasa fija del tipo de cede
    DECLARE Var_Calificacion		CHAR(1);			-- Calificacion del cliente
    DECLARE Var_TasaBase			DECIMAL(12,4);		-- tasa base
    DECLARE Var_CalculoInteres		INT(11);			-- tipo de calculo de intereses
    DECLARE Var_SobreTasa 	   		DECIMAL(12,4);		-- sobre tasa
	DECLARE	Var_PisoTasa 	   		DECIMAL(12,4);		-- piso tasa
	DECLARE Var_TechoTasa 	   		DECIMAL(12,4);		-- Techo tasa
	DECLARE Var_TotalCedes			INT(11);			-- Total de productos SAFI
	DECLARE Var_CajaRetiro			INT(11);			-- Valor caja retiro
    DECLARE Var_DiasPlazo			INT(11);			-- dias transcurridos
    DECLARE Var_PagoIntCal			CHAR(2);			-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
    DECLARE Var_Reinvertir			CHAR(2);
    DECLARE Var_TipoPago			INT(11);
	DECLARE Var_EstatusISR			CHAR(1);			-- ESTATUS DEL ISR INFORMATIVO
    DECLARE Var_EjecutaCierre		CHAR(1);			-- indica si se esta realizando el cierre de dia

	/* Declaracion de constantes */
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Entero_Cero			INT(11);
	DECLARE Entero_Uno			INT(11);
	DECLARE Entero_Seis			INT(11);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE AltaEncPoliza		CHAR(1);
	DECLARE AltaPoliza			CHAR(1);
	DECLARE ConceptoAho			INT(11);
	DECLARE Salida_NO			CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE TipoCuenta			CHAR(1);
	DECLARE AutorizacionInv		INT(11);
	DECLARE ImprimePagare		INT(11);
	DECLARE TipoVencimiento		CHAR(1);
	DECLARE TipoFinMes			CHAR(1);
    DECLARE TipoPeriodo			CHAR(1);
	DECLARE Alta_Cede			INT(11);
	DECLARE Act_Autorizar		INT(11);
	DECLARE ConTasaFija			CHAR(1);
	DECLARE ConTasaVariable		CHAR(1);
	DECLARE Esta_Vigente		CHAR(1);
	DECLARE CalculoFijo			INT(11);
    DECLARE TipoIndistinto		CHAR(1);
	DECLARE ValorCierre			VARCHAR(30);	-- INDICA SI SE REALIZA EL CIERRE DE DIA.

	/* Asignacion de constantes */
	SET Decimal_Cero		:= 0.0;
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Entero_Seis			:= 6;
	SET AutorizacionInv		:= 9;
	SET ImprimePagare		:= 7;
	SET	Alta_Cede			:= 1;
	SET Act_Autorizar		:= 3;
	SET CalculoFijo			:= 1;
    SET	Cadena_Vacia		:= '';
    SET Fecha_Vacia			:= '1900-01-01';
	SET Estatus_Activo		:= 'A';
	SET AltaEncPoliza		:= 'N';
	SET AltaPoliza			:= 'S';
	SET ConceptoAho			:= 1;
	SET Salida_NO			:= 'N';
    SET Salida_SI			:= 'S';
    SET TipoCuenta			:= 'S';
    SET TipoVencimiento		:= 'V';
    SET TipoFinMes			:= 'F';
    SET ConTasaFija			:= 'F';
    SET ConTasaVariable		:= 'V';
    SET Esta_Vigente		:= 'N';
    SET TipoPeriodo			:= 'P';
    SET TipoIndistinto		:= 'I';
    SET ValorCierre			:= 'EjecucionCierreDia';


ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBCEDESWSPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

        SET Var_EjecutaCierre := (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

        -- Validamos que no se este ejecutando el cierre de dia
        IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=Salida_SI)THEN
			SET Par_NumErr  := 800;
			SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
        END IF;

        -- Asignamos valores .
        SELECT FechaSistema, EmpresaID  INTO	Var_FechaSis, Var_EmpresaID
			FROM PARAMETROSSIS
			WHERE EmpresaID = Par_EmpresaID;

		-- Obtenemos usuario y sucursal para la tasa ISR
		SELECT UsuarioID, SucursalUsuario INTO	Var_UsuarioID, Var_SucursalUsuario
			FROM USUARIOS WHERE UsuarioID = Aud_Usuario;

		SET Aud_FechaActual			:= NOW();
		SET Par_EmpresaID			:= Var_EmpresaID;
		SET Var_CajaRetiro			:= Entero_Cero;
		SET Var_UltimaFechaAct		:=(SELECT MAX(FechaActualizacion) FROM INFLACIONACTUAL LIMIT 1);
        SET Var_TasaISR				:=(SELECT TasaISR FROM SUCURSALES WHERE SucursalID = Var_SucursalUsuario);

        SELECT   Cta.CuentaAhoID,		Cli.ClienteID,		Cli.Estatus,	Cta.MonedaID,	 Cta.Estatus,
        		 Cta.SaldoDispon,		Cli.EsMenorEdad,	Cli.PagaISR,	Cli.CalificaCredito
			INTO Var_CuentaID,			Var_ClienteID, 		Var_EstatusCli,	Var_MonedaID,	 Var_EstatusC,
				 Var_SaldoDisponible,	Var_EsMenor,		Var_PagaISR,	Var_Calificacion
		FROM  CLIENTES Cli
			INNER JOIN CUENTASAHO Cta ON Cta.ClienteID = Cli.ClienteID
				WHERE Cli.ClienteID = Par_ClienteID
					AND Cta.CuentaAhoID = Par_CuentaAhoID;

		SELECT   TipoCedeID,	MonedaId,			Reinversion,		Reinvertir,
				TasaFV, 		PagoIntCal
			INTO Var_TipoCedeID,	Var_MonedaIDCede,	Var_Reinversion,	Var_Reinvertir,
				 Var_TasaFV,		Var_PagoIntCal
		FROM TIPOSCEDES WHERE TipoCedeID = Par_TipoCedeID;

		SELECT InflacionProy INTO Var_Inflacion
			FROM INFLACIONACTUAL WHERE FechaActualizacion=Var_UltimaFechaAct;

		-- total de productos SAFI
		SELECT	COUNT(CedeID) INTO Var_TotalCedes FROM CEDES
			WHERE 	ClienteID 	= Par_ClienteID AND Estatus	= Esta_Vigente;

		SET Var_MonedaID 		:= IFNULL(Var_MonedaID,Entero_Cero);
		SET Var_MonedaIDCede 	:= IFNULL(Var_MonedaIDCede,Entero_Cero);
		SET Var_Inflacion 	 	:= IFNULL(Var_Inflacion,Decimal_Cero);
		SET Var_Plazo			:= Par_Plazo;
		SET Var_Poliza			:= Par_Poliza;
		SET Var_TasaFV			:= IFNULL(Var_TasaFV,Cadena_Vacia);


        IF (IFNULL(Var_UsuarioID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'Usuario Incorrecto.';
			LEAVE ManejoErrores;
		END IF;

		-- Validamos la cuenta
		IF (IFNULL(Var_ClienteID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Numero de Cliente No Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_CuentaID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Numero de Cuenta No Esta Ligada al Cliente.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_EstatusC,Cadena_Vacia) != Estatus_Activo) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El Estatus de la Cuenta No  Permite Realizar la Operacion.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_EstatusCli,Cadena_Vacia) != Estatus_Activo) THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'El Estatus del Cliente No  Permite Realizar la Operacion.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_EsMenor,Cadena_Vacia) = Salida_SI) THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := 'El Cliente Es Menor de Edad.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_TipoCedeID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := 'El Tipo de CEDE No Existe.';
			LEAVE ManejoErrores;
		END IF;

        IF(Var_MonedaID = Entero_Cero OR Var_MonedaIDCede = Entero_Cero) THEN
			SET Par_NumErr := 9;
			SET Par_ErrMen := 'El Tipo de Moneda No Existe.';
			LEAVE ManejoErrores;
		ELSE
			IF(Var_MonedaID <>Var_MonedaIDCede)THEN
				SET Par_NumErr := 10;
				SET Par_ErrMen := 'El Tipo de CEDE No Corresponde con la Moneda de la Cuenta.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Monto,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr := 11;
			SET Par_ErrMen := 'El Monto del CEDE Esta Vacio.';
			LEAVE ManejoErrores;
		ELSE
			IF(Par_Monto > Var_SaldoDisponible)THEN
				SET Par_NumErr := 12;
				SET Par_ErrMen := 'El Monto del CEDE es Superior al Saldo en la Cuenta.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (IFNULL(Par_Plazo,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 13;
			SET Par_ErrMen  := 'El Plazo del CEDE Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_Tasa,Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr  := 14;
			SET Par_ErrMen  := 'La Tasa del CEDE Esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_TipoPago,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 15;
			SET Par_ErrMen := 'El Tipo de Pago Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		SET Var_TipoPago := (SELECT  FIND_IN_SET(Par_TipoPago,TipoPagoInt) FROM TIPOSCEDES WHERE TipoCedeID=Par_TipoCedeID);

		IF(Var_TipoPago = Entero_Cero)THEN
			SET Par_NumErr := 16;
			SET Par_ErrMen := 'El Tipo de Pago de Intereses Es Incorrecto.';
			LEAVE ManejoErrores;
		END IF;

        IF( Par_TipoPago=TipoPeriodo)THEN
			IF(IFNULL(Par_DiasPeriodo,Entero_Cero)=Entero_Cero)THEN
				SET Par_NumErr := 17;
				SET Par_ErrMen := 'El Valor Dias del Periodo Esta Vacio.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Calculo de tasa
		IF(Var_TasaFV = ConTasaFija) THEN

			SET Var_TasaFija		:= FORMAT(FUNCIONTASACEDE(Par_TipoCedeID , Par_Plazo , Par_Monto, Var_Calificacion, Var_SucursalUsuario),4);
			SET Var_ValorGat		:= FUNCIONCALCTAGATCEDE(Fecha_Vacia,Fecha_Vacia,Var_TasaFija);
			SET Var_ValorGatReal	:= FUNCIONCALCGATREAL(Var_ValorGat,Var_Inflacion);
			SET Var_TasaBase 		:= Entero_Cero;
			SET Var_CalculoInteres 	:= CalculoFijo;
			SET Var_SobreTasa 	   	:= Decimal_Cero;
			SET Var_PisoTasa 	   	:= Decimal_Cero;
			SET Var_TechoTasa 	   	:= Decimal_Cero;
		ELSE
			IF(Var_TasaFV = ConTasaVariable) THEN
				SELECT tas.TasaBase, tas.CalculoInteres, tas.SobreTasa, tas.PisoTasa, tas.TechoTasa
					INTO Var_TasaBase,	Var_CalculoInteres,	Var_SobreTasa,	Var_PisoTasa,	Var_TechoTasa
				FROM TASASCEDES tas INNER JOIN TASACEDESUCURSALES suc
					ON(tas.TipoCedeID = suc.TipoCedeID 	AND  tas.TasaCedeID = suc.TasaCedeID
														AND suc.SucursalID = Var_SucursalUsuario)
				WHERE 	tas.TipoCedeID 			= Par_TipoCedeID
					AND 	tas.PlazoInferior	<= Par_Plazo
					AND		tas.PlazoSuperior	>= Par_Plazo
					AND 	tas.MontoInferior	<= Par_Monto
					AND		tas.MontoSuperior	>= Par_Monto
					AND		tas.TipoCedeID		= Par_TipoCedeID
					AND 	tas.Calificacion	= Var_Calificacion;

				SET Var_TasaFija 		:=	FNTASACEDES(Var_CalculoInteres,	Var_TasaBase,	Var_SobreTasa,	Var_PisoTasa,	Var_TechoTasa);
				SET Var_ValorGat 		:=	FUNCIONCALCTAGATCEDE(Fecha_Vacia,Fecha_Vacia,Var_TasaFija);
				SET Var_ValorGatReal 	:=	FUNCIONCALCGATREAL(Var_ValorGat,Var_Inflacion);
			END IF;
		END IF;

        IF(IFNULL(Var_Reinversion,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr := 18;
			SET Par_ErrMen := 'La Reinversion Automatica esta Vacia.';
			LEAVE ManejoErrores;
        END IF;

        -- validacion de reinversion
        IF(Var_Reinversion = TipoIndistinto)THEN
			IF(IFNULL(Par_Reinvertir,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr := 19;
				SET Par_ErrMen := 'La Reinversion Automatica esta Vacia.';
				LEAVE ManejoErrores;
             ELSE
				SET Var_Reinversion := Par_Reinvertir;
                -- valida si la reinversion es si para que tenga el valor del tipo de reinversion
                IF(Var_Reinversion=Salida_SI)THEN
					IF(IFNULL(Par_TipoReinversion,Cadena_Vacia)=Cadena_Vacia)THEN
						SET Par_NumErr := 20;
						SET Par_ErrMen := 'El Tipo de Reinversion Automatica esta Vacio.';
						LEAVE ManejoErrores;
					ELSE
						SET Var_Reinvertir:= Par_TipoReinversion;
					END IF;
                END IF;
            END IF;
        END IF;

		-- Validacion de tasa
		IF(IFNULL(Var_TasaFija,Decimal_Cero)=Decimal_Cero)THEN
			SET Par_NumErr := 20;
			SET Par_ErrMen := 'No Existe una Tasa Anualizada.';
			LEAVE ManejoErrores;
		END IF;

		-- Calculo de tasa ISR
		IF(Var_PagaISR = Salida_NO)THEN
			SET Var_TasaISR := Decimal_Cero;
		ELSE
			SET Var_TasaISR := IFNULL(Var_TasaISR,Decimal_Cero);
		END IF;

		-- calculo fecha vencimiento
		SET Var_FechaVencim := ADDDATE(Var_FechaSis, Var_Plazo);

		CALL DIASFESTIVOSCAL(
			Var_FechaVencim,		Entero_Cero, 		Var_FechaVenCal, 		Var_EsHabil,		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		SET Var_FechaVencim := Var_FechaVenCal;

        SET Var_DiasPlazo := IFNULL(DATEDIFF(Var_FechaVencim,Var_FechaSis),Entero_Cero);

		-- Se realiza el Alta del CEDE
		CALL CEDESALT(
			Par_TipoCedeID,		Par_CuentaAhoID,	Par_ClienteID,			Var_FechaSis,		Var_FechaVencim,
			Par_Monto,			Var_DiasPlazo,		Var_TasaFija,			Var_TasaISR,		Decimal_Cero,
			Decimal_Cero,		Decimal_Cero,		Decimal_Cero,			Decimal_Cero,		Var_ValorGat,
			Var_ValorGatReal,	Var_MonedaIDCede,	Fecha_Vacia,			Par_TipoPago,		Par_DiasPeriodo,
			Var_PagoIntCal,		Var_CalculoInteres,	Var_TasaBase,			Var_SobreTasa,		Var_PisoTasa,
			Var_TechoTasa,		Var_TotalCedes,		Var_Reinversion,		Var_Reinvertir,		Alta_Cede,
			Var_CajaRetiro,		Par_Plazo,			Var_CedeID,				Salida_NO,			Par_NumErr,
            Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- se genera simulacion de amortizaciones
		CALL CEDESSIMULADORPRO(
			Var_CedeID,			Var_FechaSis,		Var_FechaVencim,	Par_Monto,			Par_ClienteID,
			Par_TipoCedeID,		Var_TasaFija,		Par_TipoPago,		Par_DiasPeriodo,	Var_PagoIntCal,
            Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se Realiza la validacion de la CEDE para autorizarla
		CALL CEDESVAL(
			Var_CedeID, 		Var_TotalCedes,		Salida_NO, 			Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,   	Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se realiza la Actualizacion del CEDE
		CALL CEDESACT(
			Var_CedeID, 		Var_TotalCedes, 	Var_Poliza,		Act_Autorizar, 		Salida_NO,
			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal, 	Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

        -- se obtienen parametros para repsuesta
        SELECT
			InteresRetener, 	InteresGenerado, 		InteresRecibir, 	Monto, 		FechaVencimiento,
			Plazo
		INTO
			Var_ISRReal,		Var_InteresGenerado,	Var_InteresRecibir,	Var_Monto,	Var_FechaVencimiento,
			Par_Plazo
		FROM CEDES
			WHERE CedeID= Var_CedeID;

		SET Var_EstatusISR		:= (SELECT Estatus FROM ISRPARAM ORDER BY FechaActual DESC LIMIT 1);
		SET Var_EstatusISR		:= IFNULL(Var_EstatusISR, Cadena_Vacia);
		SET Var_ISRReal			:= IF(Var_EstatusISR = Estatus_Activo, FNISRINFOCAL(Var_Monto, Par_Plazo, (Var_TasaISR*100)), IFNULL(Var_ISRReal,Entero_Cero));
        SET Var_InteresGenerado	:= IFNULL(Var_InteresGenerado,Entero_Cero);
        SET Var_InteresRecibir	:= IFNULL(Var_InteresRecibir,Entero_Cero);
        SET Var_Monto			:= IFNULL(Var_Monto,Entero_Cero) + Var_InteresRecibir;
        SET Var_FechaVencimiento:= IFNULL(Var_FechaVencimiento,Fecha_Vacia);
        SET Par_NumErr 			:= Entero_Cero;
		SET Par_ErrMen 			:= 'CEDE Agregado Exitosamente';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Var_CedeID 	 		AS  CEDEID,
				Par_NumErr  		 AS NumErr,
				Par_ErrMen 			 AS ErrMen,
				Var_ISRReal			 AS ISRReal,
                Var_InteresGenerado	 AS InteresGenerado,
                Var_InteresRecibir	 AS InteresRecibir,
                Var_Monto			 AS Monto,
                Var_FechaVencimiento AS FechaVencimiento;
	END IF;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBINVERSIONESWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBINVERSIONESWSPRO`;
DELIMITER $$

CREATE PROCEDURE `CRCBINVERSIONESWSPRO`(
# =====================================================================================
# ------- STORE PARA REALIZAR ALTA Y AUTORIZACION DE UNA INVERSION CREDICLUB ---------
# =====================================================================================
	Par_ClienteID			INT(11), 			-- numero del cliente
	Par_CuentaAhoID			BIGINT(12),			-- numero de cuenta del cliente
	Par_TipoInversionID		INT(11), 			-- tipo de inversion a dar de alta
	Par_Monto				DECIMAL(12,2), 		-- monto de la inversion
	Par_Plazo				INT(11),			-- numero de dias de la  inversion

	Par_Tasa				DECIMAL(12,4),		-- tasa de la inversion
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
	DECLARE Var_Control	    	VARCHAR(100);  		-- variable de control
	DECLARE Var_SaldoDisponible	DECIMAL(14,2);		-- saldo disponible
	DECLARE Var_MonedaID		INT(11);			-- ID de la moneda de la cuenta
	DECLARE Var_SucurCli		INT(11);			-- Sucursal del cliente
	DECLARE Var_FechaSis		DATE;				-- fecha del sistema
	DECLARE Var_TipoMovAho		INT(11);			-- tipo de movimiento de ahorro
    DECLARE Var_EmpresaID		INT(11);			-- empresa ID
    DECLARE Var_ClienteID		INT(11);			-- ID del cliente
    DECLARE Var_EstatusC		CHAR(1);			-- estatus de la cuenta
    DECLARE Var_CuentaID		BIGINT(12);			-- numero de cuneta de ahorro
    DECLARE Var_EstatusCli		CHAR(1);			-- estatus del cliente
	DECLARE Var_SucursalUsuario	INT(11);			-- sucursal del usuario
    DECLARE Var_UsuarioID		INT(11);			-- ID del usuario
    DECLARE Var_Consecutivo		BIGINT(12);			-- consecutivo
    DECLARE Var_TipoInversionID	INT(11);			-- tipo de inversionID
    DECLARE Var_EstatusInver	CHAR(1);			-- estatus de la inversion
    DECLARE Var_MonedaIDInver	INT(11);			-- moneda de la inversion
    DECLARE Var_TasaAnualizada	DECIMAL(12,4);		-- tasa anualizada
	DECLARE Var_ValorGat		DECIMAL(12,4);		-- valor del GAT
	DECLARE Var_ValorGatReal	DECIMAL(12,4);		-- valor del gat REAL
	DECLARE Var_Inflacion		DECIMAL(12,4);		-- valor de inflacio
	DECLARE Var_UltimaFechaAct	DATE;				-- ultima fecha de actualizacion
	DECLARE Var_Plazo			INT(11);			-- valor del plazo
	DECLARE Var_EsMenor			CHAR(1);			-- indica si el cliente es menor de edad
	DECLARE Var_Reinversion		CHAR(1);			-- indica si reinvierte
	DECLARE	Var_Reinvertir		CHAR(5);			-- indica tipo de reinversion
	DECLARE Var_FechaVencim		DATE;				-- fecha de vencimiento
	DECLARE Var_FechaVenCal		DATE;				-- fecha de vencimeinto calculada
	DECLARE Var_EsHabil			CHAR(1);			-- es dia habil
	DECLARE Var_TasaISR			DECIMAL(12,4);		-- tasa ISR
	DECLARE Var_PagaISR			CHAR(1);			-- paga ISR
	DECLARE Var_Poliza			BIGINT(20);			-- NUMERO DE POLIZA
	DECLARE Var_InversionID 	INT(11);			-- ID de inversion
	DECLARE	Var_ISRReal			DECIMAL(12,4);		-- valor ISR
    DECLARE Var_InteresGenerado	DECIMAL(12,4);		-- Interes generado
	DECLARE	Var_InteresRecibir	DECIMAL(12,4);		-- interes recibir
    DECLARE Var_Monto			DECIMAL(12,4);		-- MONTO TOTAL
    DECLARE Var_FechaVencimiento DATE;				-- Fecha de vencimiento
	DECLARE Var_EstatusISR		CHAR(1);			-- ESTATUS DEL ISR INFORMATIVO
    DECLARE Var_EjecutaCierre	CHAR(1);			-- indica si se esta realizando el cierre de dia


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
    DECLARE ValorCierre			VARCHAR(30);	-- INDICA SI SE REALIZA EL CIERRE DE DIA.
	/* Declaración Constantes Salario Minimo */
	DECLARE Fre_DiasAnio		DECIMAL(14,2);
	DECLARE Var_SalMinDF		DECIMAL(14,2);
	DECLARE Var_SalMinAn		DECIMAL(14,2);

	/* Asignacion de constantes */
	SET Decimal_Cero		:= 0.0;
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Entero_Seis			:= 6;
	SET AutorizacionInv		:= 9;
	SET ImprimePagare		:= 7;
    SET	Cadena_Vacia		:= '';
    SET Fecha_Vacia			:= '1900-01-01';
	SET Estatus_Activo		:= 'A';
	SET AltaEncPoliza		:= 'N';
	SET AltaPoliza			:= 'S';
	SET ConceptoAho			:= 1;
	SET Salida_NO			:= 'N';
    SET Salida_SI			:= 'S';
    SET TipoCuenta			:= 'S';
    SET ValorCierre			:= 'EjecucionCierreDia';

ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBINVERSIONESWSPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

        -- Asignamos valores .
        SELECT FechaSistema, EmpresaID  INTO	Var_FechaSis, Var_EmpresaID
			FROM PARAMETROSSIS
			WHERE EmpresaID = Par_EmpresaID;

		SET Var_EjecutaCierre := (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

		-- Validamos que no se este ejecutando el cierre de dia
        IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=Salida_SI)THEN
			SET Par_NumErr  := 800;
			SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
        END IF;

		-- Obtenemos usuario y sucursal para la tasa ISR
		SELECT UsuarioID, SucursalUsuario INTO	Var_UsuarioID, Var_SucursalUsuario
			FROM USUARIOS WHERE UsuarioID = Aud_Usuario;

		SET Aud_FechaActual			:= NOW();
		SET Par_EmpresaID			:= Var_EmpresaID;
		SET Var_UltimaFechaAct		:=(SELECT MAX(FechaActualizacion) FROM INFLACIONACTUAL LIMIT 1);
        SET Var_TasaISR				:=(SELECT TasaISR FROM SUCURSALES WHERE SucursalID = Var_SucursalUsuario);

        SELECT   Cta.CuentaAhoID,		Cli.ClienteID,		Cli.Estatus,	Cta.MonedaID,	 Cta.Estatus,
        		 Cta.SaldoDispon,		Cli.EsMenorEdad,	Cli.PagaISR
			INTO Var_CuentaID,			Var_ClienteID, 		Var_EstatusCli,	Var_MonedaID,	 Var_EstatusC,
				 Var_SaldoDisponible,	Var_EsMenor,		Var_PagaISR
		FROM  CLIENTES Cli
			INNER JOIN CUENTASAHO Cta ON Cta.ClienteID = Cli.ClienteID
				WHERE Cli.ClienteID = Par_ClienteID
					AND Cta.CuentaAhoID = Par_CuentaAhoID;

		SELECT   TipoInversionID,		Estatus, 			MonedaId,			Reinversion,		Reinvertir
			INTO Var_TipoInversionID,	Var_EstatusInver, 	Var_MonedaIDInver,	Var_Reinversion,	Var_Reinvertir
		FROM CATINVERSION WHERE TipoInversionID = Par_TipoInversionID;

		SELECT MAX(InflacionProy), MAX(FechaActualizacion) INTO Var_Inflacion, Var_UltimaFechaAct
			FROM INFLACIONACTUAL LIMIT 1;

		SET Var_MonedaID 		:= IFNULL(Var_MonedaID,Entero_Cero);
		SET Var_MonedaIDInver 	:= IFNULL(Var_MonedaIDInver,Entero_Cero);
		SET Var_Inflacion 	 	:= IFNULL(Var_Inflacion,Decimal_Cero);
		SET Var_Plazo			:= Par_Plazo;
		SET Var_Poliza			:= Par_Poliza;

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

		IF (IFNULL(Var_TipoInversionID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := 'El Tipo de Inversion No Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_EstatusInver,Cadena_Vacia) != Estatus_Activo) THEN
			SET Par_NumErr := 8;
			SET Par_ErrMen := 'El Estatus Del Tipo de Inversion No Esta Vigente.';
			LEAVE ManejoErrores;
		END IF;

        IF(Var_MonedaID = Entero_Cero OR Var_MonedaIDInver = Entero_Cero) THEN
			SET Par_NumErr := 9;
			SET Par_ErrMen := 'El Tipo de Moneda No Existe.';
			LEAVE ManejoErrores;
		ELSE
			IF(Var_MonedaID <>Var_MonedaIDInver)THEN
				SET Par_NumErr := 10;
				SET Par_ErrMen := 'El Tipo de Inversion No Corresponde con la Moneda de la Cuenta.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Monto,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr := 11;
			SET Par_ErrMen := 'El Monto de la Inversion Esta Vacio.';
			LEAVE ManejoErrores;
		ELSE
			IF(Par_Monto > Var_SaldoDisponible)THEN
				SET Par_NumErr := 12;
				SET Par_ErrMen := 'El Monto de Inversion es Superior al Saldo en la Cuenta.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (IFNULL(Par_Plazo,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 12;
			SET Par_ErrMen  := 'El Plazo de la Inversion Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_Tasa,Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr  := 13;
			SET Par_ErrMen  := 'La Tasa de la Inversion Esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

		-- Calculo de la Tasa
		SET Var_TasaAnualizada := FUNCIONTASA(Var_TipoInversionID , Var_Plazo , Par_Monto);
		SET Var_ValorGat 	   := FUNCIONCALCTAGATINV(Fecha_Vacia,Fecha_Vacia,Par_Tasa);
		SET Var_ValorGatReal   := FUNCIONCALCGATREAL(Var_ValorGat,Var_Inflacion);

		IF (IFNULL(Var_TasaAnualizada,Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr  := 14;
			SET Par_ErrMen  := 'No Existe una Tasa Anualizada Para el Plazo y Monto Indicados.';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_PagaISR = Salida_NO)THEN
			SET Var_TasaISR := Decimal_Cero;
		ELSE
			SET Var_TasaISR := IFNULL(Var_TasaISR,Decimal_Cero);
		END IF;
		-- calculo fecha vencimiento y tipo de reinversion
		SET Var_FechaVencim := ADDDATE(Var_FechaSis, Var_Plazo);

		CALL DIASFESTIVOSCAL(
			Var_FechaVencim,		Entero_Cero, 		Var_FechaVenCal, 		Var_EsHabil,		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		SET Var_FechaVencim := Var_FechaVenCal;

		-- Se realiza el Alta de la Inversion
		CALL INVERSIONALT(
			Par_CuentaAhoID,	Par_ClienteID,		Var_TipoInversionID,	Var_FechaSis,		Var_FechaVencim,
			Par_Monto,			Par_Plazo,			Var_TasaAnualizada,		Var_TasaISR,		Decimal_Cero,
			Decimal_Cero,		Decimal_Cero,		Decimal_Cero,			Var_Reinvertir,		Aud_Usuario,
			Entero_Uno,			Entero_Cero,		Var_MonedaIDInver,		Cadena_Vacia,		TipoCuenta,
			Var_Poliza,			Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,
			Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,   	Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_InversionID := (SELECT InversionID FROM INVERSIONES WHERE NumTransaccion = Aud_NumTransaccion);

		-- Se Realiza la validacion de la Inversion para autorizarla
		CALL INVERSIONACT(
			Var_InversionID, 		Cadena_Vacia, 			Cadena_Vacia,		Salida_NO, 				AutorizacionInv,
			Salida_NO, 				Par_NumErr,				Par_ErrMen,			Par_Poliza,				Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se realiza la Actualizacion de la inversion para estatus de pagare
		CALL INVERSIONACT(
			Var_InversionID, 		Cadena_Vacia, 			Cadena_Vacia,		Salida_NO, 				ImprimePagare,
			Salida_NO, 				Par_NumErr,				Par_ErrMen,			Par_Poliza,				Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

        -- se obtienen parametros para repsuesta
        SELECT
			InteresRetener,			InteresGenerado, 		InteresRecibir, 	Monto, 		FechaVencimiento,
			Plazo
		INTO
            Var_ISRReal,		Var_InteresGenerado,	Var_InteresRecibir,	Var_Monto,	Var_FechaVencimiento,
            Par_Plazo
		FROM INVERSIONES
			WHERE InversionID= Var_InversionID;
		-- Se calcula el salario minimo del monto enviado y se valida antes de setear la variable si lleva ISR o sino lleva ISR
		SET Fre_DiasAnio    :=  (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='ValorUMABase');
		SET Var_SalMinDF    :=  (SELECT param.SalMinDF FROM PARAMETROSSIS param);
		SET Var_SalMinAn    :=  Var_SalMinDF*5* Fre_DiasAnio;

		IF(Par_Monto > Var_SalMinAn)THEN
			SET Var_EstatusISR		:= 'I';
			SET Var_EstatusISR		:= IFNULL(Var_EstatusISR, Cadena_Vacia);
			SET Var_ISRReal	:= IF(Var_EstatusISR = Estatus_Activo, FNISRINFOCAL(Var_Monto, Par_Plazo, (Var_TasaISR*100)), IFNULL(Var_ISRReal,Entero_Cero));
		ELSE
			SET Var_ISRReal	:= Entero_Cero;
		END IF;

        SET Var_InteresGenerado	:= IFNULL(Var_InteresGenerado,Entero_Cero);
        SET Var_InteresRecibir	:= IFNULL(Var_InteresRecibir,Entero_Cero);
        SET Var_Monto			:= IFNULL(Var_Monto,Entero_Cero) + Var_InteresRecibir;
        SET Var_FechaVencimiento:= IFNULL(Var_FechaVencimiento,Fecha_Vacia);
        SET Par_NumErr 			:= Entero_Cero;
		SET Par_ErrMen 			:= 'Inversion Agregada Exitosamente';

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Var_InversionID 	 AS InversionID,
				Par_NumErr  		 AS NumErr,
				Par_ErrMen 			 AS ErrMen,
				Var_ISRReal			 AS ISRReal,
                Var_InteresGenerado	 AS InteresGenerado,
                Var_InteresRecibir	 AS InteresRecibir,
                Var_Monto			 AS Monto,
                Var_FechaVencimiento AS FechaVencimiento;
	END IF;

END TerminaStore$$
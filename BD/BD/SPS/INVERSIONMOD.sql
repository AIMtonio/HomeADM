-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONMOD`;
DELIMITER $$


CREATE PROCEDURE `INVERSIONMOD`(
-- ------------------------------------------------------------
--  			SP PARA LA MODIFICACION DE INVERSIONES
-- ------------------------------------------------------------

	Par_InversionID			INT(11),		-- Id inversion
	Par_CuentaAhoID			BIGINT(20),		-- numero de cuenta del cliente
	Par_ClienteID			BIGINT(20),		-- numero de cliente
	Par_TipoInversionID		INT(11),		-- tipo de inversion a dar de alta
	Par_FechaInicio			VARCHAR(50),	-- fecha de inicio

	Par_FechaVencimiento	VARCHAR(50),	-- fecha de vencimiento
	Par_Monto				DECIMAL(12,2),	-- monto de la inversion
	Par_Plazo				INT(11),		-- numero de dias de la inversion
	Par_Tasa				DECIMAL(12,4),	-- tasa de la inversion
	Par_TasaISR				DECIMAL(12,4),	-- tasa del isr si se cobra

	Par_TasaNeta			DECIMAL(12,4),	-- tasa neta a cobrar
	Par_InteresGenerado		DECIMAL(12,2),	-- interes que generara
	Par_InteresRecibir		DECIMAL(12,2),	-- interes que recibira la final
	Par_InteresRetener		DECIMAL(12,2),	-- interes irs si se le cobra
	Par_Reinvertir			VARCHAR(5),		-- parametro para saber si se reinvierte

	Par_MonedaID			INT(11),		-- tipo de moneda de la inversion
	Par_Etiqueta			VARCHAR(100),	-- decripcion si lleva
    Par_Beneficiario    	CHAR(1), 		-- Beneficiario, puede ser: Cuenta Socio o Propio de la inversion

    /* Parametros de auditoria*/

	Par_EmpresaID			INT(11),
	Par_UsuarioID			INT(11),
	Par_FechaActual			DATETIME,
	Par_DireccionIP			VARCHAR(15),
	Par_ProgramaID			VARCHAR(50),
	Par_Sucursal			INT(11),
	Par_NumeroTransaccion	BIGINT(20)
	)

TerminaStore: BEGIN

	/*Declaracion de variables*/

	DECLARE Var_InversionID		INT(11);			-- variable para la inversion
	DECLARE VarStatusInversion	CHAR(5);			-- estatus de la inversion
	DECLARE Var_MontoOriginal	DECIMAL(12,4);		-- variable del estatus de la inversion
	DECLARE Var_InteresOriginal	DECIMAL(12,4);		-- intereses originales de la inversion
	DECLARE Var_Estatus			CHAR(1);			-- monto original de la inversion

	DECLARE Var_Cue_Saldo		DECIMAL(12,4);		-- saldo del cliente
	DECLARE Var_CueMoneda		INT(11);			-- moneda de la inversion
	DECLARE Var_CueEstatus		CHAR(1);			-- estadtus del cliente
	DECLARE Var_CueClienteID	BIGINT(20);			-- cliente id
	DECLARE Var_MonTipoInv		INT(11);			-- variable tipo de inversion

    DECLARE Var_TasaISR			DECIMAL(12,4);		-- tasa ISR que se cobra
	DECLARE Var_PagaISR			CHAR(1);			-- si paga isr
	DECLARE Var_DiasInversion	DECIMAL(12,4);		-- dias de la inversion
	DECLARE Var_InvStatus		CHAR(1);			-- estatus de la inversion
	DECLARE	Var_FechaSucursal	DATE;				-- fecha de la sucursal

    DECLARE Var_Beneficiario	CHAR(1);			-- beneficiario
	DECLARE Par_NumErr			INT(11);			-- Numero de error
	DECLARE Par_ErrMen			CHAR(200);			-- Mensaje de error
	DECLARE Usuario				INT(11);			-- usuario
	DECLARE Cal_GATReal			DECIMAL(12,2);		-- valor del GAT generado
	DECLARE Var_ValorUMA		DECIMAL(12,4);
    DECLARE Var_TipoPersona		CHAR(1);
	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- entero cero
	DECLARE Fecha_Vacia			DATE;				-- fecha vacia
	DECLARE Factor_Porcen		DECIMAL(12,4);		-- factor de porcentaje
	DECLARE Cadena_Vacia		CHAR(1);			-- cadena vacia
	DECLARE Decimal_Cero		DECIMAL(12,4);		-- DECIMAL cero

    DECLARE Var_Inversion		INT(11);			-- inversion
	DECLARE Var_Reinversion		INT(11);			-- reinversion
	DECLARE StaAlta				CHAR(1);			-- alta sta
	DECLARE SI_PagaISR			CHAR(1);			-- SI paga Isr
	DECLARE Var_NoImpresa		CHAR(1);			-- constante no impresa

    DECLARE Var_SalMinDF		DECIMAL(12,2);		-- Salario minimo segun el df
	DECLARE Var_SalMinAn		DECIMAL(12,2);		-- Salario minimo anualizado segun el df
	DECLARE Var_MonedaBase		INT(11);			-- base moneda
	DECLARE Cal_GAT				DECIMAL(12,2);		-- gat
	DECLARE Salida_NO			CHAR(1);			-- salida NO
    DECLARE Estatus_Inactivo    CHAR(1); 			-- Estatus Inactivo


    DECLARE BeneSocio			CHAR(1);			-- socio beneficiario
	DECLARE BeneInver			CHAR(1);			-- beneficiario propio de la inversion
	DECLARE Inactivo			CHAR(1);			-- inactivo
	DECLARE MenorEdad			CHAR(1);			-- es menor de edad
	DECLARE Var_GatInfo			DECIMAL(12,2);      -- gat info
	DECLARE ValorUMA			VARCHAR(15);
	DECLARE Var_EstatusTipoInver	CHAR(2);		-- Estatus del Tipo Inversion
	DECLARE Var_Descripcion			VARCHAR(45);	-- Descripcion Tipo Inversion

	/*asignacion de constantes*/

	SET Entero_Cero				:= 0;
	SET Fecha_Vacia				:= '1900-01-01';
	SET Factor_Porcen			:= 100.00;
	SET Var_Inversion			:= 1;
	SET Var_Reinversion			:= 3;

    SET Cadena_Vacia			:= '';
	SET Decimal_Cero			:= 0;
	SET StaAlta					:= 'A';
	SET SI_PagaISR				:= 'S';
	SET Var_NoImpresa			:= 'N';

	SET Var_InversionID			:= 0;
	SET VarStatusInversion		:= '';
	SET Var_MontoOriginal		:= 0.0;
	SET Var_InteresOriginal		:= 0.0;
	SET Cal_GAT					:= 0.0;

    SET Par_NumErr				:= 0;
	SET Par_ErrMen				:= '';
	SET Usuario					:= 0;
	SET	Salida_NO				:='N';
	SET BeneSocio				:='S';

    SET BeneInver				:='I';
	SET Inactivo				:='I';
	SET Par_FechaActual			:= NOW();
	SET MenorEdad				:="S";
	SET ValorUMA				:='ValorUMABase';
    SET Estatus_Inactivo		:= 'I';

	SELECT FechaSucursal INTO Var_FechaSucursal
		FROM SUCURSALES
		WHERE SucursalID = Par_Sucursal;

	SELECT Estatus INTO Var_InvStatus
		FROM INVERSIONES
		WHERE InversionID = Par_InversionID;

	IF EXISTS (SELECT ClienteID
				FROM CLIENTES
				WHERE ClienteID = Par_ClienteID
				AND EsMenorEdad = MenorEdad)THEN
					 SELECT '021' AS NumErr,
					 'El Cliente es Menor de Edad.' AS ErrMen,
					 'clienteID' AS control,
					 0 AS consecutivo;
			LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Var_InvStatus, Cadena_Vacia)) = Cadena_Vacia THEN
		SELECT '001' AS NumErr,
			'La Inversion no Existe' AS ErrMen,
			 'inversionID' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(Var_InvStatus != StaAlta)THEN
		SELECT '002' AS NumErr,
			 'La Inversion no puede ser Modificada (Revisar su Estatus)' AS ErrMen,
			 'inversionID' AS control,
			 Par_InversionID AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF (DATEDIFF(Par_FechaInicio, Var_FechaSucursal)) != 0 THEN
		SELECT '003' AS NumErr,
			'La Inversion no es del Dia de Hoy' AS ErrMen,
			 'inversionID' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;


	IF(IFNULL(Par_CuentaAhoID, Entero_Cero)) = Entero_Cero THEN
		SELECT '004' AS NumErr,
			 'El Numero Cuenta esta vacio' AS ErrMen,
			 'cuentaAhoID' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;


	CALL SALDOSAHORROCON(Var_CueClienteID, Var_Cue_Saldo, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);

	IF(IFNULL(Var_CueEstatus, Cadena_Vacia)) != StaAlta THEN
		SELECT '005' AS NumErr,
			'La Cuenta no Existe o no Esta Activa ' AS ErrMen,
			 'cuentaAhoID' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Var_CueClienteID, Entero_Cero)) != Par_ClienteID THEN
		SELECT '006' AS NumErr,
			 'La Cuenta no pertenece al Cliente' AS ErrMen,
			 'clienteID' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Var_CueMoneda, Entero_Cero)) != Par_MonedaID THEN
		SELECT '007' AS NumErr,
			 'La Moneda no corresponde con la Cuenta' AS ErrMen,
			 'monto' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Var_Cue_Saldo, Entero_Cero)) < Par_Monto THEN
		SELECT '008' AS NumErr,
			 'Saldo Insuficiente en la Cuenta del Cliente' AS ErrMen,
			 'monto' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	SELECT Estatus, TipoPersona INTO Var_Estatus, Var_TipoPersona
		FROM CLIENTES
			WHERE ClienteID=Par_ClienteID;

	IF(Var_Estatus = Inactivo) THEN
		SELECT '001' AS NumErr,
			 'El Cliente se Encuentra Inactivo' AS ErrMen,
			 'cuentaAhoID' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	SELECT 	MonedaId,	Estatus,	Descripcion
	INTO Var_MonTipoInv, Var_EstatusTipoInver,	Var_Descripcion
	FROM  CATINVERSION
	WHERE	TipoInversionID	 = Par_TipoInversionID;

	IF(IFNULL( Var_MonTipoInv, Entero_Cero)) = Entero_Cero THEN
		SELECT '009' AS NumErr,
			 'El Tipo de Inversion no Existe' AS ErrMen,
			 'tipoInversionID' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(Var_MonTipoInv != Var_CueMoneda) THEN
		SELECT '010' AS NumErr,
			 'La Moneda de la Inversion no Corresponde con la Cuenta' AS ErrMen,
			 'tipoInversionID' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;


	IF(IFNULL( Par_FechaInicio, Fecha_Vacia)) = Fecha_Vacia THEN
		SELECT '011' AS NumErr,
			 'La Fecha de inicio esta vacia' AS ErrMen,
			 'fechaVencimiento' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL( Par_FechaVencimiento, Fecha_Vacia)) = Fecha_Vacia THEN
		SELECT '012' AS NumErr,
			 'La Fecha de Vencimiento esta vacio' AS ErrMen,
			 'fechaVencimiento' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	SET Par_Plazo	:= DATEDIFF(Par_FechaVencimiento, Par_FechaInicio);

	IF(IFNULL(Par_Plazo, Entero_Cero)) <= Entero_Cero THEN
		SELECT '013' AS NumErr,
			 'Plazo en Dias Incorrecto' AS ErrMen,
			 'plazo' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_Monto , Decimal_Cero)) = Decimal_Cero THEN
		SELECT '014' AS NumErr,
			 'El monto de inversion esta vacio' AS ErrMen,
			 'monto' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;


	/* Se consulta para saber si el cliente paga o no ISR
		y se obtiene el valor de TasaISR*/
	SELECT	Suc.TasaISR,	PagaISR
	 INTO	Var_TasaISR,	Var_PagaISR
		FROM	CLIENTES Cli,
				SUCURSALES Suc
		WHERE	Cli.ClienteID	= Par_ClienteID
		AND 	Suc.SucursalID	= Cli.SucursalOrigen;


	IF(IFNULL( Var_PagaISR, Cadena_Vacia)) = Cadena_Vacia THEN
		SELECT '015' AS NumErr,
			 'Error al Consultar si el Cliente Paga ISR' AS ErrMen,
			 'clienteID' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	SELECT 	DiasInversion, 		MonedaBaseID,	SalMinDF
	 INTO 	Var_DiasInversion, 	Var_MonedaBase,	Var_SalMinDF
		FROM PARAMETROSSIS;

	SET Var_DiasInversion	:= IFNULL(Var_DiasInversion , Entero_Cero);
	SET Var_SalMinDF 		:= IFNULL(Var_SalMinDF , Decimal_Cero);
	SET Var_TasaISR 		:= IFNULL(Var_TasaISR , Decimal_Cero);
	SET Par_Tasa 			:= ROUND(FUNCIONTASA(Par_TipoInversionID, Par_Plazo , Par_Monto),4);

	IF(IFNULL(Par_Tasa , Decimal_Cero)) = Decimal_Cero THEN
		SELECT '013' AS NumErr,
			   'No existe una Tasa para el Plazo y Monto' AS ErrMen,
			   'tasaNeta' AS control,
			   0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

    SELECT ValorParametro
			INTO Var_ValorUMA
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;


	SET Par_TasaNeta 		:= ROUND(Par_Tasa - Par_TasaISR, 4);

	SET Par_InteresGenerado := ROUND((Par_Monto * Par_Plazo * Par_Tasa) / (Factor_Porcen * Var_DiasInversion), 2);

	SET Var_SalMinAn 		:= Var_SalMinDF * 5 * Var_ValorUMA; /* Salario minimo General Anualizado*/

	/* SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
		* entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
		* si no es CERO */

	/* Si el cliente paga ISR entonces se calcula el interes a Retener , sino su valor sera cero*/
	/* Cuando sea persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exencion alguna. */
	IF (Var_PagaISR = SI_PagaISR) THEN
		IF( Par_Monto > Var_SalMinAn OR Var_TipoPersona = 'M')THEN
			IF(Var_TipoPersona = 'M')THEN
				SET Par_InteresRetener := ROUND((Par_Monto * Par_Plazo * Par_TasaISR) / (Factor_Porcen * Var_DiasInversion), 2);
			ELSE
				SET Par_InteresRetener := ROUND(((Par_Monto-Var_SalMinAn) * Par_Plazo * Par_TasaISR) / (Factor_Porcen * Var_DiasInversion), 2);
            END IF;
		ELSE
			SET Par_InteresRetener := Decimal_Cero;
		END IF;
	ELSE
		SET Par_InteresRetener := Decimal_Cero;
	END IF;

	SET Par_InteresRecibir := ROUND(Par_InteresGenerado - Par_InteresRetener, 2);

	IF(IFNULL( Par_InteresGenerado, Decimal_Cero)) = Decimal_Cero THEN
		SELECT '017' AS NumErr,
			 'El interes Generado esta vacio' AS ErrMen,
			 'interesGenerado' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_InteresRecibir ,Decimal_Cero)) = Decimal_Cero THEN
		SELECT '018' AS NumErr,
			 'El interes a recibir esta vacio' AS ErrMen,
			 'interesRecibir' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;


	IF(IFNULL( Par_UsuarioID, Entero_Cero)) = Entero_Cero THEN
		SELECT '019' AS NumErr,
			 'El Usuario no esta logeado' AS ErrMen,
			 'inversionID' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(Var_EstatusTipoInver = Estatus_Inactivo) THEN
		SELECT '020' AS NumErr,
			 CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.') AS ErrMen,
			 'inversionID' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	SET Cal_GAT := FUNCIONCALCTAGATINV(Par_FechaVencimiento,Par_FechaInicio,Par_Tasa);

	-- Calculo del GAT REAL tomando como parametro el GAT Nominal
		SET Cal_GATReal := FUNCIONCALCGATREAL(Cal_GAT,(SELECT InflacionProy AS ValorGatHis
					FROM INFLACIONACTUAL
						WHERE FechaActualizacion =
							(SELECT MAX(FechaActualizacion)
							FROM INFLACIONACTUAL)));

	SELECT Beneficiario INTO Var_Beneficiario
			FROM INVERSIONES
				WHERE InversionID= Par_InversionID;

	SET Var_Beneficiario	:= IFNULL(Var_Beneficiario, Cadena_Vacia);


	IF(Var_Beneficiario != Par_Beneficiario)THEN
		DELETE FROM BENEFICIARIOSINVER WHERE InversionID =Par_InversionID;
	END IF;

	SET Var_GatInfo := (SELECT IFNULL(TAS.GatInformativo,Entero_Cero) FROM TASASINVERSION TAS
	INNER JOIN DIASINVERSION  DIA ON DIA.TipoInversionID = TAS.TipoInversionID AND TAS.DiaInversionID =DIA.DiaInversionID
	INNER JOIN MONTOINVERSION MON ON  MON.TipoInversionID =TAS.TipoInversionID AND TAS.MontoInversionID = MON.MontoInversionID
		WHERE TAS.TipoInversionID = Par_TipoInversionID
		AND (Par_Plazo >= DIA.PlazoInferior AND Par_Plazo <= DIA.PlazoSuperior)
		AND (Par_Monto >= MON.PlazoInferior AND Par_Monto <= MON.PlazoSuperior)
		LIMIT 1);

	UPDATE INVERSIONES SET
		CuentaAhoID			= Par_CuentaAhoID,
		ClienteID 	 		= Par_ClienteID,
		TipoInversionID		= Par_TipoInversionID,
		FechaInicio 		= Par_FechaInicio,
		FechaVencimiento	= Par_FechaVencimiento,
		Monto 				= Par_Monto,

		Plazo 				= Par_Plazo,
		Tasa 				= Par_Tasa,
		TasaISR 			= Par_TasaISR,
		TasaNeta 			= Par_TasaNeta,
		InteresGenerado		= Par_InteresGenerado,

		InteresRecibir		= Par_InteresRecibir,
		InteresRetener		= Par_InteresRetener,
		Reinvertir			= Par_Reinvertir,
		MonedaID			= Par_MonedaID,
		Etiqueta			= Par_Etiqueta,

		ValorGat			= Cal_GAT,
		Beneficiario    	= Par_Beneficiario,
		ValorGatReal		= Cal_GATReal,
		GatInformativo      = Var_GatInfo,
		PlazoOriginal		= Par_Plazo,

		EmpresaID			= Par_EmpresaID,
		Usuario				= Par_UsuarioID,
		FechaActual			= Par_FechaActual,
		DireccionIP			= Par_DireccionIP,
		ProgramaID			= Par_ProgramaID,
		Sucursal			= Par_Sucursal,
		NumTransaccion		= Par_NumeroTransaccion
	WHERE InversionID		= Par_InversionID;

		-- solo aplica si hace el cambio a beneficiario cuenta socio --
		 IF(Var_Beneficiario != BeneSocio AND Par_Beneficiario = BeneSocio) THEN
			CALL BENEFICIARIOSINVERALT(
						Entero_Cero,	Par_InversionID, 	Entero_Cero,	Cadena_Vacia, 	Cadena_Vacia,
						Cadena_Vacia,	Cadena_Vacia, 	Cadena_Vacia, 	Cadena_Vacia, 	Fecha_Vacia,
						Entero_Cero,   	Entero_cero,    Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
						Cadena_Vacia,   Entero_Cero,    Cadena_Vacia,   Entero_Cero,    Cadena_Vacia,
						Fecha_Vacia,  	Fecha_Vacia	,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
						Cadena_Vacia,   Entero_Cero,    Decimal_Cero,	Par_Beneficiario,	Salida_NO,
						Par_NumErr,    	Par_ErrMen,  	Par_EmpresaID,  Par_UsuarioID,	    Par_FechaActual,
						Par_DireccionIP,Par_ProgramaID, Par_Sucursal, Par_NumeroTransaccion);
		END IF;


		SET Par_ErrMen	:= CONCAT("Inversion Modificada Exitosamente: ", CONVERT(Par_InversionID,CHAR)) ;
		IF(Par_Beneficiario = BeneInver)THEN
			IF NOT EXISTS(SELECT *
							FROM BENEFICIARIOSINVER
								WHERE InversionID = Par_InversionID)THEN
				SET Par_ErrMen	:=CONCAT("Inversion Modificada Exitosamente: ", CONVERT(Par_InversionID, CHAR), "<br>",
									"No Olvide Capturar los Beneficiarios de la Inversion.");
			END IF;
		END IF;

		SELECT '000' AS NumErr,
			Par_ErrMen AS ErrMen,
			'inversionID' AS control,
			Par_InversionID AS consecutivo;

END TerminaStore$$
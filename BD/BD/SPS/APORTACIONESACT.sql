-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONESACT`;
DELIMITER $$


CREATE PROCEDURE `APORTACIONESACT`(
# ==============================================================
# ----------- SP PARA ACTUALIZAR LOS APORTACIONES---------------
# ==============================================================
	Par_AportacionID			INT(11),				-- Numero de Aportación
	Par_ProductoSAFI			INT(11),				-- Total de Productos SAFI
	Par_PolizaID				BIGINT(20), 			-- Numero de Poliza
	Par_NumAct					TINYINT UNSIGNED,		-- Numero de actualizacion
	Par_Salida					CHAR(1),				-- Parametro de SALIDA S: SI N: No

	INOUT Par_NumErr			INT(11),				-- Parametro de SALIDA numero de error
	INOUT Par_ErrMen			VARCHAR(400),			-- Parametro de SALIDA Mensaje de error
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)

TerminaStore: BEGIN

	/*declaracion de constantes*/
	DECLARE Salida_SI 				CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero       		DECIMAL(12,2);
	DECLARE Fecha_Vacia 			DATE;
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Act_Autorizar			INT(11);
	DECLARE Act_ImprimePag			INT(11);
	DECLARE Act_AutAnclaje			INT(11);
	DECLARE Act_CancelaAport 		INT(11);
	DECLARE Act_VenAntAport			INT(11);
	DECLARE Esta_Vigente 			CHAR(1);
	DECLARE Impreso_SI				CHAR(1);
	DECLARE Mov_ApeAport			VARCHAR(4);
	DECLARE Var_ConAltaAport		INT(11);
	DECLARE Con_Capital				INT(11);
	DECLARE Nat_Cargo				CHAR(1);
	DECLARE Nat_Abono				CHAR(1);
	DECLARE AltPoliza_NO			CHAR(1);
	DECLARE Mov_AhorroSI			CHAR(1);
	DECLARE Salida_No				CHAR(1);
	DECLARE Est_Inactivo			CHAR(1);
	DECLARE Var_ConAportCapi		INT(11);
	DECLARE Estatus_Cancel			CHAR(1);
	DECLARE Esta_Alta 				CHAR(1);
	DECLARE Mov_CanAport 			VARCHAR(4);
	DECLARE Var_ConCanAport			VARCHAR(4); 	-- Concepto Cancelacion ap
	DECLARE Var_Reversa 			INT(11);
	DECLARE SabDom					CHAR(2);		-- Dia Inhabil: Sabado y Domingo
	DECLARE No_DiaHabil				CHAR(1); 		-- No es dia habil
	DECLARE Var_TipoAjuste      	INT(11);
	DECLARE NoCliEsp		 		INT;
	DECLARE CliProcEspecifico 		VARCHAR(20);
    DECLARE Cons_AperturaFA			CHAR(2);
    DECLARE Esta_Autorizada			CHAR(1);
    DECLARE Per_Moral				CHAR(1);		-- Persona Moral
    DECLARE Per_Fisica				CHAR(1);		-- Persona Física
    DECLARE Per_Emp					CHAR(1);		-- Persona Física Act. Empresarial
	DECLARE Cons_Si					CHAR(1); 		-- Constante SI
    DECLARE Cons_No					CHAR(1); 		-- Constante NO
    

	-- Declaracion de Variables --
	DECLARE Var_Monto 				DECIMAL(16,2);
	DECLARE Var_Cuenta				BIGINT(12);
	DECLARE Var_Estatus				CHAR(2);
	DECLARE Var_EstatusImp			CHAR(1);
	DECLARE Var_EstatusCli			CHAR(1);
	DECLARE Var_Moneda				INT(11);
	DECLARE Var_IntRetener			DECIMAL(16,2);
	DECLARE Var_SalProvision		DECIMAL(16,2);
	DECLARE Var_InteresGen			DECIMAL(16,2);
	DECLARE Var_FechaSucursal		DATE;
	DECLARE varControl 				CHAR(15);		-- almacena el elemento que es incorrecto --
	DECLARE Var_FechaAutoriza		DATE;			-- fecha en que autoriza
	DECLARE	Var_TipoAportacionID	INT(11);		-- Almacena el Tipo de APORTACION
	DECLARE Var_DiaInhabil			CHAR(2);		-- Almacena el Dia Inhabil
	DECLARE Var_FecSal				DATE;			-- Almacena la Fecha de Salida
	DECLARE Var_EsHabil				CHAR(1);		-- Almacena si el dia es habil o no
	DECLARE VarPerfilAports			INT(1);
	DECLARE VarValTasasAports		INT(1);
	DECLARE Var_NumTotAport			INT(11);
	DECLARE Var_AportMadre			INT(11);
	DECLARE Var_TasaMejorada		CHAR(1);
	DECLARE	TasaMejoradaSI			CHAR(1);
	DECLARE Var_AportAnclaje 		INT(11);
	DECLARE Var_MaxAnclMadre 		INT(11);
	DECLARE Var_EsAportMadre 		INT(11);
	DECLARE Var_MaxAnclaje		 	INT(11);
	DECLARE Var_Tasa            	DECIMAL(12,2);
	DECLARE Var_ClienteID      		INT(11);
	DECLARE Var_AportMadreID		INT(11);
	DECLARE Var_AportAmor            INT(11);
	DECLARE Var_FechaInicio			DATE;				-- Fecha de Inicio del calendario a simular
	DECLARE	Var_FechaVencimiento	DATE;				-- Fecha de Vencimiento del calendario a simular
	DECLARE	Var_TasaFija			DECIMAL(18,4);		-- Valor de Tasa Fija
	DECLARE Var_TipoPagoInt			CHAR(1);			-- Indica si es a FIN DE MES (F) o al VENCIMIENTO (V) o por PERIODO(P)
	DECLARE Var_DiasPeriodo			INT(11);			-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	DECLARE Var_PagoIntCal			CHAR(2);			-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
	DECLARE Var_CliProEsp			INT;
    DECLARE Var_DiaPago				INT(11);			-- Especifica el dia de pago para aportaciones con tipo de pago programado
    DECLARE Var_Capitaliza			CHAR(1);			-- Indica si se capitaliza interes. S:si / N:no / I:indistinto
    DECLARE Var_PlazoOriginal		INT(11);			-- Guarda el plazo original de la aportacion
    DECLARE Var_AperturaAport		CHAR(2);			-- Apertura de la aportacion FA:Fecha Actual / FP: Fecha Posterior
	DECLARE Var_TipoPersona			CHAR(1);			-- Tipo de Persona
    DECLARE Var_RFCOficial			CHAR(13);			-- RFC de la Persona
    DECLARE Var_DetecNoDeseada		CHAR(1);			-- Valida si el proceso de Persona No deseadas se encuentra activado


	-- ASIGNACION DE CONSTANTES
	SET Salida_SI					:= 'S';				-- Constante Si --
	SET Entero_Cero 				:= 0;				-- Constante Cero --
	SET Decimal_Cero        		:= 0.0;             -- Valor DECIMAL Cero
	SET Fecha_Vacia					:= '1900-01-01';	-- Constante Fecha Vacia --
	SET Cadena_Vacia				:= '';				-- Constante Cadena Vacia --
	SET Act_Autorizar				:= 3;				-- Actualizacion Autoriza --
	SET Act_ImprimePag				:= 4;				-- Actualizacion Estatus Impresion Pagare --
	SET	Act_AutAnclaje				:= 5;				-- Autoriza Anclaje
	SET Act_CancelaAport 			:= 10;				-- CANCELACION DE APORTACIONES
	SET Act_VenAntAport      		:= 11;              -- VENCIMIENTO ANTICIPADO DE APORTACIONES
	SET Esta_Vigente 				:= 'N';				-- Estatus Vigente --
	SET Impreso_SI					:='I';				-- Fue impreso Si --
	SET Mov_ApeAport				:= '601'; 			-- APERTURA DE APORTACION TABLA DE TIPOSMOVSAHO
	SET Var_ConAltaAport			:= 900; 			-- Constante Mov Aports
	SET Con_Capital 				:= 1; 				-- Tabla conceptos ap
	SET Nat_Cargo 					:= 'C'; 			-- naturaleza cargo
	SET Nat_Abono 					:= 'A'; 			-- naturaleza abono
	SET AltPoliza_NO				:= 'N'; 			-- alta de de poliza no
	SET Mov_AhorroSI				:= 'S'; 			-- movimiento de ahorro si
	SET Salida_No					:= 'N'; 			-- salida no
	SET Est_Inactivo				:= 'I'; 			-- estatus inactivo
	SET Var_ConAportCapi			:= 1;				-- CONCEPTOSAHORRO
	SET Estatus_Cancel 				:= 'C';
	SET VarPerfilAports				:= 3;				-- Num Validacion
	SET VarValTasasAports			:= 5;				-- Num Validacion
	SET TasaMejoradaSI				:= 'S';
	SET Esta_Alta 					:= 'A';
	SET Mov_CanAport	 			:= '608'; 			-- Movimiento de ahorro CANCELACION APORTACIÓN.
	SET Var_ConCanAport 			:= 910; 			-- Concepto contable Cancelacion.
	SET Var_Reversa					:= 2;
	SET SabDom						:= 'SD';			-- Dia Inhabil: Sabado y Domingo
	SET No_DiaHabil					:= 'N';				-- No es dia habil
	SET Var_TipoAjuste				:= 1;
	SET Aud_FechaActual 			:= NOW();
	SET NoCliEsp					:=24;				-- Cliente CrediClub
	SET CliProcEspecifico			:='CliProcEspecifico';
    SET Cons_AperturaFA				:= 'FA';			-- Apertura de la aportacion, fecha actual
    SET	Esta_Autorizada				:= 'L';				-- Constante para estatus autorizado.
	SET Per_Moral					:= 'M';
	SET Per_Fisica					:= 'F';
	SET Per_Emp					:= 'A';
    SET Cons_No						:= 'N';
    SET Cons_Si						:= 'S';

	SELECT FechaSistema
		INTO Var_FechaAutoriza
			FROM PARAMETROSSIS;
	SET Var_FechaAutoriza :=IFNULL(Var_FechaAutoriza,Fecha_Vacia);

	SELECT FechaSucursal INTO Var_FechaSucursal
		FROM SUCURSALES
		WHERE SucursalID = Aud_Sucursal;


	ManejoErrores:BEGIN 	#bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:=	999;
				SET Par_ErrMen	:=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: APORTACIONESACT');
			END;

		SELECT ValorParametro INTO Var_CliProEsp
			FROM PARAMGENERALES
			WHERE LlaveParametro= CliProcEspecifico;

		IF(IFNULL(Par_AportacionID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 01;
			SET Par_ErrMen := 'El Numero de Aportacion esta Vacio.';
			SET varControl := 'aportacionID' ;
			LEAVE ManejoErrores;
		END IF;

		/* SE VALIDA QUE SE TENGA UN VALOR PARA EL USUARIO QUE LANZA EL PROCESO, EXCEPTO PARA EL QUE IMPRIME EL PAGARE*/
		IF(IFNULL( Aud_Usuario, Entero_Cero) = Entero_Cero AND Par_NumAct != Act_ImprimePag)THEN
			SET Par_NumErr	:= 03;
			SET Par_ErrMen	:= 'El Usuario no esta logueado.';
			SET varControl	:= 'aportacionID';
			LEAVE ManejoErrores;
		END IF;

		/* SE OBTIENEN VALORES A UTILIZAR */
		SELECT	CuentaAhoID,		Monto,      		Estatus,        	FechaInicio,		FechaVencimiento,
				EstatusImpresion,	TasaFija,			TipoPagoInt,		ClienteID,			MonedaID,
				InteresRetener,		SaldoProvision,		InteresGenerado,	TipoAportacionID,	DiasPeriodo,
				PagoIntCal,			DiasPago,			PagoIntCapitaliza,	PlazoOriginal
			INTO
				Var_Cuenta,  		Var_Monto,  		Var_Estatus,    	Var_FechaInicio,	Var_FechaVencimiento,
				Var_EstatusImp,		Var_TasaFija,		Var_TipoPagoInt,	Var_ClienteID,		Var_Moneda,
				Var_IntRetener,		Var_SalProvision,	Var_InteresGen,		Var_TipoAportacionID,Var_DiasPeriodo,
				Var_PagoIntCal,		Var_DiaPago,		Var_Capitaliza,		Var_PlazoOriginal
			FROM 	APORTACIONES
			WHERE 	AportacionID	= Par_AportacionID;

		/* SE OBTIENE EL ESTATUS DEL CLIENTE RELACIONADO A LA APORTACIÓN */
		SELECT Cli.Estatus INTO Var_EstatusCli
			FROM	CLIENTES Cli
			WHERE 	ClienteID	= Var_ClienteID;

		SELECT DiaInhabil INTO Var_DiaInhabil FROM TIPOSAPORTACIONES WHERE TipoAportacionID = Var_TipoAportacionID;

		IF(Var_EstatusCli = Est_Inactivo) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El safilocale.cliente se Encuentra Inactivo.';
			SET varControl := 'inversionID';
			LEAVE ManejoErrores;
		END IF;

		/*VALIDA QUE EL EVENTO SE ESTE REALIZANDO EN UN DIA HABIL Y QUE NO SE TRATE DE LA IMPRESION DEL PAGARE*/
		IF(Var_DiaInhabil = SabDom  AND Par_NumAct != Act_ImprimePag )THEN
			CALL DIASFESTIVOSABDOMCAL(
				Var_FechaAutoriza,	Entero_Cero, 		Var_FecSal, 		Var_EsHabil,		Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion	);

			IF(Var_EsHabil = No_DiaHabil)THEN
				SET Par_NumErr	:=	06;
				SET Par_ErrMen	:=	CONCAT('El Tipo de Aportacion ', Par_TipoAportacionID,' Tiene Parametrizado Dia Inhabil: Sabado y Domingo ',
									'por tal Motivo No se Puede Registrar la Aportacion .');
				LEAVE ManejoErrores;
			END IF;
		END IF;
        
       
        -- SE OBTIENE LA APERTURA DE LA APORTACION
        SET Var_AperturaAport := (SELECT AperturaAport FROM APORTACIONES WHERE AportacionID=Par_AportacionID);
		SET Var_AperturaAport := IFNULL(Var_AperturaAport,Cons_AperturaFA);

		/* *************************************************************************************************************
		******************************** A U T O R I Z A **** A P O R T A C I O N E S **************************************************
		************************************************************************************************************* */
		IF(Par_NumAct = Act_Autorizar)THEN
		-- INICIO VALIDACIÓN DE PERSONAS NO DESEADAS
		SET Var_DetecNoDeseada := IFNULL((SELECT  PersonNoDeseadas FROM PARAMETROSSIS LIMIT 1),Cons_No);
        IF(Var_DetecNoDeseada = Cons_Si) THEN
        	SELECT	Cli.TipoPersona
			INTO	Var_TipoPersona
			FROM	CLIENTES Cli,
					SUCURSALES Suc
			WHERE 	Cli.ClienteID 	= Var_ClienteID
            AND		Suc.SucursalID 	= Cli.SucursalOrigen;
        
        IF(Var_TipoPersona = Per_Moral) THEN 
			SELECT 	Cli.RFCpm
			INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
			WHERE 	Cli.ClienteID 	= Var_ClienteID
			AND		Suc.SucursalID 	= Cli.SucursalOrigen;
        END IF;
        
        IF(Var_TipoPersona = Per_Fisica OR Var_TipoPersona = Per_Emp ) THEN 
			SELECT 	Cli.RFC
			INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
			WHERE 	Cli.ClienteID 	= Var_ClienteID
			AND		Suc.SucursalID 	= Cli.SucursalOrigen;
        END IF;
        
          CALL PLDDETECPERSNODESEADASPRO(
				Var_ClienteID,	Var_RFCOficial,	Var_TipoPersona,	Salida_No,	Par_NumErr,					
                Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,	Aud_FechaActual,	
                Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr			:= 050;
				SET Par_ErrMen			:= Par_ErrMen;	
				LEAVE ManejoErrores;
			END IF;
		 END IF;
        
        -- FIN VALIDACIÓN DE PERSONAS NO DESEADAS

            /*SE MANDA A LLAMAR AL SP PARA QUE GENERE LAS AMORTIZACIONES DE LA APORTACIÓN */
			CALL APORTAMORTIZAPRO(
				Par_AportacionID,		Var_FechaInicio,	Var_FechaVencimiento,	Var_Monto,			Var_ClienteID,
				Var_TipoAportacionID,	Var_TasaFija,		Var_TipoPagoInt,		Var_DiasPeriodo,	Var_PagoIntCal,
				Var_DiaPago,			Var_PlazoOriginal,	Var_Capitaliza, 		Salida_NO,			Par_NumErr,
                Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,   		Aud_Sucursal,    	Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
			/*FIN DE LLAMADO AL SP QUE GENERA LAS AMORTIZACIONES*/

			SELECT COUNT(AportacionID) INTO Var_NumTotAport
				FROM 	AMORTIZAAPORT
				WHERE	AportacionID	= Par_AportacionID;

			IF(Var_NumTotAport=Entero_Cero)THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'No se pudo Autorizar la Aportacion porque no se generaron las cuotas.';
				SET varControl := 'aportacionID';
				LEAVE ManejoErrores;
			END IF;

			IF (DATEDIFF(Var_FechaInicio, Var_FechaSucursal)) != Entero_Cero AND Var_AperturaAport = Cons_AperturaFA THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := ' La Aportacion no es del Dia de Hoy.';
				SET varControl := 'aportacionID';
				LEAVE ManejoErrores;
			END IF;

			/*Validacion de Tasas de Ahorro */
			CALL VALIDATASASPRODUCTOS (
				Var_ClienteID,		Var_TipoAportacionID,	Par_ProductoSAFI,	Aud_Sucursal,		VarValTasasAports,
				Salida_No,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual, 	Aud_DireccionIP,		Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				SET varControl	:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;

			-- si la aportacion tiene como apertura fecha actual se hacen las afectaciones contables
			IF (Var_AperturaAport = Cons_AperturaFA)THEN
					/* SE MANDA A LLAMAR EL SP QUE REALIZA LAS AFECTACIONES CONTABLES */
					CALL CONTAAPORTPRO(
						Par_AportacionID,	Par_EmpresaID,		Var_FechaSucursal,		Var_Monto,			Mov_ApeAport,
						Var_ConAltaAport,	Var_ConAportCapi,	Con_Capital,			Nat_Cargo,			AltPoliza_NO,
						Mov_AhorroSI,		Salida_No,			Par_PolizaID,			Par_NumErr,			Par_ErrMen,
						Var_Cuenta,			Var_ClienteID,		Var_Moneda,				Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


				 UPDATE APORTACIONES SET
						Estatus 		= Esta_Vigente,
						FechaApertura	= Var_FechaAutoriza,
						SucursalID		= Aud_Sucursal,
						UsuarioID 		= Aud_Usuario,

						EmpresaID 		= Par_EmpresaID,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
				 WHERE	AportacionID			= Par_AportacionID;
			ELSE
					-- actualiza el estatus de la aportacion a autorizada
					UPDATE APORTACIONES SET
							Estatus 		= Esta_Autorizada,
                            FechaApertura	= Var_FechaInicio,
							UsuarioID 		= Aud_Usuario,

							EmpresaID 		= Par_EmpresaID,
							FechaActual		= Aud_FechaActual,
							DireccionIP		= Aud_DireccionIP,
							ProgramaID		= Aud_ProgramaID,
							Sucursal		= Aud_Sucursal,
							NumTransaccion	= Aud_NumTransaccion
					 WHERE	AportacionID	= Par_AportacionID;

					 -- actualiza el estatus de las amortizaciones a autorizada
					 UPDATE AMORTIZAAPORT SET
							Estatus 		= Esta_Autorizada,
							Usuario 		= Aud_Usuario,

							EmpresaID 		= Par_EmpresaID,
							FechaActual		= Aud_FechaActual,
							DireccionIP		= Aud_DireccionIP,
							ProgramaID		= Aud_ProgramaID,
							Sucursal		= Aud_Sucursal,
							NumTransaccion	= Aud_NumTransaccion
					 WHERE	AportacionID	= Par_AportacionID;

					-- elimina poliza generada desde java, ya que para estas aportaciones
                    -- se generan los movimientos durante el cierre
                    DELETE FROM POLIZACONTABLE
						WHERE	PolizaID	= Par_PolizaID;
			END IF; -- Fin validacion apertura aportacion

			SET Par_NumErr := '000';
			SET Par_ErrMen := CONCAT('Aportacion Autorizada Exitosamente: ',Par_AportacionID,'.');
			SET varControl := 'imprime' ;

		END IF;-- FIN AUTORIZACION DE LA APORTACIÓN.



		/* *************************************************************************************************************
		******************************** A U T O R I Z A *** A N C L A J E *** A P O R T A C I O N E S *********************************
		************************************************************************************************************* */
		IF(Par_NumAct = Act_AutAnclaje)THEN

			/*SE MANDA A LLAMAR AL SP PARA QUE GENERE LAS AMORTIZACIONES DE LA APORTACIÓN */
			CALL APORTAMORTIZAPRO(
				Par_AportacionID,		Var_FechaInicio,	Var_FechaVencimiento,	Var_Monto,			Var_ClienteID,
				Var_TipoAportacionID,	Var_TasaFija,		Var_TipoPagoInt,		Var_DiasPeriodo,	Var_PagoIntCal,
				Var_DiaPago,			Var_PlazoOriginal,	Var_Capitaliza,			Salida_NO,			Par_NumErr,
                Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,   		Aud_Sucursal,    	Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF (DATEDIFF(Var_FechaInicio, Var_FechaSucursal)) != 0 THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := ' La Aportacion no es del Dia de Hoy.';
				SET varControl := 'aportacionID';
				LEAVE ManejoErrores;
			END IF;

			/*Validacion de Tasas de Ahorro */
			CALL VALIDATASASPRODUCTOS (
				Var_ClienteID,		Var_TipoAportacionID,	Par_ProductoSAFI,	Aud_Sucursal,		VarValTasasAports,
				Salida_No,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual, 	Aud_DireccionIP,		Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				SET varControl	:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;

			/* SE MANDA A LLAMAR EL SP QUE REALIZA LAS AFECTACIONES CONTABLES */
			CALL CONTAAPORTPRO(
				Par_AportacionID,	Par_EmpresaID,		Var_FechaSucursal,		Var_Monto,			Mov_ApeAport,
				Var_ConAltaAport,	Var_ConAportCapi,	Con_Capital,			Nat_Cargo,			AltPoliza_NO,
				Mov_AhorroSI,		Salida_No,			Par_PolizaID,			Par_NumErr,			Par_ErrMen,
				Var_Cuenta,			Var_ClienteID,		Var_Moneda,				Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


			SELECT 		ap.AportacionOriID,		cat.TasaMejorada
				INTO	Var_AportMadre,		Var_TasaMejorada
				FROM 	APORTANCLAJE ap
						INNER JOIN APORTACIONES ap1 ON ap.AportacionOriID = ap1.AportacionID
						INNER JOIN TIPOSAPORTACIONES cat ON ap1.TipoAportacionID = cat.TipoAportacionID
				WHERE 	ap.AportacionAncID	= Par_AportacionID;

			SET Var_AportMadre	:=	IFNULL(Var_AportMadre,Entero_Cero);

			IF (Var_AportMadre > Entero_Cero AND Var_TasaMejorada = TasaMejoradaSI) THEN
				CALL APORTAJUSTEPRO(
					Par_AportacionID,	Var_TipoAjuste,	Salida_NO,			Par_NumErr,			Par_ErrMen,
					Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

			UPDATE APORTACIONES SET
					Estatus 		= Esta_Vigente,
					FechaApertura	= Var_FechaAutoriza,
					SucursalID		= Aud_Sucursal,
					UsuarioID 		= Aud_Usuario,

					EmpresaID 		= Par_EmpresaID,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion 	= Aud_NumTransaccion
			WHERE	AportacionID	= Par_AportacionID;

			SET Par_NumErr := '000';
			SET Par_ErrMen := CONCAT('Aportacion Autorizada Exitosamente: ',Par_AportacionID,'.');
			SET varControl := 'imprime' ;

		END IF;-- FIN AUTORIZACION DE LA APORTACIÓN.


		/* *************************************************************************************************************
		******************************** I M P R I M E *** P A G A R E *************************************************
		************************************************************************************************************* */
		IF(Par_NumAct = Act_ImprimePag) THEN
			UPDATE APORTACIONES SET
					EstatusImpresion	= Impreso_SI,
					FechaActual 		= Aud_FechaActual
			WHERE	AportacionID 				= Par_AportacionID;

			SET Par_NumErr := 000;
			SET Par_ErrMen := 'Pagare Impreso Exitosamente.';
			SET varControl := 'aportacionID';
		END IF;


		/* *************************************************************************************************************
		**************** C A N C E L A C I O N *** D E *** A P O R T A C I O N E S *** M I S M O *** D I A *****************************
		************************************************************************************************************* */
		-- CANCELACION DE APORTACIONES
		IF(Par_NumAct = Act_CancelaAport)THEN
			-- Validaciones antes de cancelar
			IF (Var_Estatus != Esta_Vigente AND Var_Estatus != Esta_Alta  AND Var_Estatus != Esta_Autorizada) THEN
				SET Par_NumErr := 01;
				SET Par_ErrMen := ' La Aportacion no puede ser Cancelada (Revisar Estatus).';
				SET varControl := 'aportacionID';
				LEAVE ManejoErrores;
			END IF;

			IF (DATEDIFF(Var_FechaSucursal,Var_FechaInicio)) != Entero_Cero AND Var_AperturaAport = Cons_AperturaFA THEN
				SET Par_NumErr := 02;
				SET Par_ErrMen := ' La Aportacion no es del Dia de Hoy.';
				SET varControl := 'aportacionID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL( Aud_Usuario, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 03;
				SET Par_ErrMen := 'El Usuario no esta logueado.';
				SET varControl := 'aportacionID';
				LEAVE ManejoErrores;
			END IF;

			-- Se consulta si es un ap Madre
			SET Var_EsAportMadre := (SELECT AportacionOriID
										FROM 	APORTANCLAJE
										WHERE 	AportacionOriID	= Par_AportacionID
										GROUP BY AportacionOriID);
			SET Var_EsAportMadre :=	IFNULL(Var_EsAportMadre,Entero_Cero);

			-- Se consulta si es un ANCLAJE
			SET Var_AportAnclaje := (SELECT AportacionOriID
										FROM 	APORTANCLAJE
										WHERE 	AportacionAncID	= Par_AportacionID
										GROUP BY AportacionOriID);
			SET Var_AportAnclaje :=	IFNULL(Var_AportAnclaje,Entero_Cero);


			-- Se obtiene el ultimo ap anclado de una ap madre
			SET Var_MaxAnclMadre :=	(SELECT 	MAX(CD.AportacionID)
										FROM 	APORTANCLAJE AN
												INNER JOIN APORTACIONES CD ON AN.AportacionOriID = CD.AportacionID
												OR AN.AportacionAncID = CD.AportacionID
										WHERE 	AportacionOriID 	= Var_EsAportMadre
										AND 	Estatus 	!= Estatus_Cancel);
			SET Var_MaxAnclMadre 	:=	IFNULL(Var_MaxAnclMadre,Entero_Cero);


			-- Se obtiene el ultimo ap anclado de una ap ANCLAJE
			SET Var_MaxAnclaje :=	(SELECT 	MAX(CD.AportacionID)
										FROM 	APORTANCLAJE AN
												INNER JOIN APORTACIONES CD ON AN.AportacionOriID = CD.AportacionID
												OR AN.AportacionAncID = CD.AportacionID
										WHERE 	AportacionOriID 	= Var_AportAnclaje
										AND 	Estatus 	!= Estatus_Cancel);
			SET Var_MaxAnclaje 	:=	IFNULL(Var_MaxAnclaje,Entero_Cero);


			-- se valida si el ap tiene anclajes que sea el ultimo
			IF (Var_MaxAnclaje != Entero_Cero) THEN
				IF (Par_AportacionID != Var_MaxAnclaje) THEN
					SET Par_NumErr := 04;
					SET Par_ErrMen := ' La Aportacion tiene Anclajes, no se puede Cancelar.';
					SET varControl := 'aportacionID';
					LEAVE ManejoErrores;
				END IF;
			END IF;


			-- se valida si el ap madre tiene anclajes que sea el ultimo
			IF (Var_MaxAnclMadre != Entero_Cero) THEN
				IF (Par_AportacionID != Var_MaxAnclMadre) THEN
					SET Par_NumErr := 05;
					SET Par_ErrMen := ' La Aportacion tiene Anclajes, no se puede Cancelar.';
					SET varControl := 'aportacionID';
					LEAVE ManejoErrores;
				END IF;
			END IF;



			-- Se realiza la afectacion contable si el ap es vigente (reversa)
			IF(Var_Estatus = Esta_Vigente) THEN

				CALL CONTAAPORTPRO(
					Par_AportacionID,	Par_EmpresaID,		Var_FechaSucursal,	Var_Monto,		Mov_CanAport,
					Var_ConCanAport,	Var_ConAportCapi,	Con_Capital,		Nat_Abono,		AltPoliza_NO,
					Mov_AhorroSI,		Salida_NO,			Par_PolizaID,		Par_NumErr,		Par_ErrMen,
					Var_Cuenta,			Var_ClienteID,		Var_Moneda,			Aud_Usuario,	Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

			-- Si el ap es vigente y es un anclaje se realiza la reversa para tomar los valores anteriores de la tasa
			IF(Var_Estatus = Esta_Vigente) THEN
				IF(Var_AportAnclaje > Entero_Cero)THEN

					CALL APORTAJUSTEPRO(
						Par_AportacionID,	Var_Reversa,		Salida_NO,			Par_NumErr,		Par_ErrMen,
						Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);

					 IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					 END IF;

				END IF;
			END IF;

			-- Se actualiza el ap a estatus cancelado y la fecha de cancelacion
			UPDATE APORTACIONES SET
					Estatus 		= Estatus_Cancel,
					FechaCancela 	= Var_FechaAutoriza,
					EmpresaID 		= Par_EmpresaID,
					UsuarioID 		= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID 		= Aud_ProgramaID,
					Sucursal 		= Aud_Sucursal,
					NumTransaccion 	= Aud_NumTransaccion
			WHERE 	AportacionID 			= Par_AportacionID;

			-- Se actualiza la amortizacion del ap a estatus cancelado
			UPDATE AMORTIZAAPORT SET
					Estatus 		= Estatus_Cancel,
					EmpresaID 		= Par_EmpresaID,
					Usuario 		= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID 		= Aud_ProgramaID,
					Sucursal 		= Aud_Sucursal,
					NumTransaccion 	= Aud_NumTransaccion
			WHERE 	AportacionID 	= Par_AportacionID;


			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('Aportacion Cancelada Exitosamente: ',Par_AportacionID,'.');
			SET varControl	:= 'aportacionID';

		END IF; -- FIN DE CANCELACION DE APORTACIONES



		/* *************************************************************************************************************
		**************** V E N C I M I E N T O  *** A N T I C I P A D O ************************************************
		************************************************************************************************************* */
		-- VENCIMIENTO ANTICIPADO DE DE APORTACIONES
		IF(Par_NumAct = Act_VenAntAport)THEN

			-- Validaciones antes de cancelar
			IF (Var_Estatus != Esta_Vigente) THEN
				SET Par_NumErr := 01;
				SET Par_ErrMen := 'La Aportacion no puede ser Cancelada (Revisar Estatus).';
				SET varControl := 'aportacionID';
				LEAVE ManejoErrores;
			END IF;

			IF (DATEDIFF(Var_FechaSucursal,Var_FechaInicio)) = Entero_Cero THEN
				SET Par_NumErr := 02;
				SET Par_ErrMen := ' La Aportacion es del dia de hoy, utilice la pantalla de Cancelacion.';
				SET varControl := 'aportacionID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_AportAmor :=	(SELECT AportacionID
									FROM 	AMORTIZAAPORT
									WHERE 	AportacionID = Par_AportacionID
									GROUP BY AportacionID);

			IF(IFNULL(Var_AportAmor, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 04;
				SET Par_ErrMen := 'No existen Amortizaciones para la Aportacion Indicada.';
				SET varControl := 'aportacionID';
				LEAVE ManejoErrores;
			END IF;

		-- Se obtiene el ap madre
			SET Var_AportMadreID :=	(SELECT AportacionOriID
										FROM 	APORTANCLAJE
										WHERE 	AportacionAncID = Par_AportacionID);

			SET Var_AportMadreID := IFNULL(Var_AportMadreID, Par_AportacionID);

			DELETE FROM TMPVENCANTAPORT WHERE NumTransaccion = Aud_NumTransaccion;
		-- Inserta el ap madre a la tabla temporal
			INSERT INTO TMPVENCANTAPORT(
					AportacionID,	CuentaAhoID, 		TipoAportacionID, 	MonedaID, 		ClienteID,
					SaldoProvision, FechaVencimiento, 	CalculoInteres, 	Estatus,		Reinversion,
					Monto,			PagoIntCapitaliza,	EmpresaID, 			UsuarioID,		FechaActual,	DireccionIP,
					ProgramaID,		Sucursal,			NumTransaccion)
			SELECT 	AportacionID,	CuentaAhoID, 		TipoAportacionID, 	MonedaID, 		ClienteID,
					SaldoProvision, FechaVencimiento, 	CalculoInteres,		Estatus,		Reinversion,
					Monto,			PagoIntCapitaliza,	EmpresaID, 			UsuarioID,		FechaActual,	DireccionIP,
					ProgramaID,		Sucursal,			Aud_NumTransaccion
				FROM 	APORTACIONES
				WHERE 	AportacionID = Var_AportMadreID;

		-- Inserta los anclajes a la tabla temporal

			INSERT INTO TMPVENCANTAPORT(
					AportacionID,		CuentaAhoID, 			TipoAportacionID,	MonedaID, 		ClienteID,
					SaldoProvision, 	FechaVencimiento, 		CalculoInteres, 	Estatus,		Reinversion,
					Monto,				PagoIntCapitaliza,		EmpresaID, 			UsuarioID,		FechaActual,
					DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion)
			SELECT 	CD.AportacionID,	CD.CuentaAhoID, 		CD.TipoAportacionID,CD.MonedaID, 	CD.ClienteID,
					CD.SaldoProvision, 	CD.FechaVencimiento, 	CD.CalculoInteres, 	CD.Estatus,		CD.Reinversion,
					CD.Monto,			CD.PagoIntCapitaliza,	CD.EmpresaID, 		CD.UsuarioID,	CD.FechaActual,
					CD.DireccionIP,		CD.ProgramaID,			CD.Sucursal,		Aud_NumTransaccion
				FROM 	APORTACIONES CD
						INNER JOIN APORTANCLAJE AN ON CD.AportacionID = AN.AportacionAncID AND CD.Estatus = Esta_Vigente
				WHERE 	AN.AportacionOriID 	= Var_AportMadreID;

			CALL APORTPAGOVENANTPRO (
				Var_AportMadreID, 	Var_ClienteID,		Var_FechaSucursal,	Par_PolizaID,		Salida_NO,
				Par_NumErr,			Par_ErrMen,			Par_EmpresaID, 		Aud_Usuario, 		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('Aportacion Cancelada Exitosamente.');
			SET varControl := 'aportacionID';

		END IF; -- FIN DE VENCIMIENTO ANTICIPADO DE APORTACIONES


	END ManejoErrores; # fin del manejador de errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				varControl	AS control,
				Par_AportacionID	AS consecutivo;
	END IF;
END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESACT`;
DELIMITER $$


CREATE PROCEDURE `CEDESACT`(
# ==============================================================
# ----------------- SP PARA ACTUALIZAR LOS CEDES----------------
# ==============================================================
	Par_CedeID					INT(11),				-- Numero de CEDE
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
	DECLARE Act_CancelaCede 		INT(11);
	DECLARE Act_VenAntCede     		INT(11);
	DECLARE Esta_Vigente 			CHAR(1);
	DECLARE Impreso_SI				CHAR(1);
	DECLARE Mov_ApeCede				VARCHAR(4);
	DECLARE Var_ConAltCed 			INT(11);
	DECLARE Con_Capital				INT(11);
	DECLARE Nat_Cargo				CHAR(1);
	DECLARE Nat_Abono				CHAR(1);
	DECLARE AltPoliza_NO			CHAR(1);
	DECLARE Mov_AhorroSI			CHAR(1);
    DECLARE Salida_No				CHAR(1);
	DECLARE Est_Inactivo			CHAR(1);
	DECLARE Var_ConCedeCapi			INT(11);
	DECLARE Estatus_Cancel			CHAR(1);
	DECLARE Esta_Alta 				CHAR(1);
	DECLARE Mov_CanCEDE 			VARCHAR(4);
	DECLARE Var_ConCanCEDE 			VARCHAR(4); 	-- Concepto Cancelacion cede
	DECLARE Var_Reversa 			INT(11);
	DECLARE SabDom					CHAR(2);		-- Dia Inhabil: Sabado y Domingo
	DECLARE No_DiaHabil				CHAR(1); 		-- No es dia habil
	DECLARE Var_TipoAjuste      	INT(11);
    DECLARE NoCliEsp		 		INT;
    DECLARE CliProcEspecifico 		VARCHAR(20);
	DECLARE Per_Moral				CHAR(1);
    DECLARE Per_Fisica				CHAR(1);
    DECLARE Per_Empre				CHAR(1);
    DECLARE Cons_No					CHAR(1);		-- Constante Si
    DECLARE	Cons_Si					CHAR(1);		-- Constante No

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
	DECLARE	Var_TipoCedeID			INT(11);		-- Almacena el Tipo de CEDE
	DECLARE Var_DiaInhabil			CHAR(2);		-- Almacena el Dia Inhabil
	DECLARE Var_FecSal				DATE;			-- Almacena la Fecha de Salida
	DECLARE Var_EsHabil				CHAR(1);		-- Almacena si el dia es habil o no
	DECLARE VarPerfilCedes			INT(1);
	DECLARE VarValTasasCedes		INT(1);
	DECLARE Var_NumTotCede			INT(11);
	DECLARE Var_CedeMadre			INT(11);
	DECLARE Var_TasaMejorada		CHAR(1);
	DECLARE	TasaMejoradaSI			CHAR(1);
	DECLARE Var_CedeAnclaje 		INT(11);
	DECLARE Var_MaxAnclMadre 		INT(11);
	DECLARE Var_EsCedeMadre 		INT(11);
	DECLARE Var_MaxAnclaje		 	INT(11);
	DECLARE Var_Tasa            	DECIMAL(12,2);
	DECLARE Var_ClienteID      		INT(11);
	DECLARE Var_CedeMadreID        	INT(11);
	DECLARE Var_CedeAmor            INT(11);
	DECLARE Var_FechaInicio			DATE;				-- Fecha de Inicio del calendario a simular
	DECLARE	Var_FechaVencimiento	DATE;				-- Fecha de Vencimiento del calendario a simular
	DECLARE	Var_TasaFija			DECIMAL(18,4);		-- Valor de Tasa Fija
	DECLARE Var_TipoPagoInt			CHAR(1);			-- Indica si es a FIN DE MES (F) o al VENCIMIENTO (V) o por PERIODO(P)
	DECLARE Var_DiasPeriodo			INT(11);			-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	DECLARE Var_PagoIntCal			CHAR(2);			-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
   	DECLARE Var_CliProEsp	  	INT;
	DECLARE Var_TipoPersona			CHAR(1);			-- Tipo de Persona Fisíca \nMoral \nFísica Act. Empresarial
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
	SET Act_CancelaCede 			:= 10;				-- CANCELACION DE CEDES
	SET Act_VenAntCede      		:= 11;              -- VENCIMIENTO ANTICIPADO DE CEDES
	SET Esta_Vigente 				:= 'N';				-- Estatus Vigente --
	SET Impreso_SI					:='I';				-- Fue impreso Si --
	SET Mov_ApeCede					:= '501'; 			-- APERTURA DE CEDE TABLA DE TIPOSMOVSAHO
	SET Var_ConAltCed 				:= 900; 			-- Constante Mov Cedes
	SET Con_Capital 				:= 1; 				-- Tabla conceptos cede
	SET Nat_Cargo 					:= 'C'; 			-- naturaleza cargo
	SET Nat_Abono 					:= 'A'; 			-- naturaleza abono
	SET AltPoliza_NO				:= 'N'; 			-- alta de de poliza no
	SET Mov_AhorroSI				:= 'S'; 			-- movimiento de ahorro si
	SET Salida_No					:= 'N'; 			-- salida no
	SET Est_Inactivo				:= 'I'; 			-- estatus inactivo
	SET Var_ConCedeCapi				:= 1;				-- CONCEPTOSAHORRO
    SET Estatus_Cancel 				:= 'C';
	SET VarPerfilCedes				:= 3;				-- Num Validacion
	SET VarValTasasCedes			:= 4;				-- Num Validacion
	SET TasaMejoradaSI				:= 'S';
	SET Esta_Alta 					:= 'A';
	SET Mov_CanCEDE	 				:= '508'; 			-- Movimiento CANCELACION CEDE//PENDIENTE
	SET Var_ConCanCEDE 				:= 906; 			-- Concepto Cancelacion Inversion //pendiente
	SET Var_Reversa					:= 2;
	SET SabDom						:= 'SD';			-- Dia Inhabil: Sabado y Domingo
	SET No_DiaHabil					:= 'N';				-- No es dia habil
	SET Var_TipoAjuste				:= 1;
	SET Aud_FechaActual 			:= NOW();
    SET NoCliEsp					:=24;				-- Cliente CrediClub
	SET CliProcEspecifico			:='CliProcEspecifico';
    SET Per_Moral					:= 'M';
	SET Per_Fisica					:= 'F';
	SET Per_Empre					:= 'A';
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
				SET Par_NumErr	=	999;
				SET Par_ErrMen	=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: CEDESACT');
			END;

        SELECT ValorParametro INTO Var_CliProEsp
			FROM PARAMGENERALES
			WHERE LlaveParametro= CliProcEspecifico;

		IF(IFNULL(Par_CedeID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 01;
			SET Par_ErrMen := 'El Numero de Cede esta Vacio.';
			SET varControl := 'cedeID' ;
			LEAVE ManejoErrores;
		END IF;

		/* SE VALIDA QUE SE TENGA UN VALOR PARA EL USUARIO QUE LANZA EL PROCESO, EXCEPTO PARA EL QUE IMPRIME EL PAGARE*/
		IF(IFNULL( Aud_Usuario, Entero_Cero) = Entero_Cero AND Par_NumAct != Act_ImprimePag)THEN
			SET Par_NumErr	:= 03;
			SET Par_ErrMen	:= 'El Usuario no esta logueado';
			SET varControl	:= 'cedeID';
			LEAVE ManejoErrores;
		END IF;

		/* SE OBTIENEN VALORES A UTILIZAR */
		SELECT	CuentaAhoID,		Monto,      		Estatus,        	FechaInicio,		FechaVencimiento,
				EstatusImpresion,	TasaFija,			TipoPagoInt,		ClienteID,			MonedaID,
				InteresRetener,		SaldoProvision,		InteresGenerado,	TipoCedeID,			DiasPeriodo,
				PagoIntCal
			INTO
				Var_Cuenta,  		Var_Monto,  		Var_Estatus,    	Var_FechaInicio,	Var_FechaVencimiento,
				Var_EstatusImp,		Var_TasaFija,		Var_TipoPagoInt,	Var_ClienteID,		Var_Moneda,
				Var_IntRetener,		Var_SalProvision,	Var_InteresGen,		Var_TipoCedeID,		Var_DiasPeriodo,
                Var_PagoIntCal
			FROM 	CEDES
			WHERE 	CedeID	= Par_CedeID;

		/* SE OBTIENE EL ESTATUS DEL CLIENTE RELACIONADO AL CEDE */
		SELECT Cli.Estatus INTO Var_EstatusCli
			FROM	CLIENTES Cli
			WHERE 	ClienteID	= Var_ClienteID;

		SELECT DiaInhabil INTO Var_DiaInhabil FROM TIPOSCEDES WHERE TipoCedeID = Var_TipoCedeID;

		IF(Var_EstatusCli = Est_Inactivo) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El safilocale.cliente se Encuentra Inactivo';
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
				SET Par_ErrMen	:=	CONCAT('El Tipo de CEDE ', Par_TipoCedeID,' Tiene Parametrizado Dia Inhabil: Sabado y Domingo
									por tal Motivo No se Puede Registrar el CEDE.');
				LEAVE ManejoErrores;
			END IF;
		END IF;
        
      

		/* *************************************************************************************************************
		******************************** A U T O R I Z A **** C E D E **************************************************
		************************************************************************************************************* */
		IF(Par_NumAct = Act_Autorizar)THEN
        
		SET Var_DetecNoDeseada := IFNULL((SELECT  PersonNoDeseadas FROM PARAMETROSSIS LIMIT 1),Cons_No);
        IF(Var_DetecNoDeseada = Cons_Si) THEN
           -- INICIO VALIDACIÓN DE PERSONAS NO DESEADAS
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
			
				IF(Var_TipoPersona = Per_Fisica OR Var_TipoPersona = Per_Empre ) THEN 
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
            
			/*SE MANDA A LLAMAR AL SP PARA QUE GENERE LAS AMORTIZACIONES DE LA CEDE */
			CALL CEDEAMORTIZAPRO(
				Par_CedeID,			Var_FechaInicio,	Var_FechaVencimiento,	Var_Monto,			Var_ClienteID,
				Var_TipoCedeID,		Var_TasaFija,		Var_TipoPagoInt,		Var_DiasPeriodo,	Var_PagoIntCal,
                Salida_NO,			Par_NumErr,			Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,   		Aud_Sucursal,    	Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
			/*FIN DE LLAMADO AL SP QUE GENERA LAS AMORTIZACIONES*/

			SELECT COUNT(CedeID) INTO Var_NumTotCede
				FROM 	AMORTIZACEDES
				WHERE	CedeID	= Par_CedeID;

			IF(Var_NumTotCede=Entero_Cero)THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'No se pudo Autorizar el CEDE porque no se generaron las cuotas.';
				SET varControl := 'cedeID';
				LEAVE ManejoErrores;
			END IF;

			IF (DATEDIFF(Var_FechaInicio, Var_FechaSucursal)) != 0 THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'El CEDE no es del Dia de Hoy';
				SET varControl := 'cedeID';
				LEAVE ManejoErrores;
			END IF;

			CALL VALPRODUCPERFIL(
					Var_ClienteID,		Var_TipoCedeID,			VarPerfilCedes,		Salida_No, 				Par_NumErr,
					Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				SET varControl	:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;

			/*Validacion de Tasas de Ahorro */
			CALL VALIDATASASPRODUCTOS (
				Var_ClienteID,		Var_TipoCedeID,		Par_ProductoSAFI,	Aud_Sucursal,		VarValTasasCedes,
				Salida_No,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				SET varControl	:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;

			/* SE MANDA A LLAMAR EL SP QUE REALIZA LAS AFECTACIONES CONTABLES */
			CALL CONTACEDESPRO(
				Par_CedeID,			Par_EmpresaID,		Var_FechaSucursal,		Var_Monto,			Mov_ApeCede,
				Var_ConAltCed,		Var_ConCedeCapi,	Con_Capital,			Nat_Cargo,			AltPoliza_NO,
				Mov_AhorroSI,		Salida_No,			Par_PolizaID,			Par_NumErr,			Par_ErrMen,
				Var_Cuenta,			Var_ClienteID,		Var_Moneda,				Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


			 UPDATE CEDES SET
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
			 WHERE	CedeID			= Par_CedeID;

			SET Par_NumErr := '000';
			SET Par_ErrMen := 'El CEDE ha sido Autorizado Exitosamente.';
			SET varControl := 'imprime' ;

		END IF;-- FIN AUTORIZACION DEL CEDE.



		/* *************************************************************************************************************
		******************************** A U T O R I Z A *** A N C L A J E *** C E D E *********************************
		************************************************************************************************************* */
		IF(Par_NumAct = Act_AutAnclaje)THEN

			/*SE MANDA A LLAMAR AL SP PARA QUE GENERE LAS AMORTIZACIONES DE LA CEDE */
			CALL CEDEAMORTIZAPRO(
				Par_CedeID,			Var_FechaInicio,	Var_FechaVencimiento,	Var_Monto,			Var_ClienteID,
				Var_TipoCedeID,		Var_TasaFija,		Var_TipoPagoInt,		Var_DiasPeriodo,	Var_PagoIntCal,
                Salida_NO,			Par_NumErr,			Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,   		Aud_Sucursal,    	Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF (DATEDIFF(Var_FechaInicio, Var_FechaSucursal)) != 0 THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'El CEDE no es del Dia de Hoy';
				SET varControl := 'cedeID';
				LEAVE ManejoErrores;
			END IF;


			CALL VALPRODUCPERFIL(
				Var_ClienteID,		Var_TipoCedeID,			VarPerfilCedes,		Salida_No, 				Par_NumErr,
				Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				SET varControl	:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;

			/*Validacion de Tasas de Ahorro */
			CALL VALIDATASASPRODUCTOS (
				Var_ClienteID,		Var_TipoCedeID,		Par_ProductoSAFI,	Aud_Sucursal,		VarValTasasCedes,
				Salida_No,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				SET varControl	:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;

			/* SE MANDA A LLAMAR EL SP QUE REALIZA LAS AFECTACIONES CONTABLES */
			CALL CONTACEDESPRO(
				Par_CedeID,			Par_EmpresaID,		Var_FechaSucursal,		Var_Monto,			Mov_ApeCede,
				Var_ConAltCed,		Var_ConCedeCapi,	Con_Capital,			Nat_Cargo,			AltPoliza_NO,
				Mov_AhorroSI,		Salida_No,			Par_PolizaID,			Par_NumErr,			Par_ErrMen,
				Var_Cuenta,			Var_ClienteID,		Var_Moneda,				Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


			SELECT 		cede.CedeOriID,		cat.TasaMejorada
				INTO	Var_CedeMadre,		Var_TasaMejorada
				FROM 	CEDESANCLAJE cede
						INNER JOIN CEDES cede1 ON cede.CedeOriID = cede1.CedeID
						INNER JOIN TIPOSCEDES cat ON cede1.TipoCedeID = cat.TipoCedeID
				WHERE 	cede.CedeAncID	= Par_CedeID;

			SET Var_CedeMadre	:=	IFNULL(Var_CedeMadre,Entero_Cero);

			IF (Var_CedeMadre > Entero_Cero AND Var_TasaMejorada = TasaMejoradaSI) THEN
				CALL CEDESAJUSTEPRO(
					Par_CedeID,		Var_TipoAjuste,	Salida_NO,			Par_NumErr,			Par_ErrMen,
					Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,	Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

			UPDATE CEDES SET
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
			WHERE	CedeID 			= Par_CedeID;

			SET Par_NumErr := '000';
			SET Par_ErrMen := 'El CEDE ha sido Autorizado Exitosamente.';
			SET varControl := 'imprime' ;

		END IF;-- FIN AUTORIZACION DEL CEDE.


		/* *************************************************************************************************************
		******************************** I M P R I M E *** P A G A R E *************************************************
		************************************************************************************************************* */
		IF(Par_NumAct = Act_ImprimePag) THEN
			UPDATE CEDES SET
					EstatusImpresion	= Impreso_SI,
					FechaActual 		= Aud_FechaActual
			WHERE	CedeID 				= Par_CedeID;

			SET Par_NumErr := 000;
			SET Par_ErrMen := 'Pagare Impreso Exitosamente';
			SET varControl := 'cedeID';
		END IF;


		/* *************************************************************************************************************
		**************** C A N C E L A C I O N *** D E *** C E D E *** M I S M O *** D I A *****************************
		************************************************************************************************************* */
		-- CANCELACION DE CEDES
		IF(Par_NumAct = Act_CancelaCede)THEN
			-- Validaciones antes de cancelar
			IF (Var_Estatus != Esta_Vigente AND Var_Estatus != Esta_Alta) THEN
				SET Par_NumErr := 01;
				SET Par_ErrMen := 'El CEDE no puede ser Cancelado (Revisar Estatus)';
				SET varControl := 'cedeID';
				LEAVE ManejoErrores;
			END IF;

			IF (DATEDIFF(Var_FechaSucursal,Var_FechaInicio)) != Entero_Cero THEN
				SET Par_NumErr := 02;
				SET Par_ErrMen := 'El CEDE no es del Dia de Hoy';
				SET varControl := 'cedeID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL( Aud_Usuario, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 03;
				SET Par_ErrMen := 'El Usuario no esta logueado';
				SET varControl := 'cedeID';
				LEAVE ManejoErrores;
			END IF;

			-- Se consulta si es un cede Madre
			SET Var_EsCedeMadre := (SELECT CedeOriID
										FROM 	CEDESANCLAJE
										WHERE 	CedeOriID	= Par_CedeID
										GROUP BY CedeOriID);
			SET Var_EsCedeMadre :=	IFNULL(Var_EsCedeMadre,Entero_Cero);

			-- Se consulta si es un ANCLAJE
			SET Var_CedeAnclaje := (SELECT CedeOriID
										FROM 	CEDESANCLAJE
										WHERE 	CedeAncID	= Par_CedeID
										GROUP BY CedeOriID);
			SET Var_CedeAnclaje :=	IFNULL(Var_CedeAnclaje,Entero_Cero);


			-- Se obtiene el ultimo cede anclado de una cede madre
			SET Var_MaxAnclMadre :=	(SELECT 	MAX(CD.CedeID)
										FROM 	CEDESANCLAJE AN
												INNER JOIN CEDES CD ON AN.CedeOriID = CD.CedeID
												OR AN.CedeAncID = CD.CedeID
										WHERE 	CedeOriID 	= Var_EsCedeMadre
										AND 	Estatus 	!= Estatus_Cancel);
			SET Var_MaxAnclMadre 	:=	IFNULL(Var_MaxAnclMadre,Entero_Cero);


			-- Se obtiene el ultimo cede anclado de una cede ANCLAJE
			SET Var_MaxAnclaje :=	(SELECT 	MAX(CD.CedeID)
										FROM 	CEDESANCLAJE AN
												INNER JOIN CEDES CD ON AN.CedeOriID = CD.CedeID
												OR AN.CedeAncID = CD.CedeID
										WHERE 	CedeOriID 	= Var_CedeAnclaje
										AND 	Estatus 	!= Estatus_Cancel);
			SET Var_MaxAnclaje 	:=	IFNULL(Var_MaxAnclaje,Entero_Cero);


			-- se valida si el cede tiene anclajes que sea el ultimo
			IF (Var_MaxAnclaje != Entero_Cero) THEN
				IF (Par_CedeID != Var_MaxAnclaje) THEN
					SET Par_NumErr := 04;
					SET Par_ErrMen := 'El CEDE tiene Anclajes, no se puede Cancelar';
					SET varControl := 'cedeID';
					LEAVE ManejoErrores;
				END IF;
			END IF;


			-- se valida si el cede madre tiene anclajes que sea el ultimo
			IF (Var_MaxAnclMadre != Entero_Cero) THEN
				IF (Par_CedeID != Var_MaxAnclMadre) THEN
					SET Par_NumErr := 05;
					SET Par_ErrMen := 'El CEDE tiene Anclajes, no se puede Cancelar';
					SET varControl := 'cedeID';
					LEAVE ManejoErrores;
				END IF;
			END IF;



			-- Se realiza la afectacion contable si el cede es vigente (reversa)
			IF(Var_Estatus = Esta_Vigente) THEN

				CALL CONTACEDESPRO(
					Par_CedeID,		Par_EmpresaID,		Var_FechaSucursal,	Var_Monto,		Mov_CanCEDE,
					Var_ConCanCEDE,	Var_ConCedeCapi,	Con_Capital,		Nat_Abono,		AltPoliza_NO,
					Mov_AhorroSI,	Salida_NO,			Par_PolizaID,		Par_NumErr,		Par_ErrMen,
					Var_Cuenta,		Var_ClienteID,		Var_Moneda,			Aud_Usuario,	Aud_FechaActual,
					Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

			-- Si el cede es vigente y es un anclaje se realiza la reversa para tomar los valores anteriores de la tasa
			IF(Var_Estatus = Esta_Vigente) THEN
				IF(Var_CedeAnclaje > Entero_Cero)THEN

					CALL CEDESAJUSTEPRO(
						Par_CedeID,			Var_Reversa,		Salida_NO,			Par_NumErr,		Par_ErrMen,
						Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);

					 IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					 END IF;

				END IF;
			END IF;

			-- Se actualiza el cede a estatus cancelado y la fecha de cancelacion
			UPDATE CEDES SET
					Estatus 		= Estatus_Cancel,
					FechaCancela 	= Var_FechaAutoriza,
					EmpresaID 		= Par_EmpresaID,
					UsuarioID 		= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID 		= Aud_ProgramaID,
					Sucursal 		= Aud_Sucursal,
					NumTransaccion 	= Aud_NumTransaccion
			WHERE 	CedeID 			= Par_CedeID;

			-- Se actualiza la amortizacion del cede a estatus cancelado
			UPDATE AMORTIZACEDES SET
					Estatus 		= Estatus_Cancel,
					EmpresaID 		= Par_EmpresaID,
					Usuario 		= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID 		= Aud_ProgramaID,
					Sucursal 		= Aud_Sucursal,
					NumTransaccion 	= Aud_NumTransaccion
			WHERE 	CedeID 			= Par_CedeID;


			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('CEDE Cancelado Exitosamente');
			SET varControl	:= 'cedeID';

		END IF; -- FIN DE CANCELACION DE CEDES



		/* *************************************************************************************************************
		**************** V E N C I M I E N T O  *** A N T I C I P A D O ************************************************
		************************************************************************************************************* */
		-- VENCIMIENTO ANTICIPADO DE DE CEDES
		IF(Par_NumAct = Act_VenAntCede)THEN

			-- Validaciones antes de cancelar
			IF (Var_Estatus != Esta_Vigente) THEN
				SET Par_NumErr := 01;
				SET Par_ErrMen := 'EL CEDE no puede ser Cancelado (Revisar Estatus)';
				SET varControl := 'cedeID';
				LEAVE ManejoErrores;
			END IF;

			IF (DATEDIFF(Var_FechaSucursal,Var_FechaInicio)) = Entero_Cero THEN
				SET Par_NumErr := 02;
				SET Par_ErrMen := 'El CEDE es del dia de hoy, utilice la pantalla de Cancelacion';
				SET varControl := 'cedeID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_CedeAmor :=	(SELECT CedeID
									FROM 	AMORTIZACEDES
									WHERE 	CedeID = Par_CedeID
									GROUP BY CedeID);

			IF(IFNULL(Var_CedeAmor, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 04;
				SET Par_ErrMen := 'No existen Amortizaciones para el Cede Indicado';
				SET varControl := 'cedeID';
				LEAVE ManejoErrores;
			END IF;

		-- Se obtiene el cede madre
			SET Var_CedeMadreID :=	(SELECT CedeOriID
										FROM 	CEDESANCLAJE
										WHERE 	CedeAncID = Par_CedeID);

			SET Var_CedeMadreID := IFNULL(Var_CedeMadreID, Par_CedeID);

			DELETE FROM TMPVENCIMANTCEDE WHERE NumTransaccion = Aud_NumTransaccion;
		-- Inserta el cede madre a la tabla temporal
			INSERT INTO TMPVENCIMANTCEDE(
					CedeID,			CuentaAhoID, 		TipoCedeID, 	MonedaID, 		ClienteID,
					SaldoProvision, FechaVencimiento, 	CalculoInteres, Estatus,		Reinversion,
					Monto,			EmpresaID, 			UsuarioID,		FechaActual,	DireccionIP,
					ProgramaID,		Sucursal,			NumTransaccion)
			SELECT 	CedeID,			CuentaAhoID, 		TipoCedeID, 	MonedaID, 		ClienteID,
					SaldoProvision, FechaVencimiento, 	CalculoInteres, Estatus,		Reinversion,
					Monto,			EmpresaID, 			UsuarioID,		FechaActual,	DireccionIP,
                    ProgramaID,		Sucursal,			Aud_NumTransaccion
				FROM 	CEDES
				WHERE 	CedeID = Var_CedeMadreID;

		-- Inserta los anclajes a la tabla temporal

			INSERT INTO TMPVENCIMANTCEDE(
					CedeID,				CuentaAhoID, 			TipoCedeID, 		MonedaID, 		ClienteID,
					SaldoProvision, 	FechaVencimiento, 		CalculoInteres, 	Estatus,		Reinversion,
					Monto,				EmpresaID, 				UsuarioID,			FechaActual,	DireccionIP,
					ProgramaID,			Sucursal,				NumTransaccion)
			SELECT 	CD.CedeID,			CD.CuentaAhoID, 		CD.TipoCedeID, 		CD.MonedaID, 	CD.ClienteID,
					CD.SaldoProvision, 	CD.FechaVencimiento, 	CD.CalculoInteres, 	CD.Estatus,		CD.Reinversion,
					CD.Monto,			CD.EmpresaID, 			CD.UsuarioID,		CD.FechaActual,	CD.DireccionIP,
                    CD.ProgramaID,		CD.Sucursal,			Aud_NumTransaccion
				FROM 	CEDES CD
						INNER JOIN CEDESANCLAJE AN ON CD.CedeID = AN.CedeAncID AND CD.Estatus = Esta_Vigente
				WHERE 	AN.CedeOriID 	= Var_CedeMadreID;

		-- Llamada a SP que realiza el pago del CEDE
		IF (Var_CliProEsp = NoCliEsp) THEN
			CALL CEDEPAGOVENANTPRO024 (Var_CedeMadreID, 	Var_ClienteID,		Var_FechaSucursal,	Par_PolizaID,		Salida_NO,
									Par_NumErr,			Par_ErrMen,			Par_EmpresaID, 		Aud_Usuario, 		Aud_FechaActual,
									Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);
		ELSE

			CALL CEDEPAGOVENANTPRO (Var_CedeMadreID, 	Var_ClienteID,		Var_FechaSucursal,	Par_PolizaID,		Salida_NO,
									Par_NumErr,			Par_ErrMen,			Par_EmpresaID, 		Aud_Usuario, 		Aud_FechaActual,
									Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('CEDE Cancelado Exitosamente');
			SET varControl := 'cedeID';

		END IF; -- FIN DE VENCIMIENTO ANTICIPADO DE CEDES


	END ManejoErrores; # fin del manejador de errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				varControl	AS control,
				Par_CedeID	AS consecutivo;
	END IF;
END TerminaStore$$
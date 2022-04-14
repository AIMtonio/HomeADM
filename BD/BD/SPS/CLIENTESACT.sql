
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESACT`;

DELIMITER $$
CREATE PROCEDURE `CLIENTESACT`(
/*SP PARA LA ACTUALIZACION DE LA INFORMACION DEL CLIENTE*/
	Par_ClienteID			INT(11),
	Par_PagaIVA 			CHAR(1),
	Par_PagaISR 			CHAR(1),
	Par_PagaIDE 			CHAR(1),
	Par_TipoInactiva 		INT(11),

	Par_MotivoInactiva 		VARCHAR(150),
	Par_PromotorNuevo		INT(11),
	Par_UsuarioClave 		VARCHAR(50),
	Par_ContraseniaAut 		VARCHAR(150),
	Par_NumAct				INT(11),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaBaja		DATE;
	DECLARE Var_UsuarioID    	INT;
	DECLARE Var_Estatus     	CHAR(1);
	DECLARE Var_Contrasenia 	VARCHAR(100);
	DECLARE	Fecha_Reactiva		DATE; 				/*Se refiere a la fecha de reactivaciÃ³n del cliente*/
	DECLARE varControl 			CHAR(15);		# almacena el elemento que es incorrecto
	DECLARE Var_Edad			INT(11);
	DECLARE Var_MesNac			INT(11);
	DECLARE Var_MesHoy			INT(11);
	DECLARE Var_DiaNac			INT(11);
	DECLARE Var_DiaHoy			INT(11);
	DECLARE Var_EstatusCliente  CHAR(1);
	DECLARE Var_NivelRiesgoCte	CHAR(1);
	DECLARE Var_ActividadBancoMX	VARCHAR(15);
	DECLARE Var_NivelClaveRiesgo	CHAR(1);
	DECLARE Var_EstatusCta     		CHAR(1);
	DECLARE Var_EstatusInver     	CHAR(1);

	-- DEclaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE ActivaCliente    	INT;
	DECLARE InactivaCliente     INT;
	DECLARE ClienteActivo    	CHAR(1);
	DECLARE ClienteInactivo  	CHAR(1);
	DECLARE CreditoVigente  	CHAR(1);
	DECLARE CreditoVencido  	CHAR(1);
	DECLARE ActualizaFiscales	INT;
	DECLARE MayoriaEdad			INT(11);
	DECLARE MayorEdad			INT(11);
	DECLARE ActualizaPromotor   INT;
	DECLARE ActualizaNivelRAlto	INT;
	DECLARE ActualizaNivelRActBMX	INT;
	DECLARE NivelR_Alto			CHAR(1);
	DECLARE NivelR_Bajo			CHAR(1);
	DECLARE Str_SI				CHAR(1);
	DECLARE Str_NO				CHAR(1);
	DECLARE CuentaActiva		CHAR(1);
	DECLARE InversionVigente	CHAR(1);
	DECLARE Alt_Clientes		INT(11);				# Alta de Clientes BITACORA HISTORICA DE ACTUALIZACIONES

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';					-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero				:= 0;					-- Entero _cero
	SET ActivaCliente 			:= 5;					-- Tipo de Actualizacion Activa cliente
	SET InactivaCliente 		:= 6;					-- Tipo de Actualizacion Inactiva cliente
	SET ActualizaFiscales		:= 3; 					-- Actualiza Datos Fiscales del Cliente
	SET ActualizaPromotor       := 7;					-- Actualiza Promotor Actual
	SET ActualizaNivelRAlto		:= 8;					-- Actualiza el Nivel de Riesgo del cliente por Riesgo Alto
	SET ActualizaNivelRActBMX	:= 9;					-- Actualiza el Nivel de Riesgo del cliente dependiendo de la Actividad BMX

	SET ClienteActivo 			:= 'A';					-- Cliente con Estatus Activo
	SET ClienteInactivo 		:= 'I';					-- Cliente con Estatus Inactivo
	SET CreditoVigente  		:= 'V';					-- Credito Vigente
	SET CreditoVencido  		:= 'B';					-- Credito Bencido
	SET MayoriaEdad				:= 11;					-- Motivo de inactivacion por mayoria de edad
	SET MayorEdad				:= 18;					-- 18 aÃ±os es mayor de edad
	SET NivelR_Alto				:= 'A';					-- Nivel de Riego del Cliente ALTO
	SET NivelR_Bajo				:= 'B';					-- Nivel de Riego del Cliente BAJO
	SET Str_SI					:= 'S';					-- Salida Si
	SET Str_NO					:= 'N';					-- Salida No
	SET CuentaActiva			:= 'A';
	SET InversionVigente		:= 'N';
	SET Alt_Clientes			:= 1;					# Alta de Clientes BITACORA HISTORICA DE ACTUALIZACIONES

	ManejoErrores:BEGIN 	#bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
							'esto le ocasiona. Ref: SP-CLIENTESACT');
			SET varControl := 'sqlException' ;
		END;

		IF(IFNULL(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := CONCAT('El numero de ',FNGENERALOCALE('safilocale.cliente'),' esta vacio.');
			SET varControl  := 'numero' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumAct,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El tipo de actualizacion esta vacio.';
			SET varControl  := 'numAct' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT  UsuarioID , Contrasenia INTO  Var_UsuarioID,Var_Contrasenia
			FROM USUARIOS
			WHERE Clave = Par_UsuarioClave;

		SET  Var_UsuarioID	:=IFNULL(Var_UsuarioID, Entero_Cero);
		SET Var_Contrasenia	:=IFNULL(Var_Contrasenia,Cadena_Vacia);


		IF (Par_NumAct = ActivaCliente)THEN
			IF(IFNULL(Par_UsuarioClave,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := 003;
				SET Par_ErrMen  := 'El usuario esta vacio.';
				SET varControl  := 'claveUsuarioAut' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ContraseniaAut, Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := 004;
				SET Par_ErrMen  := 'La contraseña esta vacia.';
				SET varControl  :='contraseniaAut';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ContraseniaAut != Var_Contrasenia)THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= 'Contraseña o Usuario Incorrecto.';
				SET varControl	:= 'claveUsuarioAut';
				LEAVE ManejoErrores;
			END IF;


			IF(Var_UsuarioID = Aud_Usuario)THEN
				SET Par_NumErr  := 006;
				SET Par_ErrMen  := CONCAT('El usuario que realiza la Transaccion no puede ser el mismo que  Autoriza. ');
				SET varControl  := 'claveUsuarioAut' ;
				LEAVE ManejoErrores;
			END IF;

			CALL COBROREACTIVACLIACT(
				Par_ClienteID,		Par_NumAct,			Str_NO,				Par_NumErr,			Par_ErrMen,
				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			/** REGISTRO EN LA BITÁCORA DE ACTIVACIONES E INACTIVACIONES, ANTES DE LA ACTUALIZACION
			 ** DE ESTATUS DEL CLIENTE.*/
			CALL BITACTIVACIONESCTESALT(
				Par_ClienteID,		Str_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Fecha_Reactiva := (SELECT FechaSistema FROM PARAMETROSSIS);
			SET Aud_FechaActual := NOW();

			UPDATE CLIENTES
			SET
				Estatus				= ClienteActivo,
				TipoInactiva		= Par_TipoInactiva,
				MotivoInactiva		= Par_MotivoInactiva,
				FechaReactivacion	= Fecha_Reactiva,
				FechaBaja			= Fecha_Vacia, /*Se deja con fecha vacia */

				EmpresaID			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE ClienteID = Par_ClienteID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT(FNGENERALOCALE('safilocale.cliente'),' Actualizado Exitosamente: ', Par_ClienteID,'.');
			SET varControl  := 'numero' ;
			LEAVE ManejoErrores;
		END IF; -- Activa Cliente

		-- Inactivar --
		IF (Par_NumAct = InactivaCliente )THEN
			IF(IFNULL(Par_UsuarioClave,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := 007;
				SET Par_ErrMen  := 'El usuario esta vacio.';
				SET varControl  := 'claveUsuarioAut' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ContraseniaAut, Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := 008;
				SET Par_ErrMen  := 'La contraseña esta vacia.';
				SET varControl  :='contraseniaAut';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ContraseniaAut != Var_Contrasenia)THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen	:= 'Contraseña o Usuario Incorrecto.';
				SET varControl	:= 'claveUsuarioAut';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_UsuarioID = Aud_Usuario)THEN
				SET Par_NumErr  := 010;
				SET Par_ErrMen  := 'El usuario que realiza la Transaccion no puede ser el mismo que  Autoriza.';
				SET varControl  := 'claveUsuarioAut' ;
				LEAVE ManejoErrores;
			END IF;

			-- Validar si el cliente cuenta con un credito Vigente, Castigado, o Vencido
			SELECT Estatus INTO Var_Estatus
				FROM CREDITOS
				WHERE ClienteID = Par_ClienteID AND (Estatus = 'V' OR Estatus = 'B' OR Estatus = 'K')
				LIMIT 1;

			IF (Var_Estatus = CreditoVigente) THEN
				SET Par_NumErr  := 011;
				SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' Seleccionado no puede ser Inactivado por contar con un credito Vigente.');
				SET varControl  := 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			IF (Var_Estatus = CreditoVencido) THEN
				SET Par_NumErr  := 012;
				SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' Seleccionado no puede ser Inactivado por contar con un credito Vencido.');
				SET varControl  := 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			SELECT FechaSistema INTO Var_FechaBaja FROM PARAMETROSSIS;
			SET Aud_FechaActual := CURRENT_TIMESTAMP();

			IF(Par_TipoInactiva = MayoriaEdad)THEN
				IF NOT EXISTS(SELECT *FROM CLIENTES
										WHERE ClienteID=Par_ClienteID
											AND EsMenorEdad='S')THEN
					SET Par_NumErr  := 007;
					SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' Indicado no es un ',FNGENERALOCALE('safilocale.cliente'),' Menor.');
					SET varControl  := 'numero' ;
					LEAVE ManejoErrores;
				END IF;


				SELECT YEAR(Var_FechaBaja)-YEAR(FechaNacimiento),MONTH(FechaNacimiento),MONTH(Var_FechaBaja),DAY(FechaNacimiento),DAY(Var_FechaBaja)
						INTO Var_Edad,Var_MesNac,Var_MesHoy,Var_DiaNac,Var_DiaHoy
					FROM CLIENTES WHERE ClienteID=Par_ClienteID ;

				IF(Var_Edad<MayorEdad)THEN
					SET Par_NumErr  := 008;
					SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' Indicado no es Mayor de Edad.');
					SET varControl  := 'numero' ;
					LEAVE ManejoErrores;
				END IF;

				IF(Var_Edad = MayorEdad AND Var_MesNac>Var_MesHoy)THEN
					SET Par_NumErr  := 009;
					SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' Indicado no es Mayor de edad.');
					SET varControl  := 'numero' ;
					LEAVE ManejoErrores;
				END IF;
				IF(Var_Edad = MayorEdad AND Var_MesNac=Var_MesHoy AND Var_DiaNac>Var_DiaHoy)THEN
					SET Par_NumErr  := 010;
					SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' Indicado no es Mayor de edad.');
					SET varControl  := 'numero' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;


			SELECT Estatus INTO Var_EstatusInver
					FROM INVERSIONES
					WHERE ClienteID = Par_ClienteID AND Estatus = 'N'
					LIMIT 1;

			IF (Var_EstatusInver = InversionVigente) THEN
				SET Par_NumErr  := 011;
				SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' Seleccionado no puede ser Inactivado por contar con una Inversion Vigente.');
				SET varControl  := 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			SELECT Estatus INTO Var_EstatusCta
					FROM CUENTASAHO
					WHERE ClienteID = Par_ClienteID AND Estatus = 'A'
					LIMIT 1;

			IF (Var_EstatusCta = CuentaActiva) THEN
				SET Par_NumErr  := 012;
				SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' Seleccionado no puede ser Inactivado por contar con una Cuenta Activa.');
				SET varControl  := 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			/** REGISTRO EN LA BITÁCORA DE ACTIVACIONES E INACTIVACIONES, ANTES DE LA ACTUALIZACION
			 ** DE ESTATUS DEL CLIENTE.*/
			CALL BITACTIVACIONESCTESALT(
				Par_ClienteID,		Str_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			UPDATE CLIENTES
			SET Estatus 	   = ClienteInactivo,
				TipoInactiva   = Par_TipoInactiva,
				MotivoInactiva = Par_MotivoInactiva,
				FechaBaja  	   = Var_FechaBaja, /*Se actualiza la fecha de baja  del cliente en momento de inactivaciÃ³n*/

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE ClienteID    = Par_ClienteID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT(FNGENERALOCALE('safilocale.cliente'),' Actualizado Exitosamente: ', Par_ClienteID,'.');
			SET varControl  := 'numero' ;
			LEAVE ManejoErrores;
		END IF; -- Inactiva Cliente

		IF (Par_NumAct = ActualizaFiscales )THEN

			SELECT Estatus INTO Var_EstatusCliente
					FROM CLIENTES
						WHERE ClienteID=Par_ClienteID;

			IF(NOT EXISTS(SELECT ClienteID
						FROM CLIENTES
								WHERE ClienteID = Par_ClienteID)) THEN
				SET Par_NumErr  := 013;
				SET Par_ErrMen  := CONCAT('El Numero de ',FNGENERALOCALE('safilocale.cliente'),' no existe.');
				SET varControl  := 'clienteIDf' ;
			  LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr  := 014;
					SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' esta Vacio.');
					SET varControl  := 'clienteIDf' ;
				LEAVE ManejoErrores;

			END IF;

			IF(Var_EstatusCliente = ClienteInactivo)THEN
					SET Par_NumErr  := 015;
					SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' se Encuentra Inactivo.');
					SET varControl  := 'clienteIDf' ;
				LEAVE ManejoErrores;

			END IF;


			SET Aud_FechaActual := CURRENT_TIMESTAMP();
			UPDATE CLIENTES SET
				PagaIVA			= Par_PagaIVA,
				PagaISR			= Par_PagaISR,
				PagaIDE			= Par_PagaIDE,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE ClienteID = Par_ClienteID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT(FNGENERALOCALE('safilocale.cliente'),' Actualizado Exitosamente: ',Par_ClienteID,'.');
			SET varControl  := 'clienteIDf' ;
			LEAVE ManejoErrores;
		END IF; -- Actualiza Fiscales.


		-- Actualiza Promotor Actual

		IF (Par_NumAct = ActualizaPromotor )THEN
			IF(NOT EXISTS(SELECT ClienteID
						FROM CLIENTES
								WHERE ClienteID = Par_ClienteID)) THEN
				SET Par_NumErr  := 013;
				SET Par_ErrMen  := CONCAT('El Numero de ',FNGENERALOCALE('safilocale.cliente'),' no existe.');
				SET varControl  := 'numero' ;
			   LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := 014;
				SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' esta Vacio.');
				SET varControl  := 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			SET Aud_FechaActual := CURRENT_TIMESTAMP();

			UPDATE CLIENTES SET
				PromotorActual	= Par_PromotorNuevo,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion

			WHERE ClienteID = Par_ClienteID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT(FNGENERALOCALE('safilocale.cliente'),' Actualizado Exitosamente: ',Par_ClienteID,'.');
			SET varControl  := 'numero' ;
			LEAVE ManejoErrores;

		END IF; -- Actualiza Promotor Actual.

		-- Actualiza El Nivel de Riesgo del Cliente por ALTO
		IF (Par_NumAct = ActualizaNivelRAlto)THEN

			SELECT NivelRiesgo INTO Var_NivelRiesgoCte
				FROM CLIENTES
					WHERE ClienteID = Par_ClienteID;

			IF(NOT EXISTS(SELECT ClienteID
						FROM CLIENTES
								WHERE ClienteID = Par_ClienteID)) THEN
				SET Par_NumErr  := 013;
				SET Par_ErrMen  := CONCAT('El Numero de ',FNGENERALOCALE('safilocale.cliente'),' no existe.');
				SET varControl  := 'numero' ;
			   LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := 014;
				SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' esta Vacio.');
				SET varControl  := 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_NivelRiesgoCte, Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := 015;
				SET Par_ErrMen  := 'El Nivel de Riesgo esta Vacio.';
				SET varControl  := 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_NivelRiesgoCte!=NivelR_Alto) THEN
				SET Aud_FechaActual := CURRENT_TIMESTAMP();

				UPDATE CLIENTES SET
					NivelRiesgo		= NivelR_Alto,

					EmpresaID		= Par_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID  	= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion

				WHERE ClienteID = Par_ClienteID;

				CALL BITACORAHISTPERSALT(
					Aud_NumTransaccion,			Alt_Clientes,		Par_ClienteID,				Entero_Cero,			Entero_Cero,
					Entero_Cero,				Str_NO,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,
					Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr!=Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				SET Par_NumErr  := 000;
				SET Par_ErrMen  := CONCAT(FNGENERALOCALE('safilocale.cliente'),' Actualizado Exitosamente: ',Par_ClienteID,'.');
				SET varControl  := 'numero' ;
				LEAVE ManejoErrores;
			END IF;
		END IF; -- FIN Nivel de Riesgo del Cliente ALTO .

		-- Actualiza El Nivel de Riesgo del Cliente por el nivel de riesgo que corresponda a su Actividad BMX
		IF (Par_NumAct = ActualizaNivelRActBMX)THEN

			SELECT NivelRiesgo, 		ActividadBancoMX
			INTO Var_NivelRiesgoCte,	Var_ActividadBancoMX
				FROM CLIENTES
					WHERE ClienteID = Par_ClienteID;

			SELECT ClaveRiesgo INTO Var_NivelClaveRiesgo
				FROM ACTIVIDADESBMX
					WHERE ActividadBMXID=Var_ActividadBancoMX;

			IF(NOT EXISTS(SELECT ClienteID
						FROM CLIENTES
								WHERE ClienteID = Par_ClienteID)) THEN
				SET Par_NumErr  := 013;
				SET Par_ErrMen  := CONCAT('El Numero de ',FNGENERALOCALE('safilocale.cliente'),' no existe.');
				SET varControl  := 'numero' ;
			   LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := 014;
				SET Par_ErrMen  := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' esta Vacio.');
				SET varControl  := 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_NivelRiesgoCte, Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := 015;
				SET Par_ErrMen  := 'El Nivel de Riesgo esta Vacio.';
				SET varControl  := 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			SET Aud_FechaActual := CURRENT_TIMESTAMP();

			UPDATE CLIENTES SET
				NivelRiesgo		= Var_NivelClaveRiesgo,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion

			WHERE ClienteID = Par_ClienteID;

			/*Se almacena la Informacion en la Bitacora Historica. ############################################################################ */
			CALL BITACORAHISTPERSALT(
				Aud_NumTransaccion,			Alt_Clientes,		Par_ClienteID,				Entero_Cero,			Entero_Cero,
				Entero_Cero,				Str_NO,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,
				Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			/*FIN de Respaldo de Bitacora Historica ########################################################################################### */
			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT(FNGENERALOCALE('safilocale.cliente'),' Actualizado Exitosamente: ',Par_ClienteID,'.');
			SET varControl  := 'numero' ;
			LEAVE ManejoErrores;
		END IF; -- FIN Nivel de Riesgo del Cliente BAJO.

	END ManejoErrores; #fin del manejador de errores.

	IF(Par_Salida = Str_SI) THEN
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			varControl AS control,
			Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$


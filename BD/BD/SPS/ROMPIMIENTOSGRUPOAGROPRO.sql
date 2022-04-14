-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ROMPIMIENTOSGRUPOAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ROMPIMIENTOSGRUPOAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `ROMPIMIENTOSGRUPOAGROPRO`(
	-- ======================= SP PARA DESINTEGRAR UN GRUPO DE CREDITO ======================
	Par_GrupoID				INT(11),		-- Grupo de credito
	Par_Ciclo				INT(11),		-- Ciclo del grupo
	Par_SolicitudCreditoID  BIGINT(20),		-- Solicitud de credito del cliente a desintegrar
	Par_UsuarioID			INT(11),		-- Usuario que registra el rompimiento
	Par_SucursalID			INT(11),		-- Sucursal en la que se registra el rompimiento

	Par_Motivo				VARCHAR(500),	-- Motivo del rompimiento

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Parametro Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro Mensaje de Error

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control 			CHAR(50);		-- almacena el elemento que es incorrecto
	DECLARE Var_EstatusSolicitud	CHAR(1);		-- Estatus de la solicitud de credito
	DECLARE Var_EstatusCredito		CHAR(1);		-- Estatus del credito
	DECLARE Var_PonderaTasa	    	CHAR(1);		-- S=si, N=no, poderar tasa grupal
	DECLARE Var_EsAgropecuario		CHAR(1);		-- Validador Agropecuario

	DECLARE Var_EstatusInte			CHAR(1);		-- Estatus actual de integrante
	DECLARE Var_Estatus				CHAR(1);		-- Estatus de la solicitud
	DECLARE Var_CalificaCredito		CHAR(1);		-- Calificacion del cliente

	DECLARE Var_ClienteID			INT(11);		-- Guarda el integrante a desintegrar del grupo
	DECLARE Var_RompimientoID		INT(11);		-- Guarda el id consecutivo de rompimientos
	DECLARE Var_ProductoCredito		INT(11);		-- Producto de credito
	DECLARE Var_ProspectoID			INT(11);		-- ID del prospecto de la solicitud de credito
	DECLARE Var_SucursalID			INT(11);		-- Sucursal donde se dio de alta la solicitud del credito

	DECLARE Var_NumIntegrantes		INT(11);		-- Numero de integrantes de un grupo de credito
	DECLARE Var_InstitucionNominaID	INT(11);
	DECLARE Var_NivelID				INT(11);		-- Nivel del crédito (NIVELCREDITO).
	DECLARE Var_CicloGrupo			INT(11);		-- Numero de ciclo grupal
	DECLARE Var_CicloCliente		INT(11);		-- Numero de ciclo individual(del cliente/prospecto)

	DECLARE Var_MaxRegistroID		INT(11);		-- Numero Maximo de recorrido
	DECLARE Var_Contador			INT(11);		-- Numero de Contador

	DECLARE Var_FechaSistema		DATE;			-- Feha actual del sistema PARAMETROSSIS
	DECLARE Var_PlazoID				VARCHAR(20);	-- ID del plazo
	DECLARE Var_NombreCompleto		VARCHAR(200);	-- Almacena el nombre del cliente o prospecto al que pertenece la solicitud de credito
	DECLARE Var_NombreGrupo			VARCHAR(200);	-- Nombre del grupo de credito al que pertenece el cliente
	DECLARE Var_MontoSolici			DECIMAL(12,2);	-- Monto solicitado

	DECLARE Var_MontoAutorizado		DECIMAL(12,2);	-- Monto autorizado de la solicitud
	DECLARE Var_Monto				DECIMAL(12,2);	-- Monto utilizado para calcular la tasa
	DECLARE Var_TasaFija    		DECIMAL(12,4);	-- Nueva tasa de interes
	DECLARE Var_CreditoID			BIGINT(12);		-- Credito del cliente del cliente a desintegrar
	DECLARE Var_SolicitudCreditoID	BIGINT(20);		-- ID de la solicitud de credito

	DECLARE Var_NumTransacSim 		BIGINT(20);		-- Numero de transaccion del simulador
	DECLARE	Var_ConvenioNominaID	BIGINT UNSIGNED;-- ID Convenio Nomina

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);			-- entero cero
	DECLARE Entero_Uno			INT(11);			-- entero Uno
	DECLARE Fecha_Vacia			DATE;				-- fecha vacia
	DECLARE Cadena_Vacia		CHAR(1);			-- cadena vacia
	DECLARE Salida_SI			CHAR(1);			-- salida SI

	DECLARE Estatus_Activo		CHAR(1);			-- Estatus activo
	DECLARE Estatus_Autoriza	CHAR(1);			-- Estatus autorizado
	DECLARE Estatus_Inactivo	CHAR(1);			-- Estatus Inactivo
	DECLARE PonderaTasa_SI		CHAR(1);			-- Si pondera tasa grupal
	DECLARE Salida_NO			CHAR(1);			-- No habra datos de salida

	DECLARE Con_SI				CHAR(1);			-- Constante SI
	DECLARE Con_NO				CHAR(1);			-- Constante NO
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- decimal cero

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Fecha_Vacia			:= '1900-01-01';
	SET Cadena_Vacia		:= '';
	SET Salida_SI			:= 'S';

	SET Estatus_Activo		:= 'A';
	SET PonderaTasa_SI		:= 'S';
	SET Estatus_Autoriza	:= 'A';
	SET Estatus_Inactivo	:= 'I';
	SET Salida_NO			:= 'N';

	SET Con_SI				:= 'S';
	SET Con_NO				:= 'N';
	SET Decimal_Cero		:= 0.0;

	-- Asignacion de variables
	SET Var_EstatusCredito 	:= '';
	SET Var_TasaFija		:= Decimal_Cero;
	SET Var_CicloGrupo 		:= Decimal_Cero;
	SET Var_FechaSistema	:=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

	SELECT  Sol.ClienteID ,				Sol.ProspectoID,							Sol.PlazoID,		Pro.TasaPonderaGru,
			Sol.InstitucionNominaID,	IFNULL(Sol.ConvenioNominaID,Entero_Cero)
	INTO	Var_ClienteID,   			Var_ProspectoID,							Var_PlazoID,		Var_PonderaTasa,
			Var_InstitucionNominaID, 	Var_ConvenioNominaID
	FROM SOLICITUDCREDITO Sol
	INNER JOIN PRODUCTOSCREDITO Pro ON Sol.ProductoCreditoID = Pro.ProducCreditoID
	WHERE SolicitudCreditoID = Par_SolicitudCreditoID
	  AND Sol.EsAgropecuario = Con_SI;

	IF(IFNULL(Var_ClienteID, Entero_Cero) > Entero_Cero)THEN
		SET Var_NombreCompleto	:= (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Var_ClienteID);
	ELSE
		SET Var_NombreCompleto	:= (SELECT NombreCompleto FROM PROSPECTOS WHERE ProspectoID = Var_ProspectoID);
	END IF;

	SET Var_NombreGrupo	:= (SELECT Gru.NombreGrupo
							FROM GRUPOSCREDITO Gru,
								 SOLICITUDCREDITO Sol
							WHERE Sol.GrupoID = Gru.GrupoID
							  AND Sol.SolicitudCreditoID = Par_SolicitudCreditoID);

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  := '999';
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-ROMPIMIENTOSGRUPOAGROPRO');
			SET Var_Control := 'sqlException' ;
		END;

		-- ================= VALIDACIONES GENERALES PARA EL REGISTRO DEL ROMPIMIENTO DE GRUPO ====================
		IF( IFNULL(Par_GrupoID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'Indique el Grupo.';
			SET Var_Control  := 'grupoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_Ciclo,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'Indique el Ciclo del Grupo.';
			SET Var_Control := 'cicloActual' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_SolicitudCreditoID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := '003';
			SET Par_ErrMen  := 'Indique el Numero de Solicitud de Credito.';
			SET Var_Control := 'solicitudCreditoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_UsuarioID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := 'Indique el Usuario.';
			SET Var_Control := 'usuarioID' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_SucursalID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := '005';
			SET Par_ErrMen  := 'Indique la Sucursal.';
			SET Var_Control := 'sucursalID' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_Motivo,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := '006';
			SET Par_ErrMen  := 'Indique el Motivo de Rompimiento.';
			SET Var_Control := 'motivo' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT UsuarioID FROM USUARIOS WHERE UsuarioID = Par_UsuarioID AND Estatus = Estatus_Activo) THEN
			SET Par_NumErr  := '007';
			SET Par_ErrMen  := 'El Usuario que Registra el Rompimiento No Existe.';
			SET Var_Control := 'usuarioID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT SucursalID FROM SUCURSALES WHERE SucursalID = Par_SucursalID) THEN
			SET Par_NumErr  := '008';
			SET Par_ErrMen  := 'La Sucursal No Existe.';
			SET Var_Control := 'sucursalID' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT EsAgropecuario
		INTO Var_EsAgropecuario
		FROM SOLICITUDCREDITO
		WHERE SolicitudcreditoID = Par_SolicitudCreditoID;

		SET Var_EsAgropecuario := IFNULL(Var_EsAgropecuario, Con_NO);

		IF( Var_EsAgropecuario = Con_NO ) THEN
			SET Par_NumErr  := '009';
			SET Par_ErrMen  := 'La Solicitud de Credito No es Agropecuaria, por tal motivo el rompimiento del grupo no puede realizarse.';
			SET Var_Control := 'solicitudCreditoID' ;
			LEAVE ManejoErrores;
		END IF;

		-- ============================= VALIDA LA TASA DE CREDITO GRUPAL PONDERADA ===============================
		IF( Var_PonderaTasa = PonderaTasa_SI ) THEN

			SET Var_EstatusInte	:= (SELECT Estatus FROM INTEGRAGRUPOSCRE WHERE SolicitudcreditoID = Par_SolicitudCreditoID);
			SET Var_EstatusInte	:= IFNULL(Var_EstatusInte,Estatus_Inactivo);

			UPDATE INTEGRAGRUPOSCRE    -- Se inactiva el cliente que se va a desintegrar
				SET Estatus= Estatus_Inactivo
			WHERE SolicitudcreditoID = Par_SolicitudCreditoID;

			SELECT COUNT(Ing.GrupoID) INTO Var_NumIntegrantes
			FROM INTEGRAGRUPOSCRE Ing
			INNER JOIN SOLICITUDCREDITO Sol ON Ing.SolicitudCreditoID = Sol.SolicitudCreditoID AND Sol.EsAgropecuario = Con_SI
			WHERE Ing.GrupoID = Par_GrupoID
			  AND Ing.Estatus = Estatus_Activo
			GROUP BY Ing.GrupoID;

			IF( Var_NumIntegrantes <> Entero_Cero ) THEN

				SET @Consecutivo := Entero_Cero;
				INSERT INTO TMPGRUPOTASA (
					RegistroID,
					Transaccion,		GrupoID,			SolicitudCreditoID,		EmpresaID,		Usuario,
					FechaActual,		DireccionIP,		ProgramaID,				Sucursal,		NumTransaccion)
				SELECT
					(@Consecutivo:=@Consecutivo+Entero_Uno),
					Aud_NumTransaccion,	Ing.GrupoID,		Ing.SolicitudCreditoID,	Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion
				FROM INTEGRAGRUPOSCRE Ing
				INNER JOIN SOLICITUDCREDITO Sol ON Ing.SolicitudCreditoID = Sol.SolicitudCreditoID AND Sol.EsAgropecuario = Con_SI
				WHERE Ing.GrupoID = Par_GrupoID
				  AND Ing.Estatus = Estatus_Activo;

				SELECT RegistroID
				INTO Var_MaxRegistroID
				FROM TMPGRUPOTASA
				WHERE Transaccion = Aud_NumTransaccion;

				SET Var_MaxRegistroID := IFNULL(Var_MaxRegistroID, Entero_Cero);
				SET Var_Contador := Entero_Uno;

				WHILE ( Var_Contador <= Var_MaxRegistroID ) DO

					SELECT	Sol.SolicitudCreditoID,		Sol.MontoSolici, 		Sol.SucursalID, 	Sol.NumTransacSim,	Sol.Estatus,
							Sol.MontoAutorizado,		Cli.CalificaCredito,	Sol.ClienteID,		Sol.ProspectoID,	Sol.ProductoCreditoID,
							Sol.CreditoID
					INTO	Var_SolicitudCreditoID,		Var_MontoSolici,		Var_SucursalID,		Var_NumTransacSim,	Var_Estatus,
							Var_MontoAutorizado,		Var_CalificaCredito,	Var_ClienteID,		Var_ProspectoID,	Var_ProductoCredito,
							Var_CreditoID
					FROM TMPGRUPOTASA Tmp
					INNER JOIN GRUPOSCREDITO Gru ON Tmp.GrupoID = Gru.GrupoID AND Gru.EsAgropecuario = Con_SI
					LEFT OUTER JOIN INTEGRAGRUPOSCRE Ing ON Gru.GrupoID = Ing.GrupoID AND Ing.Estatus = Estatus_Activo
					LEFT OUTER JOIN SOLICITUDCREDITO Sol ON Ing.SolicitudCreditoID = Sol.SolicitudCreditoID AND Tmp.SolicitudCreditoID = Sol.SolicitudCreditoID
					INNER JOIN CLIENTES Cli ON Cli.ClienteID = Sol.ClienteID
					WHERE Tmp.RegistroID = Var_Contador
					  AND Tmp.Transaccion = Aud_NumTransaccion;

					-- -- Solo aplica la ponderacion cuando la solicitus aun no es credito
					IF( IFNULL(Var_CreditoID, Entero_Cero) = Entero_Cero ) THEN

						SET Var_Monto := Decimal_Cero;
						IF( Var_Estatus = Estatus_Autoriza ) THEN
							SET Var_Monto := IFNULL(Var_MontoAutorizado, Decimal_Cero);
						ELSE
							SET Var_Monto := IFNULL(Var_MontoSolici, Decimal_Cero);
						END IF;

						-- -- CALCULO DEL CICLO DEL CLIENTE Y DEL GRUPO
						CALL CRECALCULOCICLOPRO(
							Var_ClienteID,		Var_ProspectoID,	Var_ProductoCredito,	Par_GrupoID,		Var_CicloCliente,
							Var_CicloGrupo,		Salida_NO,
							Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,		Aud_NumTransaccion);

						-- -- CALCULO DE LA TASA PONDERADA
						CALL ESQUEMATASACALPRO(
							Var_SucursalID, 	Var_ProductoCredito,	Var_CicloGrupo,			Var_Monto,				Var_CalificaCredito,
							Var_TasaFija, 		Var_PlazoID,			Var_InstitucionNominaID,Var_ConvenioNominaID,	Var_NivelID,
							Salida_NO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

						IF( Var_TasaFija <= Decimal_Cero ) THEN
							SET Par_NumErr  := 999;
							SET Par_ErrMen  := CONCAT('No Existe Esquema de Tasa para la Solicitud: ', CONVERT(Var_IntSolCreID, CHAR),
													' Con Ciclo: ',									   CONVERT(Par_CicloGrupo, CHAR),
													'  y Calificacion: ', 							   CASE WHEN Var_CalificaCredito = 'A' THEN 'Excelente'
																											WHEN Var_CalificaCredito = 'N' THEN 'No Asignada'
																											WHEN Var_CalificaCredito = 'B' THEN 'Buena'
																											WHEN Var_CalificaCredito = 'C' THEN 'Regular' END );
							LEAVE ManejoErrores;
						END IF;

						UPDATE SOLICITUDCREDITO SET
							TasaFija = Var_TasaFija,
							NivelID  = IFNULL(Var_NivelID,Entero_Cero),
							NumTransacSim   = Entero_Cero
						WHERE SolicitudCreditoID = Var_SolicitudCreditoID;

						UPDATE GRUPOSCREDITO SET
							CicloPonderado = Var_CicloGrupo
						WHERE GrupoID = Par_GrupoID;

						DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion  = Var_NumTransacSim;
					END IF;

					SET Var_Contador := Var_Contador + Entero_Uno;
					SET Var_Estatus				:= Cadena_Vacia;
					SET Var_CalificaCredito		:= Cadena_Vacia;
					SET Var_SolicitudCreditoID	:= Entero_Cero;
					SET Var_SucursalID			:= Entero_Cero;
					SET Var_NumTransacSim		:= Entero_Cero;
					SET Var_ClienteID			:= Entero_Cero;
					SET Var_ProspectoID			:= Entero_Cero;
					SET Var_ProductoCredito		:= Entero_Cero;
					SET Var_CreditoID			:= Entero_Cero;
					SET Var_MontoAutorizado		:= Decimal_Cero;
					SET Var_MontoSolici			:= Decimal_Cero;

				END WHILE;
			END IF;
		END IF;

		-- Se regresa a su estado anterior, para que guarde en el historico el estatus que tenia
		UPDATE INTEGRAGRUPOSCRE SET
			Estatus= Estatus_Inactivo
		WHERE SolicitudcreditoID = Par_SolicitudCreditoID;

		-- ======================== SE REGISTRAN LOS DATOS DEL ROMPIMIENTO DEL GRUPO DE CREDITO ========================
		SELECT 	Cre.CreditoID,		Sol.Estatus,				Cre.Estatus,			Sol.ProductoCreditoID,
				CASE WHEN Inte.ClienteID > Entero_Cero THEN Inte.ClienteID
					 ELSE Inte.ProspectoID
				END AS ClienteID
				INTO
				Var_CreditoID,		Var_EstatusSolicitud,		Var_EstatusCredito,		Var_ProductoCredito,
				Var_ClienteID
		FROM GRUPOSCREDITO Gru
			 LEFT OUTER JOIN INTEGRAGRUPOSCRE Inte ON Gru.GrupoID = Inte.GrupoID
			 LEFT OUTER JOIN SOLICITUDCREDITO Sol ON Inte.SolicitudCreditoID = Sol.SolicitudCreditoID
			 LEFT OUTER JOIN CREDITOS Cre ON (Inte.SolicitudCreditoID = Cre.SolicitudCreditoID  AND Inte.GrupoID = Cre.GrupoID)
		WHERE Gru.GrupoID = Par_GrupoID
		  AND Gru.CicloActual = Par_Ciclo
		  AND Inte.Estatus = Estatus_Inactivo
		  AND Sol.SolicitudCreditoID = Par_SolicitudCreditoID
		  AND Gru.EsAgropecuario = Con_SI;

		IF(IFNULL(Var_ProductoCredito, Entero_Cero) = Entero_Cero)THEN
			SET Var_ProductoCredito	:= (SELECT ProductoCreditoID FROM CREDITOS WHERE SolicitudCreditoID = Par_SolicitudCreditoID);
		END IF;

		SET Aud_FechaActual 	:= NOW();
		CALL FOLIOSAPLICAACT('ROMPIMIENTOSGRUPO', Var_RompimientoID);

		INSERT INTO ROMPIMIENTOSGRUPO(
			RompimientoID,		ClienteID,				GrupoID,				CicloActual,			SolicitudCreditoID,
			CreditoID,			EstatusSolicitud,		EstatusCredito,			ProductoCredito,		Motivo,
			Fecha,				UsuarioID,				SucursalID,
			EmpresaID,			Usuario,				FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,			NumTransaccion)
		VALUES (
			Var_RompimientoID,	Var_ClienteID,			Par_GrupoID,			Par_Ciclo,				Par_SolicitudCreditoID,
			Var_CreditoID,		Var_EstatusSolicitud,	Var_EstatusCredito,		Var_ProductoCredito,	Par_Motivo,
			Var_FechaSistema,	Par_UsuarioID,			Par_SucursalID,
			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		-- ======================== LOS DATOS DE CLIENTE DESINTEGRADO SE ENVIAN A UN HISTORICO ========================
		INSERT INTO HISINTEGRAGRUPOSROM (
			RompimientoID,			ClienteID,			ProspectoID, 		GrupoID,			Ciclo,
			SolicitudCreditoID,		Estatus,			ProrrateaPago,		FechaRegistro,		Cargo,
			EmpresaID,				Usuario,			FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,				NumTransaccion)
		SELECT
			Var_RompimientoID,		ClienteID,			ProspectoID,		GrupoID,			Ciclo,
			SolicitudCreditoID,		Estatus_Activo,		ProrrateaPago,		FechaRegistro,		Cargo,
			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion
		FROM INTEGRAGRUPOSCRE
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		-- ======================== SE ELIMINAN TODAS LAS REFERENCIAS QUE EXISTAN ENTRE EL CREDITO Y/O SOLICITUD Y EL GRUPO ========================
		DELETE FROM INTEGRAGRUPOSCRE WHERE SolicitudCreditoID = Par_SolicitudCreditoID;
		UPDATE SOLICITUDCREDITO SET
			GrupoID = Entero_Cero,
			CicloGrupo = Entero_Cero
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		UPDATE CREDITOS SET
			GrupoID = Entero_Cero,
			CicloGrupo = Entero_Cero
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		SET Par_NumErr  := '000';
		SET Par_ErrMen  := CONCAT('El  safilocale.cliente ', Var_NombreCompleto, ', Ha Sido Eliminado del Grupo ', Var_NombreGrupo, ', Exitosamente.');
		SET Var_Control := 'grupoID' ;
		LEAVE ManejoErrores;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen			 AS ErrMen,
				Var_Control			 AS control,
				Par_GrupoID	 		 AS consecutivo,
				Var_RompimientoID 	 AS consecutivoInt;
	END IF;

END TerminaStore$$
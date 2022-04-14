-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAPROYECCIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAPROYECCIONPRO`;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAPROYECCIONPRO`(
	-- Store Procedure para calcular el saldo interes a proyectar
	-- Solicitud de Credito Agro --> Registro --> Alta solicitud Credito Consolidado
	Par_FolioConsolidacionID	BIGINT(12),			-- Folio de Consolidacion
	Par_Transaccion				BIGINT(20),			-- Numero de Transaccion de la tabla en sesion
	Par_FechaProyeccion			DATE,				-- Fecha de Desembolso

	Par_Salida					CHAR(1),			-- Indica si se muestra mensaje de exito o no
	INOUT Par_NumErr			INT(11),			-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de error

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria
	Aud_Usuario					INT(11),			-- Parametro de auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal				INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_FechaSistema			DATE;			-- Fecha del Sistema
	DECLARE Var_NumRegistros			INT(11);		-- Numero de Registros Consolidados
	DECLARE Var_Contador				INT(11);		-- Contador para el Ciclo
	DECLARE Var_Control					VARCHAR(100);	-- Control de Retorno en Pantalla
	DECLARE Var_DetalleFolioConsolidaID	BIGINT(12);		-- Folio de Detalle de Consolidacion

	DECLARE Var_FolioConsolidacionID	BIGINT(12);		-- Folio de Consolidacion
	DECLARE Var_CreditoID				BIGINT(12);		-- ID de Credito
	DECLARE Var_SolicitudCreditoID		BIGINT(20);		-- ID de Solicitud de Credito
	DECLARE Var_Transaccion				BIGINT(20);		-- Numero de Transaccion
	DECLARE Var_MontoProyeccion			DECIMAL(14,2);	-- Monto de Proyeccion

	-- Declaracion de constantes
	DECLARE Fecha_Vacia			DATE;		-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(11);	-- Constante Entero en Cero
	DECLARE Entero_Uno			INT(11);	-- Constante Entero en Uno
	DECLARE Cadena_Vacia		CHAR(1);	-- Constante Cadena Vacia
	DECLARE SalidaSI			CHAR(1);	-- Constante Salida SI

	DECLARE SalidaNO			CHAR(1);	-- Constante Salida NO
	DECLARE Con_SI				CHAR(1);	-- Constante NO
	DECLARE Con_NO				CHAR(1);	-- Constante NO

	-- Asignacion de constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Cadena_Vacia			:= '';
	SET SalidaSI				:= 'S';

	SET SalidaNO				:= 'N';
	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';

	-- Bloque de Manejo de Errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECONSOLIDAPROYECCIONPRO');
			SET Var_Control := 'sqlexception';
		END;

		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT Entero_Uno);
		SET Var_FechaSistema := IFNULL(Var_FechaSistema,Fecha_Vacia);

		SET Par_Transaccion := IFNULL(Par_Transaccion,Entero_Cero);
		SET Par_FolioConsolidacionID := IFNULL(Par_FolioConsolidacionID,Entero_Cero);
		SET Par_FechaProyeccion := IFNULL(Par_FechaProyeccion, Fecha_Vacia);

		IF( Par_FolioConsolidacionID = Entero_Cero)THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Folio de Consolidacion esta Vacio.';
			SET Var_Control := 'folioConsolidaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(COUNT(FolioConsolida), Entero_Cero)
		INTO Var_FolioConsolidacionID
		FROM CREDCONSOLIDAAGROGRID
		WHERE FolioConsolida = Par_FolioConsolidacionID
		  AND Transaccion = Par_Transaccion;

		SET Var_FolioConsolidacionID := IFNULL(Var_FolioConsolidacionID, Entero_Cero);
		IF( Var_FolioConsolidacionID = Entero_Cero)THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Folio de Consolidacion No Existe.';
			SET Var_Control := 'folioConsolidaID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Transaccion = Entero_Cero)THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Numero de Transaccion esta Vacio.';
			SET Var_Control := 'numTransaccion';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FechaProyeccion = Fecha_Vacia)THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := 'la Fecha de Proyeccion esta Vacia.';
			SET Var_Control := 'fechaDesembolso';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FechaProyeccion < Var_FechaSistema)THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := 'la Fecha de Proyeccion debe ser mayor a la fecha del Sistema.';
			SET Var_Control := 'fechaDesembolso';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FechaProyeccion >= Var_FechaSistema) THEN

			IF( Par_FechaProyeccion = Var_FechaSistema ) THEN
				UPDATE CREDCONSOLIDAAGROGRID SET
					MontoProyeccion = Entero_Cero
				WHERE FolioConsolida = Par_FolioConsolidacionID
				  AND Transaccion = Par_Transaccion;
			END IF;

			IF( Par_FechaProyeccion > Var_FechaSistema ) THEN

				DELETE FROM TMPCRECONSOLIDAAGRO
				WHERE FolioConsolidaID = Par_FolioConsolidacionID
				  AND NumTransaccion = Aud_NumTransaccion;

				SET @RegistroID := Entero_Cero;
				INSERT INTO TMPCRECONSOLIDAAGRO (
					RegistroID,
					DetalleFolioConsolidaID,	FolioConsolidaID,	SolicitudCreditoID,	CreditoID,			Transaccion,
					EmpresaID,					Usuario,			FechaActual,		DireccionIP,		ProgramaID,
					Sucursal,					NumTransaccion)
				SELECT
					(@RegistroID:=@RegistroID +Entero_Uno),
					DetGridID,					FolioConsolida,		SolicitudCreditoID,	CreditoID,			Transaccion,
					Aud_EmpresaID,				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,				Aud_NumTransaccion
				FROM CREDCONSOLIDAAGROGRID
				WHERE FolioConsolida = Par_FolioConsolidacionID
				  AND Transaccion = Par_Transaccion;

				SELECT IFNULL(COUNT(RegistroID), Entero_Cero)
				INTO Var_NumRegistros
				FROM TMPCRECONSOLIDAAGRO
				WHERE FolioConsolidaID = Par_FolioConsolidacionID
				  AND NumTransaccion = Aud_NumTransaccion;

				SET Var_Contador := Entero_Uno;
				SET Var_DetalleFolioConsolidaID	:= Entero_Cero;
				SET Var_FolioConsolidacionID	:= Entero_Cero;
				SET Var_SolicitudCreditoID		:= Entero_Cero;
				SET Var_CreditoID 				:= Entero_Cero;
				SET Var_Transaccion 			:= Entero_Cero;
				SET Var_MontoProyeccion			:= Entero_Cero;

				WHILE( Var_Contador <= Var_NumRegistros ) DO

					SELECT 	DetalleFolioConsolidaID,		FolioConsolidaID,			SolicitudCreditoID,			CreditoID,
							Transaccion
					INTO 	Var_DetalleFolioConsolidaID,	Var_FolioConsolidacionID,	Var_SolicitudCreditoID,		Var_CreditoID,
							Var_Transaccion
					FROM TMPCRECONSOLIDAAGRO
					WHERE RegistroID = Var_Contador
					  AND NumTransaccion = Aud_NumTransaccion;

					SET Var_DetalleFolioConsolidaID	:= IFNULL(Var_DetalleFolioConsolidaID, Entero_Cero);
					SET Var_FolioConsolidacionID	:= IFNULL(Var_FolioConsolidacionID, Entero_Cero);
					SET Var_SolicitudCreditoID		:= IFNULL(Var_SolicitudCreditoID, Entero_Cero);
					SET Var_CreditoID 				:= IFNULL(Var_CreditoID, Entero_Cero);
					SET Var_Transaccion 			:= IFNULL(Var_Transaccion, Entero_Cero);

					-- Store Procedure de Proyeccion de Interes
					CALL PROYECCIONINTAGROCONSOLIDAPRO (
						Var_CreditoID,		Par_FechaProyeccion,	Var_MontoProyeccion,
						SalidaNO,			Par_NumErr,				Par_ErrMen,
						Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					UPDATE CREDCONSOLIDAAGROGRID SET
						MontoProyeccion = IFNULL(Var_MontoProyeccion, Entero_Cero)
					WHERE DetGridID = Var_DetalleFolioConsolidaID
					  AND FolioConsolida = Var_FolioConsolidacionID
					  AND Transaccion = Var_Transaccion;

					SET Var_DetalleFolioConsolidaID	:= Entero_Cero;
					SET Var_FolioConsolidacionID	:= Entero_Cero;
					SET Var_SolicitudCreditoID		:= Entero_Cero;
					SET Var_CreditoID 				:= Entero_Cero;
					SET Var_Transaccion 			:= Entero_Cero;
					SET Var_MontoProyeccion			:= Entero_Cero;
					SET Var_Contador 				:= Var_Contador + Entero_Uno;

				END WHILE;

				DELETE FROM TMPCRECONSOLIDAAGRO
				WHERE FolioConsolidaID = Par_FolioConsolidacionID
				  AND NumTransaccion = Aud_NumTransaccion;
			END IF;
		END IF;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= 'Proyeccion Realizada Correctamente0';
		SET Var_Control	:= 'folioConsolidacionID';

	END ManejoErrores;
	-- Fin Bloque de Manejo de Errores

	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_FolioConsolidacionID AS consecutivo;
	END IF;

END TerminaStore$$
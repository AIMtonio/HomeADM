-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAEXCLUSIONESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAEXCLUSIONESALT`;

DELIMITER $$
CREATE PROCEDURE `BITACORAEXCLUSIONESALT`(
	-- Store Procedure de Alta en la Bitacora de Exclusiones o rompimiento de Grupos
	-- Modulo Web Service
	Par_RompimientoID 			INT(11),		-- Numero de Rompimiento de Grupo
	Par_ClienteID				INT(11),		-- Numero de Cliente
	Par_CreditoID				BIGINT(20),		-- Numero de Credito
	Par_GrupoID					INT(11),		-- Numero de Grupo
	Par_CicloID 				INT(11),		-- Numero de Ciclo del Grupo

	Par_DeudaGrupal 			DECIMAL(14,2),	-- Deuda Grupal
	Par_UsuarioRegistroID		INT(11),		-- Usuario que Registra el Rompimiento de Grupo
	Par_SucursalRegistroID		INT(11),		-- Sucursal que Registra el Rompimiento de Grupo

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Parametro Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Parametro Mensaje de Error

	Aud_EmpresaID				INT(11),		-- Parámetro de auditoria ID de la Empresa
	Aud_Usuario					INT(11),		-- Parámetro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parámetro de auditoria Fecha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parámetro de auditoria Direcciion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parámetro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parámetro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parámetro de auditoria Número de la transaccion
)
TerminaStore:BEGIN

	-- Declaracion de Parametros
	DECLARE Par_BitacoraExclusionesID	BIGINT(20);		-- ID de Tabla
	DECLARE Par_FechaRegistro 			DATE;			-- Fecha de Registro del Rompimiento del Grupo
	DECLARE Par_ExigibleIndividual		DECIMAL(14,2);	-- Exigible del Credito que se Excluye

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(100); 	-- Control de Retorno en Pantalla
	DECLARE Var_ClienteID		INT(11);		-- Numero de Cliente
	DECLARE Var_CreditoID		BIGINT(12);		-- Numero de Credito
	DECLARE Var_GrupoID 		INT(11);		-- Numero de Grupo
	DECLARE Var_RompimientoID 	INT(11);		-- Numero de Rompimiento
	DECLARE Var_Valida 			INT(11);		-- Validador de Rompimiento

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Entero_Uno			INT(11);		-- Constante Entero Uno
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Constante Decimal Cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia

	DECLARE Salida_SI			CHAR(1);		-- Constante Salida SI

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Decimal_Cero		:= 0.0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';

	SET Salida_SI			:= 'S';

	SELECT IFNULL(FechaSistema, Fecha_Vacia)
	INTO Par_FechaRegistro
	FROM PARAMETROSSIS LIMIT 1;

	-- Se validan parametros nulos
	SET Par_BitacoraExclusionesID := Entero_Cero;
	SET Par_ClienteID 			  := IFNULL(Par_ClienteID , Entero_Cero);
	SET Par_CreditoID			  := IFNULL(Par_CreditoID , Entero_Cero);
	SET Par_GrupoID 			  := IFNULL(Par_GrupoID , Entero_Cero);
	SET Par_CicloID 			  := IFNULL(Par_CicloID , Entero_Cero);
	SET Par_UsuarioRegistroID	  := IFNULL(Par_UsuarioRegistroID , Entero_Cero);
	SET Par_SucursalRegistroID	  := IFNULL(Par_SucursalRegistroID , Entero_Cero);

	-- Bloque de Manejo de Errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := '999';
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-BITACORAEXCLUSIONESALT');
				SET Var_Control := 'SQLEXCEPTION' ;
			END;

		IF( Par_CreditoID = Entero_Cero ) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Numero de Credito esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_GrupoID = Entero_Cero ) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Numero de Grupo de Credito esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CicloID = Entero_Cero ) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Numero de Ciclo del Grupo esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ClienteID = Entero_Cero ) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := 'El Numero de Cliente esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_RompimientoID = Entero_Cero ) THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := 'El Numero de Rompimiento esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		SELECT ClienteID
		INTO Var_ClienteID
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID;

		SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);

		IF( Var_ClienteID = Entero_Cero ) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := 'El Cliente no Existe.';
			LEAVE ManejoErrores;
		END IF;

		SELECT CreditoID
		INTO Var_CreditoID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);

		IF( Var_CreditoID = Entero_Cero ) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Cliente no Existe.';
			LEAVE ManejoErrores;
		END IF;

		SELECT GrupoID
		INTO Var_GrupoID
		FROM GRUPOSCREDITO
		WHERE GrupoID = Par_GrupoID;

		SET Var_GrupoID := IFNULL(Var_GrupoID, Entero_Cero);

		IF( Var_GrupoID = Entero_Cero ) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Grupo de Credito no Existe.';
			LEAVE ManejoErrores;
		END IF;

		SELECT RompimientoID
		INTO Var_RompimientoID
		FROM ROMPIMIENTOSGRUPO
		WHERE RompimientoID = Par_RompimientoID;

		SET Var_RompimientoID := IFNULL(Var_RompimientoID, Entero_Cero);

		IF( Var_RompimientoID = Entero_Cero ) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Numero de Rompimiento de Grupo no Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_DeudaGrupal = Decimal_Cero ) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := CONCAT('El Exigible del Grupo ', Par_GrupoID,' Esta Vacio.');
			LEAVE ManejoErrores;
		END IF;

		-- Exigible Individual
		SET Par_ExigibleIndividual := IFNULL(FUNCIONTOTDEUDACRE(Par_CreditoID), Decimal_Cero);

		IF( Par_ExigibleIndividual = Decimal_Cero ) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := CONCAT('El Exigible del Credito ', Par_CreditoID ,' Esta Vacio.');
			LEAVE ManejoErrores;
		END IF;

		-- Se valida si el credito ya fue excluido del grupo
		SET Var_Valida := Entero_Cero;

		SELECT IFNULL( COUNT(BitacoraExclusionesID), Entero_Cero)
		INTO Var_Valida
		FROM BITACORAEXCLUSIONES
		WHERE ClienteID = Par_CreditoID
		  AND CreditoID = Par_ClienteID
		  AND GrupoID = Par_GrupoID
		  AND CicloID = Par_CicloID;

		IF( Var_Valida <> Entero_Cero ) THEN
			SET Par_NumErr  := 6;
			SET Par_ErrMen  := CONCAT('El Credito ', Par_CreditoID ,' del Grupo ',Par_GrupoID,' con N. Ciclo ',Par_CicloID,
									  ' Relacionado al Cliente ',Par_ClienteID, ' Ya se encuentra Excluido.');
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(MAX(BitacoraExclusionesID), Entero_Cero) + Entero_Uno
		INTO Par_BitacoraExclusionesID
		FROM BITACORAEXCLUSIONES FOR UPDATE;
		SET Aud_FechaActual := NOW();

		INSERT INTO BITACORAEXCLUSIONES(
			BitacoraExclusionesID,		RompimientoID,			FechaRegistro,			ClienteID,			CreditoID,
			GrupoID,					CicloID,				ExigibleIndividual,		DeudaGrupal,		UsuarioRegistroID,
			SucursalRegistroID,
			EmpresaID,					Usuario,				FechaActual,			DireccionIP,		ProgramaID,
			Sucursal,					NumTransaccion)
		VALUES(
			Par_BitacoraExclusionesID,	Par_RompimientoID,		Par_FechaRegistro,		Par_ClienteID,		Par_CreditoID,
			Par_GrupoID,				Par_CicloID,			Par_ExigibleIndividual,	Par_DeudaGrupal,	Par_UsuarioRegistroID,
			Par_SucursalRegistroID,
			Aud_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion);

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Bitacora de Exclusion Registrada Correctamente';

	END ManejoErrores;
	-- Fin Bloque de Manejo de Errores

	IF( Par_Salida = Salida_SI ) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen	AS ErrMen,
				Par_BitacoraExclusionesID AS consecutivo;
	END IF;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSBLOQPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSBLOQPRO`;
DELIMITER $$

CREATE PROCEDURE `USUARIOSBLOQPRO`(
# =====================================================================================
# ------- STORE PARA REALIZAR BLOQUEOS MASIVA SE USUARIO DESPUES DE SU ULTIMA SESSION ---------
# =====================================================================================
	Par_NumPro			TINYINT UNSIGNED,	-- Numero de Proceso que realizara

	Par_Salida			CHAR(1),			-- Campo a la qu hace referencia
	INOUT Par_NumErr	INT(11),			-- Parametro del numero de Error
	INOUT Par_ErrMen	VARCHAR(400),		-- Parametro del Mensaje de Error

	Aud_EmpresaID		INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);	-- Variable de Control
	DECLARE Var_HabilitaConfPass	CHAR(1);		-- Variable para Guardar Llave Parametro: Indica si la contrasenia requiere configuracion
	DECLARE Var_NumDiaBloq			INT(11);		-- Variable para
	DECLARE Var_ContContra			INT(11);		-- Variable para hacer el contador de Contrasenia de Usuario en el ciclo While para validacion d elas ultimas contrasenia permitidas 
	DECLARE Var_CantUsuaContra		INT(11);		-- Variable para saber la cantidad total de Contraseña del usuario Utilizada ultimamente con la que se hará el cilo While
	DECLARE Var_UsuarioID			INT(11);		-- Variable para gaurdar el numero de usuario
	DECLARE Var_FecActual			DATE; 			-- Variable para guardar  la fecha del sistema
	DECLARE Var_Clave				VARCHAR(40);	-- Variable para guardar la clave del usuario

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero				INT;			-- Entero Cero
	DECLARE Con_SalidaSI			CHAR(1);		-- Salida Si
	DECLARE Con_SalidaNo			CHAR(1);		-- Salida NO
	DECLARE Pro_BloqAutoUsuario		INT(11);		-- Actualizacion de bloqueos automaticos del usuarios por fecha ultimo acceso
	DECLARE HabilitaConfPass		VARCHAR(100);	-- Llave Parametro: Indica si la contrasenia requiere configuracion
	DECLARE MotivoBloqueo			VARCHAR(45);	-- Motivo de bloqueo por exeder los dia limite parametrizada por falta d einicio d esesion
	DECLARE	Sta_Bloquea				CHAR(1);		-- Estatus Bloqueado
	DECLARE	Sta_Activa				CHAR(1);					-- Estatus Activa
	DECLARE Var_NumAct				INT(11);		-- NUmero de actualizacion d ebloqueo
	DECLARE	Str_SI					CHAR(1);		-- Constante SI
	DECLARE	Str_NO					CHAR(1);		-- Constante NO

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET Con_SalidaSI			:= 'S';				-- Salida Si
	SET Con_SalidaNo			:= 'N';				-- Salida NO
	SET Pro_BloqAutoUsuario		:= 1;				-- Actualizacion de bloqueos automaticos del usuarios por fecha ultimo acceso
	SET HabilitaConfPass		:= 'HabilitaConfPass';		-- Llave Parametro: Indica si la contrasenia requiere configuracion
	SET MotivoBloqueo			:= 'Bloqueos Automatico';	-- Motivo de bloqueo por exeder los dia limite parametrizada por falta d einicio d esesion
	SET	Sta_Bloquea				:= 'B';						-- Estatus Bloqueado
	SET	Sta_Activa				:= 'A';						-- Estatus Activa
	SET Var_NumAct				:= 2;						-- NUmero de actualizacion d ebloqueo
	SET	Str_SI					:= 'S';						-- Constante SI
	SET	Str_NO					:= 'N';						-- Constante NO

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-USUARIOSBLOQPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

	IF(Par_NumPro = Pro_BloqAutoUsuario) THEN

		-- COnsultamos si la contraseña requiere Validacion por configuracion
		SET Var_HabilitaConfPass := (SELECT ValorParametro FROM PARAMGENERALES WHERE LLaveParametro = HabilitaConfPass);
		SET Var_HabilitaConfPass := IFNULL(Var_HabilitaConfPass,Str_NO);

		-- SI la configuracion del pasword se encuentra marcada como S=  Se realiza la validacion con el parametro configurado 
		-- por el usuario para poder realizar por el días que pasarán después del último acceso al sistema para que el usuario se bloquee automáticamente.
		IF(Var_HabilitaConfPass = Str_SI) THEN

			SELECT NumDiaBloq,	FechaSistema
				INTO Var_NumDiaBloq, Var_FecActual
				FROM PARAMETROSSIS
				LIMIT 1;

			SET Var_NumDiaBloq	:= IFNULL(Var_NumDiaBloq, Entero_Cero);

			-- Borramos la tabla temporal
			DELETE FROM TMPUSUARIOS;

			INSERT INTO TMPUSUARIOS (	UsuarioID,		Contrasenia,		Clave,			EmpresaID,		Usuario,
										FechaActual,	DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
				SELECT	UsuarioID,			Contrasenia,		Clave,				Aud_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
					FROM USUARIOS
					WHERE IF(FechUltimAcces <> Fecha_Vacia,DATEDIFF(NOW(), FechUltimAcces),Entero_Cero) > Var_NumDiaBloq
					AND Estatus = Sta_Activa;

			SELECT	Entero_Cero, COUNT(TmpUsuarioID)
				INTO Var_ContContra, Var_CantUsuaContra
				FROM TMPUSUARIOS;

			-- Hacemos un loop while para ir Validando por cada contrasenia
			WHILE Var_ContContra <= Var_CantUsuaContra DO

				SELECT UsuarioID,		Clave
					INTO Var_UsuarioID,		Var_Clave
					FROM TMPUSUARIOS
					WHERE TmpUsuarioID = Var_ContContra;

				SET Var_UsuarioID		:= IFNULL(Var_UsuarioID, Entero_Cero);

				-- Ejecutamos el sp d ebloqueo de usuario
				CALL USUARIOSACT (Var_UsuarioID,		Var_Clave,				Sta_Bloquea,		MotivoBloqueo,		Var_FecActual,
								Cadena_Vacia,			Fecha_Vacia,			Cadena_Vacia,		Entero_Cero,		Cadena_Vacia,
								Fecha_Vacia,			Var_NumAct,				Con_SalidaNo,		Par_NumErr,			Par_ErrMen,
								Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
								Aud_Sucursal,			Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				SET Var_ContContra := Var_ContContra + 1;
			END WHILE;

			-- Borramos la tabla temporal
			DELETE FROM TMPUSUARIOS;
		END IF;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	CONCAT( 'Proceso Realizado Exitosamente.');
		SET Var_Control		:=	'usuarioID';
	END IF;

END ManejoErrores;

	IF (Par_Salida = Con_SalidaSI) THEN
		SELECT Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS Control;
	END IF;

END TerminaStore$$
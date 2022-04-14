DELIMITER ;
DROP PROCEDURE IF EXISTS BITACORACICLOSGRUPALPRO;

DELIMITER $$
CREATE PROCEDURE BITACORACICLOSGRUPALPRO(
	-- Descripcion	= Procedimiento que se utiliza para almacenar la bitacora de los grupos de creditos
	-- Modulo		= Cartera Grupal
	Par_GrupoID				INT(11),			-- Parametro del numero de grupo de credito

	Par_Salida				CHAR(1),			-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),			-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control			VARCHAR(20);		-- Variable de Control
	DECLARE Var_FechaSistema	DATE;				-- Variable para almacenar al fecha del sistema
	DECLARE Var_RegistroID		INT(11);			-- Variable para almacenar el registro consecutivo
	DECLARE Var_ExisteRegistro	INT(11);			-- Variable para almacenar si existe el registro en la bitacora

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante: Cadena vacia
	DECLARE	Fecha_Vacia			DATE;				-- Constante: Fecha vacia
	DECLARE	Entero_Cero			INT;				-- Constante: Entero cero
	DECLARE Salida_SI 			CHAR(1);			-- Constante: Salida SI
	DECLARE Salida_NO			CHAR(1);			-- Constante: Salida NO

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';
	SET Aud_FechaActual 		:= NOW();

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BITACORACICLOSGRUPALPRO');
				SET Var_Control	:= 'SQLEXCEPTION';
		END;

		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

		IF(IFNULL(Par_GrupoID, Entero_Cero)) = Entero_Cero	THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El Grupo de Credito se encuentra vacio';
			SET Var_Control		:= 'grupoID';
			LEAVE ManejoErrores;
		END IF;

		-- Generamos el registro consecutivo
		SET Var_RegistroID := (SELECT IFNULL(MAX(RegistroID),Entero_Cero) + 1 FROM BITACORACICLOSGRUPAL);

		-- Validamos si existe un registro del grupo con la misma fecha
		SELECT	COUNT(RegistroID)
		INTO	Var_ExisteRegistro
		FROM BITACORACICLOSGRUPAL
		WHERE GrupoID = Par_GrupoID
			AND FechaRegistro = Var_FechaSistema;

		-- Validacion de datos nulos
		SET Var_ExisteRegistro := IFNULL(Var_ExisteRegistro, Entero_Cero);

		-- Cuando existe el registro en la bitacora
		IF(Var_ExisteRegistro > Entero_Cero)THEN
			-- Actualizamos el registro
			UPDATE BITACORACICLOSGRUPAL SET
				GrupoID				= Par_GrupoID,
				FechaRegistro		= Var_FechaSistema,
				EmpresaID			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE GrupoID = Par_GrupoID
				AND FechaRegistro = Var_FechaSistema;
		END IF;
		-- Cuando no existe registro en la bitacora
		IF(Var_ExisteRegistro = Entero_Cero)THEN
			INSERT INTO BITACORACICLOSGRUPAL(
				RegistroID,			GrupoID,			FechaRegistro,		EmpresaID,		Usuario,
				FechaActual,		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion
				)
			VALUES(
				Var_RegistroID,		Par_GrupoID,		Var_FechaSistema,	Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
				);
		END IF;

		SET	Par_NumErr	:= 0;
		SET	Par_ErrMen	:= CONCAT('Proceso Realizado Exitosamente: ', CONVERT(Par_GrupoID,CHAR));
		SET Var_Control	:= 'registroID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Entero_Cero AS Consecutivo;
	END IF;
END TerminaStore$$
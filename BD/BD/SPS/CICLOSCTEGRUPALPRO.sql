DELIMITER ;
DROP PROCEDURE IF EXISTS CICLOSCTEGRUPALPRO;

DELIMITER $$
CREATE PROCEDURE CICLOSCTEGRUPALPRO(
	-- Descripcion	= Procedimiento que se utiliza para almacenar el cliclo de cliente/prospecto
	-- Modulo		= Cartera Grupal
	Par_ClienteID			INT(11),			-- Parametro del numero de cliente
	Par_ProspectoID			INT(11),			-- Parametro del ID de prospecto
	Par_CicloBase			INT(11),			-- Parametro del ciclo del cliente
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
	DECLARE Var_ExisteCliente	INT(11);			-- Variable para almacenar si existe el cliente o prospecto
	DECLARE Var_SolicitudID		BIGINT(20);			-- Variable para almacenar el identificador de la solicitud de credito

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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CICLOSCTEGRUPALPRO');
				SET Var_Control	:= 'SQLEXCEPTION';
		END;

		IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
			IF (IFNULL(Par_ProspectoID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr		:= 001;
				SET Par_ErrMen		:= 'Especificar al menos un participante.';
				SET Var_Control		:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_ProspectoID := IFNULL(Par_ProspectoID, Entero_Cero);

		IF (IFNULL(Par_CicloBase, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'El Ciclo del cliente debe ser mayor a cero.';
			SET Var_Control		:= 'cicloBase';
			LEAVE ManejoErrores;
		END IF;

		-- Cuando el cliente es mayor a cero, seteamos el vamor del prospecto en cero
		IF(Par_ClienteID > Entero_Cero)THEN
			SET Par_ProspectoID := Entero_Cero;
		ELSE
			SET Par_ClienteID := Entero_Cero;
		END IF;

		-- Consultamos si existe el cliente
		SELECT	COUNT(CicloBase)
		INTO	Var_ExisteCliente
		FROM CICLOSCTEGRUPAL
		WHERE ClienteID = Par_ClienteID
			AND ProspectoID = Par_ProspectoID;

		-- Obtenemos la solicitud del participante en curso
		SELECT	SolicitudCreditoID
		INTO	Var_SolicitudID
		FROM INTEGRAGRUPOSCRE
		WHERE GrupoID = Par_GrupoID
			AND ClienteID = Par_ClienteID
			AND ProspectoID = Par_ProspectoID
		LIMIT 1;

		-- Validamos datos nulos
		SET Var_ExisteCliente	:= IFNULL(Var_ExisteCliente, Entero_Cero);
		SET Var_SolicitudID		:= IFNULL(Var_SolicitudID, Entero_Cero);

		-- Actualizamos el nuevo ciclo en la tabla de integrantes
		UPDATE INTEGRAGRUPOSCRE
			SET
				Ciclo			= Par_CicloBase,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
		WHERE GrupoID = Par_GrupoID
			AND SolicitudCreditoID = Var_SolicitudID;

		-- Cuando existe el cliente, solo actualizamos el registro
		IF(Var_ExisteCliente > Entero_Cero)THEN
			-- Actualizamos el registro
			UPDATE CICLOSCTEGRUPAL SET
				CicloBase			= Par_CicloBase,
				EmpresaID			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE ClienteID = Par_ClienteID
				AND ProspectoID = Par_ProspectoID;
		END IF;
		-- Cuando no existe el cliente
		IF(Var_ExisteCliente = Entero_Cero)THEN
			INSERT INTO CICLOSCTEGRUPAL(
				ClienteID,			ProspectoID,		CicloBase,		EmpresaID,		Usuario,
				FechaActual,		DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion
				)
			VALUES(
				Par_ClienteID,		Par_ProspectoID,	Par_CicloBase,	Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
				);
		END IF;

		-- Realizamos la llamada para la bitacora
		CALL BITACORACICLOSGRUPALPRO(
			Par_GrupoID,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion
			);
		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET	Par_NumErr	:= 0;
		SET	Par_ErrMen	:= CONCAT('Proceso Realizado Exitosamente: ', CONVERT(Par_CicloBase,CHAR));
		SET Var_Control	:= 'cicloCliente';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Entero_Cero AS Consecutivo;
	END IF;
END TerminaStore$$
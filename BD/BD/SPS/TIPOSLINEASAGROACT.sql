-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSLINEASAGROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSLINEASAGROACT`;

DELIMITER $$
CREATE PROCEDURE `TIPOSLINEASAGROACT`(
	-- Store procedure para la Actualizacion de Tipos de lineas de credito
	-- Modulo Cartera --> Registro --> Tipos Lineas Credito
	Par_TipoLineaAgroID			INT(11),			-- ID del tipo de linea
	Par_NumActualizacion		TINYINT UNSIGNED,	-- Numero de Actualizacion

	Par_Salida					CHAR(1),			-- indica una salida
	INOUT Par_NumErr			INT(11),			-- numero de error
	INOUT Par_ErrMen			VARCHAR(400),		-- mensaje de error

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- Declacion de Variables
	DECLARE Var_Control			VARCHAR(100);		-- Variable de control
	DECLARE Var_TipoLineaAgroID	INT(11);			-- Numero de Tipo de Linea Agro
	DECLARE Var_FechaSistema	DATE; 				-- Variable Fecha del Sistema
	DECLARE Var_UsuarioBaja     INT(11);            -- Variable para almacenar un usuario

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);			-- Constante entero cero
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia
	DECLARE Salida_SI			CHAR(1);			-- Constante salida si
	DECLARE Salida_NO			CHAR(1);			-- Constante salida no
	DECLARE Con_SI				CHAR(1);			-- Constante si

	DECLARE Con_NO				CHAR(1);			-- Constante no
	DECLARE Est_Inactiva		CHAR(1);			-- Constante Estatus Inactiva
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante Decimal cero
	DECLARE Fecha_Vacia			DATE;				-- Constante fecha vacia

	-- Declaracion de Actualizaciones
	DECLARE Act_InactivarLinea	TINYINT UNSIGNED;	-- Actualizacion a inactiva

	-- Asignacion de constantes
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';
	SET Con_SI					:= 'S';

	SET Con_NO					:= 'N';
	SET Est_Inactiva			:= 'I';
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia				:= '1900-01-01';

	-- Asignacion de Actualizaciones
	SET Act_InactivarLinea		:= 1;

	SET Par_NumActualizacion	:= IFNULL(Par_NumActualizacion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr 	:= 999;
			SET Par_ErrMen 	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-TIPOSLINEASAGROACT');
			SET Var_Control := 'sqlException';
		END;

		IF( Par_NumActualizacion = Act_InactivarLinea ) THEN

			-- Asignamos valor por defaul a varibles
			SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
			SET Par_TipoLineaAgroID	:= IFNULL(Par_TipoLineaAgroID, Entero_Cero);

			IF( Par_TipoLineaAgroID = Entero_Cero ) THEN
				SET Par_NumErr  := 001;
				SET Par_ErrMen  := 'El Tipo de linea Agro esta vacio.';
				SET Var_Control := 'tipoLineaAgroID';
				LEAVE ManejoErrores;
			END IF;

			SELECT TipoLineaAgroID
			INTO Var_TipoLineaAgroID
			FROM TIPOSLINEASAGRO
			WHERE TipoLineaAgroID = Par_TipoLineaAgroID;

			SET Var_TipoLineaAgroID	:= IFNULL(Var_TipoLineaAgroID, Entero_Cero);

			IF( Var_TipoLineaAgroID = Entero_Cero ) THEN
				SET Par_NumErr  := 002;
				SET Par_ErrMen  := 'El Tipo de linea Agro no Existe.';
				SET Var_Control := 'tipoLineaAgroID';
				LEAVE ManejoErrores;
			END IF;

			SELECT UsuarioID
			INTO Var_UsuarioBaja
			FROM USUARIOS
			WHERE UsuarioID = Aud_Usuario;

			SET Var_UsuarioBaja	:= IFNULL(Var_UsuarioBaja, Entero_Cero);

			IF( Var_UsuarioBaja = Entero_Cero ) THEN
				SET Par_NumErr  := 003;
				SET Par_ErrMen  := 'Usuario para dar de baja no existe.';
				SET Var_Control := 'tipoLineaAgroID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE TIPOSLINEASAGRO SET
				UsuarioBaja			= Var_UsuarioBaja,
				FechaBaja			= Var_FechaSistema,
                Estatus             = Est_Inactiva,
				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE TipoLineaAgroID = Par_TipoLineaAgroID;

			SET Par_NumErr	:= Entero_Cero;
			SET	Par_ErrMen	:= CONCAT('Tipo Linea Agro Dada de Baja Exitosamente: ',CONVERT(Par_TipoLineaAgroID,CHAR));
			SET Var_Control	:= 'tipoLineaAgroID';
			LEAVE ManejoErrores;

		END IF;
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_TipoLineaAgroID AS Consecutivo;
	END IF;

END TerminaStore$$
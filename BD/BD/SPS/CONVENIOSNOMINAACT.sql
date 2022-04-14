-- SP CONVENIOSNOMINAACT

DELIMITER ;

DROP PROCEDURE IF EXISTS CONVENIOSNOMINAACT;

DELIMITER $$

CREATE PROCEDURE `CONVENIOSNOMINAACT`(
-- SP PARA LA ACTUALIZAR UN REGISTRO DE CONVENIO DE UNA EMPRESA DE NOMINA
	Par_ConvenioNominaID		BIGINT UNSIGNED,							-- Identificador del convenio

	Par_NumAct 					TINYINT UNSIGNED, 							-- Numero de Actualizacion

	Par_Salida					CHAR(1),									-- Salida Si o No
	INOUT Par_NumErr			INT(11),									-- Parametro de salida numero de error
	INOUT Par_ErrMen			VARCHAR(400),								-- Parametro de salida mensaje de error

	Aud_EmpresaID				INT(11),									-- Parametro de Auditoria
	Aud_Usuario					INT(11),									-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,									-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),								-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),								-- Parametro de Auditoria
	Aud_Sucursal				INT(11),									-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)									-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);								-- Variable de control
	DECLARE Var_FechaSistema	DATETIME;									-- Valor para el campo FechaSistema de PARAMETROSSIS

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);									-- Constante para Cadena Vacia
	DECLARE Decimal_Cero		DECIMAL(12,2);								-- Constante para Decimal Cero
	DECLARE Fecha_Vacia			DATE;										-- Constante para Fecha Vacia
	DECLARE Entero_Cero			INT(1);										-- Constante entero cero
	DECLARE Entero_Uno			INT(1);										-- Constante entero uno
	DECLARE SalidaSI			CHAR(1);									-- Salida si
	DECLARE SalidaNO			CHAR(1);									-- Salida no
	DECLARE Est_Act				CHAR(1);									-- Constante de Estatus Activo de Convenio de Nomina
	DECLARE Est_Venc			CHAR(1);									-- Constante de Estatus Vencido de Convenio de Nomina
	DECLARE Var_ActAct			INT(1);										-- Constante del numero de actualizacion a estatus activo
	DECLARE Var_ActVenc			INT(1);										-- Constante del numero de actualizacion a estatus vencido
	DECLARE Var_ActProg			INT(1);										-- Constante del numero de actualizacion para descontar no. de actualizacion
	DECLARE Var_MotivoEstAct	VARCHAR(33);								-- Constante Motivo de Estatus en Activacion Automatica
	DECLARE Var_MotivoEstVenc	VARCHAR(29);								-- Constante Motivo de Estatus en Vencimiento Automatico
	DECLARE Var_NombreUsuario	VARCHAR(16);								-- Constante nombre usuario virtual

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';										-- Cadena Vacia
	SET Decimal_Cero            := 0.0;  								    -- Decimal Cero
	SET Fecha_Vacia 			:= '1900-01-01';							-- Fecha Vacia
	SET Entero_Cero 			:= 0;										-- Entero Cero
	SET Entero_Uno				:= 1;										-- Entero Uno
	SET SalidaSI				:= 'S';										-- Asignacion de salida si
	SET SalidaNO				:= 'N';										-- Asignacion de salida no
	SET Var_Control				:= '';										-- Control de Errores
	SET Est_Act					:= 'A';										-- Asignacion constante de Estatus Cancelada de Convenio de Nomina
	SET Est_Venc				:= 'V';										-- Asignacion constante de Estatus Vencido de Convenio de Nomina
	SET Var_ActAct				:= 1;										-- Asignacion de constante del numero de actualizacion a estatus activo
	SET Var_ActVenc				:= 2;										-- Asignacion de constante del numero de actualizacion a estatus vencido
	SET Var_ActProg				:= 3;										-- Asignacion de constante del numero de actualizacion para descontar no. de actualizacion
	SET Var_MotivoEstAct		:= 'SE ACTIVA POR PROCESO AUTOMATICO';		-- Constante Motivo de Estatus en Activacion Automatica
	SET Var_MotivoEstVenc		:= 'VENCE POR PROCESO AUTOMATICO';			-- Constante Motivo de Estatus en Vencimiento Automatico
	SET Var_NombreUsuario		:= 'USUARIO VIRTUAL';						-- Constante nombre usuario virtual

	-- Asignacion de valores por defecto
	SET Par_ConvenioNominaID		:= IFNULL(Par_ConvenioNominaID, Entero_Cero);

	SET Aud_EmpresaID				:= IFNULL(Aud_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					'esto le ocasiona. Ref: SP-CONVENIOSNOMINAACT');
				SET Var_Control	= 'SQLEXCEPTION';
			END;

			-- Validaciones
			IF (Par_ConvenioNominaID = Entero_Cero) THEN
				SET Par_NumErr 	:= 001;
				SET Par_ErrMen	:= 'El numero de convenio se encuentra vacio';
				SET Var_Control	:= 'convenioNominaID';
				LEAVE ManejoErrores;
			END IF;

			SELECT		FechaSistema
				INTO	Var_FechaSistema
				FROM PARAMETROSSIS;

			-- Act 1 Actualizacion a estatus Activo en proceso automatico de activacion ACTIVABAJACONVPRO
			IF (Par_NumAct = Var_ActAct) THEN
				UPDATE CONVENIOSNOMINA SET
					Estatus				= Est_Act,
					NumActualizaciones	= NumActualizaciones + Entero_Uno,

					EmpresaID			= Aud_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
					WHERE	convenioNominaID = Par_ConvenioNominaID;
			END IF;

			-- Act 2 Actualizacion a estatus Vencido en proceso automatico de activacion ACTIVABAJACONVPRO
			IF (Par_NumAct = Var_ActVenc) THEN
				UPDATE CONVENIOSNOMINA SET
					Estatus				= Est_Venc,
					NumActualizaciones	= NumActualizaciones + Entero_Uno,

					EmpresaID			= Aud_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
					WHERE	convenioNominaID = Par_ConvenioNominaID;
			END IF;

			SET	Par_NumErr	:= Entero_Cero ;
			SET Par_ErrMen	:= CONCAT('Convenio de Empresa de Nomina Actualizado Exitosamente: ', Par_ConvenioNominaID);
			SET Var_Control := Cadena_Vacia;

			-- Act 3 Actualizacion de descuento de numero de actualizacion al entrar en vigor por primera vez una programacion de convenio en lapso de dias inhabiles
			IF (Par_NumAct = Var_ActProg) THEN
				UPDATE CONVENIOSNOMINA SET
					NumActualizaciones	= NumActualizaciones - Entero_Uno,

					EmpresaID			= Aud_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
					WHERE	convenioNominaID = Par_ConvenioNominaID;
			END IF;

			SET	Par_NumErr	:= Entero_Cero ;
			SET Par_ErrMen	:= CONCAT('Convenio de Empresa de Nomina Actualizado Exitosamente: ', Par_ConvenioNominaID);
			SET Var_Control := Cadena_Vacia;

    END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$
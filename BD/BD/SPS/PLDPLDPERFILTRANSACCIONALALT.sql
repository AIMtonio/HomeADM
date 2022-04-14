-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPLDPERFILTRANSACCIONALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPLDPERFILTRANSACCIONALALT`;
DELIMITER $$


CREATE PROCEDURE `PLDPLDPERFILTRANSACCIONALALT`(
	-- SP para dar de Alta el Perfil Transaccional.
	Par_ClienteIDExt		        VARCHAR(20),	            -- CLIENTE ID EXTERNO
	Par_DepositosMax				DECIMAL(16,2),				-- Monto Maximo de Deposito por transaccion
	Par_RetirosMax					DECIMAL(16,2),				-- Monto Maximo de Retiros por Transaccion
	Par_NumDepositos				INT(11),					-- Numero Maximo de depositos
	Par_NumRetiros					INT(11),					-- Numero Maximo de Retiros

	Par_CatOrigenRecID				INT(11),					-- ID Del Origen de los Recursos CATPLDORIGENREC
	Par_CatDestinoRecID				INT(11),					-- ID del Destino de los recursos CATPLDDESTINOREC
	Par_ComentarioOrigenRec			VARCHAR(200),				-- Comentario Sobre el Origen de los Recursos
	Par_ComentarioDestRec			VARCHAR(200),				-- Comentario Sobre el Destino de los Recursos
	Par_Salida						CHAR(1),					-- Indica el tipo de salida S.- SI N.- No

	INOUT Par_NumErr				INT,						-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				-- Mensaje de Error
	-- Parametros de Auditoria
	Aud_EmpresaID					INT(11),					-- Parametro de Auditoria
	Aud_Usuario						INT(11),					-- Parametro de Auditoria
	Aud_FechaActual					DATETIME,					-- Parametro de Auditoria

	Aud_DireccionIP					VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID					VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal					INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion				BIGINT(12)					-- Parametro de Auditoria
)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_Consecutivo 		VARCHAR(200);				-- Numero consecutivo para la imagen a digitalizar
	DECLARE Var_FechaRegistro 		DATE;						-- Fecha en la que se digitalizo el Archivo
	DECLARE Var_TipoProceso			CHAR(1);					-- Tipo de Proceso a realizar
	DECLARE Var_ClienteID		    INT(11);		            -- NUMERO DEL CLIENTE EN EL SAFI

	-- Declaracion de constantes
	DECLARE Estatus_Activo			CHAR(1);					-- Indicador de Estatus Activo
	DECLARE Entero_Cero				INT(11);					-- Entero Cero
	DECLARE Cadena_Vacia			CHAR(1);					-- Cadena Vacia
	DECLARE Cons_NO					CHAR(1);					-- Contrante que indica NO
	DECLARE SalidaSi				CHAR(1);					-- Constanre que indica SI


	-- Asignacion de constantes
	SET Estatus_Activo			:= 'A';							-- Estatus Activo
	SET Entero_Cero				:= 0;							-- Entero Cero
	SET Cadena_Vacia			:= '';							-- Cadena Vacia
	SET Cons_NO					:= 'N';							-- Constante No
	SET SalidaSi				:= 'S';							-- Salida Si
	SET Var_TipoProceso			:= 'M';							-- Proceso a Realizar

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDPLDPERFILTRANSACCIONALALT');
			SET Var_Control		:= 'sqlException' ;
		END;

		SET Par_ClienteIDExt	:= IFNULL(Par_ClienteIDExt,Cadena_Vacia);

		IF(IFNULL( Par_ClienteIDExt, Cadena_Vacia) = Entero_Cero) THEN
			SET Par_NumErr			:= 001;
			SET Par_ErrMen			:= 'El Numero de Cliente esta Vacio.';
			SET Var_Control			:= 'Par_ClienteIDExt';
			SET Var_Consecutivo 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT ClienteID
		INTO Var_ClienteID
		FROM PLDCLIENTES
		WHERE ClienteIDExt = Par_ClienteIDExt;

		SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);

		IF(IFNULL( Var_ClienteID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr			:= 002;
			SET Par_ErrMen			:= 'El Cliente ingresado no existe.';
			SET Var_Control			:= 'Var_ClienteID';
			SET Var_Consecutivo 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual		:= NOW();

		CALL PLDPERFILTRANSACCIONALALT(
			Var_ClienteID,		Entero_Cero,			Par_DepositosMax,		Par_RetirosMax,				Par_NumDepositos,
			Par_NumRetiros,		Par_CatOrigenRecID,		Par_CatDestinoRecID,	Par_ComentarioOrigenRec,	Par_ComentarioDestRec,
			Cons_NO,			Par_NumErr,				Par_ErrMen,
			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
		);

		IF(Par_NumErr!=Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		CALL PLDPERFILTRANSHISALT(
			Var_ClienteID,	Entero_Cero,	Cons_NO,			Par_NumErr,			Par_ErrMen,
			Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,	Aud_NumTransaccion
		);

		IF(Par_NumErr!=Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se calcula el Nivel de Riesgo del Nuevo Cliente
		CALL RIESGOPLDCTEPRO(
			Var_ClienteID,      Cons_NO,        	Par_NumErr,       	Par_ErrMen,   Aud_EmpresaID,      Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal, Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
		  LEAVE ManejoErrores;
		END IF;
		-- FIN de Calculo de Nivel de Riesgo del Nuevo Cliente

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Perfil Transaccional Agregado Exitosamente.');
		SET Var_Control 	:= 'clienteID' ;
		SET Var_Consecutivo	:= Par_ClienteIDExt;

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$

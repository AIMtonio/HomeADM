-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARENVIOCORREOPARAMACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARENVIOCORREOPARAMACT`;DELIMITER $$

CREATE PROCEDURE `TARENVIOCORREOPARAMACT`(
    -- SP para actualizar campos
	Par_RemitenteID			INT(11),					-- ID de la empresa
	Par_Estatus				CHAR(1),					-- Estatus del remitente (A-B)

	Par_NumAct				TINYINT(1),					-- Numero de lista

	Par_Salida				CHAR(1),					-- Indica el tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),					-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),				-- Mensaje de Error
	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),					-- Parametro de auditoria
	Aud_Usuario				INT(11),					-- Parametro de auditoria
	Aud_FechaActual			DATETIME,					-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),				-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),				-- Parametro de auditoria
	Aud_Sucursal			INT(11),					-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)					-- Parametro de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);		-- Constante de variable de control

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(1);				-- Entero cero
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE SalidaSI				CHAR(1);			-- Salida Si
    DECLARE SalidaNO				CHAR(1);			-- Salido No
	DECLARE Fecha_Vacia				DATETIME;			-- Fecha vacia
	DECLARE EstSI					CHAR(1);			-- Con Autentificacion
	DECLARE Act_Estatus				TINYINT(1);			-- Asignacion indica actualizacion de estatus
	DECLARE EstBaj					CHAR(1);			-- variable para asignacion baja

	-- Asignacion de Constantes
	SET Entero_Cero					:=0;				-- Entero Cero
	SET Cadena_Vacia				:='';				-- Cadena_ Vacia
	SET SalidaSI					:='S';				-- String SI
	SET SalidaNO					:='N';				-- String NO
	SET Fecha_Vacia					:='1900-01-01';		-- Fecha Vacia
	SET EstSI						:='S';				-- Con Autentificacion
	SET Act_Estatus					:= 1;				-- Asignacion indica actualizacion de estatus
	SET EstBaj						:='B';				-- estatus baja

	-- Valores por default
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
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TARENVIOCORREOPARAMACT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		IF(Par_Estatus=EstBaj)THEN
			SET	Par_NumErr := 001;
			SET	Par_ErrMen := CONCAT("Remitente de correo ya esta de baja");
			LEAVE ManejoErrores;
		END IF;

		IF (Par_NumAct = Act_Estatus) THEN
			UPDATE TARENVIOCORREOPARAM
				SET Estatus         = EstBaj,
					EmpresaID       = EmpresaID,
					Usuario         = Usuario,
					FechaActual     = FechaActual,
					DireccionIP     = DireccionIP,
					ProgramaID      = ProgramaID,
					Sucursal        = Sucursal,
					NumTransaccion  = NumTransaccion
			WHERE RemitenteID = Par_RemitenteID;
			SET Par_ErrMen = "El remitente a sido dado de baja.";
		END IF;

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := CONCAT(Par_ErrMen," ", CONVERT(Par_RemitenteID,CHAR));

	END ManejoErrores;  -- End del Handler de Errores.

	IF(Par_Salida = SalidaSI)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Par_RemitenteID AS Consecutivo;
	END IF;

END TerminaStore$$
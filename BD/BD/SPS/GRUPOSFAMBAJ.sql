-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSFAMBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSFAMBAJ`;DELIMITER $$

CREATE PROCEDURE `GRUPOSFAMBAJ`(
/* SP DE BAJA DE GRUPOS FAMILIARES */
	Par_ClienteID				BIGINT(12),		-- ID del Cliente a quien le pertenece el grupo.
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),

	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),

	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control     CHAR(15);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-GRUPOSFAMBAJ');
			SET Var_Control:= 'sqlException' ;
		END;

	# ALTA EN HISTÓRICO
	CALL HISGRUPOSFAMALT(
		Par_ClienteID,		SalidaNO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	DELETE FROM GRUPOSFAM
		WHERE ClienteID = Par_ClienteID;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT('Grupo Familiar Eliminado Exitosamente para el ',
						FNGENERALOCALE('safilocale.cliente'),': ',Par_ClienteID,'.');
	SET Var_Control:= 'clienteID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_ClienteID AS Consecutivo;
END IF;

END TerminaStore$$
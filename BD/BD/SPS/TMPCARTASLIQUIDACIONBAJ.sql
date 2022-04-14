-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCARTASLIQUIDACIONBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS TMPCARTASLIQUIDACIONBAJ;

DELIMITER $$
CREATE PROCEDURE TMPCARTASLIQUIDACIONBAJ(
-- SP DE BAJA PARA LAS CARTAS DE LIQUIDACION
	Par_ConsolidaCartaID		INT(11),			-- ID de Solicitud de Credito

	Par_Salida 					CHAR(1),			-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID				INT(11),			-- Parametros de Auditoria
	Aud_Usuario					INT(11),			-- Parametros de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal				INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Var_Control			CHAR(15);
	DECLARE	Var_Consecutivo		INT(11);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		VARCHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	SalidaSI			CHAR(1);
	DECLARE	SalidaNO			CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET	SalidaSI			:= 'S';				-- Salida Si
	SET	SalidaNO			:= 'N'; 			-- Salida No
	SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TMPCARTASLIQUIDACIONBAJ');
			SET Var_Control:= 'sqlException' ;
		END;

		DELETE
		  FROM TMPCARTASLIQUIDACION
		 WHERE ConsolidaCartaID = IFNULL(Par_ConsolidaCartaID,Entero_Cero);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Cartas Comerciales Eliminadas Exitosamente.';
	SET Var_Control:= 'instrumentoID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT	Par_NumErr		AS NumErr,
			Par_ErrMen		AS ErrMen,
			Var_Control		AS Control,
			Var_Consecutivo	AS Consecutivo;
END IF;

END TerminaStore$$
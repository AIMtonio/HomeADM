-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMAPERTCONVENIOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMAPERTCONVENIOBAJ`;
DELIMITER $$

CREATE PROCEDURE `COMAPERTCONVENIOBAJ`(
/* SP DE BAJA PARA ESQUEMAS DE COBRO DE COMISION APERTURA PARA CONVENIO POR ID DE ESQUEMA*/
	Par_EsqComApertID			INT(11),		-- ID del producto de Crédito.
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Var_Control     CHAR(50);
	DECLARE	Var_Consecutivo INT(11);

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
	SET	SalidaSI			:= 'S';				-- Salida Si
	SET	SalidaNO			:= 'N'; 			-- Salida No
	SET Aud_FechaActual 	:= NOW();

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-COMAPERTCONVENIOBAJ');
				SET Var_Control:= 'sqlException' ;
			END;

			IF (IFNULL(Par_EsqComApertID,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr 	:= 001;
				SET Par_ErrMen	:= 'El Esquema no es válido';
				SET Var_Control := 'esqComApertID';
				LEAVE ManejoErrores;
			END IF;

		DELETE
		FROM COMAPERTCONVENIO
			WHERE EsqComApertID = Par_EsqComApertID;

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := 'Esquemas de Cobro por Convenio Eliminado Exitosamente.';
		SET Var_Control:= 'convenioNominaID' ;
		SET Var_Consecutivo:= Par_EsqComApertID ;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
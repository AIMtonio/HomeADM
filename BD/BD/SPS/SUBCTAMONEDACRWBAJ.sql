-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDACRWBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAMONEDACRWBAJ`;
DELIMITER $$

CREATE PROCEDURE `SUBCTAMONEDACRWBAJ`(
/* MODIFICACIÓN DE SUBCUENTAS MONEDAS CROWDFUNDING. */
	Par_ConceptoCRWID		INT(11),		-- ID del Concepto.
	Par_MonedaID			INT(11),		-- ID de la Moneda.
	Par_Salida				CHAR(1),		-- Tipo de Salida.
	INOUT Par_NumErr		INT(11),		-- Número de Error.
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error.

	/* Parámetros de Auditoría */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaración de Variables.
DECLARE	Var_Control				VARCHAR(50);

-- Declaración de Constantes.
DECLARE Entero_Cero				INT;
DECLARE Decimal_Cero			DECIMAL(12,2);
DECLARE Cadena_Vacia			CHAR(1);
DECLARE Str_SI					CHAR(1);
DECLARE Str_NO					CHAR(1);

-- Asignación de constantes.
SET Entero_Cero					:=0;		-- Constante Entero Cero
SET Decimal_Cero				:=0.00;		-- Constante Decimal Cero
SET Cadena_Vacia				:= '';		-- Constante Cadena Vacia
SET Str_SI						:= 'S';		-- Constante SI
SET Str_NO						:= 'N';		-- Constante NO

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCTAMONEDACRWBAJ');
			SET Var_Control:= 'sqlException' ;
		END;

	DELETE FROM SUBCTAMONEDACRW
	WHERE ConceptoCRWID	= Par_ConceptoCRWID
		AND MonedaID	= Par_MonedaID;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT("Subcuenta Eliminada Exitosamente: ", CONVERT(Par_MonedaID, CHAR));
	SET Var_Control:= 'monedaID';

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_MonedaID AS Consecutivo;
END IF;

END TerminaStore$$
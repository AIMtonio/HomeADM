-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCRWMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORCRWMOD`;

DELIMITER $$
CREATE PROCEDURE `CUENTASMAYORCRWMOD`(
/* MODIFICACIÓN DE CUENTAS MAYOR CROWDFUNDING. */
	Par_ConceptoCRWID		INT(11),		-- ID del Concepto.
	Par_Cuenta				CHAR(4),		-- Cuenta de Mayor.
	Par_Nomenclatura		VARCHAR(30),	-- Nomenclatura de la Cuenta.
	Par_NomenclaturaCR		VARCHAR(30),	-- Nomenclatura del Centro de Costo.
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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASMAYORCRWMOD');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_ConceptoCRWID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Concepto esta Vacio.';
		SET Var_Control:= 'conceptoCRWID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Cuenta, Cadena_Vacia))= Cadena_Vacia THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'La Cuenta esta Vacia.';
		SET Var_Control:= 'cuenta';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Nomenclatura, Cadena_Vacia))= Cadena_Vacia THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'La Nomenclatura esta Vacia.';
		SET Var_Control:= 'nomenclatura';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_NomenclaturaCR, Cadena_Vacia))= Cadena_Vacia THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'La Nomenclatura Costos esta Vacia.';
		SET Var_Control:= 'nomenclaturaCR';
		LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual := NOW();

	UPDATE CUENTASMAYORCRW SET
		ConceptoCRWID	= Par_ConceptoCRWID,
		Cuenta			= Par_Cuenta,
		Nomenclatura	= Par_Nomenclatura,
		NomenclaturaCR	= Par_NomenclaturaCR,

		EmpresaID		= Aud_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE ConceptoCRWID	= Par_ConceptoCRWID;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT("Cuenta Modificada Exitosamente. Concepto: ", CONVERT(Par_ConceptoCRWID, CHAR));
	SET Var_Control:= 'conceptoCRWID';

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_ConceptoCRWID AS Consecutivo;
END IF;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWTIPOSFONDEADORBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWTIPOSFONDEADORBAJ`;
DELIMITER $$

CREATE PROCEDURE `CRWTIPOSFONDEADORBAJ`(
	Par_TipoFondID			INT(11),		-- Id del Tipo de Fondeador.
	Par_Salida				CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error
	/* Parámetros de Auditoría. */
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
DECLARE Est_Inactivo			CHAR(1);

-- Asignación de constantes.
SET Entero_Cero					:=0;		-- Constante Entero Cero
SET Decimal_Cero				:=0.00;		-- Constante Decimal Cero
SET Cadena_Vacia				:= '';		-- Constante Cadena Vacia
SET Str_SI						:= 'S';		-- Constante SI
SET Str_NO						:= 'N';		-- Constante NO
SET Est_Inactivo				:= 'I';		-- Estatus Inactivo

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWTIPOSFONDEADORBAJ');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_TipoFondID,Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Tipo de Fondeador esta vacio.';
		SET Var_Control:= 'tipoFondID';
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT TipoFondeadorID FROM CRWTIPOSFONDEADOR
		WHERE TipoFondeadorID = Par_TipoFondID)) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Tipo de Fondeador no existe.';
		SET Var_Control:= 'tipoFondeadorID';
		LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual := NOW();

	UPDATE CRWTIPOSFONDEADOR
	SET Estatus = Est_Inactivo
		WHERE TipoFondeadorID = Par_TipoFondID;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT('Tipo de Fondeador dado de Baja Exitosamente: ',Par_TipoFondID,'.');
	SET Var_Control:= 'tipoFondeadorID';

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_TipoFondID AS Consecutivo;
END IF;

END TerminaStore$$
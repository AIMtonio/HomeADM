-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASCHEQUERABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASCHEQUERABAJ`;DELIMITER $$

CREATE PROCEDURE `CAJASCHEQUERABAJ`(
# =============================================================
# -------- SP PARA DAR DE BAJA UNA ASIGNACION DE CHEQUERA------
# =============================================================
	Par_InstitucionID		INT(11),		-- Numero de la Institucion Bancaria
	Par_NumCtaInstit		VARCHAR(20),	-- Numero de la cuenta institucional bancaria
    Par_TipoChequera		CHAR(2),		-- Tipo de chequera E.- Estandar P.- Proforma

	Par_Salida				CHAR(1),		-- Salida del sp S.- Si N.- No
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE  Entero_Cero       INT(11);
	DECLARE  Decimal_Cero      DECIMAL(14,2);
	DECLARE	 Cadena_Vacia	   CHAR(1);
	DECLARE  Salida_SI		   CHAR(1);

	-- Declaracion de variables
	DECLARE  Var_Control	   VARCHAR(200);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= ''; 			-- Constante cadena vacia
	SET	Entero_Cero			:= 0; 			-- Constante entero cero
	SET	Decimal_Cero		:= 0.0;			-- COnstante decimal cero
	SET Salida_SI			:= 'S';			-- Salida SI

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								    'Disculpe las molestias que esto le ocasiona. Ref: SP-CAJASCHEQUERABAJ');
			SET Var_Control= 'sqlException' ;
		END;

		DELETE FROM CAJASCHEQUERA
			WHERE 	InstitucionID	= Par_InstitucionID
			AND 	NumCtaInstit	= Par_NumCtaInstit
			AND		TipoChequera	= Par_TipoChequera;

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('Chequeras Eliminadas Exitosamente: ',Par_NumCtaInstit );
		SET Var_Control := 'institucionID';


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$
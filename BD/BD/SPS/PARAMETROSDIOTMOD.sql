-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSDIOTMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSDIOTMOD`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSDIOTMOD`(
	# =================================================================
	# ---- SP QUE MODIFICA UN REGISTRO EN LA TABLA PARAMETROSDIOT ------
	# =================================================================
	Par_IVA				INT(11),		-- Impuesto asignado al IVA
	Par_RetIVA			INT(11),		-- Impuesto asignado a la Retencion del IVA
    Par_Salida          CHAR(1),		-- Indica el tipo de salida S.- SI N.- No
    INOUT Par_NumErr    INT(11),		-- Numero de Error
    INOUT Par_ErrMen    VARCHAR(400),	-- Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Var_Consecutivo		INT(11);

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Cadena_Vacia		CHAR;
	DECLARE	Fecha_Vacia			DATE;
	DECLARE ValorSi 			CHAR(1);
	DECLARE SalidaSi 			CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;			-- Entero Cero
	SET Decimal_Cero		:= 0.00;		-- Decimal Cero
	SET Cadena_Vacia		:= '';			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';-- Fecha vacia
	SET ValorSi 			:= 'S';			-- Si
	SET SalidaSi 			:= 'S';			-- Salida si

	SET Aud_FechaActual		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMETROSDIOTMOD');
			SET Var_Control := 'sqlException' ;
		END;

      UPDATE  PARAMETROSDIOT SET
            IVA          		= Par_IVA,
            RetIVA				= Par_RetIVA,

            Usuario             = Aud_Usuario,
            FechaActual         = Aud_FechaActual,
            DireccionIP         = Aud_DireccionIP,
            ProgramaID          = Aud_ProgramaID,
            Sucursal            = Aud_Sucursal,

            NumTransaccion      = Aud_NumTransaccion

        WHERE EmpresaID         = 1;

	  SET Par_NumErr  := 0;
        SET Par_ErrMen  := CONCAT('Informacion Modificada');
        SET Var_Control := 'iva';

END ManejoErrores;

IF(Par_Salida = SalidaSi) THEN
    SELECT 	Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$
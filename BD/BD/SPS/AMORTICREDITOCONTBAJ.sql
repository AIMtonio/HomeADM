-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOCONTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOCONTBAJ`;DELIMITER $$

CREATE PROCEDURE `AMORTICREDITOCONTBAJ`(
/*SP para dar de baja las amortizaciones de crédito*/
	Par_CreditoID		BIGINT(12),

	Par_Salida          CHAR(1),
    INOUT Par_NumErr	INT(11),
    INOUT Par_ErrMen	VARCHAR(400),

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	SalidaNO	CHAR(1);
	DECLARE	Salida_SI	CHAR(1);
    DECLARE Entero_Cero	INT(11);

	-- Asignacion de constantes
	SET	SalidaNO 		:='N';
	SET	Salida_SI		:= 'S';
    SET Entero_Cero		:= 0;

    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTICREDITOCONTBAJ');
		END;

		DELETE FROM AMORTICREDITOCONT WHERE CreditoID = Par_CreditoID;

		SET Par_NumErr      := Entero_Cero;
        SET Par_ErrMen      := 'Amortizaciones Eliminadas.';

END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr          AS NumErr,
            Par_ErrMen          AS ErrMen;

    END IF;

END TerminaStore$$
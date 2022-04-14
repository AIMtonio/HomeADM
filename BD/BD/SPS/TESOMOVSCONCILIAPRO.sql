-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOMOVSCONCILIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOMOVSCONCILIAPRO`;DELIMITER $$

CREATE PROCEDURE `TESOMOVSCONCILIAPRO`(
# ==================================================================================
# -------- SP PARA REALIZAR LA CONCILIACION DE MOVIMIENTOS DE TESORERIA ------------
# ==================================================================================
	Par_TipoMov			CHAR(4),
	Par_FolioMovimento	INT(11),
	Par_FolioCargaID	INT(11),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Aud_EmpresaID		INT(11),
    Aud_Usuario			INT(11),
    Aud_FechaActual		DATETIME,
    Aud_DireccionIP		VARCHAR(15),
    Aud_ProgramaID		VARCHAR(50),
    Aud_Sucursal		INT(11),
    Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

    -- Declaracion de Constantes
    DECLARE Entero_Cero		INT(11);
    DECLARE Cadena_Vacia	CHAR(1);
    DECLARE	consecutivo		BIGINT(12);
    DECLARE Est_Conciliado	CHAR(1);
    DECLARE ActConciliado   INT(11);
    DECLARE Salida_NO       CHAR(1);
    DECLARE Salida_SI		CHAR(1);
    DECLARE Par_Consecutivo	BIGINT(12);

    -- Declaracion de variables
    DECLARE VarControl 		VARCHAR(15);

    -- Asignacion de Constantes
    SET Entero_Cero			:= 0;		-- entero en cero
    SET Cadena_Vacia		:= '';		-- cadena o string vacia
    SET consecutivo			:= 0;		-- numero consecutivo
    SET Est_Conciliado		:= 'C';		-- estatus conciliado
    SET ActConciliado		:= 1;		-- numero de actualizacion para conciliacion
    SET Salida_NO			:= 'N';		-- indica que no se trata de una salida a pantalla
	SET Salida_SI			:= 'S';

    ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	= '999';
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								   'esto le ocasiona. Ref: SP-TESOMOVSCONCILIAPRO');
			SET VarControl	= 'sqlException';
		END;

	/* Se actualiza el folIo en la tabla de TESORERIAMOVS*/
		CALL TESORERIAMOVSACT(
			Par_FolioMovimento,	Par_FolioCargaID,	ActConciliado,	Salida_NO,		Par_NumErr,
			Par_ErrMen,			Par_Consecutivo,	Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


	/* Se actualiza el folio en la tabla de TESOMOVSCONCILIA*/
		CALL TESOMOVSCONCILIACT(
			Par_FolioCargaID,	Entero_Cero,		Cadena_Vacia,	Par_FolioMovimento,	Par_TipoMov,
			ActConciliado,    	Salida_NO,			Par_NumErr,		Par_ErrMen,			Par_Consecutivo,
			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen 	:= 'Conciliacion Realizada Exitosamente';


    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				'cuentaAhorroID'AS control,
				consecutivo 	AS consecutivo;
    END IF;

END TerminaStore$$
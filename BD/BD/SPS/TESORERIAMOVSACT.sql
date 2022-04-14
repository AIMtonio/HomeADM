-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESORERIAMOVSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESORERIAMOVSACT`;DELIMITER $$

CREATE PROCEDURE `TESORERIAMOVSACT`(
# ==================================================================================
# ---------------- SP PARA ACTUALIZACION DE MOVIMIENTOS DE TESORERIA ---------------
# ==================================================================================
	Par_FolioMovimiento	INT(11),
	Par_FolioCargaID	INT(11),
	Par_NumAct      	TINYINT UNSIGNED,

	Par_Salida     		CHAR(1),
	OUT	Par_NumErr		INT(11),
	OUT	Par_ErrMen		VARCHAR(400),
	OUT	Par_Consecutivo	BIGINT(12),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

    -- Declaracion de constantes
	DECLARE Entero_Cero		INT(11);
	DECLARE Est_Conciliado	CHAR(1);
	DECLARE Decimal_Cero	DECIMAL(14,2);
	DECLARE ActConciliado   INT(11);
	DECLARE Salida_SI       CHAR(1);
	DECLARE Est_Concilia	CHAR(1);

	-- Declaracion de variables
    DECLARE Var_NumTran		BIGINT(20);
    DECLARE varControl      CHAR(15);


	-- Asignacion de constantes
	SET Entero_Cero     	:= 0;		-- entero en cero
	SET Est_Conciliado 		:= 'C';		-- indica estatus conciliado
	SET Decimal_Cero 		:= 0.00;	-- decimal en cero
	SET ActConciliado 		:= 1;		-- numero de actualizacion para conciliacion
	SET Salida_SI       	:= 'S';		-- Salida a Pantalla SI
	SET Aud_FechaActual		:= NOW();	-- actualiza el valor para la fecha de auditoria
	SET Est_Concilia		:= 'O';

    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
										'esto le ocasiona. Ref: SP-TESORERIAMOVSACT');
                SET varControl = 'sqlException' ;
            END;

	/* Cuando se hace la conciliacion se actualiza el folio en TESORERIAMOVS*/
		IF(Par_NumAct = ActConciliado) THEN

			SELECT 		NumTransaccion	INTO Var_NumTran
				FROM	TESORERIAMOVS
				WHERE	FolioMovimiento	= Par_FolioMovimiento;


			UPDATE TESORERIAMOVS SET
				Status		 		= Est_Conciliado,

				NumeroMov 			= Par_FolioCargaID,
				EmpresaID 			= Par_EmpresaID,
				Usuario 			= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID 			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
                NumTransaccion  	= Aud_NumTransaccion
			WHERE FolioMovimiento	= Par_FolioMovimiento;


			UPDATE ORDENPAGODESCRED	SET
				Estatus 			= Est_Concilia,

				EmpresaID 			= Par_EmpresaID,
				Usuario 			= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID 			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
                NumTransaccion  	= Aud_NumTransaccion
			WHERE	NumTransaccion	= Var_NumTran;


			UPDATE CHEQUESEMITIDOS	SET
				Estatus 			= Est_Concilia,

				EmpresaID 			= Par_EmpresaID,
				Usuario 			= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID 			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
                NumTransaccion  	= Aud_NumTransaccion
			WHERE	NumTransaccion	= Var_NumTran;

		END IF;


		SET Par_NumErr      := '000';
		SET Par_ErrMen      := 'Movimiento Actualizado Exitosamente.';
		SET Par_Consecutivo := Entero_Cero;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				'CuentaAhoID' 	AS control,
				Par_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
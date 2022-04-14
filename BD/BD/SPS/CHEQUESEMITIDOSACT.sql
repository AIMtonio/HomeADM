-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESEMITIDOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHEQUESEMITIDOSACT`;DELIMITER $$

CREATE PROCEDURE `CHEQUESEMITIDOSACT`(
# ==================================================================================
# ----------------------- SP PARA ACTUALIZACION DE CHEQUES -------------------------
# ==================================================================================
	Par_InstitucionID		INT(11),
	Par_CuentaInstitucion	BIGINT(12),
	Par_NumeroCheque		INT(10),
    Par_TipoChequera		CHAR(2),			-- Tipo Chequera P- PROFORMA, E-ESTANDAR
	Par_NumAct				TINYINT UNSIGNED,

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE ActAplicado			INT(11);
	DECLARE ActPagado			INT(11);
    DECLARE ActCancelado		INT(11);
	DECLARE EstatusAplicado		CHAR(1);
    DECLARE EstatusPagado		CHAR(1);
    DECLARE EstatusCancelado	CHAR(1);
	DECLARE SalidaSI			CHAR(1);

    -- Declaracion de variables
    DECLARE varControl          CHAR(15);

	-- Asignacion de constantes
	SET ActAplicado				:= 1;		-- Actualiza el cheque a Aplicado
	SET ActPagado				:= 2;		-- Actualiza el cheque a Pagado
    SET ActCancelado			:= 3;		-- Actualiza el estatus de cheque a Cancelado
	SET EstatusAplicado			:= 'A';		-- Estatus Aplicado
	SET EstatusPagado			:= 'P';
	SET EstatusCancelado		:= 'C';		-- Estatus Cancelado
    SET SalidaSI				:= 'S';		-- Salida en Pantalla SI

	ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
										'esto le ocasiona. Ref: SP-CHEQUESEMITIDOSACT');
                SET varControl = 'sqlException' ;
            END;


		IF(Par_NumAct = ActAplicado)THEN
			UPDATE CHEQUESEMITIDOS SET
					Estatus				= EstatusAplicado,
					EmpresaID			= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal 			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
			WHERE 	InstitucionID 		= Par_InstitucionID
			  AND 	CuentaInstitucion 	= Par_CuentaInstitucion
			  AND 	NumeroCheque 		= Par_NumeroCheque;

			SET	Par_NumErr := 0;
			SET Par_ErrMen := 'Cheque Aplicado Exitosamente';

		END IF;

		IF(Par_NumAct = ActPagado)THEN
			UPDATE CHEQUESEMITIDOS SET
					Estatus				= EstatusPagado,
					EmpresaID			= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal 			= Aud_Sucursal,
                    NumTransaccion		= Aud_NumTransaccion
			WHERE 	InstitucionID 		= Par_InstitucionID
			  AND 	CuentaInstitucion 	= Par_CuentaInstitucion
              AND	TipoChequera 		= Par_TipoChequera
			  AND 	NumeroCheque 		= Par_NumeroCheque;

			SET	Par_NumErr := 0;
			SET Par_ErrMen := 'Cheque Pagado Exitosamente';

		END IF;


        IF(Par_NumAct = ActCancelado)THEN
			UPDATE CHEQUESEMITIDOS SET
					Estatus				= EstatusCancelado,
					EmpresaID			= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal 			= Aud_Sucursal,
                    NumTransaccion		= Aud_NumTransaccion
			WHERE 	InstitucionID 		= Par_InstitucionID
			  AND 	CuentaInstitucion 	= Par_CuentaInstitucion
              AND	TipoChequera 		= Par_TipoChequera
			  AND 	NumeroCheque 		= Par_NumeroCheque;

			SET	Par_NumErr := 0;
			SET Par_ErrMen := 'Cheque Pagado Exitosamente';

		END IF;

	END ManejoErrores;

	 IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				'tipoOperacion' AS control,
				Par_NumeroCheque AS consecutivo;
	END IF;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONMOVACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONMOVACT`;
DELIMITER $$

CREATE PROCEDURE `DISPERSIONMOVACT`(
# =========================================================================
# -STORE QUE OBTIENE LOS VALORES PARA ACTUALIZAR MOV DE DISPERSIONES-
# =========================================================================
	Par_ClaveDispMov     	INT(11),
	Par_DispersionID     	INT(11),
	Par_Estatus          	VARCHAR(2),
	Par_CuentaCheque	  	VARCHAR(25),
	Par_TipoAct				INT(11),
	Par_TipoConcepto		INT(11),		-- Tipo de Concepto referente a Cartas de Liquidacion

    Par_Salida         		CHAR(1),
	OUT	Par_NumErr			INT(11),
	OUT	Par_ErrMen			VARCHAR(400),
	OUT	Par_Consecutivo		BIGINT(20),

    Par_EmpresaID        	INT(11),
	Aud_Usuario          	INT(11),
	Aud_FechaActual      	DATETIME,
	Aud_DireccionIP      	VARCHAR(20),
	Aud_ProgramaID       	VARCHAR(50),
	Aud_Sucursal         	INT(11),
	Aud_NumTransaccion   	BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(100);
	-- Declaracion de  Constantes
	DECLARE Var_ActEstatus	INT(11);
	DECLARE Exportada		INT(11);
	DECLARE ActExportada	CHAR(1);
	DECLARE SalidaSi		CHAR(1);
	DECLARE SalidaNo		CHAR(1);
	DECLARE ActConceptoDis	INT(11);

	-- Asignacion de Constantes
	SET Var_ActEstatus 		:= 1;
	SET Exportada			:= 2;
	SET ActExportada		:= 'E';
	SET SalidaSi			:= 'S';
	SET SalidaNo			:= 'N';
	SET ActConceptoDis		:= 3;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										 'Disculpe las molestias que esto le ocasiona. Ref: SP-DISPERSIONMOVACT');
				SET Var_Control = 'SQLEXCEPTION';
		END;

		IF(Par_TipoAct = Var_ActEstatus) THEN

			UPDATE  DISPERSIONMOV  SET
				Estatus				= Par_Estatus ,
				CuentaDestino 		= Par_CuentaCheque,

				EmpresaID			= Par_EmpresaID ,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID ,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE  ClaveDispMov 	= Par_ClaveDispMov
			  AND DispersionID 		= Par_DispersionID ;

			SET Par_NumErr 		:= 0;
			SET Par_ErrMen 		:= CONCAT("Movimiento de Dispersion Actualizada: ",CONVERT(Par_ClaveDispMov, CHAR));
			SET Var_Control		:= 'claveDispMov';
			SET Par_Consecutivo := Par_ClaveDispMov;

		END IF;

		IF(Par_TipoAct = Exportada) THEN

			UPDATE  DISPERSIONMOV  SET
				Estatus			= ActExportada,

				EmpresaID			= Par_EmpresaID ,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID ,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE  ClaveDispMov 	= Par_ClaveDispMov
			  AND DispersionID 		= Par_DispersionID ;

			SET Par_NumErr 		:= 0;
			SET Par_ErrMen 		:= CONCAT("Movimiento de Dispersion Actualizada: ",CONVERT(Par_DispersionID, CHAR));
			SET Var_Control		:= 'claveDispMov';
			SET Par_Consecutivo := Par_DispersionID;

		END IF;

		IF(Par_TipoAct = ActConceptoDis) THEN
			UPDATE  DISPERSIONMOV  SET
				ConceptoDispersion	= Par_TipoConcepto,

				EmpresaID		= Par_EmpresaID ,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID ,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE ClaveDispMov 	= Par_ClaveDispMov
				AND DispersionID = Par_DispersionID ;

			SET Par_NumErr 		:= 0;
			SET Par_ErrMen 		:= CONCAT("Movimiento de Dispersion Actualizada: ",CONVERT(Par_DispersionID, CHAR));
			SET Var_Control		:= 'claveDispMov';
			SET Par_Consecutivo := Par_DispersionID;

		END IF;

	END ManejoErrores;

		IF(Par_Salida = SalidaSi)THEN
			SELECT 	Par_NumErr  AS NumErr,
					Par_ErrMen  AS ErrMen,
					Var_Control AS control,
					Par_ClaveDispMov AS consecutivo;
		END IF;

END TerminaStore$$
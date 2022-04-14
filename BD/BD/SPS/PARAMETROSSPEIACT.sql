-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSPEIACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSPEIACT`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSSPEIACT`(



    Par_EmpresaID			INT(11),
    Par_NumAct       		INT,

    Par_Salida          	CHAR(1),
	INOUT Par_NumErr    	INT(11),
	INOUT Par_ErrMen    	VARCHAR(400),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(20),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
		)
TerminaStore: BEGIN


	DECLARE Var_TipoPagoID   	INT(2);
	DECLARE Var_Control 	   	CHAR(15);
	DECLARE Var_Estatus        	CHAR(1);
	DECLARE	Var_FechaHabil		DATE;
	DECLARE	Var_EsHabil			CHAR(1);


	DECLARE  NumTipoPagoID   	INT;
	DECLARE	 Cadena_Vacia		CHAR(1);
	DECLARE	 Fecha_Vacia		DATE;
	DECLARE	 Entero_Cero		INT;
	DECLARE	 Decimal_Cero		DECIMAL(12,2);
	DECLARE  SalidaNO        	CHAR(1);
	DECLARE  SalidaSI        	CHAR(1);
	DECLARE  ActFecha    	    INT;
	DECLARE  ActFechaApertura	INT;



	SET	NumTipoPagoID		    := 0;
	SET	Cadena_Vacia		    := '';
	SET	Fecha_Vacia			    := '1900-01-01';
	SET	Entero_Cero			    := 0;
	SET	Decimal_Cero		    := 0.0;
	SET SalidaSI        	    := 'S';
	SET SalidaNO        	    := 'N';
	SET Par_NumErr  		    := 0;
	SET Par_ErrMen  		    := '';
	SET ActFecha   	            := 1;
	SET ActFechaApertura   	    := 2;


	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMETROSSPEIACT');
				SET Var_Control = 'sqlException';
			END;


		IF(IFNULL(Par_EmpresaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El ID de la Empresa esta Vacia.';
			SET Var_Control:= 'empresaID';
			LEAVE ManejoErrores;
		END IF;



		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		IF (Par_NumAct = ActFecha)THEN

			UPDATE PARAMETROSSPEI SET
				UltActCat       = CURRENT_TIMESTAMP(),

				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE EmpresaID		= Par_EmpresaID;

			SET Par_NumErr := 000;
			SET Par_ErrMen := CONCAT('Registro Actualizado exitosamente: ',CONVERT(Par_EmpresaID, CHAR));

		END IF;

		IF (Par_NumAct = ActFechaApertura)THEN

			CALL DIASFESTIVOSCAL(
					CURDATE(),		1,					Var_FechaHabil,		Var_EsHabil,		Par_EmpresaID,
					Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

			UPDATE PARAMETROSSPEI SET
				FechaApertura   = Var_FechaHabil,

				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion

			WHERE	EmpresaID	= Par_EmpresaID;

			SET Par_NumErr := 000;
			SET Par_ErrMen := CONCAT('Registro Actualizado exitosamente: ',CONVERT(Par_EmpresaID, CHAR));

		END IF;


	END ManejoErrores;

		IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Par_EmpresaID AS consecutivo;
		END IF;

END TerminaStore$$
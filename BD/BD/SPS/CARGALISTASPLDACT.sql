-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGALISTASPLDACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGALISTASPLDACT`;DELIMITER $$

CREATE PROCEDURE `CARGALISTASPLDACT`(
	Par_CargaListasID			INT(11),
	Par_TipoLista				VARCHAR(3),
    Par_TipoAct					TINYINT UNSIGNED,
    Par_Salida          		CHAR(1),
    INOUT Par_NumErr    		INT,

    INOUT Par_ErrMen    		VARCHAR(400),

	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),

	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
			)
TerminaStore: BEGIN


DECLARE Var_Control			VARCHAR(20);
DECLARE Var_CargaListasID	INT(11);
DECLARE Var_Consecutivo		INT(11);
DECLARE Var_FechaSistema	DATE;


DECLARE Act_Exito			INT;
DECLARE Act_Fallo			INT;
DECLARE Act_InvalRecien		INT;
DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE Cadena_Vacia		CHAR;
DECLARE	Fecha_Vacia			DATE;
DECLARE ValorSi 			CHAR(1);
DECLARE SalidaSi 			CHAR(1);
DECLARE EstEnProceso		CHAR(1);
DECLARE EstatusValido		CHAR(1);
DECLARE EstatusInvalido		CHAR(1);


SET Act_Exito			:= 1;
SET Act_Fallo			:= 2;
SET Act_InvalRecien		:= 3;
SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.00;
SET Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET ValorSi 			:= 'S';
SET SalidaSi 			:= 'S';
SET EstEnProceso		:= 'P';
SET EstatusValido		:= 'V';
SET EstatusInvalido		:= 'I';

SET Aud_FechaActual		:= NOW();
SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS);

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CARGALISTASPLDALT');
			SET Var_Control := 'sqlException' ;
		END;


	IF(Par_TipoAct=Act_Exito)THEN
		IF(IFNULL(Par_CargaListasID,Entero_Cero)=Entero_Cero)THEN
			SET	Par_NumErr		:= 001;
			SET	Par_ErrMen		:= 'El ID de Carga de listas se encuentra vacio.';
			SET Var_Control 	:= '' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT CargaListasID INTO Var_CargaListasID
			FROM CARGALISTASPLD
			WHERE CargaListasID = Par_CargaListasID;

		IF(IFNULL(Var_CargaListasID,Entero_Cero)=Entero_Cero)THEN
			SET	Par_NumErr		:= 002;
			SET	Par_ErrMen		:= 'El ID de Carga de Listas No Existe.';
			SET Var_Control 	:= '' ;
			LEAVE ManejoErrores;
		END IF;

		UPDATE CARGALISTASPLD SET
			FechaCarga 		= Var_FechaSistema,
			Estatus 		= EstatusValido,
			EmpresaID 		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,

			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			SucursalID		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
			WHERE CargaListasID = Par_CargaListasID;

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Modificacion de Carga de Listas Exitosa.');
		SET Var_Control 	:= '' ;
		LEAVE ManejoErrores;
    END IF;


	IF(Par_TipoAct=Act_Fallo)THEN
		IF(IFNULL(Par_CargaListasID,Entero_Cero)=Entero_Cero)THEN
			SET	Par_NumErr		:= 001;
			SET	Par_ErrMen		:= 'El ID de Carga de listas se encuentra vacio.';
			SET Var_Control 	:= '' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT CargaListasID INTO Var_CargaListasID
			FROM CARGALISTASPLD
			WHERE CargaListasID = Par_CargaListasID;

		IF(IFNULL(Var_CargaListasID,Entero_Cero)=Entero_Cero)THEN
			SET	Par_NumErr		:= 002;
			SET	Par_ErrMen		:= 'El ID de Carga de Listas No Existe.';
			SET Var_Control 	:= '' ;
			LEAVE ManejoErrores;
		END IF;

		UPDATE CARGALISTASPLD SET
			FechaCarga 		= Var_FechaSistema,
			Estatus 		= EstatusInvalido,
			EmpresaID 		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,

			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			SucursalID		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
			WHERE CargaListasID = Par_CargaListasID;

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Modificacion de Carga de Listas Exitosa.');
		SET Var_Control 	:= '' ;
		LEAVE ManejoErrores;
    END IF;


	IF(Par_TipoAct=Act_InvalRecien)THEN

		UPDATE CARGALISTASPLD SET
			Estatus 		= EstatusInvalido,
			EmpresaID 		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,

			ProgramaID		= Aud_ProgramaID,
			SucursalID		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
			WHERE FechaCarga = Var_FechaSistema
				AND Estatus = EstEnProceso
                AND TipoLista = Par_TipoLista;

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Modificacion de Carga de Listas Exitosa.');
		SET Var_Control 	:= '' ;
		LEAVE ManejoErrores;
    END IF;

END ManejoErrores;

IF(Par_Salida = SalidaSi) THEN
    SELECT 	Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Par_CargaListasID AS Consecutivo;
END IF;

END TerminaStore$$
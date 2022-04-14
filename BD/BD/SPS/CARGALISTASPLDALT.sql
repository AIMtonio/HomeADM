-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGALISTASPLDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGALISTASPLDALT`;DELIMITER $$

CREATE PROCEDURE `CARGALISTASPLDALT`(
	Par_TipoLista				VARCHAR(3),
	Par_RutaArchivo				VARCHAR(200),
	Par_FechaCarga				DATE,
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
DECLARE Var_Consecutivo		INT(11);
DECLARE Var_FechaVigencia	DATE;


DECLARE TipoAct				INT;
DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE Cadena_Vacia		CHAR;
DECLARE	Fecha_Vacia			DATE;
DECLARE ValorSi 			CHAR(1);
DECLARE SalidaSi 			CHAR(1);
DECLARE SalidaNo 			CHAR(1);
DECLARE EstatusEnProceso	CHAR(1);


SET TipoAct				:= 3;
SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.00;
SET Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET ValorSi 			:= 'S';
SET SalidaSi 			:= 'S';
SET SalidaNo 			:= 'N';
SET EstatusEnProceso	:= 'P';

SET Aud_FechaActual		:= NOW();
SET Var_FechaVigencia 	:= (SELECT FechaSistema FROM PARAMETROSSIS);

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CARGALISTASPLDALT');
			SET Var_Control := 'sqlException' ;
		END;

    IF(IFNULL(Par_TipoLista,Cadena_Vacia)=Cadena_Vacia)THEN
		SET	Par_NumErr		:= 001;
		SET	Par_ErrMen		:= 'El Tipo de Lista se encuentra vacio.';
		SET Var_Control 	:= '' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_RutaArchivo,Cadena_Vacia)=Cadena_Vacia)THEN
		SET	Par_NumErr		:= 002;
		SET	Par_ErrMen		:= 'La Ruta del Archivo se encuentra vacia.';
		SET Var_Control 	:= '' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_FechaCarga,Fecha_Vacia)=Fecha_Vacia)THEN
		SET	Par_NumErr		:= 003;
		SET	Par_ErrMen		:= 'La Fecha de Carga se encuentra vacia.';
		SET Var_Control 	:= '' ;
        LEAVE ManejoErrores;
    END IF;

    CALL CARGALISTASPLDACT(
		Entero_Cero, 	Par_TipoLista, 	TipoAct,			SalidaNo,			Par_NumErr,
        Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
        Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

    IF(Par_NumErr!=Entero_Cero)THEN
		LEAVE ManejoErrores;
    END IF;


	CALL FOLIOSAPLICAACT('CARGALISTASPLD', Var_Consecutivo);

    INSERT INTO CARGALISTASPLD (
		CargaListasID,		TipoLista,			RutaArchivo,		FechaCarga,			Estatus,
        EmpresaID,			Usuario,	 		FechaActual,		DireccionIP,		ProgramaID,
        SucursalID,			NumTransaccion
	) VALUES (
		Var_Consecutivo,	Par_TipoLista,		Par_RutaArchivo,	Par_FechaCarga, 	EstatusEnProceso,
		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
        Aud_Sucursal,		Aud_NumTransaccion
	);

	SET	Par_NumErr		:= 000;
	SET	Par_ErrMen		:= CONCAT('Carga de Listas Exitosa.');
	SET Var_Control 	:= '' ;

END ManejoErrores;

IF(Par_Salida = SalidaSi) THEN
    SELECT 	Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMPLDOPEEFECMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMPLDOPEEFECMOD`;DELIMITER $$

CREATE PROCEDURE `PARAMPLDOPEEFECMOD`(

	Par_FolioID					INT(11),
	Par_MontoRemesaUno			DECIMAL(14,2),
	Par_MontoRemesaDos			DECIMAL(14,2),
	Par_MontoRemesaTres			DECIMAL(14,2),
	Par_RemesaMonedaID			INT(11),

	Par_MontoLimEfecF			DECIMAL(14,2),
	Par_MontoLimEfecM			DECIMAL(14,2),
	Par_MontoLimEfecMes			DECIMAL(14,2),
	Par_MontoLimMonedaID		INT(11),
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
TerminaStore:BEGIN


DECLARE Var_Control			VARCHAR(20);


DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE Cadena_Vacia		CHAR;
DECLARE	Fecha_Vacia			DATE;
DECLARE ValorSi 			CHAR(1);
DECLARE SalidaSi 			CHAR(1);


SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0;
SET Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET ValorSi 			:= 'S';
SET SalidaSi 			:= 'S';

SET Aud_FechaActual		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMPLDOPEEFECMOD');
			SET Var_Control := 'sqlException' ;
		END;

    IF(IFNULL(Par_FolioID,Entero_Cero)=Entero_Cero)THEN
		SET	Par_NumErr		:= 001;
		SET	Par_ErrMen		:= 'El Numero de Folio se encuentra vacio.';
		SET Var_Control 	:= 'folioID' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MontoRemesaUno,Decimal_Cero)=Decimal_Cero)THEN
		SET	Par_NumErr		:= 004;
		SET	Par_ErrMen		:= 'El Monto Limite Uno se encuentra vacio.';
		SET Var_Control 	:= 'montoRemesaUno' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MontoRemesaDos,Decimal_Cero)=Decimal_Cero)THEN
		SET	Par_NumErr		:= 005;
		SET	Par_ErrMen		:= 'El Monto Limite Dos se encuentra vacio.';
		SET Var_Control 	:= 'montoRemesaDos' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MontoRemesaTres,Decimal_Cero)=Decimal_Cero)THEN
		SET	Par_NumErr		:= 006;
		SET	Par_ErrMen		:= 'El Monto Limite Tres se encuentra vacio.';
		SET Var_Control 	:= 'montoRemesaTres' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_RemesaMonedaID,Entero_Cero)=Entero_Cero)THEN
		SET	Par_NumErr		:= 007;
		SET	Par_ErrMen		:= 'La Moneda para el Pago de Remesas se encuentra vacia.';
		SET Var_Control 	:= '' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MontoLimEfecF,Decimal_Cero)=Decimal_Cero)THEN
		SET	Par_NumErr		:= 008;
		SET	Par_ErrMen		:= 'El Monto Limite Efectivo para Pers. Fisicas se encuentra vacio.';
		SET Var_Control 	:= 'montoLimEfecF' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MontoLimEfecM,Decimal_Cero)=Decimal_Cero)THEN
		SET	Par_NumErr		:= 009;
		SET	Par_ErrMen		:= 'El Monto Limite Efectivo para Pers. Morales se encuentra vacio.';
		SET Var_Control 	:= 'montoLimEfecM' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MontoLimEfecMes,Decimal_Cero)=Decimal_Cero)THEN
		SET	Par_NumErr		:= 010;
		SET	Par_ErrMen		:= 'El Monto Limite Efectivo para ambos Tipos de Personas se encuentra vacio.';
		SET Var_Control 	:= 'montoLimEfecMes' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MontoLimMonedaID,Entero_Cero)=Entero_Cero)THEN
		SET	Par_NumErr		:= 011;
		SET	Par_ErrMen		:= 'La Moneda para el Limite de Efectivo Mensual se encuentra vacia.';
		SET Var_Control 	:= '' ;
        LEAVE ManejoErrores;
    END IF;

    UPDATE PARAMPLDOPEEFEC SET
		MontoRemesaUno			= Par_MontoRemesaUno,
		MontoRemesaDos			= Par_MontoRemesaDos,

		MontoRemesaTres			= Par_MontoRemesaTres,
        RemesaMonedaID			= Par_RemesaMonedaID,
        MontoLimEfecF			= Par_MontoLimEfecF,
        MontoLimEfecM			= Par_MontoLimEfecM,
		MontoLimEfecMes			= Par_MontoLimEfecMes,

        MontoLimMonedaID		= Par_MontoLimMonedaID,
        EmpresaID				= Aud_EmpresaID,
        Usuario					= Aud_Usuario,
        FechaActual				= Aud_FechaActual,
		DireccionIP				= Aud_DireccionIP,

        ProgramaID				= Aud_ProgramaID,
        Sucursal				= Aud_Sucursal,
        NumTransaccion			= Aud_NumTransaccion
        WHERE FolioID			= Par_FolioID;

	SET	Par_NumErr		:= 000;
	SET	Par_ErrMen		:= CONCAT('Parametros Modificados Exitosamente. Folio: ', CONVERT(Par_FolioID, CHAR));
	SET Var_Control 	:= 'folioID' ;

END ManejoErrores;

IF(Par_Salida = SalidaSi) THEN
    SELECT 	Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$
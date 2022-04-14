-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMESASEGCOBALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROMESASEGCOBALT`;DELIMITER $$

CREATE PROCEDURE `PROMESASEGCOBALT`(

	Par_BitSegCobID		INT(11),
    Par_NumPromesa		INT(11),
    Par_FechaPromPago	DATE,
    Par_MontoPromPago	DECIMAL(16,2),
    Par_ComentarioProm	VARCHAR(300),

    Par_Salida			CHAR(1),
    inout Par_NumErr	INT(11),
    inout Par_ErrMen	VARCHAR(150),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

	)
TerminaStore: BEGIN


    DECLARE Var_Control		VARCHAR(50);
    DECLARE Var_Consecutivo	VARCHAR(20);


    DECLARE Fecha_Vacia		DATE;
    DECLARE Entero_Cero		INT(11);
    DECLARE Entero_Uno		INT(11);
    DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Salida_SI		CHAR(1);


	SET	Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
    SET Cadena_Vacia		:= '';
    SET Salida_SI			:= 'S';

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-PROMESASEGCOBALT');
		SET Var_Control = 'sqlException' ;
	END;

        IF NOT EXISTS (SELECT BitacoraID FROM BITACORASEGCOB WHERE BitacoraID = Par_BitSegCobID )THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'No existe Registro de la Bitacora';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaPromPago, Fecha_Vacia) = Fecha_Vacia )THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'La Fecha Promesa de Pago esta Vacia';
			SET Var_Control	:= CONCAT('fechaPromPago',Par_NumPromesa);
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MontoPromPago, Entero_Cero) <= Entero_Cero )THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El Monto Promesa de Pago debe ser mayor a Cero';
			SET Var_Control	:= CONCAT('montoPromPago',Par_NumPromesa);
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ComentarioProm, Cadena_Vacia) = Cadena_Vacia )THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El Comentario esta Vacio';
			SET Var_Control	:= CONCAT('comentarioProm',Par_NumPromesa);
			LEAVE ManejoErrores;
		END IF;

        SET Aud_FechaActual = now();

        INSERT INTO PROMESASEGCOB
		(	BitacoraID, 		NumPromesa, 		FechaPromPago, 		MontoPromPago, 			ComentarioProm,
			EmpresaID, 			Usuario,			FechaActual, 		DireccionIP, 			ProgramaID,
			Sucursal, 			NumTransaccion
        )VALUES(
			Par_BitSegCobID,	Par_NumPromesa,		Par_FechaPromPago,	Par_MontoPromPago,		Par_ComentarioProm,
            Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,
            Aud_Sucursal,		Aud_NumTransaccion
		);

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONCAT('Bitacora de Seguimiento de Cobranza Realizada Exitosamente: ', CAST(Par_BitSegCobID AS CHAR) );
		SET Var_Control	:= 'creditoID';
		SET Var_Consecutivo:= Par_BitSegCobID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;


END TerminaStore$$
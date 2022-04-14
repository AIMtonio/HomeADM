-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORASEGCOBALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORASEGCOBALT`;DELIMITER $$

CREATE PROCEDURE `BITACORASEGCOBALT`(

    Par_FechaSis		DATE,
	Par_UsuarioID		INT(11),
    Par_SucursalID		INT(11),
    Par_CreditoID		BIGINT(12),
    Par_ClienteID		BIGINT(11),

    Par_AccionID		INT(11),
    Par_RespuestaID		INT(11),
    Par_Comentario		VARCHAR(300),
    Par_EtapaCobranza	VARCHAR(10),
    Par_FechaEtregaDoc  DATE,

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
    DECLARE Var_BitacoraID	INT(11);


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
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-BITACORASEGCOBALT');
		SET Var_Control = 'sqlException' ;
	END;

		IF(IFNULL(Par_FechaSis, Fecha_Vacia) = Fecha_Vacia )THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'La Fecha esta Vacia';
			SET Var_Control	:='creditoID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS (SELECT UsuarioID FROM USUARIOS WHERE UsuarioID = Par_UsuarioID )THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Usuario no Existe';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS (SELECT SucursalID FROM SUCURSALES WHERE SucursalID = Par_SucursalID )THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'La Sucursal no Existe';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS (SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID )THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El Credito no Existe';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID )THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'El Cliente no Existe';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS (SELECT AccionID FROM TIPOACCIONCOB WHERE AccionID = Par_AccionID )THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := 'El Tipo de Accion no Existe';
			SET Var_Control	:= 'accionID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS (SELECT RespuestaID FROM TIPORESPUESTACOB WHERE RespuestaID = Par_RespuestaID )THEN
			SET Par_NumErr := 7;
			SET Par_ErrMen := 'El Tipo de Respuesta no Existe';
			SET Var_Control	:= 'respuestaID';
			LEAVE ManejoErrores;
		END IF;

        SET Aud_FechaActual = now();
        CALL FOLIOSAPLICAACT('BITACORASEGCOB',Var_BitacoraID);

        INSERT INTO BITACORASEGCOB
		(	BitacoraID, 			Fecha, 			UsuarioID, 			SucursalID, 		CreditoID,
			ClienteID, 				AccionID, 		RespuestaID, 		Comentario, 		EtiquetaEtapa,
            FechaEntregaDoc,
			EmpresaID, 				Usuario, 		FechaActual, 		DireccionIP, 		ProgramaID,
            Sucursal, 				NumTransaccion
        )VALUES(
			Var_BitacoraID,			Par_FechaSis,	Par_UsuarioID,		Par_SucursalID,		Par_CreditoID,
            Par_ClienteID,			Par_AccionID,	Par_RespuestaID,	Par_Comentario,		Par_EtapaCobranza,
            Par_FechaEtregaDoc,
            Par_EmpresaID,			Aud_Usuario,	Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,			Aud_NumTransaccion
		);

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONCAT('Bitacora de Seguimiento de Cobranza Realizada Exitosamente: ', CAST(Var_BitacoraID AS CHAR) );
		SET Var_Control	:= 'creditoID';
		SET Var_Consecutivo:= Var_BitacoraID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;


END TerminaStore$$
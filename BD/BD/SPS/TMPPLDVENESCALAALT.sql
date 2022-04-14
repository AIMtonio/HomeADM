-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDVENESCALAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPPLDVENESCALAALT`;DELIMITER $$

CREATE PROCEDURE `TMPPLDVENESCALAALT`(

	Par_OpcionCajaID		INT(11),
	Par_ClienteID			INT(11),
	Par_UsuarioServicioID	INT(11),
	Par_CuentaAhoID			BIGINT(12),
	Par_MonedaID			INT(11),

	Par_Monto				DECIMAL(12,2),
	Par_FechaOperacion		DATETIME,
	Par_TipoResultEscID		CHAR(1),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr   		INT,

    INOUT Par_ErrMen   		VARCHAR(400),
    INOUT Par_FolioEscala	BIGINT(12),
	Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
		)
TerminaStore: BEGIN

    DECLARE Var_FolioEscala		BIGINT(11);
    DECLARE Var_Control			VARCHAR(20);
    DECLARE Var_Consecutivo		VARCHAR(100);
    DECLARE Var_TipoResultEscID	CHAR(1);
    DECLARE Var_ClienteID		INT(11);



    DECLARE	Cadena_Vacia		CHAR(1);
    DECLARE Decimal_Cero		DECIMAL(12,2);
    DECLARE Entero_Uno			INT;
    DECLARE Entero_Cero			INT;
    DECLARE Fecha_Vacia			DATE;
    DECLARE Salida_SI			CHAR(1);
    DECLARE Salida_No			CHAR(1);
    DECLARE Proceso_OPERACION	VARCHAR(16);
    DECLARE Seguimiento			CHAR(1);
    DECLARE CadenaUno			CHAR(1);


    SET Cadena_Vacia		:= '';
    SET Decimal_Cero		:= 0.0;
    SET Entero_Cero			:= 0;
    SET Entero_Uno			:= 1;
    SET Salida_SI			:= 'S';
    SET Salida_No			:= 'N';
    SET Fecha_Vacia			:= '1900-01-01';
    SET Proceso_OPERACION	:= 'OPERACION';
    SET	Seguimiento			:= 'S';
    SET	CadenaUno			:= '1';


    SET Var_FolioEscala		:= Entero_Cero;
    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-TMPPLDVENESCALAALT');
		END;

        SET	Par_MonedaID				:=	IFNULL(Par_MonedaID, Entero_Cero);
        SET Par_OpcionCajaID			:=	IFNULL(Par_OpcionCajaID, Entero_Cero);
        SET Par_Monto					:=	IFNULL(Par_Monto, Decimal_Cero);
        SET Par_FechaOperacion			:=	IFNULL(Par_FechaOperacion, Fecha_Vacia);
		SET Par_TipoResultEscID			:=	IFNULL(Par_TipoResultEscID, Cadena_Vacia);
        SET Aud_FechaActual				:= NOW();

        IF(IFNULL(Par_CuentaAhoID, Entero_Cero) 			= Entero_Cero
			AND IFNULL(Par_ClienteID,	Entero_Cero) 		= Entero_Cero
            AND IFNULL(Par_UsuarioServicioID, Entero_Cero) 	= Entero_Cero) THEN
			SET Par_NumErr	:= 001;
            SET Par_ErrMen	:= 'El Cliente/Usuario Esta Vacio.';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_CuentaAhoID	!= Entero_Cero) THEN
			SET Par_ClienteID := (SELECT ClienteID from CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);
		END IF;

        IF(Par_MonedaID	= Entero_Cero) THEN
			SET Par_NumErr	:= 002;
            SET Par_ErrMen	:= 'La Moneda se Encuentra Vacia.';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_OpcionCajaID	= Entero_Cero) THEN
			SET Par_NumErr	:= 003;
            SET Par_ErrMen	:= 'La Opcion de la Operacion esta Vacia.';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Monto		= Decimal_Cero) THEN
			SET Par_NumErr	:= 004;
            SET Par_ErrMen	:= 'El Monto Esta Vacio.';
			SET Var_Control := 'monto';
			LEAVE ManejoErrores;
        END IF;

        IF(Par_FechaOperacion = Fecha_Vacia) THEN
			SET Par_NumErr	:= 005;
            SET Par_ErrMen	:= 'La Fecha de la Operacion Esta Vacio.';
			SET Var_Control := 'fecha';
			LEAVE ManejoErrores;
        END IF;

		IF(Par_TipoResultEscID = Cadena_Vacia) THEN
			SET Par_NumErr	:= 006;
            SET Par_ErrMen	:= 'El Estatus de la Operacion Esta Vacio.';
			SET Var_Control := 'fecha';
			LEAVE ManejoErrores;
        END IF;

        SET Var_TipoResultEscID := (SELECT Par_TipoResultEscID FROM TIPORESULESCPLD WHERE TipoResultEscID=Par_TipoResultEscID);
        SET Var_TipoResultEscID := IFNULL(Var_TipoResultEscID,Cadena_Vacia);
        IF(Var_TipoResultEscID = Cadena_Vacia) THEN
			SET Par_NumErr	:= 007;
            SET Par_ErrMen	:= 'Estatus No Valido.';
			SET Var_Control := 'fecha';
			LEAVE ManejoErrores;
        END IF;

        SET Var_FolioEscala 	:= (SELECT IFNULL(MAX(FolioEscala),Entero_Cero) + Entero_Uno
											FROM TMPPLDVENESCALA);
		INSERT INTO TMPPLDVENESCALA(
			FolioEscala,		OpcionCajaID, 		ClienteID,				UsuarioServicioID,			CuentaAhoID,	MonedaID,
            Monto,				FechaOperacion,		TipoResultEscID,		EmpresaID,					Usuario,		FechaActual,
            DireccionIP,		ProgramaID,			Sucursal,				NumTransaccion)
		VALUES(
			Var_FolioEscala,	Par_OpcionCajaID,	Par_ClienteID,			Par_UsuarioServicioID,		Par_CuentaAhoID,	Par_MonedaID,
			Par_Monto,			Par_FechaOperacion,	Par_TipoResultEscID,	Aud_EmpresaID,				Aud_Usuario,	Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion	);

		CALL PLDOPEESCALAINTALT (
			Var_FolioEscala,	Proceso_OPERACION,		Par_FechaOperacion,		Aud_Sucursal,			Par_ClienteID,
			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			CadenaUno,
			Cadena_Vacia,		Cadena_Vacia,			Aud_Usuario,			Par_TipoResultEscID,	Entero_Cero,
			Cadena_Vacia,		Cadena_Vacia,			Fecha_Vacia,			Salida_No,				Par_NumErr,
			Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
		SET	Par_NumErr		:= 501;
		SET	Par_ErrMen		:=	CONCAT("Para continuar Proceso Requiere Autorizacion, Favor de Verificar con el Personal Autorizado de Escalamiento Interno. Folio de la Solicitud: ",Var_FolioEscala , ".");
		SET Var_Control		:= 'FolioEscalaID' ;
		SET Var_Consecutivo	:= Var_FolioEscala;
		SET Par_FolioEscala	:= Var_FolioEscala;
	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;
END TerminaStore$$
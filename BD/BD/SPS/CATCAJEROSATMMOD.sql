-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCAJEROSATMMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCAJEROSATMMOD`;
DELIMITER $$


CREATE PROCEDURE `CATCAJEROSATMMOD`(
	Par_CajeroID			VARCHAR(20),
	Par_SucursalID			INT(11),
	Par_NumCajeroProsa		VARCHAR(30),
	Par_Ubicacion			VARCHAR(500),
	Par_UsuarioID			INT(11),
	Par_EstadoID			INT(11),


	Par_MunicipioID			INT(11),
	Par_LocalidadID			INT(11),
	Par_ColoniaID			INT(11),
	Par_Calle				VARCHAR(150),
	Par_Numero				VARCHAR(20),


	Par_NumInterior			VARCHAR(20),
	Par_CtaContableMN		VARCHAR(25),
	Par_CtaContableME		VARCHAR(25),
	Par_CtaContaMNTrans		VARCHAR(25),
	Par_CtaContaMETrans		VARCHAR(25),
	Par_NomenclaturaCR		VARCHAR(45),

	Par_Latitud				VARCHAR(10),
	Par_Longitud        	VARCHAR(11),
	Par_CP					VARCHAR(5),
	Par_TipoCajeroID		INT,

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),


    Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT

	)

TerminaStore:BEGIN
-- Declaracion de Variables
DECLARE Var_Control			VARCHAR(50);
DECLARE Var_EstatusUsuario	CHAR(1);


-- Declaracion de Constantes
DECLARE Cadena_Vacia	CHAR;
DECLARE Entero_Cero		INT;
DECLARE SalidaSI		CHAR(1);
DECLARE EstatusActivo	CHAR(1);
DECLARE Decimal_Cero	DECIMAL;

-- Asignacion de Constantes
SET Cadena_Vacia		:='';		-- Cadena Vacia
SET Entero_Cero			:=0;		-- Entero Cero
SET SalidaSI			:='S';		-- Salida SI
SET EstatusActivo		:='A';		-- Estatus Activo
SET Decimal_Cero		:=0.0;		-- DECIMAL Cero.

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-CATCAJEROSATMMOD');
    END;

IF (IFNULL(Par_CajeroID,Cadena_Vacia) = Cadena_Vacia)THEN
	SET Par_NumErr := 1;
	SET Par_ErrMen := "El Numero de Cajero esta vacio";
	SET Var_Control	:='cajeroID';
	LEAVE ManejoErrores;
END IF;

IF (IFNULL(Par_SucursalID,Entero_Cero) = Entero_Cero)THEN
	SET Par_NumErr := 2;
	SET Par_ErrMen := "El Numero de Sucursal esta vacio";
	SET Var_Control	:='sucursalID';
	LEAVE ManejoErrores;
END IF;


IF (IFNULL(Par_NumCajeroProsa, Cadena_Vacia) = Cadena_Vacia)THEN
	SET Par_NumErr := 3;
	SET Par_ErrMen := "El Numero de Cajero PROSA esta vacio";
	SET Var_Control	:='numCajeroPROSA';
	LEAVE ManejoErrores;
END IF;

IF (IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero)THEN
	SET Par_NumErr := 4;
	SET Par_ErrMen := "El Estado esta vacio";
	SET Var_Control	:='estadoID';
	LEAVE ManejoErrores;
END IF;

IF (IFNULL(Par_MunicipioID, Entero_Cero) = Entero_Cero)THEN
	SET Par_NumErr := 5;
	SET Par_ErrMen := "El Municipio esta vacio";
	SET Var_Control	:='municipioID';
	LEAVE ManejoErrores;
END IF;
IF (IFNULL(Par_UsuarioID,Entero_Cero) = Entero_Cero)THEN
	SET Par_NumErr := 6;
	SET Par_ErrMen := "El Numero de Usuario esta vacio";
	SET Var_Control	:='usuarioID';
	LEAVE ManejoErrores;
END IF;

IF (IFNULL(Par_CtaContableMN,Cadena_Vacia) = Cadena_Vacia)THEN
	SET Par_NumErr := 7;
	SET Par_ErrMen := "La Cuenta Contable de la Moneda Nacional esta vacia";
	SET Var_Control	:='ctaContableMN';
	LEAVE ManejoErrores;
END IF;
IF NOT EXISTS(SELECT CuentaCompleta
				FROM CUENTASCONTABLES
					WHERE CuentaCompleta = Par_CtaContableMN)THEN
	SET Par_NumErr := 8;
	SET Par_ErrMen := "La Cuenta Contable indicada para la Moneda Nacional no Existe";
	SET Var_Control	:='ctaContableMN';
	LEAVE ManejoErrores;
END IF;

IF NOT EXISTS(SELECT CuentaCompleta
				FROM CUENTASCONTABLES
					WHERE CuentaCompleta = Par_CtaContableME)THEN
	SET Par_NumErr := 9;
	SET Par_ErrMen := "La Cuenta Contable indicada para la Moneda Extranjera no Existe";
	SET Var_Control	:='ctaContableME';
	LEAVE ManejoErrores;
END IF;

IF NOT EXISTS(SELECT CuentaCompleta
				FROM CUENTASCONTABLES
					WHERE CuentaCompleta = Par_CtaContaMNTrans)THEN
	SET Par_NumErr := 10;
	SET Par_ErrMen := "La Cuenta Contable indicada para la Moneda Nacional en Transito no Existe";
	SET Var_Control	:='ctaContaMNTrans';
	LEAVE ManejoErrores;
END IF;

IF NOT EXISTS(SELECT CuentaCompleta
				FROM CUENTASCONTABLES
					WHERE CuentaCompleta = Par_CtaContaMETrans)THEN
	SET Par_NumErr := 11;
	SET Par_ErrMen := "La Cuenta Contable indicada para la Moneda Extranjera en Transito no Existe";
	SET Var_Control	:='ctaContaMETrans';
	LEAVE ManejoErrores;
END IF;

SELECT  Estatus  INTO Var_EstatusUsuario
    FROM USUARIOS
    WHERE UsuarioID = Par_UsuarioID;

SET Var_EstatusUsuario := IFNULL(Var_EstatusUsuario,Cadena_Vacia);

IF(Var_EstatusUsuario != EstatusActivo)THEN
	SET Par_NumErr := 12;
	SET Par_ErrMen := "El Usuario no se encuentra Activo";
	SET Var_Control	:='usuarioID';
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_Latitud, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 13;
		SET Par_ErrMen := CONCAT('La Latitud de la Sucursal esta vacia.');
		SET Var_Control := 'latitud' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Longitud, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 14;
		SET Par_ErrMen := CONCAT('La Longitud de la Sucursal esta vacia.');
		SET Var_Control := 'longitud' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CP, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 15;
		SET Par_ErrMen := CONCAT('El Codigo Postal esta vacio.');
		SET Var_Control := 'cp' ;
		LEAVE ManejoErrores;
	END IF;

	 IF(IFNULL(Par_TipoCajeroID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 16;
			SET Par_ErrMen := CONCAT('El Tipo de Cajero esta Vacio.');
			SET Var_Control := 'tipoCajeroID' ;
			LEAVE ManejoErrores;
		END IF;


	SET Aud_FechaActual := CURRENT_TIMESTAMP();


UPDATE CATCAJEROSATM SET
		CajeroID		= Par_CajeroID,
		SucursalID		= Par_SucursalID,
		NumCajeroPROSA	= Par_NumCajeroProsa,
		Ubicacion		= Par_Ubicacion,
		UsuarioID		= Par_UsuarioID,

		CtaContableMN	= Par_CtaContableMN,
		CtaContableME	= Par_CtaContableME,
		CtaContaMNTrans	= Par_CtaContaMNTrans,
		CtaContaMETrans	= Par_CtaContaMETrans,

		EstadoID		= Par_EstadoID,
		MunicipioID		= Par_MunicipioID,
		LocalidadID		= Par_LocalidadID,
		ColoniaID		= Par_ColoniaID,

		Calle 			= Par_Calle,
		Numero			= Par_Numero,
		NumInterior		= Par_NumInterior,
		NomenclaturaCR	= Par_NomenclaturaCR,

		Latitud			= Par_Latitud,
		Longitud		= Par_Longitud,
		CP				= Par_CP,
		TipoCajeroID	= Par_TipoCajeroID,

		EmpresaID		=Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		=Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE CajeroID =Par_CajeroID;

	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT("Cajero Modificado Exitosamente: ", Par_CajeroID);
	SET Var_Control	:='cajeroID';

END ManejoErrores;  -- END del Handler de Errores
	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_CajeroID AS consecutivo;
	END IF;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASBCAMOVILALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASBCAMOVILALT`;
DELIMITER $$

CREATE PROCEDURE `CUENTASBCAMOVILALT`(
# =====================================================================================
# ------- STORE PARA REALIZAR EL ALTA DE LAS CUENTAS DE BANCA MOVIL PADEMOBILE --------
# =====================================================================================
	Par_ClienteID		   INT(11),
	Par_CuentaAhoID		   BIGINT(12),
	Par_Telefono		   VARCHAR(20),
	Par_UsuarioPDMID	   INT(11),
	Par_RegistroPDM		   CHAR(1),

	Par_Salida			   CHAR(1),
	INOUT Par_NumErr	   INT,
	INOUT Par_ErrMen	   VARCHAR(350),

	Par_EmpresaID		   INT(11),
	Aud_Usuario			   INT(11),
	Aud_FechaActual		   DATETIME,
	Aud_DireccionIP		   VARCHAR(20),
	Aud_ProgramaID		   VARCHAR(50),
	Aud_Sucursal		   INT(11),
	Aud_NumTransaccion	   BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);        -- Cadena vacia
	DECLARE	Entero_Cero		INT;            -- Entero Cero
	DECLARE	Decimal_Cero	DECIMAL(18,2);  -- Decimal _cero
	DECLARE	Fecha_Vacia		DATE;           -- Fecha Vacia
	DECLARE SalidaSI 		CHAR(1);        -- Salida si
	DECLARE	SalidaNO		CHAR(1);        -- Salida no
	DECLARE Est_Acti		CHAR(1);		-- Estatus Activo

	-- Declaracion de Variables
	DECLARE Var_Control	    VARCHAR(200); 	-- Variable de control
	DECLARE Var_Consecutivo	BIGINT(20);    	-- Variable consecutivo
	DECLARE Var_Folio		BIGINT(20);		-- Variable para el Folio de la cuenta
	DECLARE Var_FechaRegis	DATETIME;		-- Variable para la Fecha de Registro

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';             -- Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01 00:00:00';   -- Fecha Vacia
	SET	Entero_Cero		:= 0;              -- Entero Cero
	SET	Decimal_Cero	:= 0.0;            -- Decimal cero
	SET SalidaSI 	   	:= 'S';            -- Salida SI
	SET	SalidaNO		:= 'N';            -- Salida NO
	SET Est_Acti		:= 'A';			   -- Estatus Activo

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr	= 999;
					SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASBCAMOVILALT');
					SET Var_Control = 'sqlException';
				END;

		-- QUE LA CUENTA EXISTA EN LA TABLA CUENTASAHO
		IF NOT EXISTS (SELECT	CuentaAhoID
			FROM CUENTASAHO
			WHERE	CuentaAhoID	= Par_CuentaAhoID
              AND	Estatus	= Est_Acti) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := CONCAT('La cuenta ',Par_CuentaAhoID, ' no Existe');
			SET Var_Control:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		-- QUE EL CLIENTE EN LA TABLA CLIENTES
		IF NOT EXISTS (SELECT	CL.ClienteID
			FROM CUENTASAHO CA
				INNER JOIN CLIENTES CL ON CA.ClienteID = CL.ClienteID
			WHERE	CuentaAhoID = Par_CuentaAhoID
			  AND	CL.Estatus = Est_Acti) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El cliente no Existe';
			SET Var_Control:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Telefono,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'El Telefono esta Vacio.';
			SET Var_Control:= 'Telefono' ;
			LEAVE ManejoErrores;
		END IF;

		-- QUE LA CUENTA EXISTA EN LA TABLA CUENTASBSCMOVIL
		IF EXISTS (SELECT	ClienteID
			FROM CUENTASBCAMOVIL
			WHERE	ClienteID	= Par_ClienteID
			  AND	Telefono = Par_Telefono) THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := CONCAT('El Cliente ',Par_ClienteID, ' ya se Encuentra Registrado');
			SET Var_Control:= 'cuentasBcaMovID' ;
			LEAVE ManejoErrores;
		END IF;

		-- QUE LA CUENTA EXISTA EN LA TABLA CUENTASBSCMOVIL
		IF EXISTS (SELECT	ClienteID
			FROM CUENTASBCAMOVIL
			WHERE	ClienteID != Par_ClienteID
			  AND	Telefono = Par_Telefono) THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := CONCAT('El Numero Telefonico ',Par_Telefono, ' Se Encuentra Asociado a una Cuenta');
			SET Var_Control:= 'cuentasBcaMovID' ;
			LEAVE ManejoErrores;
		END IF;

		-- SE SETEA EL VALOR DEL FOLIO DE PARAMETROS INCREMENTANDO EN 1
		SET Var_Folio := (SELECT IFNULL(MAX(CuentasBcaMovID),Entero_Cero) + 1 FROM CUENTASBCAMOVIL);
		-- FECHA REGISTRO
		SET Var_FechaRegis 	:= CURRENT_TIMESTAMP();
		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		INSERT INTO CUENTASBCAMOVIL (
			CuentasBcaMovID,	ClienteID,		CuentaAhoID,	Telefono,	UsuarioPDMID,
			RegistroPDM,		Estatus,		FechaRegistro,	EmpresaID,	Usuario,
			FechaActual,		DireccionIP,	ProgramaID,		Sucursal,	NumTransaccion)

		VALUES(
			Var_Folio,			Par_ClienteID,			Par_CuentaAhoID,	Par_Telefono,	Par_UsuarioPDMID,
			Par_RegistroPDM,	Est_Acti,				Var_FechaRegis,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		CALL HISTOBCAMOVILALT(
			Var_Folio,		Est_Acti,		Var_FechaRegis,		SalidaNO,			Par_NumErr,
			Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'cuentasBcaMovID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT("Alta En Banca Movil Exitosamente: ", CONVERT(Var_Folio, CHAR));
		SET Var_Control:= 'cuentasBcaMovID';
		SET Var_Consecutivo:= Var_Folio;


	END ManejoErrores;

		IF (Par_Salida = SalidaSI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$
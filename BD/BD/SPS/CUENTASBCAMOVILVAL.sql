-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASBCAMOVILVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASBCAMOVILVAL`;DELIMITER $$

CREATE PROCEDURE `CUENTASBCAMOVILVAL`(
# =====================================================================================
# ------- STORE PARA REALIZAR EL ALTA DE LAS CUENTAS DE BANCA MOVIL PADEMOBILE --------
# =====================================================================================
	Par_ClienteID		   	INT(11),		-- ID cliente
	Par_CuentaAhoID		   	BIGINT(12),		-- Cuenta de ahorro
	Par_Telefono		   	VARCHAR(20),	-- Telefono
	Par_UsuarioPDMID	   	INT(11),		-- ID usuario PDM

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control	    VARCHAR(200); 	-- Variable de control
	DECLARE Var_Consecutivo	BIGINT(20);    	-- Variable consecutivo

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);        -- Cadena vacia
	DECLARE	Entero_Cero		INT;            -- Entero Cero
	DECLARE	Decimal_Cero	DECIMAL(18,2);  -- Decimal _cero
	DECLARE	Fecha_Vacia		DATE;           -- Fecha Vacia
	DECLARE SalidaSI 		CHAR(1);        -- Salida si

	DECLARE	SalidaNO		CHAR(1);        -- Salida no
	DECLARE Est_Acti		CHAR(1);		-- Estatus Activo

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';             -- Cadena Vacia
	SET	Entero_Cero		:= 0;              -- Entero Cero
	SET	Decimal_Cero	:= 0.0;            -- Decimal cero
	SET	Fecha_Vacia		:= '1900-01-01';   -- Fecha Vacia
	SET SalidaSI 	   	:= 'S';            -- Salida SI

	SET	SalidaNO		:= 'N';            -- Salida NO
	SET Est_Acti		:= 'A';			   -- Estatus Activo

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr	= 999;
					SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASBCAMOVILVAL');
					SET Var_Control = 'sqlException';
				END;

		-- QUE LA CUENTA EXISTA EN LA TABLA CUENTASAHO
		IF NOT EXISTS (	SELECT	CuentaAhoID
						FROM CUENTASAHO
						WHERE	CuentaAhoID	= Par_CuentaAhoID
							AND	Estatus	= Est_Acti) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := CONCAT('La cuenta ',Par_CuentaAhoID, ' no Existe');
			SET Var_Control:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		-- QUE EXISTA EL CLIENTE EN LA TABLA CLIENTES
		IF NOT EXISTS (	SELECT	CL.ClienteID
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
		IF EXISTS (	SELECT	ClienteID
					FROM CUENTASBCAMOVIL
					WHERE	ClienteID	= Par_ClienteID
						AND	Telefono = Par_Telefono) THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := CONCAT('El Cliente ',Par_ClienteID, ' ya se Encuentra Registrado');
			SET Var_Control:= 'cuentasBcaMovID' ;
			LEAVE ManejoErrores;
		END IF;

		-- QUE LA CUENTA EXISTA EN LA TABLA CUENTASBSCMOVIL
		IF EXISTS (	SELECT	ClienteID
					FROM CUENTASBCAMOVIL
					WHERE	ClienteID != Par_ClienteID
						AND	Telefono = Par_Telefono) THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := CONCAT('El Numero Telefonico ',Par_Telefono, ' Se Encuentra Asociado a una Cuenta');
			SET Var_Control:= 'cuentasBcaMovID' ;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 000;
		SET Par_ErrMen := "Validacion Banca Movil Realizada Exitosamente: ";
		SET Var_Control:= 'cuentasBcaMovID';
		SET Var_Consecutivo:= Entero_Cero;

	END ManejoErrores;

		IF (Par_Salida = SalidaSI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$
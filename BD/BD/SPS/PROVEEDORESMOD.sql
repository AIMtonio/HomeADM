
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------

-- PROVEEDORESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROVEEDORESMOD`;

DELIMITER $$
CREATE PROCEDURE `PROVEEDORESMOD`(
/* MODIFICACIÓN DE PROVEEDORES */
	Par_ProveedorID 		INT,
	Par_InstitucionID 		INT,
	Par_ApellidoPaterno		VARCHAR(50),
	Par_ApellidoMaterno		VARCHAR(50),
	Par_PrimerNombre		VARCHAR(50),

	Par_SegundoNombre		VARCHAR(50),
	Par_TipoPersona			CHAR(1),
	Par_FechaNacimiento		DATE,
	Par_CURP				CHAR(18),
	Par_RazonSocial			VARCHAR(150),

	Par_RFC					CHAR(13),
	Par_RFCpm				CHAR(13),
	Par_TipoPago			CHAR(1),
	Par_CuentaClave			CHAR(18),
	Par_CuentaComple		VARCHAR(25),

	Par_CuentaAntic			VARCHAR(25),
	Par_TipoProveedor		INT,
	Par_Correo				VARCHAR(50),
	Par_Telefono			VARCHAR(20),
	Par_TelefonoCelular		VARCHAR(20),

	Par_ExtTelefonoPart		VARCHAR(6),
    Par_TipoTercero			VARCHAR(2),
    Par_TipoOperacion		VARCHAR(2),
    Par_PaisResidencia		VARCHAR(2),
    Par_Nacionalidad		VARCHAR(40),

    Par_NumIDFiscal			VARCHAR(40),
	Par_PaisNacimiento		INT(12),
	Par_EstadoNacimiento	INT(12),
	Par_Salida				CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr		INT,			-- Numero de Error

	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_ProveedorID		INT;
DECLARE	Var_Control     	CHAR(15);
DECLARE Var_TipProvID		INT(12);
DECLARE Var_CtaConta		CHAR(25);
DECLARE Var_CtaAnticip		CHAR(25);
DECLARE Var_NombreCompleto	VARCHAR(200);
DECLARE Var_SoloNombres		VARCHAR(500);
DECLARE Var_SoloApellidos	VARCHAR(500);
DECLARE	Var_RazonSocialPLD	VARCHAR(200);
DECLARE Var_DetectaGAFI		CHAR(1);

-- Declaracion de Constantes
DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Pers_Moral			CHAR(1);
DECLARE Pers_Fisica			CHAR(1);
DECLARE	ConstanteSI        	CHAR(1);
DECLARE	ConstanteNO        	CHAR(1);
DECLARE	EsProveedor        	CHAR(3);

-- Asignacion de Constantes
SET Entero_Cero 			:=0;				-- Entero cero
SET Cadena_Vacia			:='';				-- Cadena vacia
SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
SET Decimal_Cero			:= 0.00;			-- Decimal cero
SET Pers_Moral          	:= 'M';				-- Persona moral
SET Pers_Fisica         	:= 'F';				-- Persona Fisica
SET	ConstanteSI        		:= 'S';				-- Salida Si
SET	ConstanteNO        		:= 'N'; 			-- Salida No
SET	EsProveedor        		:= 'PRV'; 			-- Es proveedor

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PROVEEDORESMOD.');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(Par_TipoPersona = Pers_Fisica)THEN
		IF(NOT EXISTS(SELECT ProveedorID FROM PROVEEDORES  WHERE ProveedorID = Par_ProveedorID))THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Proveedor Especificado No Existe.';
			SET Var_Control:= 'proveedorID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PrimerNombre, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Primer Nombre esta vacio.';
			SET Var_Control:= 'primerNombre' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ApellidoPaterno, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El Apellido Paterno esta vacio.';
			SET Var_Control:= 'apellidoPaterno' ;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'La Fecha de Nacimiento esta vacia.';
			SET Var_Control:= 'fechaNacimiento' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := 'El RFC esta vacio.';
			SET Var_Control:= 'RFC' ;
			LEAVE ManejoErrores;
		END IF;
		SET Var_NombreCompleto  := FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre,Cadena_Vacia,Par_ApellidoPaterno,Par_ApellidoMaterno);
		SET Var_SoloNombres		:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Par_PrimerNombre,Par_SegundoNombre,Cadena_Vacia,Cadena_Vacia,Cadena_Vacia),'MA'),500);
		SET Var_SoloApellidos	:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Cadena_Vacia,Cadena_Vacia,Cadena_Vacia,Par_ApellidoPaterno,Par_ApellidoMaterno),'MA'),500);
		SET Var_DetectaGAFI		:= ConstanteSI;
		SET Var_RazonSocialPLD	:= Cadena_Vacia;
	END IF;

	IF(Par_TipoPersona = Pers_Moral)THEN
		IF(IFNULL(Par_RazonSocial, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr := 7;
			SET Par_ErrMen := 'La Razón Social esta vacia.';
			SET Var_Control:= 'razonSocial' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_RFCpm, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr := 8;
			SET Par_ErrMen := 'El RFC esta vacio.';
			SET Var_Control:= 'RFCpm' ;
			LEAVE ManejoErrores;
		END IF;
		SET Var_NombreCompleto  	:= Par_RazonSocial;
		SET Var_SoloNombres			:= Cadena_Vacia;
		SET Var_SoloApellidos		:= Cadena_Vacia;
		SET Par_PaisNacimiento		:= NULL;
		SET Par_EstadoNacimiento	:= NULL;
		SET Var_DetectaGAFI			:= ConstanteSI;
		SET Var_RazonSocialPLD		:= LEFT(FNLIMPIACARACTERESGEN(Par_RazonSocial,'MA'),200);
	END IF;

	 -- valida la Cuenta Contable (CxP):
	CALL CUENTASCONTABLESVAL(	Par_CuentaComple,	ConstanteNO,		Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
								Aud_NumTransaccion);
	
	-- Validamos la respuesta
	IF(Par_NumErr <> Entero_Cero) THEN
		SET Par_NumErr := 8;
		SET Par_ErrMen := CONCAT(Par_ErrMen, ', Cuenta Contable (CxP):');
		SET Var_Control:= 'cuentaCompleta' ;
		LEAVE ManejoErrores;
	END IF;

	-- valida la Cuenta Constable Anticipos
	CALL CUENTASCONTABLESVAL(	Par_CuentaAntic,	ConstanteNO,		Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
								Aud_NumTransaccion);
	
	-- Validamos la respuesta
	IF(Par_NumErr <> Entero_Cero) THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen := CONCAT(Par_ErrMen, ', Cuenta Constable Anticipos');
		SET Var_Control:= 'cuentaAnticipo' ;
		LEAVE ManejoErrores;
	END IF;

	SET Var_TipProvID := (SELECT TipoProveedorID FROM TIPOPROVEEDORES WHERE TipoProveedorID = Par_TipoProveedor);

	IF(IFNULL(Var_TipProvID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 10;
		SET Par_ErrMen := 'El tipo de Proveedor especificado no existe.';
		SET Var_Control:= 'tipoProveedorID' ;
		LEAVE ManejoErrores;
	END IF;

	/*SECCION PLD: Deteccion de operaciones inusuales*/
	CALL PLDDETECCIONPRO(
		Par_ProveedorID,		Par_PrimerNombre,		Par_SegundoNombre,		Cadena_Vacia,			Par_ApellidoPaterno,
		Par_ApellidoMaterno,	Par_TipoPersona,		Par_RazonSocial,		Par_RFC,				Par_RFCpm,
		Par_FechaNacimiento,	Entero_Cero,			Par_PaisNacimiento,		Par_EstadoNacimiento,	Var_NombreCompleto,
		EsProveedor,			ConstanteSI,			ConstanteSI,			Var_DetectaGAFI,		ConstanteNO,
		Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	IF(Par_NumErr!=Entero_Cero)THEN
		SET Par_NumErr			:= 50; # NO CAMBIAR ESTE NUMERO DE ERROR
		SET Var_Control			:= 'agrega';
		LEAVE ManejoErrores;
	END IF;
	/*FIN SECCION PLD: Deteccion de operaciones inusuales*/

	SET Aud_FechaActual := NOW();

	UPDATE PROVEEDORES SET
		InstitucionID	= Par_InstitucionID,
		ApellidoPaterno	= Par_ApellidoPaterno,
		ApellidoMaterno	= Par_ApellidoMaterno,
		PrimerNombre	= Par_PrimerNombre,
		SegundoNombre	= Par_SegundoNombre,

		TipoPersona		= Par_TipoPersona,
		FechaNacimiento	= Par_FechaNacimiento,
		CURP			= Par_CURP,
		RazonSocial		= Par_RazonSocial,
		RFC				= Par_RFC,

		RFCpm			= Par_RFCpm,
		TipoPago		= Par_TipoPago,
		CuentaClave		= Par_CuentaClave,
		CuentaCompleta  = Par_CuentaComple,
		CuentaAnticipo  = Par_CuentaAntic,

		TipoProveedor	= Par_TipoProveedor,
		Correo			= Par_Correo,
		Telefono		= Par_Telefono,
		TelefonoCelular	= Par_TelefonoCelular,
		ExtTelefonoPart = Par_ExtTelefonoPart,

		TipoTerceroID	= Par_TipoTercero,
		TipoOperacionID = Par_TipoOperacion,
		PaisID			= Par_PaisResidencia,
		Nacionalidad	= Par_Nacionalidad,
		NumIDFiscal		= Par_NumIDFiscal,

		PaisNacimiento	= Par_PaisNacimiento,
		EstadoNacimiento = Par_EstadoNacimiento,
		SoloNombres 	= Var_SoloNombres,
		SoloApellidos 	= Var_SoloApellidos,
		RazonSocialPLD	= Var_RazonSocialPLD,

		NombreCompleto	= Var_NombreCompleto,
		EmpresaID		= Aud_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,

		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion 	= Aud_NumTransaccion
	WHERE ProveedorID 	= Par_ProveedorID;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT("Proveedor Modificado Exitosamente: ", CONVERT(Par_ProveedorID, CHAR));
	SET Var_Control:= 'proveedorID' ;

END ManejoErrores;

IF (Par_Salida = ConstanteSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Par_ProveedorID AS Consecutivo;
END IF;

END TerminaStore$$


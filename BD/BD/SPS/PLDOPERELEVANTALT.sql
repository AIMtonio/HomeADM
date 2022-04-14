
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPERELEVANTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPERELEVANTALT`;

DELIMITER $$
CREATE PROCEDURE `PLDOPERELEVANTALT`(
	-- SP DE ALTA DE OPERACIONES RELEVANTES.
	Par_SucursalID				INT(11),			-- Clave O Id De La Sucursal.
	Par_Fecha					DATE,				-- Fecha De La Operacion.
	Par_Hora					TIME,				-- Hora De La Operacion.
	Par_Localidad				VARCHAR(10),		-- Clave De La Localidad  A La Que Corresponde La Sucursal.
	Par_TipoOperacionID			VARCHAR(3),			-- Clave Del Tipo De Operación Realizada.

	Par_ClienteID				INT(11),			-- Clave O Id Del Cliente.
	Par_CuentaAhoID				BIGINT(12),			-- Núm. de la Cuenta de Ahorro.
	Par_Monto					DOUBLE,				-- Monto De La Transaccion Realizada En La Moneda Original.
	Par_ClaveMoneda				VARCHAR(3),			-- ID de la Moneda Original.
	Par_DescripcionOper			VARCHAR(100),		-- Descripcion De La Operacion O Transaccion Reportada Como Operacion Reelevante.

	Par_UsuarioServicioID		INT(11),			-- Numero de Usuario de Servicio
	Par_Salida					CHAR(1),			-- Indica El Tipo De Salida S.- Si N.- No.
	INOUT Par_NumErr			INT,				-- Numero De Error.
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje De Error.
	INOUT Par_Consecutivo		INT(11),			-- Numero De Operación Relevante.

    -- Parametros de Auditoria
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),

	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_ApellidoMat			VARCHAR(50);		-- Apellido Materno Del Cliente.
DECLARE Var_ApellidoPat			VARCHAR(50);		-- Apellido Paterno Del Cliente.
DECLARE Var_Calle				VARCHAR(100);		-- Calle Del Cliente.
DECLARE Var_Colonia				VARCHAR(200);		-- Colonia Del Cliente.
DECLARE Var_Control				CHAR(15);			-- Campo Control.
DECLARE Var_CP					CHAR(5);			-- Codigo Postal Del Cliente.
DECLARE Var_EstadoID			INT(11);			-- Estado Del Cliente.
DECLARE Var_Localidad			VARCHAR(10);		-- Localidad Del Cliente.
DECLARE Var_MunicipioID			INT(11);			-- Municipio Del Cliente.
DECLARE Var_NombreCompleto		VARCHAR(200);		-- Colonia Del Cliente.
DECLARE Var_OpeReelevanteID		INT(11);			-- Número de la op. relevante.
DECLARE Var_PrimerNombre		VARCHAR(50);		-- Primer Nombre Del Cliente.
DECLARE Var_RFC					CHAR(13);			-- Rfc Del cliente.
DECLARE Var_SegundoNombre		VARCHAR(50);		-- Segundo Nombre Del Cliente.
DECLARE Var_TercerNombre		VARCHAR(50);		-- Tercer Nombre Del Cliente.
DECLARE Var_Mayusculas			CHAR(2);			-- Mayusculas.

-- Declaracion de Constantes
DECLARE Cadena_Vacia			VARCHAR(1);
DECLARE Fecha_Vacia				DATE;
DECLARE Entero_Cero				INT(11);
DECLARE Str_SI					CHAR(1);
DECLARE Str_NO					CHAR(1);
DECLARE InstMonEfectivo			VARCHAR(3);
DECLARE TipoOpRelevante			INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia				:= '';				-- Cadena vacia
SET Fecha_Vacia					:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero					:= 0;				-- Entero Cero
SET Str_SI						:= 'S';				-- Constante Si
SET Str_NO						:= 'N'; 			-- Constante No
SET InstMonEfectivo				:= '01'; 			-- EFECTIVO
SET TipoOpRelevante				:= 01;				-- Tipo de Operación Relevante.
SET Var_Mayusculas				:= 'MA';			-- Obtener el resultado en Mayusculas

SET Aud_FechaActual				:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPERELEVANTALT');
			SET Var_Control:= 'sqlException' ;
		END;

	SET Var_OpeReelevanteID := (SELECT IFNULL(MAX(OpeReelevanteID),Entero_Cero) + 1 FROM PLDOPEREELEVANT);
	SET Par_UsuarioServicioID	:= IFNULL(Par_UsuarioServicioID,Entero_Cero);

    -- INICIO SI ES UN CLIENTE
    IF(Par_ClienteID > Entero_Cero)THEN
		-- DATOS DEL CLIENTE.
		SELECT
			C.PrimerNombre,	C.SegundoNombre,		C.TercerNombre,		C.ApellidoPaterno,	C.ApellidoMaterno,
			C.RFCOficial,	C.NombreCompleto
		INTO
			Var_PrimerNombre,	Var_SegundoNombre,	Var_TercerNombre,	Var_ApellidoPat,	Var_ApellidoMat,
			Var_RFC,			Var_NombreCompleto
		FROM CLIENTES AS C
			WHERE C.ClienteID = Par_ClienteID;

		-- DATOS DE LA DIRECCION OFICIAL DEL CLIENTE.
		SELECT
			RIGHT(FNGENDIRECCION(3,
				DIR.EstadoID,			DIR.MunicipioID,	DIR.LocalidadID,	DIR.ColoniaID,
				DIR.Calle,				DIR.NumeroCasa,		DIR.NumInterior,	DIR.Piso,	DIR.PrimeraEntreCalle,
				DIR.SegundaEntreCalle,	DIR.CP,				DIR.Descripcion,	DIR.Lote,	DIR.Manzana),100) AS Calle,
			FNGENDIRECCION(4,
				DIR.EstadoID,			DIR.MunicipioID,	DIR.LocalidadID,	DIR.ColoniaID,
				DIR.Calle,				DIR.NumeroCasa,		DIR.NumInterior,	DIR.Piso,	DIR.PrimeraEntreCalle,
				DIR.SegundaEntreCalle,	DIR.CP,				DIR.Descripcion,	DIR.Lote,	DIR.Manzana) AS Colonia,
			FNGETPLDSITILOC(EstadoID, MunicipioID, LocalidadID),
			DIR.CP,		DIR.MunicipioID,	DIR.EstadoID
		INTO
			Var_Calle,	Var_Colonia,		Var_Localidad,		Var_CP,		Var_MunicipioID,
			Var_EstadoID
		FROM DIRECCLIENTE AS DIR
		WHERE DIR.ClienteID = Par_ClienteID
			AND DIR.Oficial = Str_SI;
	END IF;
    -- FIN SI ES UN CLIENTE

    -- INICIO SI ES UN USUARIO DE SERVICIO
    IF(Par_UsuarioServicioID > Entero_Cero)THEN
		-- DATOS DEL USUARIO DE SERVICIO
		SELECT
			PrimerNombre,		SegundoNombre,		TercerNombre,		ApellidoPaterno,	ApellidoMaterno,
			RFCOficial,			NombreCompleto,
			RIGHT(FNGENDIRECCION(3,
				EstadoID,		MunicipioID,		LocalidadID,		ColoniaID,
				Calle,			NumExterior,		NumInterior,		Piso,				Cadena_Vacia,
				Cadena_Vacia,	CP,					Cadena_Vacia,		Lote,				Manzana),100) AS Calle,
			FNGENDIRECCION(4,
				EstadoID,		MunicipioID,		LocalidadID,		ColoniaID,
				Calle,			NumExterior,		NumInterior,		Piso,				Cadena_Vacia,
				Cadena_Vacia,	CP,					Cadena_Vacia,		Lote,				Manzana) AS Colonia,
			FNGETPLDSITILOC(EstadoID, MunicipioID, LocalidadID),
			CP,					MunicipioID,		EstadoID
		INTO
			Var_PrimerNombre,	Var_SegundoNombre,	Var_TercerNombre,	Var_ApellidoPat,	Var_ApellidoMat,
			Var_RFC,			Var_NombreCompleto,	Var_Calle,			Var_Colonia,		Var_Localidad,
			Var_CP,				Var_MunicipioID,	Var_EstadoID
		FROM USUARIOSERVICIO
			WHERE UsuarioServicioID = Par_UsuarioServicioID;
	END IF;
	-- FIN SI ES UN USUARIO DE SERVICIO

	SET Var_PrimerNombre	:= IFNULL(Var_PrimerNombre, Cadena_Vacia);
	SET Var_SegundoNombre	:= IFNULL(Var_SegundoNombre, Cadena_Vacia);
	SET Var_TercerNombre	:= IFNULL(Var_TercerNombre, Cadena_Vacia);
	SET Var_ApellidoPat		:= IFNULL(Var_ApellidoPat, Cadena_Vacia);
	SET Var_ApellidoMat		:= IFNULL(Var_ApellidoMat, Cadena_Vacia);
	SET Var_RFC				:= IFNULL(Var_RFC, Cadena_Vacia);
	SET Var_NombreCompleto	:= IFNULL(Var_NombreCompleto, Cadena_Vacia);
	SET Var_Calle			:= IFNULL(Var_Calle, Cadena_Vacia);
	SET Var_Colonia			:= IFNULL(Var_Colonia, Cadena_Vacia);
	SET Var_Localidad		:= IFNULL(Var_Localidad, Cadena_Vacia);
	SET Var_CP				:= IFNULL(Var_CP, Cadena_Vacia);
	SET Var_MunicipioID		:= IFNULL(Var_MunicipioID, Entero_Cero);
	SET Var_EstadoID		:= IFNULL(Var_EstadoID, Entero_Cero);

	INSERT INTO PLDOPEREELEVANT(
		OpeReelevanteID,		SucursalID,				Fecha,					Hora,					Localidad,
		TipoOperacionID,		InstrumentMonID,		ClienteID,				CuentaAhoID,			Monto,
		ClaveMoneda,			PrimerNombreCliente,	SegundoNombreCliente,	TercerNombreCliente,	ApellidoPatCliente,
		ApellidoMatCliente,		RFC,					Calle,					ColoniaCliente,			LocalidadCliente,
		CP,						MunicipioID,			EstadoID,				DescripcionOper,		NombreCompleto,
        UsuarioServicioID,		EmpresaID,				Usuario,				FechaActual,			DireccionIP,
        ProgramaID,				Sucursal,				NumTransaccion)
	VALUES(
		Var_OpeReelevanteID,	Par_SucursalID,			Par_Fecha,				Par_Hora,				Par_Localidad,
		Par_TipoOperacionID,	InstMonEfectivo,		Par_ClienteID,			Par_CuentaAhoID,		Par_Monto,
		Par_ClaveMoneda,		Var_PrimerNombre,		Var_SegundoNombre,		Var_TercerNombre,		Var_ApellidoPat,
		Var_ApellidoMat,		Var_RFC,				Var_Calle,				Var_Colonia,			Var_Localidad,
		Var_CP,					Var_MunicipioID,		Var_EstadoID,			Par_DescripcionOper,	Var_NombreCompleto,
        Par_UsuarioServicioID,	Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
        Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	-- REGISTRO DE LA ALERTA
	CALL PLDENVALERTASPRO(
		TipoOpRelevante,	Var_OpeReelevanteID,	Str_NO,				Par_NumErr,			Par_ErrMen,
		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_ErrMen != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Operacion Grabada Exitosamente.';
	SET Var_Control:= 'operacionID' ;

END ManejoErrores;

	IF (Par_Salida = Str_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$


-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDHISREELEVANALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDHISREELEVANALT`;
DELIMITER $$

CREATE PROCEDURE `PLDHISREELEVANALT`(
	-- SP QUE GUARDA EN EL HISTORICO LAS OPERACIONES RELEVANTES
	Par_EmpresaID				INT,			-- ID de la Empresa
	Par_FechaGeneracion			DATE,			-- Fecha de Generacion del Reporte
	Par_PeriodoID				INT,			-- ID del periodo de generacion del reporte
	Par_PeriodoInicio			DATE,			-- Fecha de Inicio del Periodo
	Par_PeriodoFin				DATE,			-- Fecha Final del Periodo

	Par_Archivo					VARCHAR(45),	-- Nombre del Archivo Generado
	Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT,			-- Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Error
    -- Parametros de Auditoria
	Aud_Usuario					INT(11),

	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	NumOperacion			INT(11);
DECLARE	Sucursal				INT(11);
DECLARE	FechaOperacion			DATE;
DECLARE	HoraOperacion			TIME;
DECLARE	LocalidadSucursal		VARCHAR(10);
DECLARE	TipoOperacion			INT(11);
DECLARE	InsMone					INT(11);
DECLARE	Cliente					INT(11);
DECLARE	MontoOperacion			DOUBLE;
DECLARE	Moneda					INT(11);
DECLARE	PrimerNom				VARCHAR(45);
DECLARE	SegundoNom				VARCHAR(45);
DECLARE	TercerNom				VARCHAR(45);
DECLARE	ApPat					VARCHAR(45);
DECLARE	ApMat					VARCHAR(45);
DECLARE	RfcCliente				CHAR(13);
DECLARE	RfcPermor				CHAR(12);
DECLARE	Domicilio				VARCHAR(100);
DECLARE	varColonia				VARCHAR(45);
DECLARE	varLocalidad			VARCHAR(45);
DECLARE	CpCte					CHAR(5);
DECLARE	MunicipioCte			INT(11);
DECLARE	EstadoCte				INT(11);

-- Concatenar el domicilio
DECLARE	VarCalle			VARCHAR(50);
DECLARE	Num					CHAR(10);
DECLARE	Interior			CHAR(10);
DECLARE	VarPiso				CHAR(10);

-- Declaracion de Constantes
DECLARE	Con_Cadena_Vacia	VARCHAR(1);
DECLARE	Con_Fecha_Vacia		DATE;
DECLARE	Con_Entero_Cero		INT(11);
DECLARE	SalidaSI        	CHAR(1);
DECLARE	SalidaNO        	CHAR(1);
DECLARE	varControl        	CHAR(15);

-- Asignacion de Constantes
SET Con_Cadena_Vacia		:= '';				-- Cadena vacia
SET Con_Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Con_Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        		:= 'S';				-- Salida Si
SET	SalidaNO        		:= 'N'; 			-- Salida No


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDHISREELEVANALT');
		END;

	IF(IFNULL(Par_FechaGeneracion, Con_Fecha_Vacia)) = Con_Fecha_Vacia THEN
		SET Par_NumErr :='001';
		SET Par_ErrMen := 'La Fecha de Generacion esta vacia';
		SET varControl:= 'fechaGeneracion' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PeriodoID, Con_Entero_Cero)) = Con_Entero_Cero THEN
		SET Par_NumErr :='002';
		SET Par_ErrMen := 'El Periodo esta vacio';
		SET varControl:= 'periodoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PeriodoInicio, Con_Fecha_Vacia)) = Con_Fecha_Vacia THEN
		SET Par_NumErr :='003';
		SET Par_ErrMen := 'La Fecha Inicial esta vacia';
		SET varControl:= 'periodoInicio' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PeriodoFin, Con_Fecha_Vacia)) = Con_Fecha_Vacia THEN
		SET Par_NumErr :='004';
		SET Par_ErrMen := 'La Fecha Final esta vacia';
		SET varControl:= 'periodoFin' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Archivo, Con_Cadena_Vacia)) = Con_Cadena_Vacia THEN
		SET Par_NumErr :='005';
		SET Par_ErrMen := 'El Nombre del Archivo esta vacio';
		SET varControl:= 'archivo' ;
		LEAVE ManejoErrores;
	END IF;
    SET Aud_FechaActual := NOW();

	IF(EXISTS(SELECT Fecha
				FROM PLDOPEREELEVANT
				WHERE Fecha>=Par_PeriodoInicio AND Fecha<=Par_PeriodoFin)) THEN

		SET @Var_OpeRelHist := (SELECT IFNULL(MAX(OpeReelevanteID), Con_Entero_Cero) FROM `PLDHIS-REELEVAN` WHERE FechaGeneracion = Par_FechaGeneracion);

		INSERT INTO `PLDHIS-REELEVAN`(
			FechaGeneracion,		PeriodoID,					OpeReelevanteID,			PeriodoInicio,				PeriodoFin,
			Archivo,				SucursalID,					Fecha,						Hora,						Localidad,
			TipoOperacionID,		InstrumentMonID,			ClienteID,					CuentaAhoID,				Monto,
			ClaveMoneda,			PrimerNombreCliente,		SegundoNombreCliente,		TercerNombreCliente,		ApellidoPatCliente,
			ApellidoMatCliente,		RFC,						Calle,						ColoniaCliente,				LocalidadCliente,
			CP,						MunicipioID,				EstadoID,					DescripcionOper,			NombreCompleto,
			UsuarioServicioID,		EmpresaID,					Usuario,					FechaActual,				DireccionIP,
			ProgramaID,				Sucursal,					NumTransaccion)
		  SELECT
			Par_FechaGeneracion,	Par_PeriodoID,				(@Var_OpeRelHist := @Var_OpeRelHist + 1),			Par_PeriodoInicio,			Par_PeriodoFin,
			Par_Archivo,			SucursalID,					Fecha,						Hora,						Localidad,
			TipoOperacionID,		InstrumentMonID,			ClienteID,					CuentaAhoID,				Monto,
			ClaveMoneda,			PrimerNombreCliente,		SegundoNombreCliente,		TercerNombreCliente,		ApellidoPatCliente,
			ApellidoMatCliente,		RFC,						Calle,						ColoniaCliente,				LocalidadCliente,
			CP,		     			MunicipioID,				EstadoID, 					DescripcionOper,			NombreCompleto,
			UsuarioServicioID,		Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,		 	Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion

			FROM   PLDOPEREELEVANT
			WHERE Fecha >=Par_PeriodoInicio AND Fecha<=Par_PeriodoFin;

		-- Se eliminan los registros de la tabla de operaciones relevantes
		CALL PLDOPEREELEVANBAJ(
			Par_EmpresaID, 		Par_PeriodoInicio, 		Par_PeriodoFin, 	SalidaNO, 			Par_NumErr,
			Par_ErrMen,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,	  	Aud_NumTransaccion);

		IF(Par_NumErr!=Con_Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	END IF;

    -- Se eliminan los registros de la tabla CNBV de operaciones relevantes
	CALL PLDCNBVOPEREELBAJ(
		Par_EmpresaID, 		Par_PeriodoInicio, 		Par_PeriodoFin, 	SalidaNO, 			Par_NumErr,
		Par_ErrMen,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,	  	Aud_NumTransaccion);

	IF(Par_NumErr!=Con_Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	-- Se guardan los datos en la tabla de la que se toman los datos para generar el reporte a la CNBV
	CALL PLDCNBVOPEREELALT(
		Par_EmpresaID, 		Par_PeriodoInicio, 		Par_PeriodoFin, 	SalidaNO, 			Par_NumErr,
		Par_ErrMen,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,	  	Aud_NumTransaccion);

	IF(Par_NumErr!=Con_Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET	Par_NumErr := Con_Entero_Cero;
	SET	Par_ErrMen := 'Archivo generado con exito.';

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'periodoID' AS control,
			NumOperacion AS consecutivo;
END IF;

END TerminaStore$$
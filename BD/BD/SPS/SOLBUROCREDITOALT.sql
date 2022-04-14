-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLBUROCREDITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLBUROCREDITOALT`;DELIMITER $$

CREATE PROCEDURE `SOLBUROCREDITOALT`(
	/*SP para dar de alta las solicitudes de buro de credito*/
	Par_PrimerNomb		VARCHAR(50),
	Par_SegundoNomb		VARCHAR(50),
	Par_TercerNomb		VARCHAR(50),
	Par_ApellidoPat		VARCHAR(50),
	Par_ApellidoMat		VARCHAR(50),

	Par_RFC				VARCHAR(13),
	Par_FechaConsul  	DATETIME,
	Par_EstadoID		INT,
	Par_MunicipioID		INT,
	Par_Calle			VARCHAR(50),

	Par_NumExterior		CHAR(10),
	Par_NumInterior		CHAR(10),
	Par_Piso			CHAR(10),
	Par_Colonia			VARCHAR(50),
	Par_CP				CHAR(5),

	Par_Lote			CHAR(10),
	Par_Manzana			CHAR(10),
	Par_FechaNac		DATE,
	Par_TipoAlta		CHAR(1),
	Par_LocalidadID		INT(11),

	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),
	/*Auditoria*/
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),

	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control	    	VARCHAR(100);  	-- Variable de control
	DECLARE Var_Consecutivo		VARCHAR(20);     -- Variable consecutivo
	-- Declaracion de constantes
	DECLARE  Entero_Cero		INT;
	DECLARE  Cadena_Vacia		CHAR(1);
	DECLARE  SalidaSI			CHAR(1);
	DECLARE  SalidaNO			CHAR(1);
	DECLARE  Cadena_MensajeBC	VARCHAR(30);
	DECLARE  Cadena_MensajeCC	VARCHAR(30);

	DECLARE  Con_tipoA			CHAR(1);
	DECLARE  Con_tipoB			CHAR(1);
	DECLARE  Con_tipoC			CHAR(1);

	-- Asignacion de constantes
	SET Con_tipoA		:= 'A';
	SET Con_tipoB		:= 'B';
	SET Con_tipoC		:= 'C';
	SET	Entero_Cero		:= 0;
	SET SalidaSI		:='S';
	SET SalidaNO		:='N';
	SET	Cadena_Vacia	:= '';
	SET Cadena_MensajeBC := 'Procesando Respuesta';
	SET Cadena_MensajeCC := 'Procesando Respuesta';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SOLBUROCREDITOALT');
			SET Var_Control := 'sqlException' ;
		END;

		IF(IFNULL(Par_PrimerNomb, Cadena_Vacia))= Cadena_Vacia THEN
			SET	 Par_NumErr := 1;
			SET  Par_ErrMen := 'El Primer Nombre esta Vacio.';
			SET Var_Control	:= 'primerNombre' ;
			SET Var_Consecutivo := Par_PrimerNomb;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ApellidoPat, Cadena_Vacia))= Cadena_Vacia THEN
			SET	 Par_NumErr := 2;
			SET  Par_ErrMen := 'El Apellido Paterno esta Vacio.';
			SET Var_Control	:= 'apellidoPaterno' ;
			SET Var_Consecutivo := Par_ApellidoPat;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_RFC, Cadena_Vacia))= Cadena_Vacia THEN
			SET	 Par_NumErr := 3;
			SET  Par_ErrMen := 'El RFC esta Vacio.';
			SET Var_Control	:= 'RFC' ;
			SET Var_Consecutivo := Par_RFC;
			LEAVE ManejoErrores;
		END IF;

		IF(CHARACTER_LENGTH(Par_RFC) >13)THEN
			SET	 Par_NumErr := 4;
			SET  Par_ErrMen := 'El RFC debe ser de 13 Caracteres.';
			SET Var_Control	:= 'RFC' ;
			SET Var_Consecutivo := Par_RFC;
			LEAVE ManejoErrores;
		END IF;

		IF(CHARACTER_LENGTH(Par_CP) >5 AND CHARACTER_LENGTH(Par_CP) <5)THEN
			SET	 Par_NumErr := 5;
			SET  Par_ErrMen := 'El CP debe ser de 5 Caracteres.';
			SET Var_Control	:= 'cp' ;
			SET Var_Consecutivo := Par_CP;
			LEAVE ManejoErrores;
		END IF;

		SET Par_FechaConsul := (SELECT CURRENT_TIMESTAMP());
		SET Aud_FechaActual := (SELECT CURRENT_TIMESTAMP());
		SET Cadena_MensajeBC := Cadena_Vacia;
		SET Cadena_MensajeCC := Cadena_Vacia;

		IF(Con_tipoA = Par_TipoAlta ) THEN
			SET Cadena_MensajeBC := 'Procesando Respuesta';
			SET Cadena_MensajeCC := 'Procesando Respuesta';
		 END IF;
		 IF(Con_tipoB = Par_TipoAlta ) THEN
		 	SET Cadena_MensajeBC := 'Procesando Respuesta';
			SET Cadena_MensajeCC := Cadena_Vacia;
		 END IF;
		 IF(Con_tipoC = Par_TipoAlta ) THEN
			SET Cadena_MensajeBC := Cadena_Vacia;
			SET Cadena_MensajeCC := 'Procesando Respuesta';
		 END IF;


		IF(Par_Lote = Cadena_Vacia ) THEN
			SET Par_Lote = NULL;
			END IF;

		IF(Par_Manzana = Cadena_Vacia ) THEN
			SET Par_Manzana = NULL;
		END IF;


		IF(Par_NumInterior = Cadena_Vacia ) THEN
			SET Par_NumInterior = NULL;
		END IF;


		INSERT INTO SOLBUROCREDITO (
			RFC,				FechaConsulta,		PrimerNombre,		SegundoNombre,		TercerNombre,
			ApellidoPaterno,	ApellidoMaterno,	EstadoID,			MunicipioID,		Calle,
			NumeroExterior,		NumeroInterior,		Piso,				Colonia,			CP,
			Lote,				Manzana,			FechaNacimiento,	FolioConsulta,		FolioConsultaC,
			LocalidadID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
			ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
			Par_RFC,			Par_FechaConsul,	Par_PrimerNomb,		Par_SegundoNomb,	Par_TercerNomb,
			Par_ApellidoPat,	Par_ApellidoMat,	Par_EstadoID,		Par_MunicipioID,	LTRIM(Par_Calle),
			LTRIM(Par_NumExterior),	LTRIM(Par_NumInterior),	LTRIM(Par_Piso),	LTRIM(Par_Colonia),	LTRIM(Par_CP),
			LTRIM(Par_Lote),	LTRIM(Par_Manzana),	Par_FechaNac,		Cadena_MensajeBC,	Cadena_MensajeCC,
			Par_LocalidadID,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET	 Par_NumErr := 0;
		SET  Par_ErrMen := 'Solicitud Enviada.';
		SET Var_Control	:= 'solBuroCredito' ;
		SET Var_Consecutivo := Aud_NumTransaccion;
	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESCPUBOBLSOLIDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESCPUBOBLSOLIDALT`;DELIMITER $$

CREATE PROCEDURE `ESCPUBOBLSOLIDALT`(

	/* SP que Agrega los datos de la Escritura Publica de los Obligados Solidarios */
	Par_OblSolidID				INT(11),			-- Identificador del Obligado Solidario
	Par_Esc_Tipo				CHAR(1),			-- Tipo de Acta C.-Constitutiva, P.- Poderes
    Par_NomApoder				VARCHAR(150),		-- Nombre del Apoderado
	Par_RFC_Apoder				VARCHAR(13),		-- RFC del Apoderado
	Par_EscriPub				VARCHAR(50),		-- Numero Publico de la Escritura Publica
	Par_LibroEscr				VARCHAR(50),		-- Libro en que se encuentra la Escritura Publica
	Par_VolumenEsc				VARCHAR(20),		-- Volumen de la Escritura Publica
    Par_FechaEsc				DATE,				-- Fecha de la Escritura Publica
	Par_EstadoIDEsc				INT(11),			-- Estado de Escritura Publica
	Par_LocalEsc				INT(11),			-- Municipio de Escritura Publica
	Par_Notaria					INT(11),			-- Numero de la Notaria Publica
	Par_DirecNotar				VARCHAR(150),		-- Direccion de Notaria Publica
	Par_NomNotario				VARCHAR(100),		-- Nombre del Notario
	Par_RegistroPub				VARCHAR(10),		-- Numero de Registro Publico
	Par_FolioRegPub				VARCHAR(10),		-- Folio de Registro Publico
    Par_VolRegPub				VARCHAR(20),		-- Volumen de Registro Publico
	Par_LibroRegPub				VARCHAR(10),		-- Libro de Registro Publico
	Par_AuxiRegPub				VARCHAR(20),		-- Auxiliar de Registro Publico
	Par_FechaRegPub				DATE,				-- Fecha de Registro Publico
	Par_EstadoIDReg				INT(11),			-- Estado de Registro Publico
	Par_LocalRegPub				INT(11),			-- Localidad de Registro Publico

	Par_Salida					CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida
	INOUT	Par_NumErr			INT(11),				-- Parametro que corresponde a un numero de exito o error
	INOUT	Par_ErrMen			VARCHAR(350),		-- Parametro que corresponde a un mensaje de exito o error
    Par_LLamado					CHAR(1),			-- Tipo Consulta

	-- PARAMETROS AUDITORIA
	Par_EmpresaID				INT(11),			-- Parametros de Auditoria
	Aud_Usuario					INT(11),			-- Parametros de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de Auditoria
    Aud_DireccionIP				VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal				INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT				-- Parametros de Auditoria
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Consecutivo		INT(11);			-- Declaracion de variable consecutivo
	DECLARE VarControl			VARCHAR(200);		-- Declaracion de variable control

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);			-- Declaracion de Cadena vacia
	DECLARE	Fecha_Vacia			DATE;				-- Declaracion de Fecha vacia
	DECLARE	Entero_Cero			INT(11);			-- Declaracion de Entero cero
	DECLARE Salida_SI			CHAR(1);			-- Declaracion de Salida si
	DECLARE EscTipo_Poderes		CHAR(1);			-- Declaracion de Tipo de Acta de Poder
    DECLARE Tipo_Agregar		CHAR(1);			-- Declaracion de Tipo Consulta Alta

	-- 	Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena Vacio
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Var_Consecutivo			:= 0;				-- Consecutivo
	SET	Entero_Cero				:= 0;				-- Asignacion de entero cero
	SET EscTipo_Poderes			:='P';				-- Tipo de Acta de Poder
	SET Salida_SI				:='S';				-- Asingacion de parametro de salida
	SET Tipo_Agregar			:= 'A';				-- Tipo Consulta Alta

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ESCPUBOBLSOLIDALT');
			SET VarControl = 'sqlException';
		END;

	IF(IFNULL(Par_Esc_Tipo,Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El Tipo  de Acta esta Vacio';
		SET VarControl := 'esc_Tipo';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EscriPub, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'El no. de Escritura Publica esta Vacio';
		SET VarControl := 'escrituraPub';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaEsc, Fecha_Vacia)) = Fecha_Vacia THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'La Fecha esta Vacia';
		SET VarControl := 'fechaEsc';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EstadoIDEsc, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := 'El estado esta Vacio';
		SET VarControl := 'estadoIDEsc';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_LocalEsc, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := 'La localidad esta Vacia';
		SET VarControl := 'localidadEsc';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Notaria, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'La notaria esta Vacia';
			SET VarControl := 'notaria';
			LEAVE ManejoErrores;
	END IF;

	IF(Par_Esc_Tipo=EscTipo_Poderes)THEN
	IF(IFNULL(Par_NomApoder, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen := 'El nombre del Apoderado esta Vacio';
			SET VarControl := 'nomApoderado';
			LEAVE ManejoErrores;
	END IF; END IF;

	IF(Par_Esc_Tipo=EscTipo_Poderes)THEN
	IF(IFNULL(Par_RFC_Apoder, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 008;
		SET Par_ErrMen := 'El RFC del Apoderado esta Vacio';
		SET VarControl := 'RFC_Apoderado';
		LEAVE ManejoErrores;
	END IF; END IF;

	IF(IFNULL(Par_RegistroPub, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 009;
		SET Par_ErrMen := 'El Registro esta Vacio';
		SET VarControl := 'registroPub';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FolioRegPub, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 010;
		SET Par_ErrMen := 'El Folio esta Vacio';
		SET VarControl := 'folioRegPub';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaRegPub, Fecha_Vacia)) = Fecha_Vacia THEN
		SET Par_NumErr := 011;
		SET Par_ErrMen := 'La Fecha esta Vacia';
		SET VarControl := 'fechaRegPub';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EstadoIDReg, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 012;
		SET Par_ErrMen := 'La Entidad Federativa de Registro Pub esta Vacio';
		SET VarControl := 'estadoIDReg' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_LocalRegPub, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 013;
		SET Par_ErrMen := 'La localidad  de Registro Pub esta Vacia';
		SET VarControl := 'localidadRegPub';
		LEAVE ManejoErrores;
	END IF;

	INSERT INTO ESCPUBOBLSOLID(
									OblSolidID,			Esc_Tipo,			NomApoderado,		RFC_Apoderado,		EscrituraPublic,
									LibroEscritura, 	FechaEsc,			VolumenEsc,			EstadoIDEsc,		LocalidadEsc,
									Notaria,			DirecNotaria,		NomNotario,			RegistroPub,		FolioRegPub,
									VolumenRegPub,		LibroRegPub,		AuxiliarRegPub,		FechaRegPub,		EstadoIDReg,
									LocalidadRegPub,	EmpresaID,			Usuario,			FechaActual,		DireccionIP,
									ProgramaID,			Sucursal,			NumTransaccion

	)VALUES (						Par_OblSolidID,		Par_Esc_Tipo,		Par_NomApoder,		Par_RFC_Apoder,		Par_EscriPub,
									Par_LibroEscr,		Par_FechaEsc,		Par_VolumenEsc, 	Par_EstadoIDEsc,	Par_LocalEsc,
									Par_Notaria, 		Par_DirecNotar, 	Par_NomNotario,		Par_RegistroPub, 	Par_FolioRegPub,
									Par_VolRegPub, 		Par_LibroRegPub, 	Par_AuxiRegPub, 	Par_FechaRegPub, 	Par_EstadoIDReg,
									Par_LocalRegPub,	Par_EmpresaID,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_LLamado = Tipo_Agregar) THEN
		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Obligado Solidario Agregado Exitosamente: ',Par_OblSolidID);
		SET VarControl		:= 'consecutivoEsc';
		SET Var_Consecutivo	:= Var_Consecutivo;
	ELSE
        SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Obligado Solidario Modificado Exitosamente: ',Par_OblSolidID);
		SET VarControl		:= 'consecutivoEsc';
		SET Var_Consecutivo	:= Var_Consecutivo;
	END IF;

	END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			VarControl AS control,
			Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
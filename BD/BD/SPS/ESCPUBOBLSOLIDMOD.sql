-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESCPUBOBLSOLIDMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESCPUBOBLSOLIDMOD`;DELIMITER $$

CREATE PROCEDURE `ESCPUBOBLSOLIDMOD`(

	/* SP que Modifica los datos de la Escritura Publica de los Obligados Solidarios */
	Par_OblSolidID					INT(11),		-- Identificador de obligados solidarios
	Par_Esc_Tipo					CHAR(1),		-- Tipo de Acta C.-Constitutiva, P.- Poderes
	Par_NomApoder					VARCHAR(150),	-- Nombre del Apoderado
	Par_RFC_Apoder					VARCHAR(13),	-- RFC del Apoderado
	Par_EscriPub					VARCHAR(50),	-- Numero Publico de la Escritura Publica
    Par_LibroEscr					VARCHAR(50),	-- Libro en que se encuentra la Escritura Publica
	Par_VolumenEsc					VARCHAR(20),	-- Volumen de la Escritura Publica
	Par_FechaEsc					DATE,			-- Fecha de la Escritura Publica
	Par_EstadoIDEsc					INT(11),		-- Estado de Escritura Publica
	Par_LocalEsc					INT(11),		-- Municipio de Escritura Publica
    Par_Notaria						INT(11),		-- Numero de la Notaria Publica
	Par_DirecNotar					VARCHAR(150),	-- Direccion de Notaria Publica
	Par_NomNotario					VARCHAR(100),	-- Nombre del Notario
	Par_RegistroPub					VARCHAR(10),	-- Numero de Registro Publico
	Par_FolioRegPub					VARCHAR(10),	-- Folio de Registro Publico
    Par_VolRegPub					VARCHAR(20),	-- Volumen de Registro Publico
	Par_LibroRegPub					VARCHAR(10),	-- Libro de Registro Publico
	Par_AuxiRegPub					VARCHAR(20),	-- Auxiliar de Registro Publico
	Par_FechaRegPub					DATE,			-- Fecha de Registro Publico
	Par_EstadoIDReg					INT(11),		-- Estado de Registro Publico

	Par_LocalRegPub					INT(11),		-- Localidad de Registro Publico
    Par_Salida						CHAR(1),		-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr				INT (11),		-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen				VARCHAR(350),	-- Parametro que corresponde a un mensaje de exito o error

	-- Parametros de Auditoria
	Par_EmpresaID					INT(11),		-- Parametros de Auditoria
	Aud_Usuario						INT(11),		-- Parametros de Auditoria
	Aud_FechaActual					DATETIME,		-- Parametros de Auditoria
	Aud_DireccionIP					VARCHAR(15),	-- Parametros de Auditoria
	Aud_ProgramaID					VARCHAR(50),	-- Parametros de Auditoria
	Aud_Sucursal					INT(11),		-- Parametros de Auditoria
	Aud_NumTransaccion				BIGINT			-- Parametros de Auditoria
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Consecutivo			INT(11);		-- Declaracion de Variable Consecutivo
	DECLARE Var_Control				VARCHAR(200); 	-- Declaracion de Variable Control

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Declaracion de Constante Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;			-- Declaracion de Constante fecha vacia
	DECLARE	Entero_Cero				INT(11);		-- Declaracion de Constante entero cero
	DECLARE Salida_SI				CHAR(1);		-- Declaracion de Constante salida
	DECLARE EscTipo_Poderes			CHAR(1);		-- Declaracion de Constante tipo de poderes

	-- 	Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero 0
	SET Salida_SI				:='S';				-- Salida SI
	SET EscTipo_Poderes			:='P';				-- Tipo de Poderes
	SET	Var_Consecutivo			:= 0;				-- Consecutivo

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-ESCPUBOBLSOLIDMOD');
			SET Var_Control = 'sqlException';
		END;

	IF(NOT EXISTS (SELECT OblSolidID
					FROM OBLIGADOSSOLIDARIOS
					WHERE OblSolidID = Par_OblSolidID)) THEN
		SET Par_NumErr  := 001;
		SET Par_ErrMen  := 'El Numero de Cliente no existe';
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Esc_Tipo,Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 002;
		SET Par_ErrMen  := 'El Tipo  de Acta esta Vacio';
		SET Var_Control := 'esc_Tipo';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EscriPub, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 003;
		SET Par_ErrMen  := 'El No. de Escritura Publica esta Vacio';
		SET Var_Control := 'escrituraPub';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaEsc, Fecha_Vacia)) = Fecha_Vacia THEN
		SET Par_NumErr  := 004;
		SET Par_ErrMen  := 'La Fecha de Escritura Publica esta Vacia';
		SET Var_Control := 'fechaEsc';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EstadoIDEsc, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 005;
		SET Par_ErrMen  := 'El estado esta Vacio';
		SET Var_Control := 'estadoIDEsc';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_LocalEsc, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 006;
		SET Par_ErrMen  := 'La localidad esta Vacia';
		SET Var_Control := 'localidadEsc';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Notaria, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 007;
		SET Par_ErrMen  := 'La notaria esta Vacia';
		SET Var_Control := 'notaria';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Esc_Tipo=EscTipo_Poderes)THEN
	IF(IFNULL(Par_NomApoder, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 008;
		SET Par_ErrMen  := 'El nombre del Apoderado esta Vacio';
		SET Var_Control := 'nomApoderado';
		LEAVE ManejoErrores;
	END IF; END IF;

	IF(Par_Esc_Tipo=EscTipo_Poderes)THEN
	IF(IFNULL(Par_RFC_Apoder, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 009;
		SET Par_ErrMen  := 'El RFC del Apoderado esta Vacio';
		SET Var_Control := 'RFC_Apoderado';
		LEAVE ManejoErrores;
	END IF; END IF;

	IF(IFNULL(Par_RegistroPub, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 010;
		SET Par_ErrMen  := 'El Registro esta Vacio';
		SET Var_Control := 'registroPub' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FolioRegPub, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 011;
		SET Par_ErrMen  := 'El Folio esta Vacio';
		SET Var_Control := 'folioRegPub';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaRegPub, Fecha_Vacia)) = Fecha_Vacia THEN
		SET Par_NumErr  := 012;
		SET Par_ErrMen  := 'La Fecha esta Vacia';
		SET Var_Control := 'fechaRegPub';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EstadoIDReg, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 013;
		SET Par_ErrMen  := 'La Entidad Federativa de Registro Pub esta Vacio';
		SET Var_Control := 'estadoIDReg';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_LocalRegPub, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 014;
		SET Par_ErrMen  := 'La localidad  de Registro Pub esta Vacia';
		SET Var_Control := 'localidadRegPub';
		LEAVE TerminaStore;
	END IF;

	SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE ESCPUBOBLSOLID SET
			Esc_Tipo		= Par_Esc_Tipo,
			EscrituraPublic	= Par_EscriPub,
			LibroEscritura	= Par_LibroEscr,
			VolumenEsc		= Par_VolumenEsc,
			FechaEsc		= Par_FechaEsc,

			EstadoIDEsc		= Par_EstadoIDEsc,
			LocalidadEsc	= Par_LocalEsc,
			Notaria			= Par_Notaria,
			DirecNotaria	= Par_DirecNotar,
			NomNotario		= Par_NomNotario,

			NomApoderado	= Par_NomApoder,
			RFC_Apoderado	= Par_RFC_Apoder,
			RegistroPub		= Par_RegistroPub,
			FolioRegPub		= Par_FolioRegPub,
			VolumenRegPub	= Par_VolRegPub,

			LibroRegPub		= Par_LibroRegPub,
			AuxiliarRegPub	= Par_AuxiRegPub,
			FechaRegPub		= Par_FechaRegPub,
			EstadoIDReg		= Par_EstadoIDReg,
			LocalidadRegPub	= Par_LocalRegPub,

			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,

			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion

		WHERE OblSolidID = Par_OblSolidID;

	SET Par_NumErr			:= '000';
    SET Par_ErrMen			:= CONCAT('Obligado Solidario Modificado Exitosamente: ',Par_OblSolidID);
	SET Var_Control			:= 'consecutivoEsc';
	SET Var_Consecutivo		:= Var_Consecutivo;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
	END IF;
END TerminaStore$$
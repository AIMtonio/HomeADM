-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESCPUBAVALESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESCPUBAVALESMOD`;DELIMITER $$

CREATE PROCEDURE `ESCPUBAVALESMOD`(

	Par_AvalID				INT(11),
	Par_Esc_Tipo			CHAR(1),
	Par_NomApoder			VARCHAR(150),
	Par_RFC_Apoder			VARCHAR(13),
	Par_EscriPub			VARCHAR(50),

    Par_LibroEscr			VARCHAR(50),
	Par_VolumenEsc			VARCHAR(20),
	Par_FechaEsc			DATE,
	Par_EstadoIDEsc			INT(11),
	Par_LocalEsc			INT(11),

    Par_Notaria				INT(11),
	Par_DirecNotar			VARCHAR(150),
	Par_NomNotario			VARCHAR(100),
	Par_RegistroPub			VARCHAR(10),
	Par_FolioRegPub			VARCHAR(10),

    Par_VolRegPub			VARCHAR(20),
	Par_LibroRegPub			VARCHAR(10),
	Par_AuxiRegPub			VARCHAR(20),
	Par_FechaRegPub			DATE,
	Par_EstadoIDReg			INT(11),

	Par_LocalRegPub			INT(11),
    Par_Salida    			CHAR(1),
	INOUT	Par_NumErr 		INT (11),
	INOUT	Par_ErrMen  	VARCHAR(350),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DateTime,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
    Aud_NumTransaccion		BIGINT

	)
TerminaStore: BEGIN


	DECLARE Var_Consecutivo		INT(11);
	DECLARE Var_Control	   		VARCHAR(200);



	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE Salida_SI			CHAR(1);
	DECLARE EscTipo_Poderes		CHAR(1);



	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET Salida_SI				:='S';
	SET EscTipo_Poderes			:='P';
	SET	Var_Consecutivo			:= 0;


ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                    'esto le ocasiona. Ref: SP-ESCPUBAVALESMOD');
			SET Var_Control = 'sqlException';
		END;

	IF(NOT EXISTS (SELECT AvalID
				FROM AVALES
				WHERE AvalID = Par_AvalID)) THEN
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


		UPDATE ESCPUBAVALES SET
			Esc_Tipo		= Par_Esc_Tipo,
			EscrituraPublic	= Par_EscriPub,
			LibroEscritura	= Par_LibroEscr,
			VolumenEsc		= Par_VolumenEsc,
			FechaEsc		= Par_FechaEsc,

			EstadoIDEsc		= Par_EstadoIDEsc,
			LocalidadEsc	= Par_LocalEsc,
			Notaria			= Par_Notaria,
			DirecNotaria 	= Par_DirecNotar,
			NomNotario		= Par_NomNotario,

			NomApoderado	= Par_NomApoder,
			RFC_Apoderado	= Par_RFC_Apoder,
			RegistroPub		= Par_RegistroPub,
			FolioRegPub		= Par_FolioRegPub,
			VolumenRegPub		= Par_VolRegPub,

			LibroRegPub		= Par_LibroRegPub,
			AuxiliarRegPub	= Par_AuxiRegPub,
			FechaRegPub		= Par_FechaRegPub,
			EstadoIDReg		= Par_EstadoIDReg,
			LocalidadRegPub	= Par_LocalRegPub,

			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,

			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion

		WHERE AvalID = Par_AvalID;

	SET Par_NumErr 		:= '000';
    SET Par_ErrMen 		:= CONCAT('Aval Modificado Exitosamente: ',Par_AvalID);
	SET Var_Control		:= 'consecutivoEsc';
	SET Var_Consecutivo	:= Var_Consecutivo;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
	END IF;



END TerminaStore$$
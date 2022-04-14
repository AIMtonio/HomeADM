DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDSEGPERSONALISTASALT`;

DELIMITER $$
CREATE PROCEDURE `PLDSEGPERSONALISTASALT`(
	Par_OpeInusualID 		BIGINT(20), 	-- Identificador de la tala PLDOPEINUSUALES,
  	Par_TipoPersona 		CHAR(5),  		-- Indica si la persona que hizo deteccion en la LPB es prospecto/cliente/aval/relacionado/proveedor,
  	Par_NumRegistro 		BIGINT(20),  	-- Indica el numero de prospecto/cliente/aval/relacionado/proveedor al que corresponde la deteccion realizada,
  	Par_Nombre 				VARCHAR(300),  	-- Indica el nombre del prospecto/cliente/aval/relacionado/proveedor al que corresponde la deteccion realizada,
  	Par_FechaDeteccion 		DATE,  			-- indica la fecha en que se hizo la deteccion.,
  	Par_ListaDeteccion 		VARCHAR(45),  	-- Indica la lista en la cual se hizo la deteccion.,
  	Par_NombreDet 			VARCHAR(300),  	-- Indica los nombres que tenia la persona detectada al momento de la deteccion.,
  	Par_ApellidoDet 		VARCHAR(300),  	-- indica los apellidos que tenia la persona detectada al momento de la deteccion.,
  	Par_FechaNacimientoDet 	DATE,  			-- Indica la fecha de nacimiento que tenia la persona detectada al momento de la deteccion.,
  	Par_RFCDet 				VARCHAR(13),  	--  Indica el Registro Federal de Contribuyente que tenia la persona detectada al momento de la deteccion.,
  	Par_PaisDetID 			INT(11),  		-- Indica el pais que tenia la persona detectada al momento de la deteccion,
  	
  	Par_Salida				CHAR(1),		-- Indica si requiere salida
  	INOUT Par_NumErr 		INT(11),		-- Numero de exito o error
  	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de exito o error
  	
  	Par_EmpresaID 			INT(11),    	-- Parametros de auditoria,
  	Aud_Usuario 			INT(11),    	-- Parametros de auditoria,
  	Aud_FechaActual 		DATETIME,    	-- Parametros de auditoria,
  	Aud_DireccionIP 		VARCHAR(15),    -- Parametros de auditoria,
  	Aud_ProgramaID 			VARCHAR(50),    -- Parametros de auditoria,
  	Aud_Sucursal 			INT(11),    	-- Parametros de auditoria,
  	Aud_NumTransaccion 		BIGINT(20)    	-- Parametros de auditoria,

)
TerminaStore: BEGIN
		
		-- Declaracion de variables
		DECLARE Var_Control			VARCHAR(50);

		-- Declaracion de constantes
		DECLARE Entero_Cero			INT(11);
		DECLARE Cadena_Vacia		CHAR(1);
		DECLARE Fecha_Vacia			DATE;
		DECLARE Con_NO 				CHAR(1);
		DECLARE Salida_SI			CHAR(1);
		DECLARE Moral				CHAR(1);

		-- Seteo de valores
		SET Entero_Cero		:= 0;
		SET Cadena_Vacia	:= '';
		SET Fecha_Vacia		:= '1900-01-01';
		SET Con_NO 			:= 'N';
		SET Salida_SI 		:= 'S';
		SET Moral			:= 'M';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDSEGPERSONALISTASALT');
			SET Var_Control	:= 'sqlException';
		END;


		IF IFNULL(Par_OpeInusualID,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El identificador de la operacion no debe estar vacio';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_TipoPersona,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El tipo de persona no debe estar vacio';
			LEAVE ManejoErrores;
		END IF;


		IF IFNULL(Par_Nombre,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El nombre esta vacio';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_FechaDeteccion,Fecha_Vacia) = Fecha_Vacia THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'La Fecha de Deteccion esta vacia';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_ListaDeteccion,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := 'La Fecha de Deteccion esta vacia';
			LEAVE ManejoErrores;
		END IF;


		IF IFNULL(Par_RFCDet,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 10;
			SET Par_ErrMen := 'El RFC de la deteccion esta vacio';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_PaisDetID,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 11;
			SET Par_ErrMen := 'El pais de deteccion esta vacio';
			LEAVE ManejoErrores;
		END IF;

		SET Par_FechaNacimientoDet := IFNULL(Par_FechaNacimientoDet,Fecha_Vacia);
		SET Par_NombreDet := IFNULL(Par_NombreDet,Cadena_Vacia);
		SET Par_ApellidoDet := IFNULL(Par_ApellidoDet,Cadena_Vacia);

		INSERT INTO PLDSEGPERSONALISTAS
		(	OpeInusualID, 	TipoPersona, 		NumRegistro, 	Nombre, 			FechaDeteccion,
			ListaDeteccion, NombreDet, 			ApellidoDet, 	FechaNacimientoDet, RFCDet,
			PaisDetID, 		PermiteOperacion, 	Comentario, 	EmpresaID, 			Usuario, 
			FechaActual, 	DireccionIP, 		ProgramaID, 	Sucursal, 			NumTransaccion)
		VALUES
		(
			Par_OpeInusualID, 	Par_TipoPersona, 		Par_NumRegistro, 	Par_Nombre, 			Par_FechaDeteccion,
			Par_ListaDeteccion, Par_NombreDet, 			Par_ApellidoDet, 	Par_FechaNacimientoDet, Par_RFCDet,
			Par_PaisDetID, 		Con_NO, 				Cadena_Vacia, 		Par_EmpresaID, 			Aud_Usuario, 
			Aud_FechaActual, 	Aud_DireccionIP, 		Aud_ProgramaID, 	Aud_Sucursal, 			Aud_NumTransaccion
		);



		SET	Par_NumErr	:= Entero_Cero;
		SET	Par_ErrMen	:= CONCAT('Seguimiento de Persona Registrado Correctamente');
		SET Var_Control	:= 'opeInusualID';
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_OpeInusualID AS Consecutivo;
	END IF;

END TerminaStore$$
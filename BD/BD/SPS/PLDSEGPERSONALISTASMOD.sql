DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDSEGPERSONALISTASMOD`;

DELIMITER $$
CREATE PROCEDURE `PLDSEGPERSONALISTASMOD`(
	Par_OpeInusualID 		BIGINT(20), 	-- Identificador de la tala PLDOPEINUSUALES
  	Par_PermiteOperacion 	CHAR(1),  		-- Indica si el cliente ligado al folio consultado podra continuar con sus operaciones en el sistema al despues del analisis que realice el area de cumplimiento.\n\nS = SI\nN = NO,
  	Par_Comentario 			VARCHAR(400),  	-- En este el oficial de cumplimiento agregara los comentarios de su revision.,
  	
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
		DECLARE Var_OpeInusual		BIGINT(20);

		-- Declaracion de constantes
		DECLARE Entero_Cero			INT(11);
		DECLARE Cadena_Vacia		CHAR(1);
		DECLARE Fecha_Vacia			DATE;
		DECLARE Con_NO 				CHAR(1);
		DECLARE Salida_SI			CHAR(1);

		-- Seteo de valores
		SET Entero_Cero		:= 0;
		SET Cadena_Vacia	:= '';
		SET Fecha_Vacia		:= '1900-01-01';
		SET Con_NO 			:= 'N';
		SET Salida_SI 		:= 'S';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPEINUSUALESMOD');
			SET Var_Control	:= 'sqlException';
		END;

		SELECT OpeInusualID
		INTO Var_OpeInusual 
		FROM PLDSEGPERSONALISTAS WHERE OpeInusualID =  Par_OpeInusualID;


		IF IFNULL(Par_OpeInusualID,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Identificador de la Operacion esta vacio';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Var_OpeInusual,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Identificador de la Operacion no existe';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_PermiteOperacion,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'No se a indicado si se permite operacion';
			LEAVE ManejoErrores;
		END IF;


		
		IF IFNULL(Par_Comentario,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El comentario esta vacio';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();
		UPDATE PLDSEGPERSONALISTAS SET 
			PermiteOperacion 	= Par_PermiteOperacion, 
			Comentario 			= Par_Comentario,
			EmpresaID 			= Par_EmpresaID, 
			Usuario 			= Aud_Usuario, 
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID 			= Aud_ProgramaID,
			Sucursal 			= Aud_Sucursal,
			NumTransaccion 		= Aud_NumTransaccion
		WHERE OpeInusualID = Par_OpeInusualID;



		SET	Par_NumErr	:= Entero_Cero;
		SET	Par_ErrMen	:= CONCAT('Seguimiento de Persona Modificado Correctamente ');
		SET Var_Control	:= 'opeInusualID';
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_OpeInusualID AS consecutivo;
	END IF;

END TerminaStore$$
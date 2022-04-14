-- SP SERVICIOSXEMPRESAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS SERVICIOSXEMPRESAALT;

DELIMITER $$
CREATE PROCEDURE SERVICIOSXEMPRESAALT(
	Par_ServicioID		INT(11),
	Par_InstitNominaID	INT(11),
    Par_Salida			CHAR(1),		-- Salida en Pantalla
	/* Parametros de Entrada/Salida */
	INOUT Par_NumErr	INT(11),		-- Numero  de Error o Exito
	INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de Error o Exito
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
)
TerminaStore : BEGIN

	/*DECLARACION DE CONSTANTES*/
	DECLARE Entero_Cero			INT(1);				# Constante Entero Cero
	DECLARE SalidaSI			CHAR(1);

	/*Decalracion de Variables*/
	DECLARE Var_Control			VARCHAR(200);	-- Variable de control

	/*ASIGNACION DE CONSTANTES*/
	SET Entero_Cero		:= 0;					-- Entero Cero
	SET SalidaSI		:= 'S'; 				-- Constante Cadena Si

		-- *** Manejo de excepciones ***
	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-SERVICIOSXEMPRESAALT');
				SET Var_Control :='SQLEXCEPTION';
			END;

		/* Verificar que INSTITNOMINAID no esté vacío */
		IF(IFNULL(Par_InstitNominaID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 02;
			SET Par_ErrMen := 'El Instit nómina ID está vacío';
			SET Var_Control:= 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		IF (NOT EXISTS (SELECT InstitNominaID
							FROM  INSTITNOMINA
							WHERE	InstitNominaID = Par_InstitNominaID)) THEN

			SET Par_NumErr := 03;
			SET Par_ErrMen := 'La Institucion de nomina no existe';
			SET Var_Control:= 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		IF (EXISTS (SELECT InstitNominaID
							FROM  SERVICIOSXEMPRESA
							WHERE ServicioID 		= Par_ServicioID
							  AND InstitNominaID 	= Par_InstitNominaID)) THEN

			SET Par_NumErr := 04;
			SET Par_ErrMen := 'La Institucion de nomina ya esta asociada al servicio';
			SET Var_Control:= 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		/* INSERT A SERVICIOSADICIONALES */
		INSERT INTO SERVICIOSXEMPRESA(
				ServicioID, 	InstitNominaID, 	EmpresaID, 	Usuario, 	FechaActual,
				DireccionIP, 	ProgramaID,			Sucursal, 	NumTransaccion)
			VALUES(
				Par_ServicioID,		Par_InstitNominaID,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Servicio por Empresa Agregado Exitosamente';
		SET Var_Control := 'servicioID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr  	AS NumErr,
				Par_ErrMen  	AS ErrMen,
				Var_Control		AS Control,
				Par_ServicioID	AS Consecutivo;
	END IF;
END TerminaStore$$
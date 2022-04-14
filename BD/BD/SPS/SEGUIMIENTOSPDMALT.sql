-- SEGUIMIENTOSPDMALT

DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUIMIENTOSPDMALT`;
DELIMITER $$
CREATE  PROCEDURE `SEGUIMIENTOSPDMALT`(
	/*
	* SP para generar el folio con el que se le dara seguimiento al cliente
	*/
	Par_ClienteID			INT(11),			-- Cliente que realiza peticion de seguimiento
	Par_Telefono			VARCHAR(20),		-- Telefono que proporciona para l seguimiento
	Par_TipoSoporteID		INT(11),			-- Identifcador del soporte que se le dara obtenida de la tabla CATTIPOSOPORTE

	Par_Salida 				CHAR(1),			-- Indica si espera un SELECT de Salida
	INOUT Par_NumErr 		INT(11),			-- Numero de Error
	INOUT Par_ErrMen 		VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID 			INT(11),			-- Parametro de Auditoria
	Aud_Usuario 			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual 		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP 		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 			VARCHAR(50), 		-- Parametro de Auditoria
	Aud_Sucursal 			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 		BIGINT(20)			-- Parametro de Auditoria
)

TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero		INT(11);		-- Constante para el valor 0
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante para la cadena vacia
	DECLARE Salida_SI		CHAR(1);		-- Constante para el valor S
	DECLARE Mayusculas		CHAR(2);		-- Constante para nomenclatura de
	DECLARE Con_EnProceso	CHAR(1);		-- Constante del estatus En Proceso
	DECLARE Fecha_Vacia		DATE;			-- Constante para la Fecha vacia
	-- Declaracion de Variables
	DECLARE Var_Consecutivo		INT(11);
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_FechaSis		DATE;
	DECLARE Var_FechaActual		DATETIME;
	-- Seteo de valores

	SET	Aud_FechaActual		:= NOW();			-- Se setea la fecha Actual
	SET Mayusculas			:= 'MA';			-- Obtener el resultado en Mayusculas
	SET Salida_SI			:= 'S';
	SET Con_EnProceso		:='P';
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Par_Telefono		:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_Telefono, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);
	SELECT FechaSistema INTO Var_FechaSis FROM PARAMETROSSIS;
	SET Var_FechaActual		:= CONCAT(Var_FechaSis," ",CURTIME());
	ManejoErrores: BEGIN

	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 					'esto le ocasiona. Ref: SP-SEGUIMIENTOSPDMALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF(IFNULL(Par_ClienteID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Cliente esta Vacio.';
			SET Var_Control:= 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Telefono,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 	:= 2;
			SET Par_ErrMen 	:= 'El Telefono esta Vacio.';
			SET Var_Control	:= 'numeroTelefono';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoSoporteID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 	:= 3;
			SET Par_ErrMen 	:= 'El Tipo de Soporte esta Vacio.';
			SET Var_Control	:= 'tipoSoporteID';
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(MAX(SeguimientoID),Entero_Cero)+1 INTO Var_Consecutivo
		FROM SEGUIMIENTOSPDM;


		INSERT INTO SEGUIMIENTOSPDM
		(SeguimientoID,		ClienteID,		Telefono,		TipoSoporteID,		UsuarioRegistra,
		UsuarioFinaliza,	UsuarioCancela,	FechaRegistra,	FechaFinaliza,		FechaCancela,
		Estatus,			EmpresaID,		Usuario,		FechaActual,		DireccionIP,
		ProgramaID,			Sucursal,		NumTransaccion)
		VALUES
		(Var_Consecutivo,	Par_ClienteID,	Par_Telefono,		Par_TipoSoporteID,	Aud_Usuario,
		Entero_Cero,		Entero_Cero,	Var_FechaActual,	Fecha_Vacia,		Fecha_Vacia,
		Con_EnProceso,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);


		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= CONCAT('Folio: ',Var_Consecutivo);
		SET Var_Control	:= 'clienteID';

	END ManejoErrores;

		IF(Par_Salida = Salida_SI) THEN
			SELECT 	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS Control,
					Var_Consecutivo AS Consecutivo;
		END IF;
END TerminaStore$$
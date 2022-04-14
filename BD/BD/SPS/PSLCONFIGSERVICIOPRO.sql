-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCONFIGSERVICIOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCONFIGSERVICIOPRO`;DELIMITER $$

CREATE PROCEDURE `PSLCONFIGSERVICIOPRO`(
	-- Stored procedure para realizar el alta de una configuracion de servicio con valores por defecto
	Par_ServicioID 					INT(11), 				-- ID del servicio
	Par_ClasificacionServ 			CHAR(2), 				-- Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)

	Par_NumPro 						TINYINT UNSIGNED,		-- Parametro con el numero de proceso a ejecutar

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen 				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID 					INT(11), 				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal 					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(2, 1); 			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE SalidaNO				CHAR(1);				-- Salida no
	DECLARE Var_SI					CHAR(1);				-- Variable con valor si
	DECLARE Var_NO					CHAR(1);				-- Variable con valor no
	DECLARE Var_AltValDef 			TINYINT;				-- Proceso de registro con valores por defecto

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control
	DECLARE Var_Consecutivo 		INT(11); 				-- Variable consecutivo
	DECLARE Var_ServicioID 			INT(11); 				-- Identificador del servicio


	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no
	SET Var_SI						:= 'S';					-- Variable con valor si
	SET Var_NO						:= 'N';					-- Variable con valor no
	SET Var_AltValDef 				:= 1; 					-- Alta de la configuracion del servicio con valores por defecto

	-- Valores por default
	SET Par_ServicioID 				:= IFNULL(Par_ServicioID, Entero_Cero);
	SET Par_ClasificacionServ 		:= IFNULL(Par_ClasificacionServ, Entero_Cero);

    SET Aud_EmpresaID				:= IFNULL(Aud_EmpresaID, Entero_Cero);
    SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
    SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
       			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-PSLCONFIGSERVICIOPRO');
			END;


		-- Proceso de registro con valores por defecto
		IF(Par_NumPro = Var_AltValDef) THEN
			SELECT 	ServicioID INTO Var_ServicioID
				FROM PSLCONFIGSERVICIO
				WHERE ServicioID = Par_ServicioID
				AND ClasificacionServ = Par_ClasificacionServ;

			-- Si ya existe el registro terminamos el proceso.
			IF(Var_ServicioID IS NOT NULL) THEN
				SET Par_NumErr		:= 0;
				SET Par_ErrMen		:= 'Servicio registrado previamente';
				SET Var_Consecutivo := Par_ServicioID;
				LEAVE ManejoErrores;
			END IF;

			CALL PSLCONFIGSERVICIOALT( 	Par_ServicioID,			Par_ClasificacionServ,		Cadena_Vacia,			Cadena_Vacia,		Cadena_Vacia,
										Cadena_Vacia,			Var_NO,						Var_NO,					Entero_Cero,		Entero_Cero,
										Var_NO,					Var_NO,						Entero_Cero,			Var_NO,				Var_NO,
										Entero_Cero,			Var_AltValDef,				SalidaNO,				Par_NumErr, 		Par_ErrMen,
										Aud_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
										Aud_Sucursal,			Aud_NumTransaccion
				);

			IF(Par_NumErr <> Entero_Cero) THEN
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			-- El registro se inserto exitosamente
			SET Par_NumErr		:= 0;
			SET Par_ErrMen		:= 'Configuracion de servicio registrada correctamente';
			SET Var_Consecutivo := Par_ServicioID;
			LEAVE ManejoErrores;
		END IF;	-- Fin del proceso de pase de catalogos a historico
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr		AS NumErr,
			   Par_ErrMen		AS ErrMen,
			   'servicioID' 	AS control,
			   Var_Consecutivo	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$
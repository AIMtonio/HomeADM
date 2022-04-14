-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATMPENVIOCORREOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATMPENVIOCORREOPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTATMPENVIOCORREOPRO`(
	-- Stored Procedure para actualizar o insertar el envio de correos
	Par_AnioMes						INT(11),				-- Periodo del estado de cuenta
	Par_ClienteID					INT(11),				-- ID de Cliente
	Par_SucursalID					INT(11),				-- ID de la sucursal
	Par_CorreoEnvio 				VARCHAR(50), 			-- Cuenta de Correo a la que se enviara el Estado de Cuenta
	Par_EstatusEdoCta 				VARCHAR(50), 			-- Estatus del Estado de Cuenta 1= Info Extraida, 2=Timbrado 3= No se Pudo timbrar
	Par_EstatusEnvio 				CHAR(1), 				-- Estatus de envio: S=Enviado, N=No enviado
	Par_FechaEnvio 					DATETIME, 				-- Fecha y hora del envio del correo
	Par_UsuarioEnvia 				INT(11), 				-- COMMENT 'ID del usuario en el sistema que realizo el envío

	Par_NumPro 						INT(11), 				-- Numero de proceso a ejecutar

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen 				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID 					INT(11), 				-- Parametros de auditoria
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
	DECLARE Var_ProAct 				TINYINT; 				-- Opcion para actualizacion de envio de correos

	-- Declaracion de variables
	DECLARE Var_Consecutivo 		INT(11); 				-- Consecutivo
	DECLARE Var_ClienteID 			INT(11); 				-- ID del cliente

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no
	SET Var_ProAct 					:= 1; 					-- Opcion para actualizacion de envio de correos

	-- Valores por default
	SET Par_AnioMes 				:= IFNULL(Par_AnioMes, Entero_Cero);
	SET Par_ClienteID 				:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_SucursalID 				:= IFNULL(Par_SucursalID, Entero_Cero);
	SET Par_CorreoEnvio 			:= IFNULL(Par_CorreoEnvio, Cadena_Vacia);
	SET Par_EstatusEdoCta			:= IFNULL(Par_EstatusEdoCta, Cadena_Vacia);
	SET Par_EstatusEnvio			:= IFNULL(Par_EstatusEnvio, Cadena_Vacia);
	SET Par_FechaEnvio				:= IFNULL(Par_FechaEnvio, Fecha_Vacia);
	SET Par_UsuarioEnvia 			:= IFNULL(Par_UsuarioEnvia, Entero_Cero);

	SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
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
											'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTATMPENVIOCORREOPRO');
			END;

		IF(Par_NumPro = Var_ProAct) THEN
			IF(Par_AnioMes = Entero_Cero) THEN
				SET Par_NumErr	:= 1;
				SET Par_ErrMen	:= 'El periodo a procesar esta vacio.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			-- Insertamos los nuevos envios de correo
			INSERT INTO EDOCTAENVIOCORREO (	AnioMes, 			ClienteID, 			SucursalID,			CorreoEnvio,		EstatusEdoCta,
											EstatusEnvio,		FechaEnvio,			UsuarioEnvia,		PDFGenerado,		EmpresaID,
											Usuario,			FechaActual, 		DireccionIP,		ProgramaID,			Sucursal,
											NumTransaccion
				)
				SELECT						TMP.AnioMes, 		TMP.ClienteID, 		TMP.SucursalID,		TMP.CorreoEnvio,	TMP.EstatusEdoCta,
											TMP.EstatusEnvio,	TMP.FechaEnvio,		TMP.UsuarioEnvia,	TMP.PDFGenerado,	TMP.EmpresaID,
											TMP.Usuario,		TMP.FechaActual, 	TMP.DireccionIP,	TMP.ProgramaID,		TMP.Sucursal,
											TMP.NumTransaccion
					FROM EDOCTATMPENVIOCORREO TMP
					LEFT JOIN EDOCTAENVIOCORREO PROD ON PROD.AnioMes = TMP.AnioMes AND PROD.ClienteID = TMP.ClienteID
					WHERE PROD.AnioMes IS NULL
					AND TMP.AnioMes = Par_AnioMes;


			-- Actualizamos los envios de correos actuales
			UPDATE EDOCTAENVIOCORREO AS PROD
				INNER JOIN EDOCTATMPENVIOCORREO AS TMP ON PROD.AnioMes = TMP.AnioMes AND PROD.ClienteID = TMP.ClienteID
				SET PROD.EstatusEdoCta	= TMP.EstatusEdoCta,
					PROD.PDFGenerado	= TMP.PDFGenerado,
					PROD.FechaActual 	= TMP.FechaActual,
					PROD.DireccionIP 	= TMP.DireccionIP,
					PROD.ProgramaID 	= TMP.ProgramaID,
					PROD.Sucursal 		= TMP.Sucursal,
					PROD.NumTransaccion = TMP.NumTransaccion
				WHERE TMP.AnioMes = Par_AnioMes;

			-- El registro se inserto exitosamente
			SET Par_NumErr		:= 0;
			SET Par_ErrMen		:= 'Proceso de actualizacion de envio de correos realizado correctamente';
			SET Var_Consecutivo := Par_ClienteID;
		END IF;


	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr		AS NumErr,
			   Par_ErrMen		AS ErrMen,
			   'clienteID' 		AS control,
			   Var_Consecutivo	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$
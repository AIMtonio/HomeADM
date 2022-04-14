-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATMPENVIOCORREOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATMPENVIOCORREOALT`;DELIMITER $$

CREATE PROCEDURE `EDOCTATMPENVIOCORREOALT`(
	-- Stored Procedure para dar de alta en envio de correo en la tabla temporal
	Par_AnioMes						INT(11),				-- Periodo del estado de cuenta
	Par_ClienteID					INT(11),				-- ID de Cliente
	Par_SucursalID					INT(11),				-- ID de la sucursal
	Par_CorreoEnvio 				VARCHAR(50), 			-- Cuenta de Correo a la que se enviara el Estado de Cuenta
	Par_EstatusEdoCta 				VARCHAR(50), 			-- Estatus del Estado de Cuenta 1= Info Extraida, 2=Timbrado 3= No se Pudo timbrar
	Par_EstatusEnvio 				CHAR(1), 				-- Estatus de envio: S=Enviado, N=No enviado
	Par_FechaEnvio 					DATETIME, 				-- Fecha y hora del envio del correo
	Par_UsuarioEnvia 				INT(11), 				-- COMMENT 'ID del usuario en el sistema que realizo el envío
	Par_PDFGenerado					CHAR(1),				-- Indica que el PDF del Estado de Cuenta ha sido generado

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

	-- Declaracion de variables
	DECLARE Var_Consecutivo 		INT(11); 				-- Consecutivo
	DECLARE Var_ClienteID 			INT(11); 				-- ID del cliente
	DECLARE Var_SucursalID			INT(11); 				-- ID de la sucursal

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no

	-- Valores por default
	SET Par_AnioMes 				:= IFNULL(Par_AnioMes, Entero_Cero);
	SET Par_ClienteID 				:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_SucursalID 				:= IFNULL(Par_SucursalID, Entero_Cero);
	SET Par_CorreoEnvio 			:= IFNULL(Par_CorreoEnvio, Cadena_Vacia);
	SET Par_EstatusEdoCta			:= IFNULL(Par_EstatusEdoCta, Cadena_Vacia);
	SET Par_EstatusEnvio			:= IFNULL(Par_EstatusEnvio, Cadena_Vacia);
	SET Par_FechaEnvio				:= IFNULL(Par_FechaEnvio, Fecha_Vacia);
	SET Par_UsuarioEnvia 			:= IFNULL(Par_UsuarioEnvia, Entero_Cero);
	SET Par_PDFGenerado 			:= IFNULL(Par_PDFGenerado, Cadena_Vacia);

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
											'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTATMPENVIOCORREOALT');
			END;

		IF(Par_AnioMes = Entero_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El anio y mes del periodo esta vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ClienteID = Entero_Cero) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El ID del cliente esta vacio';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_SucursalID = Entero_Cero) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El ID de la sucursal esta vacia.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT NULL INTO Var_ClienteID;

		SELECT ClienteID INTO Var_ClienteID
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

		IF(Var_ClienteID IS NULL) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'No se encontro el cliente especificado.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		SELECT NULL INTO Var_SucursalID;

		SELECT SucursalID INTO Var_SucursalID
			FROM SUCURSALES
			WHERE SucursalID = Par_SucursalID;

		IF(Var_SucursalID IS NULL) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'No se encontro la sucursal especificada.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		SELECT NULL INTO Var_ClienteID;

		SELECT ClienteID INTO Var_ClienteID
			FROM EDOCTATMPENVIOCORREO
			WHERE AnioMes = Par_AnioMes
			AND ClienteID = Par_ClienteID
			AND SucursalID = Par_SucursalID;

		IF(Var_ClienteID IS NOT NULL) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= 'Ya existe un correo con el cliente, el periodo y sucursal especificado.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_EstatusEdoCta = Cadena_Vacia) THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= 'El Estatus del Estado de Cuenta esta vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_EstatusEnvio = Cadena_Vacia) THEN
			SET Par_NumErr	:= 8;
			SET Par_ErrMen	:= 'El Estatus del envio esta vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;
		-- Validación para asegurarse que el nuevo campo PDFGenerado no se inserte vacio. Cardinal Sistemas Inteligentes
		IF(Par_PDFGenerado = Cadena_Vacia) THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= 'El Estatus de PDFGenerado esta vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;
		-- Fin de la validacion. Cardinal Sistemas Inteligentes


		INSERT INTO EDOCTATMPENVIOCORREO (	AnioMes, 				ClienteID, 				SucursalID, 			CorreoEnvio,			EstatusEdoCta,
											EstatusEnvio, 			FechaEnvio,				UsuarioEnvia,			PDFGenerado,			EmpresaID,
											Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
											NumTransaccion
			)
			VALUES (						Par_AnioMes, 			Par_ClienteID, 			Par_SucursalID, 		Par_CorreoEnvio,		Par_EstatusEdoCta,
											Par_EstatusEnvio, 		Par_FechaEnvio,			Par_UsuarioEnvia,		Par_PDFGenerado,		Par_EmpresaID,
											Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
											Aud_NumTransaccion
			);

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Envio de correo registrado correctamente';
		SET Var_Consecutivo := Par_ClienteID;
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
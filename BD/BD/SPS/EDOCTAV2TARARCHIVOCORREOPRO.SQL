DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2TARARCHIVOCORREOPRO;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2TARARCHIVOCORREOPRO (
	-- Stored procedure para insertar en las tablas EDOCTAV2TARENVIOCORREO y EDOCTAV2TARARCHIVOCORREO
	Par_ClienteID					INT(11),				-- Numero de cliente a enviar correo
	Par_RutaPDF						VARCHAR(2000),			-- Ruta del archivo PDF en el servidor a adjuntar en el correo
	Par_PesoPDF						LONG,					-- Peso en bytes del archivo PDF a adjuntar en el correo
	Par_RutaXML						VARCHAR(2000),			-- Ruta del archivo XML en el servidor a adjuntar en el correo
	Par_PesoXML						LONG,					-- Peso en bytes del archivo XML a adjuntar en el correo
	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(800),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador
	Aud_EmpresaID 					INT(11), 				-- Parametro de auditoria
	Aud_Usuario						INT(11),				-- Parametro de auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal 					INT(11), 				-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Entero vacio
	DECLARE Decimal_Cero			DECIMAL(14,2);			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE Var_SalidaNO			CHAR(1);				-- Salida no
	DECLARE Var_PDF					CHAR(3);				-- Extension PDF
	DECLARE Var_XML					CHAR(3);				-- Extension XML
	DECLARE Var_ExtPDF				CHAR(4);				-- Extension PDF
	DECLARE Var_ExtXML				CHAR(4);				-- Extension XML

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de Control
	DECLARE Var_EnvioCorreoID		BIGINT(20);				-- ID del correo
	DECLARE Var_MesProceso			INT(11);				-- Periodo del estado de cuenta ejecutado
	DECLARE Var_EnvioAutomatico		CHAR(1);				-- Variable para determinar si esta habilitado el envio de correo de estados de cuenta
	DECLARE Var_RemitenteID			INT(11);				-- Identificador del remitente
	DECLARE Var_Asunto				VARCHAR(100);			-- Asunto del correo electronico
	DECLARE Var_CuerpoTexto			TEXT;					-- Cuerpo del texto
	DECLARE Var_FechaInicio			DATE;					-- Corresponde con la fecha de inicio del periodo a ejecutar de estado de cuenta
	DECLARE Var_FechaFin			DATE;					-- Corresponde con la fecha de fin del periodo a ejecutar de estado de cuenta
	DECLARE Var_Correo				VARCHAR(50);			-- Correo destinatario
	DECLARE Var_Contrasenia			VARCHAR(20);			-- Contrasenia que se compone del RFC sin homoclave del cliente

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero				:= 0.0;					-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';					-- Asignacion de salida no
	SET Var_PDF						:= 'PDF';				-- Extension PDF
	SET Var_XML						:= 'XML';				-- Extension XML
	SET Var_ExtPDF					:= '.pdf';				-- Extension PDF
	SET Var_ExtXML					:= '.xml';				-- Extension XML
	SET Par_ClienteID	:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_RutaPDF		:= IFNULL(Par_RutaPDF, Cadena_Vacia);
	SET Par_PesoPDF		:= IFNULL(Par_PesoPDF, Entero_Cero);
	SET Par_RutaXML		:= IFNULL(Par_RutaXML, Cadena_Vacia);
	SET Par_PesoXML		:= IFNULL(Par_PesoXML, Entero_Cero);

	SELECT		MesProceso,			EnvioAutomatico,		RemitenteID,		Asunto,		CuerpoTexto,
				FechaInicio,		FechaFin
		INTO	Var_MesProceso,		Var_EnvioAutomatico,	Var_RemitenteID,	Var_Asunto,	Var_CuerpoTexto,
				Var_FechaInicio,	Var_FechaFin
		FROM	EDOCTAV2PARAMS
		LIMIT 0, 1;

	SELECT		Correo,		SUBSTRING(IFNULL(RFCOficial, Cadena_Vacia), 1, GREATEST(LENGTH(IFNULL(RFCOficial, Cadena_Vacia)) - 3, Entero_Cero))
		INTO	Var_Correo,	Var_Contrasenia
		FROM	CLIENTES
		WHERE	ClienteID	= Par_ClienteID;

	SET Var_MesProceso		:= IFNULL(Var_MesProceso, Entero_Cero);
	SET Var_EnvioAutomatico	:= IFNULL(Var_EnvioAutomatico, Var_SalidaNO);
	SET Var_RemitenteID		:= IFNULL(Var_RemitenteID, Entero_Cero);
	SET Var_Asunto			:= IFNULL(Var_Asunto, Cadena_Vacia);
	SET Var_CuerpoTexto		:= IFNULL(Var_CuerpoTexto, Cadena_Vacia);
	SET Var_FechaInicio		:= IFNULL(Var_FechaInicio, Fecha_Vacia);
	SET Var_FechaFin		:= IFNULL(Var_FechaFin, Fecha_Vacia);
	SET Var_Correo			:= IFNULL(Var_Correo, Cadena_Vacia);

	-- Proceso que se encarga de pasar los registros si esta habilitado el envio automatico
	IF Var_Correo <> Cadena_Vacia THEN
		IF Par_RutaPDF <> Cadena_Vacia OR Par_RutaXML <> Cadena_Vacia THEN
			INSERT INTO EDOCTAV2TARENVIOCORREO (	ClienteID,			Periodo,			Contrasenia,		EmailDestino,		Asunto,
													Mensaje,			EstatusEnvio,		FechaEnvio,			FechaProgramada,	FechaVencimiento,
													Proceso,			PIDTarea,			DescripcionError,	RemitenteID,		EmpresaID,
													Usuario,			FechaActual,		DireccionIP,		ProgramaID,			Sucursal,
													NumTransaccion)
										VALUES (	Par_ClienteID,		Var_MesProceso, 	Var_Contrasenia,	Var_Correo,			Var_Asunto,
													Var_CuerpoTexto,	Var_SalidaNO,		Fecha_Vacia,		NOW(),				DATE_ADD(NOW(), INTERVAL 1 MONTH),
													Aud_ProgramaID,		Cadena_Vacia,		Cadena_Vacia,		Var_RemitenteID,	Aud_EmpresaID,
													Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
													Aud_NumTransaccion);

			SELECT		MAX(EnvioCorreoID)
				INTO	Var_EnvioCorreoID
				FROM	EDOCTAV2TARENVIOCORREO
				WHERE	Periodo		= Var_MesProceso
				  AND	ClienteID	= Par_ClienteID;
		END IF;

		IF Par_RutaPDF <> Cadena_Vacia THEN
			INSERT INTO EDOCTAV2TARARCHIVOCORREO (	EnvioCorreoID,		NombreArchivo,					Extension,			Archivo,			PesoByte,
													EmpresaID,			Usuario,						FechaActual,		DireccionIP,		ProgramaID,
													Sucursal,			NumTransaccion)
										VALUES (	Var_EnvioCorreoID,	CAST(Par_ClienteID AS CHAR),	Var_PDF,			Par_RutaPDF,		Par_PesoPDF,
													Aud_EmpresaID,		Aud_Usuario,					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
													Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

		IF Par_RutaXML <> Cadena_Vacia THEN
			INSERT INTO EDOCTAV2TARARCHIVOCORREO (	EnvioCorreoID,		NombreArchivo,					Extension,			Archivo,			PesoByte,
													EmpresaID,			Usuario,						FechaActual,		DireccionIP,		ProgramaID,
													Sucursal,			NumTransaccion)
										VALUES (	Var_EnvioCorreoID,	CAST(Par_ClienteID AS CHAR),	Var_XML,			Par_RutaXML,		Par_PesoXML,
													Aud_EmpresaID,		Aud_Usuario,					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
													Aud_Sucursal,		Aud_NumTransaccion);
		END IF;
	END IF;

	SET Par_NumErr	:= Entero_Cero;
	SET Par_ErrMen	:= 'Proceso de registro de archivos adjuntos finalizado exitosamente';
	SET Var_Control	:= 'EnvioCorreoID';

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;
END TerminaStore$$

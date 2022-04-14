-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOTIFCACORREOGRDVALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS NOTIFCACORREOGRDVALPRO;

DELIMITER $$
CREATE PROCEDURE `NOTIFCACORREOGRDVALPRO`(
	-- Store Procedure: De Proceso de Notificacion  de Guarda Valores
	-- Modulo Guarda Valores
	Par_TipoInstrumento			INT(11),		-- Tipo de Instrumento
	Par_TipoPersona 			CHAR(1),		-- Tipo de Persona

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	-- Declaraion de Variables
	DECLARE Var_NumErr 				INT(11);		--
	DECLARE Var_Contador			INT(10);		-- Contador para ciclo while
	DECLARE Var_NumPocision			INT(10);		-- Numero de Pocion del Correo
	DECLARE Var_NumNotificaciones	INT(11);		-- Numero de notificaciones
	DECLARE LongitudCadena 			INT(11);		-- Longitud de la Cadena

	DECLARE Var_Correo_Destino 		VARCHAR(500);	-- Variable de Correos de Destino
	DECLARE Var_NombrePersona		VARCHAR(200);	-- Nombre Persona
	DECLARE	Var_VersionSAFI			VARCHAR(200);	-- Version de SAFI
	DECLARE Var_Asunto				VARCHAR(100);	-- Variable de Asunto de la notificaicon
	DECLARE Var_Descripcion 		VARCHAR(100);	-- Descripcion
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_CorreoEnviar		VARCHAR(50);	-- Variable de Correo a Enviar
	DECLARE Var_Correo_Remitente 	VARCHAR(50);	-- Variavle de Correo Remitente

	DECLARE Var_Contrasenia			VARCHAR(50);	-- Contraseña del Correo de Notificacion
	DECLARE Var_UsuarioCorreo 		VARCHAR(50);	-- Contraseña del Correo de Notificacion
	DECLARE Var_ServidorCorreo		VARCHAR(30);	-- Servidor de Correo de Notificacion
	DECLARE	Var_ColorBG				VARCHAR(20);
	DECLARE Var_Puerto				VARCHAR(10);	-- Puerto de Envio de Notificacion
	DECLARE Var_Fecha 				DATETIME;		-- Fecha de Operacion
	DECLARE Var_FechaOperacion		DATE;			-- Fecha de Operacion

	DECLARE Var_Mensaje 			TEXT;			-- Mensaje de Notificacion
	DECLARE	Con_Mensaje				TEXT;
	DECLARE Var_PieMensaje			TEXT;
	DECLARE MensajeTMP				TEXT;
	DECLARE Var_RemitenteID			INT(11);

	-- Declaracion de constantes
	DECLARE Hora_Vacia				TIME;			-- Constante de hora Vacia
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO

	DECLARE Con_Prospecto 			CHAR(1);		-- Constante de Prospecto
	DECLARE Con_Cliente				CHAR(1);		-- Constante de Cliente
	DECLARE Origen_GuardaValores 	CHAR(1);		-- Origen Guarda Valores
	DECLARE Con_Separador 			CHAR(1);		-- Constante Separador
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero

	DECLARE Entero_Uno 				INT(11);		-- Entero Uno
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero
	DECLARE Var_ProcesoGuarda		VARCHAR(50);

	-- Asignacion  de constantes
	SET Hora_Vacia			:= '00:00:00';
	SET Fecha_Vacia			:= '1900-01-01';
	SET	Cadena_Vacia		:= '';
	SET	Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';

	SET Con_Prospecto 		:= 'P';
	SET Con_Cliente			:= 'C';
	SET Origen_GuardaValores := 'G';
	SET Con_Separador 		:= ',';
	SET	Entero_Cero			:= 0;
	SET Entero_Uno 			:= 1;

	SET	Decimal_Cero		:= 0.0;
	SET Var_ColorBG			:= '#1E4663';
	SET Var_Control			:= Cadena_Vacia;
	SET Var_ProcesoGuarda	:= 'Guarda Valores';


	SET Var_VersionSAFI		:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'VersionSAFI');
	SET Var_VersionSAFI		:= CONCAT('SAFI Ver.', IFNULL(Var_VersionSAFI, Entero_Cero));

	SELECT FechaSistema
	INTO Var_FechaOperacion
	FROM PARAMETROSSIS
	LIMIT 1;

	SET Var_Descripcion := 'Existen nuevos Documentos para Resguardo en guarda valores.';

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-NOTIFCACORREOGRDVALPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;


		SELECT CorreoRemitente,		ServidorCorreo,		Puerto,		UsuarioServidor,	Contrasenia
		INTO Var_Correo_Remitente,	Var_ServidorCorreo,	Var_Puerto,	Var_UsuarioCorreo,	Var_Contrasenia
		FROM PARAMGUARDAVALORES
		LIMIT 1;

		SELECT CAST(ValorParametro AS UNSIGNED)
		INTO Var_RemitenteID
		FROM PARAMGENERALES
		WHERE LlaveParametro =  'RemitenteGuardaValor';

		SET Var_RemitenteID := IFNULL(Var_RemitenteID, Entero_Cero);

		IF(IFNULL(Var_Correo_Destino, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('La notificacion se realizo Correctamente.');
			SET Var_Control	:= Cadena_Vacia;
		END IF;

		IF( Par_TipoPersona = Con_Cliente ) THEN
			SELECT NombreCompleto
			INTO Var_NombrePersona
			FROM CLIENTES
			WHERE ClienteID = Par_TipoInstrumento;
		END IF;

		IF( Par_TipoPersona = Con_Prospecto ) THEN
			SELECT NombreCompleto
			INTO Var_NombrePersona
			FROM PROSPECTOS
			WHERE ProspectoID = Par_TipoInstrumento;
		END IF;

		SET Var_NombrePersona := IFNULL(Var_NombrePersona, Cadena_Vacia);

		-- Puestos Facultados
		SET @Consecutivo := Entero_Cero;
		INSERT INTO TMPNOTIFICAGRDVALORES(
				NotificacionID,
				CorreoDestino,		EmpresaID,		Usuario,		FechaActual,
				DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
		SELECT 	@Consecutivo:=(@Consecutivo+Entero_Uno),
				Usr.Correo,			Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
		FROM USUARIOS Usr
		INNER JOIN USRGUARDAVALORES Par ON Par.PuestoFacultado = Usr.ClavePuestoID
		WHERE IFNULL(Usr.Correo, Cadena_Vacia) <> Cadena_Vacia;

		-- Usuarios Facultados
		INSERT INTO TMPNOTIFICAGRDVALORES(
				NotificacionID,
				CorreoDestino,		EmpresaID,		Usuario,		FechaActual,
				DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
		SELECT 	@Consecutivo:=(@Consecutivo+Entero_Uno),
				Usr.Correo,			Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
		FROM USUARIOS Usr
		INNER JOIN USRGUARDAVALORES Par ON Par.UsuarioFacultadoID = Usr.UsuarioID
		WHERE IFNULL(Usr.Correo, Cadena_Vacia) <> Cadena_Vacia;


		SET Con_Mensaje :=CONCAT(
			'<table cellspacing="0" cellpadding="0" border="0" bgcolor="#ffffff" style="width:100%;max-width:600px;margin:0 auto"> ',
			'<tbody> ',
				'<tr> ',
					'<td colspan="3" align="left" style="line-height:0;box-sizing:border-box;padding:24px 40px 16px 40px; color:white; font-family:Arial" bgcolor="',Var_ColorBG,'" width="600px" height="74px"></td> ',
				'</tr> ',
				'<tr> ',
					'<td colspan="3" align="left" style="font-family:Arial;color:#566270;font-size:15px;line-height:19px;padding:30px 40px">Estimado(a)</td>',
					'GUARDA VALORES:<br><br> ',
					'<table style="color:#00000"> ',
						'<thead style="background-color:',Var_ColorBG,'; color:#ffffff;font-family:Arial; text-align:center;"> ',
							'<tr> ',
								'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Instrumento</label></td> ',
								'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Nombre<br>de la Pers. Involucrada</label></td> ',
								'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Fecha Operaci&oacute;n</label></td> ',
								'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Descripci&oacute;n<br>de la Operaci&oacute;n</label></td> ',
							'</tr> ',
						'</thead> ',
						'<tbody style="vertical-align: text-top; font-size: 11px; color:#566270;"> ');

		SET MensajeTMP	:= CONCAT(Con_Mensaje,
						'<tr style="border-bottom: 1px solid ',Var_ColorBG,';"> ',
							'<td width="200px" style="text-align: center;">',Par_TipoInstrumento,'</td> ',
							'<td width="200px">',Var_NombrePersona,'</td> ',
							'<td width="200px" style="text-align: center;">',Var_FechaOperacion,'</td> ',
							'<td width="200px" style="text-align: left;">',Var_Descripcion,'</td> ',
						'</tr> ');

		SET Var_PieMensaje := CONCAT(MensajeTMP,
						'</tbody>',
						'</table>',
						'<br>',
						'Por favor, dir&iacute;jase a la pantalla ubicada en SAFI para darle(s) seguimiento oportuno:',
						'<br><b>Guarda Valores > Registro >  Registro de Documentos</b>',
						'<br>',
						'<br>',
						'Gracias.',
					'</td> ',
				'</tr> ',
				'<tr> ',
					'<td colspan="3" align="right" style="height:10px;background-color:',Var_ColorBG,';width:600px;padding:10px 5px 5px 5px;box-sizing:border-box;color: #ffffff;font-size: 10px;font-family:Arial;"> ',
						'<label>',Var_VersionSAFI,'</label> ',
					'</td> ',
				'</tr> ',
			'</tbody> ',
		'</table> ');


		SET Var_Mensaje := Var_PieMensaje;
		SET Var_Asunto	:='GUARDA VALORES.';

		-- Obtengo el Numero de Notificaciones
		SELECT IFNULL(COUNT(NotificacionID), Entero_Cero)
		INTO Var_NumNotificaciones
		FROM TMPNOTIFICAGRDVALORES
		WHERE NumTransaccion = Aud_NumTransaccion;

		-- Inicializo el Contador
		SET Var_Contador := Entero_Uno;

		-- Inicio la Insercion
		WHILE ( Var_Contador <= Var_NumNotificaciones) DO

			SELECT CorreoDestino
			INTO Var_CorreoEnviar
			FROM TMPNOTIFICAGRDVALORES
			WHERE NotificacionID = Var_Contador
			  AND NumTransaccion = Aud_NumTransaccion;

			SET Var_Fecha := NOW();
			SET Aud_FechaActual := NOW();

			-- Envio el correo
			CALL TARENVIOCORREOALT(
				Var_RemitenteID,		Var_CorreoEnviar,	Var_Asunto,			Var_Mensaje, 		Entero_Cero,
				Var_Fecha,				Fecha_Vacia,		Var_ProcesoGuarda,	Cadena_Vacia,		Salida_NO,
				Par_NumErr, 			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP, 		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			-- Si el proceso falla la salida es exitosa para no detener el flujo
			IF( Par_NumErr <> Entero_Cero ) THEN
				DELETE FROM TMPNOTIFICAGRDVALORES WHERE NumTransaccion = Aud_NumTransaccion;
				SET Par_NumErr  := Entero_Cero;
				SET Par_ErrMen  := Cadena_Vacia;
				SET Var_Control := Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;

			SET Var_Contador := Var_Contador + Entero_Uno;

		END WHILE;

		UPDATE ENVIOCORREO SET
			Origen = Origen_GuardaValores
		WHERE Remitente = Var_Correo_Remitente
		  AND Asunto = Var_Asunto
		  AND NumTransaccion = Aud_NumTransaccion;

		DELETE FROM TMPNOTIFICAGRDVALORES WHERE NumTransaccion = Aud_NumTransaccion;

		IF( Par_NumErr <> Entero_Cero ) THEN
			DELETE FROM TMPNOTIFICAGRDVALORES WHERE NumTransaccion = Aud_NumTransaccion;
			SET Par_NumErr  := Entero_Cero;
			SET Par_ErrMen  := Cadena_Vacia;
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('La notificacion se realizo Correctamente.');
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Control AS consecutivo;
	END IF;

END TerminaStore$$
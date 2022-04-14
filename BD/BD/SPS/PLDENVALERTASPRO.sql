-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDENVALERTASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDENVALERTASPRO`;
DELIMITER $$


CREATE PROCEDURE `PLDENVALERTASPRO`(
	-- STORE QUE REGISTRA EL CORREO POR DETECCION PLD
	Par_TipoOperacion	INT(11),		-- Tipo de operación. 1.- Relevante 2.- Inusual.
	Par_OperacionID		BIGINT(20),		-- ID de la operacion inusual a enviar como alerta
	Par_Salida			CHAR(1),		-- Indica el tipo de Salida S.- Si N.- No
	INOUT Par_NumErr   	INT,			-- Numero de Error
    INOUT Par_ErrMen   	VARCHAR(400),	-- Mensaje de Error

	-- Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE	Var_Persona				VARCHAR(200);
DECLARE	Var_FechaSistema		DATE;
DECLARE	Var_FechaDeteccion		DATE;
DECLARE	Var_DesOperacion  		VARCHAR(500);
DECLARE Var_MontoOperacion		DECIMAL(16,2);
DECLARE Var_Remitente			VARCHAR(50);
DECLARE Var_DestinatarioPLD		VARCHAR(50);
DECLARE	Var_ServidorCorreo		VARCHAR(30);
DECLARE	Var_Puerto				VARCHAR(10);
DECLARE	Var_Contrasenia			VARCHAR(20);
DECLARE	Var_UsuarioCorreo		VARCHAR(50);
DECLARE	Var_TipoPersonaSAFI		VARCHAR(3);
DECLARE	Var_ClavePersonaInv		BIGINT(12);
DECLARE	Var_ClienteID			BIGINT(12);
DECLARE	Var_NombreCompleto		VARCHAR(200);
DECLARE	Var_Descripcion			VARCHAR(200);
DECLARE	Var_FechaAlta			DATE;
DECLARE	Var_FechaDepInicial		DATE;
DECLARE	Var_CuentaAhoID			BIGINT(12);
DECLARE	Var_TipoPersonaSAFIDes	VARCHAR(20);
DECLARE	Var_ColorBG				VARCHAR(20);
DECLARE	Var_VersionSAFI			VARCHAR(200);
DECLARE Var_UsuarioServicioID	INT(11);			-- Identificador del Usuario de Servicio
DECLARE Var_NumTransaccion		BIGINT(20);			-- Almacena el Numero de Transaccion de la Operacion

-- Declaracion de Variables
DECLARE	Con_Mensaje				TEXT;
DECLARE	Con_MensajeDes			TEXT;
DECLARE	Con_MensajeEnviar		TEXT;
DECLARE Var_RemitenteID			INT(11);
DECLARE	Var_CteInvolucrado		VARCHAR(100);
DECLARE	Var_DesCortaPreoc		VARCHAR(50);

-- Declaracion de Constantes
DECLARE	Con_Asunto			VARCHAR(150);
DECLARE	Entero_Cero			INT;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Str_SI				CHAR(1);
DECLARE Str_No				CHAR(1);
DECLARE ESCLIENTE			VARCHAR(3);
DECLARE ESUSUARIO			VARCHAR(3);
DECLARE ESAVAL				VARCHAR(3);
DECLARE ESPROSPECTO			VARCHAR(3);
DECLARE ESRELACIONADO		VARCHAR(3);
DECLARE	TipoRelevante		INT(11);
DECLARE	TipoInusual			INT(11);
DECLARE	TipoIntPreo			INT(11);
DECLARE Var_ProcesoPld		VARCHAR(50);

-- Asignacion de Variables
SET Con_Asunto			:='Alertas PLD 24 HRS [URGENTE]';-- Asunto del Mensaje
SET	Con_MensajeDes		:='';			-- tds del mensaje
SET Entero_Cero			:=0;			-- Constante Cero
SET Con_MensajeEnviar	:='';			-- Mensaje completo a Enviar
SET Cadena_Vacia		:='';			-- Cadena Vacia
SET Str_SI 				:= 'S';			-- Constante SI
SET Str_No 				:= 'N';			-- Constante NO
SET Fecha_Vacia			:= '1900-01-01';-- Fecha Vacia
SET ESCLIENTE			:= 'CTE';
SET ESUSUARIO			:= 'USU';
SET ESAVAL				:= 'AVA';
SET ESPROSPECTO			:= 'PRO';
SET ESRELACIONADO		:= 'REL';
SET TipoRelevante		:= 1;
SET TipoInusual			:= 2;
SET TipoIntPreo			:= 3;
SET Var_ColorBG			:= '#1E4663';
SET Var_ProcesoPld		:= 'PLD';

SET Aud_FechaActual := NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDENVALERTASPRO');
	END;

	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_VersionSAFI		:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'VersionSAFI');
	SET Var_VersionSAFI		:= CONCAT('SAFI v', IFNULL(Var_VersionSAFI, Entero_Cero));
	-- Se obtiene la cuenta de correo del Oficial de Cumplimiento
	SET Var_DestinatarioPLD := (SELECT Correo FROM USUARIOS USU, PARAMETROSSIS PAR
										WHERE PAR.OficialCumID = USU.UsuarioID);

	-- Se obtienen los parametros de la cuenta de correo que realiza el envio del mismo
	SELECT PAR.Remitente, PAR.ServidorCorreo, PAR.Puerto, PAR.UsuarioCorreo,	PAR.Contrasenia,
			USU.NombreCompleto
	  INTO Var_Remitente,Var_ServidorCorreo,  Var_Puerto, Var_UsuarioCorreo,	Var_Contrasenia,
	  		Var_NombreCompleto
		FROM USUARIOS USU,
				PARAMETROSSIS PAR
			WHERE PAR.OficialCumID= USU.UsuarioID;

	SELECT CAST(ValorParametro AS UNSIGNED)
		INTO Var_RemitenteID
		FROM PARAMGENERALES
		WHERE LlaveParametro =  'RemitentePld';

	SET Var_RemitenteID := IFNULL(Var_RemitenteID, Entero_Cero);

	SET Con_Mensaje :=CONCAT(
		'<table cellspacing="0" cellpadding="0" border="0" bgcolor="#ffffff" style="width:100%;max-width:600px;margin:0 auto"> ',
		'<tbody> ',
			'<tr> ',
				'<td colspan="3" align="left" style="line-height:0;box-sizing:border-box;padding:24px 40px 16px 40px; color:white; font-family:Arial" bgcolor="',Var_ColorBG,'" width="600px" height="74px"><img src="data:image/png;base64,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"></td> ',
			'</tr> ',
			'<tr> ',
				'<td colspan="3" align="left" style="font-family:Arial;color:#566270;font-size:15px;line-height:19px;padding:30px 40px">Estimado(a) <b>',Var_NombreCompleto,'</b>.<br><br> ');

	IF(Par_TipoOperacion = TipoRelevante)THEN
		SET Con_Asunto := 'Alerta por Operación Relevante.';
		-- Se obtiene los datos de la operación relevante.
		SELECT
			P.Fecha,				P.ClienteID,	P.NombreCompleto,	P.CuentaAhoID,		P.Monto,
            P.UsuarioServicioID,	P.NumTransaccion
		INTO
			Var_FechaDeteccion,		Var_ClienteID,	Var_NombreCompleto,	Var_CuentaAhoID,	Var_MontoOperacion,
            Var_UsuarioServicioID,	Var_NumTransaccion
		FROM PLDOPEREELEVANT P
			WHERE P.OpeReelevanteID = Par_OperacionID;

		SET Var_FechaDeteccion		:= IFNULL(Var_FechaDeteccion,Fecha_Vacia);
		SET Var_ClienteID			:= IFNULL(Var_ClienteID,Entero_Cero);
		SET Var_NombreCompleto		:= IFNULL(Var_NombreCompleto,Cadena_Vacia);
		SET Var_CuentaAhoID			:= IFNULL(Var_CuentaAhoID,Entero_Cero);
		SET Var_MontoOperacion		:= IFNULL(Var_MontoOperacion,Entero_Cero);
		SET Var_UsuarioServicioID	:= IFNULL(Var_UsuarioServicioID,Entero_Cero);
		SET Var_NumTransaccion		:= IFNULL(Var_NumTransaccion,Entero_Cero);

        -- SI LA OPERACION RELEVANTE ES DE UN USUARIO DE SERVICIO
        IF(Var_UsuarioServicioID > Entero_Cero)THEN
			SET Var_ClienteID 	:= Var_UsuarioServicioID;
            SET Var_CuentaAhoID	:= Var_NumTransaccion;
        END IF;

		SET Var_TipoPersonaSAFIDes := FNGENERALOCALE('safilocale.cliente');

		SET Con_MensajeDes	:= CONCAT(Con_MensajeDes,
			'Existe una nueva Operaci&oacute;n Relevante:<br><br> ',
				'<table style="color:#00000"> ',
					'<thead style="background-color:',Var_ColorBG,'; color:#ffffff;font-family:Arial; text-align:center;"> ',
						'<tr> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Folio</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Fecha Detecci&oacute;n</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>N&uacute;m. y Nombre<br>del ',Var_TipoPersonaSAFIDes,'</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>N&uacute;m. Cuenta<br>Operaci&oacute;n</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Monto<br>Operaci&oacute;n</label></td> ',
						'</tr> ',
					'</thead> ',
					'<tbody style="vertical-align: text-top; font-size: 11px; color:#566270;"> ',
						'<tr style="border-bottom: 1px solid ',Var_ColorBG,';"> ',
							'<td width="200px" style="text-align: center;">',Par_OperacionID,'</td> ',
							'<td width="200px" style="text-align: center;">',Var_FechaDeteccion,'</td> ',
							'<td width="200px">',Var_ClienteID,' - ',Var_NombreCompleto,'</td> ',
							'<td width="200px" style="text-align: center;">',Var_CuentaAhoID,'</td> ',
							'<td width="200px" style="text-align: right;">$',FORMAT(Var_MontoOperacion,2),'</td> ',
						'</tr> ',
					'</tbody> ',
				'</table><br>Por favor, dirijase a la pantalla ubicada en el SAFI para generar el reporte para mayor detalle:<br><b>Prevencion LD > Reportes > Op. Relevantes</b><br><br>Gracias. ',
			'</td> ',
		'</tr> ');

	END IF;

	IF(Par_TipoOperacion = TipoInusual)THEN
		-- Se obtienen los valores de la operacion inusual
		SELECT
			NomPersonaInv,	FechaDeteccion,		DesOperacion,		TipoPersonaSAFI,		ClavePersonaInv
		INTO
			Var_Persona,	Var_FechaDeteccion,	Var_DesOperacion,	Var_TipoPersonaSAFI,	Var_ClavePersonaInv
			FROM PLDOPEINUSUALES
				WHERE OpeInusualID = Par_OperacionID;

		SET Var_TipoPersonaSAFIDes := IF(Var_TipoPersonaSAFI = ESCLIENTE,FNGENERALOCALE('safilocale.cliente'),
										IF(Var_TipoPersonaSAFI = ESUSUARIO, 'Usuario de Servicios',
											IF(Var_TipoPersonaSAFI = ESAVAL,'Aval',
												IF(Var_TipoPersonaSAFI = ESPROSPECTO,'Prospecto',
													IF(Var_TipoPersonaSAFI = ESRELACIONADO,'Relacionado a la Cta.','Número')))));

		SET Con_MensajeDes	:= CONCAT(Con_MensajeDes,
			'Se ha detectado una Operaci&oacute;n Inusual:',
			'<br>',
			'<br>',
			'<table style="color:#00000">',
			'<thead style="background-color:',Var_ColorBG,'; color:#ffffff;font-family:Arial; text-align:center;">',
			'<tr>',
			'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;">',
			'<label>Folio</label>',
			'</td>',
			'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;">',
			'<label>',Var_TipoPersonaSAFIDes,'</label>',
			'</td>',
			'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;">',
			'<label>Fecha</label>',
			'</td>',
			'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;">',
			'<label>Descripci&oacute;n</label>',
			'</td>',
			'</tr>',
			'</thead>',
			'<tbody style="vertical-align: text-top; font-size: 11px; color:#566270;">');

		SET Var_Persona			:=IFNULL(Var_Persona, Cadena_Vacia);
		SET Var_FechaDeteccion	:=IFNULL(Var_FechaDeteccion, Fecha_Vacia);
		SET Var_DesOperacion	:=IFNULL(Var_DesOperacion, Cadena_Vacia);
		SET Par_OperacionID		:=IFNULL(Par_OperacionID, Entero_Cero);

		SET Con_MensajeDes	:=CONCAT(Con_MensajeDes,
				'<tr style="border-bottom: 1px solid ',Var_ColorBG,';">',
					'<td width="200px" style="text-align: center;">',Par_OperacionID,'</td>',
					'<td width="200px">',Var_Persona,'</td>',
					'<td width="200px" style="text-align: center;">',Var_FechaDeteccion,'</td>',
					'<td width="200px">',Var_DesOperacion,'</td>',
				'</tr>',
			'</tbody>',
			'</table>');

		IF(Var_TipoPersonaSAFI = ESCLIENTE) THEN
			SELECT
				CLI.ClienteID,		NombreCompleto,			ACT.Descripcion,		FechaAlta,		CuentaAhoID
			INTO
				Var_ClienteID,		Var_NombreCompleto,		Var_Descripcion,		Var_FechaAlta,	Var_CuentaAhoID
			FROM CLIENTES AS CLI
			LEFT JOIN CUENTASAHO AS CTA ON CLI.ClienteID = CTA.ClienteID
			INNER JOIN ACTIVIDADESBMX AS ACT ON CLI.ActividadBancoMX = ACT.ActividadBMXID
			WHERE CLI.ClienteID = Var_ClavePersonaInv
			LIMIT 1;

			SET Con_MensajeDes := CONCAT(Con_MensajeDes,
				'<br><b>No. ',FNGENERALOCALE('safilocale.cliente'),':</b> ',Var_ClienteID,
				'<br><b>Nombre:</b> ',Var_NombreCompleto,
				'<br><b>Actividad BMX:</b> ',Var_Descripcion,
				'<br><b>Fecha de Afiliaci&oacute;n:</b> ',Var_FechaAlta);
		END IF;

		-- Se concluye el armado del cuerpo del mensaje de correo
		SET Con_MensajeDes := CONCAT(Con_MensajeDes,
				'<br><br>',
				'Por favor, dirijase a la pantalla ubicada en el SAFI para darle seguimiento oportuno:',
				'<br><b>Prevencion LD > Procesos >  Segto. Operaciones Inusuales</b>',
				'<br>',
				'<br>',
				'Gracias.',
			'</td> ',
		'</tr> ');
	END IF;

	IF(Par_TipoOperacion = TipoIntPreo)THEN
		SET Con_Asunto := CONCAT('Notificacion de Operacion Interna Preocupante.');

		# SE OBTIENE LOS DATOS DE LA OPERACIÓN INTERNA PREOCUPANTES.
		SELECT
			P.Fecha,			P.ClavePersonaInv,		P.NomPersonaInv,	P.CteInvolucrado,	C.DesCorta,
			P.DesOperacion
		INTO
			Var_FechaDeteccion,	Var_ClavePersonaInv,	Var_NombreCompleto,	Var_CteInvolucrado,	Var_DesCortaPreoc,
			Var_DesOperacion
		FROM PLDOPEINTERPREO P
			INNER JOIN PLDCATMOTIVPREO C ON P.CatMotivPreoID = C.CatMotivPreoID
			WHERE P.OpeInterPreoID = Par_OperacionID;

		SET Var_FechaDeteccion		:= IFNULL(Var_FechaDeteccion,Fecha_Vacia);
		SET Var_ClavePersonaInv		:= IFNULL(Var_ClavePersonaInv,Entero_Cero);
		SET Var_NombreCompleto		:= IFNULL(Var_NombreCompleto,Cadena_Vacia);
		SET Var_CteInvolucrado		:= TRIM(IFNULL(Var_CteInvolucrado,Cadena_Vacia));
		SET Var_DesCortaPreoc		:= IFNULL(Var_DesCortaPreoc,Cadena_Vacia);
		SET Var_DesOperacion		:= IFNULL(Var_DesOperacion,Cadena_Vacia);

		SET Var_TipoPersonaSAFIDes := FNGENERALOCALE('safilocale.cliente');

		SET Con_MensajeDes	:= CONCAT(Con_MensajeDes,
			'Ha sido reportada una Operaci&oacute;n Interna Preocupante:<br><br> ',
				'<table style="color:#00000"> ',
					'<thead style="background-color:',Var_ColorBG,'; color:#ffffff;font-family:Arial; text-align:center;"> ',
						'<tr> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Folio Operaci&oacute;n</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Fecha Detecci&oacute;n</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>N&uacute;m. y Nombre<br>del Empleado</label></td> ',
							IF(Var_CteInvolucrado != Cadena_Vacia,
								CONCAT(
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>',Var_TipoPersonaSAFIDes,' Involucrado</label></td> '),
							Cadena_Vacia),
						'</tr> ',
					'</thead> ',
					'<tbody style="vertical-align: text-top; font-size: 11px; color:#566270;"> ',
						'<tr style="border-bottom: 1px solid ',Var_ColorBG,';"> ',
							'<td width="200px" style="text-align: center;">',LPAD(Par_OperacionID,5,'0'),'</td> ',
							'<td width="200px" style="text-align: center;">',Var_FechaDeteccion,'</td> ',
							'<td width="200px">',Var_ClavePersonaInv,' - ',Var_NombreCompleto,'</td> ',
							IF(Var_CteInvolucrado != Cadena_Vacia,
							CONCAT(
							'<td width="200px">',Var_CteInvolucrado,'</td> '),
							Cadena_Vacia),
						'</tr> ',
					'</tbody> ',
				'</table>',

				'<br><b>Motivo Reporte:</b> ',Var_DesCortaPreoc,
				'<br><b>Descripci&oacute;n de la Operaci&oacute;n:</b> ',TRIM(Var_DesOperacion),
				'<br><br>',
				'<br>Por favor, dir&iacute;jase a la pantalla ubicada en el SAFI para un seguimiento oportuno:<br><b>Prevencion LD > Procesos > Segto. Op. Internas Preocupantes</b><br><br>Gracias. ',
			'</td> ',
		'</tr> ');

	END IF;

	-- Se concluye el armado del cuerpo del mensaje de correo
	SET Con_MensajeEnviar:=CONCAT(Con_Mensaje,Con_MensajeDes,
			'<tr> ',
				'<td colspan="3" align="right" style="height:10px;background-color:',Var_ColorBG,';width:600px;padding:10px 5px 5px 5px;box-sizing:border-box;color: #ffffff;font-size: 10px;font-family:Arial;"> ',
					'<label>',Var_VersionSAFI,'</label> ',
				'</td> ',
			'</tr> ',
		'</tbody> ',
	'</table> ');

	-- Se hace el registro del correo para su envio
	CALL TARENVIOCORREOALT(
		Var_RemitenteID,	Var_DestinatarioPLD,	Con_Asunto, 		Con_MensajeEnviar,		Entero_Cero,
		Aud_FechaActual,	Fecha_Vacia,			Var_ProcesoPld,		Cadena_Vacia,			Str_No,
		Par_NumErr, 		Par_ErrMen, 			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
		Aud_DireccionIP, 	Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion);

END ManejoErrores;  -- End del Handler de Errores.

	IF Par_Salida = Str_SI THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'numero' AS Control,
				Par_OperacionID AS Consecutivo;
	END IF;

END TerminaStore$$

-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONEDASENVALERTASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONEDASENVALERTASPRO`;

DELIMITER $$
CREATE PROCEDURE `MONEDASENVALERTASPRO`(
/* REGISTRA UNA ALERTA DE CORREO POR ACTUALIZACIÓN DEL TIPO DE CAMBIO DOF. */
	Par_MonedaID        INT(11),		-- ID de la moneda
	Par_TipoAlerta		INT(11),		-- Tipo de Alerta 1: Act. Exitosa. 2: Error.
	Par_Salida			CHAR(1),		-- Indica el tipo de Salida S.- Si N.- No
	INOUT Par_NumErr   	INT,			-- Numero de Error
    INOUT Par_ErrMen   	VARCHAR(400),	-- Mensaje de Error

	/* Parametros de Auditoria */
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
DECLARE	Var_FechaSistema		DATE;
DECLARE Var_Destinatarios		VARCHAR(500);
DECLARE	Var_NombreCompleto		VARCHAR(200);
DECLARE	Var_ColorBG				VARCHAR(20);
DECLARE	Var_VersionSAFI			VARCHAR(200);
DECLARE Var_RolAdminTeso		INT(11);
DECLARE Var_Descrip				VARCHAR(80);
DECLARE Var_DescriCorta			VARCHAR(45);
DECLARE Var_TipCamDof			DECIMAL(14,6);
DECLARE Var_FechaRegistro		DATE;
DECLARE Var_FechaActBanxico		VARCHAR(10);
DECLARE Var_RemitenteID			INT(11);

DECLARE	Con_Mensaje				TEXT;
DECLARE	Con_MensajeDes			TEXT;
DECLARE	Con_MensajeEnviar		TEXT;

-- Declaracion de Constantes
DECLARE	Con_Asunto			VARCHAR(150);
DECLARE	Entero_Cero			INT;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Str_SI				CHAR(1);
DECLARE Str_No				CHAR(1);
DECLARE Var_ProcesoID		VARCHAR(50);
DECLARE TipoAlerta_Exito	INT(11);
DECLARE TipoAlerta_Error	INT(11);

-- Asignacion de Variables
SET Con_Asunto			:='Alertas';	-- Asunto del Mensaje
SET	Con_MensajeDes		:='';			-- tds del mensaje
SET Entero_Cero			:=0;			-- Constante Cero
SET Con_MensajeEnviar	:='';			-- Mensaje completo a Enviar
SET Cadena_Vacia		:='';			-- Cadena Vacia
SET Str_SI 				:= 'S';			-- Constante SI
SET Str_No 				:= 'N';			-- Constante NO
SET Fecha_Vacia			:= '1900-01-01';-- Fecha Vacia
SET TipoAlerta_Exito	:=01;			-- Tipo de Alerta Exito.
SET TipoAlerta_Error	:=02;			-- Tipo de Alerta Error.
SET Var_ColorBG			:= '#1E4663';
SET Var_ProcesoID		:= 'TESORERIA';

SET Aud_FechaActual := NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		GET DIAGNOSTICS condition 1
		@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-MONEDASENVALERTASPRO[',@Var_SQLState,'-' , @Var_SQLMessage,']');
	END;

	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_VersionSAFI		:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'VersionSAFI');
	SET Var_VersionSAFI		:= CONCAT('SAFI v', IFNULL(Var_VersionSAFI, Entero_Cero));
	SET Var_RolAdminTeso	:= (SELECT RolAdminTeso FROM PARAMETROSSIS limit 1);
	SET Var_RolAdminTeso	:= IFNULL(Var_RolAdminTeso, Entero_Cero);
	SET Var_NombreCompleto	:= (SELECT UPPER(NombreRol) FROM ROLES WHERE RolID = Var_RolAdminTeso);
	SET Var_NombreCompleto	:= IFNULL(Var_NombreCompleto, Entero_Cero);
	SET Var_Destinatarios	:= (SELECT LEFT(GROUP_CONCAT(Correo),500) FROM USUARIOS U
								WHERE U.RolID = Var_RolAdminTeso AND U.Correo IS NOT NULL AND TRIM(U.Correo) != Cadena_Vacia GROUP BY U.RolID);
	SET Var_RemitenteID		:= (SELECT CAST(ValorParametro AS UNSIGNED) FROM PARAMGENERALES
								WHERE LlaveParametro =  'RemitenteTeso');
	SET Var_RemitenteID		:= IFNULL(Var_RemitenteID, Entero_Cero);


	SET Con_Mensaje :=CONCAT(
		'<table cellspacing="0" cellpadding="0" border="0" bgcolor="#ffffff" style="width:100%;max-width:600px;margin:0 auto"> ',
		'<tbody> ',
			'<tr> ',
				'<td colspan="3" align="left" style="line-height:0;box-sizing:border-box;padding:24px 40px 16px 40px; color:white; font-family:Arial" bgcolor="',Var_ColorBG,'" width="600px" height="74px"><img src="data:image/png;base64,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"></td> ',
			'</tr> ',
			'<tr> ',
				'<td colspan="3" align="left" style="font-family:Arial;color:#566270;font-size:15px;line-height:19px;padding:30px 40px;text-align: justify;text-justify: inter-word;">Estimado(a) <b>',Var_NombreCompleto,'</b>.<br><br> ');

	IF(Par_TipoAlerta = TipoAlerta_Exito)THEN
		-- Se obtiene los datos de la operación relevante.
		SELECT
			Descripcion,	TipCamDof,		FechaRegistro,		FechaActBanxico,
			DescriCorta
		INTO
			Var_Descrip,	Var_TipCamDof,	Var_FechaRegistro,	Var_FechaActBanxico,
			Var_DescriCorta
		FROM MONEDAS
		WHERE MonedaId = Par_MonedaID;

		SET Var_Descrip				:= IFNULL(Var_Descrip,Cadena_Vacia);
		SET Var_DescriCorta			:= IFNULL(Var_DescriCorta,Cadena_Vacia);
		SET Var_TipCamDof			:= IFNULL(Var_TipCamDof,Entero_Cero);
		SET Var_FechaRegistro		:= IFNULL(Var_FechaRegistro,Fecha_Vacia);
		SET Var_FechaActBanxico		:= IFNULL(Var_FechaActBanxico,Fecha_Vacia);

		SET Con_Asunto := CONCAT('Actualizacion de Divisa [',Var_DescriCorta,']. Fecha [',Var_FechaSistema,'].');

		SET Con_MensajeDes	:= CONCAT(Con_MensajeDes,
			'Se ha actualizado el Tipo de Cambio DOF (WS):<br><br> ',
				'<table style="color:#00000"> ',
					'<thead style="background-color:',Var_ColorBG,'; color:#ffffff;font-family:Arial; text-align:center;"> ',
						'<tr> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Moneda ID</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Descripci&oacute;n</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Tipo de Cambio<br>DOF</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Fecha de<br>Actualizaci&oacute;n</label></td> ',
						'</tr> ',
					'</thead> ',
					'<tbody style="vertical-align: text-top; font-size: 11px; color:#566270;"> ',
						'<tr style="border-bottom: 1px solid ',Var_ColorBG,';"> ',
							'<td width="200px" style="text-align: center;">',Par_MonedaID,'</td> ',
							'<td width="200px" style="text-align: center;">',Var_Descrip,'</td> ',
							'<td width="200px" style="text-align: center;">',Var_TipCamDof,'</td> ',
							'<td width="200px" style="text-align: center;">',Var_FechaActBanxico,'</td> ',
						'</tr> ',
					'</tbody> ',
				'</table><br>Por favor, dirijase a la pantalla ubicada en el SAFI para consultar el nuevo Tipo de Cambio DOF: <b>Tesoreria > Taller de Productos > Registro de Divisas</b>.<br><br>Gracias. ',
			'</td> ',
		'</tr> ');
	END IF;

	IF(Par_TipoAlerta = TipoAlerta_Error)THEN
		SET Con_Asunto := CONCAT('Error en Act. de Divisas.');

		SET Con_MensajeDes	:= CONCAT(Con_MensajeDes,
			'No se ha actualizado el Tipo de Cambio DOF debido a un problema con el Servicio Web del Banco de M&eacute;xico.<br><br>Por favor, dirijase a la pantalla ubicada en el SAFI para realizar la Actualizaci&oacute;n Manual del Tipo de Cambio DOF: <b>Tesoreria > Taller de Productos > Registro de Divisas</b>.<br><br>Gracias. ',
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
		Var_RemitenteID,	Var_Destinatarios,		Con_Asunto, 		Con_MensajeEnviar,		Entero_Cero,
		Aud_FechaActual,	Fecha_Vacia,			Var_ProcesoID,		Cadena_Vacia,			Str_No,
		Par_NumErr, 		Par_ErrMen, 			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
		Aud_DireccionIP, 	Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion);

	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT('Alerta Generada Exitosamente.');

END ManejoErrores;  -- End del Handler de Errores.

	IF(Par_Salida = Str_SI)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'numero' AS Control,
				Par_MonedaID AS Consecutivo;
	END IF;

END TerminaStore$$


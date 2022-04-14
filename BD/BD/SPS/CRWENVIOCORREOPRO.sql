-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWENVIOCORREOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWENVIOCORREOALT`;
DELIMITER $$


CREATE PROCEDURE `CRWENVIOCORREOALT`(
	-- ENVIO DE CORREOS CRW EN CASO DE PLD
		Par_CreditoID			BIGINT(20),		-- Variable de credito id
		Par_NumProc				INT(11),		-- Indica el numero del proceso a ejecutar
		Par_Salida				CHAR(1),		-- Indica el tipo de Salida S.- Si N.- No

		INOUT Par_NumErr		INT(11),		-- Numero de Error
		INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

		Aud_EmpresaID			INT(11),		-- Auditoria
		Aud_Usuario				INT(11),		-- Auditoria
		Aud_FechaActual			DATETIME,		-- Auditoria

		Aud_DireccionIP			VARCHAR(15),	-- Auditoria
		Aud_ProgramaID			VARCHAR(50),	-- Auditoria
		Aud_Sucursal			INT(11),		-- Auditoria
		Aud_NumTransaccion		BIGINT(20)		-- Auditoria
)

TerminaStore:BEGIN
	
	-- Declaracion de Variables
	DECLARE Var_CorreoID			INT;			-- ID del correo
	DECLARE Par_Folio				INT;			-- Folio del correo
	DECLARE	Var_Asunto				VARCHAR(150);	-- Asunto del Correo
	DECLARE	Var_Fecha				DATETIME;		-- Fecha de Registro
	DECLARE Var_Correo				VARCHAR(50);		-- Variable correo
	DECLARE Var_NombreCompleto		VARCHAR(150);		-- nombre completo

	DECLARE	Var_ServidorCorreo		VARCHAR(30);	-- Servidor del correo
	DECLARE	Var_Puerto				VARCHAR(10);	-- Numero del Puerto del Servidor del Correo
	DECLARE	Var_UsuarioCorreo		VARCHAR(50);	-- Usuario de la Cuenta de Correo
	DECLARE	Var_Contrasenia			VARCHAR(20);	-- Password de la Cuenta de Correo
	DECLARE	Var_Remitente			VARCHAR(50);
	DECLARE Var_Control	    		VARCHAR(100);
	DECLARE Var_ProcDetecCre		VARCHAR(50);		-- Variable de proceso de deteccion pld de credito
	DECLARE Var_PlantillaCorre		VARCHAR(2000);		-- Plantilla del correo
	DECLARE Var_FechaDeteccion		DATE;				-- Fecha deteccion pld
	DECLARE Var_PrcesoEscID			VARCHAR(50);		-- clave del proceso que genero el escalamiento\nsegún catalogo de procesos de escalamiento
	DECLARE Var_Descripcion			VARCHAR(50);		-- Descripcion escalamiento interno pld


	-- Declaracion de Constantes
	DECLARE Con_Estatus				CHAR(1);		-- Estatus
	DECLARE Entero_Cero				INT(11);		-- Entero cero
	DECLARE Entero_Uno				INT(11);		-- Entero uno
	DECLARE Cadena_Vacia			CHAR(2);
	DECLARE Str_SI					CHAR(1);
	DECLARE SalidaNO				CHAR(1);		-- Salida no
	DECLARE Fecha_Vacia				DATETIME;
	DECLARE Con_mensaje				VARCHAR(150);

	-- Asignacion de variables
	SET Var_ProcDetecCre		:= 'CREDITO';											-- Asignacion de proceso de deteccion pld
	SET Var_Asunto				:= 'Solicitud de Gestión Escalamiento Interno.';		-- Asunto del correo default
	
	-- Asignacion de Constantes
	SET SalidaNO				:= 'N';					-- Salida no
	SET Con_Estatus 			:= 'N';					-- Estatus No Enviado
	SET Entero_Cero				:= 0;					-- Entero Cero
	SET Cadena_Vacia			:= '';					-- Cadena_ Vacia
	SET Str_SI					:= 'S';					-- String SI
	SET Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Uno				:= 1;				-- Entero uno
	SET Var_PlantillaCorre	:= CONCAT(
	'<TABLE BORDER="0" WIDTH="100%" CELLSPACING="1"  ALIGN="CENTER" VALIGN="CENTER" CELLPADDING="1" STYLE="font-family: arial,helvetica,tahoma,verdana;">',
		'<TR>',
			'<TD ALIGN="CENTER" BGCOLOR="04B431" STYLE="font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px; color: FFFFFF ;text-decoration: none;">',
				'Solicitud para Gesti&oacute;n de Escalamiento Interno',
			'</TD>',
		'</TR>',
		'<TABLE BORDER="0" WIDTH="100%" CELLSPACING="1"  ALIGN="CENTER" VALIGN="CENTER" CELLPADDING="1" STYLE="font-family: arial,helvetica,tahoma,verdana;">',
			'<TR>',
				'<TD BGCOLOR="0182C4" STYLE="font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px; color: FFFFFF ;text-decoration: none; white-space: nowrap;">No. Operaci&oacute;n</TD>',
				'<TD BGCOLOR="0182C4" STYLE="font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px; color: FFFFFF ;text-decoration: none;">No. Cliente</TD>',
				'<TD BGCOLOR="0182C4" STYLE="font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px; color: FFFFFF ;text-decoration: none;">Fecha</TD>',
				'<TD BGCOLOR="0182C4" STYLE="font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px; color: FFFFFF ;text-decoration: none;">Descripci&oacute;n</TD>',
			'</TR>',
			'<TR>',
				'<TD> %NumeroOperacion%</TD>',
				'<TD> %CteInv%</TD>',
				'<TD STYLE="white-space: nowrap;"> %Fecha%</TD>',
				'<TD> ',
					'Se requiere la Gesti&oacute;n de una Operaci&oacute;n en Gesti&oacute;n de Escalamiento Interno.',
					'<BR><b>Proceso:</b> %Proceso%.',
				'</TD>',
			'</TR>',
		'</TABLE>',
	'</TABLE>');


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWENVIOCORREOALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SELECT 	U.Correo, 		U.NombreCompleto
		INTO 	Var_Correo,		Var_NombreCompleto
		FROM USUARIOS U,
				PARAMETROSSIS P
		WHERE U.UsuarioID = P.OficialCumID;
		
		SELECT 	Remitente,			ServidorCorreo,			Puerto,			UsuarioCorreo,			Contrasenia
		INTO	Var_Remitente,		Var_ServidorCorreo,		Var_Puerto,		Var_UsuarioCorreo,		Var_Contrasenia
			FROM PARAMETROSSIS
			WHERE EmpresaID = Entero_Uno;
		
		-- Consulta de parametros para informacion del correo
		SELECT  ProcesoEscID, 			Cli.NombreCompleto,		DATE_FORMAT(FechaDeteccion, '%Y-%m-%d')
		INTO 	Var_PrcesoEscID,		Var_NombreCompleto,		Var_FechaDeteccion
		FROM PLDOPEESCALAINT Ope,
				CLIENTES Cli
		WHERE   OperProcesoID   = Par_CreditoID
			AND   ProcesoEscID    = Var_ProcDetecCre
			AND   Ope.ClienteID   = Cli.ClienteID;
		
		SELECT	ProcesoEscID, 		Descripcion
		INTO 	Var_PrcesoEscID,	Var_Descripcion
		FROM PROCESCALINTPLD
		WHERE ProcesoEscID = Var_PrcesoEscID;
		
		
		-- Sustituir datos de plantilla del correo
		SET Var_PlantillaCorre := REPLACE(Var_PlantillaCorre, '%NumeroOperacion%', IFNULL(Par_CreditoID, Entero_Cero));
		SET Var_PlantillaCorre := REPLACE(Var_PlantillaCorre, '%CteInv%', IFNULL(Var_NombreCompleto, Cadena_Vacia));
		SET Var_PlantillaCorre := REPLACE(Var_PlantillaCorre, '%Fecha%', IFNULL(Var_FechaDeteccion, Fecha_Vacia));
		SET Var_PlantillaCorre := REPLACE(Var_PlantillaCorre, '%Proceso%', IFNULL(Var_Descripcion, Cadena_Vacia));
		
		CALL ENVIOCORREOALT(
			Var_Remitente,		Var_Correo,				Var_PlantillaCorre,		Var_Asunto,										Fecha_Vacia,
			Var_ServidorCorreo,	Var_Puerto,				Var_UsuarioCorreo,		Var_Contrasenia,								SalidaNO,
			Par_NumErr,			Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,									Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
		);
			
		IF(Par_NumErr <> Entero_Cero) THEN
			SET Par_NumErr	:= 007;
			LEAVE ManejoErrores;
		END IF;
	END ManejoErrores;  -- END del Handler de Errores

	IF Par_Salida = Str_SI THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'correoID' AS control,
				Var_CorreoID AS consecutivo;
	END IF;
END TerminaStore$$

-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDALERTAINUSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDALERTAINUSPRO`;

DELIMITER $$
CREATE PROCEDURE `PLDALERTAINUSPRO`(
	/* STORE QUE REGISTRA EL CORREO POR DETECCION EN LISTAS NEGRAS O
	 * EN PERSONAS BLOQUEADAS (OPERACION INUSUAL */
	Par_OpeInusualID	BIGINT(20),		-- ID de la operacion inusual a enviar como alerta
	Par_Salida			CHAR(1),		-- Indica el tipo de Salida S.- Si N.- No
	INOUT Par_NumErr	INT(11),		-- Numero de Error
	INOUT Par_ErrMen	TEXT,			-- Mensaje de Error

	Par_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Persona				VARCHAR(200);
	DECLARE	Var_FechaDeteccion		DATE;
	DECLARE	Var_DesOperacion  		VARCHAR(500);

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
	DECLARE	Var_CuentaAhoIDOpeInu	BIGINT(12);
	DECLARE	Var_TipoPersonaSAFIDes	VARCHAR(50);
	DECLARE Var_CatMotivInuID		VARCHAR(15);	-- clave de motivo del registro de la operacion segun el Catalogo PLDCATMOTIVINU
	DECLARE	Var_TipoPersonaCteCta	VARCHAR(500);
    DECLARE Var_TipoListaID			VARCHAR(45);	-- ID del Catalogo de Tipos de Listas de PLD
    DECLARE	Var_NumeroID			BIGINT(12);


	-- Declaracion de Variables
	DECLARE	Con_Mensaje				VARCHAR(2000);
	DECLARE	Con_MensajeDes			VARCHAR(15000);
	DECLARE	Con_MensajeEnviar		VARCHAR(20000);
	DECLARE Var_RemitenteID			INT(11);

	-- Declaracion de Constantes
	DECLARE	Con_Asunto			VARCHAR(150);
	DECLARE	Entero_Cero			INT;
	DECLARE Cadena_Vacia		CHAR(1);
    DECLARE Separador			CHAR(20);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Str_SI				CHAR(1);
	DECLARE Str_No				CHAR(1);
	DECLARE ESCLIENTE			VARCHAR(3);
	DECLARE ESUSUARIO			VARCHAR(3);
	DECLARE ESAVAL				VARCHAR(3);
	DECLARE ESPROSPECTO			VARCHAR(3);
	DECLARE ESRELACIONADO		VARCHAR(3);
    DECLARE ESPROVEEDOR			VARCHAR(3);
    DECLARE ESOBLSOLI			VARCHAR(3);
    DECLARE ESNA				VARCHAR(3);
	DECLARE Var_ProcesoPld		VARCHAR(50);
	DECLARE MotivoAlertaAut		CHAR(4);
    DECLARE CatMotInuLisNeg		VARCHAR(15);	-- clave de motivo de Lista Negra
    DECLARE CatMotInuLisBloq	VARCHAR(15);	-- Clave de motivo de Lista de Personas Bloqueadas
    DECLARE CatMotPaises		VARCHAR(15);	-- Clave de motivo de Paraisos Fiscales o Paises que no prestan ayuda
	DECLARE	AsuntoPosOPeInusual	VARCHAR(150);	-- Asunto del Mensaje Posibles Operaciones Inusuales

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
    SET ESPROVEEDOR 		:= 'PRV';
    SET ESOBLSOLI			:= 'OBS';
	SET Var_ProcesoPld		:= 'PLD';
	SET MotivoAlertaAut 	:= 'SIS1';
    SET CatMotInuLisNeg		:= 'LISNEG';
    SET CatMotInuLisBloq	:= 'LISBLOQ';
    SET CatMotPaises		:= 'PAISES';
	SET AsuntoPosOPeInusual	:= 'ALERTAS POSIBLES OPS INUSUALES';-- Asunto del Mensaje Posibles Operaciones Inusuales

    SET Separador			:= ' ';
    SET ESNA				:= 'NA';

	SET Aud_FechaActual := NOW();

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-PLDALERTAINUSPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']');
		END;

		SET Par_OpeInusualID := IFNULL(Par_OpeInusualID, Entero_Cero);
	    -- Se obtienen los valores de la operacion inusual
		IF EXISTS( SELECT OpeInusualID FROM PLDOPEINUSUALES WHERE OpeInusualID = Par_OpeInusualID) THEN
			SELECT
			NomPersonaInv,		FechaDeteccion,			DesOperacion,		TipoPersonaSAFI,		ClavePersonaInv,
            CatMotivInuID, 		CuentaAhoID,			TipoListaID
			INTO
			Var_Persona,		Var_FechaDeteccion,		Var_DesOperacion,	Var_TipoPersonaSAFI,	Var_ClavePersonaInv,
            Var_CatMotivInuID, 	Var_CuentaAhoIDOpeInu,	Var_TipoListaID
				FROM PLDOPEINUSUALES
					WHERE OpeInusualID = Par_OpeInusualID;

			SET Var_TipoPersonaSAFIDes := IF(Var_TipoPersonaSAFI = ESCLIENTE,'Cliente',
											IF(Var_TipoPersonaSAFI = ESUSUARIO, 'Usuario de Servicios',
												IF(Var_TipoPersonaSAFI = ESAVAL,'Aval',
													IF(Var_TipoPersonaSAFI = ESPROSPECTO,'Prospecto',
														IF(Var_TipoPersonaSAFI = ESRELACIONADO,'Relacionado a la Cta.',
                                                        IF(Var_TipoPersonaSAFI = ESOBLSOLI,'Obligado Solidario',
                                                         IF(Var_TipoPersonaSAFI = ESPROVEEDOR,'Proveedor','N&uacute;mero')))))));

			SET Con_Mensaje 		:=CONCAT('<TABLE BORDER="0" WIDTH="100%" CELLSPACING="1"  ALIGN="CENTER" VALIGN="CENTER" CELLPADDING="1" STYLE="font-family: arial,helvetica,tahoma,verdana;">
								<TR><TD ALIGN="CENTER" BGCOLOR="FA5858" STYLE="font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;">
								URGENTE - Detecci&oacute;n de Operaci&oacute;n Inusual</TD>
								</TR><TABLE BORDER="0" WIDTH="100%" CELLSPACING="1"  ALIGN="CENTER" VALIGN="CENTER" CELLPADDING="1" STYLE="font-family: arial,helvetica,tahoma,verdana;">
								<TR><TD BGCOLOR="0182C4" STYLE="font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;">Folio</TD>
								<TD BGCOLOR="0182C4" STYLE="font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;">',Var_TipoPersonaSAFIDes,'</TD>
								<TD BGCOLOR="0182C4" STYLE="font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;">Fecha</TD>
								<TD BGCOLOR="0182C4" STYLE="font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;">Descripci&oacute;n
								</TD></TR>');

			SET Var_Persona						:=IFNULL(Var_Persona, Cadena_Vacia);
			SET Var_FechaDeteccion				:=IFNULL(Var_FechaDeteccion, Fecha_Vacia);
			SET Var_DesOperacion				:=IFNULL(Var_DesOperacion, Cadena_Vacia);
			SET Par_OpeInusualID				:=IFNULL(Par_OpeInusualID, Entero_Cero);

            IF(Var_CatMotivInuID = CatMotInuLisNeg) THEN

				IF(Var_TipoPersonaSAFI = ESCLIENTE) THEN
					SELECT
						CLI.ClienteID,		CLI.NombreCompleto,	ACT.Descripcion,	CLI.FechaAlta,	CTA.FechaDepInicial
					INTO
						Var_NumeroID,		Var_NombreCompleto,	Var_Descripcion,	Var_FechaAlta,	Var_FechaDepInicial
					FROM CLIENTES AS CLI
					LEFT JOIN CUENTASAHO AS CTA ON CLI.ClienteID = CTA.ClienteID AND FechaDepInicial != '1900-01-01'
					INNER JOIN ACTIVIDADESBMX AS ACT ON CLI.ActividadBancoMX = ACT.ActividadBMXID
					WHERE CLI.ClienteID = Var_ClavePersonaInv
					ORDER BY FechaDepInicial ASC
					LIMIT 1;
				END IF;

                IF(Var_TipoPersonaSAFI = ESPROSPECTO) THEN
					SELECT
						PRO.ProspectoID,	PRO.NombreCompleto,	Cadena_Vacia,		Fecha_Vacia,	Fecha_Vacia
					INTO
						Var_NumeroID,		Var_NombreCompleto,	Var_Descripcion,	Var_FechaAlta,		Var_FechaDepInicial

					FROM PROSPECTOS AS PRO
					WHERE PRO.ProspectoID = Var_ClavePersonaInv;
				END IF;

				IF(Var_TipoPersonaSAFI = ESUSUARIO) THEN
					SELECT
						USU.UsuarioServicioID,	USU.NombreCompleto,	Cadena_Vacia,		Fecha_Vacia,	Fecha_Vacia
					INTO
						Var_NumeroID,			Var_NombreCompleto,	Var_Descripcion,	Var_FechaAlta,		Var_FechaDepInicial

					FROM USUARIOSERVICIO AS USU
					WHERE USU.UsuarioServicioID = Var_ClavePersonaInv;
				END IF;

                IF(Var_TipoPersonaSAFI = ESAVAL) THEN
					SELECT
						AVA.AvalID,		AVA.NombreCompleto,	Cadena_Vacia,		Fecha_Vacia,	Fecha_Vacia
					INTO
						Var_NumeroID,	Var_NombreCompleto,	Var_Descripcion,	Var_FechaAlta,		Var_FechaDepInicial

					FROM AVALES AS AVA
					WHERE AVA.AvalID = Var_ClavePersonaInv;
				END IF;

				IF(Var_TipoPersonaSAFI = ESRELACIONADO) THEN
					SELECT
						PER.PersonaID,	PER.NombreCompleto,	ACT.Descripcion,	Fecha_Vacia,	CTA.FechaDepInicial
					INTO
						Var_NumeroID,	Var_NombreCompleto,	Var_Descripcion,	Var_FechaAlta,		Var_FechaDepInicial

					FROM CUENTASPERSONA AS PER
                    LEFT JOIN CUENTASAHO AS CTA ON PER.CuentaAhoID = CTA.CuentaAhoID AND CTA.FechaDepInicial != '1900-01-01'
                    INNER JOIN ACTIVIDADESBMX AS ACT ON PER.ActividadBancoMX = ACT.ActividadBMXID
					WHERE PER.PersonaID = Var_ClavePersonaInv AND PER.CuentaAhoID = Var_CuentaAhoIDOpeInu;

				END IF;


                IF(Var_TipoPersonaSAFI = ESPROVEEDOR) THEN
					SELECT
						PRO.ProveedorID,		CASE WHEN(IFNULL(PRO.TipoPersona,Cadena_Vacia) = 'M')
												THEN  RazonSocial
												ELSE CONCAT(SoloNombres, Separador ,SoloApellidos)
                                                END NombreCompleto,		Cadena_Vacia,		Fecha_Vacia,	Fecha_Vacia
					INTO
						Var_NumeroID,			Var_NombreCompleto,		Var_Descripcion,	Var_FechaAlta,		Var_FechaDepInicial

					FROM PROVEEDORES AS PRO
					WHERE PRO.ProveedorID = Var_ClavePersonaInv;
				END IF;

				IF(Var_TipoPersonaSAFI = ESOBLSOLI) THEN
					SELECT
						SOL.OblSolidID,	SOL.NombreCompleto,	Cadena_Vacia,		Fecha_Vacia,	Fecha_Vacia
					INTO
						Var_NumeroID,	Var_NombreCompleto,	Var_Descripcion,	Var_FechaAlta,		Var_FechaDepInicial

					FROM OBLIGADOSSOLIDARIOS AS SOL
					WHERE SOL.OblSolidID = Var_ClavePersonaInv;
				END IF;

                SET Var_NumeroID := IFNULL(Var_NumeroID, Entero_Cero);
                SET Var_TipoListaID := IFNULL(Var_TipoListaID, Cadena_Vacia);
				SET Var_NombreCompleto := IFNULL(Var_NombreCompleto, Cadena_Vacia);
				SET Var_Descripcion := IFNULL(Var_Descripcion, Cadena_Vacia);
				SET Var_FechaAlta := IFNULL(Var_FechaAlta, Fecha_Vacia);
				SET Var_FechaDepInicial := IFNULL(Var_FechaDepInicial, Fecha_Vacia);
				SET Var_CuentaAhoIDOpeInu := IFNULL(Var_CuentaAhoIDOpeInu, Entero_Cero);


				SET Var_DesOperacion := CONCAT(
						'<br><b>Coincidencia ListasNegras (',Var_TipoListaID,').</b>',
                        IF(Var_TipoPersonaSAFI != ESNA,
                        CONCAT('<br><b>',Var_TipoPersonaSAFIDes,': </b>',Var_NumeroID),
                        Cadena_Vacia),
						IF(Var_TipoPersonaSAFI != ESNA,
						CONCAT('<br><b>Nombre:</b> ',Var_NombreCompleto),
                        Cadena_Vacia),
                        IF(Var_TipoPersonaSAFI != ESNA,
                        CONCAT('<br><b>Actividad BMX:</b> ',Var_Descripcion),
                        Cadena_Vacia),
						IF(Var_TipoPersonaSAFI != ESNA,
						CONCAT('<br><b>Fecha de Afiliaci&oacute;n:</b> ',Var_FechaAlta),
                        Cadena_Vacia),
						IF(Var_TipoPersonaSAFI != ESNA,
						CONCAT('<br><b>Fecha de Inicio Trans:</b> ',Var_FechaDepInicial),
                        Cadena_Vacia)
						);
          ELSE

				IF(Var_TipoPersonaSAFI = ESCLIENTE) THEN
					SELECT
						CLI.ClienteID,		NombreCompleto,			ACT.Descripcion,		FechaAlta,		FechaDepInicial,
						CuentaAhoID
					INTO
						Var_ClienteID,		Var_NombreCompleto,		Var_Descripcion,		Var_FechaAlta,	Var_FechaDepInicial,
						Var_CuentaAhoID
					FROM CLIENTES AS CLI
					LEFT JOIN CUENTASAHO AS CTA ON CLI.ClienteID = CTA.ClienteID AND FechaDepInicial != '1900-01-01'
					INNER JOIN ACTIVIDADESBMX AS ACT ON CLI.ActividadBancoMX = ACT.ActividadBMXID
					WHERE CLI.ClienteID = Var_ClavePersonaInv
					ORDER BY FechaDepInicial ASC
					LIMIT 1;

						SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);
						SET Var_NombreCompleto := IFNULL(Var_NombreCompleto, Cadena_Vacia);
						SET Var_Descripcion := IFNULL(Var_Descripcion, Cadena_Vacia);
						SET Var_FechaAlta := IFNULL(Var_FechaAlta, Fecha_Vacia);
						SET Var_FechaDepInicial := IFNULL(Var_FechaDepInicial, Fecha_Vacia);
						SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);
						SET Var_CatMotivInuID := IFNULL(Var_CatMotivInuID, Cadena_Vacia);
						SET Var_CuentaAhoIDOpeInu := IFNULL(Var_CuentaAhoIDOpeInu, Entero_Cero);

					-- TIPO DE PERSONA
					SELECT	CONCAT(
							IF(Var_ClienteID != 0,'Cliente,',Cadena_Vacia),
							IF(CP.EsApoderado = 'S','Apoderado/Rep. Legal,',Cadena_Vacia),
							IF(CP.EsTitular = 'S','Accionista,',Cadena_Vacia),
							IF(CP.EsCotitular = 'S','Titular,',Cadena_Vacia),
							IF(CP.EsBeneficiario = 'S','Cotitular,',Cadena_Vacia),
							IF(CP.EsProvRecurso = 'S','Beneficiario,',Cadena_Vacia),
							IF(CP.EsPropReal = 'S','Proveedor de Recursos,',Cadena_Vacia),
							IF(CP.EsFirmante = 'S','Propietario Real,',Cadena_Vacia),
							IF(CP.EsAccionista = 'S','Firmante',Cadena_Vacia)
						)
						INTO Var_TipoPersonaCteCta
					FROM CUENTASPERSONA CP
					WHERE CP.CuentaAhoID = Var_CuentaAhoIDOpeInu
						AND CP.ClienteID = Var_ClienteID
						AND	CP.EstatusRelacion = 'V'
					LIMIT 1;
					SET Var_TipoPersonaCteCta := IFNULL(Var_TipoPersonaCteCta,Cadena_Vacia);

					SET Var_DesOperacion := CONCAT(
						IF(Var_CatMotivInuID = MotivoAlertaAut,
						'<br><b>Escenario fuera de perfil transaccional:</b>',
						'<br><b>Coincidencia en:</b>'),Var_DesOperacion,
						'<br><b>ClienteID:</b> ',Var_ClienteID,
						IF(Var_CatMotivInuID = MotivoAlertaAut,
						CONCAT('<br><b>Tipo de Persona:</b>',Var_TipoPersonaCteCta),
						Cadena_Vacia),
						'<br><b>Nombre:</b> ',Var_NombreCompleto,
						'<br><b>Actividad BMX:</b> ',Var_Descripcion,
						'<br><b>Fecha de Afiliaci&oacute;n:</b> ',Var_FechaAlta,
						'<br><b>Fecha de Inicio Trans:</b> ',Var_FechaDepInicial);
				END IF;

			END IF;

			SET Con_MensajeDes	:=CONCAT(Con_MensajeDes,'<TR><TD>',Par_OpeInusualID,'</TD><TD>',
											Var_Persona,'</TD><TD>',Var_FechaDeteccion,'</TD><TD>',
											Var_DesOperacion , '</TD></TR>');

			-- Se concluye el armado del cuerpo del mensaje de correo
			SET Con_MensajeEnviar:=CONCAT(Con_Mensaje,Con_MensajeDes,'</TABLE></TABLE>');

			-- Se obtiene la cuenta de correo del Oficial de Cumplimiento
			SELECT Correo  INTO Var_DestinatarioPLD
				FROM USUARIOS USU,
						PARAMETROSSIS PAR
					WHERE PAR.OficialCumID= USU.UsuarioID;

			-- Se obtienen los parametros de la cuenta de correo que realiza el envio del mismo
			SELECT PAR.Remitente, PAR.ServidorCorreo, PAR.Puerto, PAR.UsuarioCorreo, PAR.Contrasenia
			INTO Var_Remitente,Var_ServidorCorreo,  Var_Puerto, Var_UsuarioCorreo,Var_Contrasenia
				FROM USUARIOS USU,
						PARAMETROSSIS PAR
					WHERE PAR.OficialCumID= USU.UsuarioID;

			SELECT CAST(ValorParametro AS UNSIGNED)
				INTO Var_RemitenteID
				FROM PARAMGENERALES
				WHERE LlaveParametro =  'RemitentePld';

			SET Var_RemitenteID := IFNULL(Var_RemitenteID, Entero_Cero);

			-- SE VALIDA LA CLAVE DEL MOTIVO DE LA OPERACION INUSUAL
			IF(Var_CatMotivInuID NOT IN(CatMotInuLisNeg,CatMotInuLisBloq,CatMotPaises))THEN
				SET Con_Asunto := AsuntoPosOPeInusual;
            END IF;

			CALL TARENVIOCORREOALT(
					Var_RemitenteID,		Var_DestinatarioPLD,	Con_Asunto, 		Con_MensajeEnviar,		Entero_Cero,
					Aud_FechaActual,		Fecha_Vacia,			Var_ProcesoPld,		Cadena_Vacia,			Str_No,
					Par_NumErr, 			Par_ErrMen, 			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP, 		Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion);
		END IF;

	END ManejoErrores;
	-- End del Handler de Errores.

	IF Par_Salida = Str_SI THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'numero' AS Control,
				Par_OpeInusualID AS Consecutivo;
	END IF;

END TerminaStore$$
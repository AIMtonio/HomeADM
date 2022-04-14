-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------

# ===================================================================================================
# --------- SP CONSTRUCTOR DE ENVIO DE CORREOS DE CAJAS ABIERTAS Y TRANSFERENCIAS PENDIENTES---------
# --------- Confiadira-------------------------------------------------------------------------------
# ===================================================================================================

DELIMITER ;
DROP PROCEDURE IF EXISTS `VALIDACAJASPRO`;
DELIMITER $$

CREATE PROCEDURE `VALIDACAJASPRO`(

	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

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
	DECLARE Var_FechaSistema		DATETIME;
	DECLARE Var_CuerpoCorreo		TEXT;
	DECLARE Var_Contador			INT(11);
	DECLARE Var_TotalReg			INT(11);
	DECLARE EnvioCorreo				CHAR(1);

	-- Variables de cajas
	DECLARE Var_NombreUsuario		CHAR(100);
	DECLARE Var_CajaID				INT(11);
	DECLARE Var_Caja				INT(11);
	DECLARE Var_CajaOrigen			INT(11);
	DECLARE Var_CajaDestino			INT(11);
	DECLARE Var_Usuario				VARCHAR(100);
	DECLARE Var_TipoCaja			VARCHAR(50);
	DECLARE Var_EstatusCaja			VARCHAR(10);
	DECLARE Var_ClienteCajaCierre	VARCHAR(10);
	DECLARE Var_Control				VARCHAR(50);			-- Variable de Control
	DECLARE Fecha_Vacia				DATE;

	-- Envio de Correos
	DECLARE Var_RemitenteID			INT(11);
	DECLARE Var_CorreoDestino		VARCHAR(500);
	DECLARE Var_CorreoCC			VARCHAR(500);
	DECLARE Var_HorasEspera			INT(11);


		-- Declaracion de constantes
	DECLARE EstatusAlta			CHAR(1);		-- Estatus Alta de cajas
	DECLARE	EstatusActiva		CHAR(2);		-- Estatus Activa de Operaciones de  cajas
	DECLARE Entero_Uno			INT(11);		-- Entero 1;
	DECLARE Entero_Cero			INT(11);		-- Entero 1;
	DECLARE SalidaSI			CHAR(1);		-- Salida SI
	DECLARE SalidaNo			CHAR(1);		-- Salida NO
	DECLARE Cadena_Vacia		CHAR(1);		-- Salida NO
	DECLARE Asunto				VARCHAR(50);	-- Asunto del correo
	DECLARE ProcesoID			VARCHAR(50);
	DECLARE ConfiadoraID		INT(11);
	DECLARE	ActivaUsuarios		INT(11);

		-- Asignacion de Constantes
	SET SalidaSI					:= 'S';		-- Salida SI
	SET SalidaNO					:= 'N';		-- Salida NO
	SET Entero_Cero					:= 0;		-- Entero Cero
	SET Entero_Uno					:= 1;		-- Entero Uno
	SET Cadena_Vacia				:= '';		-- Caden Vacia
	SET EstatusAlta					:= 'A';		-- Estatus de la transferencia (Alta)
	SET EstatusActiva				:= 'A';		-- Estatus Activa
	SET Asunto						:= "VALIDACION DE CAJAS";
	SET ConfiadoraID				:= 46;
	SET ActivaUsuarios				:= 13;
	SET Fecha_Vacia					:= '1900-01-01';

	DROP TEMPORARY TABLE IF EXISTS TMPOPENCAJAS;
	CREATE TEMPORARY TABLE TMPOPENCAJAS(
		Consecutivo			INT(11) AUTO_INCREMENT,
		CajaID 				INT(11),
		NombreUsuario		VARCHAR(100),
		TipoCaja			VARCHAR(50),
		PRIMARY KEY (`Consecutivo`)
	);

	DROP TEMPORARY TABLE IF EXISTS TMPTRANSFER;
	CREATE TEMPORARY TABLE TMPTRANSFER(
		Consecutivo				INT(11) AUTO_INCREMENT,
		CajaOrigen 				INT(11),
		CajaDestino				INT(11),
		PRIMARY KEY (`Consecutivo`)
	);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
					SET Par_NumErr = 999;
					SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-VALIDACAJASPRO');
			END;

			-- Asignar variable de fecha de sistema
		SELECT FechaSistema INTO Var_FechaSistema
		FROM PARAMETROSSIS
		LIMIT 1;

		SET Var_FechaSistema := IFNULL (Var_FechaSistema, Fecha_Vacia);


		SELECT Intervalo
		INTO Var_HorasEspera
		FROM VALCAJASPARAMETROS
		LIMIT 1;

		SET Var_HorasEspera = IFNULL(Var_HorasEspera, Entero_Cero);



		SELECT ValorParametro
		INTO Var_ClienteCajaCierre
		FROM PARAMGENERALES
		WHERE LlaveParametro = 'PermiteValidaCajas';
			-- Envio Coreo NO
		SET EnvioCorreo := "N";
		SET Var_CuerpoCorreo := " <!DOCTYPE html> <html lang='es'>  <head> <meta charset='utf-8'> <style> table, th, td {  border-collapse: collapse;} th, td { padding: 5px; text-align: left;} </style> </head> <body>";
		SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, " <p> Estimados Todos<br />El proceso de validaci&oacute;n detect&oacute; lo siguiente: </p> ");
		-- Se valida que no exista una caja abierta en el sistema
		IF EXISTS(	SELECT CajaID FROM CAJASVENTANILLA WHERE Estatus = EstatusAlta AND EstatusOpera = EstatusActiva)THEN
			SET EnvioCorreo = "S";
			INSERT INTO TMPOPENCAJAS (CajaID,		NombreUsuario,		TipoCaja)
				SELECT Cj.CajaID, Us.NombreCompleto ,CASE  WHEN Cj.TipoCaja = "CP" THEN "Caja Principal" ELSE "Caja de Atenci&oacute;n al P&uacute;blico" END
				FROM CAJASVENTANILLA Cj
				INNER JOIN USUARIOS Us ON Cj.UsuarioID = Us.UsuarioID
				Where Cj.Estatus 	=	EstatusAlta
				AND Cj.EstatusOpera	=	EstatusActiva;
			SET Var_Contador 		:= 1;
			SELECT COUNT(*) INTO Var_TotalReg FROM TMPOPENCAJAS;
			SET Var_CuerpoCorreo	:= CONCAT(Var_CuerpoCorreo, " <table style='width:50%'> <tr style='border-bottom: 1.5px solid black'> <th colspan='2'>Cajas Abiertas</th>  </tr>");
			armaTabla: WHILE Var_Contador <= Var_TotalReg DO

				SELECT	Tmp.NombreUsuario,		Tmp.CajaID, 	Tmp.TipoCaja
				INTO 	Var_NombreUsuario,		Var_CajaID,		Var_TipoCaja
				FROM	TMPOPENCAJAS Tmp
				WHERE	Tmp.Consecutivo = Var_Contador;

				SET Var_NombreUsuario	:= IFNULL(Var_NombreUsuario, Cadena_Vacia);
				SET Var_CajaID			:= IFNULL(Var_CajaID, Entero_Cero);
				SET Var_TipoCaja		:= IFNULL(Var_TipoCaja, Cadena_Vacia);

				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr><td>Nombre de Usuario:</td> ", " <td> ",Var_NombreUsuario, "</td></tr><tr>");
				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, " <td>N&uacute;mero de Caja:</td> ", " <td> ",Var_CajaID, "</td></tr><tr>");
				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, " <td>Tipo de Caja:</td> ", " <td> ",Var_TipoCaja, "</td></tr>");
				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr><td></td></tr>");

				SET Var_Contador := Var_Contador + Entero_Uno;
			END WHILE armaTabla;
		END IF;

		SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "	</table>");


		IF EXISTS( SELECT CajaDestino FROM CAJASTRANSFER CT WHERE  CT.Estatus  = EstatusAlta AND CT.Fecha = Var_FechaSistema)THEN
			SET EnvioCorreo = "S";
			INSERT INTO TMPTRANSFER (CajaOrigen, CajaDestino)
				SELECT 	Ct.CajaOrigen, Ct.CajaDestino
				FROM 	CAJASTRANSFER Ct
				WHERE 	Ct.Estatus 	= EstatusAlta
				AND 	Ct.Fecha	= Var_FechaSistema;

			SET Var_Contador 		:= 1;
			SELECT COUNT(*) INTO Var_TotalReg FROM TMPTRANSFER;
			SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "	<br><br><table style='width:50%'> <tr style='border-bottom: 1.5px solid black'>
																<th colspan='2'>Transferencias Pendientes</th> </tr>");

			armaTabla2: WHILE Var_Contador <= Var_TotalReg DO
				SELECT 	Tmp.CajaOrigen,	Tmp.CajaDestino
				INTO	Var_CajaOrigen,	Var_CajaDestino
				FROM TMPTRANSFER Tmp
				Where Tmp.Consecutivo = Var_Contador;

				SELECT 	CASE  WHEN Cj.EstatusOpera = "C" THEN "Cerrada" ELSE "Abierta" END,	CASE  WHEN Cj.TipoCaja = "CP" THEN "Caja Principal" ELSE "Caja de Atenci&oacute;n al P&uacute;blico" END, Us.NombreCompleto
				INTO	Var_EstatusCaja,	Var_TipoCaja, Var_Usuario
				FROM CAJASVENTANILLA Cj
				INNER JOIN USUARIOS Us ON Cj.UsuarioID = Us.UsuarioID
				Where Cj.CajaID	=	Var_CajaOrigen
				LIMIT Entero_Uno;

				SET Var_Usuario 	:= IFNULL(Var_Usuario, Cadena_Vacia);
				SET Var_CajaOrigen 	:= IFNULL(Var_CajaOrigen, Entero_Cero);
				SET Var_TipoCaja 	:= IFNULL(Var_TipoCaja, Cadena_Vacia);
				SET Var_EstatusCaja := IFNULL (Var_EstatusCaja, Cadena_Vacia);

				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr><td>Usuario Origen:</td> ", " <td> ",Var_Usuario, "</td></tr><tr>");
				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr><td>Caja Origen:</td> ", " <td> ",Var_CajaOrigen, "</td></tr><tr>");
				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr><td>Tipo Caja Origen:</td> ", " <td> ",Var_TipoCaja, "</td></tr><tr>");
				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr><td>Estatus Caja Origen:</td> ", " <td> ",Var_EstatusCaja, "</td></tr><tr>");

				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr><td></td></tr>");

				SELECT 	CASE  WHEN Cj.EstatusOpera = "C" THEN "Cerrada" ELSE "Abierta" END,	CASE  WHEN Cj.TipoCaja = "CP" THEN "Caja Principal" ELSE "Caja de Atenci&oacute;n al P&uacute;blico" END, Us.NombreCompleto
				INTO	Var_EstatusCaja,	Var_TipoCaja, Var_Usuario
				FROM CAJASVENTANILLA Cj
				INNER JOIN USUARIOS Us ON Cj.UsuarioID = Us.UsuarioID
				Where Cj.CajaID	=	Var_CajaDestino
				LIMIT Entero_Uno;

				SET Var_Usuario 		:= IFNULL(Var_Usuario, Cadena_Vacia);
				SET Var_CajaDestino 	:= IFNULL(Var_CajaDestino, Entero_Cero);
				SET Var_TipoCaja 		:= IFNULL(Var_TipoCaja, Cadena_Vacia);
				SET Var_EstatusCaja 	:= IFNULL (Var_EstatusCaja, Cadena_Vacia);

				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr><td>Usuario Destino:</td> ", " <td> ",Var_Usuario, "</td></tr><tr>");
				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr><td>Caja Destino:</td> ", " <td> ",Var_CajaDestino, "</td></tr><tr>");
				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr><td>Tipo Caja Destino:</td> ", " <td> ",Var_TipoCaja, "</td></tr><tr>");
				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr><td>Estatus Caja Destino:</td> ", " <td> ",Var_EstatusCaja, "</td></tr><tr>");
				SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<tr style='border-bottom: 1.5px solid black'><td></td><td></td></tr>");
				SET Var_Contador := Var_Contador + Entero_Uno;
			END WHILE armaTabla2;
			SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "</table>");
		END IF;

		SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<p>El proceso de validaci&oacute;n volver&aacute; a ejecutarse en ", Var_HorasEspera ," hora, por lo que se solicita que se hagan los procesos correspondientes para tener la posibilidad de hacer el cierre de d&iacute;a.</p>");
		SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "<p>Gracias por su atenci&oacute;n.</p>");
		SET Var_CuerpoCorreo := CONCAT(Var_CuerpoCorreo, "</body></html>");

		IF(EnvioCorreo = "S") THEN
			-- Select email destinatarios
			SELECT GROUP_CONCAT(Us.Correo SEPARATOR ', ')
			INTO Var_CorreoDestino
			FROM VALCAJASDESTINATARIOS Des
			INNER JOIN USUARIOS Us On Des.UsuarioID = Us.UsuarioID
			Where Des.Tipo = "D"
			GROUP BY Des.Tipo;
			SET Var_CorreoDestino  := IFNULL(Var_CorreoDestino, Cadena_Vacia);

			-- Select email cc
			SELECT GROUP_CONCAT(Us.Correo SEPARATOR ', ')
			INTO Var_CorreoCC
			FROM VALCAJASDESTINATARIOS Des
			INNER JOIN USUARIOS Us On Des.UsuarioID = Us.UsuarioID
			Where Des.Tipo = "C"
			GROUP BY Des.Tipo;
			SET Var_CorreoCC  := IFNULL(Var_CorreoCC, Cadena_Vacia);

			SELECT RemitenteID
			INTO Var_RemitenteID
			From VALCAJASPARAMETROS
			LIMIT Entero_Uno;
			SET Var_RemitenteID  := IFNULL(Var_RemitenteID, Entero_Cero);

			IF (Var_CorreoDestino <> Cadena_Vacia AND Var_RemitenteID > 0) THEN
					CALL TARENVIOCORREOALT ( 	Var_RemitenteID,	Var_CorreoDestino,	Asunto,			Var_CuerpoCorreo,	Entero_Cero,
												Var_FechaSistema,	Var_FechaSistema,	Aud_ProgramaID,	Var_CorreoCC,		SalidaNO,
												Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
												Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

			END IF;

			SET Par_NumErr 	:= 0;
			SET Par_ErrMen 	:= "Se enviará un correo";
			SET Var_Control := "";
			LEAVE ManejoErrores;

		ELSE
			-- Reactiva Usuarios
			IF(Var_ClienteCajaCierre = ConfiadoraID) THEN
				CALL USUARIOSACT(	Entero_Cero,    Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,       Fecha_Vacia,
									Cadena_Vacia,   Fecha_Vacia,        Cadena_Vacia,       Entero_Cero,        Cadena_Vacia,
									Fecha_Vacia,    ActivaUsuarios,     SalidaNO,           Par_NumErr,         Par_ErrMen,
									Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
									Aud_Sucursal,   Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Par_NumErr := 0;
			SET Par_ErrMen := "No hay un correo que enviar";
			SET Var_Control := "ValidaCajasPro";
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) then
		SELECT  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control	AS control;
	END IF;

END TerminaStore$$
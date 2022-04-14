-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSCON`;
DELIMITER $$


CREATE PROCEDURE `USUARIOSCON`(
# ==============================================
# ------- STORE PARA CONSULTAR USUARIOS---------
# ==============================================
	Par_NumUsuario	 	CHAR(16),			-- ID del usuario
	Par_Clave			VARCHAR(45),		-- Clave del usuario
	Par_Contrasenia		VARCHAR(45),		-- Contrasenia del usuario
	Par_NombreCom		VARCHAR(150),		-- Nombre completo del usuario
	Par_SucursalUsuario	INT(11),			-- ID de la sucursal del usuario

	Par_NumCon			TINYINT UNSIGNED,	-- Numero de consulta

	Par_EmpresaID      	INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario        	INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual    	DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP    	VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID     	VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal       	INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion 	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE	EsGestorSI				CHAR(1);
	DECLARE	EsSupervisorSI			CHAR(1);
	DECLARE	Con_Principal			INT;
	DECLARE	Con_Foranea				INT;
	DECLARE	Con_Clave				INT;
	DECLARE	Con_BloqDesbloq			INT;
	DECLARE	Con_Cancelacion			INT;
	DECLARE	Con_LimpiaSes			INT;
	DECLARE	Con_Contrasenia			INT;
	DECLARE	Con_WS					INT;
	DECLARE	Con_UsuPorNom			INT;
	DECLARE	Con_UsuGestor			INT;
	DECLARE	ContraActual			VARCHAR(45);
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE EstatusVigente  		CHAR(1);
	DECLARE	Var_UsuarioID			INT;
	DECLARE Con_SMSAPValidaUserWS	INT;
	DECLARE Con_PDAValidaUserWS 	INT;
	DECLARE Con_UsuSupervisor 		INT;
	DECLARE Con_Rol			  		INT;
	DECLARE Con_ValidaUserWS        INT;
	DECLARE Con_ValidaLogueo		INT;
	DECLARE Con_ClaveLogueo			INT;	-- Consulta para devolver la información del usuario por medio de la clave
	DECLARE Con_AuditoriaWS			INT;
	DECLARE Con_UsuarioAnalista	    INT;	-- Consulta para devolver la informacion del usuario analista de credito en caso de ser uno
	DECLARE Con_UsuarioAnalistaVirtual INT; -- Consulta para analista virtual
	DECLARE AnalistaVirtual        VARCHAR(45); -- Analista Virtual
	DECLARE Con_RolCoordinador		INT(11);			-- Rol de coordinador
	DECLARE Var_LlaveRolCoordinador	VARCHAR(100);		-- Llave para consultar el valor del rol coordinador
	DECLARE Var_RolCoordinador		INT(11);			-- Variable para almacenar el rol coordinador



	DECLARE CodigoResp				INT(11);
	DECLARE CodigoDesc				VARCHAR(40);
	DECLARE EsValido				CHAR(5);
	DECLARE Var_Estatus				CHAR(1);
	DECLARE Var_SucursalID			INT(11);
	DECLARE Var_IMEI				VARCHAR(32);
	DECLARE Var_UsaAplicacion 		CHAR(1);     	-- Indica si usa aplicacion movil o no
	DECLARE Var_Contrasenia			VARCHAR(45); 	-- Contrasenia del usuario
	DECLARE Var_LoginsFallidos		VARCHAR(45); 	-- Logins fallidos del usuario
	DECLARE Var_NomComp				VARCHAR(50); 	-- Nombre Completo del usuario
	DECLARE Var_ClavePuestoID		VARCHAR(10);		-- Clave Puesto del usuario
	DECLARE Var_SucUsuario			INT(11);		-- Sucursal usuario
	DECLARE Var_tipoAnalista	    CHAR(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';		-- Constante Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Constante Fecha Vacia
	SET	Entero_Cero				:= 0;		-- Constante Entero Cero
	SET Estatus_Activo			:= 'A';		-- Estatus Activo
	SET EstatusVigente  		:= 'V';		-- Estatus Vigente
	SET EsGestorSI	 			:= 'S';		-- Si es Gestor
	SET EsSupervisorSI			:= 'S';		-- Si es Supervidor
	SET Var_tipoAnalista        := 'A';     -- Variable tipo analista
	SET	Con_Principal			:= 1;		-- Consulta Principal de Usuarios
	SET	Con_Foranea				:= 2;		-- Consulta Foranea de Usuarios
	SET	Con_Clave				:= 3;		-- Consulta de Usuarios por clave
	SET	Con_BloqDesbloq			:= 4;		-- Consulta de Usuarios en pantalla de Bloqueo/Desbloqueo de usuarios
	SET	Con_Cancelacion			:= 5;		-- Consulta de Usuarios en pantalla de Cancelacion de Usuarios
	SET Con_Contrasenia			:= 6;		-- Consulta de Usuarios contrasena
	SET Con_WS					:= 7;		-- Consulta de Usuarios WS
	SET Con_UsuPorNom			:= 8; 		-- Consulta usuario por nombre (envio de correo al Oficial de Cumplimiento)
	SET Con_LimpiaSes  			:= 9; 		-- Consulta de Usuarios en pantalla Limpiar Sesion de Usuario
	SET Con_SMSAPValidaUserWS 	:= 10;		-- Consulta de validacion de usuarios en Aplicacion SMS WS
	SET Con_PDAValidaUserWS 	:= 11;		-- Consulta de validacion de usuarios via WS
	SET Con_UsuGestor    		:= 12;  	-- Consulta de Usuarios que sean Gestor
	SET Con_UsuSupervisor		:= 13;  	-- Consulta de Usuarios que sean Supervisor
	SET Con_Rol             	:= 14; 		-- consulta los usuarios y su rol
	SET Con_ValidaUserWS        := 15; 		-- consulta valida un usuario desde ws
	SET Con_ValidaLogueo		:= 16;		-- Consulta valida las credenciales de un usario sean correctas desde movil
	SET Con_ClaveLogueo			:= 17;		-- Consulta que trae las claves del cliente con la clave
	SET Con_AuditoriaWS			:= 18;		-- Consulta que los Parametros de Auditoria con un Usuario
	SET Con_UsuarioAnalista		:= 20;		-- Consulta de usuarios tipo analistas
    SET Con_UsuarioAnalistaVirtual :=19;    -- Consulta de usuarios analistas / virtual
	SET Con_RolCoordinador			:= 21;	-- Consulta el rol de coordinador
	SET AnalistaVirtual        :='ANALISTA VIRTUAL';
	SET Var_LlaveRolCoordinador	:= 'RolCoordinador';	-- Llave rol coordinador

	IF(Par_NumCon = Con_Principal) THEN
		SELECT	`UsuarioID`, 			`ClavePuestoID`,	`Nombre`,  				`ApPaterno`,			`ApMaterno`,
				`Clave`, 				`Contrasenia`,		`Correo`,				`SucursalUsuario`,		`RolID`,
				`IPsesion`,				`FechUltimAcces`,	`FechUltPass`,			`Estatus`, 				`NombreCompleto`,
				`RealizaConsultasCC`,	`UsuarioCirculo`,	`ContrasenaCirculo`,	RealizaConsultasBC,		UsuarioBuroCredito,
				ContrasenaBuroCredito,	`AccesoMonitor`,	`FechaAlta`,			Notificacion, 			`AccederAutorizar`,
				`RFC`,					`CURP`,				`DireccionCompleta`,	`FolioIdentificacion`,	`FechaExpedicion`,
                `FechaVencimiento`,		`EmpleadoID`, `UsaAplicacion`, `IMEI`, `NotificaCierre` 
			FROM USUARIOS
			WHERE	UsuarioID = Par_NumUsuario;
	END IF;

	IF(Par_NumCon = Con_Foranea) THEN
		SELECT	`UsuarioID`,	`NombreCompleto`
			FROM USUARIOS
			WHERE 	UsuarioID = Par_NumUsuario;
	END IF;

	IF(Par_NumCon = Con_Clave) THEN
		SELECT	UsuarioID,	NombreCompleto,	Clave,			Contrasenia,	Rol.Descripcion,
				Estatus,	LoginsFallidos,	EstatusSesion,	IPsesion,		Clave AS Semilla,
                AccedeHuella, 	AccederAutorizar
			FROM USUARIOS Usu,
				ROLES Rol
			WHERE	Usu.Clave = Par_Clave
			  AND	Usu.RolId = Rol.RolID;
	END IF;

	IF(Par_NumCon = Con_BloqDesbloq) THEN
		SELECT	`UsuarioID`, 	`NombreCompleto`,	`Clave`, 	`FechUltimAcces`,`FechUltPass`,
				`Estatus`,		`MotivoBloqueo`,	CONVERT(`FechaBloqueo`,CHAR)
			FROM USUARIOS
			WHERE	UsuarioID = Par_NumUsuario;
	END IF;

	IF(Par_NumCon = Con_Cancelacion) THEN
		SELECT	`UsuarioID`, 	`NombreCompleto`,	`Clave`, 	`FechUltimAcces`,`FechUltPass`,
				`Estatus`,
				IFNULL(`MotivoCancel`,Cadena_Vacia) AS `MotivoCancel`,
				IFNULL(`FechaCancel`,Fecha_Vacia) AS `FechaCancel`,
				IFNULL(`UsuarioIDCancel`,Cadena_Vacia) AS `UsuarioIDCancel`,
				IFNULL(`MotivoReactiva`,Cadena_Vacia) AS `MotivoReactiva`,
				CASE WHEN `FechaReactiva` = Fecha_Vacia THEN Cadena_Vacia ELSE IFNULL(`FechaReactiva`,Cadena_Vacia) END AS `FechaReactiva`,
				IFNULL(`UsuarioIDReactiva`,Cadena_Vacia) AS `UsuarioIDReactiva`
			FROM USUARIOS
			WHERE	UsuarioID = Par_NumUsuario;
	END IF;

	IF(Par_NumCon = Con_LimpiaSes) THEN
		SELECT	`UsuarioID`, 	`NombreCompleto`,	`Clave`, 	`FechUltimAcces`,`FechUltPass`,
				`Estatus`,		`EstatusSesion`
			FROM USUARIOS
			WHERE	UsuarioID = Par_NumUsuario;
	END IF;

	IF(Par_NumCon = Con_Contrasenia) THEN
		SET ContraActual:= (SELECT	Contrasenia FROM USUARIOS WHERE UsuarioID = Par_NumUsuario);
		IF(Par_Contrasenia <> ContraActual) THEN
		   SELECT 'La Contrasenia Actual es incorrecta:' AS contrasenia ;
		END IF;
		IF(Par_Contrasenia = ContraActual) THEN
			 SELECT Par_Contrasenia;
		END IF;
	END IF;

	IF(Par_NumCon = Con_WS) THEN
		SELECT	U.SucursalUsuario,	U.IPsesion,	U.EmpresaID, P.FechaSistema
			FROM USUARIOS U,
				PARAMETROSSIS P
			WHERE	U.UsuarioID = Par_NumUsuario;
	END IF;

	# Consulta No 8: usada para el envio de correo al Oficial de Cumplimiento MODULO DE PLD
	IF(Par_NumCon = Con_UsuPorNom) THEN
		SELECT	U.Correo, U.NombreCompleto
			FROM USUARIOS U,
				PARAMETROSSIS P
			WHERE	U.UsuarioID = P.OficialCumID;
	END IF;

	IF(Par_NumCon = Con_SMSAPValidaUserWS) THEN
		SELECT	Usu.UsuarioID,	Usu.Estatus
		  INTO	Var_UsuarioID, Var_Estatus
			FROM USUARIOS Usu,
				PARAMETROSCAJA Par,
				CAJASVENTANILLA Caj
			WHERE	Clave 			= Par_Clave
			  AND	Contrasenia 	= Par_Contrasenia
			  AND	Usu.RolID 		= Par.EjecutivoFR
			  AND	Usu.UsuarioID 	= Caj.UsuarioID
			  AND	Caj.Estatus 	= Estatus_Activo
			LIMIT 1;


		IF(IFNULL(Var_UsuarioID,Entero_Cero) != Entero_Cero) THEN
				IF(Var_Estatus = Estatus_Activo) THEN
					SET CodigoResp 	:= 1;
					SET CodigoDesc	:= 'Usuario Valido';
					SET EsValido	:= 'TRUE';
				ELSE
					SET CodigoResp 	:= 2;
					SET CodigoDesc	:= 'Cuenta Bloqueada';
					SET EsValido	:= 'FALSE';
				END IF;

		ELSE
				SET CodigoResp 	:= 0;
				SET CodigoDesc	:= 'Usuario y/o contrasenia incorrecto';
				SET EsValido	:= 'FALSE';

		END IF;

		SELECT IFNULL(Var_UsuarioID,Entero_Cero) AS UsuarioID,CodigoResp, CodigoDesc,	EsValido;
	END IF;

	IF(Par_NumCon = Con_PDAValidaUserWS) THEN
		SELECT 	Usu.UsuarioID, Usu.Estatus, SucursalUsuario
		  INTO 	Var_UsuarioID, Var_Estatus, Var_SucursalID
			FROM USUARIOS Usu,
				PARAMETROSCAJA Par,
				CAJASVENTANILLA Caj
			WHERE Clave 		= Par_Clave
			  AND Contrasenia 	= Par_Contrasenia
			  AND Usu.RolID 	= Par.EjecutivoFR
			  AND Usu.UsuarioID = Caj.UsuarioID
			  AND Caj.Estatus 	= Estatus_Activo
			LIMIT 1;


		IF(IFNULL(Var_UsuarioID,Entero_Cero) != Entero_Cero) THEN
			IF(Var_Estatus = Estatus_Activo) THEN
				IF(Var_SucursalID = Par_SucursalUsuario)THEN
					SET CodigoResp 	:= 1;
					SET CodigoDesc	:= 'Usuario Valido';
					SET EsValido	:= 'TRUE';
				ELSE
					SET CodigoResp 	:= 3;
					SET CodigoDesc	:= 'Usuario No tiene acceso a la Sucursal';
					SET EsValido	:= 'FALSE';
				END IF;
			ELSE
				SET CodigoResp 	:= 3;
				SET CodigoDesc	:= 'Usuario No tiene acceso a la Sucursal';
				SET EsValido	:= 'FALSE';
			END IF;
		ELSE
			SET CodigoResp 	:= 2;
			SET CodigoDesc	:= 'Usuario y/o contrasenia incorrecto';
			SET EsValido	:= 'FALSE';

		END IF;

		SELECT IFNULL(Var_UsuarioID,Entero_Cero) AS UsuarioID,CodigoResp, CodigoDesc,	EsValido;
	END IF;
	-- Consulta de Usuarios que sean Gestor
	IF(Par_NumCon = Con_UsuGestor) THEN
		SELECT	Usu.UsuarioID,	Usu.NombreCompleto
			FROM USUARIOS Usu
				INNER JOIN PUESTOS Pto ON Usu.ClavePuestoID = Pto.ClavePuestoID
			WHERE 	Pto.EsGestor 	= EsGestorSI
			  AND	Usu.UsuarioID 	= Par_NumUsuario;
	END IF;

	-- Consulta de Usuarios que sean Supervisor
	IF(Par_NumCon = Con_UsuSupervisor) THEN
		SELECT 	Usu.UsuarioID, Usu.NombreCompleto
			FROM USUARIOS Usu
				INNER JOIN PUESTOS Pto ON Usu.ClavePuestoID = Pto.ClavePuestoID
			WHERE 	Pto.EsSupervisor = EsSupervisorSI
			  AND	Usu.UsuarioID = Par_NumUsuario;
	END IF;

	-- consulta roles y usuarios
	IF(Par_NumCon = Con_Rol) THEN
		SELECT	U.UsuarioID,	U.NombreCompleto,	R.NombreRol, 	U.RolID
			FROM USUARIOS U
				INNER JOIN ROLES R ON U.RolID = R.RolID
			WHERE	U.UsuarioID = Par_NumUsuario;
	END IF;

	IF(Par_NumCon = Con_ValidaUserWS) THEN
		SELECT	Usu.UsuarioID, Usu.Estatus
		  INTO	Var_UsuarioID, Var_Estatus
			FROM USUARIOS Usu
			WHERE Clave 		= Par_Clave
			  AND Contrasenia 	= Par_Contrasenia
			LIMIT 1;

		IF(IFNULL(Var_UsuarioID,Entero_Cero) != Entero_Cero) THEN
			IF(Var_Estatus = Estatus_Activo) THEN
				SET CodigoResp 	:= 0;
				SET CodigoDesc	:= 'Usuario Valido';
				SET EsValido	:= 'TRUE';
			ELSE
				SET CodigoResp 	:= 2;
				SET CodigoDesc	:= 'Cuenta Bloqueada';
				SET EsValido	:= 'FALSE';
			END IF;

		ELSE
			SET CodigoResp 	:= 1;
			SET CodigoDesc	:= 'Usuario y/o contrasenia incorrecto';
			SET EsValido	:= 'FALSE';

		END IF;

		SELECT IFNULL(Var_UsuarioID,Entero_Cero) AS UsuarioID,CodigoResp, CodigoDesc,	EsValido;

	END IF;

	-- Consulta para login de la aplicacion movil
	IF(Par_NumCon = Con_ValidaLogueo) THEN
		SELECT		Usu.UsuarioID, 		Usu.Estatus, 		Usu.IMEI, 		UsaAplicacion
            INTO	Var_UsuarioID, 		Var_Estatus, 		Var_IMEI, 		Var_UsaAplicacion
			FROM USUARIOS Usu WHERE
				Clave = Par_Clave AND
				Contrasenia = Par_Contrasenia
                LIMIT 1;

			IF(IFNULL(Var_UsuarioID,Entero_Cero) != Entero_Cero) THEN
				IF(Var_Estatus = Estatus_Activo) THEN
					SET CodigoResp 	:= 0;
					SET CodigoDesc	:= 'Usuario Valido';
					SET EsValido	:= 'TRUE';
				ELSE
					SET CodigoResp 	:= 3;
					SET CodigoDesc	:= 'Cuenta Bloqueada';
					SET EsValido	:= 'FALSE';
				END IF;
			ELSE
				SET CodigoResp 	:= 2;
				SET CodigoDesc	:= 'Credenciales no validas';
				SET EsValido	:= 'FALSE';

			END IF;

		SELECT IFNULL(Var_UsuarioID,Entero_Cero) AS UsuarioID, CodigoResp, CodigoDesc,	EsValido, IFNULL(Var_IMEI,Cadena_Vacia) AS IMEI, IFNULL(Var_UsaAplicacion, Cadena_Vacia) AS UsaAplicacion;

	END IF;

	-- Consulta para login de la aplicacion movil solo con clave
	IF(Par_NumCon = Con_ClaveLogueo) THEN
		SELECT		Usu.UsuarioID, 		Usu.Estatus, 		Usu.IMEI, 		UsaAplicacion,		LoginsFallidos,
					Contrasenia, 		NombreCompleto,		ClavePuestoID,	SucursalUsuario
            INTO	Var_UsuarioID, 		Var_Estatus, 		Var_IMEI, 		Var_UsaAplicacion,	Var_LoginsFallidos,
					Var_Contrasenia,	Var_NomComp,		Var_ClavePuestoID,	Var_SucUsuario
			FROM USUARIOS Usu WHERE
				Clave = Par_Clave
                LIMIT 1;

			IF(IFNULL(Var_UsuarioID,Entero_Cero) != Entero_Cero) THEN
				IF(Var_Estatus = Estatus_Activo) THEN
					SET CodigoResp 	:= 0;
					SET CodigoDesc	:= 'Usuario Valido';
					SET EsValido	:= 'TRUE';
				ELSE
					SET CodigoResp 	:= 3;
					SET CodigoDesc	:= 'Cuenta Bloqueada';
					SET EsValido	:= 'FALSE';
				END IF;
			ELSE
				SET CodigoResp 	:= 2;
				SET CodigoDesc	:= 'Credenciales no validas';
				SET EsValido	:= 'FALSE';

			END IF;

		SELECT IFNULL(Var_UsuarioID,Entero_Cero) AS UsuarioID, CodigoResp, CodigoDesc,	EsValido, IFNULL(Var_IMEI,Cadena_Vacia) AS IMEI, IFNULL(Var_UsaAplicacion, Cadena_Vacia) AS UsaAplicacion,
					Var_LoginsFallidos AS LoginsFallidos, Var_Contrasenia AS Contrasenia, Var_Estatus AS Estatus, Var_NomComp AS NombreCompleto, Var_ClavePuestoID AS ClavePuestoID, Var_SucUsuario AS SucursalUsuario;

	END IF;

	IF(Par_NumCon = Con_AuditoriaWS)THEN
		SET Var_UsuarioID := (SELECT UsuarioID FROM USUARIOS WHERE UsuarioID = Par_NumUsuario);
		SET Var_UsuarioID := IFNULL(Var_UsuarioID, Entero_Cero);

		IF(Var_UsuarioID = Entero_Cero) THEN
			SELECT	DefUsuarioID AS UsuarioID, DefEmpresaID AS SucursalUsuario,	DefSucursalID AS EmpresaID
				FROM WSAUDITORIADEFAULT U LIMIT 1;

		ELSE
			SELECT	U.UsuarioID, U.SucursalUsuario,	U.EmpresaID
				FROM USUARIOS U
				WHERE	U.UsuarioID = Par_NumUsuario;
		END IF;
	END IF;

    -- Consulta para extraer la informacion de los usuarios que pertenezcan a un perfil de tipo analista
	IF(Par_NumCon=Con_UsuarioAnalista)THEN
	  SELECT       Usu.UsuarioID,             Usu.EstatusAnalisis,         Usu.NombreCompleto,Usu.Clave
	      FROM     USUARIOS Usu     INNER JOIN     PERFILESANALISTAS  AS Per ON Usu.RolID=Per.RolID
	      WHERE    Usu.UsuarioID  =  Par_NumUsuario
		    AND    Per.TipoPerfil =  Var_tipoAnalista;
	END IF;

	    -- Consulta para extraer la informacion de los usuarios que pertenezcan a un perfil de tipo analista
	IF(Par_NumCon=Con_UsuarioAnalistaVirtual)THEN
		SELECT
			Sol.SolicitudCreditoID, Usu.UsuarioID,  Sol.ProductoID,Pro.Descripcion AS DescripcionProd ,Cli.ClienteID, Cli.NombreCompleto AS NombreCompletoCli,IFNULL(Usu.NombreCompleto,AnalistaVirtual) AS AnalistaAsignado
			FROM SOLICITUDESASIGNADAS Sol
			INNER JOIN SOLICITUDCREDITO Soli      ON      Sol.SolicitudCreditoID=Soli.SolicitudCreditoID
			INNER JOIN CLIENTES Cli               ON      Soli.ClienteID=Cli.ClienteID
			LEFT OUTER JOIN PRODUCTOSCREDITO Pro  ON      Sol.ProductoID=Pro.ProducCreditoID
			LEFT JOIN USUARIOS Usu                ON      Usu.UsuarioID=Sol.UsuarioID
	    	WHERE Sol.UsuarioID=Par_NumUsuario LIMIT 1;
	END IF;

	-- 21.- CONSULTA USUARIOS DE ROL COORDINADOR
	IF(Par_NumCon = Con_RolCoordinador)THEN

		-- SE OBTIENE EL ROL CORRESPONDIENTE AL COORDINADOR
		SELECT	CAST(ValorParametro AS UNSIGNED)
		INTO	Var_RolCoordinador
		FROM PARAMGENERALES
		WHERE
			LlaveParametro = Var_LlaveRolCoordinador;

		-- VALIDACION DE DATOS NULOS
		SET Var_RolCoordinador := IFNULL(Var_RolCoordinador, Entero_Cero);

		SELECT
			User.UsuarioID,	User.SucursalUsuario,	User.NombreCompleto
		FROM USUARIOS User
		INNER JOIN
			ROLES Rol ON User.RolID = Rol.RolID
		WHERE User.UsuarioID = Par_NumUsuario
			AND User.Estatus = Estatus_Activo
			AND Rol.RolID = Var_RolCoordinador;
	END IF;


END TerminaStore$$

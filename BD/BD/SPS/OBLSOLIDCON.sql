-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBLSOLIDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `OBLSOLIDCON`;DELIMITER $$

CREATE PROCEDURE `OBLSOLIDCON`(
	-- SP QUE CONSULTA Obligados Solidarios
	Par_OblSolidID			BIGINT(20),			-- Identificador del obligado Solidarios
	Par_NumCon				TINYINT UNSIGNED,	-- Parametro para indicar el tipo de reporte

	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_ClienteID 		INT(11);		-- Identificacdor del cliente
	DECLARE Var_ProspectoID		INT(11);		-- Numero de prospecto

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;			-- Fecha vacia
	DECLARE Entero_Cero			INT(11);		-- Entero cero
	DECLARE Salida_SI			CHAR(1);		-- Genera salida
	DECLARE ConPrincipal		INT(11);		-- Consulta principal
	DECLARE ConCredOblSolid		INT(11);		-- Consulta credito por obligado solidario
	DECLARE ConCredCliente		INT(11);		-- Consulta credito por cliente
	DECLARE ConCredProspecto	INT(11);		-- Consulta credito por prospecto
	DECLARE Desembolsado		CHAR(1);		-- Valor desembolso
	DECLARE CredVigente			CHAR(1);		-- Constante credito vigente
	DECLARE CredVencido			CHAR(1);		-- Constante credito vencido

    DECLARE Tipo_Per			CHAR(1);		-- Declaracion del tipo de persona
    DECLARE	Per_Fisica			CHAR(1);		-- Declaracion de Constante persona fisica
	DECLARE	Per_ActEmp			CHAR(1);		-- Declaracion de Constante persona actividad empresarial
	DECLARE	Per_Moral			CHAR(1);		-- Declaracion de Constante persona moral

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Asignacion cadena vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Asignacion fecha vacia
	SET Entero_Cero			:= 0;				-- Asignacion Entero cero
	SET Salida_SI			:= 'S';				-- Asignacion Salida Si
	SET ConPrincipal		:= 1;				-- Consulta principal
	SET ConCredOblSolid		:= 2;			-- Consulta creditos avalados por obligado solidario
	SET ConCredCliente		:= 3;				-- Consulta creditos avalados por cliente
	SET ConCredProspecto	:= 4;				-- Consulta creditos avalados por prospecto
	SET Desembolsado		:= 'D';				-- Estatus del credito: Desembolsado
	SET CredVigente			:= 'V';				-- Estatus del credito: Vigente
	SET CredVencido			:= 'B';				-- Estatus del credito: Vencido

    SET Tipo_Per			:= '';				-- Tipo de Persona
    SET Per_Fisica			:= 'F';				-- Tipo de Persona fisica
	SET Per_ActEmp			:= 'A';				-- Tipo de Persona fisica con act empresarial
	SET Per_Moral			:= 'M';				-- Tipo de Persona moral

	-- Valores Default
	SET Par_OblSolidID		:= IFNULL(Par_OblSolidID, Entero_Cero);
	SET Par_NumCon			:= IFNULL(Par_NumCon, Entero_Cero);

	-- No.: 1
	-- Consulta los datos de un obligado solidario
	-- Usado en la pantalla de alta de Obligados Solidarios
	IF (Par_NumCon = ConPrincipal) THEN
		SELECT TipoPersona INTO Tipo_Per
				FROM OBLIGADOSSOLIDARIOS
				WHERE OblSolidID= Par_OblSolidID;

		IF (Tipo_Per = Per_Fisica OR Tipo_Per = Per_ActEmp) THEN

			SELECT  A.OblSolidID,			A.TipoPersona,		A.RazonSocial,		A.PrimerNombre,		A.SegundoNombre,
					A.TercerNombre,			A.ApellidoPaterno,	A.ApellidoMaterno,	A.RFC,				A.Telefono,
					A.NombreCompleto,		A.Calle,			A.NumExterior,		A.NumInterior,		A.Manzana,
					A.Lote,					A.Colonia,			A.ColoniaID,		A.LocalidadID,		A.MunicipioID,
					A.EstadoID,				A.CP,				A.Latitud,			A.Longitud,			A.FechaNac,
					A.TelefonoCel,			A.RFCpm,			A.Sexo,				A.EstadoCivil,		A.DireccionCompleta,
					A.ExtTelefonoPart,		EO.Esc_Tipo,		EO.EscrituraPublic,	EO.LibroEscritura,	EO.VolumenEsc,
					EO.FechaEsc,			EO.EstadoIDEsc,		EO.LocalidadEsc,	EO.Notaria,			EO.DirecNotaria,
					EO.NomNotario,			EO.NomApoderado,	EO.RFC_Apoderado,	EO.RegistroPub,		EO.FolioRegPub,
					EO.VolumenRegPub,		EO.LibroRegPub,		EO.AuxiliarRegPub,	EO.FechaRegPub,		EO.EstadoIDReg,
					EO.LocalidadRegPub,		A.Nacion,			A.LugarNacimiento,	A.OcupacionID,		A.Puesto,
					A.DomicilioTrabajo,		A.TelefonoTrabajo,	A.ExtTelTrabajo,	ocup.Descripcion
			FROM OBLIGADOSSOLIDARIOS A
				INNER JOIN OCUPACIONES AS ocup ON A.OcupacionID = ocup.OcupacionID
				LEFT OUTER JOIN ESCPUBOBLSOLID EO	ON EO.OblSolidID = A.OblSolidID
				WHERE A.OblSolidID = Par_OblSolidID;

		ELSEIF (Tipo_Per = Per_Moral) THEN
			SELECT  A.OblSolidID,			A.TipoPersona,		A.RazonSocial,		A.PrimerNombre,		A.SegundoNombre,
					A.TercerNombre,			A.ApellidoPaterno,	A.ApellidoMaterno,	A.RFC,				A.Telefono,
					A.NombreCompleto,		A.Calle,			A.NumExterior,		A.NumInterior,		A.Manzana,
					A.Lote,					A.Colonia,			A.ColoniaID,		A.LocalidadID,		A.MunicipioID,
					A.EstadoID,				A.CP,				A.Latitud,			A.Longitud,			A.FechaNac,
					A.TelefonoCel,			A.RFCpm,			A.Sexo,				A.EstadoCivil,		A.DireccionCompleta,
					A.ExtTelefonoPart,		EO.Esc_Tipo,		EO.EscrituraPublic,	EO.LibroEscritura,	EO.VolumenEsc,
					EO.FechaEsc,			EO.EstadoIDEsc,		EO.LocalidadEsc,	EO.Notaria,			EO.DirecNotaria,
					EO.NomNotario,			EO.NomApoderado,	EO.RFC_Apoderado,	EO.RegistroPub,		EO.FolioRegPub,
					EO.VolumenRegPub,		EO.LibroRegPub,		EO.AuxiliarRegPub,	EO.FechaRegPub,		EO.EstadoIDReg,
					EO.LocalidadRegPub,		A.Nacion,			A.LugarNacimiento,	A.OcupacionID,		A.Puesto,
					A.DomicilioTrabajo,		A.TelefonoTrabajo,	A.ExtTelTrabajo, 	Cadena_Vacia as Descripcion
			FROM OBLIGADOSSOLIDARIOS A
				LEFT OUTER JOIN ESCPUBOBLSOLID EO	ON EO.OblSolidID = A.OblSolidID
				WHERE A.OblSolidID = Par_OblSolidID;
		END IF;

	END IF;

	-- No.: 2
	-- Consulta creditos avalados por obligado solidario
	-- Usado en el grid de Asignacion de avales
	IF(Par_NumCon = ConCredOblSolid)THEN
		SELECT	OBL.NombreCompleto, 			COUNT(Cre.CreditoID) AS CreditosAvalados,
				Entero_Cero AS EstatusCliente,	OBL.OblSolidID,
				Entero_Cero AS ClienteID, 		Entero_Cero AS ProspectoID
		FROM OBLIGADOSSOLIDARIOS OBL
			LEFT JOIN OBLSOLIDARIOSPORSOLI OSP ON OSP.OblSolidID = OBL.OblSolidID
			LEFT JOIN SOLICITUDCREDITO Sol ON OSP.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Sol.Estatus = Desembolsado
			LEFT JOIN CREDITOS Cre ON Cre.CreditoID = Sol.CreditoID
				AND (Cre.Estatus = CredVigente
				OR Cre.Estatus = CredVencido)
		WHERE OBL.OblSolidID = Par_OblSolidID
		GROUP BY OBL.OblSolidID, OBL.NombreCompleto;
	END IF;

	-- No.: 3
	-- Consulta creditos avalados por cliente
	-- Usado en el grid de Asignacion de avales
	IF (Par_NumCon = ConCredCliente) THEN
		SET Var_ClienteID := Par_OblSolidID;

		SELECT	Cli.NombreCompleto, 			COUNT(Cre.CreditoID) AS CreditosAvalados,
				Cli.Estatus AS EstatusCliente,	Entero_Cero AS OblSolidID, Cli.ClienteID,
				Entero_Cero AS ProspectoID
		FROM CLIENTES Cli
			LEFT JOIN OBLSOLIDARIOSPORSOLI OSP ON OSP.ClienteID = Cli.ClienteID
			LEFT JOIN SOLICITUDCREDITO Sol ON OSP.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Sol.Estatus = Desembolsado
			LEFT JOIN CREDITOS Cre ON Cre.CreditoID = Sol.CreditoID
				AND (Cre.Estatus = CredVigente
				OR Cre.Estatus = CredVencido)
		WHERE Cli.ClienteID = Var_ClienteID
		GROUP BY Cli.ClienteID, Cli.NombreCompleto, Cli.Estatus;
	END IF;

	-- No.: 4
	-- Consulta creditos avalados por prospecto
	-- Usado en el grid de Asignacion de avales
	IF (Par_NumCon = ConCredProspecto) THEN
		SET Var_ProspectoID := Par_OblSolidID;

		SELECT	Pro.NombreCompleto, COUNT(Cre.CreditoID) AS CreditosAvalados,
				Entero_Cero AS EstatusCliente, Entero_Cero AS OblSolidID,
				Entero_Cero AS ClienteID, Pro.ProspectoID
		FROM PROSPECTOS Pro
			LEFT JOIN OBLSOLIDARIOSPORSOLI OSP ON OSP.ProspectoID = Pro.ProspectoID
			LEFT JOIN SOLICITUDCREDITO Sol ON OSP.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Sol.Estatus = Desembolsado
			LEFT JOIN CREDITOS Cre ON Cre.CreditoID = Sol.CreditoID
				AND (Cre.Estatus = CredVigente
				OR Cre.Estatus = CredVencido)
		WHERE Pro.ProspectoID = Var_ProspectoID
		GROUP BY Pro.ProspectoID, Pro.NombreCompleto;
	END IF;

END TerminaStore$$
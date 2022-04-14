-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESCON`;DELIMITER $$

CREATE PROCEDURE `AVALESCON`(
/* SP QUE CONSULTA AVALES */
    Par_AvalID              BIGINT(20),
    Par_NumCon              TINYINT UNSIGNED,
	/* Parametros de Auditoria */
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,

    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_ClienteID 		INT(11);		-- Numero de cliente
DECLARE Var_ProspectoID		INT(11);		-- Numero de prospecto

-- Declaracion de Constantes
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Salida_SI           CHAR(1);
DECLARE ConPrincipal        INT;
DECLARE ConCredAval         INT;
DECLARE ConCredCliente      INT;
DECLARE ConCredProspecto    INT;
DECLARE ConPersonaFisica	INT(11);
DECLARE Desembolsado		CHAR(1);
DECLARE CredVigente			CHAR(1);
DECLARE CredVencido			CHAR(1);
DECLARE PersonaMoral		CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia    	:= '';				-- Cadena vacia
SET Fecha_Vacia     	:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero     	:= 0;				-- Entero cero
SET Salida_SI       	:= 'S';				-- Salida Si
SET ConPrincipal        := 1;       		-- Consulta principal
SET ConCredAval         := 2;       		-- Consulta creditos avalados por aval
SET ConCredCliente      := 3;       		-- Consulta creditos avalados por cliente
SET ConCredProspecto    := 4;       		-- Consulta creditos avalados por prospecto
SET ConPersonaFisica	:= 5;				-- Consulta Persona Fisica
SET Desembolsado		:= 'D';				-- Estatus del credito: Desembolsado
SET CredVigente			:= 'V';				-- Estatus del credito: Vigente
SET CredVencido			:= 'B';				-- Estatus del credito: Vencido
SET PersonaMoral		:= 'M';				-- Persona Moral

-- No.: 1
-- Consulta los datos de un aval
-- Usado en la pantalla de alta de avales
IF(Par_NumCon = ConPrincipal)THEN
    SELECT  A.AvalID,           	A.TipoPersona,      A.RazonSocial,      A.PrimerNombre,   	A.SegundoNombre,
            A.TercerNombre,       	A.ApellidoPaterno,  A.ApellidoMaterno,  A.RFC,            	A.Telefono,
            A.NombreCompleto,     	A.Calle,            A.NumExterior,      A.NumInterior,    	A.Manzana,
            A.Lote,               	A.Colonia,          A.ColoniaID,        A.LocalidadID,    	A.MunicipioID,
            A.EstadoID,           	A.CP,               A.Latitud, 			A.Longitud,       	A.FechaNac,
            A.TelefonoCel,        	A.RFCpm,          	A.Sexo,  			A.EstadoCivil,    	A.DireccionCompleta,
            A.ExtTelefonoPart, 		EA.Esc_Tipo, 		EA.EscrituraPublic,	EA.LibroEscritura,	EA.VolumenEsc,
            EA.FechaEsc, 			EA.EstadoIDEsc,		EA.LocalidadEsc,	EA.Notaria,			EA.DirecNotaria,
            EA.NomNotario,			EA.NomApoderado,	EA.RFC_Apoderado,	EA.RegistroPub,		EA.FolioRegPub,
            EA.VolumenRegPub,		EA.LibroRegPub,		EA.AuxiliarRegPub,	EA.FechaRegPub,		EA.EstadoIDReg,
            EA.LocalidadRegPub,		A.Nacion,			A.LugarNacimiento,	A.OcupacionID,		A.Puesto,
			A.DomicilioTrabajo,		A.TelefonoTrabajo,	A.ExtTelTrabajo,	ocup.Descripcion,	A.NumIdentific,
            A.FecExIden,			A.FecVenIden
        FROM AVALES A
		INNER JOIN OCUPACIONES AS ocup ON A.OcupacionID = ocup.OcupacionID
		LEFT OUTER JOIN ESCPUBAVALES EA
        ON EA.AvalID = A.Avalid
		WHERE A.AvalID = Par_AvalID;
END IF;

-- No.: 2
-- Consulta creditos avalados por aval
-- Usado en el grid de Asignacion de avales
IF(Par_NumCon = ConCredAval)THEN
    SELECT
		Ava.NombreCompleto, COUNT(Cre.CreditoID) AS CreditosAvalados,
		Entero_Cero AS EstatusCliente, Ava.AvalID,
		Entero_Cero AS ClienteID, Entero_Cero AS ProspectoID
	  FROM AVALES Ava
		LEFT JOIN AVALESPORSOLICI AvaS ON AvaS.AvalID = Ava.AvalID
		LEFT JOIN SOLICITUDCREDITO Sol ON AvaS.SolicitudCreditoID = Sol.SolicitudCreditoID
			AND Sol.Estatus = Desembolsado
		LEFT JOIN CREDITOS Cre ON Cre.CreditoID = Sol.CreditoID
			AND (Cre.Estatus = CredVigente
			OR Cre.Estatus = CredVencido)
		WHERE Ava.AvalID = Par_AvalID
	  GROUP BY Ava.AvalID, Ava.NombreCompleto;
END IF;

-- No.: 3
-- Consulta creditos avalados por cliente
-- Usado en el grid de Asignacion de avales
IF(Par_NumCon = ConCredCliente)THEN

	SET Var_ClienteID := Par_AvalID;

    SELECT
		Cli.NombreCompleto, COUNT(Cre.CreditoID) AS CreditosAvalados,
		Cli.Estatus AS EstatusCliente, Entero_Cero AS AvalID, Cli.ClienteID,
		Entero_Cero AS ProspectoID
	  FROM CLIENTES Cli
		LEFT JOIN AVALESPORSOLICI AvaS ON AvaS.ClienteID = Cli.ClienteID
		LEFT JOIN SOLICITUDCREDITO Sol ON AvaS.SolicitudCreditoID = Sol.SolicitudCreditoID
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
IF(Par_NumCon = ConCredProspecto)THEN

	SET Var_ProspectoID := Par_AvalID;

    SELECT
		Pro.NombreCompleto, COUNT(Cre.CreditoID) AS CreditosAvalados,
		Entero_Cero AS EstatusCliente, Entero_Cero AS AvalID,
		Entero_Cero AS ClienteID, Pro.ProspectoID
	  FROM PROSPECTOS Pro
		LEFT JOIN AVALESPORSOLICI AvaS ON AvaS.ProspectoID = Pro.ProspectoID
		LEFT JOIN SOLICITUDCREDITO Sol ON AvaS.SolicitudCreditoID = Sol.SolicitudCreditoID
			AND Sol.Estatus = Desembolsado
		LEFT JOIN CREDITOS Cre ON Cre.CreditoID = Sol.CreditoID
			AND (Cre.Estatus = CredVigente
			OR Cre.Estatus = CredVencido)
		WHERE Pro.ProspectoID = Var_ProspectoID
	  GROUP BY Pro.ProspectoID, Pro.NombreCompleto;
END IF;

-- Consulta los Avales que son Personas Fisicas o Fisicas con Activiad Empresarial
IF(Par_NumCon = ConPersonaFisica)THEN
    SELECT  A.AvalID,	A.NombreCompleto
        FROM AVALES A
		WHERE A.AvalID = Par_AvalID
        AND A.TipoPersona <> PersonaMoral;
END IF;


END TerminaStore$$
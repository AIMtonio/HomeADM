-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROSPECTOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROSPECTOSCON`;
DELIMITER $$


CREATE PROCEDURE `PROSPECTOSCON`(
	-- Store Procedure: De Consulta para los Prospectos del menu de Clientes
	-- Modulo Clientes
	Par_ProspectoID		BIGINT(20),		-- ID de Prospecto
	Par_ClienteID		INT(11),		-- ID de Cliente
	Par_NumCon			TINYINT UNSIGNED,-- Numero de Consulta

	Par_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	Cadena_Vacia	CHAR(1);	-- Constante Cadena Vacia
DECLARE	Fecha_Vacia		DATE;		-- Constante Fecha Vacia
DECLARE	Entero_Cero		INT;		-- Constante Entero Cero
DECLARE Salida_SI 		CHAR(1);	-- Constante Salida SI
DECLARE TipConPrin		INT;		-- Consulta Principal
DECLARE Con_Foranea		INT;		-- Consulta Foranea
DECLARE Con_Cliente		INT;		-- Consulta de Cliente
DECLARE Con_Califica    INT;		-- Consulta Calificacion Prospecto
DECLARE Con_Nombre      INT;		-- Consulta Nombre de Prospecto
DECLARE Con_PersonaFisica	INT(11);-- Consulta de Persona Fisica
DECLARE Con_GuardaValores	INT(11);-- Consulta de Guarda valores
DECLARE PersonaMoral	CHAR(1);	-- Consulta Persona moral

-- Asignacion de constantes
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET Salida_SI 		:= 'S';
SET TipConPrin 		:= 1;
SET	Con_Foranea		:= 2;
SET	Con_Cliente		:= 3;
SET Con_Califica	:= 4;
SET Con_Nombre		:= 5;
SET Con_PersonaFisica	:= 6;
SET Con_GuardaValores	:= 7;
SET PersonaMoral		:= 'M';		-- Persona Moral

-- Consulta principal de prospectos
IF(Par_NumCon = TipConPrin)THEN
	SELECT	pro.ProspectoID,		pro.TipoPersona,		pro.RazonSocial,		pro.PrimerNombre,		pro.SegundoNombre,
			pro.TercerNombre,		pro.ApellidoPaterno,	pro.ApellidoMaterno,	pro.FechaNacimiento,	pro.RFC,
			pro.Sexo,				pro.EstadoCivil,		pro.Telefono,			pro.NombreCompleto,		pro.Calle,
			pro.NumExterior,		pro.NumInterior,		pro.Manzana,			pro.Lote,				pro.Colonia,
			pro.ColoniaID,			pro.LocalidadID,		pro.MunicipioID,		pro.EstadoID,			pro.CP,
			IFNULL(pro.ClienteID,Entero_Cero)AS ClienteID,	pro.Latitud,			pro.Longitud,			pro.TipoDireccionID,
			pro.OcupacionID,		pro.LugardeTrabajo,		pro.Puesto,				pro.TelTrabajo,			pro.AntiguedadTra,
			pro.Clasificacion,		pro.NoEmpleado,			pro.TipoEmpleado, 		pro.RFCpm, 				pro.ExtTelefonoPart,
			pro.ExtTelefonoTrab, 	pro.CalificaProspecto,	pro.Nacion,				pro.LugarNacimiento,	pro.PaisID,
			pais.Nombre
		FROM PROSPECTOS AS pro
		INNER JOIN PAISES AS pais ON pro.PaisID = pais.PaisID
		WHERE	pro.ProspectoID = Par_ProspectoID;
END IF;

-- Consulta foranea de prospectos
IF(Par_NumCon = Con_Foranea)THEN
	SELECT	ProspectoID,	NombreCompleto, ClienteID, Sexo, EstadoCivil
		FROM  PROSPECTOS
		WHERE ProspectoID = Par_ProspectoID;
END IF;

-- Consulta a partir de un numero de cliente el numero de prospecto.
IF(Par_NumCon = Con_Cliente)THEN
	SELECT	IFNULL(ProspectoID,Entero_Cero),	NombreCompleto,		IFNULL(ClienteID,Entero_Cero)
		FROM  PROSPECTOS
		WHERE ClienteID = Par_ClienteID;
END IF;

-- Consulta Calificacion del prospecto.
IF(Par_NumCon = Con_Califica)THEN
	SELECT	CalificaProspecto
		FROM  PROSPECTOS
		WHERE ProspectoID = Par_ProspectoID;
END IF;

-- Consulta Nombre Completo del prospecto.
IF(Par_NumCon = Con_Nombre)THEN
	SELECT	NombreCompleto
		FROM  PROSPECTOS
		WHERE ProspectoID = Par_ProspectoID;
END IF;

-- Consulta a los prospectos que son Persona Fisica y Fisica con Actividad Empresarial
IF(Par_NumCon = Con_PersonaFisica)THEN

	SELECT	ProspectoID,	NombreCompleto
		FROM  PROSPECTOS
		WHERE ProspectoID = Par_ProspectoID
        AND TipoPersona <> PersonaMoral;
END IF;

-- Consulta de prospectos en Guarda Valores
IF(Par_NumCon = Con_GuardaValores)THEN
	SELECT	ProspectoID,	NombreCompleto, IFNULL(ClienteID, Entero_Cero) AS ClienteID, Sexo, EstadoCivil
		FROM  PROSPECTOS
		WHERE ProspectoID = Par_ProspectoID;
END IF;

END TerminaStore$$
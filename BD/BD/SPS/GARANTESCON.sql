-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `GARANTESCON`;DELIMITER $$

CREATE PROCEDURE `GARANTESCON`(
	# ========== SP PARA CONSULTA DE GARANTES =============================================
    Par_GaranteID       INT(11),                -- Numero de Garante a Consultar
    Par_NumCon          TINYINT UNSIGNED,   	-- Numero de consulta

    -- Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
		)
TerminaStore: BEGIN


	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE	Con_Principal			INT;
    DECLARE Con_PersonaFisica		INT(11);
    DECLARE PersonaMoral			CHAR(1);


 -- Asignacion de constantes
    SET Cadena_Vacia                := '';              -- Cadena vacia
    SET Fecha_Vacia                 := '1900-01-01';    -- Fecha vacia
    SET Entero_Cero                 := 0;               -- Entero cero
    SET Con_Principal               := 1;               -- Consulta principal
    SET Con_PersonaFisica			:= 2;				-- Consulta a los Garantes que son Persona Fisica y Fisica con Actividad Empresarial
	SET PersonaMoral 				:= 'M';				-- Tipo de Persona Moral

	IF(Par_NumCon = Con_Principal) THEN

	   SELECT 	GaranteID,			TipoPersona,		Titulo,				PrimerNombre,		SegundoNombre,
				TercerNombre,		ApellidoPaterno,	ApellidoMaterno,	FechaNacimiento,	Nacion,
                LugarNacimiento,	EstadoID,			PaisResidencia,		Sexo,				CURP,
                RegistroHacienda,	RFC,				FechaConstitucion,	EstadoCivil,		TelefonoCelular,
                Telefono,			ExtTelefonoPart,	Correo,				Fax,				Observaciones,
                RazonSocial,		RFCpm,				RFCOficial,			PaisConstitucionID,	CorreoAlterPM,
                TipoSociedadID,		GrupoEmpresarial,	FEA,				PaisFEA,			NombreCompleto,
                TipoIdentiID,       NumIdentific,		FecExIden,			FecVenIden,			EstadoIDDir,
                MunicipioID,        LocalidadID,		ColoniaID,			Calle,				NumeroCasa,
                NumInterior,        CP,					Lote,				Manzana,			DireccionCompleta,
                Esc_Tipo,           EscrituraPublic,	LibroEscritura,		VolumenEsc,			FechaEsc,
                EstadoIDEsc,        MunicipioEsc,		Notaria,			NomApoderado,		RFC_Apoderado,
                RegistroPub,        FolioRegPub,		VolumenRegPub,		LibroRegPub,		AuxiliarRegPub,
                FechaRegPub,        EstadoIDReg,		MunicipioRegPub

			FROM GARANTES
			WHERE GaranteID = Par_GaranteID;
	END IF;

-- Consulta a los Garantes que son Persona Fisica y Fisica con Actividad Empresarial
	IF(Par_NumCon = Con_PersonaFisica) THEN

	   SELECT 	GaranteID,	NombreCompleto
			FROM GARANTES
			WHERE GaranteID = Par_GaranteID
            AND TipoPersona <> PersonaMoral;
	END IF;

END TerminaStore$$
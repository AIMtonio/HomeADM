-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSERVICIOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSERVICIOCON`;
DELIMITER $$

CREATE PROCEDURE `USUARIOSERVICIOCON`(

    Par_UsuarioID       INT(11),
    Par_NumCon          TINYINT UNSIGNED,

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);		-- Cadena Vacia
	DECLARE Fecha_Vacia     	DATE;			-- Fecha Vacia
	DECLARE Entero_Cero     	INT(11);		-- Entero Cero
	DECLARE Con_Principal   	INT(11);		-- Consulta Principal
	DECLARE Con_Ventanilla  	INT(11);		-- Consulta Ventanilla

	DECLARE Con_Unificacion 	INT(11);        -- Consulta de usuario para unificacion
	DECLARE Con_Conocimiento	INT(11);		-- Consulta para conocimiento del usuario

	-- Asignacion de Constantes
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Con_Principal       := 1;
	SET Con_Ventanilla      := 2;

	SET Con_Unificacion     := 5;
	SET Con_Conocimiento	:= 6;

	IF(Par_NumCon = Con_Principal) THEN
	SELECT  UsuarioServicioID,  TipoPersona,        PrimerNombre,       SegundoNombre,  TercerNombre,
			ApellidoPaterno,    ApellidoMaterno,    FechaNacimiento,    Nacionalidad,   PaisNacimiento,
			EstadoNacimiento,   Sexo,               CURP,               RazonSocial,    TipoSociedadID,
			RFC,                RFCpm,              RFCOficial,         FEA,            FechaConstitucion,
			PaisRFC,            OcupacionID,        Correo,             TelefonoCelular,Telefono,
			ExtTelefonoPart,    NombreCompleto,     SucursalOrigen,     PaisResidencia, TipoDireccionID,
			EstadoID,           MunicipioID,        LocalidadID,        ColoniaID,      Calle,
			NumExterior,        NumInterior,        CP,                 Piso,           Manzana,
			Lote,               DirCompleta,        TipoIdentiID,       NumIdenti,      FecExIden,
			FecVenIden,         DocEstanciaLegal,   DocExisLegal,       FechaVenEst,    UsuarioUnificadoID,
			NivelRiesgo,        Estatus
		FROM USUARIOSERVICIO
			WHERE UsuarioServicioID = Par_UsuarioID;
	END IF;

	IF(Par_NumCon = Con_Ventanilla) THEN
	SELECT  UsuarioServicioID,  TipoPersona,        PrimerNombre,       SegundoNombre,  TercerNombre,
			ApellidoPaterno,    ApellidoMaterno,    FechaNacimiento,    Nacionalidad,   PaisNacimiento,
			EstadoNacimiento,   Sexo,               CURP,               RazonSocial,    TipoSociedadID,
			RFC,                RFCpm,              RFCOficial,         FEA,            FechaConstitucion,
			PaisRFC,            OcupacionID,        Correo,             TelefonoCelular,Telefono,
			ExtTelefonoPart,    NombreCompleto,     SucursalOrigen,     PaisResidencia, TipoDireccionID,
			EstadoID,           MunicipioID,        LocalidadID,        ColoniaID,      Calle,
			NumExterior,        NumInterior,        CP,                 Piso,           Manzana,
			Lote,               DirCompleta,        TipoIdentiID,       NumIdenti,      FecExIden,
			FecVenIden,         DocEstanciaLegal,   DocExisLegal,       FechaVenEst
		FROM USUARIOSERVICIO
			WHERE UsuarioServicioID = Par_UsuarioID;
	END IF;

	-- 5.- Consulta de usuario para unificacion.
    -- Pantalla: Ventanilla > Registro > Unificar Usuario Servicios.
    IF (Par_NumCon = Con_Unificacion) THEN
        SELECT  UsuarioServicioID,  NombreCompleto, RFC,    CURP,   Sexo,
                FechaNacimiento
        FROM USUARIOSERVICIO
        WHERE UsuarioServicioID = Par_UsuarioID;
    END IF;

	-- 6. Consulta de usuario para dar de alta o modificar conocimiento
	-- Pantalla. Prevencion LD > Registro > Conocimiento Usuario Servicios.
	 IF (Par_NumCon = Con_Conocimiento) THEN
        SELECT  UsuarioServicioID,  NombreCompleto, NivelRiesgo, Nacionalidad
        FROM USUARIOSERVICIO
        WHERE UsuarioServicioID = Par_UsuarioID;
    END IF;

END TerminaStore$$
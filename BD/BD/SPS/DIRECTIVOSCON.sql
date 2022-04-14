-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECTIVOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECTIVOSCON`;

DELIMITER $$
CREATE PROCEDURE `DIRECTIVOSCON`(
# =====================================================================================
# ----- STORE ENCARGADO DE REALIZAR UNA CONSULTA A LA TABLA DIRECTIVOS -----------------
# =====================================================================================
    Par_NumClienteID        BIGINT(12),         # Numero de Cliente
    Par_NumGaranteID        BIGINT(12),         # Numero Garante
    Par_NumAvalID           BIGINT(12),         # Numero de Aval
    Par_DirectivoID         INT(13),            # Numero de Directivo
    Par_NumCon              TINYINT UNSIGNED,   # Numero de Consulta

    -- Parametros de Auditoria
    Par_EmpresaID           INT(11),            -- ID de la empresa
    Aud_Usuario             INT(11),            -- Parametro de auditoria ID del usuario
    Aud_FechaActual         DATETIME,           -- Parametro de auditoria Fecha actual
    Aud_DireccionIP         VARCHAR(15),        -- Parametro de auditoria Direccion IP
    Aud_ProgramaID          VARCHAR(50),        -- Parametro de auditoria Programa
    Aud_Sucursal            INT(11),            -- Parametro de auditoria ID de la Sucursal
    Aud_NumTransaccion      BIGINT(20)          -- Parametro de auditoria Numero de la Transaccion
)
TerminaStore: BEGIN

    -- DECLARACION DE VARIABLES
    DECLARE NumErr          INT(11);        -- Numero de Error
    DECLARE ErrMen          VARCHAR(40);    -- Mensaje de Error
    DECLARE Var_CuentaAhoID INT(11);        -- Numero de Cuenta
    DECLARE Var_ClienteID   INT(11);        -- Numero de Cliente
    DECLARE Var_GaranteID   INT(11);        -- Numero de Garante
    DECLARE Var_AvalID      INT(11);        -- Numero de Aval

    -- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Fecha_Vacia     DATE;
    DECLARE Entero_Cero     INT(11);
    DECLARE Con_Principal   INT(11);


    -- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia    := '';              -- String o cadena vacia.
    SET Fecha_Vacia     := '1900-01-01';    -- Fecha vacia.
    SET Entero_Cero     := 0;               -- Entero cero.
    SET Con_Principal   := 1;               -- Consulta principal.

    # Se obtiene el valor del Cliente si el directivo es Cliente de la Institucion
    IF(Par_NumCon = Con_Principal) THEN
        IF(Par_NumGaranteID <>Entero_Cero) THEN
            SET Var_GaranteID := (SELECT GaranteRelacion FROM DIRECTIVOS WHERE DirectivoID = Par_DirectivoID AND GaranteID = Par_NumGaranteID);
            SET Var_GaranteID := IFNULL(Var_GaranteID, Entero_Cero);

            IF(Par_NumCon = Con_Principal) THEN
            SELECT  Dir.ClienteID,          Dir.GaranteID,          Dir.AvalID,             Dir.DirectivoID,        Dir.RelacionadoID,
                    Dir.GaranteRelacion,    Dir.AvalRelacion,       Dir.CargoID,            Dir.EsApoderado,        Dir.ConsejoAdmon,
                    Dir.EsAccionista,       Dir.Titulo,             Dir.PrimerNombre,       Dir.SegundoNombre,      Dir.TercerNombre,
                    Dir.ApellidoPaterno,    Dir.ApellidoMaterno,    Dir.NombreCompleto,     Dir.FechaNac,           Dir.PaisNacimiento,
                    Dir.EdoNacimiento,      Dir.EstadoCivil,        Dir.Sexo,               Dir.Nacionalidad,       Dir.CURP,
                    Dir.RFC,                Dir.OcupacionID,        Dir.FEA,                Dir.PaisFEA,            Dir.PaisRFC,
                    Dir.PuestoA,            Dir.SectorGeneral,      Dir.ActividadBancoMX,   Dir.ActividadINEGI,     Dir.SectorEconomico,
                    Dir.TipoIdentiID,       Dir.OtraIdentifi,       Dir.NumIdentific,       Dir.FecExIden,          Dir.FecVenIden,
                    Dir.Domicilio,          Dir.TelefonoCasa,       Dir.TelefonoCelular,    Dir.Correo,             Dir.PaisResidencia,
                    Dir.DocEstanciaLegal,   Dir.DocExisLegal,       Dir.FechaVenEst,        Dir.NumEscPub,          Dir.FechaEscPub,
                    Dir.EstadoID,           Dir.MunicipioID,        Dir.NotariaID,          Dir.TitularNotaria,     Dir.Fax,
                    Dir.ExtTelefonoPart,    Dir.IngresoRealoRecur,  Dir.PorcentajeAcciones, Dir.EsPropietarioReal,  Dir.ValorAcciones,
                    Dir.FolioMercantil,     Dir.TipoAccionista,     Dir.NombreCompania,     Dir.Direccion1,         Dir.Direccion2,
                    Dir.MunNacimiento,      Dir.LocNacimiento,      Dir.ColoniaID,          Dir.NombreCiudad,       Dir.CodigoPostal,
                    Dir.EdoExtranjero,      Dir.EsSolicitante,      Dir.EsAutorizador,      Dir.EsAdministrador,    Dir.PaisIDDom,
                    Dir.EstadoIDDom,        Dir.MunicipioIDDom,     Dir.LocalidadIDDom,     Dir.ColoniaIDDom,       Dir.NombreColoniaDom,
                    Dir.NombreCiudadDom,    Dir.CalleDom,           Dir.NumExteriorDom,     Dir.NumInteriorDom,     Dir.PisoDom,
                    Dir.PrimeraEntreDom,    Dir.SegundaEntreDom,    Dir.CodigoPostalDom

            FROM DIRECTIVOS Dir
            WHERE Dir.GaranteID = Par_NumGaranteID
              AND Dir.DirectivoID = Par_DirectivoID;

            END IF;
        END IF;

        IF(Par_NumAvalID <>Entero_Cero) THEN
            SET Var_AvalID := (SELECT AvalRelacion FROM DIRECTIVOS WHERE DirectivoID = Par_DirectivoID AND AvalID = Par_NumAvalID);
            SET Var_AvalID := IFNULL(Var_AvalID, Entero_Cero);

            IF(Par_NumCon = Con_Principal) THEN
            SELECT  Dir.ClienteID,          Dir.GaranteID,          Dir.AvalID,             Dir.DirectivoID,        Dir.RelacionadoID,
                    Dir.GaranteRelacion,    Dir.AvalRelacion,       Dir.CargoID,            Dir.EsApoderado,        Dir.ConsejoAdmon,
                    Dir.EsAccionista,       Dir.Titulo,             Dir.PrimerNombre,       Dir.SegundoNombre,      Dir.TercerNombre,
                    Dir.ApellidoPaterno,    Dir.ApellidoMaterno,    Dir.NombreCompleto,     Dir.FechaNac,           Dir.PaisNacimiento,
                    Dir.EdoNacimiento,      Dir.EstadoCivil,        Dir.Sexo,               Dir.Nacionalidad,       Dir.CURP,
                    Dir.RFC,                Dir.OcupacionID,        Dir.FEA,                Dir.PaisFEA,            Dir.PaisRFC,
                    Dir.PuestoA,            Dir.SectorGeneral,      Dir.ActividadBancoMX,   Dir.ActividadINEGI,     Dir.SectorEconomico,
                    Dir.TipoIdentiID,       Dir.OtraIdentifi,       Dir.NumIdentific,       Dir.FecExIden,          Dir.FecVenIden,
                    Dir.Domicilio,          Dir.TelefonoCasa,       Dir.TelefonoCelular,    Dir.Correo,             Dir.PaisResidencia,
                    Dir.DocEstanciaLegal,   Dir.DocExisLegal,       Dir.FechaVenEst,        Dir.NumEscPub,          Dir.FechaEscPub,
                    Dir.EstadoID,           Dir.MunicipioID,        Dir.NotariaID,          Dir.TitularNotaria,     Dir.Fax,
                    Dir.ExtTelefonoPart,    Dir.IngresoRealoRecur,  Dir.PorcentajeAcciones, Dir.EsPropietarioReal,  Dir.ValorAcciones,
                    Dir.FolioMercantil,     Dir.TipoAccionista,     Dir.NombreCompania,     Dir.Direccion1,         Dir.Direccion2,
                    Dir.MunNacimiento,      Dir.LocNacimiento,      Dir.ColoniaID,          Dir.NombreCiudad,       Dir.CodigoPostal,
                    Dir.EdoExtranjero,      Dir.EsSolicitante,      Dir.EsAutorizador,      Dir.EsAdministrador,    Dir.PaisIDDom,
                    Dir.EstadoIDDom,        Dir.MunicipioIDDom,     Dir.LocalidadIDDom,     Dir.ColoniaIDDom,       Dir.NombreColoniaDom,
                    Dir.NombreCiudadDom,    Dir.CalleDom,           Dir.NumExteriorDom,     Dir.NumInteriorDom,     Dir.PisoDom,
                    Dir.PrimeraEntreDom,    Dir.SegundaEntreDom,    Dir.CodigoPostalDom
            FROM DIRECTIVOS Dir
            WHERE Dir.AvalID = Par_NumAvalID
              AND Dir.DirectivoID = Par_DirectivoID;

            END IF;
        END IF;

        IF(Par_NumClienteID <>Entero_Cero) THEN
            SET Var_ClienteID := (SELECT RelacionadoID FROM DIRECTIVOS WHERE DirectivoID = Par_DirectivoID AND ClienteID = Par_NumClienteID);
            SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);

            IF(Par_NumCon = Con_Principal) THEN
            SELECT  Dir.ClienteID,          Dir.GaranteID,          Dir.AvalID,             Dir.DirectivoID,        Dir.RelacionadoID,
                    Dir.GaranteRelacion,    Dir.AvalRelacion,       Dir.CargoID,            Dir.EsApoderado,        Dir.ConsejoAdmon,
                    Dir.EsAccionista,       Dir.Titulo,             Dir.PrimerNombre,       Dir.SegundoNombre,      Dir.TercerNombre,
                    Dir.ApellidoPaterno,    Dir.ApellidoMaterno,    Dir.NombreCompleto,     Dir.FechaNac,           Dir.PaisNacimiento,
                    Dir.EdoNacimiento,      Dir.EstadoCivil,        Dir.Sexo,               Dir.Nacionalidad,       Dir.CURP,
                    Dir.RFC,                Dir.OcupacionID,        Dir.FEA,                Dir.PaisFEA,            Dir.PaisRFC,
                    Dir.PuestoA,            Dir.SectorGeneral,      Dir.ActividadBancoMX,   Dir.ActividadINEGI,     Dir.SectorEconomico,
                    Dir.TipoIdentiID,       Dir.OtraIdentifi,       Dir.NumIdentific,       Dir.FecExIden,          Dir.FecVenIden,
                    Dir.Domicilio,          Dir.TelefonoCasa,       Dir.TelefonoCelular,    Dir.Correo,             Dir.PaisResidencia,
                    Dir.DocEstanciaLegal,   Dir.DocExisLegal,       Dir.FechaVenEst,        Dir.NumEscPub,          Dir.FechaEscPub,
                    Dir.EstadoID,           Dir.MunicipioID,        Dir.NotariaID,          Dir.TitularNotaria,     Dir.Fax,
                    Dir.ExtTelefonoPart,    Dir.IngresoRealoRecur,  Dir.PorcentajeAcciones, Dir.EsPropietarioReal,  Dir.ValorAcciones,
                    Dir.FolioMercantil,     Dir.TipoAccionista,     Dir.NombreCompania,     Dir.Direccion1,         Dir.Direccion2,
                    Dir.MunNacimiento,      Dir.LocNacimiento,      Dir.ColoniaID,          Dir.NombreCiudad,       Dir.CodigoPostal,
                    Dir.EdoExtranjero,      Dir.EsSolicitante,      Dir.EsAutorizador,      Dir.EsAdministrador,    Dir.PaisIDDom,
                    Dir.EstadoIDDom,        Dir.MunicipioIDDom,     Dir.LocalidadIDDom,     Dir.ColoniaIDDom,       Dir.NombreColoniaDom,
                    Dir.NombreCiudadDom,    Dir.CalleDom,           Dir.NumExteriorDom,     Dir.NumInteriorDom,     Dir.PisoDom,
                    Dir.PrimeraEntreDom,    Dir.SegundaEntreDom,    Dir.CodigoPostalDom
            FROM DIRECTIVOS Dir
            WHERE Dir.ClienteID = Par_NumClienteID
              AND Dir.DirectivoID = Par_DirectivoID;

            END IF;
        END IF;
    END IF;

END TerminaStore$$
DELIMITER ;
DROP PROCEDURE IF EXISTS `REMITENTESUSUARIOSERVREP`;

DELIMITER $$

CREATE PROCEDURE `REMITENTESUSUARIOSERVREP`(
    -- SP QUE GENERA REPORTES DE REMITENTES POR USUARIOS DE SERVICIOS

    Par_FechaInicio			DATE,           -- Fecha de Inicio para la consulta
	Par_FechaFin			DATE,           -- Fecha Final para la consulta
    Par_UsuarioServicioID   INT(11),        -- ID del Usuario a consultar

    Aud_EmpresaID			INT(11),        -- Parametros de Auditoria
	Aud_Usuario				INT(11),        -- Parametros de Auditoria
	Aud_FechaActual			DATETIME,       -- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),    -- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),    -- Parametros de Auditoria

    Aud_Sucursal			INT(11),        -- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)      -- Parametros de Auditoria
)
TerminaStore: BEGIN
    -- Declaracion de Constantes Generales
    DECLARE	Entero_Cero 			INT(11);
    DECLARE Entero_Uno 				INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Fecha_Vacia				DATE;
	DECLARE SalidaSI				CHAR(1);
	DECLARE Cadena_Vacia			VARCHAR(100);
    DECLARE SalidaNO				CHAR(1);

    -- Declaracion de Constantes para el Reporte
    DECLARE Var_NombreCompletoUsuario   VARCHAR(100);

    -- Asignacion de Constantes Generales
    SET Entero_Cero 			    := 0;
    SET Entero_Uno 				    := 1;
	SET Decimal_Cero 			    := 0.0;
	SET Fecha_Vacia				    := '1900-01-01';
	SET SalidaSI				    := 'S';
	SET Cadena_Vacia 			    := '';
    SET SalidaNO 				    := 'N';

    -- Consulta para obtener los registros de todos los remitentes de todos lo usarios de servicio
    IF(Par_UsuarioServicioID = Entero_Cero)THEN
        SELECT R.UsuarioServicioID, U.NombreCompleto AS NombreUsuario, R.RemitenteID, R.NombreCompleto, C.Descripcion AS TipoPersona,
            R.RFC, R.CURP, R.Domicilio, T.Nombre AS TipoIdentiID, R.NumIdentific,
            UPPER(P.Nombre) AS PaisResidencia,
            CASE R.Nacionalidad
                WHEN 'N' THEN "NACIONAL"
                WHEN 'E' THEN "EXTRANJERO"
                WHEN ''  THEN "DESCONOCIDO"
            END AS Nacionalidad
            FROM REMITENTESUSUARIOSERV R
                LEFT JOIN PAISES P ON R.PaisResidencia = P.PaisID
              	LEFT JOIN CATTIPOSPERSONA C ON R.TipoPersona = C.TipoPersona
                LEFT JOIN TIPOSIDENTI T ON R.TipoIdentiID = T.TipoIdentiID
                INNER JOIN USUARIOSERVICIO U ON R.UsuarioServicioID = U.UsuarioServicioID
            WHERE (Fecha BETWEEN Par_FechaInicio AND Par_FechaFin);

    END IF;

    -- Consulta para obtener los registros de los remitentes de un usuario de servicio en especifico
    IF(Par_UsuarioServicioID <> Entero_Cero)THEN
        SELECT R.UsuarioServicioID, U.NombreCompleto AS NombreUsuario, R.RemitenteID, R.NombreCompleto, C.Descripcion AS TipoPersona,
            R.RFC, R.CURP, R.Domicilio, T.Nombre AS TipoIdentiID, R.NumIdentific,
            UPPER(P.Nombre) AS PaisResidencia,
            CASE R.Nacionalidad
                WHEN 'N' THEN "NACIONAL"
                WHEN 'E' THEN "EXTRANJERO"
                WHEN ''  THEN "DESCONOCIDO"
            END AS Nacionalidad
            FROM REMITENTESUSUARIOSERV R
                LEFT JOIN PAISES P ON R.PaisResidencia = P.PaisID
              	LEFT JOIN CATTIPOSPERSONA C ON R.TipoPersona = C.TipoPersona
                LEFT JOIN TIPOSIDENTI T ON R.TipoIdentiID = T.TipoIdentiID
                INNER JOIN USUARIOSERVICIO U ON R.UsuarioServicioID = U.UsuarioServicioID
        WHERE R.UsuarioServicioID = Par_UsuarioServicioID AND
        (Fecha BETWEEN Par_FechaInicio AND Par_FechaFin);

    END IF;

END TerminaStore$$




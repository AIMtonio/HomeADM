-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSERARCHIVOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSERARCHIVOLIS`;
DELIMITER $$

CREATE PROCEDURE `USUARIOSERARCHIVOLIS`(
    Par_UsuarioID       INT(11),
    Par_TipoDocumen     VARCHAR(45),
    Par_Instrumento     INT(11),
    Par_NumLis          TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_CliProEsp       INT(11);    -- Almacena el Numero de Cliente para Procesos Especificos

-- DECLARACION DE CONSTANCTES
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT(11);
DECLARE Con_CliProcEspe     VARCHAR(20);
DECLARE NumClienteSofi      INT(11);

DECLARE Lis_Principal       INT(11);

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Con_CliProcEspe     := 'CliProcEspecifico'; -- Llave Parametro para Procesos Especificos
SET NumClienteSofi      := 15;                  -- Numero de Cliente para Sofi Procesos Especificos: 15

SET Lis_Principal       := 1;

-- SE OBTIENE EL NUMERO DE CLIENTE PARA PROCESOS ESPECIFICOS
SET Var_CliProEsp := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);
SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);

IF(Par_NumLis = Lis_Principal) THEN
    -- SE REALIZA LA VALIDACION CUANDO EL CLIENTE ESPECIFICO ES SOFI EXPRESS
    IF(Var_CliProEsp = NumClienteSofi) THEN
        SELECT  TipoDocumento,  Consecutivo,    Recurso,    UsuarioSerArchiID, Observacion,
                FechaRegistro
        FROM USUARIOSERARCHIVO
            WHERE  UsuarioServicioID = IFNULL(Par_UsuarioID,Entero_Cero);
    ELSE
        SELECT  TipoDocumento,  Consecutivo,    Recurso,    UsuarioSerArchiID, Observacion,
                FechaRegistro
		FROM USUARIOSERARCHIVO
			WHERE  UsuarioServicioID = IFNULL(Par_UsuarioID,Entero_Cero)
			AND TipoDocumento = Par_TipoDocumen
			LIMIT 0, 15;
    END IF;
END IF;

END TerminaStore$$
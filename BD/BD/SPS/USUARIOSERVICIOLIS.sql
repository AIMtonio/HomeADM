-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSERVICIOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSERVICIOLIS`;
DELIMITER $$

CREATE PROCEDURE `USUARIOSERVICIOLIS`(

    Par_Nombre          VARCHAR(200),
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

    -- Declaracion de Constantes
    DECLARE     Cadena_Vacia        CHAR(1);        -- Cadena Vacia
    DECLARE     Fecha_Vacia         DATE;           -- Fecha Vacia
    DECLARE     Entero_Cero         INT(11);        -- Entero Cero
    DECLARE     Est_Activo          CHAR(1);        -- Estatus: ACTIVO
    DECLARE     Cons_No             CHAR(1);

    DECLARE     Lis_Principal       INT(11);        -- Lista Principal
    DECLARE     Lis_Ventanilla      INT(11);        -- Lista Ventanilla
    DECLARE     Lis_Unificacion     INT(11);        -- Lista de usuarios de servicios que tengan coincidencias.


    -- Asignacion de constantes
    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Est_Activo      := 'A';
    SET Cons_No         := 'N';

    SET Lis_Principal   := 1;
    SET Lis_Ventanilla  := 2;
    SET Lis_Unificacion := 5;


    -- 1.- Lista Principal
    IF(Par_NumLis = Lis_Principal) THEN
        SELECT UsuarioServicioID, NombreCompleto
            FROM USUARIOSERVICIO
            WHERE NombreCompleto LIKE CONCAT("%", Par_Nombre, "%")
                LIMIT 0, 15;
    END IF;

    -- 2.- Lista Ventanilla
    IF(Par_NumLis = Lis_Ventanilla) THEN
        SELECT usr.UsuarioServicioID, usr.NombreCompleto, CONCAT(IFNULL(usr.Calle,Cadena_Vacia),' ',IFNULL(col.Asentamiento,Cadena_Vacia)) AS Direccion, suc.NombreSucurs
            FROM USUARIOSERVICIO usr
                LEFT JOIN SUCURSALES suc ON usr.SucursalOrigen = suc.SucursalID
                LEFT JOIN COLONIASREPUB col ON usr.ColoniaID = col.ColoniaID
                        AND usr.MunicipioID = col.MunicipioID
                        AND usr.EstadoID = col.EstadoID
                    WHERE  usr.Estatus = Est_Activo
                    AND usr.NombreCompleto LIKE CONCAT("%", Par_Nombre, "%")
                    ORDER BY usr.NombreCompleto ASC
                    LIMIT 0,50;
    END IF;

    -- 5.- Lista de usuarios de servicios que tenga coincidencias con usuarios para que se le puedan unificar
    -- Pantalla: Ventanilla > Registro > Unificar Usuario Servicios.
    IF (Par_NumLis = Lis_Unificacion) THEN
        SELECT DISTINCT(US.UsuarioServicioID), US.NombreCompleto
        FROM USUARIOSERVICIO US
        INNER JOIN COINCIDEREMESASUSUSER CU ON CU.UsuarioServicioID = US.UsuarioServicioID
            AND CU.Unificado = Cons_No
        WHERE US.NombreCompleto LIKE CONCAT("%", Par_Nombre, "%")
        LIMIT 0, 15;
    END IF;

END TerminaStore$$
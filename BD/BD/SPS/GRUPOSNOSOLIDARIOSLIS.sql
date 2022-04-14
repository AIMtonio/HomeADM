-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSNOSOLIDARIOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSNOSOLIDARIOSLIS`;DELIMITER $$

CREATE PROCEDURE `GRUPOSNOSOLIDARIOSLIS`(

    Par_GrupoID             BIGINT(12),
    Par_SucursalID          INT(11),
    Par_NombreGrupo         VARCHAR(200),
    Par_NumLis              TINYINT UNSIGNED,


    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
        )
TerminaStore:BEGIN




    DECLARE Lis_Principal       INT;
    DECLARE Lis_GruposAct       INT;
    DECLARE Lis_ClientesGpo INT;
   DECLARE Entero_Cero      INT;

    DECLARE Estatus_Activo      CHAR(1);
    DECLARE Cadena_Vacia        CHAR(1);


    SET Lis_Principal           :=1;
    SET Lis_GruposAct           :=2;
    SET Lis_ClientesGpo         :=3;

    SET Estatus_Activo          :='A';
    SET Cadena_Vacia            :='';
   SET Entero_Cero          :=0;



        IF(Par_NumLis = Lis_Principal) THEN
        IF(Par_SucursalID !=Entero_Cero)THEN
              SELECT GrupoID, NombreGrupo
            FROM GRUPOSNOSOLIDARIOS
            WHERE NombreGrupo LIKE CONCAT("%", Par_NombreGrupo, "%")
            AND SucursalID=Par_SucursalID;
        ELSE
             SELECT GrupoID, NombreGrupo
            FROM GRUPOSNOSOLIDARIOS
            WHERE NombreGrupo LIKE CONCAT("%", Par_NombreGrupo, "%");
        END IF;

        END IF;


        IF(Par_NumLis = Lis_GruposAct) THEN
            SELECT GrupoID          AS Id_Segmento,
                    NombreGrupo     AS DescSegmento
            FROM GRUPOSNOSOLIDARIOS
            WHERE SucursalID = Par_SucursalID
                AND Estatus = Estatus_Activo;
        END IF;


        IF(Par_NumLis = Lis_ClientesGpo) THEN
            IF EXISTS (SELECT Inte.ClienteID
                FROM INTEGRAGRUPONOSOL Inte,
                     CLIENTES Cli,
                     GRUPOSNOSOLIDARIOS Gru
                WHERE Inte.ClienteID = Cli.ClienteID
                    AND Gru.GrupoID = Par_GrupoID
                    AND Inte.GrupoID = Gru.GrupoID
                    AND Gru.Estatus = Estatus_Activo
                    AND Cli.Estatus = Estatus_Activo
                LIMIT 1) THEN

                SELECT DISTINCT(Inte.ClienteID) AS NumSocio,
                         RTRIM(
                            CONCAT(
                                Cli.PrimerNombre, ' ',
                                IFNULL(Cli.SegundoNombre,Cadena_Vacia), ' ',
                                IFNULL(Cli.TercerNombre,Cadena_Vacia))
                            )                   AS Nombre,
                        IFNULL(Cli.ApellidoPaterno,Cadena_Vacia)        AS ApPaterno,
                        IFNULL(Cli.ApellidoMaterno,Cadena_Vacia)        AS ApMaterno,
                        Cli.FechaNacimiento     AS FecNacimiento,
                        IFNULL(Cli.RFC,'')                  AS Rfc
                FROM INTEGRAGRUPONOSOL Inte,
                     CLIENTES Cli,
                     GRUPOSNOSOLIDARIOS Gru
                WHERE Inte.ClienteID = Cli.ClienteID
                    AND Gru.GrupoID = Par_GrupoID
                    AND Inte.GrupoID = Gru.GrupoID
                    AND Gru.Estatus = Estatus_Activo
                    AND Cli.Estatus = Estatus_Activo;
                ELSE
                    SELECT ''   AS NumSocio,
                            ''  AS Nombre,
                            ''  AS ApPaterno,
                            ''  AS ApMaterno,
                            ''  AS FecNacimiento,
                            ''  AS Rfc;
            END IF;
        END IF;

    END TerminaStore$$
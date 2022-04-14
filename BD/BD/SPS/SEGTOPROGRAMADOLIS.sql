-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOPROGRAMADOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOPROGRAMADOLIS`;DELIMITER $$

CREATE PROCEDURE `SEGTOPROGRAMADOLIS`(

    Par_UsuarioID       INT(11),
    Par_Fecha           DATE,
    Par_NombreRes       VARCHAR(50),
    Par_NumLis          TINYINT UNSIGNED,

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Con_AlcanceG        CHAR(1);
    DECLARE Con_EsGestorS       CHAR(1);
    DECLARE Con_EsSupervisorS   CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Cero         INT;
    DECLARE Lis_Gestor          INT;
    DECLARE Lis_Foranea         INT;
    DECLARE Lis_GestorMes       INT;


    DECLARE Var_EsGestor        CHAR(1);
    DECLARE Var_EsSupervisor    CHAR(1);
    DECLARE Var_CreditoID       BIGINT(12);
    DECLARE Var_GrupoID         INT;


    SET Con_EsGestorS       := 'S';
    SET Con_EsSupervisorS   := 'S';
    SET Cadena_Vacia        := '';
    SET Con_AlcanceG        := 'G';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Lis_Gestor          := 1;
    SET Lis_Foranea         := 2;
    SET Lis_GestorMes       := 3;

    IF(Par_NumLis = Lis_Gestor ) THEN
        SELECT  EsGestor , EsSupervisor INTO Var_EsGestor, Var_EsSupervisor
            FROM    USUARIOS usu, PUESTOS pue
        WHERE   pue.EsGestor = Con_EsGestorS
            AND     pue.EsSupervisor = Con_EsSupervisorS
            AND     usu.ClavePuestoID = pue.ClavePuestoID
            AND     UsuarioID = Par_UsuarioID;
        SET Var_EsGestor := IFNULL(Var_EsGestor,Cadena_Vacia);
        SET Var_EsSupervisor := IFNULL(Var_EsSupervisor,Cadena_Vacia);
        IF (Var_EsGestor = Con_EsGestorS AND Var_EsSupervisor = Con_EsSupervisorS) THEN
            SELECT pro.SegtoPrograID, pro.HoraProgramada,
                CASE WHEN pro.CreditoID != Entero_Cero THEN CONVERT(CONCAT(cat.Descripcion, '- Credito: ', pro.CreditoID, ' ',cli.NombreCompleto),CHAR) ELSE
                CONVERT(CONCAT(cat.Descripcion, '-Grupo: ', pro.GrupoID, ' ', grp.NombreGrupo ),CHAR) END AS DetalleActivi,
               CASE WHEN (SELECT seg.Estatus
                            FROM SEGTOREALIZADOS seg
                            WHERE seg.SegtoPrograID = pro.SegtoPrograID ORDER BY seg.SegtoRealizaID DESC LIMIT 1) = 'T' THEN 'T'
                     ELSE  CASE WHEN DATE(pro.FechaProgramada) < DATE(NOW()) AND
                            (SELECT COUNT(SegtoRealizaID) FROM SEGTOREALIZADOS WHERE SegtoPrograID = pro.SegtoPrograID) = Entero_Cero THEN 'V'
                     ELSE CASE WHEN DATE(pro.FechaProgramada) > DATE(NOW()) AND
                            (SELECT COUNT(SegtoRealizaID) FROM SEGTOREALIZADOS WHERE SegtoPrograID = pro.SegtoPrograID) = Entero_Cero THEN 'F' ELSE '' END
                        END
                    END AS Estatus,
                CASE WHEN  (SELECT rec.Alcance
                    FROM SEGTOREALIZADOS seg, SEGTORECOMENDAS rec
                    WHERE seg.RecomendacionSegtoID=rec.RecomendacionSegtoID AND seg.SegtoPrograID = pro.SegtoPrograID ORDER BY seg.SegtoRealizaID DESC LIMIT 1) = 'G'
                OR (SELECT res.Alcance
                    FROM SEGTOREALIZADOS seg, SEGTORESULTADOS res
                    WHERE seg.ResultadoSegtoID= res.ResultadoSegtoID AND seg.SegtoPrograID = pro.SegtoPrograID ORDER BY seg.SegtoRealizaID DESC LIMIT 1) = 'G' THEN 'G' ELSE '' END AS Alcance
                    FROM SEGTOPROGRAMADO pro
                    LEFT JOIN SEGTOCATEGORIAS cat ON pro.CategoriaID = cat.CategoriaID
                    LEFT JOIN CREDITOS cre ON pro.CreditoID= cre.CreditoID
                    LEFT JOIN CLIENTES cli ON cre.ClienteID= cli.ClienteID
                    LEFT JOIN GRUPOSCREDITO grp ON pro.GrupoID=grp.GrupoID
                    WHERE pro.FechaProgramada = Par_Fecha;
        ELSE
                    SELECT pro.SegtoPrograID, pro.HoraProgramada,
                CASE WHEN pro.CreditoID != Entero_Cero THEN CONVERT(CONCAT(cat.Descripcion, '- Credito: ', pro.CreditoID, ' ',cli.NombreCompleto),CHAR) ELSE
                CONVERT(CONCAT(cat.Descripcion, '-Grupo: ', pro.GrupoID, ' ', grp.NombreGrupo ),CHAR) END AS DetalleActivi,
                CASE WHEN (SELECT seg.Estatus
                            FROM SEGTOREALIZADOS seg
                            WHERE seg.SegtoPrograID = pro.SegtoPrograID ORDER BY seg.SegtoRealizaID DESC LIMIT 1) = 'T' THEN 'T'
                     ELSE  CASE WHEN DATE(pro.FechaProgramada) < DATE(NOW()) AND
                            (SELECT COUNT(SegtoRealizaID) FROM SEGTOREALIZADOS WHERE SegtoPrograID = pro.SegtoPrograID) = Entero_Cero THEN 'V'
                     ELSE CASE WHEN DATE(pro.FechaProgramada) > DATE(NOW()) AND
                            (SELECT COUNT(SegtoRealizaID) FROM SEGTOREALIZADOS WHERE SegtoPrograID = pro.SegtoPrograID) = Entero_Cero THEN 'F' ELSE '' END
                        END
                    END AS Estatus,
                CASE WHEN  (SELECT rec.Alcance
                    FROM SEGTOREALIZADOS seg, SEGTORECOMENDAS rec
                    WHERE seg.RecomendacionSegtoID=rec.RecomendacionSegtoID AND seg.SegtoPrograID = pro.SegtoPrograID ORDER BY seg.SegtoRealizaID DESC LIMIT 1) = 'G'
                OR (SELECT res.Alcance
                    FROM SEGTOREALIZADOS seg, SEGTORESULTADOS res
                    WHERE seg.ResultadoSegtoID= res.ResultadoSegtoID AND seg.SegtoPrograID = pro.SegtoPrograID ORDER BY seg.SegtoRealizaID DESC LIMIT 1) = 'G' THEN 'G' ELSE '' END AS Alcance
                    FROM SEGTOPROGRAMADO pro
                    LEFT JOIN SEGTOCATEGORIAS cat ON pro.CategoriaID = cat.CategoriaID
                    LEFT JOIN CREDITOS cre ON pro.CreditoID= cre.CreditoID
                    LEFT JOIN CLIENTES cli ON cre.ClienteID= cli.ClienteID
                    LEFT JOIN GRUPOSCREDITO grp ON pro.GrupoID=grp.GrupoID
                    WHERE pro.FechaProgramada = Par_Fecha AND pro.PuestoResponsableID = Par_UsuarioID;
        END IF;
    END IF;

    IF(Par_NumLis = Lis_Foranea ) THEN
            SELECT seg.SegtoPrograID,
                CONCAT(cat.NombreCorto, "-",
                           CASE WHEN IFNULL(seg.CreditoID, Entero_Cero) != Entero_Cero THEN
                                    CONCAT("Credito: ", CONVERT(seg.CreditoID, CHAR), ' ' ,cli.NombreCompleto)
                                ELSE
                                    CONCAT("Grupo: ", CONVERT(IFNULL(seg.GrupoID, Entero_Cero), CHAR),
                                            " ", CONVERT(IFNULL(grp.NombreGrupo, Entero_Cero),CHAR))
                            END ) AS DetalleActivi,
                CONCAT( CONVERT(seg.FechaProgramada,CHAR)," ", seg.HoraProgramada) AS FechaProgramada
        FROM SEGTOPROGRAMADO seg
        INNER JOIN SEGTOCATEGORIAS cat ON seg.CategoriaID = cat.CategoriaID
        LEFT JOIN CREDITOS cre ON seg.CreditoID = cre.CreditoID
        LEFT JOIN CLIENTES cli ON cre.ClienteID = cli.ClienteID
        LEFT JOIN GRUPOSCREDITO grp ON seg.GrupoID = grp.GrupoID
        WHERE (seg.PuestoResponsableID = Par_UsuarioID OR seg.PuestoSupervisorID = Par_UsuarioID)
            AND (cli.NombreCompleto LIKE CONCAT('%',Par_NombreRes,'%')
                OR grp.NombreGrupo LIKE CONCAT('%'  ,Par_NombreRes,'%'))
        ORDER BY seg.FechaProgramada, seg.HoraProgramada DESC
        LIMIT 0,15;
    END IF;

    IF(Par_NumLis = Lis_GestorMes ) THEN

        SELECT  EsGestor , EsSupervisor INTO Var_EsGestor, Var_EsSupervisor
            FROM    USUARIOS usu, PUESTOS pue
        WHERE   pue.EsGestor = Con_EsGestorS
            AND     pue.EsSupervisor = Con_EsSupervisorS
            AND     usu.ClavePuestoID = pue.ClavePuestoID
            AND     UsuarioID = Par_UsuarioID;
        SET Var_EsGestor := IFNULL(Var_EsGestor,Cadena_Vacia);
        SET Var_EsSupervisor := IFNULL(Var_EsSupervisor,Cadena_Vacia);
        IF (Var_EsGestor = Con_EsGestorS AND Var_EsSupervisor = Con_EsSupervisorS) THEN
            SELECT
                Sep.SegtoPrograID,
                Sep.FechaProgramada,
                Sep.HoraProgramada,
                Sep.CategoriaID
                    FROM    SEGTOPROGRAMADO Sep
            WHERE   Sep.FechaProgramada         <=  Aud_FechaActual
            AND     Sep.FechaProgramada         >=  Par_Fecha
            ORDER BY    Sep.FechaProgramada, Sep.HoraProgramada;
        ELSE
            SELECT
                Sep.SegtoPrograID,
                Sep.FechaProgramada,
                Sep.HoraProgramada,
                Sep.CategoriaID
                FROM    SEGTOPROGRAMADO Sep
                LEFT OUTER JOIN GRUPOSCREDITO Gru ON Gru.GrupoID = IFNULL(Sep.GrupoID, Entero_Cero)
                WHERE   Sep.PuestoResponsableID = Par_UsuarioID
                AND     Sep.FechaProgramada         <=  Aud_FechaActual
                AND     Sep.FechaProgramada         >=  Par_Fecha
                ORDER BY    Sep.FechaProgramada, Sep.HoraProgramada;

        END IF;
    END IF;
END TerminaStore$$
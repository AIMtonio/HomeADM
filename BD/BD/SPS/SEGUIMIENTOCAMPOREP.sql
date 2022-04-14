-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUIMIENTOCAMPOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUIMIENTOCAMPOREP`;DELIMITER $$

CREATE PROCEDURE `SEGUIMIENTOCAMPOREP`(
    Par_FechaInicio     DATE,
    Par_FechaFin        DATE,
    Par_CategoriaID     INT,
    Par_PlazaID         INT,
    Par_SucursalID      INT,
    Par_ProdCredID      INT,
    Par_GestorID        INT,
    Par_SupervisorID    INT,
    Par_ResultadoID     INT,
    Par_RecomendaID     INT,
    Par_Municipio       INT,
	Par_NumeroReporte   INT,

    Aud_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
	)
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE	Cadena_Vacia	CHAR(1);
    DECLARE	Fecha_Vacia		DATE;
    DECLARE	Entero_Cero		INT;

    DECLARE	EstatusVigente	CHAR(1);
    DECLARE	EstatusAtras	CHAR(1);
    DECLARE	EstatusPagado	CHAR(1);
    DECLARE	EstatusVencido	CHAR(1);


    DECLARE	FechaSist		DATE;
    DECLARE  Var_Sentencia 	VARCHAR(5000);

	-- Declaracion de Constantes
	DECLARE Rep_Detalle      INT(11);
	DECLARE Rep_Sumarizado   INT(11);

    -- Asignacion de Variables
    SET	Cadena_Vacia    := '';
    SET	Entero_Cero     := 0;
    SET	Fecha_Vacia     := '1900-01-01';

    SET	EstatusVigente  := 'V';
    SET	EstatusAtras    := 'A';
    SET	EstatusPagado   := 'P';
    SET	EstatusVencido  := 'B';

	-- Asignacion de constantes
	SET Rep_Detalle     := 1;   -- Reporte Detalle de Seguimiento de campo
	SET Rep_Sumarizado  := 2;   -- Reporte Sumarizado de Seguimiento de campo

IF(Par_NumeroReporte = Rep_Detalle) THEN
    SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_Sentencia :='SELECT seg.SegtoPrograID, DATE_FORMAT(seg.FechaRegistro, "%Y-%m-%d") as FechaRegistro, seg.CreditoID, ';
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cli.NombreCompleto, seg.GrupoID, grp.NombreGrupo, DATE_FORMAT(seg.FechaProgramada, "%Y-%m-%d") as FechaProgramada, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.HoraProgramada, seg.CategoriaID, cat.Descripcion, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.PuestoSupervisorID, usu2.NombreCompleto as NombreSupervisor, time(now()) as HoraEmision, seg.TipoGeneracion, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaInicioSegto, "%Y-%m-%d") as FechaInicioSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaFinalSegto, "%Y-%m-%d") as FechaFinalSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.Estatus, seg.EsForzado, rea.SegtoRealizaID, DATE_FORMAT(rea.FechaCaptura, "%Y-%m-%d") as FechaCaptura, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'rea.Comentario, rea.ResultadoSegtoID, res.Descripcion as Resultado, rea.RecomendacionSegtoID, rec.Descripcion as Recomendacion1, rea.SegdaRecomendaSegtoID, rec2.Descripcion as Recomendacion2, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE WHEN rea.Estatus = "I" THEN "INICIADO"  WHEN rea.Estatus = "T" THEN "TERMINADO"  WHEN rea.Estatus = "C" THEN "CANCELADO" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN rea.Estatus = "R" THEN "REPROGRAMADO"  WHEN rea.Estatus = "A" THEN "AUTORIZADO" ELSE "" END AS EstatusRealiza ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'FROM SEGTOPROGRAMADO seg  ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTOCATEGORIAS cat on seg.CategoriaID = cat.CategoriaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN USUARIOS usu on seg.PuestoResponsableID = usu.UsuarioID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN USUARIOS usu2 on seg.PuestoSupervisorID = usu2.UsuarioID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN CREDITOS cre on seg.CreditoID = cre.CreditoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN CLIENTES cli on cre.ClienteID = cli.ClienteID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SUCURSALES suc on cre.SucursalID = suc.SucursalID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN GRUPOSCREDITO grp on seg.GrupoID = grp.GrupoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SUCURSALES suc2 on grp.SucursalID = suc2.SucursalID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTOREALIZADOS rea on seg.SegtoPrograID = rea.SegtoPrograID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec on rea.RecomendacionSegtoID = rec.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec2 on rea.SegdaRecomendaSegtoID = rec2.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORESULTADOS res on rea.ResultadoSegtoID = res.ResultadoSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE seg.FechaRegistro BETWEEN ? AND ? ');

    IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
    IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
    IF(IFNULL(Par_SupervisorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoSupervisorID = ', Par_SupervisorID);
    END IF;
    IF(IFNULL(Par_ResultadoID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND rea.ResultadoSegtoID = ', Par_ResultadoID);
    END IF;
    IF(IFNULL(Par_RecomendaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND rea.RecomendacionSegtoID = ', Par_RecomendaID);
    END IF;
    IF(IFNULL(Par_ProdCredID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND CASE WHEN seg.CreditoID = 0 THEN (SELECT ProductoCreditoID FROM CREDITOS WHERE GrupoID = seg.GrupoID LIMIT 1) = ', Par_ProdCredID);
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' ELSE cre.ProductoCreditoID = ', Par_ProdCredID ,' END ');
    END IF;
    IF(IFNULL(Par_PlazaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND CASE WHEN seg.CreditoID = 0 THEN suc2.PlazaID = ',Par_PlazaID,' ELSE suc.PlazaID = ',Par_PlazaID,' END ');
    END IF;
    IF(IFNULL(Par_SucursalID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND CASE WHEN seg.CreditoID = 0 THEN grp.SucursalID = ',Par_SucursalID,' ELSE cre.SucursalID = ',Par_SucursalID,' END ');
    END IF;
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ';');

    -- select Var_Sentencia;
    SET @Sentencia	= (Var_Sentencia);
    SET @FechaInicio	= Par_FechaInicio;
    SET @FechaFin		= Par_FechaFin;


    PREPARE STSEGTOCAMPOREP FROM @Sentencia;
    EXECUTE STSEGTOCAMPOREP USING @FechaInicio, @FechaFin;
    DEALLOCATE PREPARE STSEGTOCAMPOREP;

    END IF;

IF(Par_NumeroReporte = Rep_Sumarizado) THEN
    SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_Sentencia :='SELECT * FROM (SELECT seg.SegtoPrograID, DATE_FORMAT(seg.FechaRegistro, "%Y-%m-%d") as FechaRegistro, seg.CreditoID, ';
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cli.NombreCompleto, seg.GrupoID, grp.NombreGrupo, DATE_FORMAT(seg.FechaProgramada, "%Y-%m-%d") as FechaProgramada, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.HoraProgramada, seg.CategoriaID, cat.Descripcion, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.PuestoSupervisorID, usu2.NombreCompleto as NombreSupervisor, time(now()) as HoraEmision, seg.TipoGeneracion, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaInicioSegto, "%Y-%m-%d") as FechaInicioSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaFinalSegto, "%Y-%m-%d") as FechaFinalSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.Estatus, seg.EsForzado, rea.SegtoRealizaID, DATE_FORMAT(rea.FechaCaptura, "%Y-%m-%d") as FechaCaptura, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'rea.Comentario, rea.ResultadoSegtoID, res.Descripcion as Resultado, rea.RecomendacionSegtoID, rec.Descripcion as Recomendacion1, rea.SegdaRecomendaSegtoID, rec2.Descripcion as Recomendacion2, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE WHEN rea.Estatus = "I" THEN "INICIADO"  WHEN rea.Estatus = "T" THEN "TERMINADO"  WHEN rea.Estatus = "C" THEN "CANCELADO" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN rea.Estatus = "R" THEN "REPROGRAMADO"  WHEN rea.Estatus = "A" THEN "AUTORIZADO" ELSE "" END AS EstatusRealiza ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'FROM SEGTOPROGRAMADO seg  ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTOCATEGORIAS cat on seg.CategoriaID = cat.CategoriaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN USUARIOS usu on seg.PuestoResponsableID = usu.UsuarioID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN USUARIOS usu2 on seg.PuestoSupervisorID = usu2.UsuarioID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN CREDITOS cre on seg.CreditoID = cre.CreditoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN CLIENTES cli on cre.ClienteID = cli.ClienteID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SUCURSALES suc on cre.SucursalID = suc.SucursalID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN GRUPOSCREDITO grp on seg.GrupoID = grp.GrupoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SUCURSALES suc2 on grp.SucursalID = suc2.SucursalID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTOREALIZADOS rea on seg.SegtoPrograID = rea.SegtoPrograID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec on rea.RecomendacionSegtoID = rec.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec2 on rea.SegdaRecomendaSegtoID = rec2.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORESULTADOS res on rea.ResultadoSegtoID = res.ResultadoSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE seg.FechaRegistro BETWEEN ? AND ? ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'AND seg.SegtoPrograID = rea.SegtoPrograID ');

    IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
    IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
    IF(IFNULL(Par_SupervisorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoSupervisorID = ', Par_SupervisorID);
    END IF;
    IF(IFNULL(Par_ResultadoID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND rea.ResultadoSegtoID = ', Par_ResultadoID);
    END IF;
    IF(IFNULL(Par_RecomendaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND rea.RecomendacionSegtoID = ', Par_RecomendaID);
    END IF;
    IF(IFNULL(Par_ProdCredID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND CASE WHEN seg.CreditoID = 0 THEN (SELECT ProductoCreditoID FROM CREDITOS WHERE GrupoID = seg.GrupoID LIMIT 1) = ', Par_ProdCredID);
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' ELSE cre.ProductoCreditoID = ', Par_ProdCredID ,' END ');
    END IF;
    IF(IFNULL(Par_PlazaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND CASE WHEN seg.CreditoID = 0 THEN suc2.PlazaID = ',Par_PlazaID,' ELSE suc.PlazaID = ',Par_PlazaID,' END ');
    END IF;
    IF(IFNULL(Par_SucursalID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND CASE WHEN seg.CreditoID = 0 THEN grp.SucursalID = ',Par_SucursalID,' ELSE cre.SucursalID = ',Par_SucursalID,' END ');
    END IF;
	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY rea.SegtoRealizaID DESC) SEGUIMIENTO ');
    SET Var_Sentencia := 	CONCAT(Var_Sentencia,' GROUP BY SegtoPrograID, SegtoRealizaID ');
    SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY SegtoPrograID ASC; ');

    -- select Var_Sentencia;
    SET @Sentencia	= (Var_Sentencia);
    SET @FechaInicio	= Par_FechaInicio;
    SET @FechaFin		= Par_FechaFin;


    PREPARE STSEGTOCAMPOREP FROM @Sentencia;
    EXECUTE STSEGTOCAMPOREP USING @FechaInicio, @FechaFin;
    DEALLOCATE PREPARE STSEGTOCAMPOREP;

    END IF;

END TerminaStore$$
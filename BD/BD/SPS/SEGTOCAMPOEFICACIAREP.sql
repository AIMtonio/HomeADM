-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOCAMPOEFICACIAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOCAMPOEFICACIAREP`;DELIMITER $$

CREATE PROCEDURE `SEGTOCAMPOEFICACIAREP`(
    Par_FechaInicio     DATE,
    Par_FechaFin        DATE,
	Par_FechaIniSeg     DATE,
    Par_FechaFinSeg     DATE,
    Par_CategoriaID     INT,
    Par_PlazaID         INT,
    Par_SucursalID      INT,
    Par_ProdCredID      INT,
    Par_GestorID        INT,
    Par_TipoGestorID    INT,
    Par_SupervisorID    INT,
    Par_ResultadoID     INT,
    Par_RecomendaID     INT,
    Par_Municipio       INT,
	Par_Programado      CHAR(1),
	Par_Seguimiento     CHAR(1),
	Par_NumeroReporte   INT,

    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
	)
TerminaStore: BEGIN
    -- Declaracion de Variables
    DECLARE  Var_Sentencia 	VARCHAR(10000);

    -- Declaracion de Constantes
    DECLARE	Cadena_Vacia		CHAR(1);
    DECLARE	Fecha_Vacia			DATE;
    DECLARE	Entero_Cero			INT;
	DECLARE Var_FechaSistema	DATE;
	DECLARE Estatus_Pagado		CHAR(1);
	DECLARE ProgramadoSi		CHAR(1);
    DECLARE SeguimientoSi		CHAR(1);
	DECLARE ProgramadoNo		CHAR(1);
    DECLARE SeguimientoNo		CHAR(1);
	DECLARE Rep_Detalle     	INT(11);
    DECLARE Rep_Sumarizado  	INT(11);

    -- Asignacion de Constantes
    SET	Cadena_Vacia    := '';           -- Cadena vacia
    SET	Entero_Cero     := 0;            -- Entero Cero
    SET	Fecha_Vacia     := '1900-01-01'; -- Fecha vacia
	SET Estatus_Pagado  := 'P';          -- Estatus Pagado
	SET ProgramadoSi    := 'S';          -- Check Programado Si
    SET SeguimientoSi   := 'S';          -- Check seguimiento Si
	SET ProgramadoNo    := 'N';          -- Check Programado No
    SET SeguimientoNo   := 'N';          -- Check seguimiento No
	SET Rep_Detalle     := 1;            -- Reporte Detalle de Eficacia de Seguimiento de campo
	SET Rep_Sumarizado  := 2;            -- Reporte Sumarizado de Eficacia de Seguimiento de campo

IF(Par_NumeroReporte = Rep_Detalle AND Par_Programado = ProgramadoSi AND Par_Seguimiento = SeguimientoNo) THEN
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_Sentencia :='SELECT seg.SegtoPrograID, DATE_FORMAT(seg.FechaRegistro, "%Y-%m-%d") as FechaRegistro, seg.CreditoID, ';
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cli.NombreCompleto, seg.GrupoID, grp.NombreGrupo, DATE_FORMAT(seg.FechaProgramada, "%Y-%m-%d") as FechaProgramada, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.HoraProgramada, seg.CategoriaID, cat.Descripcion as DescripcionCategoria, tip.TipoGestionID,tip.Descripcion as DescripcionGestores, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.PuestoSupervisorID, usu2.NombreCompleto as NombreSupervisor, time(now()) as HoraEmision, seg.TipoGeneracion, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaInicioSegto, "%Y-%m-%d") as FechaInicioSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaFinalSegto, "%Y-%m-%d") as FechaFinalSegto, sgt.FechaPromPago,sgt.MontoPromPago, rea.FechaSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.Estatus, seg.EsForzado, rea.SegtoRealizaID, DATE_FORMAT(rea.FechaCaptura, "%Y-%m-%d") as FechaCaptura, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'rea.Comentario, rea.ResultadoSegtoID, res.Descripcion as Resultado, rea.RecomendacionSegtoID, rec.Descripcion as Recomendacion1, rea.SegdaRecomendaSegtoID, rec2.Descripcion as Recomendacion2, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE WHEN cre.Estatus = "I" THEN "INACTIVO"  WHEN cre.Estatus = "A" THEN "AUTORIZADO"  WHEN cre.Estatus = "V" THEN "VIGENTE" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "P" THEN "PAGADO"  WHEN cre.Estatus = "C" THEN "CANCELADO" WHEN cre.Estatus = "B" THEN "VENCIDO" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "K" THEN "CASTIGADO" ELSE "" END AS EstatusCredito, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(min(Amo.FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(min(Amo.FechaExigible))end)');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Amo.creditoID=cre.CreditoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <="',Var_FechaSistema,'"');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.Estatus != "',Estatus_Pagado, '") as FechaExigible, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia,'(select (case when ifnull(min(FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'else ( datediff("',Var_FechaSistema,'", min(FechaExigible)))  end) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '  from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' where Amo.CreditoID = cre.CreditoID');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, " and Amo.Estatus != '",Estatus_Pagado,"'");
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <= "',Var_FechaSistema,'")as DiasAtraso, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(max(Det.AmortizacionID),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(max(Det.AmortizacionID)) end)');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID) as Amortizacion, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.FechaPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(DATE_FORMAT(MAX(Det.FechaPago),"%Y-%m-%d")) end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as FechaUltimoPago, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.MontoTotPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(MAX(Det.MontoTotPago))end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion and Det.FechaPago = FechaUltimoPago ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as MontoTotalPagado ');
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
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTORESCOBRAORD sgt on rea.SegtoPrograID = sgt.SegtoPrograID
																				and rea.SegtoPrograID=sgt.SegtoPrograID
																				and rea.SegtoRealizaID=sgt.SegtoRealizaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec on rea.RecomendacionSegtoID = rec.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec2 on rea.SegdaRecomendaSegtoID = rec2.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORESULTADOS res on rea.ResultadoSegtoID = res.ResultadoSegtoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN TIPOGESTION tip on cat.TipoGestionID = tip.TipoGestionID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE seg.FechaProgramada BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ');

    IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
    IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
	IF(IFNULL(Par_TipoGestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND tip.TipoGestionID = ', Par_TipoGestorID);
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


    PREPARE STSEGTOEFICACIAREP FROM @Sentencia;
    EXECUTE STSEGTOEFICACIAREP;
    DEALLOCATE PREPARE STSEGTOEFICACIAREP;

    END IF;

IF(Par_NumeroReporte = Rep_Sumarizado AND Par_Programado = ProgramadoSi AND Par_Seguimiento = SeguimientoNo) THEN
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_Sentencia :='SELECT * FROM (SELECT seg.SegtoPrograID, DATE_FORMAT(seg.FechaRegistro, "%Y-%m-%d") as FechaRegistro, seg.CreditoID, ';
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cli.NombreCompleto, seg.GrupoID, grp.NombreGrupo, DATE_FORMAT(seg.FechaProgramada, "%Y-%m-%d") as FechaProgramada, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.HoraProgramada, seg.CategoriaID, cat.Descripcion as DescripcionCategoria, tip.TipoGestionID,tip.Descripcion as DescripcionGestores, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.PuestoSupervisorID, usu2.NombreCompleto as NombreSupervisor, time(now()) as HoraEmision, seg.TipoGeneracion, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaInicioSegto, "%Y-%m-%d") as FechaInicioSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaFinalSegto, "%Y-%m-%d") as FechaFinalSegto, sgt.FechaPromPago,sgt.MontoPromPago, rea.FechaSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.Estatus, seg.EsForzado, rea.SegtoRealizaID, DATE_FORMAT(rea.FechaCaptura, "%Y-%m-%d") as FechaCaptura, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'rea.Comentario, rea.ResultadoSegtoID, res.Descripcion as Resultado, rea.RecomendacionSegtoID, rec.Descripcion as Recomendacion1, rea.SegdaRecomendaSegtoID, rec2.Descripcion as Recomendacion2, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE WHEN cre.Estatus = "I" THEN "INACTIVO"  WHEN cre.Estatus = "A" THEN "AUTORIZADO"  WHEN cre.Estatus = "V" THEN "VIGENTE" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "P" THEN "PAGADO"  WHEN cre.Estatus = "C" THEN "CANCELADO" WHEN cre.Estatus = "B" THEN "VENCIDO" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "K" THEN "CASTIGADO" ELSE "" END AS EstatusCredito, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(min(Amo.FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(min(Amo.FechaExigible))end)');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Amo.creditoID=cre.CreditoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <="',Var_FechaSistema,'"');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.Estatus != "',Estatus_Pagado, '") as FechaExigible, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia,'(select (case when ifnull(min(FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'else ( datediff("',Var_FechaSistema,'", min(FechaExigible)))  end) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '  from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' where Amo.CreditoID = cre.CreditoID');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, " and Amo.Estatus != '",Estatus_Pagado,"'");
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <= "',Var_FechaSistema,'")as DiasAtraso, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(max(Det.AmortizacionID),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(max(Det.AmortizacionID)) end)');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID) as Amortizacion, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.FechaPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(DATE_FORMAT(MAX(Det.FechaPago),"%Y-%m-%d")) end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as FechaUltimoPago, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.MontoTotPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(MAX(Det.MontoTotPago))end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion and Det.FechaPago = FechaUltimoPago ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as MontoTotalPagado ');
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
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTORESCOBRAORD sgt on rea.SegtoPrograID = sgt.SegtoPrograID
																				and rea.SegtoPrograID=sgt.SegtoPrograID
																				and rea.SegtoRealizaID=sgt.SegtoRealizaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec on rea.RecomendacionSegtoID = rec.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec2 on rea.SegdaRecomendaSegtoID = rec2.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORESULTADOS res on rea.ResultadoSegtoID = res.ResultadoSegtoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN TIPOGESTION tip on cat.TipoGestionID = tip.TipoGestionID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE seg.FechaProgramada BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ');

    IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
    IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
	IF(IFNULL(Par_TipoGestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND tip.TipoGestionID = ', Par_TipoGestorID);
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
    SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY rea.SegtoRealizaID DESC) EFICACIA ');
    SET Var_Sentencia := 	CONCAT(Var_Sentencia,' GROUP BY SegtoPrograID, FechaPromPago, MontoPromPago, FechaSegto, SegtoRealizaID');
    SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY SegtoPrograID ASC; ');

     -- select Var_Sentencia;
    SET @Sentencia	= (Var_Sentencia);


    PREPARE STSEGTOEFICACIAREP FROM @Sentencia;
    EXECUTE STSEGTOEFICACIAREP;
    DEALLOCATE PREPARE STSEGTOEFICACIAREP;
END IF;

IF(Par_NumeroReporte = Rep_Detalle AND Par_Seguimiento = SeguimientoSi AND Par_Programado = ProgramadoNo) THEN
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
       SET Var_Sentencia :='SELECT seg.SegtoPrograID, DATE_FORMAT(seg.FechaRegistro, "%Y-%m-%d") as FechaRegistro, seg.CreditoID, ';
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cli.NombreCompleto, seg.GrupoID, grp.NombreGrupo, DATE_FORMAT(seg.FechaProgramada, "%Y-%m-%d") as FechaProgramada, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.HoraProgramada, seg.CategoriaID, cat.Descripcion as DescripcionCategoria, tip.TipoGestionID,tip.Descripcion as DescripcionGestores, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.PuestoSupervisorID, usu2.NombreCompleto as NombreSupervisor, time(now()) as HoraEmision, seg.TipoGeneracion, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaInicioSegto, "%Y-%m-%d") as FechaInicioSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaFinalSegto, "%Y-%m-%d") as FechaFinalSegto, sgt.FechaPromPago,sgt.MontoPromPago, rea.FechaSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.Estatus, seg.EsForzado, rea.SegtoRealizaID, DATE_FORMAT(rea.FechaCaptura, "%Y-%m-%d") as FechaCaptura, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'rea.Comentario, rea.ResultadoSegtoID, res.Descripcion as Resultado, rea.RecomendacionSegtoID, rec.Descripcion as Recomendacion1, rea.SegdaRecomendaSegtoID, rec2.Descripcion as Recomendacion2, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE WHEN cre.Estatus = "I" THEN "INACTIVO"  WHEN cre.Estatus = "A" THEN "AUTORIZADO"  WHEN cre.Estatus = "V" THEN "VIGENTE" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "P" THEN "PAGADO"  WHEN cre.Estatus = "C" THEN "CANCELADO" WHEN cre.Estatus = "B" THEN "VENCIDO" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "K" THEN "CASTIGADO" ELSE "" END AS EstatusCredito, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(min(Amo.FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(min(Amo.FechaExigible))end)');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Amo.creditoID=cre.CreditoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <="',Var_FechaSistema,'"');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.Estatus != "',Estatus_Pagado, '") as FechaExigible, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia,'(select (case when ifnull(min(FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'else ( datediff("',Var_FechaSistema,'", min(FechaExigible)))  end) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '  from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' where Amo.CreditoID = cre.CreditoID');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, " and Amo.Estatus != '",Estatus_Pagado,"'");
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <= "',Var_FechaSistema,'")as DiasAtraso, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(max(Det.AmortizacionID),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(max(Det.AmortizacionID)) end)');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID) as Amortizacion, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.FechaPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(DATE_FORMAT(MAX(Det.FechaPago),"%Y-%m-%d")) end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as FechaUltimoPago, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.MontoTotPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(MAX(Det.MontoTotPago))end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion and Det.FechaPago = FechaUltimoPago ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as MontoTotalPagado ');
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
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTORESCOBRAORD sgt on rea.SegtoPrograID = sgt.SegtoPrograID
																				and rea.SegtoPrograID=sgt.SegtoPrograID
																				and rea.SegtoRealizaID=sgt.SegtoRealizaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec on rea.RecomendacionSegtoID = rec.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec2 on rea.SegdaRecomendaSegtoID = rec2.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORESULTADOS res on rea.ResultadoSegtoID = res.ResultadoSegtoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN TIPOGESTION tip on cat.TipoGestionID = tip.TipoGestionID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE rea.FechaSegto BETWEEN "',Par_FechaIniSeg,'" AND "',Par_FechaFinSeg,'" ');

    IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
    IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
	IF(IFNULL(Par_TipoGestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND tip.TipoGestionID = ', Par_TipoGestorID);
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


    PREPARE STSEGTOEFICACIAREP FROM @Sentencia;
    EXECUTE STSEGTOEFICACIAREP;
    DEALLOCATE PREPARE STSEGTOEFICACIAREP;

    END IF;

IF(Par_NumeroReporte = Rep_Sumarizado AND Par_Seguimiento = SeguimientoSi AND Par_Programado = ProgramadoNo) THEN
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_Sentencia :='SELECT * FROM (SELECT seg.SegtoPrograID, DATE_FORMAT(seg.FechaRegistro, "%Y-%m-%d") as FechaRegistro, seg.CreditoID, ';
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cli.NombreCompleto, seg.GrupoID, grp.NombreGrupo, DATE_FORMAT(seg.FechaProgramada, "%Y-%m-%d") as FechaProgramada, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.HoraProgramada, seg.CategoriaID, cat.Descripcion as DescripcionCategoria, tip.TipoGestionID,tip.Descripcion as DescripcionGestores, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.PuestoSupervisorID, usu2.NombreCompleto as NombreSupervisor, time(now()) as HoraEmision, seg.TipoGeneracion, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaInicioSegto, "%Y-%m-%d") as FechaInicioSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaFinalSegto, "%Y-%m-%d") as FechaFinalSegto, sgt.FechaPromPago,sgt.MontoPromPago, rea.FechaSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.Estatus, seg.EsForzado, rea.SegtoRealizaID, DATE_FORMAT(rea.FechaCaptura, "%Y-%m-%d") as FechaCaptura, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'rea.Comentario, rea.ResultadoSegtoID, res.Descripcion as Resultado, rea.RecomendacionSegtoID, rec.Descripcion as Recomendacion1, rea.SegdaRecomendaSegtoID, rec2.Descripcion as Recomendacion2, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE WHEN cre.Estatus = "I" THEN "INACTIVO"  WHEN cre.Estatus = "A" THEN "AUTORIZADO"  WHEN cre.Estatus = "V" THEN "VIGENTE" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "P" THEN "PAGADO"  WHEN cre.Estatus = "C" THEN "CANCELADO" WHEN cre.Estatus = "B" THEN "VENCIDO" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "K" THEN "CASTIGADO" ELSE "" END AS EstatusCredito, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(min(Amo.FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(min(Amo.FechaExigible))end)');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Amo.creditoID=cre.CreditoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <="',Var_FechaSistema,'"');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.Estatus != "',Estatus_Pagado, '") as FechaExigible, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia,'(select (case when ifnull(min(FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'else ( datediff("',Var_FechaSistema,'", min(FechaExigible)))  end) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '  from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' where Amo.CreditoID = cre.CreditoID');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, " and Amo.Estatus != '",Estatus_Pagado,"'");
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <= "',Var_FechaSistema,'")as DiasAtraso, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(max(Det.AmortizacionID),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(max(Det.AmortizacionID)) end)');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID) as Amortizacion, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.FechaPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(DATE_FORMAT(MAX(Det.FechaPago),"%Y-%m-%d")) end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as FechaUltimoPago, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.MontoTotPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(MAX(Det.MontoTotPago))end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion and Det.FechaPago = FechaUltimoPago ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as MontoTotalPagado ');
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
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTORESCOBRAORD sgt on rea.SegtoPrograID = sgt.SegtoPrograID
																				and rea.SegtoPrograID=sgt.SegtoPrograID
																				and rea.SegtoRealizaID=sgt.SegtoRealizaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec on rea.RecomendacionSegtoID = rec.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec2 on rea.SegdaRecomendaSegtoID = rec2.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORESULTADOS res on rea.ResultadoSegtoID = res.ResultadoSegtoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN TIPOGESTION tip on cat.TipoGestionID = tip.TipoGestionID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE rea.FechaSegto BETWEEN "',Par_FechaIniSeg,'" AND "',Par_FechaFinSeg,'" ');

    IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
    IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
	IF(IFNULL(Par_TipoGestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND tip.TipoGestionID = ', Par_TipoGestorID);
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
    SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY rea.SegtoRealizaID DESC) EFICACIA ');
    SET Var_Sentencia := 	CONCAT(Var_Sentencia,' GROUP BY SegtoPrograID, FechaPromPago, MontoPromPago, FechaSegto, SegtoRealizaID');
    SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY SegtoPrograID ASC; ');

    -- select Var_Sentencia;
    SET @Sentencia	= (Var_Sentencia);

    PREPARE STSEGTOEFICACIAREP FROM @Sentencia;
    EXECUTE STSEGTOEFICACIAREP;
    DEALLOCATE PREPARE STSEGTOEFICACIAREP;
END IF;

IF(Par_NumeroReporte = Rep_Detalle AND Par_Programado = ProgramadoSi AND Par_Seguimiento = SeguimientoSi) THEN
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_Sentencia :='(SELECT seg.SegtoPrograID, DATE_FORMAT(seg.FechaRegistro, "%Y-%m-%d") as FechaRegistro, seg.CreditoID, ';
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cli.NombreCompleto, seg.GrupoID, grp.NombreGrupo, DATE_FORMAT(seg.FechaProgramada, "%Y-%m-%d") as FechaProgramada, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.HoraProgramada, seg.CategoriaID, cat.Descripcion as DescripcionCategoria, tip.TipoGestionID,tip.Descripcion as DescripcionGestores, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.PuestoSupervisorID, usu2.NombreCompleto as NombreSupervisor, time(now()) as HoraEmision, seg.TipoGeneracion, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaInicioSegto, "%Y-%m-%d") as FechaInicioSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaFinalSegto, "%Y-%m-%d") as FechaFinalSegto, sgt.FechaPromPago,sgt.MontoPromPago, rea.FechaSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.Estatus, seg.EsForzado, rea.SegtoRealizaID, DATE_FORMAT(rea.FechaCaptura, "%Y-%m-%d") as FechaCaptura, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'rea.Comentario, rea.ResultadoSegtoID, res.Descripcion as Resultado, rea.RecomendacionSegtoID, rec.Descripcion as Recomendacion1, rea.SegdaRecomendaSegtoID, rec2.Descripcion as Recomendacion2, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE WHEN cre.Estatus = "I" THEN "INACTIVO"  WHEN cre.Estatus = "A" THEN "AUTORIZADO"  WHEN cre.Estatus = "V" THEN "VIGENTE" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "P" THEN "PAGADO"  WHEN cre.Estatus = "C" THEN "CANCELADO" WHEN cre.Estatus = "B" THEN "VENCIDO" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "K" THEN "CASTIGADO" ELSE "" END AS EstatusCredito, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(min(Amo.FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(min(Amo.FechaExigible))end)');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Amo.creditoID=cre.CreditoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <="',Var_FechaSistema,'"');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.Estatus != "',Estatus_Pagado, '") as FechaExigible, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia,'(select (case when ifnull(min(FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'else ( datediff("',Var_FechaSistema,'", min(FechaExigible)))  end) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '  from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' where Amo.CreditoID = cre.CreditoID');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, " and Amo.Estatus != '",Estatus_Pagado,"'");
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <= "',Var_FechaSistema,'")as DiasAtraso, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(max(Det.AmortizacionID),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(max(Det.AmortizacionID)) end)');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID) as Amortizacion, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.FechaPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(DATE_FORMAT(MAX(Det.FechaPago),"%Y-%m-%d")) end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as FechaUltimoPago, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.MontoTotPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(MAX(Det.MontoTotPago))end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion and Det.FechaPago = FechaUltimoPago ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as MontoTotalPagado ');
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
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTORESCOBRAORD sgt on rea.SegtoPrograID = sgt.SegtoPrograID
																				and rea.SegtoPrograID=sgt.SegtoPrograID
																				and rea.SegtoRealizaID=sgt.SegtoRealizaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec on rea.RecomendacionSegtoID = rec.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec2 on rea.SegdaRecomendaSegtoID = rec2.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORESULTADOS res on rea.ResultadoSegtoID = res.ResultadoSegtoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN TIPOGESTION tip on cat.TipoGestionID = tip.TipoGestionID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE seg.FechaProgramada BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ');

    IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
    IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
	IF(IFNULL(Par_TipoGestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND tip.TipoGestionID = ', Par_TipoGestorID);
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
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ') UNION (');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'SELECT seg.SegtoPrograID, DATE_FORMAT(seg.FechaRegistro, "%Y-%m-%d") as FechaRegistro, seg.CreditoID, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cli.NombreCompleto, seg.GrupoID, grp.NombreGrupo, DATE_FORMAT(seg.FechaProgramada, "%Y-%m-%d") as FechaProgramada, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.HoraProgramada, seg.CategoriaID, cat.Descripcion as DescripcionCategoria, tip.TipoGestionID,tip.Descripcion as DescripcionGestores, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.PuestoSupervisorID, usu2.NombreCompleto as NombreSupervisor, time(now()) as HoraEmision, seg.TipoGeneracion, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaInicioSegto, "%Y-%m-%d") as FechaInicioSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaFinalSegto, "%Y-%m-%d") as FechaFinalSegto, sgt.FechaPromPago,sgt.MontoPromPago, rea.FechaSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.Estatus, seg.EsForzado, rea.SegtoRealizaID, DATE_FORMAT(rea.FechaCaptura, "%Y-%m-%d") as FechaCaptura, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'rea.Comentario, rea.ResultadoSegtoID, res.Descripcion as Resultado, rea.RecomendacionSegtoID, rec.Descripcion as Recomendacion1, rea.SegdaRecomendaSegtoID, rec2.Descripcion as Recomendacion2, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE WHEN cre.Estatus = "I" THEN "INACTIVO"  WHEN cre.Estatus = "A" THEN "AUTORIZADO"  WHEN cre.Estatus = "V" THEN "VIGENTE" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "P" THEN "PAGADO"  WHEN cre.Estatus = "C" THEN "CANCELADO" WHEN cre.Estatus = "B" THEN "VENCIDO" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "K" THEN "CASTIGADO" ELSE "" END AS EstatusCredito, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(min(Amo.FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(min(Amo.FechaExigible))end)');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Amo.creditoID=cre.CreditoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <="',Var_FechaSistema,'"');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.Estatus != "',Estatus_Pagado, '") as FechaExigible, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia,'(select (case when ifnull(min(FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'else ( datediff("',Var_FechaSistema,'", min(FechaExigible)))  end) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '  from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' where Amo.CreditoID = cre.CreditoID');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, " and Amo.Estatus != '",Estatus_Pagado,"'");
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <= "',Var_FechaSistema,'")as DiasAtraso, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(max(Det.AmortizacionID),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(max(Det.AmortizacionID)) end)');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID) as Amortizacion, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.FechaPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(DATE_FORMAT(MAX(Det.FechaPago),"%Y-%m-%d")) end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as FechaUltimoPago, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.MontoTotPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(MAX(Det.MontoTotPago))end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion and Det.FechaPago = FechaUltimoPago ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as MontoTotalPagado ');
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
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTORESCOBRAORD sgt on rea.SegtoPrograID = sgt.SegtoPrograID
																				and rea.SegtoPrograID=sgt.SegtoPrograID
																				and rea.SegtoRealizaID=sgt.SegtoRealizaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec on rea.RecomendacionSegtoID = rec.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec2 on rea.SegdaRecomendaSegtoID = rec2.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORESULTADOS res on rea.ResultadoSegtoID = res.ResultadoSegtoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN TIPOGESTION tip on cat.TipoGestionID = tip.TipoGestionID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE rea.FechaSegto BETWEEN "',Par_FechaIniSeg,'" AND "',Par_FechaFinSeg,'" ');

    IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
    IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
	IF(IFNULL(Par_TipoGestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND tip.TipoGestionID = ', Par_TipoGestorID);
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
    SET Var_Sentencia :=CONCAT(Var_Sentencia,') ORDER BY SegtoPrograID ASC ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ';');

    -- select Var_Sentencia;
    SET @Sentencia	= (Var_Sentencia);

    PREPARE STSEGTOEFICACIAREP FROM @Sentencia;
    EXECUTE STSEGTOEFICACIAREP;
    DEALLOCATE PREPARE STSEGTOEFICACIAREP;

    END IF;

IF(Par_NumeroReporte = Rep_Sumarizado AND Par_Programado = ProgramadoSi AND Par_Seguimiento = SeguimientoSi) THEN
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_Sentencia :='(SELECT * FROM (SELECT seg.SegtoPrograID, DATE_FORMAT(seg.FechaRegistro, "%Y-%m-%d") as FechaRegistro, seg.CreditoID, ';
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cli.NombreCompleto, seg.GrupoID, grp.NombreGrupo, DATE_FORMAT(seg.FechaProgramada, "%Y-%m-%d") as FechaProgramada, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.HoraProgramada, seg.CategoriaID, cat.Descripcion as DescripcionCategoria, tip.TipoGestionID,tip.Descripcion as DescripcionGestores, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.PuestoSupervisorID, usu2.NombreCompleto as NombreSupervisor, time(now()) as HoraEmision, seg.TipoGeneracion, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaInicioSegto, "%Y-%m-%d") as FechaInicioSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaFinalSegto, "%Y-%m-%d") as FechaFinalSegto, sgt.FechaPromPago,sgt.MontoPromPago, rea.FechaSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.Estatus, seg.EsForzado, rea.SegtoRealizaID, DATE_FORMAT(rea.FechaCaptura, "%Y-%m-%d") as FechaCaptura, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'rea.Comentario, rea.ResultadoSegtoID, res.Descripcion as Resultado, rea.RecomendacionSegtoID, rec.Descripcion as Recomendacion1, rea.SegdaRecomendaSegtoID, rec2.Descripcion as Recomendacion2, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE WHEN cre.Estatus = "I" THEN "INACTIVO"  WHEN cre.Estatus = "A" THEN "AUTORIZADO"  WHEN cre.Estatus = "V" THEN "VIGENTE" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "P" THEN "PAGADO"  WHEN cre.Estatus = "C" THEN "CANCELADO" WHEN cre.Estatus = "B" THEN "VENCIDO" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "K" THEN "CASTIGADO" ELSE "" END AS EstatusCredito, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(min(Amo.FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(min(Amo.FechaExigible))end)');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Amo.creditoID=cre.CreditoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <="',Var_FechaSistema,'"');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.Estatus != "',Estatus_Pagado, '") as FechaExigible, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia,'(select (case when ifnull(min(FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'else ( datediff("',Var_FechaSistema,'", min(FechaExigible)))  end) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '  from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' where Amo.CreditoID = cre.CreditoID');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, " and Amo.Estatus != '",Estatus_Pagado,"'");
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <= "',Var_FechaSistema,'")as DiasAtraso, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(max(Det.AmortizacionID),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(max(Det.AmortizacionID)) end)');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID) as Amortizacion, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.FechaPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(DATE_FORMAT(MAX(Det.FechaPago),"%Y-%m-%d")) end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as FechaUltimoPago, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.MontoTotPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(MAX(Det.MontoTotPago))end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion and Det.FechaPago = FechaUltimoPago ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as MontoTotalPagado ');
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
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTORESCOBRAORD sgt on rea.SegtoPrograID = sgt.SegtoPrograID
																				and rea.SegtoPrograID=sgt.SegtoPrograID
																				and rea.SegtoRealizaID=sgt.SegtoRealizaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec on rea.RecomendacionSegtoID = rec.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec2 on rea.SegdaRecomendaSegtoID = rec2.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORESULTADOS res on rea.ResultadoSegtoID = res.ResultadoSegtoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN TIPOGESTION tip on cat.TipoGestionID = tip.TipoGestionID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE seg.FechaProgramada BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ');

    IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
    IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
	IF(IFNULL(Par_TipoGestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND tip.TipoGestorID = ', Par_TipoGestorID);
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
    SET Var_Sentencia :=CONCAT(Var_Sentencia,' ORDER BY rea.SegtoRealizaID DESC) EFICACIA ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia,' GROUP BY SegtoPrograID, FechaPromPago, MontoPromPago, FechaSegto, SegtoRealizaID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ') UNION (');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'SELECT * FROM (SELECT seg.SegtoPrograID, DATE_FORMAT(seg.FechaRegistro, "%Y-%m-%d") as FechaRegistro, seg.CreditoID, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cli.NombreCompleto, seg.GrupoID, grp.NombreGrupo, DATE_FORMAT(seg.FechaProgramada, "%Y-%m-%d") as FechaProgramada, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.HoraProgramada, seg.CategoriaID, cat.Descripcion as DescripcionCategoria, tip.TipoGestionID,tip.Descripcion as DescripcionGestores, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.PuestoSupervisorID, usu2.NombreCompleto as NombreSupervisor, time(now()) as HoraEmision, seg.TipoGeneracion, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaInicioSegto, "%Y-%m-%d") as FechaInicioSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'DATE_FORMAT(seg.FechaFinalSegto, "%Y-%m-%d") as FechaFinalSegto, sgt.FechaPromPago,sgt.MontoPromPago, rea.FechaSegto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.Estatus, seg.EsForzado, rea.SegtoRealizaID, DATE_FORMAT(rea.FechaCaptura, "%Y-%m-%d") as FechaCaptura, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'rea.Comentario, rea.ResultadoSegtoID, res.Descripcion as Resultado, rea.RecomendacionSegtoID, rec.Descripcion as Recomendacion1, rea.SegdaRecomendaSegtoID, rec2.Descripcion as Recomendacion2, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'CASE WHEN cre.Estatus = "I" THEN "INACTIVO"  WHEN cre.Estatus = "A" THEN "AUTORIZADO"  WHEN cre.Estatus = "V" THEN "VIGENTE" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "P" THEN "PAGADO"  WHEN cre.Estatus = "C" THEN "CANCELADO" WHEN cre.Estatus = "B" THEN "VENCIDO" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHEN cre.Estatus = "K" THEN "CASTIGADO" ELSE "" END AS EstatusCredito, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(min(Amo.FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(min(Amo.FechaExigible))end)');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Amo.creditoID=cre.CreditoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <="',Var_FechaSistema,'"');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.Estatus != "',Estatus_Pagado, '") as FechaExigible, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia,'(select (case when ifnull(min(FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'else ( datediff("',Var_FechaSistema,'", min(FechaExigible)))  end) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '  from AMORTICREDITO Amo ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' where Amo.CreditoID = cre.CreditoID');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, " and Amo.Estatus != '",Estatus_Pagado,"'");
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <= "',Var_FechaSistema,'")as DiasAtraso, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (case when ifnull(max(Det.AmortizacionID),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(max(Det.AmortizacionID)) end)');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID) as Amortizacion, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.FechaPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(DATE_FORMAT(MAX(Det.FechaPago),"%Y-%m-%d")) end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as FechaUltimoPago, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select(case when ifnull(max(Det.MontoTotPago),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' else(MAX(Det.MontoTotPago))end) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from DETALLEPAGCRE Det ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Det.creditoID=cre.CreditoID and Det.AmortizacionID=Amortizacion and Det.FechaPago = FechaUltimoPago ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	order by Det.AmortizacionID DESC  limit 1)as MontoTotalPagado ');
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
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTORESCOBRAORD sgt on rea.SegtoPrograID = sgt.SegtoPrograID
																				and rea.SegtoPrograID=sgt.SegtoPrograID
																				and rea.SegtoRealizaID=sgt.SegtoRealizaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec on rea.RecomendacionSegtoID = rec.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORECOMENDAS rec2 on rea.SegdaRecomendaSegtoID = rec2.RecomendacionSegtoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SEGTORESULTADOS res on rea.ResultadoSegtoID = res.ResultadoSegtoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN TIPOGESTION tip on cat.TipoGestionID = tip.TipoGestionID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE rea.FechaSegto BETWEEN "',Par_FechaIniSeg,'" AND "',Par_FechaFinSeg,'" ');

    IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
    IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
	IF(IFNULL(Par_TipoGestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND tip.TipoGestionID = ', Par_TipoGestorID);
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

	SET Var_Sentencia :=CONCAT(Var_Sentencia,' ORDER BY rea.SegtoRealizaID DESC) EFICACIA ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia,' GROUP BY SegtoPrograID, FechaPromPago, MontoPromPago, FechaSegto, SegtoRealizaID');
    SET Var_Sentencia :=CONCAT(Var_Sentencia,' ORDER BY SegtoPrograID ASC); ');


    -- select Var_Sentencia;
    SET @Sentencia	= (Var_Sentencia);

    PREPARE STSEGTOEFICACIAREP FROM @Sentencia;
    EXECUTE STSEGTOEFICACIAREP;
    DEALLOCATE PREPARE STSEGTOEFICACIAREP;

    END IF;
END TerminaStore$$
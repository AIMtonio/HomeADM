-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUIMIENTOFORMREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUIMIENTOFORMREP`;
DELIMITER $$


CREATE PROCEDURE `SEGUIMIENTOFORMREP`(
	Par_FechaInicio     DATE,
    Par_FechaFin        DATE,
    Par_CategoriaID     INT,
    Par_SucursalID      INT,
    Par_GestorID        INT,
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

    -- Declaracion de Constantes
    DECLARE	Cadena_Vacia		CHAR(1);
    DECLARE	Fecha_Vacia			DATE;
    DECLARE	Entero_Cero			INT;
	DECLARE Var_FechaSistema	DATE;
	DECLARE Estatus_Pagado		CHAR(1);
	DECLARE Rep_Principal  		INT(11);
	DECLARE Rep_TabNopago   	INT(11);
	DECLARE Rep_TabResul    	INT(11);
	DECLARE Rep_TabRecom    	INT(11);


	-- Declaracion de Variables
    DECLARE Var_Sentencia		TEXT(80000);
	DECLARE Var_FechaVencim		DATE;
	DECLARE Var_Descripcion 	VARCHAR(500);
	DECLARE Var_NumRegTemporal  INT(11);
	DECLARE contador            INT(11);
    DECLARE limiteTabla         INT(11);
	DECLARE CURSORNOPAGO CURSOR FOR
	SELECT Descripcion
		FROM SEGTOMOTIVNOPAGO;

	DECLARE CURSORRESULTADO CURSOR FOR
	SELECT Descripcion
		FROM SEGTORESULTADOS;

	DECLARE CURSORRECOMENDACION CURSOR FOR
	SELECT Descripcion
		FROM SEGTORECOMENDAS;

	-- Asignacion de Constantes
    SET	Cadena_Vacia    := '';            -- Cadena Vacia
    SET	Fecha_Vacia     := '1900-01-01';  -- Fecha_Vacia
    SET	Entero_Cero     := 0;             -- Entero Cero
	SET contador        := 0;             -- Contador
	SET Estatus_Pagado  := 'P';           -- Estatus Pagado
    SET Rep_Principal   := 1;             -- Reporte Principal
	SET Rep_TabNopago   := 2;             -- Reporte para obtener el catalogo de motivo no pago
	SET Rep_TabResul    := 3;             -- Reporte para obtener el catalogo de resultados
    SET Rep_TabRecom    := 4;             -- Reporte para obtener el catalogo de recomendaciones

IF(Par_NumeroReporte = Rep_Principal) THEN
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_Sentencia :=' (SELECT seg.SegtoPrograID, seg.CreditoID,seg.GrupoID, grp.NombreGrupo, seg.FechaProgramada, sol.Proyecto, ';
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'seg.CategoriaID, cat.Descripcion, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'suc.SucursalID, suc.NombreSucurs, cli.NombreCompleto,dir.DireccionCompleta,cli.Telefono, cli.TelefonoCelular, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cre.MontoCredito as Monto,cre.FechaInicio as Inicio, cre.FechaVencimien as Vencimiento, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'cre.SaldoCapVigent, cre.SaldoCapAtrasad, (cre.SaldoCapVencido + cre.SaldCapVenNoExi) as SaldoVencido, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(round(cre.SaldoCapVigent,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoCapAtrasad,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoCapVencido,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldCapVenNoExi,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoInterOrdin,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoInterAtras,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoInterVenc,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoInterProvi,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoIntNoConta,2) ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoMoratorios + cre.SaldoMoraVencido +cre.SaldoMoraCarVen,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldComFaltPago,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoComServGar,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoOtrasComis,2) )');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '  as SaldoTotal, '); -- Saldo Total
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (min(Amo.FechaExigible))');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from AMORTICREDITO Amo');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Amo.creditoID=cre.CreditoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <="',Var_FechaSistema,'"');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.Estatus != "',Estatus_Pagado, '") as FechaExigible, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia,'(select (case when ifnull(min(FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'else ( datediff("',Var_FechaSistema,'", min(FechaExigible)))  end) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '  from AMORTICREDITO Amo');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' where Amo.CreditoID = cre.CreditoID');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, " and Amo.Estatus != '",Estatus_Pagado,"'");
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <= "',Var_FechaSistema,'")as DiasAtraso ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'FROM SEGTOPROGRAMADO seg ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTOCATEGORIAS cat on seg.CategoriaID = cat.CategoriaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN USUARIOS usu on seg.PuestoResponsableID = usu.UsuarioID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN CREDITOS cre on seg.CreditoID = cre.CreditoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SOLICITUDCREDITO sol on cre.CreditoID = sol.CreditoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN CLIENTES as cli on cli.ClienteID  = cre.ClienteID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN DIRECCLIENTE as dir on dir.ClienteID  = cli.ClienteID AND dir.Oficial="S" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SUCURSALES suc on cre.SucursalID = suc.SucursalID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN GRUPOSCREDITO grp on seg.GrupoID = grp.GrupoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE seg.FechaProgramada BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'AND seg.CreditoID > 0 ');
   IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
   IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
    IF(IFNULL(Par_SucursalID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND CASE WHEN seg.CreditoID = 0 THEN grp.SucursalID = ',Par_SucursalID,' ELSE cre.SucursalID = ',Par_SucursalID,' END     )');
    END IF;
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' UNION ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' (SELECT seg.SegtoPrograID, seg.CreditoID,seg.GrupoID, grp.NombreGrupo, seg.FechaProgramada, sol.Proyecto, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' seg.CategoriaID, cat.Descripcion, seg.PuestoResponsableID, usu.NombreCompleto as NombreResponsable, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' suc.SucursalID, suc.NombreSucurs, cli.NombreCompleto,dir.DireccionCompleta,cli.Telefono, cli.TelefonoCelular, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' sum(cre.MontoCredito) as Monto, cre.FechaInicio as Inicio, cre.FechaVencimien as Vencimiento, ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, ' sum(cre.SaldoCapVigent), sum(cre.SaldoCapAtrasad), (sum(cre.SaldoCapVencido + cre.SaldCapVenNoExi)) as SaldoVencido, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' sum(round(cre.SaldoCapVigent,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoCapAtrasad,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoCapVencido,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldCapVenNoExi,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoInterOrdin,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoInterAtras,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoInterVenc,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoInterProvi,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoIntNoConta,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoMoratorios + cre.SaldoMoraVencido +cre.SaldoMoraCarVen,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldComFaltPago,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoComServGar,2) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '   + round(cre.SaldoOtrasComis,2) )');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, '  as SaldoTotal, '); -- Saldo Total
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select (min(Amo.FechaExigible))');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	from AMORTICREDITO Amo');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '	where Amo.creditoID=cre.CreditoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible >="',Var_FechaSistema,'"');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.Estatus != "',Estatus_Pagado, '") as FechaExigible, ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia,'(select (case when ifnull(min(FechaExigible),"',Fecha_Vacia,'") = "',Fecha_Vacia,'" then 0 ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'else ( datediff("',Var_FechaSistema,'", min(FechaExigible)))  end) ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, '  from AMORTICREDITO Amo');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' where Amo.CreditoID = cre.CreditoID');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, " and Amo.Estatus != '",Estatus_Pagado,"'");
	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' and Amo.FechaExigible <= "',Var_FechaSistema,'")as DiasAtraso ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'FROM SEGTOPROGRAMADO seg  ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN SEGTOCATEGORIAS cat on seg.CategoriaID = cat.CategoriaID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'INNER JOIN USUARIOS usu on seg.PuestoResponsableID = usu.UsuarioID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN INTEGRAGRUPOSCRE ing on ing.GrupoID = seg.GrupoID ');
	SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SOLICITUDCREDITO sol on sol.SolicitudCreditoID = ing.SolicitudCreditoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN CLIENTES as cli on cli.ClienteID = ing.ClienteID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN CREDITOS cre on cre.CreditoID = sol.CreditoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN PRODUCTOSCREDITO pro on pro.ProducCreditoID = cre.ProductoCreditoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN DIRECCLIENTE as dir on dir.ClienteID  = cli.ClienteID AND dir.Oficial="S" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN SUCURSALES suc on cre.SucursalID = suc.SucursalID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'LEFT JOIN GRUPOSCREDITO grp on seg.GrupoID = grp.GrupoID ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'WHERE seg.FechaProgramada BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ');
    SET Var_Sentencia :=CONCAT(Var_Sentencia, 'AND seg.GrupoID >0 ');

    IF(IFNULL(Par_CategoriaID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.CategoriaID = ', Par_CategoriaID);
    END IF;
   IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND seg.PuestoResponsableID = ', Par_GestorID);
    END IF;
    IF(IFNULL(Par_SucursalID, Entero_Cero) != Entero_Cero) THEN
        SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND CASE WHEN seg.CreditoID = 0 THEN grp.SucursalID = ',Par_SucursalID,' ELSE cre.SucursalID = ',Par_SucursalID,' END )');
    END IF;
    SET Var_Sentencia := CONCAT(Var_Sentencia,';');


 -- select Var_Sentencia;
	SET @Sentencia	= (Var_Sentencia);

    PREPARE STFORMSEGTOREP FROM @Sentencia;
    EXECUTE STFORMSEGTOREP;
    DEALLOCATE PREPARE STFORMSEGTOREP;
 END IF;

-- Leer la Descripcion del catalogo de la tabla SEGTOMOTIVNOPAGO
IF(Par_NumeroReporte = Rep_TabNopago) THEN
-- Creacion de Tabla Temporal
DROP TABLE IF EXISTS  TMNOPAGO;
CREATE TEMPORARY TABLE TMNOPAGO(
	Folio				INT AUTO_INCREMENT,
    Tmp_Descripcion   VARCHAR(500),
	Tmp_Descripcion2  VARCHAR(500),
    Tmp_Descripcion3   VARCHAR(500) ,
	PRIMARY KEY (Folio)
);
-- Apertura del Cursor
OPEN CURSORNOPAGO;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSORNOPAGO INTO
		Var_Descripcion;

	SET limiteTabla := (SELECT COUNT(*) FROM SEGTOMOTIVNOPAGO);

	IF contador = 3 THEN
		SET contador = 0;
	END IF;
	IF(contador = 0)THEN
			INSERT INTO TMNOPAGO  (Tmp_Descripcion) VALUES (CONCAT("___",Var_Descripcion));

			SET	Var_NumRegTemporal := (SELECT MAX(Folio) FROM TMNOPAGO);
			SET	Var_NumRegTemporal := IFNULL(Var_NumRegTemporal, 0);
	END IF;
	IF(contador = 1)THEN
			UPDATE TMNOPAGO
			SET Tmp_Descripcion2 = (CONCAT("___",Var_Descripcion))
			WHERE Folio = Var_NumRegTemporal;
	END IF;
	IF(contador = 2)THEN
			UPDATE TMNOPAGO
			SET Tmp_Descripcion3 = (CONCAT("___",Var_Descripcion))
			WHERE Folio = Var_NumRegTemporal;
	END IF;
	SET contador = contador + 1;

	END LOOP;
END;
	-- Cierre del Cursor
	CLOSE CURSORNOPAGO;
	SELECT Tmp_Descripcion,Tmp_Descripcion2,Tmp_Descripcion3
			FROM TMNOPAGO;
		DROP TABLE IF EXISTS TMNOPAGO;
 END IF;

-- Leer la Descripcion del catalogo de la tabla SEGTORESULTADOS
IF(Par_NumeroReporte = Rep_TabResul) THEN
-- Creacion de Tabla Temporal
DROP TABLE IF EXISTS  TMRESULTADO;
CREATE TEMPORARY TABLE TMRESULTADO(
	Folio				INT AUTO_INCREMENT,
    Tmp_Descripcion  	VARCHAR(500),
	Tmp_Descripcion2    VARCHAR(500),
	PRIMARY KEY (Folio)
);

-- Apertura del Cursor
OPEN CURSORRESULTADO;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSORRESULTADO INTO
		Var_Descripcion;

	SET limiteTabla := (SELECT COUNT(*) FROM SEGTORESULTADOS);

	IF contador = 2 THEN
		SET contador = 0;
	END IF;
IF(contador = 0)THEN
			INSERT INTO TMRESULTADO  (Tmp_Descripcion) VALUES (CONCAT("___",Var_Descripcion));

			SET	Var_NumRegTemporal := (SELECT MAX(Folio) FROM TMRESULTADO);
			SET	Var_NumRegTemporal := IFNULL(Var_NumRegTemporal, 0);
	END IF;
	IF(contador = 1)THEN
			UPDATE TMRESULTADO
			SET Tmp_Descripcion2 = (CONCAT("___",Var_Descripcion))
			WHERE Folio = Var_NumRegTemporal;
	END IF;
	SET contador = contador + 1;

	END LOOP;
END;
	-- Cierre del Cursor
	CLOSE CURSORRESULTADO;
	SELECT Tmp_Descripcion,Tmp_Descripcion2
			FROM TMRESULTADO;
		DROP TABLE IF EXISTS TMRESULTADO;

 END IF;

-- Leer la Descripcion del catalogo de la tabla SEGTORECOMENDAS
IF(Par_NumeroReporte = Rep_TabRecom) THEN
-- Creacion de Tabla Temporal
DROP TABLE IF EXISTS  TMRECOMENDACION;
CREATE TEMPORARY TABLE TMRECOMENDACION(
	Folio				INT AUTO_INCREMENT,
    Tmp_Descripcion  	VARCHAR(500),
	Tmp_Descripcion2    VARCHAR(500),
	PRIMARY KEY (Folio)
);

-- Apertura del Cursor
OPEN CURSORRECOMENDACION;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSORRECOMENDACION INTO
		Var_Descripcion;

	SET limiteTabla := (SELECT COUNT(*) FROM SEGTORECOMENDAS);

	IF contador = 2 THEN
		SET contador = 0;
	END IF;
IF(contador = 0)THEN
			INSERT INTO TMRECOMENDACION  (Tmp_Descripcion) VALUES (CONCAT("___",Var_Descripcion));

			SET	Var_NumRegTemporal := (SELECT MAX(Folio) FROM TMRECOMENDACION);
			SET	Var_NumRegTemporal := IFNULL(Var_NumRegTemporal, 0);
	END IF;
	IF(contador = 1)THEN
			UPDATE TMRECOMENDACION
			SET Tmp_Descripcion2 = (CONCAT("___",Var_Descripcion))
			WHERE Folio = Var_NumRegTemporal;
	END IF;
	SET contador = contador + 1;

	END LOOP;
END;
	-- Cierre del Cursor
	CLOSE CURSORRECOMENDACION;
	SELECT Tmp_Descripcion,Tmp_Descripcion2
			FROM TMRECOMENDACION;
		DROP TABLE IF EXISTS TMRECOMENDACION;

 END IF;
END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EMISIONNOTICOBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMISIONNOTICOBLIS`;DELIMITER $$

CREATE PROCEDURE `EMISIONNOTICOBLIS`(
	/* SP PARA LA LISTA DE CREDITOS DE LA PANTALLA EMISION DE NOTIFICACIONES   */
    Par_SucursalID		INT(11),				-- Sucursal
    Par_EstCredBus		VARCHAR(10),			-- Estatus credito(V=Vigente, B=Vencido, ambos)
    Par_EstadoID		INT(11),				-- ID del estado
	Par_DiaAtrasoIni	INT(11),				-- Dias de atraso inicial
	Par_MunicipioID		INT(11),				-- ID del municipio

    Par_DiaAtrasoFin	INT(11),				-- Dias de atraso final
	Par_LocalidadID		INT(11),				-- ID de la localidad
    Par_LimRenglones	INT(11),				-- Limite de renglones disponibles
	Par_ColoniaID		INT(11),				-- ID de la colonia
    Par_NumLis			TINYINT UNSIGNED,		-- Numero de lista

	Par_EmpresaID		INT(11),				-- Parametros de auditoria --
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables

	DECLARE	FechaSist			DATE;
    DECLARE Var_FechaCorte		DATE;
	DECLARE Var_Sentencia		VARCHAR(6000);	-- Sentencia SQL

	-- Declaracion de constantes
    DECLARE Lis_Creditos		INT(11);

	DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_VigenteDes		CHAR(15);
	DECLARE Est_Vencido			CHAR(1);
	DECLARE Est_VencidoDes		CHAR(15);

    DECLARE Entero_Cero			INT(11);
    DECLARE Cadena_Vacia		CHAR(1);
    DECLARE Cons_Si				CHAR(1);
    DECLARE Cons_No				CHAR(1);
    DECLARE Fecha_Vacia			DATE;

    -- Asignacion de constantes
    SET Lis_Creditos			:= 1;

	SET Est_Vigente				:= 'V';
	SET Est_VigenteDes			:= 'VIGENTE';
	SET Est_Vencido				:= 'B';
	SET Est_VencidoDes			:= 'VENCIDO';

    SET Entero_Cero				:= 0;
    SET Cadena_Vacia			:= '';
    SET Cons_Si					:= 'S';
    SET Cons_No					:= 'N';
    SET Fecha_Vacia				:= '1900-01-01';

	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_FechaCorte :=	(SELECT MAX(FechaCorte) FROM SALDOSCREDITOS);			-- Obtenemos la ultima fecha de corte de SALDOSCREDITOS


	/*TABLA TEMPORAL DE CREDITOS */
		DROP TABLE IF EXISTS TMPEMISIONCREDITOS;
		CREATE TEMPORARY TABLE TMPEMISIONCREDITOS(
			ClienteID			BIGINT(12),
            NombreCompleto		VARCHAR(200),
            SucursalID			INT(11),
            NombreSucursal		VARCHAR(200),
            LocalidadID			INT(11),

            NombreLocalidad		VARCHAR(200),
			CreditoID			BIGINT(12),
            ProducCreditoID		INT(11),
            ProductoCred		VARCHAR(100),
			SaldoTotalCap		DECIMAL(16,2),
            DiasAtraso			INT(11),

			EstatusCredito		VARCHAR(100),
            FrecuenPagoCap		VARCHAR(30),
            EtiquetaEtapa		VARCHAR(10),
            FormatoID			INT(11),
            NombreFormato		VARCHAR(150),

			Emitir				CHAR(1),
            FechaCita			VARCHAR(10),
            HoraCita			VARCHAR(10),
            SolicitudCreditoID	BIGINT(12),

            EstadoID			INT(11),
            MunicipioID			INT(11)
            );

	IF(Par_NumLis = Lis_Creditos) THEN

        SET Var_Sentencia := CONCAT("INSERT INTO TMPEMISIONCREDITOS(
					ClienteID,     		SucursalID,            	LocalidadID,			CreditoID,     			DiasAtraso,
					SaldoTotalCap,   	EstatusCredito,			FrecuenPagoCap,			ProducCreditoID,		SolicitudCreditoID,
                    EstadoID,			MunicipioID
			)SELECT	cre.ClienteID, 		cre.SucursalID, 		dir.LocalidadID, 		cre.CreditoID,			salc.DiasAtraso,
                    IFNULL(SUM(amo.SaldoCapVigente	+ amo.SaldoCapAtrasa + amo.SaldoCapVencido	+ amo.SaldoCapVenNExi),",Entero_Cero,") AS totalCapital,
					CASE	WHEN cre.Estatus='",Est_Vencido,"' 	THEN 	'",Est_VencidoDes,"'
							WHEN cre.Estatus='",Est_Vigente,"' 	THEN 	'",Est_VigenteDes ,"' END AS EstatusCredi,
					CASE 	WHEN cre.FrecuenciaCap='S'	THEN	'SEMANAL'
							WHEN cre.FrecuenciaCap='C'	THEN	'CATORCENAL'
							WHEN cre.FrecuenciaCap='Q'	THEN	'QUINCENAL'
							WHEN cre.FrecuenciaCap='M'	THEN	'MENSUAL'
							WHEN cre.FrecuenciaCap='P'	THEN	'PERIODO'
							WHEN cre.FrecuenciaCap='B'	THEN	'BIMESTRAL'
							WHEN cre.FrecuenciaCap='T'	THEN	'TRIMESTRAL'
							WHEN cre.FrecuenciaCap='R'	THEN	'TETRAMESTRAL'
							WHEN cre.FrecuenciaCap='E'	THEN	'SEMESTRAL'
							WHEN cre.FrecuenciaCap='A'	THEN	'ANUAL'
							WHEN cre.FrecuenciaCap='U'	THEN	'UNICO'
							WHEN cre.FrecuenciaCap='L'	THEN	'LIBRES'	END AS Frecuencia, cre.ProductoCreditoID, cre.SolicitudCreditoID,
					dir.EstadoID, 		dir.MunicipioID
			FROM CREDITOS cre
					LEFT JOIN AMORTICREDITO amo
						ON cre.CreditoID = amo.CreditoID
					LEFT JOIN SALDOSCREDITOS salc
						ON cre.CreditoID = salc.CreditoID AND salc.FechaCorte = '",Var_FechaCorte,"'
					LEFT JOIN DIRECCLIENTE dir
						ON cre.ClienteID = dir.ClienteID AND dir.Oficial = 'S' ");

		-- Filtro por dias de atraso
		SET Var_Sentencia := CONCAT(Var_Sentencia, " WHERE salc.DiasAtraso >= ",Par_DiaAtrasoIni);

		IF(Par_DiaAtrasoFin > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND salc.DiasAtraso <= ",Par_DiaAtrasoFin);
		END IF;

        -- Filtro por estatus credito
		IF(IFNULL(Par_EstCredBus,Cadena_Vacia) <> Cadena_Vacia) THEN
			SET Par_EstCredBus := REPLACE(Par_EstCredBus, "-","','");
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND cre.Estatus IN('",Par_EstCredBus,"')");
		END IF;

        -- Filtro por sucursal donde se origino el credito
		IF(Par_SucursalID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND cre.SucursalID = ",Par_SucursalID);
		END IF;

        -- Filtro por estado
		IF(Par_EstadoID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND dir.EstadoID = ",Par_EstadoID);
		END IF;

        -- Filtro por municipio
		IF(Par_MunicipioID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND dir.MunicipioID = ",Par_MunicipioID);
		END IF;

        -- Filtro por localidad
		IF(Par_LocalidadID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND dir.LocalidadID = ",Par_LocalidadID);
		END IF;

        -- Filtro por colonia
		IF(Par_ColoniaID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND dir.ColoniaID = ",Par_ColoniaID);
		END IF;

        -- Agrupa por Credito
        SET Var_Sentencia := CONCAT(Var_Sentencia, " GROUP BY cre.ClienteID, cre.SucursalID, dir.LocalidadID, cre.CreditoID, salc.DiasAtraso, cre.Estatus,cre.FrecuenciaCap,cre.ProductoCreditoID, cre.SolicitudCreditoID, dir.EstadoID, dir.MunicipioID");

		-- Filtro por numero de renglones
    	IF(Par_LimRenglones > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " LIMIT ",Par_LimRenglones);
		END IF;

        SET Var_Sentencia := CONCAT(Var_Sentencia, " ;");

		SET @Sentencia	= (Var_Sentencia);

		PREPARE EMISIONNOTICOBLIS FROM @Sentencia;
		EXECUTE EMISIONNOTICOBLIS;
		DEALLOCATE PREPARE EMISIONNOTICOBLIS;

		-- SE ACTUALIZA EL CAMPO EMITIR DE TODOS LOS CREDITOS QUE YA SE EMITIO UNA NOTIFICACION Y SE ACTUALIZAN SUS CAMPOS
		UPDATE TMPEMISIONCREDITOS tmp,EMISIONNOTICOB det
				SET tmp.Emitir = Cons_Si,
					tmp.FechaCita = CASE WHEN det.FechaCita = Fecha_Vacia THEN Cadena_Vacia ELSE det.FechaCita END,
					tmp.HoraCita  = det.HoraCita
		WHERE tmp.CreditoID = det.CreditoID;

        UPDATE TMPEMISIONCREDITOS tmp
			SET tmp.FechaCita = Cadena_Vacia
		WHERE tmp.FechaCita IS NULL;

        UPDATE TMPEMISIONCREDITOS tmp
			SET tmp.HoraCita = Cadena_Vacia
		WHERE tmp.HoraCita IS NULL;

		-- SE ACTUALIZA TODOS LOS CREDITOS QUE AUN NO SE LES HA EMITIDO UNA NOTIFICACION
		UPDATE TMPEMISIONCREDITOS tmp
			SET tmp.Emitir = Cons_No
		WHERE tmp.Emitir is null;

		-- SE ACTUALZIA EN LA TABLA TEMPORAL EL NOMBRE COMPLETO DEL CLIENTE
		UPDATE TMPEMISIONCREDITOS tmp, CLIENTES	cli SET
			tmp.NombreCompleto =  cli.NombreCompleto
		WHERE tmp.ClienteID = cli.ClienteID;

		-- SE ACTUALIZA EL NOMBRE DE LA SUCURSAL
		UPDATE TMPEMISIONCREDITOS tmp, SUCURSALES suc SET
			tmp.NombreSucursal =  CONCAT(suc.SucursalID,'-',suc.NombreSucurs)
		WHERE tmp.SucursalID = suc.SucursalID;

		-- SE ACTUALIZA EL NOMBRE DE LA LOCALIDAD
		UPDATE TMPEMISIONCREDITOS tmp, LOCALIDADREPUB loc SET
			tmp.NombreLocalidad =  loc.NombreLocalidad
		WHERE tmp.LocalidadID = loc.LocalidadID
			AND tmp.EstadoID = loc.EstadoID
            AND tmp.MunicipioID = loc.MunicipioID;

		-- SE ACTUALIZA EL NOMBRE DEl PRODUCTO DEL CREDITO
		UPDATE TMPEMISIONCREDITOS tmp, PRODUCTOSCREDITO pro SET
			tmp.ProductoCred =  pro.Descripcion
		WHERE tmp.ProducCreditoID = pro.ProducCreditoID;

		-- SE ACTUALIZA EL ID DEL FORMATO DE NOTIFICACION QUE
		UPDATE TMPEMISIONCREDITOS tmp, ESQUEMANOTICOB esq SET
			tmp.EtiquetaEtapa 	= 	esq.EtiquetaEtapa,
            tmp.FormatoID		= 	esq.FormatoID
		WHERE tmp.DiasAtraso BETWEEN esq.DiasAtrasoIni AND esq.DiasAtrasoFin;

		-- SE ACTUALIZA LA DESCRIPCION DEL FORMATO, EL NOMBE DEL PRPT Y EL TIPO
		UPDATE TMPEMISIONCREDITOS tmp, FORMATONOTIFICACOB fnc SET
			tmp.Nombreformato =  fnc.Descripcion
		WHERE tmp.FormatoID = fnc.FormatoID;



    SELECT	ClienteID,			NombreCompleto,			SucursalID,			NombreSucursal,			NombreLocalidad,
			CreditoID,			ProductoCred,			SaldoTotalCap,		DiasAtraso,				EstatusCredito,
            FrecuenPagoCap,		EtiquetaEtapa,			NombreFormato,		Emitir,					FechaCita,
            HoraCita,			FormatoID,				SolicitudCreditoID
	FROM TMPEMISIONCREDITOS;

    END IF;

END TerminaStore$$
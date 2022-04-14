-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNACREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGNACREDITOLIS`;DELIMITER $$

CREATE PROCEDURE `ASIGNACREDITOLIS`(
	/* SP PARA LA LISTA DE CREDITOS DE LA PANTALLA ASIGNACION DE CARTERA   */
	Par_FolioAsigID		INT(11),				-- Id asignacion
	Par_DiaAtrasoMin	INT(11),				-- Dias de atraso minimo
    Par_DiaAtrasoMax	INT(11),				-- Dias de atraso maximo
    Par_AdeudoMin		DECIMAL(18,2),			-- Adeudo Minimo
    Par_AdeudoMax		DECIMAL(18,2),			-- Adeudo maximo

    Par_EstCredito		VARCHAR(10),			-- Estatus credito(V=Vigente, B=Vencido, K=Castigado, Todos)
    Par_SucursalID		INT(11),				-- Sucursal
    Par_EstadoID		INT(11),				-- ID del estado
	Par_MunicipioID		INT(11),				-- ID del municipio
	Par_LocalidadID		INT(11),				-- ID de la localidad

	Par_ColoniaID		INT(11),				-- ID de la colonia
    Par_LimRenglones	INT(11),				-- Limite de renglones disponibles
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

	-- Declaracion de constantes
    DECLARE Lis_Creditos		INT(11);
    DECLARE Lis_CredAsignacion	INT(11);
	DECLARE Var_Sentencia		VARCHAR(6000);	-- Sentencia SQL

	DECLARE Est_Inactivo		CHAR(1);
	DECLARE Est_InactivoDes		CHAR(15);
	DECLARE Est_Autorizado		CHAR(1);
	DECLARE Est_AutorizadoDes	CHAR(15);
	DECLARE Est_Pagado			CHAR(1);
	DECLARE Est_PagadoDes		CHAR(15);
	DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_VigenteDes		CHAR(15);
	DECLARE Est_Vencido			CHAR(1);
	DECLARE Est_VencidoDes		CHAR(15);
	DECLARE Est_Castigado		CHAR(1);
 	DECLARE Est_CastigadoDes	CHAR(15);
    DECLARE Entero_Cero			INT(11);
    DECLARE Cadena_Vacia		CHAR(1);
    DECLARE CredAsig_Si			CHAR(1);
    DECLARE CredAsig_No			CHAR(1);
    DECLARE Dir_Oficial			CHAR(1);

    -- Asignacion de constantes
    SET Lis_Creditos			:= 1;
    SET Lis_CredAsignacion		:= 2;
    SET Est_Inactivo			:= 'I';
	SET Est_InactivoDes			:= 'INACTIVO';
	SET Est_Autorizado			:= 'A';
	SET Est_AutorizadoDes		:= 'AUTORIZADO';
	SET Est_Pagado				:= 'P';
	SET Est_PagadoDes			:= 'PAGADO';
	SET Est_Vigente				:= 'V';
	SET Est_VigenteDes			:= 'VIGENTE';
	SET Est_Vencido				:= 'B';
	SET Est_VencidoDes			:= 'VENCIDO';
	SET Est_Castigado			:= 'K';
 	SET Est_CastigadoDes		:= 'CASTIGADO';
    SET Entero_Cero				:= 0;
    SET Cadena_Vacia			:= '';
    SET CredAsig_Si				:= 'S';
    SET CredAsig_No				:= 'N';
    SET Dir_Oficial				:= 'S';

	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);

	/*TABLA TEMPORAL QUE ALMACENARA LOS DIAS DE ATRASO Y LA FECHA PROXIMA DE PAGO QUE SE OBTIENEN CON FUNCIONES
    Y LAS DIRECCION OFICIAL DEL CLIENTE*/
    DROP TABLE IF EXISTS TMPDIASATRASOFECHAPAG;
		CREATE TEMPORARY TABLE TMPDIASATRASOFECHAPAG(
			CreditoID			BIGINT(12),
            DiasAtraso			INT(11),
            FechaProxVencim		VARCHAR(20),
            TotalAdeudo			DECIMAL(18,2),
			CredAsignado		CHAR(1),

            ClienteID			INT(11),
            EstadoID			INT(11),
            MunicipioID			INT(11),
            LocalidadID			INT(11),
            ColoniaID			INT(11)
        );

	/*TABLA TEMPORAL DE CREDITOS */
		DROP TABLE IF EXISTS TMPASIGNACREDITOS;
		CREATE TEMPORARY TABLE TMPASIGNACREDITOS(
			ClienteID			BIGINT,
            NombreCompleto		VARCHAR(200),
            SucursalID			INT(11),
            NombreSucursal		VARCHAR(200),
			CreditoID			BIGINT(12),

			EstatusCred			VARCHAR(100),
            DiasAtraso			INT(11),
			MontoCredito		DECIMAL(12,2),
			FechaDesembolso		DATE,
			FechaVencimien		DATE,

            FechaProxVencim		VARCHAR(20),
			SaldoCapital		DECIMAL(16,2),
			SaldoInteres		DECIMAL(16,2),
			SaldoMoratorio		DECIMAL(16,2),
			Asignado			CHAR(1),

            TotalAdeudo			DECIMAL(18,2)
            );

	IF(Par_NumLis = Lis_Creditos) THEN

		-- Guarda en tabla temporal los valores que se obtiene con funciones y el id de asignacion y la direccion oficial de los clientes q tiene creditos
		INSERT INTO TMPDIASATRASOFECHAPAG(
				CreditoID,	DiasAtraso, FechaProxVencim, TotalAdeudo, ClienteID,
                EstadoID,	MunicipioID,	LocalidadID, 	ColoniaID
        )SELECT cre.CreditoID,
				FUNCIONDIASATRASO(cre.CreditoID,FechaSist) ,
						FNFECHAPROXPAG(cre.CreditoID),
							FUNCIONTOTDEUDACRE(cre.CreditoID),
								cre.ClienteID,
					dir.EstadoID,	dir.MunicipioID,	dir.LocalidadID,	dir.ColoniaID
			FROM CREDITOS cre
				LEFT JOIN DIRECCLIENTE dir
                ON cre.ClienteID = dir.ClienteID AND dir.Oficial = Dir_Oficial;

		-- Se actualizan el campo CredAsignado de todos los creditos que ya se encuentran asignados
		UPDATE TMPDIASATRASOFECHAPAG tmp
			LEFT JOIN DETCOBCARTERAASIG det
            ON tmp.CreditoID = det.CreditoID
				SET tmp.CredAsignado = det.CredAsignado
		WHERE det.CredAsignado = CredAsig_Si;

		-- Se actualiza todos los creditos que aun no han sido asignados
		UPDATE TMPDIASATRASOFECHAPAG tmp
			SET tmp.CredAsignado = CredAsig_No
		WHERE tmp.CredAsignado is null;


        SET Var_Sentencia := CONCAT("INSERT INTO TMPASIGNACREDITOS(
					ClienteID,     		SucursalID,            	NombreSucursal,			CreditoID,
					EstatusCred,	    DiasAtraso,				MontoCredito,			FechaDesembolso,		FechaVencimien,
					FechaProxVencim,	SaldoCapital,			SaldoInteres,			SaldoMoratorio,			Asignado,
                    TotalAdeudo
			)SELECT	cre.ClienteID, 		cre.SucursalID, 		CONCAT(suc.SucursalID,'-',suc.NombreSucurs),	cre.CreditoID,
			CASE	WHEN cre.Estatus='",Est_Vencido,"' 	THEN 	'",Est_VencidoDes,"'
					WHEN cre.Estatus='",Est_Vigente,"' 	THEN 	'",Est_VigenteDes ,"'
					WHEN cre.Estatus='",Est_Castigado,"' 	THEN 	'",Est_CastigadoDes,"' END
			AS EstatusCredito,	tmpdap.DiasAtraso,  cre.MontoCredito,	cre.FechaMinistrado AS FechaDesembolso, cre.FechaVencimien,
					tmpdap.FechaProxVencim,
                    IFNULL(SUM(amo.SaldoCapVigente	+ amo.SaldoCapAtrasa + amo.SaldoCapVencido	+ amo.SaldoCapVenNExi),",Entero_Cero,") AS totalCapital,
                    IFNULL(SUM(amo.SaldoInteresPro + amo.SaldoInteresAtr + amo.SaldoInteresVen + amo.SaldoIntNoConta),",Entero_Cero,") AS SaldoInteres,
                    IFNULL(SUM(amo.SaldoMoratorios + amo.SaldoMoraVencido),",Entero_Cero,") AS SaldoMoratorios,
                    tmpdap.CredAsignado,
                    tmpdap.TotalAdeudo
			FROM CREDITOS cre
					LEFT JOIN AMORTICREDITO amo
						ON cre.CreditoID = amo.CreditoID
					LEFT JOIN TMPDIASATRASOFECHAPAG tmpdap
						ON cre.CreditoID = tmpdap.CreditoID
					LEFT JOIN SUCURSALES suc
						ON cre.SucursalID = suc.SucursalID
				WHERE tmpdap.CredAsignado <> 'S' ");
		-- Filtro por dias de atraso
		SET Var_Sentencia := CONCAT(Var_Sentencia, " AND tmpdap.DiasAtraso >= ",Par_DiaAtrasoMin);

		IF(Par_DiaAtrasoMax > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND tmpdap.DiasAtraso <= ",Par_DiaAtrasoMax);
		END IF;

		-- Filtro por adeudo total
		IF(Par_AdeudoMin > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND tmpdap.TotalAdeudo >= ",Par_AdeudoMin);
		END IF;

		IF(Par_AdeudoMax > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND tmpdap.TotalAdeudo <= ",Par_AdeudoMax);
		END IF;

        -- Filtro por estatus credito
		IF(IFNULL(Par_EstCredito,Cadena_Vacia) <> Cadena_Vacia) THEN
			SET Par_EstCredito := REPLACE(Par_EstCredito, "-","','");
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND cre.Estatus IN('",Par_EstCredito,"')");
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND cre.Estatus IN('",Est_Vigente,"','",Est_Vencido,"','",Est_Castigado,"') ");
		END IF;

        -- Filtro por sucursal donde se origino el credito
		IF(Par_SucursalID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND cre.SucursalID = ",Par_SucursalID);
		END IF;

        -- Filtro por estado
		IF(Par_EstadoID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND tmpdap.EstadoID = ",Par_EstadoID);
		END IF;

        -- Filtro por municipio
		IF(Par_MunicipioID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND tmpdap.MunicipioID = ",Par_MunicipioID);
		END IF;

        -- Filtro por localidad
		IF(Par_LocalidadID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND tmpdap.LocalidadID = ",Par_LocalidadID);
		END IF;

        -- Filtro por colonia
		IF(Par_ColoniaID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND tmpdap.ColoniaID = ",Par_ColoniaID);
		END IF;

        -- Agrupa por Credito
        SET Var_Sentencia := CONCAT(Var_Sentencia, " GROUP BY amo.CreditoID, 		cre.ClienteID, 		cre.SucursalID,
															  cre.CreditoID, 		tmpdap.DiasAtraso,  cre.MontoCredito,
															  cre.FechaMinistrado, 	cre.FechaVencimien,	tmpdap.FechaProxVencim,
															  tmpdap.CredAsignado, 	tmpdap.TotalAdeudo,	cre.Estatus");

		-- Filtro por numero de renglones
    	IF(Par_LimRenglones > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " LIMIT ",Par_LimRenglones);
		END IF;

        SET Var_Sentencia := CONCAT(Var_Sentencia, " ;");

		SET @Sentencia	= (Var_Sentencia);

		PREPARE ASIGNACREDITOLIS FROM @Sentencia;
		EXECUTE ASIGNACREDITOLIS;
		DEALLOCATE PREPARE ASIGNACREDITOLIS;

		-- SE ACTUALZIA EN LA TABLA TEMPORAL EL NOMBRE COMPLETO DEL CLIENTE
		UPDATE TMPASIGNACREDITOS tmp, CLIENTES	cli SET
			tmp.NombreCompleto =  cli.NombreCompleto
		WHERE tmp.ClienteID = cli.ClienteID;

		-- SE ACTUALIZA EL NOMBRE DE LA SUCURSAL
		UPDATE TMPASIGNACREDITOS tmp, SUCURSALES suc SET
			tmp.NombreSucursal =  CONCAT(suc.SucursalID,'-',suc.NombreSucurs)
		WHERE tmp.SucursalID = suc.SucursalID;

    SELECT	ClienteID,   		NombreCompleto,  		SucursalID,				NombreSucursal,         CreditoID,
			EstatusCred,	    DiasAtraso,				MontoCredito,			FechaDesembolso,		FechaVencimien,
			FechaProxVencim,	SaldoCapital,			SaldoInteres,			SaldoMoratorio,			Asignado
	FROM TMPASIGNACREDITOS;

    END IF;


    -- Lista creditos en una asignacion
    IF(Par_NumLis = Lis_CredAsignacion) THEN

		SELECT	detc.ClienteID,		detc.NombreCompleto,	detc.SucursalID,		CONCAT(detc.SucursalID,"-",suc.NombreSucurs) AS NombreSucursal,		detc.CreditoID,
				CASE	WHEN detc.EstatusCred=Est_Vencido 	THEN 	Est_VencidoDes
						WHEN detc.EstatusCred=Est_Vigente 	THEN 	Est_VigenteDes
						WHEN detc.EstatusCred=Est_Castigado THEN 	Est_CastigadoDes END
				AS EstatusCred,		detc.DiasAtraso,		detc.MontoCredito,		detc.FechaDesembolso,	detc.FechaVencimien,
				FNFECHAPROXPAG(detc.CreditoID) AS FechaProxVencim,detc.SaldoCapital,detc.SaldoInteres,		detc.SaldoMoratorio,	detc.CredAsignado AS Asignado
		FROM DETCOBCARTERAASIG detc
		LEFT JOIN SUCURSALES suc
			ON detc.SucursalID = suc.SucursalID
		WHERE detc.FolioAsigID = Par_FolioAsigID;

    END IF;

END TerminaStore$$
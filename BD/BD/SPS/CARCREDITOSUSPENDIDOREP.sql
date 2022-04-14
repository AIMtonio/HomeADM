
-- CARCREDITOSUSPENDIDOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARCREDITOSUSPENDIDOREP`;
DELIMITER $$

CREATE PROCEDURE `CARCREDITOSUSPENDIDOREP`(
	-- SP para generar el reporte de creditos suspendidos
    Par_FechaInicial        DATE,			-- Fecha inicial
    Par_FechaFinal          DATE,			-- Fecha final
    Par_SucursalID          INT(11),		-- ID de la sucursal
    Par_ProductoCreditoID   INT(11),		-- ID del producto credito

    Par_EmpresaID		    INT(11),		-- Parametro de auditoria
	Aud_Usuario        	    INT(11),		-- Parametro de auditoria
	Aud_FechaActual    	    DATE,			-- Parametro de auditoria
	Aud_DireccionIP    	    VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID     	    VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal       	    INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion      BIGINT(20)		-- Parametro de auditoria
)
TerminaStore: BEGIN
	/*DECLARACION DE VARIABLES */
	DECLARE Var_Sentencia       VARCHAR(10000);    -- Alamacena la consulta a ejecuta

	/*DECLARACION DE CONSTANTES */
    DECLARE Cadena_Vacia        VARCHAR(20);
	DECLARE Entero_Cero         INT(11);
	DECLARE Estatus_Vig         CHAR(1);
	DECLARE Estatus_Pag         CHAR(1);
    DECLARE Estatus_R			CHAR(1);
	DECLARE Cadena_Cero         CHAR(1);
	DECLARE	Decimal_Cero		DECIMAL(12,2);		-- Decimal vacio

	/* ASIGNACION  DE CONSTANTES */
	SET	Entero_Cero		        := 0;  		-- Constante entero cero
	SET Cadena_Vacia            := ''; 		-- Cadena vacia
	SET Estatus_Vig		        :='N'; 		-- Estatus vigente
	SET Estatus_Pag		        :='P'; 		-- Estatus pagado
    SET Estatus_R				:='R';		-- Estatus Registrado
	SET Cadena_Cero				:='0'; 		-- Cadena cero
    SET Decimal_Cero			:= 0.0;		-- Asignacion de Decima Vacio

	DROP TEMPORARY TABLE IF EXISTS TMPCARCREDITOSUSP;
    CREATE TEMPORARY TABLE TMPCARCREDITOSUSP(
	   ConsecutivoID		INT(11) NOT NULL AUTO_INCREMENT,
	   CreditoID			BIGINT(12),
	   ClienteID			INT(11),
	   NombreCompleto		VARCHAR(200),
       ProductoCred			VARCHAR(100),
       NombreGrupo			VARCHAR(200),
       MontoOriginal		DECIMAL(18,2),
       FechaDesembolso		DATE,
       FechaSuspension		DATE,
       FechaDefuncion		DATE,
       FolioActa			VARCHAR(20),
       CapitalDet			DECIMAL(18,2),
       InteresDet			DECIMAL(12,2),
       MoratorioDet			DECIMAL(12,2),
       ComisionDet			DECIMAL(12,2),
       TotalDet				DECIMAL(12,2),
       PagosDet				DECIMAL(12,2),
       CondonacionesDet		DECIMAL(12,2),
       RecuperarDet			DECIMAL(12,2),
	   MontoNotasCargo      DECIMAL(12,2),
	   PRIMARY KEY (`ConsecutivoID`));

    DROP TEMPORARY TABLE IF EXISTS TMPCARCREDITOSUSPCOND;
    CREATE TEMPORARY TABLE TMPCARCREDITOSUSPCOND(
	   CreditoID			BIGINT(12),
	   Condonaciones		DECIMAL(12,2));

	DROP TEMPORARY TABLE IF EXISTS TMPCARCREDITOSUSPPAG;
    CREATE TEMPORARY TABLE TMPCARCREDITOSUSPPAG(
	   CreditoID			BIGINT(12),
	   PagoCred				DECIMAL(12,2));

    SET Var_Sentencia := ('INSERT INTO TMPCARCREDITOSUSP (	CreditoID, ClienteID, NombreCompleto, ProductoCred, NombreGrupo,
															MontoOriginal, FechaDesembolso, FechaSuspension, FechaDefuncion, FolioActa,
                                                            CapitalDet, InteresDet, MoratorioDet, ComisionDet, TotalDet, PagosDet,
                                                            CondonacionesDet, RecuperarDet, MontoNotasCargo)');
	-- QUITAR EL VALOR QUEMADO DEL CREDITO-- SOLO SE USA PARA LAS PRUEBAS
	SET Var_Sentencia := CONCAT(Var_Sentencia,' SELECT	CC.CreditoID,CL.ClienteID,CL.NombreCompleto,PC.Descripcion,IFNULL(''N/A'',GC.NombreGrupo),CR.MontoCredito,
														CR.FechaMinistrado,CC.FechaSuspencion,CC.FechaDefuncion,CC.FolioActa,CC.TotalSalCapital,
                                                        CC.TotalSalInteres,CC.TotalSalMoratorio,CC.TotalSalComisiones,CC.TotalAdeudo,',Decimal_Cero,','
                                                        ,Decimal_Cero,',',Decimal_Cero, ', IFNULL((CR.SaldoNotCargoSinIVA +  CR.SaldoNotCargoConIVA + CR.SaldoNotCargoRev),0.00) AS MontoNotasCargo');
	SET Var_Sentencia := CONCAT(Var_Sentencia,'	FROM CREDITOS AS CR ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CLIENTES AS CL ON CR.ClienteID = CL.ClienteID');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CARCREDITOSUSPENDIDO AS CC ON CR.CreditoID = CC.CreditoID');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO AS PC ON CR.ProductoCreditoID = PC.ProducCreditoID');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES AS SU ON CR.SucursalID = SU.SucursalID');

    SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN GRUPOSCREDITO GC ON CR.GrupoID = GC.GrupoID ');

    SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE FechaSuspencion BETWEEN "', Par_FechaInicial ,'" AND "', Par_FechaFinal,'"');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND CC.Estatus ="',Estatus_R,'"');
    SET Par_SucursalID:= IFNULL(Par_SucursalID, Entero_Cero);
    IF(IFNULL(Par_SucursalID, Entero_Cero) != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND SU.SucursalID =',CONVERT(Par_SucursalID,CHAR));
    END IF;

    IF(IFNULL(Par_ProductoCreditoID,Entero_Cero) != Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_Sentencia,' AND PC.ProducCreditoID=',CONVERT(Par_ProductoCreditoID,CHAR));
    END IF;
    SET @Sentencia	  = (Var_Sentencia);

	PREPARE CARCREDITOSUPREP FROM @Sentencia;
	EXECUTE CARCREDITOSUPREP;
    DEALLOCATE PREPARE CARCREDITOSUPREP;

    -- SE OBTIENE EL LOS PAGOS REALIZADOS DESPUES DE LA SUSPENDER DEL CREDITO
    INSERT INTO TMPCARCREDITOSUSPPAG(CreditoID,PagoCred)
    SELECT DP.CreditoID,sum(DP.MontoTotPago)
    FROM DETALLEPAGCRE DP
		INNER JOIN CARCREDITOSUSPENDIDO CC ON DP.CreditoID = CC.CreditoID
            WHERE DP.FechaPago >= CC.FechaSuspencion
                AND DP.NumTransaccion > CC.NumTransaccion
            GROUP BY DP.CreditoID;

    UPDATE TMPCARCREDITOSUSP
    INNER JOIN TMPCARCREDITOSUSPPAG
		ON TMPCARCREDITOSUSP.CreditoID = TMPCARCREDITOSUSPPAG.CreditoID
	SET TMPCARCREDITOSUSP.PagosDet = TMPCARCREDITOSUSPPAG.PagoCred;

    -- SE OBTIENE LAS CONDONACIONES REALIZADAS DESPUES DE SUSPENDER EL CREDITO
    INSERT INTO TMPCARCREDITOSUSPCOND (CreditoID, Condonaciones)
    SELECT CC.CreditoID,SUM(MontoComisiones) + SUM(MontoMoratorios) + SUM(MontoInteres) + SUM(MontoCapital) AS Condonaciones
    FROM CREQUITAS CR
    INNER JOIN CARCREDITOSUSPENDIDO CC ON CR.CreditoID = CC.CreditoID
        WHERE CR.FechaRegistro  >= CC.FechaSuspencion
            AND CR.NumTransaccion > CC.NumTransaccion
        GROUP BY CR.CreditoID;

    UPDATE TMPCARCREDITOSUSP
    INNER JOIN TMPCARCREDITOSUSPCOND
		ON TMPCARCREDITOSUSP.CreditoID = TMPCARCREDITOSUSPCOND.CreditoID
	SET TMPCARCREDITOSUSP.CondonacionesDet = TMPCARCREDITOSUSPCOND.Condonaciones;

	UPDATE TMPCARCREDITOSUSP Tmp
	INNER JOIN NOTASCARGO Nota ON Tmp.CreditoID = Nota.CreditoID
		SET
			Tmp.ComisionDet = (Tmp.ComisionDet - Tmp.MontoNotasCargo);


    -- SE ACTUALIZA EL VALOR POR RECUPERAR
    UPDATE TMPCARCREDITOSUSP
		SET RecuperarDet = (TotalDet-(PagosDet + CondonacionesDet));

    SELECT  ConsecutivoID,	CreditoID,			ClienteID,			NombreCompleto,		ProductoCred,
			NombreGrupo,	MontoOriginal,		FechaDesembolso,	FechaSuspension,	FechaDefuncion,
            FolioActa,		CapitalDet,			InteresDet,			MoratorioDet,		ComisionDet,
            TotalDet, 		PagosDet,			CondonacionesDet,	RecuperarDet,		MontoNotasCargo
	FROM TMPCARCREDITOSUSP;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECASTIGOSREP`;
DELIMITER $$

CREATE PROCEDURE `CRECASTIGOSREP`(
	Par_FechaInicio			DATE,			
	Par_FechaFin 			DATE,			
	Par_Sucursal			INT(11),		
	Par_Moneda				INT(11),		
	Par_ProductoCre			INT(11),		
	Par_Promotor   			INT,			
	Par_MotivoCastigoID		INT(11),		
	Par_InstitucionID 		INT(11), 		
    Par_ConvenioNominaID	BIGINT UNSIGNED, 

    Par_EmpresaID       	INT(11),		
    Aud_Usuario         	INT(11),		
    Aud_FechaActual     	DATETIME,		
    Aud_DireccionIP     	VARCHAR(15),	
    Aud_ProgramaID      	VARCHAR(50),	
    Aud_Sucursal        	INT(11),		
    Aud_NumTransaccion  	BIGINT(20)  	
)
TerminaStore:BEGIN

	
	DECLARE Var_Sentencia 			VARCHAR(60000);
	DECLARE Var_RestringeReporte	CHAR(1);
	DECLARE Var_UsuDependencia		VARCHAR(1000);

	
	DECLARE Entero_Cero 	INT(11);
	DECLARE Cadena_Vacia 	CHAR(1);
	DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Con_NO			CHAR(1);
    DECLARE EsNomina        CHAR(1); 		
    DECLARE Cons_Si         CHAR(1); 		

	
	SET Entero_Cero 		:=0;
	SET Cadena_Vacia 		:='';
	SET Decimal_Cero		:=0.00;
	SET Con_NO				:='N';
    SET Cons_Si          	:= 'S';

	SET Par_Sucursal 		:= IFNULL(Par_Sucursal,Entero_Cero);
	SET Par_Moneda			:=IFNULL(Par_Moneda,Entero_Cero);
	SET Par_ProductoCre		:=IFNULL(Par_ProductoCre, Entero_Cero);
	SET Par_Promotor		:=IFNULL(Par_Promotor,Entero_Cero);
	SET Par_MotivoCastigoID	:=IFNULL(Par_MotivoCastigoID, Entero_Cero);

	SELECT	RestringeReporte
		INTO Var_RestringeReporte
	FROM PARAMETROSSIS LIMIT 1;
	SET Var_RestringeReporte:= IFNULL(Var_RestringeReporte,'N');
	SET EsNomina		:= (SELECT ProductoNomina 
								FROM PRODUCTOSCREDITO 
                                WHERE ProducCreditoID = Par_ProductoCre);
	SET EsNomina		:= IFNULL(EsNomina, Con_NO);
    
    DROP TABLE IF EXISTS TMPCRECASTIGOSREP;
	CREATE TEMPORARY TABLE TMPCRECASTIGOSREP(
		`CreditoID` 			bigint(12),
		`ClienteID` 			INT(11),
		`NombreCompleto` 		varchar(200),
		`ProductoCreditoID` 	INT(11),
		`Descripcion` 			varchar(100),
		`GrupoID` 				INT(11),
		`NombreGrupo` 			varchar(200),
		`MontoCredito` 			decimal(12,2),
		`Fecha` 				date ,
		`DesMotivoCastigo` 		varchar(150),
		`CapitalCastigado` 		decimal(14,2),
		`InteresCastigado` 		decimal(14,2),
		`TotalCastigo` 			decimal(14,2),
		`MonRecuperado`			decimal(14,2),
		`NombrePromotor` 		varchar(100),
		`NombreSucurs` 			varchar(50),
		`SucursalID` 			INT(11),
		`PromotorActual` 		INT(6),
		`MontoRecuperar` 		decimal(15,2),
		`FechaMinistrado` 		date,
		`HoraEmision` 			varchar(10),
		`IntMoraCastigado` 		decimal(14,2),
		`AccesorioCastigado` 	decimal(14,2),
		`ProductoNomina` 		char(1),
		`InstitucionNominaID` 	INT(11),
		`ConvenioNominaID` 		INT(11),
		`MontoNotasCargo`         decimal(14,2)
		);
        
	SET Var_Sentencia :=	"INSERT INTO TMPCRECASTIGOSREP (
									CreditoID,			ClienteID,			NombreCompleto,			ProductoCreditoID,			Descripcion,
									GrupoID,			NombreGrupo,		MontoCredito,			Fecha,						DesMotivoCastigo,
									CapitalCastigado,	InteresCastigado,	TotalCastigo,			MonRecuperado,				NombrePromotor,
									NombreSucurs,		SucursalID,			PromotorActual,			MontoRecuperar,				FechaMinistrado,
									HoraEmision,		IntMoraCastigado,	AccesorioCastigado,		ProductoNomina,				InstitucionNominaID,
									ConvenioNominaID,   MontoNotasCargo)
									";
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' Select Cre.CreditoID,Cre.ClienteID,  Cli.NombreCompleto, Cre.ProductoCreditoID,');
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' Pro.Descripcion,  Cre.GrupoID,IFNULL(Gru.NombreGrupo,"")as NombreGrupo,Cre.MontoCredito,Cas.Fecha,');
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' MoCas.Descricpion as DesMotivoCastigo, IFNULL(Cas.CapitalCastigado,0.00)as CapitalCastigado,');
    SET Var_Sentencia	:=CONCAT(Var_sentencia,' IFNULL(Cas.InteresCastigado,0.00)as InteresCastigado,IFNULL(Cas.TotalCastigo,0.00)as TotalCastigo,');
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' IFNULL(Cas.MonRecuperado,0.00)as MonRecuperado, Prom.NombrePromotor, Suc.NombreSucurs,Cre.SucursalID,');
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' Cli.PromotorActual, IFNULL((Cas.TotalCastigo - Cas.MonRecuperado),0.00) as MontoRecuperar, Cre.FechaMinistrado,');
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' convert(time(now()),char) as HoraEmision, ifnull(Cas.IntMoraCastigado,0.00) as IntMoraCastigado, ifnull(Cas.AccesorioCastigado,0.00) as AccesorioCastigado, Pro.ProductoNomina, ');
	IF(Par_ProductoCre!=0 AND EsNomina = Cons_Si)THEN
		SET Var_Sentencia :=	CONCAT(Var_Sentencia,' Nomi.InstitNominaID AS InstitucionNominaID, Nomi.ConvenioNominaID AS ConvenioNominaID, ');
	ELSE
		SET Var_Sentencia :=    CONCAT(Var_Sentencia, Entero_Cero,' AS InstitucionNominaID,', Entero_Cero,' AS ConvenioNominaID, ');
	END IF;
    SET Var_Sentencia   :=CONCAT(Var_Sentencia, ' IFNULL((Cas.SaldoNotCargoSinIVA +  Cas.SaldoNotCargoConIVA + Cas.SaldoNotCargoRev),0.00) AS MontoNotasCargo');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' from CREDITOS Cre');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' left join GRUPOSCREDITO Gru on Gru.GrupoID	= Cre.GrupoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia, ' inner join PRODUCTOSCREDITO  Pro on   Pro.ProducCreditoID = Cre.ProductoCreditoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,	' inner join CLIENTES Cli	on Cli.ClienteID = Cre.ClienteID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' inner join CRECASTIGOS Cas on Cas.CreditoID = Cre.CreditoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' inner join MOTIVOSCASTIGO MoCas on MoCas.MotivoCastigoID = Cas.MotivoCastigoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' left join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' left join SUCURSALES Suc on Suc.SucursalID = Cre.SucursalID');

	
	IF(Var_RestringeReporte = 'S')THEN
	
		
		SET Var_UsuDependencia := (SELECT FNUSUARIOSDEPENDECIA(Aud_Usuario));

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN SOLICITUDCREDITO SOL 
				ON Cre.CreditoID = SOL.CreditoID AND SOL.UsuarioAltaSol IN(',Var_UsuDependencia,') ');

	END IF; 
	IF(Par_ProductoCre!=0 AND EsNomina = Cons_Si)THEN
		
        IF( EsNomina = Cons_Si) THEN
			IF(IFNULL(Par_InstitucionID,Entero_Cero) != Entero_Cero) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN NOMCONDICIONCRED Nomi ON Pro.ProducCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID  AND Nomi.InstitNominaID = ',Par_InstitucionID);
			 ELSE
				SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN NOMCONDICIONCRED Nomi ON Pro.ProducCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID  ');
			END IF;
		
			IF(IFNULL(Par_ConvenioNominaID,Entero_Cero) != Entero_Cero) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Nomi.ConvenioNominaID = ',Par_ConvenioNominaID);
			END IF;
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA InstNom ON Nomi.InstitNominaID = InstNom.InstitNominaID ');
		END IF;
	END IF;
    
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' where Cas.Fecha between  ? and ?');


	IF(Par_Sucursal != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' and Cre.SucursalID=', CONVERT(Par_Sucursal,CHAR));
	END IF;
	IF(Par_Moneda != Entero_Cero)THEN
			 SET Var_Sentencia = CONCAT(Var_sentencia,' and Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
	END IF;

	IF(Par_ProductoCre != Entero_Cero)THEN
		   SET Var_Sentencia :=  CONCAT(Var_sentencia,' and Cre.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
	END IF;

	IF(Par_Promotor!= Entero_Cero)THEN
		   SET Var_Sentencia := CONCAT(Var_sentencia,'  and Cli.PromotorActual=',CONVERT(Par_Promotor,CHAR));
	END IF;
	IF(Par_MotivoCastigoID != Entero_Cero)THEN
		   SET Var_Sentencia := CONCAT(Var_sentencia,'  and Cas.MotivoCastigoID=',CONVERT(Par_MotivoCastigoID,CHAR));
	END IF;

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' and Cre.EsAgropecuario = "',Con_NO,'"');

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' order by Cre.SucursalID, Cli.PromotorActual,Cre.ProductoCreditoID;');

	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

	PREPARE STCRECASTIGOSREP FROM @Sentencia;
	EXECUTE STCRECASTIGOSREP  USING @FechaInicio, @FechaFin;
	DEALLOCATE PREPARE STCRECASTIGOSREP;

    
	UPDATE TMPCRECASTIGOSREP TMP
	INNER JOIN CREDITOS Cre on TMP.CreditoID=Cre.CreditoID
	INNER JOIN NOMCONDICIONCRED Nomi ON TMP.ProductoCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID
		SET TMP.InstitucionNominaID =  Nomi.InstitNominaID,
			TMP.ConvenioNominaID	 = Nomi.ConvenioNominaID
	WHERE TMP.ProductoNomina= Cons_Si
	AND TMP.InstitucionNominaID = Entero_Cero;
	
    
    SELECT  CreditoID,			ClienteID,			NombreCompleto,			ProductoCreditoID,			Descripcion,
			GrupoID,			NombreGrupo,		MontoCredito,			Fecha,						DesMotivoCastigo,
			CapitalCastigado,	InteresCastigado,	TotalCastigo,			MonRecuperado,				NombrePromotor,
			NombreSucurs,		SucursalID,			PromotorActual,			MontoRecuperar,				FechaMinistrado,
			HoraEmision,		IntMoraCastigado,	AccesorioCastigado,		ProductoNomina,				InstitucionNominaID,
			ConvenioNominaID,   MontoNotasCargo
	FROM TMPCRECASTIGOSREP;
    
    DROP TABLE IF EXISTS TMPCRECASTIGOSREP;
    
END	TerminaStore$$
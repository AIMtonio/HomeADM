-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRACREREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINISTRACREREP`;
DELIMITER $$


CREATE PROCEDURE `MINISTRACREREP`(

	Par_FechaInicio			DATE,
	Par_FechaFin			DATE,
	Par_Sucursal			INT,
	Par_Moneda				INT,
	Par_ProductoCre			INT,
	Par_Promotor      		INT,
	Par_Genero        		CHAR(1),
	Par_Estado        	 	INT,
	Par_Municipio      		INT,
	Par_InstNominaID     	INT(11),                -- ID de la empresa de Nomina
	Par_ConvenioID          BIGINT UNSIGNED,        -- Numero de Convenio
	Par_NumList				TINYINT UNSIGNED,


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

	)

TerminaStore: BEGIN


	DECLARE	pagoExigible		DECIMAL(12,2);
	DECLARE	TotalMonto			DECIMAL(12,2);
	DECLARE	nombreUsuario		VARCHAR(50);
	DECLARE Var_Sentencia 		VARCHAR(5000);
	DECLARE Var_RestringeReporte	CHAR(1);
	DECLARE Var_UsuDependencia		VARCHAR(1000);

	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Lis_MinisRep		INT;
	DECLARE	Lis_MinisRespDet	INT;
	DECLARE	Con_Foranea			INT;
	DECLARE	Con_PagareTfija		INT;
	DECLARE	Con_Saldos			INT;
	DECLARE Con_PagareImp 		INT;
	DECLARE	Con_PagoCred		INT;
	DECLARE	EstatusVigente		CHAR(1);
	DECLARE	EstatusAtras		CHAR(1);
	DECLARE	CienPorciento		DECIMAL(10,2);
	DECLARE EstatusPagado		CHAR(1);
	DECLARE EstatusCastigado	CHAR(1);
	DECLARE Var_RecPropios  	CHAR(1);
	DECLARE Var_RecInstitu 		CHAR(1);
	DECLARE Var_PerFisica 		CHAR(1);
	DECLARE Est_Vencido			CHAR(1);
	DECLARE Var_trans			INT(10);
	DECLARE EsAgropecuario		CHAR(1);
	DECLARE Constante_No		CHAR(1);
	DECLARE EsProductoNomina	CHAR(1);
	DECLARE PermiteDisp			CHAR(1);
	DECLARE Con_SI				CHAR(1);
	DECLARE EstatusSuspendido	CHAR(1);		-- Estatus Suspendido del credito
	DECLARE Var_Autorizado		CHAR(1);

	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_MinisRep		:= 2;
	SET Lis_MinisRespDet	:= 3;
	SET	EstatusVigente		:= 'V';
	SET	EstatusAtras		:= 'A';
	SET	CienPorciento		:= 100.00;
	SET EstatusPagado		:= 'P';
	SET EstatusCastigado	:= 'K';
	SET Var_RecPropios  	:='P';
	SET Var_RecInstitu  	:='F';
	SET Var_PerFisica 		:='F';
	SET Est_Vencido			:= 'B';
	SET EsAgropecuario		:= 'S';
	SET Constante_No		:= 'N';
	SET PermiteDisp			:= (SELECT  PermitirMultDisp FROM PARAMETROSSIS LIMIT 1);
	SET Con_SI				:= 'S';
	SET EstatusSuspendido	:= 'S';				-- Estatus Suspendido del credito
	SET Var_Autorizado		:= 'A';

		SELECT	RestringeReporte
			INTO Var_RestringeReporte
		FROM PARAMETROSSIS LIMIT 1;
		SET Var_RestringeReporte:= IFNULL(Var_RestringeReporte,'N');


		call TRANSACCIONESPRO (Aud_NumTransaccion);

	IF(Par_NumList = Lis_MinisRep) THEN

		  SET Var_Sentencia := 'INSERT INTO TMPMINISTRA (GrupoID,NombreGrupo,TipoFondeo,SucursalID,NombreSucurs,NombrePromotor,PromotorID,ClienteID,NombreCompleto,';
		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia,'SolicitudCreditoID,FechaRegistro,MontoSolici,CreditoID,FechaAutoriza,MontoCredito,MontoDesembolso,FechaInicio,TipoDispersion,ProductoCreditoID,ProductoDesc,InstitNominaID,ConvenioNominaID,FechaEmision,HoraEmision,NumTransaccion) ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia, "SELECT IFNULL(Gpo.GrupoID, 0) AS GrupoID, IFNULL(Gpo.NombreGrupo, '') AS NombreGrupo,");
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN Cre.TipoFondeo = "',Var_RecPropios,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "PROPIOS"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN Cre.TipoFondeo = "',Var_RecInstitu,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Cre.TipoFondeo <> "',Cadena_Vacia,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN (SELECT NombreInstitFon FROM  INSTITUTFONDEO I WHERE I.InstitutFondID= Cre.InstitFondeoID)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS TipoFondeo,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Suc.SucursalID,Suc.NombreSucurs, Pro.NombrePromotor,Pro.PromotorID, Cre.ClienteID, Cli.NombreCompleto,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.SolicitudCreditoID, CHAR) IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN 0');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.SolicitudCreditoID, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS SolicitudCreditoID,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.FechaRegistro, CHAR) IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN ""');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.FechaRegistro, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS FechaRegistro,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.MontoSolici, CHAR)  IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN 0');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.MontoSolici, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS MontoSolici,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cre.CreditoID,       Cre.FechaAutoriza, ROUND(Cre.MontoCredito,2) AS MontoCredito,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cre.MontoCredito AS MontoDesembolso,    Cre.FechaInicio, ');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN Cre.TipoDispersion = "S" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "SPEI" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "C" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "CHEQUE" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "O" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "ORD.PAGO"  ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "E" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "EFECTIVO" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "A" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "TRAN. SANTANDER" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		ELSE ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' "" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS TipoDispersion ,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cre.ProductoCreditoID , PRO.Descripcion AS ProductoDesc,');

		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia, 'IFNULL(Nomc.InstitNominaID,0) AS InstitNominaID, IFNULL(Nomc.ConvenioNominaID,0) AS ConvenioNominaID,');

		  SET Var_Sentencia :=	CONCAT(Var_sentencia,' Par.FechaSistema AS FechaEmision, TIME(NOW()) AS HoraEmision, ',Aud_NumTransaccion);

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM CREDITOS Cre');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' LEFT JOIN GRUPOSCREDITO Gpo ON Gpo.GrupoID = Cre.GrupoID ');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO PRO ON Cre.ProductoCreditoID = PRO.ProducCreditoID');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' LEFT OUTER JOIN PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');
		  -- RELACIONAMOS PRODUCTO DE NOMINA CON INSTITUCION Y CONVENIO
		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia,' LEFT OUTER JOIN NOMCONDICIONCRED Nomc ON Cre.ProductoCreditoID= Nomc.ProducCreditoID
													   AND Cre.ConvenioNominaID=Nomc.ConvenioNominaID ');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cli.ClienteID = Cre.ClienteID');
		  SET Par_Genero 	:= IFNULL(Par_Genero,Cadena_Vacia);

		IF(Par_Genero!=Cadena_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.TipoPersona="',Var_PerFisica,'"');
		END IF;

		SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);

		IF(Par_Estado!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Cli.ClienteID=Dir.ClienteID ORDER BY Oficial DESC LIMIT 1)=',CONVERT(Par_Estado,CHAR));
		END IF;

		SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);

		IF(Par_Municipio!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Cli.ClienteID=Dir.ClienteID ORDER BY Oficial DESC LIMIT 1)=',CONVERT(Par_Municipio,CHAR));
		END IF;


		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES Pro ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Pro.PromotorID=Cli.PromotorActual');
		SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);

		IF(Par_Promotor!=0)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Pro.PromotorID=',CONVERT(Par_Promotor,CHAR));
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES Suc ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Suc.SucursalID = Cre.SucursalID');

		SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);

		IF(Par_ProductoCre!=0)THEN
			SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Cre.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' LEFT OUTER JOIN SOLICITUDCREDITO Sol ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Sol.SolicitudCreditoID = Cre.SolicitudCreditoID');


		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE  Cre.FechaInicio	>= ? AND Cre.FechaInicio <= ?');

		SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);

		IF(Par_Moneda!=0)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
		END IF;

		SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);

		IF(Par_Sucursal!=0)THEN
			SET Var_Sentencia = CONCAT(Var_Sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
		END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND (Cre. Estatus = "',EstatusVigente,'" OR Cre.Estatus = "',EstatusPagado,'" OR Cre.Estatus = "',Est_Vencido,'" OR Cre.Estatus = "',EstatusCastigado,'"  OR Cre.Estatus = "',EstatusSuspendido,'")');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,'  AND Cre.EsAgropecuario = "',Constante_No,'"');
		-- SI ES PRODUCTO DE NOMINA, SE REALIZAN LOS FILTROS ESPECIFICADOS
		IF(Par_ProductoCre!=Entero_Cero)THEN
			SELECT ProductoNomina INTO EsProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID=Par_ProductoCre LIMIT 1;

			IF(EsProductoNomina='S')THEN
				SET Par_InstNominaID	:= IFNULL(Par_InstNominaID,Entero_Cero);
				SET	Par_ConvenioID		:= IFNULL(Par_ConvenioID,Entero_Cero);

				IF(Par_InstNominaID=Entero_Cero AND Par_ConvenioID!=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia,' AND Nomc.ConvenioNominaID=',CONVERT(Par_ConvenioID,CHAR));
				END IF;
				IF(Par_InstNominaID!=Entero_Cero AND Par_ConvenioID=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia, ' AND Nomc.InstitNominaID=', CONVERT(Par_InstNominaID,CHAR));
				END IF;
				IF(Par_InstNominaID!=Entero_Cero AND Par_ConvenioID!=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia, ' AND Nomc.InstitNominaID=', CONVERT(Par_InstNominaID,CHAR),
											' AND Nomc.ConvenioNominaID=',CONVERT(Par_ConvenioID,CHAR));
				END IF;
			END IF;
		END IF;



		 -- CUANDO EL PARAMETRO RESTRINGE CARTERA ES SI, MOSTRARA LA INFORMACION POR USUARIO DE ACUERDO AL CRONOGRAMA
		IF(Var_RestringeReporte = 'S')THEN

			-- OBTENEMOS LOS USUARIOS QUE SON DEPENDENCIAS
			SET Var_UsuDependencia := (SELECT FNUSUARIOSDEPENDECIA(Aud_Usuario));

			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Sol.UsuarioAltaSol IN(',Var_UsuDependencia,')');

		END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY Cre.SucursalID, Cre.ProductoCreditoID ,Cli.PromotorActual, IFNULL(Gpo.GrupoID, 0), Cre.CreditoID;');

		SET @Sentencia	= (Var_Sentencia);
		SET @FechaInicio	= Par_FechaInicio;
		SET @FechaFin		= Par_FechaFin;

	   PREPARE STMINISTRACREREP FROM @Sentencia;
	   EXECUTE STMINISTRACREREP USING @FechaInicio, @FechaFin;
	   DEALLOCATE PREPARE STMINISTRACREREP;

		  SET Var_Sentencia := 'INSERT INTO TMPMINISTRA (GrupoID,NombreGrupo,TipoFondeo,SucursalID,NombreSucurs,NombrePromotor,PromotorID,ClienteID,NombreCompleto,';
		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia,'SolicitudCreditoID,FechaRegistro,MontoSolici,CreditoID,FechaAutoriza,MontoCredito,MontoDesembolso,FechaInicio,TipoDispersion,ProductoCreditoID,ProductoDesc,InstitNominaID,ConvenioNominaID,FechaEmision,HoraEmision,NumTransaccion) ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia," SELECT IFNULL(Gpo.GrupoID, 0) AS GrupoID, IFNULL(Gpo.NombreGrupo, '') AS NombreGrupo,");
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN Cre.TipoFondeo = "',Var_RecPropios,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "PROPIOS"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN Cre.TipoFondeo = "',Var_RecInstitu,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Cre.TipoFondeo <> "',Cadena_Vacia,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN (SELECT NombreInstitFon FROM  INSTITUTFONDEO I WHERE I.InstitutFondID= Cre.InstitFondeoID)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS TipoFondeo,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Suc.SucursalID,Suc.NombreSucurs, Pro.NombrePromotor,Pro.PromotorID, Cre.ClienteID, Cli.NombreCompleto,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.SolicitudCreditoID, CHAR) IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN 0');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.SolicitudCreditoID, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS SolicitudCreditoID,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.FechaRegistro, CHAR) IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN ""');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.FechaRegistro, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS FechaRegistro,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.MontoSolici, CHAR)  IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN 0');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.MontoSolici, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS MontoSolici,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cre.CreditoID,       Cre.FechaAutoriza, ROUND(Cre.MontoCredito,2) AS MontoCredito,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Agro.Capital AS MontoDesembolso,    Agro.FechaPagoMinis AS FechaInicio, ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN Cre.TipoDispersion = "S" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "SPEI" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "C" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "CHEQUE" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "O" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "ORD.PAGO"  ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "E" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "EFECTIVO" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "A" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "TRAN. SANTANDER" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		ELSE ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' "" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS TipoDispersion,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cre.ProductoCreditoID , PRO.Descripcion AS ProductoDesc,');

		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia, 'IFNULL(Nomc.InstitNominaID,0) AS InstitNominaID, IFNULL(Nomc.ConvenioNominaID,0) AS ConvenioNominaID,');

		  SET Var_Sentencia :=	CONCAT(Var_sentencia,' Par.FechaSistema AS FechaEmision, TIME(NOW()) AS HoraEmision, ',Aud_NumTransaccion);

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM CREDITOS Cre');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' LEFT JOIN GRUPOSCREDITO Gpo ON Gpo.GrupoID = Cre.GrupoID ');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO PRO ON Cre.ProductoCreditoID = PRO.ProducCreditoID');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' LEFT OUTER JOIN PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');
		  -- RELACIONAMOS PRODUCTO DE NOMINA CON INSTITUCION Y CONVENIO
		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia,' LEFT OUTER JOIN NOMCONDICIONCRED Nomc ON Cre.ProductoCreditoID= Nomc.ProducCreditoID
													   AND Cre.ConvenioNominaID=Nomc.ConvenioNominaID ');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cli.ClienteID = Cre.ClienteID');
		  SET Par_Genero 	:= IFNULL(Par_Genero,Cadena_Vacia);

		IF(Par_Genero!=Cadena_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.TipoPersona="',Var_PerFisica,'"');
		END IF;

		SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);

		IF(Par_Estado!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Cli.ClienteID=Dir.ClienteID ORDER BY Oficial DESC LIMIT 1)=',CONVERT(Par_Estado,CHAR));
		END IF;

		SET Par_Municipio := ifnull(Par_Municipio,Entero_Cero);

		IF(Par_Municipio!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Cli.ClienteID=Dir.ClienteID ORDER BY Oficial DESC LIMIT 1)=',CONVERT(Par_Municipio,CHAR));
		END IF;


		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES Pro ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Pro.PromotorID=Cli.PromotorActual');
		SET Par_Promotor := ifnull(Par_Promotor,Entero_Cero);

		IF(Par_Promotor!=0)then
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Pro.PromotorID=',CONVERT(Par_Promotor,CHAR));
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES Suc ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Suc.SucursalID = Cre.SucursalID');

		SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);

		IF(Par_ProductoCre!=0)THEN
			SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Cre.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' LEFT OUTER JOIN SOLICITUDCREDITO Sol ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Sol.SolicitudCreditoID = Cre.SolicitudCreditoID');

		SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN MINISTRACREDAGRO Agro ON');
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' Agro.CreditoID = Cre.CreditoID');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE  Agro.FechaPagoMinis BETWEEN ? AND ?');

		SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);

		IF(Par_Moneda!=0)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',convert(Par_Moneda,CHAR));
		END IF;

		SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);

		IF(Par_Sucursal!=0)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' and Cre.SucursalID=',convert(Par_Sucursal,CHAR));
		END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND (Cre. Estatus = "',EstatusVigente,'" OR Cre.Estatus = "',EstatusPagado,'" OR Cre.Estatus = "',Est_Vencido,'" OR Cre.Estatus = "',EstatusCastigado,'"  OR Cre.Estatus = "',EstatusSuspendido,'")');
		SET Var_Sentencia :=	CONCAT(Var_Sentencia,' AND Cre.EsAgropecuario = "',EsAgropecuario,'"');

		-- SI ES PRODUCTO DE NOMINA, SE APLICAN LOS FILTROS ESPECIFICADOS
		IF(Par_ProductoCre!=Entero_Cero)THEN
			SELECT ProductoNomina INTO EsProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID=Par_ProductoCre LIMIT 1;

			IF(EsProductoNomina='S')THEN
				SET Par_InstNominaID	:= IFNULL(Par_InstNominaID,Entero_Cero);
				SET	Par_ConvenioID		:= IFNULL(Par_ConvenioID,Entero_Cero);

				IF(Par_InstNominaID=Entero_Cero AND Par_ConvenioID!=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia,' AND Nomc.ConvenioNominaID=',CONVERT(Par_ConvenioID,CHAR));
				END IF;
				IF(Par_InstNominaID!=Entero_Cero AND Par_ConvenioID=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia, ' AND Nomc.InstitNominaID=', CONVERT(Par_InstNominaID,CHAR));
				END IF;
				IF(Par_InstNominaID!=Entero_Cero AND Par_ConvenioID!=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia, ' AND Nomc.InstitNominaID=', CONVERT(Par_InstNominaID,CHAR),
											' AND Nomc.ConvenioNominaID=',CONVERT(Par_ConvenioID,CHAR));
				END IF;
			END IF;
		END IF;


		 -- CUANDO EL PARAMETRO RESTRINGE CARTERA ES SI, MOSTRARA LA INFORMACION POR USUARIO DE ACUERDO AL CRONOGRAMA
		IF(Var_RestringeReporte = 'S')THEN

			-- OBTENEMOS LOS USUARIOS QUE SON DEPENDENCIAS
			SET Var_UsuDependencia := (SELECT FNUSUARIOSDEPENDECIA(Aud_Usuario));

			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Sol.UsuarioAltaSol IN(',Var_UsuDependencia,')');

		END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY Cre.SucursalID, Cre.ProductoCreditoID ,Cli.PromotorActual, IFNULL(Gpo.GrupoID, 0), Cre.CreditoID;');


		SET @Sentencia	= (Var_Sentencia);
		SET @FechaInicio	= Par_FechaInicio;
		SET @FechaFin		= Par_FechaFin;

	   PREPARE STMINISTRACREREP FROM @Sentencia;
	   EXECUTE STMINISTRACREREP USING @FechaInicio, @FechaFin;
	   DEALLOCATE PREPARE STMINISTRACREREP;


		SELECT * FROM TMPMINISTRA
		WHERE FechaInicio BETWEEN @FechaInicio AND @FechaFin;

	   DELETE FROM TMPMINISTRA  WHERE NumTransaccion = Aud_NumTransaccion;

	END IF;

	IF(Par_NumList = Lis_MinisRespDet) THEN
		-- REPORTE DETALLADO
		SET Var_Sentencia := 'INSERT INTO TMPMINISTRA (GrupoID,NombreGrupo,TipoFondeo,SucursalID,NombreSucurs,NombrePromotor,PromotorID,ClienteID,NombreCompleto,';
		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia,'SolicitudCreditoID,FechaRegistro,MontoSolici,CreditoID,FechaAutoriza,MontoCredito,MontoDesembolso,FechaInicio,TipoDispersion,ProductoCreditoID,ProductoDesc,InstitNominaID,ConvenioNominaID,FechaEmision,HoraEmision,NumTransaccion) ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia, "SELECT IFNULL(Gpo.GrupoID, 0) AS GrupoID, IFNULL(Gpo.NombreGrupo, '') AS NombreGrupo,");
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN Cre.TipoFondeo = "',Var_RecPropios,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "PROPIOS"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN Cre.TipoFondeo = "',Var_RecInstitu,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Cre.TipoFondeo <> "',Cadena_Vacia,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN (SELECT NombreInstitFon FROM  INSTITUTFONDEO I WHERE I.InstitutFondID= Cre.InstitFondeoID)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS TipoFondeo,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Suc.SucursalID,Suc.NombreSucurs, Pro.NombrePromotor,Pro.PromotorID, Cre.ClienteID, Cli.NombreCompleto,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.SolicitudCreditoID, CHAR) IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN 0');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.SolicitudCreditoID, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS SolicitudCreditoID,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.FechaRegistro, CHAR) IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN ""');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.FechaRegistro, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS FechaRegistro,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.MontoSolici, CHAR)  IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN 0');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.MontoSolici, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS MontoSolici,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cre.CreditoID,       Cre.FechaAutoriza, ROUND(Cre.MontoCredito,2) AS MontoCredito,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cre.MontoCredito AS MontoDesembolso,');


		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cre.FechaInicio, ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN Cre.TipoDispersion = "S" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "SPEI" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "C" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "CHEQUE" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "O" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "ORD.PAGO"  ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "E" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "EFECTIVO" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "A" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "TRAN. SANTANDER" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		ELSE ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' "" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS TipoDispersion ,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cre.ProductoCreditoID , PRO.Descripcion AS ProductoDesc,');

		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia, 'IFNULL(Nomc.InstitNominaID,0) AS InstitNominaID, IFNULL(Nomc.ConvenioNominaID,0) AS ConvenioNominaID,');

		  SET Var_Sentencia :=	CONCAT(Var_sentencia,' Par.FechaSistema AS FechaEmision, TIME(NOW()) AS HoraEmision, ',Aud_NumTransaccion);

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM CREDITOS Cre');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' LEFT JOIN GRUPOSCREDITO Gpo ON Gpo.GrupoID = Cre.GrupoID ');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO PRO ON Cre.ProductoCreditoID = PRO.ProducCreditoID');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' LEFT OUTER JOIN PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');
		  -- RELACIONAMOS PRODUCTO DE NOMINA CON INSTITUCION Y CONVENIO
		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia,' LEFT OUTER JOIN NOMCONDICIONCRED Nomc ON Cre.ProductoCreditoID= Nomc.ProducCreditoID
													   AND Cre.ConvenioNominaID=Nomc.ConvenioNominaID ');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cli.ClienteID = Cre.ClienteID');
		  SET Par_Genero 	:= IFNULL(Par_Genero,Cadena_Vacia);

		IF(Par_Genero!=Cadena_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.TipoPersona="',Var_PerFisica,'"');
		END IF;

		SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);

		IF(Par_Estado!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Cli.ClienteID=Dir.ClienteID ORDER BY Oficial DESC LIMIT 1)=',CONVERT(Par_Estado,CHAR));
		END IF;

		SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);

		IF(Par_Municipio!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Cli.ClienteID=Dir.ClienteID ORDER BY Oficial DESC LIMIT 1)=',CONVERT(Par_Municipio,CHAR));
		END IF;


		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES Pro ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Pro.PromotorID=Cli.PromotorActual');
		SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);

		IF(Par_Promotor!=0)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Pro.PromotorID=',CONVERT(Par_Promotor,CHAR));
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES Suc ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Suc.SucursalID = Cre.SucursalID');

		SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);

		IF(Par_ProductoCre!=0)THEN
			SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Cre.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' LEFT OUTER JOIN SOLICITUDCREDITO Sol ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Sol.SolicitudCreditoID = Cre.SolicitudCreditoID');

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE  Cre.FechaInicio	>= ? AND Cre.FechaInicio <= ?');

		SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);

		IF(Par_Moneda!=0)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
		END IF;

		SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);

		IF(Par_Sucursal!=0)THEN
			SET Var_Sentencia = CONCAT(Var_Sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
		END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND (Cre. Estatus = "',EstatusVigente,'" OR Cre.Estatus = "',EstatusPagado,'" OR Cre.Estatus = "',Est_Vencido,'" OR Cre.Estatus = "',EstatusCastigado,'")');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,'  AND Cre.EsAgropecuario = "',Constante_No,'"');
		-- SI ES PRODUCTO DE NOMINA, SE REALIZAN LOS FILTROS ESPECIFICADOS
		IF(Par_ProductoCre!=Entero_Cero)THEN
			SELECT ProductoNomina INTO EsProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID=Par_ProductoCre LIMIT 1;

			IF(EsProductoNomina='S')THEN
				SET Par_InstNominaID	:= IFNULL(Par_InstNominaID,Entero_Cero);
				SET	Par_ConvenioID		:= IFNULL(Par_ConvenioID,Entero_Cero);

				IF(Par_InstNominaID=Entero_Cero AND Par_ConvenioID!=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia,' AND Nomc.ConvenioNominaID=',CONVERT(Par_ConvenioID,CHAR));
				END IF;
				IF(Par_InstNominaID!=Entero_Cero AND Par_ConvenioID=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia, ' AND Nomc.InstitNominaID=', CONVERT(Par_InstNominaID,CHAR));
				END IF;
				IF(Par_InstNominaID!=Entero_Cero AND Par_ConvenioID!=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia, ' AND Nomc.InstitNominaID=', CONVERT(Par_InstNominaID,CHAR),
											' AND Nomc.ConvenioNominaID=',CONVERT(Par_ConvenioID,CHAR));
				END IF;
			END IF;
		END IF;



		 -- CUANDO EL PARAMETRO RESTRINGE CARTERA ES SI, MOSTRARA LA INFORMACION POR USUARIO DE ACUERDO AL CRONOGRAMA
		IF(Var_RestringeReporte = 'S')THEN

			-- OBTENEMOS LOS USUARIOS QUE SON DEPENDENCIAS
			SET Var_UsuDependencia := (SELECT FNUSUARIOSDEPENDECIA(Aud_Usuario));

			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Sol.UsuarioAltaSol IN(',Var_UsuDependencia,')');

		END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY Cre.SucursalID, Cre.ProductoCreditoID ,Cli.PromotorActual, IFNULL(Gpo.GrupoID, 0), Cre.CreditoID;');

		SET @Sentencia	= (Var_Sentencia);
		SET @FechaInicio	= Par_FechaInicio;
		SET @FechaFin		= Par_FechaFin;

	   PREPARE STMINISTRACREREP FROM @Sentencia;
	   EXECUTE STMINISTRACREREP USING @FechaInicio, @FechaFin;
	   DEALLOCATE PREPARE STMINISTRACREREP;

		  SET Var_Sentencia := 'INSERT INTO TMPMINISTRA (GrupoID,NombreGrupo,TipoFondeo,SucursalID,NombreSucurs,NombrePromotor,PromotorID,ClienteID,NombreCompleto,';
		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia,'SolicitudCreditoID,FechaRegistro,MontoSolici,CreditoID,FechaAutoriza,MontoCredito,MontoDesembolso,FechaInicio,TipoDispersion,ProductoCreditoID,ProductoDesc,InstitNominaID,ConvenioNominaID,FechaEmision,HoraEmision,NumTransaccion) ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia," SELECT IFNULL(Gpo.GrupoID, 0) AS GrupoID, IFNULL(Gpo.NombreGrupo, '') AS NombreGrupo,");
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN Cre.TipoFondeo = "',Var_RecPropios,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "PROPIOS"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN Cre.TipoFondeo = "',Var_RecInstitu,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Cre.TipoFondeo <> "',Cadena_Vacia,'"');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN (SELECT NombreInstitFon FROM  INSTITUTFONDEO I WHERE I.InstitutFondID= Cre.InstitFondeoID)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS TipoFondeo,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Suc.SucursalID,Suc.NombreSucurs, Pro.NombrePromotor,Pro.PromotorID, Cre.ClienteID, Cli.NombreCompleto,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.SolicitudCreditoID, CHAR) IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN 0');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.SolicitudCreditoID, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS SolicitudCreditoID,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.FechaRegistro, CHAR) IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN ""');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.FechaRegistro, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS FechaRegistro,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN CONVERT(Sol.MontoSolici, CHAR)  IS NULL');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN 0');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE CONVERT(Sol.MontoSolici, CHAR)');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS MontoSolici,');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cre.CreditoID,       Cre.FechaAutoriza, ROUND(Cre.MontoCredito,2) AS MontoCredito,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Agro.Capital AS MontoDesembolso,    Agro.FechaPagoMinis AS FechaInicio, ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN Cre.TipoDispersion = "S" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "SPEI" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "C" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "CHEQUE" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "O" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "ORD.PAGO"  ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "E" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "EFECTIVO" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		WHEN Cre.TipoDispersion = "A" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' THEN "TRAN. SANTANDER" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' 		ELSE ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' "" ');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS TipoDispersion,');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cre.ProductoCreditoID , PRO.Descripcion AS ProductoDesc,');

		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia, 'IFNULL(Nomc.InstitNominaID,0) AS InstitNominaID, IFNULL(Nomc.ConvenioNominaID,0) AS ConvenioNominaID,');

		  SET Var_Sentencia :=	CONCAT(Var_sentencia,' Par.FechaSistema AS FechaEmision, TIME(NOW()) AS HoraEmision, ',Aud_NumTransaccion);

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM CREDITOS Cre');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' LEFT JOIN GRUPOSCREDITO Gpo ON Gpo.GrupoID = Cre.GrupoID ');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO PRO ON Cre.ProductoCreditoID = PRO.ProducCreditoID');
		  SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' LEFT OUTER JOIN PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');
		  -- RELACIONAMOS PRODUCTO DE NOMINA CON INSTITUCION Y CONVENIO
		  SET Var_Sentencia	:=	CONCAT(Var_Sentencia,' LEFT OUTER JOIN NOMCONDICIONCRED Nomc ON Cre.ProductoCreditoID= Nomc.ProducCreditoID
													   AND Cre.ConvenioNominaID=Nomc.ConvenioNominaID ');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON');
		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Cli.ClienteID = Cre.ClienteID');
		  SET Par_Genero 	:= IFNULL(Par_Genero,Cadena_Vacia);

		IF(Par_Genero!=Cadena_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.TipoPersona="',Var_PerFisica,'"');
		END IF;

		SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);

		IF(Par_Estado!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Cli.ClienteID=Dir.ClienteID ORDER BY Oficial DESC LIMIT 1)=',CONVERT(Par_Estado,CHAR));
		END IF;

		SET Par_Municipio := ifnull(Par_Municipio,Entero_Cero);

		IF(Par_Municipio!=0)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Cli.ClienteID=Dir.ClienteID ORDER BY Oficial DESC LIMIT 1)=',CONVERT(Par_Municipio,CHAR));
		END IF;


		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES Pro ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Pro.PromotorID=Cli.PromotorActual');
		SET Par_Promotor := ifnull(Par_Promotor,Entero_Cero);

		IF(Par_Promotor!=0)then
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Pro.PromotorID=',CONVERT(Par_Promotor,CHAR));
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES Suc ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Suc.SucursalID = Cre.SucursalID');

		SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);

		IF(Par_ProductoCre!=0)THEN
			SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Cre.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' LEFT OUTER JOIN SOLICITUDCREDITO Sol ON');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Sol.SolicitudCreditoID = Cre.SolicitudCreditoID');

		SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN MINISTRACREDAGRO Agro ON');
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' Agro.CreditoID = Cre.CreditoID');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE  Agro.FechaPagoMinis BETWEEN ? AND ?');

		SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);

		IF(Par_Moneda!=0)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',convert(Par_Moneda,CHAR));
		END IF;

		SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);

		IF(Par_Sucursal!=0)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' and Cre.SucursalID=',convert(Par_Sucursal,CHAR));
		END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND (Cre. Estatus = "',EstatusVigente,'" OR Cre.Estatus = "',EstatusPagado,'" OR Cre.Estatus = "',Est_Vencido,'" OR Cre.Estatus = "',EstatusCastigado,'")');
		SET Var_Sentencia :=	CONCAT(Var_Sentencia,' AND Cre.EsAgropecuario = "',EsAgropecuario,'"');

		-- SI ES PRODUCTO DE NOMINA, SE APLICAN LOS FILTROS ESPECIFICADOS
		IF(Par_ProductoCre!=Entero_Cero)THEN
			SELECT ProductoNomina INTO EsProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID=Par_ProductoCre LIMIT 1;

			IF(EsProductoNomina='S')THEN
				SET Par_InstNominaID	:= IFNULL(Par_InstNominaID,Entero_Cero);
				SET	Par_ConvenioID		:= IFNULL(Par_ConvenioID,Entero_Cero);

				IF(Par_InstNominaID=Entero_Cero AND Par_ConvenioID!=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia,' AND Nomc.ConvenioNominaID=',CONVERT(Par_ConvenioID,CHAR));
				END IF;
				IF(Par_InstNominaID!=Entero_Cero AND Par_ConvenioID=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia, ' AND Nomc.InstitNominaID=', CONVERT(Par_InstNominaID,CHAR));
				END IF;
				IF(Par_InstNominaID!=Entero_Cero AND Par_ConvenioID!=Entero_Cero) THEN
					SET Var_Sentencia	:=	CONCAT(Var_Sentencia, ' AND Nomc.InstitNominaID=', CONVERT(Par_InstNominaID,CHAR),
											' AND Nomc.ConvenioNominaID=',CONVERT(Par_ConvenioID,CHAR));
				END IF;
			END IF;
		END IF;


		 -- CUANDO EL PARAMETRO RESTRINGE CARTERA ES SI, MOSTRARA LA INFORMACION POR USUARIO DE ACUERDO AL CRONOGRAMA
		IF(Var_RestringeReporte = 'S')THEN

			-- OBTENEMOS LOS USUARIOS QUE SON DEPENDENCIAS
			SET Var_UsuDependencia := (SELECT FNUSUARIOSDEPENDECIA(Aud_Usuario));

			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Sol.UsuarioAltaSol IN(',Var_UsuDependencia,')');

		END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY Cre.SucursalID, Cre.ProductoCreditoID ,Cli.PromotorActual, IFNULL(Gpo.GrupoID, 0), Cre.CreditoID;');


		SET @Sentencia	= (Var_Sentencia);
		SET @FechaInicio	= Par_FechaInicio;
		SET @FechaFin		= Par_FechaFin;

	   PREPARE STMINISTRACREREP FROM @Sentencia;
	   EXECUTE STMINISTRACREREP USING @FechaInicio, @FechaFin;
	   DEALLOCATE PREPARE STMINISTRACREREP;


		SELECT * FROM TMPMINISTRA
		WHERE FechaInicio BETWEEN @FechaInicio AND @FechaFin;

	   DELETE FROM TMPMINISTRA  WHERE NumTransaccion = Aud_NumTransaccion;

	END IF;

END TerminaStore$$
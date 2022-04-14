
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOSREALIZADOSREP`;
DELIMITER $$

CREATE PROCEDURE `PAGOSREALIZADOSREP`(
	Par_Fecha				DATE,
	Par_FechaFin			DATE,
	Par_Sucursal			INT(11),
	Par_Moneda				INT(11),
	Par_ProductoCre			INT(11),

	Par_Promotor   			INT(11),
	Par_Genero 				CHAR(1),
	Par_Estado  			INT(11),
	Par_Municipio   		INT(11),
    Par_ModoPago        	CHAR(1),

	Par_InstitucionID 		INT(11), -- parametro atraso final
    Par_ConvenioNominaID	BIGINT UNSIGNED, -- Numero del Convenio de Nomina
    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual

    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN


	DECLARE	pagoExigible		DECIMAL(12,2);
	DECLARE	TotalCartera		DECIMAL(12,2);
	DECLARE	TotalCapVigent		DECIMAL(12,2);
	DECLARE	TotalCapVencido		DECIMAL(12,2);
	DECLARE	nombreUsuario		VARCHAR(50);
	DECLARE Var_Sentencia 		VARCHAR(5000);
	DECLARE Var_RestringeReporte	CHAR(1);
	DECLARE Var_UsuDependencia		VARCHAR(1000);

	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Lis_SaldosRep		INT;
	DECLARE	Con_Foranea			INT;
	DECLARE	Con_PagareTfija		INT;
	DECLARE	Con_Saldos			INT;
	DECLARE Con_PagareImp 		INT;
	DECLARE	Con_PagoCred		INT;
	DECLARE	EstatusVigente		CHAR(1);
	DECLARE	EstatusAtras		CHAR(1);
	DECLARE	EstatusPagado		CHAR(1);
	DECLARE	EstatusVencido		CHAR(1);
	DECLARE	EstatCastigado		CHAR(1);
	DECLARE	CienPorciento		DECIMAL(10,2);
	DECLARE	FechaSist			DATE;
	DECLARE Var_PerFisica 		CHAR(1);
    DECLARE EsNomina           	CHAR(1); -- Producto de nomina
    DECLARE Cons_No           	CHAR(1); -- Constante NO
    DECLARE Cons_Si           	CHAR(1); -- Constante SI

    DECLARE OrigenPagoS		CHAR(1);
	DECLARE OrigenPagoV		CHAR(1);
	DECLARE OrigenPagoC		CHAR(1);
	DECLARE OrigenPagoN		CHAR(1);
	DECLARE OrigenPagoD		CHAR(1);
	DECLARE OrigenPagoR		CHAR(1);
	DECLARE OrigenPagoW		CHAR(1);
	DECLARE OrigenPagoO		CHAR(1);

	DECLARE OP_SPEI			VARCHAR(40);
	DECLARE OP_Ventanilla	VARCHAR(40);
	DECLARE OP_CargoACta	VARCHAR(40);
	DECLARE OP_Nomina		VARCHAR(40);
	DECLARE OP_Domiciliado	VARCHAR(40);
	DECLARE OP_DepositoRefe VARCHAR(40);
	DECLARE OP_WebS 		VARCHAR(40);
	DECLARE OP_Otros		VARCHAR(40);

	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Lis_SaldosRep			:= 4;
	SET	EstatusVigente			:= 'V';
	SET	EstatusAtras			:= 'A';
	SET	EstatusPagado			:= 'P';
	SET	CienPorciento			:= 100.00;
	SET	EstatusVencido			:= 'B';
	SET	EstatCastigado			:= 'K';
	SET Var_PerFisica 			:='F';
    SET Cons_No           		:= 'N';
	SET Cons_Si           		:= 'S';

	SET OrigenPagoS				:='S';
	SET OrigenPagoV				:='V';
	SET OrigenPagoC				:='C';
	SET OrigenPagoN				:='N';
	SET OrigenPagoD				:='D';
	SET OrigenPagoR				:='R';
	SET OrigenPagoW				:='W';
	SET OrigenPagoO				:='O';

	SET OP_SPEI				:='SPEI';
	SET OP_Ventanilla		:='VENTANILLA';
	SET OP_CargoACta		:='CARGO A CUENTA';
	SET OP_Nomina			:='DESCUENTO POR NOMINA';
	SET OP_Domiciliado		:='DOMICILIADO';
	SET OP_DepositoRefe		:='DÉPOSITO REFERENCIADO';
	SET OP_WebS				:='WEBSERVICE';
	SET OP_Otros			:='OTROS';

	SELECT	RestringeReporte
			INTO Var_RestringeReporte
		FROM PARAMETROSSIS LIMIT 1;
		SET Var_RestringeReporte:= IFNULL(Var_RestringeReporte,'N');

	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);

	SET EsNomina		:= (SELECT ProductoNomina
								FROM PRODUCTOSCREDITO
                                WHERE ProducCreditoID = Par_ProductoCre);
	SET EsNomina		:= IFNULL(EsNomina, Cons_No);



    DROP TABLE IF EXISTS TMPPAGOSREALIZADOSREP;
	CREATE TEMPORARY TABLE TMPPAGOSREALIZADOSREP(
		  `FechaPago` 			date,
		  `GrupoID` 			bigint(11),
		  `NombreGrupo` 		varchar(200),
		  `CreditoID` 			bigint(12),
		  `CicloGrupo`			bigint(11),
		  `ClienteID` 			int(11),
		  `NombreCliente` 		varchar(200),
		  `NombreProducto` 		varchar(100),
		  `NombreSucurs` 		varchar(50),
		  `MontoCredito` 		decimal(12,2),
		  `Capital` 			decimal(14,2),
		  `Intereses` 			decimal(16,4),
		  `Moratorios` 			decimal(12,2),
		  `Comisiones` 			decimal(15,2),
		  `IVA` 				decimal(12,2),
		  `TotalPagado` 		decimal(12,2),
		  `FormaDePago` 		char(1),
		  `OrigenPago` 			VARCHAR(40),
		  `SucursalID` 			int(11),
		  `ProductoCreditoID` 	int(11)  ,
		  `PromotorActual` 		int(11),
		  `NombrePromotor` 		varchar(100),
		  `FechaEmision` 		date,
		  `HoraEmision` 		datetime,
		  `FechaVencim` 		date,
		  `CredPorPromotor` 	bigint(21),
		  `RefPago` 			bigint(20),
		  `ProductoNomina`		char(1),
		  `NombreInstit` 		VARCHAR(200),
		  `DesConvenio` 		int(11),
		  `IVA_Comisiones`		decimal(12,2),
          `CuentaAhoID`			BIGINT(12),
          `LineaFondeo`			INT(11),
          `FuenteFondeo`		VARCHAR(200),
          `FolioFondeo`			VARCHAR(45),
          `NotasCargo`			DECIMAL(14,2),
          `IvaNotasCargo`		DECIMAL(14,2),
		  `Accesorios`			DECIMAL(14,2),
		  `InteresAccesorio`	DECIMAL(14,2),
		  `IvaInteresAccesorio` DECIMAL(14,2),
          INDEX (LineaFondeo, CreditoID, ProductoCreditoID)
		);
    SET Var_Sentencia :=	"INSERT INTO TMPPAGOSREALIZADOSREP (
								FechaPago,			GrupoID,		NombreGrupo,		CreditoID,			CicloGrupo,
								ClienteID,			NombreCliente,	NombreProducto,		NombreSucurs,		MontoCredito,
								Capital,			Intereses,		Moratorios,			Comisiones,			IVA,
								TotalPagado,		FormaDePago,	OrigenPago,			SucursalID,			ProductoCreditoID,
								PromotorActual,		NombrePromotor,	FechaEmision,		HoraEmision,		FechaVencim,
								CredPorPromotor,	RefPago,		ProductoNomina,		NombreInstit,		DesConvenio,
								IVA_Comisiones,		CuentaAhoID,	LineaFondeo,		FuenteFondeo,		FolioFondeo,
								NotasCargo,			IvaNotasCargo,	Accesorios,			InteresAccesorio, 	IvaInteresAccesorio)";

	SET Var_Sentencia :=	CONCAT(Var_Sentencia,"select Det.FechaPago, ifnull(Gpo.GrupoID, 0) as GrupoID, ifnull(Gpo.NombreGrupo, '') as NombreGrupo, Det.CreditoID, ifnull(Cre.CicloGrupo, 0) as CicloGrupo, Det.ClienteID,Cli.NombreCompleto as NombreCliente,");
	SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' Pro.Descripcion as NombreProducto,Suc.NombreSucurs, Cre.MontoCredito, ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, '  (Det.MontoCapOrd+ Det.MontoCapAtr + Det.MontoCapVen ) as Capital, ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, '  (Det.MontoIntOrd+ Det.MontoIntAtr+Det.MontoIntVen) as Intereses, ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, '  (Det.MontoIntMora) as Moratorios,  (Det.MontoComision + Det.MontoGastoAdmon + Det.MontoAccesorios)  as Comisiones,');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, '  (Det.MontoIVA )  as IVA,   Det.MontoTotPago  as TotalPagado, Det.FormaPago  as FormaDePago,');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' CASE OrigenPago WHEN "',OrigenPagoS,'" THEN "',OP_SPEI,'"');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' WHEN "',OrigenPagoV,'"	THEN "',OP_Ventanilla,'"');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' WHEN "',OrigenPagoC,'"	THEN "',OP_CargoACta,'"');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' WHEN "',OrigenPagoN,'"	THEN "',OP_Nomina,'"');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' WHEN "',OrigenPagoD,'"	THEN "',OP_Domiciliado,'"');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' WHEN "',OrigenPagoR,'"	THEN "',OP_DepositoRefe,'"');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' WHEN "',OrigenPagoW,'"	THEN "',OP_WebS,'"');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ELSE "',OP_Otros,'" END AS OrigenPago,');
	SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' Cre.SucursalID, Cre.ProductoCreditoID, Cli.PromotorActual, PROM.NombrePromotor, Par.FechaSistema as FechaEmision, time(now()) as HoraEmision,');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' Amo.FechaVencim, (select count(d.CreditoID)  from DETALLEPAGCRE d where d.CreditoID = Cre.CreditoID) as CredPorPromotor,  ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, '    Det.Transaccion as RefPago, Pro.ProductoNomina');

	IF(Par_ProductoCre!=0)THEN
		IF(EsNomina = Cons_Si) THEN
				SET Var_Sentencia :=	CONCAT(Var_Sentencia,', CONCAT(Nomi.InstitNominaID,"-",InstNom.NombreInstit) AS NombreInstit, Nomi.ConvenioNominaID AS DesConvenio, ');
		ELSE
				SET Var_Sentencia :=    CONCAT(Var_Sentencia,', "" AS NombreInstit,', Entero_Cero,' AS DesConvenio, ');
		END IF;
	ELSE
				SET Var_Sentencia :=	CONCAT(Var_Sentencia,', IFNULL(CONCAT(Nomi.InstitNominaID,"-",InstNom.NombreInstit), "', Cadena_Vacia, '") AS NombreInstit, IFNULL(Nomi.ConvenioNominaID, ', Entero_Cero, ') AS DesConvenio, ');
	END IF;


	SET Var_Sentencia :=    CONCAT(Var_Sentencia,' (IFNULL(Det.MontoIVAComision,0) + IFNULL(Det.MontoIVAAccesorios,0) ) AS IVA_Comisiones, Cre.CuentaID, Cre.LineaFondeo, CASE WHEN Cre.LineaFondeo = 0 THEN "RECURSOS PROPIOS" ELSE "" END, "", ');

	SET Var_Sentencia :=    CONCAT(Var_Sentencia,' IFNULL(Det.MontoNotasCargo, 0), IFNULL(Det.MontoIVANotasCargo, 0), ');

	-- Aqui va
	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Det.MontoAccesorios, Det.MontoIntAccesorios, Det.MontoIVAIntAccesorios');

	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' FROM DETALLEPAGCRE Det ');

	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN CREDITOS Cre ON Det.CreditoID=Cre.CreditoID ');

	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN AMORTICREDITO Amo ON Amo.AmortizacionID=Det.AmortizacionID');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' AND Amo.CreditoID=Det.CreditoID');

	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN  PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');

	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID ');


	SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
	IF(Par_ProductoCre!=0)THEN
		SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Pro.ProducCreditoID =',CONVERT(Par_ProductoCre,CHAR));
        -- VALIDACION DE PRODUCTO DE NOMINA
        IF( EsNomina = Cons_Si) THEN
			IF(IFNULL(Par_InstitucionID,Entero_Cero) != Entero_Cero) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN NOMCONDICIONCRED Nomi ON Cre.ProductoCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID AND Nomi.InstitNominaID = ',Par_InstitucionID);
			 ELSE
				SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN NOMCONDICIONCRED Nomi ON Cre.ProductoCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID  ');
			END IF;

			IF(IFNULL(Par_ConvenioNominaID,Entero_Cero) != Entero_Cero) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Nomi.ConvenioNominaID = ',Par_ConvenioNominaID);
			END IF;
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA InstNom ON Nomi.InstitNominaID = InstNom.InstitNominaID ');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN NOMCONDICIONCRED Nomi ON Cre.ProductoCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID  ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN INSTITNOMINA InstNom ON Nomi.InstitNominaID = InstNom.InstitNominaID ');
		END IF;
	ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN NOMCONDICIONCRED Nomi ON Cre.ProductoCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID  ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN INSTITNOMINA InstNom ON Nomi.InstitNominaID = InstNom.InstitNominaID ');
	END IF;

	SET Var_Sentencia := 	CONCAT(Var_Sentencia,'  INNER JOIN CLIENTES Cli ON Det.ClienteID = Cli.ClienteID');

		SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
			IF(Par_Genero!=Cadena_Vacia)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.TipoPersona="',Var_PerFisica,'"');
		   END IF;


		SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
			IF(Par_Estado!=0)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
			END IF;

		SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
			IF(Par_Municipio!=0)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
			END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ON PROM.PromotorID=Cli.PromotorActual ');

		SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
			IF(Par_Promotor!=0)THEN

				SET Var_Sentencia := CONCAT(Var_sentencia,'   AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
			END IF;

		SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
			IF(Par_Moneda!=0)THEN
				SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
			END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cre.SucursalID ');

		SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
			IF(Par_Sucursal!=0)THEN
				SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
			END IF;

		SET Par_ModoPago := IFNULL(Par_ModoPago,Cadena_Vacia);
			IF(Par_ModoPago!=Cadena_Vacia)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Det.FormaPago="',Par_ModoPago,'"');
			END IF;



		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' LEFT JOIN GRUPOSCREDITO Gpo ON Gpo.GrupoID = Cre.GrupoID ');

		 -- CUANDO EL PARAMETRO RESTRINGE CARTERA ES SI, MOSTRARA LA INFORMACION POR USUARIO DE ACUERDO AL CRONOGRAMA
		IF(Var_RestringeReporte = 'S')THEN

			-- OBTENEMOS LOS USUARIOS QUE SON DEPENDENCIAS
			SET Var_UsuDependencia := (SELECT FNUSUARIOSDEPENDECIA(Aud_Usuario));

			SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN SOLICITUDCREDITO SOL
					ON Cre.SolicitudCreditoID = SOL.SolicitudCreditoID AND SOL.UsuarioAltaSol IN (',Var_UsuDependencia,') ');

		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE Det.FechaPago >=? AND Det.FechaPago <=? ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ORDER BY Cre.SucursalID, Cre.ProductoCreditoID, Cli.PromotorActual, ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' IFNULL(Gpo.GrupoID, 0), Cre.CreditoID,  Det.FechaPago, Det.AmortizacionID;');


	SET @Sentencia	= (Var_Sentencia);
	SET @Fecha	= Par_Fecha;
	SET @FechaFin		= Par_FechaFin;
	PREPARE STSALDOSCAPITALREP FROM @Sentencia;
	EXECUTE STSALDOSCAPITALREP USING @Fecha, @FechaFin;

	DEALLOCATE PREPARE STSALDOSCAPITALREP;

	UPDATE TMPPAGOSREALIZADOSREP SET IVA = IVA - IVA_Comisiones
	WHERE ((Capital + Intereses + Moratorios + Comisiones + IVA + IVA_Comisiones) - TotalPagado) != 0; -- IALDANA T_13448
	-- ACTUALIZAMOS LOS DATOS DE INSTITUCION DE NOMINA
	UPDATE TMPPAGOSREALIZADOSREP TMP
    INNER JOIN CREDITOS Cre ON TMP.CreditoID=Cre.CreditoID
	INNER JOIN NOMCONDICIONCRED Nomi ON TMP.ProductoCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID
	INNER JOIN INSTITNOMINA InstNom ON TMP.NombreInstit = InstNom.InstitNominaID
		SET TMP.NombreInstit =  CONCAT(Nomi.InstitNominaID,"-",InstNom.NombreInstit),
			TMP.DesConvenio	 = Nomi.ConvenioNominaID
	WHERE TMP.ProductoNomina= Cons_Si
	AND TMP.NombreInstit = "";
	-- FIN ACTUALIZACION LOS DATOS DE INSTITUCION DE NOMINA

    -- ACTUALIZAMOS LOS DATOS DE FONDEO
		UPDATE TMPPAGOSREALIZADOSREP TMP
		INNER JOIN LINEAFONDEADOR LIN ON LIN.LineaFondeoID=TMP.LineaFondeo
		INNER JOIN INSTITUTFONDEO INS ON LIN.InstitutFondID=INS.InstitutFondID
			SET TMP.FolioFondeo = LIN.FolioFondeo,
				TMP.FuenteFondeo = INS.NombreInstitFon;
    -- FIN ACTUALIZAMOS LOS DATOS DE FONDEO


    SELECT  FechaPago,			GrupoID,			NombreGrupo,			CreditoID,			CicloGrupo,
			ClienteID,			NombreCliente,		NombreProducto,			NombreSucurs,		MontoCredito,
			Capital,			Intereses,			Moratorios,				Comisiones,			IVA,
			TotalPagado,		FormaDePago,		OrigenPago,				SucursalID,			ProductoCreditoID,
			PromotorActual,		NombrePromotor,		FechaEmision,			HoraEmision,		FechaVencim,
			CredPorPromotor,	RefPago,			ProductoNomina,			NombreInstit,		DesConvenio,
			CuentaAhoID,		FuenteFondeo,		FolioFondeo,			LineaFondeo,		IVA_Comisiones,
            CASE FormaDePago WHEN "C" THEN "CARGO A CUENTA"
							 WHEN "V" THEN "VENTANILLA"
                             WHEN "S" THEN "SPEI"
                             WHEN "N" THEN "DESCUENTOS POR NOMINA"
                             WHEN "R" THEN "DEPOSITO REFERENCIADO"
                             WHEN "D" THEN "DOMICILIADO"
                             ELSE "OTROS"
			END AS MetodoPago,
			NotasCargo,			IvaNotasCargo, Accesorios, InteresAccesorio, IvaInteresAccesorio
	FROM TMPPAGOSREALIZADOSREP;
    DROP TABLE IF EXISTS TMPPAGOSREALIZADOSREP;

END TerminaStore$$

-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTASFINIQUITOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARTASFINIQUITOREP`;DELIMITER $$

CREATE PROCEDURE `CARTASFINIQUITOREP`(
	Par_FechaInicio			DATE,
	Par_FechaFin 			DATE,
	Par_Sucursal			INT,
	Par_Moneda				INT,
	Par_ProductoCre			INT,
    Par_InstNomina			INT,
	Par_Promotor   			INT,
	Par_Genero  			CHAR(1),
	Par_Estado 				INT,
	Par_Municipio	   		INT,

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

		)
TerminaStore: BEGIN



	DECLARE	nombreUsuario		VARCHAR(50);
	DECLARE Var_Sentencia 		VARCHAR(6000);
	DECLARE Var_InstitucionID	INT(11);
	DECLARE	Var_NomInstitucion	VARCHAR(100);
	DECLARE Var_JefeCobranza 	VARCHAR(100);
	DECLARE EstadoInst			VARCHAR(100);
	DECLARE MunicipioInst		VARCHAR(150);


	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	EstatusVigente	CHAR(1);
	DECLARE	EstatusAtras	CHAR(1);
	DECLARE	EstatusPagado	CHAR(1);
	DECLARE	EstatusVencido	CHAR(1);

	DECLARE	FechaSist		DATE;

	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	EstatusVigente	:= 'V';
	SET	EstatusAtras	:= 'A';
	SET	EstatusPagado	:= 'P';
	SET	EstatusVencido	:= 'B';

	CALL TRANSACCIONESPRO (Aud_NumTransaccion);

	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);


	SELECT P.InstitucionID, I.Nombre,			P.NombreJefeCobranza,	E.Nombre,			M.Nombre
	INTO Var_InstitucionID,	Var_NomInstitucion,	Var_JefeCobranza,		EstadoInst,			MunicipioInst
	FROM PARAMETROSSIS P, INSTITUCIONES I
	INNER JOIN ESTADOSREPUB E ON I.EstadoEmpresa = E.EstadoID
	INNER JOIN MUNICIPIOSREPUB M ON I.MunicipioEmpresa = M.MunicipioID
							AND I.EstadoEmpresa = M.EstadoID
	WHERE P.InstitucionID = I.InstitucionID;


	SET Var_Sentencia := ' DROP TABLE IF EXISTS TMPCARTASFINIQUTO ; ';
			SET @Sentencia	= (Var_Sentencia);
			PREPARE STCARTASFINREP FROM @Sentencia;
			EXECUTE STCARTASFINREP;
			DEALLOCATE PREPARE STCARTASFINREP;

	SET Var_Sentencia := ' CREATE TABLE TMPCARTASFINIQUTO ( `Transaccion`				BIGINT(20),
																			`CreditoID`   		BIGINT(12),
                                                                        `CreditoIDMig` 		BIGINT(12),
																		`ClienteID`        	INT(11),
																		`NombreCompleto`    VARCHAR(200),
																		`FechaTerminacion`  DATE,
																		`SucursalID`		INT(11),
																		`NombreSucurs`		VARCHAR(200),
                                                                        `EstadoSucID`		INT(11),
                                                                        `EstadoSucNom`		VARCHAR(50),
                                                                        `MunicipioSucID`	INT(11),
                                                                        `MunicipioSucNom`	VARCHAR(50),
																		`ProductoCreditoID`	INT(11),
																		`Descripcion`    	VARCHAR(200),
                                                                        `ProductoNomina`   	CHAR(1),
																		`PromotorActual`	INT(11),
																		`NombrePromotor`	VARCHAR(200),
                                                                        `FechaEmision`		DATE,
                                                                        `SolicitudCreditoID` BIGINT(12),
                                                                        `InstitucionNomID`	INT(11),
																		`NombreInstNomina`	VARCHAR(200),
                                                                        `DirecInstNomina`	VARCHAR(200),
                                                                        `EstatusCredito`    VARCHAR(20)



									); ';


	SET @Sentencia	= (Var_Sentencia);
	PREPARE STCARTASFINREPA FROM @Sentencia;
	EXECUTE STCARTASFINREPA;
	DEALLOCATE PREPARE STCARTASFINREPA;

	SET Var_Sentencia :=  '
			INSERT INTO TMPCARTASFINIQUTO (
				Transaccion,
				CreditoID,
				ClienteID,
				NombreCompleto,
				FechaTerminacion,
				SucursalID,
				NombreSucurs,
				EstadoSucID,
				MunicipioSucID,
				ProductoCreditoID,
				Descripcion,
				ProductoNomina,
				PromotorActual,
				NombrePromotor,
				FechaEmision,
				SolicitudCreditoID,
				InstitucionNomID,
				EstatusCredito)
		';

	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' SELECT  "',Aud_NumTransaccion,'",Cre.CreditoID,Cre.ClienteID,Cli.NombreCompleto,Cre.FechTerminacion,
														Cre.SucursalID, Suc.NombreSucurs, Suc.EstadoID, Suc.MunicipioID, Pro.ProducCreditoID, Pro.Descripcion,
                                                   Pro.ProductoNomina,	PROM.PromotorID, PROM.NombrePromotor,	Cre.FechaMinistrado,');
    SET Par_InstNomina := IFNULL(Par_InstNomina,Entero_Cero);
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, 'Sol.SolicitudCreditoID, Sol.InstitucionNominaID,');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' CASE 	WHEN Cre.Estatus="I" THEN "INACTIVO" ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, '			WHEN Cre.Estatus="A" THEN "AUTORIZADO" ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		WHEN Cre.Estatus="V" THEN "VIGENTE"  ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		WHEN Cre.Estatus="P" THEN "PAGADO" ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		WHEN Cre.Estatus="C" THEN "CANCELADO" ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		WHEN Cre.Estatus="B" THEN "VENCIDO" ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		WHEN Cre.Estatus="K" THEN "CASTIGADO" ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		END AS EstatusCredito');

	SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' FROM CREDITOS Cre ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' LEFT JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID ');

	IF(Par_InstNomina!=Entero_Cero)THEN
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA Inst ON Sol.InstitucionNominaID = Inst.InstitNominaID ');
		SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Inst.InstitNominaID =',Par_InstNomina);
	END IF;

    SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID ');

    SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
    IF(Par_ProductoCre!=Entero_Cero)THEN
		SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Pro.ProducCreditoID =',CONVERT(Par_ProductoCre,CHAR));
	END IF;

	SET Var_Sentencia := 	CONCAT(Var_Sentencia,'  INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID');

    SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
    IF(Par_Genero!=Cadena_Vacia)THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
	END IF;

	SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
    IF(Par_Estado!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial= "S" AND Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
	END IF;

    SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
    IF(Par_Municipio!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
	END IF;

	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ON PROM.PromotorID=Cli.PromotorActual ');

    SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
	IF(Par_Promotor!=Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,'   AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
	END IF;

	SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
	IF(Par_Moneda!=Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cre.SucursalID ');

	SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
	IF(Par_Sucursal!=Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE	(Cre.Estatus	= "',EstatusPagado,'") ');

	SET Par_FechaInicio := IFNULL(Par_FechaInicio,Fecha_Vacia);
	SET Par_FechaFin := IFNULL(Par_FechaFin,Fecha_Vacia);
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND	(Cre.FechTerminacion BETWEEN	"',Par_FechaInicio,'" AND "',Par_FechaFin,'") ');

	SET @Sentencia	= (Var_Sentencia);


	 PREPARE STCARTASFINREPB FROM @Sentencia;
		  EXECUTE STCARTASFINREPB;
		  DEALLOCATE PREPARE STCARTASFINREPB;


    UPDATE  TMPCARTASFINIQUTO T,
			ESTADOSREPUB E
	SET		T.EstadoSucNom=E.Nombre
    WHERE	T.EstadoSucID=E.EstadoID;


    UPDATE  TMPCARTASFINIQUTO T,
			MUNICIPIOSREPUB M
	SET		T.MunicipioSucNom=M.Nombre
    WHERE 	T.MunicipioSucID=M.MunicipioID
		AND T.EstadoSucID=M.EstadoID;


	UPDATE TMPCARTASFINIQUTO T
		INNER JOIN EQU_CREDITOS E ON  T.CreditoID= E.CreditoIDSAFI
	SET CreditoIDMig = IFNULL(E.CreditoIDCte,Cadena_Vacia);


	UPDATE TMPCARTASFINIQUTO T
		INNER JOIN INSTITNOMINA I ON  T.InstitucionNomID= I.InstitNominaID
	SET NombreInstNomina = IFNULL(I.NombreInstit,Cadena_Vacia),
		DirecInstNomina =	IFNULL(I.Domicilio,Cadena_Vacia);

	 SELECT Transaccion,		   	CreditoID,				IFNULL(CreditoIDMig,Cadena_Vacia) AS CreditoIDMig,			ClienteID,				NombreCompleto,
			FNFECHATEXTO(FechaTerminacion) as FechaTer,		FechaTerminacion,		EstatusCredito,    		SucursalID,
			NombreSucurs,		 	EstadoSucID,			EstadoSucNom,			MunicipioSucID,        	MunicipioSucNom,
			ProductoCreditoID,		Descripcion,			ProductoNomina,			PromotorActual,    		NombrePromotor,
			FechaEmision,			Var_InstitucionID,	    Var_NomInstitucion,     Var_JefeCobranza,		SolicitudCreditoID,
			InstitucionNomID,		IFNULL(NombreInstNomina,Cadena_Vacia) AS NombreInstNomina,				DirecInstNomina,
			EstadoInst,				MunicipioInst
		FROM
			TMPCARTASFINIQUTO;
		DELETE FROM TMPCARTASFINIQUTO
		WHERE
			Transaccion = Aud_NumTransaccion;


END TerminaStore$$
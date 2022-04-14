-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REESTRUCCREDITOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REESTRUCCREDITOREP`;
DELIMITER $$


CREATE PROCEDURE `REESTRUCCREDITOREP`(
# ============================================================================================================
# ------------------ SP PARA OBTENER DATOS PARA EL REPORTE DE REESTRUCTURAS DE CREDITO -----------------------
# ============================================================================================================
	Par_FechaInicio		DATE,			# Fecha de inicio de registro de la reestructructura del credito
	Par_FechaFin		DATE,			# Fecha de fin de registro de la reestructructura del credito
	Par_SucursalID		INT,			# Sucursal Id del usuario que realizo la restructuracion
	Par_MonedaID		INT,			# Tipo de moneda con la que realiza el pago
	Par_ProducCreOr		INT,			# Producto credito del credito origen
	Par_ProducCreDe		INT,			# Producto credito del credito destino
	Par_UsuarioID		INT,			# Id del usuario quien realizo la restructuracion
	Par_EstadoID		INT,			# Id del Estado al que pertenecece el socio
	Par_MunicipioID		INT,			# Id del Municipio al que pertenece el socio

	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)

TerminaStore: BEGIN

	#Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Entero_Cero		INT;
	DECLARE Fecha_Vacia		DATE;
	DECLARE Var_SI			CHAR(1);
	DECLARE Var_NO			CHAR(1);
	DECLARE CreReestructura	CHAR(1);
	DECLARE Estatus_Desemb	CHAR(1);

	#Declaracion de variables
	DECLARE Var_Sentencia 			VARCHAR(10000);
	DECLARE Var_RestringeReporte	CHAR(1);
	DECLARE Var_UsuDependencia		VARCHAR(1000);	

	# Asignacion  de constantes
	SET	Cadena_Vacia		:= '';			# Cadena o String Vacio
	SET	Fecha_Vacia			:= '1900-01-01';# Fecha vacia
	SET	Entero_Cero			:= 0;			# Entero en Cero
	SET	Var_SI				:= 'S';			# Valor para Si
	SET	Var_NO	 			:= 'N';			# Valor para Si
	SET CreReestructura		:= 'R';			# Tratamiento : reestructura
	SET Estatus_Desemb		:= 'D';			# Estatus desembolsado


	# Asignacion  de variables
	SET Par_SucursalID		:= IFNULL(Par_SucursalID,Entero_Cero);
	SET Par_MonedaID		:= IFNULL(Par_MonedaID,Entero_Cero);
	SET Par_ProducCreOr		:= IFNULL(Par_ProducCreOr,Entero_Cero);
	SET Par_ProducCreDe		:= IFNULL(Par_ProducCreDe,Entero_Cero);
	SET Par_UsuarioID		:= IFNULL(Par_UsuarioID,Entero_Cero);
	SET Par_EstadoID		:= IFNULL(Par_EstadoID,Entero_Cero);
	SET Par_MunicipioID		:= IFNULL(Par_MunicipioID,Entero_Cero);


	SELECT	RestringeReporte
		INTO Var_RestringeReporte
	FROM PARAMETROSSIS LIMIT 1;
	SET Var_RestringeReporte:= IFNULL(Var_RestringeReporte,'N');
	
	# Datos
	SET Var_Sentencia := 'select (select SucursalUsuario from USUARIOS  WHERE UsuarioID=Ree.UsuarioID) as SucursalID,Suc.NombreSucurs, 	';
	SET Var_Sentencia := CONCAT(Var_Sentencia,'Ree.FechaRegistro,		Ree.UsuarioID, Usu.NombreCompleto as NombreUsuario,');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' Ree.CreditoOrigenID,	Pro.Descripcion as NombProdCreOrig,	Cre.MontoCredito as ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' MontoCreditoOrig, Ree.SaldoCredAnteri,	Cre.FechaInicio,	');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' Cre.FechaVencimien, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' case when Ree.EstatusCredAnt="I" then "INACTIVO"  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCredAnt="A" then "AUTORIZADO"   ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCredAnt="V" then "VIGENTE"   ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCredAnt="P" then "PAGADO"  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCredAnt="C" then "CANCELADO" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCredAnt="B" then "VENCIDO"  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCredAnt="K" then "CASTIGADO"  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCredAnt="S" then "SUSPENDIDO"  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' end as EstatusCredAnt, Ree.NumDiasAtraOri, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' Ree.CreditoDestinoID,	ProDe.Descripcion as NombProdCreReest ,');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' CreDe.MontoAutorizado as MontoCreditoRees, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' case when Ree.EstatusCreacion="I" then "INACTIVO"  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCreacion="A" then "AUTORIZADO"   ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCreacion="V" then "VIGENTE"   ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCreacion="P" then "PAGADO"  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCreacion="C" then "CANCELADO" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCreacion="B" then "VENCIDO"  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCreacion="K" then "CASTIGADO"  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' when Ree.EstatusCreacion="S" then "SUSPENDIDO"  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' end as EstatusCreacion,  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' Ree.NumPagoSoste,	Ree.NumPagoActual,	');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' Cli.ClienteID,	');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' Cli.NombreCompleto as NombreSocio,	');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' SUM(ROUND(Amo.SaldoCapVigente,2) + ROUND(Amo.SaldoCapAtrasa,2) +
													ROUND(Amo.SaldoCapVencido,2) + ROUND(Amo.SaldoCapVenNExi,2)) as SaldoCapital,	');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' SUM(ROUND(Amo.SaldoInteresOrd + Amo.SaldoInteresAtr +
														  Amo.SaldoInteresVen + Amo.SaldoInteresPro + Amo.SaldoIntNoConta,2) +
													ROUND(CASE WHEN Cli.PagaIVA = "', Var_SI, '" AND ProDe.CobraIVAInteres = "', Var_SI, '"
																			THEN Amo.SaldoInteresOrd * SucC.IVA +
																				 Amo.SaldoInteresPro * SucC.IVA +
																				 Amo.SaldoInteresAtr * SucC.IVA +
																				 Amo.SaldoInteresVen * SucC.IVA +
																				 Amo.SaldoIntNoConta * SucC.IVA
																			ELSE ',Entero_Cero , '
														  END , 2) )  as SaldoInteres, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' SUM(ROUND(Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen,2) +
													ROUND(CASE WHEN Cli.PagaIVA = "', Var_SI, '" AND ProDe.CobraIVAMora = "', Var_SI, '"
																			THEN Amo.SaldoMoratorios * SucC.IVA +
																				 Amo.SaldoMoraVencido * SucC.IVA +
																				 Amo.SaldoMoraCarVen * SucC.IVA
																			ELSE ',Entero_Cero , '
														  END, 2)) as SaldoInteresMora,');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' FUNCIONTOTDEUDACRE(Ree.CreditoDestinoID)  as TotalAdeudo');

    SET Var_Sentencia := CONCAT(Var_Sentencia,' FROM	REESTRUCCREDITO Ree  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CREDITOS	Cre ON Cre.CreditoID = Ree.CreditoOrigenID ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN AMORTICREDITO	Amo ON Cre.CreditoID = Amo.CreditoID ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN SOLICITUDCREDITO CreDe ON (Cre.CreditoID = CreDe.Relacionado AND Cre.SolicitudCreditoID = CreDe.SolicitudCreditoID) ');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CLIENTES	Cli ON Cli.ClienteID = Cre.ClienteID ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO ProDe ON CreDe.ProductoCreditoID = ProDe.ProducCreditoID ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN USUARIOS Usu ON Usu.UsuarioID = Ree.UsuarioID ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES SucC ON SucC.SucursalID = Cli.SucursalOrigen ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES Suc ON ((select SucursalUsuario from USUARIOS  WHERE UsuarioID=Ree.UsuarioID) = Suc.SucursalID)');

	SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE   Ree.Origen = "', CreReestructura, '"');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' AND 	Ree.EstatusReest = "', Estatus_Desemb, '"');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' AND 	Ree.FechaRegistro >= ?');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' AND 	Ree.FechaRegistro <= ? ');


	IF(Par_UsuarioID != Entero_Cero) THEN
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Ree.UsuarioID =',CONVERT(Par_UsuarioID,CHAR));
	END IF;

	IF(Par_MonedaID != Entero_Cero) THEN
        SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND CreDe.MonedaID =',CONVERT(Par_MonedaID,CHAR));
    END IF;

	IF(Par_SucursalID != Entero_Cero) THEN
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND (select SucursalUsuario from USUARIOS  WHERE UsuarioID=Ree.UsuarioID) =',CONVERT(Par_SucursalID,CHAR));
	END IF;

	IF(Par_ProducCreOr != Entero_Cero) THEN
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Cre.ProductoCreditoID=',CONVERT(Par_ProducCreOr,CHAR));
	END IF;

	IF(Par_ProducCreDe != Entero_Cero) THEN
		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND CreDe.ProductoCreditoID=',CONVERT(Par_ProducCreDe,CHAR));
	END IF;

	IF(Par_EstadoID != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,' AND (select Dir.EstadoID from DIRECCLIENTE Dir where Cre.ClienteID=Dir.ClienteID and Dir.Oficial="S")=',CONVERT(Par_EstadoID,CHAR));
	END IF;

	IF(Par_MunicipioID != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,' AND (select Dir.MunicipioID from DIRECCLIENTE Dir where Cre.ClienteID=Dir.ClienteID and Dir.Oficial="S")=',convert(Par_MunicipioID,CHAR));
	END IF;
    
    -- CUANDO EL PARAMETRO RESTRINGE CARTERA ES SI, MOSTRARA LA INFORMACION POR USUARIO DE ACUERDO AL CRONOGRAMA
	IF(Var_RestringeReporte = 'S')THEN
		
        -- OBTENEMOS LOS USUARIOS QUE SON DEPENDENCIAS
        SET Var_UsuDependencia := (SELECT FNUSUARIOSDEPENDECIA(Aud_Usuario));

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Ree.UsuarioID IN(',Var_UsuDependencia,')');

	END IF; 

    SET Var_Sentencia := CONCAT(Var_Sentencia,' GROUP BY Cre.CreditoID, Ree.UsuarioID, Suc.NombreSucurs, Ree.FechaRegistro, Ree.SaldoCredAnteri, Ree.EstatusCredAnt, Ree.NumDiasAtraOri, Ree.CreditoDestinoID');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' ORDER BY (select SucursalUsuario from USUARIOS  WHERE UsuarioID=Ree.UsuarioID), Ree.UsuarioID, Ree.FechaRegistro; ');

	SET @Sentencia	    = (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

   PREPARE STREESTRUCCREDITOREP FROM @Sentencia;
   EXECUTE STREESTRUCCREDITOREP USING @FechaInicio, @FechaFin;
   DEALLOCATE PREPARE STREESTRUCCREDITOREP;

END TerminaStore$$
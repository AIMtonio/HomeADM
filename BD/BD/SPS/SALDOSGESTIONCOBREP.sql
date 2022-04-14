-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSGESTIONCOBREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSGESTIONCOBREP`;
DELIMITER $$

CREATE PROCEDURE `SALDOSGESTIONCOBREP`(
/* SP DE REPORTE PARA SALDOS DE CARTERA, AVALES Y REFERENCIAS */
	Par_Fecha				DATE,
	Par_Sucursal			INT(11),
	Par_Moneda				INT(11),
	Par_ProductoCre			INT(11),
	Par_Promotor   			INT(11),

	Par_Genero  			CHAR(1),
	Par_Estado 				INT(11),
	Par_Municipio	   		INT(11),
	Par_AtrasoInicial   	INT(11),
	Par_AtrasoFinal   		INT(11),

	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	pagoExigible		DECIMAL(12,2);
	DECLARE	TotalCartera		DECIMAL(12,2);
	DECLARE	TotalCapVigent		DECIMAL(12,2);
	DECLARE	TotalCapVencido		DECIMAL(12,2);
	DECLARE	nombreUsuario		VARCHAR(50);
	DECLARE Var_Sentencia 		VARCHAR(6000);
	DECLARE Var_IVA				DECIMAL(12,2);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Entero_Uno			INT(11);
	DECLARE	Lis_SaldosRep		INT(11);
	DECLARE	Con_Foranea			INT(11);
	DECLARE	ReferenciaUno		INT(11);
	DECLARE	ReferenciaDos		INT(11);
	DECLARE ReferenciaTres 		INT(11);
	DECLARE	ReferenciaCuatro	INT(11);
	DECLARE	EstatusVigente		CHAR(1);
	DECLARE	EstatusAtras		CHAR(1);
	DECLARE	EstatusPagado		CHAR(1);
	DECLARE	EstatusVencido		CHAR(1);
	DECLARE EstatusSuspendido	CHAR(1);		-- Estatus Suspendido del Credito

	DECLARE	Decimal_Cero		DECIMAL(10,2);
	DECLARE	CienPorciento		DECIMAL(10,2);
	DECLARE	FechaSist			DATE;
	DECLARE Var_PerFisica 		CHAR(1);
	DECLARE SiCobraIVA			CHAR(1);
	DECLARE Str_SI				CHAR(1);
	DECLARE EstatusAutorizado	CHAR(1);
	DECLARE FormatoTelefono		VARCHAR(15);
	DECLARE SinNumero			VARCHAR(10);
	DECLARE PrefijoNumero		VARCHAR(10);

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Entero_Uno			:= 1;
	SET	Lis_SaldosRep		:= 4;
	SET	EstatusVigente		:= 'V';
	SET	EstatusAtras		:= 'A';
	SET	EstatusPagado		:= 'P';
	SET	CienPorciento		:= 100.00;
	SET	EstatusVencido		:= 'B';
	SET EstatusSuspendido	:= 'S';		-- Estatus Suspendido del Credito
	SET Var_PerFisica 		:= 'F';
	SET	SiCobraIVA 			:= 'S';
	SET	Str_SI	 			:= 'S';
	SET	EstatusAutorizado	:= 'U';
	SET	Decimal_Cero		:= 0.0;
	SET	ReferenciaUno		:= 1;
	SET	ReferenciaDos		:= 2;
	SET	ReferenciaTres		:= 3;
	SET	ReferenciaCuatro	:= 4;
	SET	FormatoTelefono		:= '(###) ###-####';
	SET	SinNumero			:= ' SN';
	SET	PrefijoNumero		:= ' NO. ';

	TRUNCATE TMPSALDOSGESTIONCOB;
	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_Sentencia :=  '
		INSERT INTO TMPSALDOSGESTIONCOB (
			Transaccion,		GrupoID,			NombreGrupo,		CreditoID,			CicloGrupo,
			ClienteID,			NombreCompleto,		MontoCredito,		FechaInicio,		FechaVencimien,
			FechaVencim,		EstatusCredito,		Capital,			Interes,			Moratorios,
			Comisiones,			Cargos,				AmortizacionID,		IVATotal,			CobraIVAMora,
			CobraIVAInteres,	SucursalID,			NombreSucurs,		ProductoCreditoID,	Descripcion,
			PromotorActual,		NombrePromotor,		TotalCuota,			Pago,				FechaPago,
			DiasAtraso,			SaldoTotal,			FechaEmision,		HoraEmision,		Telefono,
            Celular,			SolicitudCreditoID,	CapitalVencido,		MontoSeguroCuota,	IVASeguroCuota)
		';
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' select  0,ifnull(Gpo.GrupoID,0), ifnull(Gpo.NombreGrupo,""),Cre.CreditoID,ifnull(Cre.CicloGrupo, 0),Cre.ClienteID,Cli.NombreCompleto,Cre.MontoCredito,Cre.FechaInicio,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' Cre.FechaVencimien, Amc.FechaVencim,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' case 	when Cre.Estatus="I" then "INACTIVO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, '			when Cre.Estatus="A" then "AUTORIZADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="V" then "VIGENTE"  ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="P" then "PAGADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="C" then "CANCELADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="B" then "VENCIDO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="K" then "CASTIGADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="S" then "SUSPENDIDO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		end as EstatusCredito,');

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (Amc.SaldoCapVigente + Amc.SaldoCapAtrasa + Amc.SaldoCapVenNExi) as Capital,');
        SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (round(Amc.SaldoInteresOrd,2) + round(Amc.SaldoInteresAtr,2)  + round(Amc.SaldoInteresVen,2) ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' + round(Amc.SaldoInteresPro,2)  + round(Amc.SaldoIntNoConta,2) ) as Interes,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen)  as Moratorios,');
        SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (Amc.SaldoComFaltaPa + Amc.SaldoComServGar  + Amc.SaldoOtrasComis) as Comisiones,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0.00 as  Cargos,Amc.AmortizacionID,');

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' round( (');


		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' case when  Cli.PagaIVA="',SiCobraIVA,'"   or Cli.PagaIVA is NULL then');-- IVA  COMISIONES
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' round( (Amc.SaldoComFaltaPa + Amc.SaldoComServGar)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' * (select IVA from SUCURSALES  where  SucursalID = Cre.SucursalID))+(FNEXIGIBLEIVAACCESORIOS(Cre.CreditoID, Amc.AmortizacionID,(select IVA from SUCURSALES  where  SucursalID = Cre.SucursalID), Cli.PagaIVA))');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' else 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' end'); --  IvaComisiones+

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0.00'); --  IVA CARGOS+

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' case when   Pro.CobraIVAInteres="',SiCobraIVA,'"   or Pro.CobraIVAInteres is NULL  then');-- IVA INTERES
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (round(Amc.SaldoInteresOrd,2) + round(Amc.SaldoInteresAtr,2)  + round(Amc.SaldoInteresVen,2)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' + round(Amc.SaldoInteresPro,2)  + round(Amc.SaldoIntNoConta,2) ) ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' * (select IVA from SUCURSALES  where  SucursalID = Cre.SucursalID)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' else 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' end'); -- as IvaInteres

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' case when   Pro.CobraIVAMora="',SiCobraIVA,'"  or Pro.CobraIVAMora is NULL then');-- IVA MORATORIO
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' round((Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen) * (select IVA from SUCURSALES  where  SucursalID = Cre.SucursalID),2)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' else 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' end'); --  IvaMoratorio = IVATotal

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ) , 2 ) as IVATotal,Pro.CobraIVAMora,Pro.CobraIVAInteres,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' Cre.SucursalID, Suc.NombreSucurs,Cre.ProductoCreditoID, Pro.Descripcion, Cli.PromotorActual,PROM.NombrePromotor,');



		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (Amc.SaldoCapVigente + Amc.SaldoCapAtrasa + Amc.SaldoCapVencido + Amc.SaldoCapVenNExi +');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' round(Amc.SaldoInteresOrd,2) + round(Amc.SaldoInteresAtr,2)  + round(Amc.SaldoInteresVen,2)  ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' + round(Amc.SaldoInteresPro,2)  + round(Amc.SaldoIntNoConta,2) +');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen)+ Amc.SaldoComFaltaPa + Amc.SaldoComServGar + Amc.SaldoOtrasComis + 0.00 +  ');

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' round( (');


		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' case when  Cli.PagaIVA="',SiCobraIVA,'"   or Cli.PagaIVA is NULL then');-- IVA  COMISIONES
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' round( (Amc.SaldoComFaltaPa + Amc.SaldoComServGar)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' * (select IVA from SUCURSALES  where  SucursalID = Cre.SucursalID))+(FNEXIGIBLEIVAACCESORIOS(Cre.CreditoID, Amc.AmortizacionID,(select IVA from SUCURSALES  where  SucursalID = Cre.SucursalID), Cli.PagaIVA))');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' else 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' end'); --  IvaComisiones+

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0.00'); --  IVA CARGOS+

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' case when   Pro.CobraIVAInteres="',SiCobraIVA,'"   or Pro.CobraIVAInteres is NULL  then');-- IVA INTERES
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (round(Amc.SaldoInteresOrd,2) + round(Amc.SaldoInteresAtr,2)  + round(Amc.SaldoInteresVen,2)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' + round(Amc.SaldoInteresPro,2)  + round(Amc.SaldoIntNoConta,2) ) ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' * (select IVA from SUCURSALES  where  SucursalID = Cre.SucursalID)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' else 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' end'); -- as IvaInteres

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' +');-- mas el seguro y el iva del seguro

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' case when   Pro.CobraIVAMora="',SiCobraIVA,'"  or Pro.CobraIVAMora is NULL then');-- IVA MORATORIO
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' round((Amc.SaldoMoratorios + Amc.SaldoMoraVencido + Amc.SaldoMoraCarVen)  * (select IVA from SUCURSALES  where  SucursalID = Cre.SucursalID),2)');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' else 0.00');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' end'); --  IvaMoratorio = IVATotal

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' + round(Amc.SaldoSeguroCuota,2) + round(Amc.SaldoIVASeguroCuota,2) ) , 2 )  ) as TotalCuota,');


		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' IFNULL((select SUM(DET.MontoTotPago) from DETALLEPAGCRE DET where');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' DET.AmortizacionID=Amc.AmortizacionID and Amc.CreditoID=DET.CreditoID');
        SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' group by DET.AmortizacionID,DET.CreditoID),0) as Pago, ');



		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' IFNULL((select MAX(FechaPago) from DETALLEPAGCRE DET where');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' DET.AmortizacionID=Amc.AmortizacionID and Amc.CreditoID=DET.CreditoID');
        SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' group by DET.AmortizacionID,DET.CreditoID),"1900-01-01") as FechaPago ,');


		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' (select  datediff( Par.FechaSistema, ifnull(min(Amo.FechaExigible), Par.FechaSistema)) from AMORTICREDITO Amo where Amo.CreditoID = Amc.CreditoID  ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, '   and Amo.Estatus in ("V", "A", "B") ) as DiasAtraso, ');

		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' 0.0 as SaldoTotal, "1900-01-01" as FechaEmision, "12:00:00" as HoraEmision, Cli.Telefono, Cli.TelefonoCelular, Cre.SolicitudCreditoID,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' Amc.SaldoCapVencido as CapitalVencido,Amc.SaldoSeguroCuota,	Amc.SaldoIVASeguroCuota');

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' from CREDITOS Cre ');

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' inner join  PARAMETROSSIS Par on Par.EmpresaID=Par.EmpresaID ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' inner join AMORTICREDITO Amc ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' on Amc.CreditoID = Cre.CreditoID');


		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' inner join PRODUCTOSCREDITO Pro on Cre.ProductoCreditoID = Pro.ProducCreditoID ');


				SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
                IF(Par_ProductoCre!=0)THEN
                    SET Var_Sentencia :=  CONCAT(Var_sentencia,' and Pro.ProducCreditoID =',CONVERT(Par_ProductoCre,CHAR));
                END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,'  inner join CLIENTES Cli on Cre.ClienteID = Cli.ClienteID');

		SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
                IF(Par_Genero!=Cadena_Vacia)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,' and Cli.Sexo="',Par_Genero,'"');
                    SET Var_Sentencia := CONCAT(Var_sentencia,' and Cli.TipoPersona="',Var_PerFisica,'"');
		END IF;


		SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
                IF(Par_Estado!=0)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,' and (select Dir.EstadoID from DIRECCLIENTE Dir where Dir.Oficial= "S" and Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
                END IF;

		SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
                IF(Par_Municipio!=0)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,' and (select Dir.MunicipioID from DIRECCLIENTE Dir where Dir.Oficial="S" and Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
                END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' inner join PROMOTORES PROM on PROM.PromotorID=Cli.PromotorActual ');

		SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
                IF(Par_Promotor!=0)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,'   and PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
                END IF;

		SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
                IF(Par_Moneda!=0)THEN
                    SET Var_Sentencia = CONCAT(Var_sentencia,' and Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
                END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' inner join SUCURSALES Suc on Suc.SucursalID = Cre.SucursalID ');

		SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
                IF(Par_Sucursal!=0)THEN
                    SET Var_Sentencia = CONCAT(Var_sentencia,' and Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
                END IF;
		SET Var_Sentencia = CONCAT(Var_sentencia,' left join GRUPOSCREDITO Gpo on Gpo.GrupoID = Cre.GrupoID ');

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' where	(Cre.Estatus	= "',EstatusVigente,'" or Cre.Estatus = "',EstatusVencido,'" or Cre.Estatus = "',EstatusSuspendido,'") ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' and Amc.FechaExigible <= "',Par_Fecha,'" ');
  		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' order by Cre.SucursalID, Cre.ProductoCreditoID, Cli.PromotorActual,Cre.CreditoID,Amc.FechaVencim;');

	SET @Sentencia	= (Var_Sentencia);

	PREPARE STSALDOSCAPITALREP FROM @Sentencia;
	EXECUTE STSALDOSCAPITALREP;
	DEALLOCATE PREPARE STSALDOSCAPITALREP;

    /* INICIO PARA CReDITOS NUEVOS. LOS VALORES DEBEN SER CERO */
    SET Var_Sentencia :=  '
		INSERT INTO TMPSALDOSGESTIONCOB (
			Transaccion,		GrupoID,			NombreGrupo,		CreditoID,			CicloGrupo,
			ClienteID,			NombreCompleto,		MontoCredito,		FechaInicio,		FechaVencimien,
			FechaVencim,		EstatusCredito,		Capital,			Interes,			Moratorios,
			Comisiones,			Cargos,				AmortizacionID,		IVATotal,			CobraIVAMora,
			CobraIVAInteres,	SucursalID,			NombreSucurs,		ProductoCreditoID,	Descripcion,
			PromotorActual,		NombrePromotor,		TotalCuota,			Pago,				FechaPago,
			DiasAtraso,			SaldoTotal,			FechaEmision,		HoraEmision,		Telefono,
            Celular,			SolicitudCreditoID,	CapitalVencido,		MontoSeguroCuota,	IVASeguroCuota)
		';
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' select  0,ifnull(Gpo.GrupoID,0), ifnull(Gpo.NombreGrupo,""),Cre.CreditoID,ifnull(Cre.CicloGrupo, 0),Cre.ClienteID,Cli.NombreCompleto,Cre.MontoCredito,Cre.FechaInicio,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' Cre.FechaVencimien, Amc.FechaVencim,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' case 	when Cre.Estatus="I" then "INACTIVO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, '			when Cre.Estatus="A" then "AUTORIZADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="V" then "VIGENTE"  ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="P" then "PAGADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="C" then "CANCELADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="B" then "VENCIDO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="K" then "CASTIGADO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Cre.Estatus="S" then "SUSPENDIDO" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		end as EstatusCredito,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0 as Capital,0 as Interes, 0 as Moratorios, 0 as Comisiones,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0.00 as  Cargos,Amc.AmortizacionID,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0 as IVATotal,Pro.CobraIVAMora,Pro.CobraIVAInteres,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' Cre.SucursalID, Suc.NombreSucurs,Cre.ProductoCreditoID, Pro.Descripcion, Cli.PromotorActual,PROM.NombrePromotor,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0 as TotalCuota, 0 as Pago, "1900-01-01" as FechaPago , 0 as DiasAtraso, ');
		SET Var_Sentencia :=  	CONCAT(Var_Sentencia, ' 0.0 as SaldoTotal, "1900-01-01" as FechaEmision, "12:00:00" as HoraEmision, Cli.Telefono, Cli.TelefonoCelular, Cre.SolicitudCreditoID,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0 as CapitalVencido, 0 as MontoSeguroCuota, 0 as IVASeguroCuota');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' from CREDITOS Cre ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' inner join  PARAMETROSSIS Par on Par.EmpresaID=Par.EmpresaID ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' inner join AMORTICREDITO Amc ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' on Amc.CreditoID = Cre.CreditoID');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' inner join PRODUCTOSCREDITO Pro on Cre.ProductoCreditoID = Pro.ProducCreditoID ');

		SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);

        IF(Par_ProductoCre!=0)THEN
            SET Var_Sentencia :=  CONCAT(Var_sentencia,' and Pro.ProducCreditoID =',CONVERT(Par_ProductoCre,CHAR));
        END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,'  inner join CLIENTES Cli on Cre.ClienteID = Cli.ClienteID');

		SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
                IF(Par_Genero!=Cadena_Vacia)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,' and Cli.Sexo="',Par_Genero,'"');
                    SET Var_Sentencia := CONCAT(Var_sentencia,' and Cli.TipoPersona="',Var_PerFisica,'"');
		END IF;

		SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
                IF(Par_Estado!=0)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,' and (select Dir.EstadoID from DIRECCLIENTE Dir where Dir.Oficial= "S" and Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
                END IF;

		SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
                IF(Par_Municipio!=0)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,' and (select Dir.MunicipioID from DIRECCLIENTE Dir where Dir.Oficial="S" and Cli.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
                END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia,' inner join PROMOTORES PROM on PROM.PromotorID=Cli.PromotorActual ');

		SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
                IF(Par_Promotor!=0)THEN
                    SET Var_Sentencia := CONCAT(Var_sentencia,'   and PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
                END IF;

		SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
                IF(Par_Moneda!=0)THEN
                    SET Var_Sentencia = CONCAT(Var_sentencia,' and Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
                END IF;

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' inner join SUCURSALES Suc on Suc.SucursalID = Cre.SucursalID ');

		SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
                IF(Par_Sucursal!=0)THEN
                    SET Var_Sentencia = CONCAT(Var_sentencia,' and Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
                END IF;
		SET Var_Sentencia = CONCAT(Var_sentencia,' left join GRUPOSCREDITO Gpo on Gpo.GrupoID = Cre.GrupoID ');

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' where	(Cre.Estatus	= "',EstatusVigente,'" or Cre.Estatus = "',EstatusVencido,'" or Cre.Estatus = "',EstatusSuspendido,'") ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' and Amc.FechaInicio <= "',Par_Fecha,'" ');
  		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' order by Cre.SucursalID, Cre.ProductoCreditoID, Cli.PromotorActual,Cre.CreditoID,Amc.FechaVencim;');

	SET @Sentencia	= (Var_Sentencia);
	PREPARE STSALDOSCAPITALREP2 FROM @Sentencia;
	EXECUTE STSALDOSCAPITALREP2;
	DEALLOCATE PREPARE STSALDOSCAPITALREP2;
    /* FIN PARA CReDITOS NUEVOS. LOS VALORES DEBEN SER CERO */

	-- SE ACTUALIZAN DATOS DEL DOMICILIO
	UPDATE TMPSALDOSGESTIONCOB T INNER JOIN DIRECCLIENTE Dir ON T.ClienteID=Dir.ClienteID
		INNER JOIN ESTADOSREPUB  	Est 	ON Dir.EstadoID = Est.EstadoID
		INNER JOIN MUNICIPIOSREPUB 	Mun		ON Dir.EstadoID = Mun.EstadoID		AND Dir.MunicipioID = Mun.MunicipioID
		INNER JOIN LOCALIDADREPUB 	Loc		ON Dir.EstadoID = Loc.EstadoID		AND Dir.MunicipioID = Loc.MunicipioID
																				AND Dir.LocalidadID	= Loc.LocalidadID
	SET T.CalleNumero 	= UPPER(CONCAT(IFNULL(Calle,Cadena_Vacia),IF(LENGTH(IFNULL(NumeroCasa,Cadena_Vacia))>Entero_Cero,CONCAT(PrefijoNumero,NumeroCasa),SinNumero))),
		T.NombreColonia = Dir.Colonia,
		T.CP			= Dir.CP,
		T.NombreLocalidad = Loc.NombreLocalidad,
		T.NombreEstado	= Est.Nombre
		WHERE Dir.Oficial = Str_SI;

	-- SE ACTUALIZAN DE LA REFERENCIA 1
	UPDATE TMPSALDOSGESTIONCOB T INNER JOIN REFERENCIACLIENTE R ON T.SolicitudCreditoID=R.SolicitudCreditoID
		INNER JOIN ESTADOSREPUB  	Est 	ON R.EstadoID = Est.EstadoID
		INNER JOIN MUNICIPIOSREPUB 	Mun		ON R.EstadoID = Mun.EstadoID		AND R.MunicipioID = Mun.MunicipioID
		INNER JOIN LOCALIDADREPUB 	Loc		ON R.EstadoID = Loc.EstadoID		AND R.MunicipioID = Loc.MunicipioID
																				AND R.LocalidadID = Loc.LocalidadID
		INNER JOIN COLONIASREPUB 	Col 	ON R.EstadoID = Col.EstadoID		AND R.MunicipioID = Col.MunicipioID
																				AND R.ColoniaID	= Col.ColoniaID
	SET T.NombreReferencia1 = UPPER(R.NombreCompleto),
		T.TelefonoRef1 		= R.Telefono,
		T.CalleNumeroRef1 	= UPPER(CONCAT(IFNULL(Calle,Cadena_Vacia),IF(LENGTH(IFNULL(NumeroCasa,Cadena_Vacia))>Entero_Cero,CONCAT(PrefijoNumero,NumeroCasa),SinNumero))),
		T.NombreColoniaRef1	= CONCAT(Col.TipoAsenta,' ', Col.Asentamiento),
		T.CPRef1			= R.CP,
		T.NombreLocalidadRef1 = Loc.NombreLocalidad,
		T.NombreEstadoRef1	= Est.Nombre
		WHERE R.Consecutivo = ReferenciaUno;

	-- SE ACTUALIZAN DE LA REFERENCIA 2
	UPDATE TMPSALDOSGESTIONCOB T INNER JOIN REFERENCIACLIENTE R ON T.SolicitudCreditoID=R.SolicitudCreditoID
		INNER JOIN ESTADOSREPUB  	Est 	ON R.EstadoID = Est.EstadoID
		INNER JOIN MUNICIPIOSREPUB 	Mun		ON R.EstadoID = Mun.EstadoID		AND R.MunicipioID = Mun.MunicipioID
		INNER JOIN LOCALIDADREPUB 	Loc		ON R.EstadoID = Loc.EstadoID		AND R.MunicipioID = Loc.MunicipioID
																				AND R.LocalidadID = Loc.LocalidadID
		INNER JOIN COLONIASREPUB 	Col 	ON R.EstadoID = Col.EstadoID		AND R.MunicipioID = Col.MunicipioID
																				AND R.ColoniaID	= Col.ColoniaID
	SET T.NombreReferencia2 = UPPER(R.NombreCompleto),
		T.TelefonoRef2 		= R.Telefono,
		T.CalleNumeroRef2 	= UPPER(CONCAT(IFNULL(Calle,Cadena_Vacia),IF(LENGTH(IFNULL(NumeroCasa,Cadena_Vacia))>Entero_Cero,CONCAT(PrefijoNumero,NumeroCasa),SinNumero))),
		T.NombreColoniaRef2	= CONCAT(Col.TipoAsenta,' ', Col.Asentamiento),
		T.CPRef2			= R.CP,
		T.NombreLocalidadRef2 = Loc.NombreLocalidad,
		T.NombreEstadoRef2	= Est.Nombre
		WHERE R.Consecutivo = ReferenciaDos;

	-- SE ACTUALIZAN DE LA REFERENCIA 3
	UPDATE TMPSALDOSGESTIONCOB T INNER JOIN REFERENCIACLIENTE R ON T.SolicitudCreditoID=R.SolicitudCreditoID
		INNER JOIN ESTADOSREPUB  	Est 	ON R.EstadoID = Est.EstadoID
		INNER JOIN MUNICIPIOSREPUB 	Mun		ON R.EstadoID = Mun.EstadoID		AND R.MunicipioID = Mun.MunicipioID
		INNER JOIN LOCALIDADREPUB 	Loc		ON R.EstadoID = Loc.EstadoID		AND R.MunicipioID = Loc.MunicipioID
																				AND R.LocalidadID = Loc.LocalidadID
		INNER JOIN COLONIASREPUB 	Col 	ON R.EstadoID = Col.EstadoID		AND R.MunicipioID = Col.MunicipioID
																				AND R.ColoniaID	= Col.ColoniaID
	SET T.NombreReferencia3 = UPPER(R.NombreCompleto),
		T.TelefonoRef3 		= R.Telefono,
		T.CalleNumeroRef3 	= UPPER(CONCAT(IFNULL(Calle,Cadena_Vacia),IF(LENGTH(IFNULL(NumeroCasa,Cadena_Vacia))>Entero_Cero,CONCAT(PrefijoNumero,NumeroCasa),SinNumero))),
		T.NombreColoniaRef3	= CONCAT(Col.TipoAsenta,' ', Col.Asentamiento),
		T.CPRef3			= R.CP,
		T.NombreLocalidadRef3 = Loc.NombreLocalidad,
		T.NombreEstadoRef3	= Est.Nombre
		WHERE R.Consecutivo = ReferenciaTres;

	-- SE ACTUALIZAN DE LA REFERENCIA 4
	UPDATE TMPSALDOSGESTIONCOB T INNER JOIN REFERENCIACLIENTE R ON T.SolicitudCreditoID=R.SolicitudCreditoID
		INNER JOIN ESTADOSREPUB  	Est 	ON R.EstadoID = Est.EstadoID
		INNER JOIN MUNICIPIOSREPUB 	Mun		ON R.EstadoID = Mun.EstadoID		AND R.MunicipioID = Mun.MunicipioID
		INNER JOIN LOCALIDADREPUB 	Loc		ON R.EstadoID = Loc.EstadoID		AND R.MunicipioID = Loc.MunicipioID
																				AND R.LocalidadID = Loc.LocalidadID
		INNER JOIN COLONIASREPUB 	Col 	ON R.EstadoID = Col.EstadoID		AND R.MunicipioID = Col.MunicipioID
																				AND R.ColoniaID	= Col.ColoniaID
	SET T.NombreReferencia4 = UPPER(R.NombreCompleto),
		T.TelefonoRef4 		= R.Telefono,
		T.CalleNumeroRef4 	= UPPER(CONCAT(IFNULL(Calle,Cadena_Vacia),IF(LENGTH(IFNULL(NumeroCasa,Cadena_Vacia))>Entero_Cero,CONCAT(PrefijoNumero,NumeroCasa),SinNumero))),
		T.NombreColoniaRef4	= CONCAT(Col.TipoAsenta,' ', Col.Asentamiento),
		T.CPRef4			= R.CP,
		T.NombreLocalidadRef4 = Loc.NombreLocalidad,
		T.NombreEstadoRef4	= Est.Nombre
		WHERE R.Consecutivo = ReferenciaCuatro;

	-- SE OBTIENEN LOS DATOS DE LOS AVALES
	-- Variables auxiliares
	SET @consecutivo = Entero_Cero;
	SET @SolcitudCredT = Entero_Cero;

	TRUNCATE TMPAVALESPORSOLICI;
	INSERT INTO TMPAVALESPORSOLICI(
		SolicitudCreditoID,	Consecutivo,		AvalID,			NombreCompleto,		Telefono,
        Calle,				Numero,				CP,				EstadoID,			NombreEstado,
		MunicipioID,		NombreMunicipio,	LocalidadID,	NombreLocalidad,	ColoniaID,
		NombreColonia)
	SELECT DISTINCT
		aps.SolicitudCreditoID,
		Entero_Cero,
		COALESCE(cl.ClienteID,av.AvalID,ps.ProspectoID)AS Aval,
		COALESCE(cl.NombreCompleto,av.NombreCompleto,ps.NombreCompleto)AS NombreCompleto,
		COALESCE(cl.Telefono,av.Telefono,ps.Telefono)AS Telefono,
		COALESCE(dc.Calle,av.Calle,ps.Calle) AS Calle,
		COALESCE(dc.NumeroCasa,av.NumExterior,ps.NumExterior) AS Numero,
		COALESCE(dc.CP,av.CP,ps.CP) AS CP,
		COALESCE(dc.EstadoID,av.EstadoID,ps.EstadoID) AS EstadoID, Cadena_Vacia,
		COALESCE(dc.MunicipioID,av.MunicipioID,ps.MunicipioID) AS MunicipioID, Cadena_Vacia,
		COALESCE(dc.LocalidadID,av.LocalidadID,ps.LocalidadID) AS LocalidadID, Cadena_Vacia,
		COALESCE(dc.ColoniaID,av.ColoniaID,ps.ColoniaID) AS ColoniaID,
		Cadena_Vacia
	FROM
		AVALESPORSOLICI aps
        INNER JOIN TMPSALDOSGESTIONCOB tmp ON aps.SolicitudCreditoID = tmp.SolicitudCreditoID
		LEFT OUTER JOIN AVALES 			av ON av.AvalID 		= aps.AvalID
		LEFT OUTER JOIN CLIENTES		cl ON cl.ClienteID 		= aps.ClienteID
		LEFT OUTER JOIN DIRECCLIENTE	dc ON dc.ClienteID 		= cl.ClienteID AND Oficial = Str_SI
		LEFT OUTER JOIN PROSPECTOS		ps ON ps.ProspectoID 	= aps.ProspectoID
	WHERE
		aps.Estatus = EstatusAutorizado
	ORDER BY aps.SolicitudCreditoID;

    UPDATE TMPAVALESPORSOLICI aps
    SET Consecutivo = IF(@SolcitudCredT!= aps.SolicitudCreditoID,(@consecutivo := 1),(@consecutivo := @consecutivo +1)),
		NombreColonia = IF(@SolcitudCredT!= aps.SolicitudCreditoID, @SolcitudCredT:=aps.SolicitudCreditoID,Entero_Cero);

	-- SE ACTUALIZAN LOS DATOS DE LOS AVALES (AVAL1)
	UPDATE TMPSALDOSGESTIONCOB T INNER JOIN TMPAVALESPORSOLICI R ON T.SolicitudCreditoID=R.SolicitudCreditoID
		INNER JOIN ESTADOSREPUB  	Est 	ON R.EstadoID = Est.EstadoID
		INNER JOIN MUNICIPIOSREPUB 	Mun		ON R.EstadoID = Mun.EstadoID		AND R.MunicipioID = Mun.MunicipioID
		INNER JOIN LOCALIDADREPUB 	Loc		ON R.EstadoID = Loc.EstadoID		AND R.MunicipioID = Loc.MunicipioID
																				AND R.LocalidadID = Loc.LocalidadID
		INNER JOIN COLONIASREPUB 	Col 	ON R.EstadoID = Col.EstadoID		AND R.MunicipioID = Col.MunicipioID
																				AND R.ColoniaID	= Col.ColoniaID
	SET T.NombreAval1 		= UPPER(R.NombreCompleto),
		T.TelefonoAval1 	= R.Telefono,
		T.CalleNumeroAval1 	= UPPER(CONCAT(IFNULL(R.Calle,Cadena_Vacia),IF(LENGTH(IFNULL(R.Numero,Cadena_Vacia))>Entero_Cero,CONCAT(PrefijoNumero,R.Numero),SinNumero))),
		T.NombreColoniaAval1= CONCAT(Col.TipoAsenta,' ', Col.Asentamiento),
		T.CPAval1			= R.CP,
		T.NombreLocalidadAval1 = Loc.NombreLocalidad,
		T.NombreEstadoAval1	= Est.Nombre
		WHERE R.Consecutivo = ReferenciaUno;

	-- SE ACTUALIZAN LOS DATOS DE LOS AVALES (AVAL2)
	UPDATE TMPSALDOSGESTIONCOB T INNER JOIN TMPAVALESPORSOLICI R ON T.SolicitudCreditoID=R.SolicitudCreditoID
		INNER JOIN ESTADOSREPUB  	Est 	ON R.EstadoID = Est.EstadoID
		INNER JOIN MUNICIPIOSREPUB 	Mun		ON R.EstadoID = Mun.EstadoID		AND R.MunicipioID = Mun.MunicipioID
		INNER JOIN LOCALIDADREPUB 	Loc		ON R.EstadoID = Loc.EstadoID		AND R.MunicipioID = Loc.MunicipioID
																				AND R.LocalidadID = Loc.LocalidadID
		INNER JOIN COLONIASREPUB 	Col 	ON R.EstadoID = Col.EstadoID		AND R.MunicipioID = Col.MunicipioID
																				AND R.ColoniaID	= Col.ColoniaID
	SET T.NombreAval2 		= UPPER(R.NombreCompleto),
		T.TelefonoAval2 	= R.Telefono,
		T.CalleNumeroAval2 	= UPPER(CONCAT(IFNULL(R.Calle,Cadena_Vacia),IF(LENGTH(IFNULL(R.Numero,Cadena_Vacia))>Entero_Cero,CONCAT(PrefijoNumero,R.Numero),SinNumero))),
		T.NombreColoniaAval2= CONCAT(Col.TipoAsenta,' ', Col.Asentamiento),
		T.CPAval2			= R.CP,
		T.NombreLocalidadAval2 = Loc.NombreLocalidad,
		T.NombreEstadoAval2	= Est.Nombre
		WHERE R.Consecutivo = ReferenciaDos;

	TRUNCATE TMPAVALESPORSOLICI;

	SELECT
		MAX(Transaccion) AS Transaccion,			MAX(GrupoID) AS GrupoID,							MAX(NombreGrupo) AS NombreGrupo,		CreditoID,
        MAX(CicloGrupo) AS CicloGrupo,				MAX(ClienteID) AS ClienteID,						MAX(NombreCompleto) AS NombreCompleto,	MAX(MontoCredito) AS MontoCredito,
        MAX(FechaInicio) AS FechaInicio,			MAX(FechaVencimien) AS FechaVencimien,				MAX(FechaVencim) AS FechaVencim,		MAX(EstatusCredito) AS EstatusCredito,
        SUM(Capital)AS Capital,						SUM(Interes)AS Interes,								SUM(Moratorios)AS Moratorios,			SUM(Comisiones)AS Comisiones,
        MAX(Cargos) AS Cargos,						MAX(AmortizacionID) AS AmortizacionID,				SUM(IVATotal)AS IVATotal,				MAX(CobraIVAMora) AS CobraIVAMora,
		MAX(CobraIVAInteres) AS CobraIVAInteres,	MAX(SucursalID) AS SucursalID,						MAX(NombreSucurs) AS NombreSucurs,		MAX(ProductoCreditoID) AS ProductoCreditoID,
        MAX(Descripcion) AS Descripcion,			MAX(PromotorActual) AS PromotorActual,				MAX(NombrePromotor) AS NombrePromotor,	SUM(TotalCuota)AS TotalCuota,
        SUM(IFNULL(Pago,Decimal_Cero)) AS Pago,		MAX(IFNULL(FechaPago,Cadena_Vacia)) AS FechaPago,	SUM(MontoSeguroCuota) AS Seguro,				SUM(IVASeguroCuota) AS IVASeguro,
        MAX(IF(DiasAtraso<Entero_Cero,Entero_Cero,DiasAtraso)) AS DiasAtraso,		FUNCIONCONFINIQCRE(CreditoID) AS SaldoTotal,
        MAX(IFNULL(CalleNumero,Cadena_Vacia)) AS CalleNumero,						SUM(CapitalVencido)AS CapitalVencido,
        MAX(IFNULL(NombreColonia,Cadena_Vacia)) AS NombreColonia,					MAX(IFNULL(CP,Cadena_Vacia)) AS CP,
        MAX(IFNULL(NombreLocalidad,Cadena_Vacia)) AS NombreLocalidad,				MAX(IFNULL(NombreEstado,Cadena_Vacia)) AS NombreEstado,
        MAX(IFNULL(NombreReferencia1,Cadena_Vacia)) AS NombreReferencia1,			MAX(IFNULL(CalleNumeroRef1,Cadena_Vacia)) AS CalleNumeroRef1,
        MAX(IFNULL(NombreColoniaRef1,Cadena_Vacia)) AS NombreColoniaRef1,			MAX(IFNULL(CPRef1,Cadena_Vacia)) AS CPRef1,
        MAX(IFNULL(NombreLocalidadRef1,Cadena_Vacia)) AS NombreLocalidadRef1,		MAX(IFNULL(NombreEstadoRef1,Cadena_Vacia)) AS NombreEstadoRef1,
        MAX(IFNULL(NombreReferencia2,Cadena_Vacia)) AS NombreReferencia2,			MAX(IFNULL(CalleNumeroRef2,Cadena_Vacia)) AS CalleNumeroRef2,
        MAX(IFNULL(NombreColoniaRef2,Cadena_Vacia)) AS NombreColoniaRef2,			MAX(IFNULL(CPRef2,Cadena_Vacia)) AS CPRef2,
        MAX(IFNULL(NombreLocalidadRef2,Cadena_Vacia)) AS NombreLocalidadRef2,		MAX(IFNULL(NombreEstadoRef2,Cadena_Vacia)) AS NombreEstadoRef2,
        MAX(IFNULL(NombreReferencia3,Cadena_Vacia)) AS NombreReferencia3,			MAX(IFNULL(CalleNumeroRef3,Cadena_Vacia)) AS CalleNumeroRef3,
        MAX(IFNULL(NombreColoniaRef3,Cadena_Vacia)) AS NombreColoniaRef3,			MAX(IFNULL(CPRef3,Cadena_Vacia)) AS CPRef3,
        MAX(IFNULL(NombreLocalidadRef3,Cadena_Vacia)) AS NombreLocalidadRef3,		MAX(IFNULL(NombreEstadoRef3,Cadena_Vacia)) AS NombreEstadoRef3,
		MAX(IFNULL(NombreReferencia4,Cadena_Vacia)) AS NombreReferencia4,			MAX(IFNULL(CalleNumeroRef4,Cadena_Vacia)) AS CalleNumeroRef4,
        MAX(IFNULL(NombreColoniaRef4,Cadena_Vacia)) AS NombreColoniaRef4,			MAX(IFNULL(CPRef4,Cadena_Vacia)) AS CPRef4,
        MAX(IFNULL(NombreLocalidadRef4,Cadena_Vacia)) AS NombreLocalidadRef4,    	MAX(IFNULL(NombreEstadoRef4,Cadena_Vacia)) AS NombreEstadoRef4,
        MAX(IFNULL(NombreAval1,Cadena_Vacia)) AS NombreAval1,						MAX(IFNULL(CalleNumeroAval1,Cadena_Vacia)) AS CalleNumeroAval1,
        MAX(IFNULL(NombreColoniaAval1,Cadena_Vacia)) AS NombreColoniaAval1,			MAX(IFNULL(CPAval1,Cadena_Vacia)) AS CPAval1,
        MAX(IFNULL(NombreLocalidadAval1,Cadena_Vacia)) AS NombreLocalidadAval1,		MAX(IFNULL(NombreEstadoAval1,Cadena_Vacia)) AS NombreEstadoAval1,
        MAX(IFNULL(NombreAval2,Cadena_Vacia)) AS NombreAval2,						MAX(IFNULL(CalleNumeroAval2,Cadena_Vacia)) AS CalleNumeroAval2,
        MAX(IFNULL(NombreColoniaAval2,Cadena_Vacia)) AS NombreColoniaAval2,      	MAX(IFNULL(CPAval2,Cadena_Vacia)) AS CPAval2,
        MAX(IFNULL(NombreLocalidadAval2,Cadena_Vacia)) AS NombreLocalidadAval2,		MAX(IFNULL(NombreEstadoAval2,Cadena_Vacia)) AS NombreEstadoAval2,
        MAX(IF(Telefono IS NULL, Cadena_Vacia, CONCAT(FNMASCARA(Telefono,FormatoTelefono)))) AS Telefono,
        MAX(IF(Celular IS NULL, Cadena_Vacia, CONCAT(FNMASCARA(Celular,FormatoTelefono)))) 	AS Celular,
        MAX(IF(TelefonoRef1 IS NULL, Cadena_Vacia, CONCAT(FNMASCARA(TelefonoRef1,FormatoTelefono)))) AS TelefonoRef1,
        MAX(IF(TelefonoRef2 IS NULL, Cadena_Vacia, CONCAT(FNMASCARA(TelefonoRef2,FormatoTelefono)))) AS TelefonoRef2,
        MAX(IF(TelefonoRef3 IS NULL, Cadena_Vacia, CONCAT(FNMASCARA(TelefonoRef3,FormatoTelefono)))) AS TelefonoRef3,
        MAX(IF(TelefonoRef4 IS NULL, Cadena_Vacia, CONCAT(FNMASCARA(TelefonoRef4,FormatoTelefono)))) AS TelefonoRef4,
        MAX(IF(TelefonoAval1 IS NULL, Cadena_Vacia, CONCAT(FNMASCARA(TelefonoAval1,FormatoTelefono)))) AS TelefonoAval1,
		MAX(IF(TelefonoAval2 IS NULL, Cadena_Vacia, CONCAT(FNMASCARA(TelefonoAval2,FormatoTelefono)))) AS TelefonoAval2
		FROM TMPSALDOSGESTIONCOB
			WHERE IF(DiasAtraso<Entero_Cero,Entero_Cero,DiasAtraso) >=	Par_AtrasoInicial
				AND DiasAtraso <= Par_AtrasoFinal
                GROUP BY CreditoID
		ORDER BY SucursalID, ProductoCreditoID, PromotorActual, CreditoID, FechaVencim;
	TRUNCATE TMPSALDOSGESTIONCOB;

END TerminaStore$$
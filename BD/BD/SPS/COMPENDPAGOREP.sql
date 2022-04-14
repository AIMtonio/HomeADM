-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMPENDPAGOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMPENDPAGOREP`;
DELIMITER $$

CREATE PROCEDURE `COMPENDPAGOREP`(
    Par_ClienteID           int,
    Par_GrupoID             int,
    Par_Sucursal            int,
    Par_Moneda              int,
    Par_ProductoCre         int,
    Par_Promotor            int,
    Par_Genero              char(1),
    Par_Estado              int,
    Par_Municipio           int,

    Par_EmpresaID           int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint

	)
TerminaStore: BEGIN


DECLARE Var_Sentencia       varchar(6000);



DECLARE Cadena_Vacia		   char(1);
DECLARE Entero_Cero         int;

DECLARE EstatusVigente      char(1);
DECLARE EstatusAtras        char(1);
DECLARE EstatusInactivo     char(1);
DECLARE EstatusCancelado 	char(1);
DECLARE EstatusVencido      char(1);
DECLARE EstatusPagado       char(1);
DECLARE EstatusSuspendido	char(1);		-- Estatus Suspendido



DECLARE FechaSist           date;
DECLARE Var_PerFisica       char(1);
DECLARE SiCobraIVA		      char(1);

Set Cadena_Vacia            := '';
Set	Entero_Cero           := 0;
Set	EstatusVigente        := 'V';
Set	EstatusAtras          := 'A';
Set	EstatusInactivo       := 'I';
Set	EstatusCancelado      := 'C';
Set	EstatusVencido        := 'B';
Set	EstatusPagado         := 'P';
set EstatusSuspendido		:= 'S';		-- Estatus Suspendido




Set Var_PerFisica         := 'F';
Set	SiCobraIVA 		      := 'S';

set FechaSist := (Select FechaSistema from PARAMETROSSIS);

        set Var_Sentencia :=  'select  Amc.AmortizacionID,Amc.CreditoID,Amc.ClienteID,Cli.NombreCompleto,Pro.ProducCreditoID,Pro.Descripcion,Cre.FechaInicio as FechaDesembolso, Cre.FechaVencimien as FechaVtoFinal,';
        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' case when Amc.Estatus="I" then "INACTIVO" ');
        set Var_Sentencia := 	CONCAT(Var_Sentencia, '		when Amc.Estatus="A" then "ATRASADO" ');
        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Amc.Estatus="V" then "VIGENTE" ');
        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Amc.Estatus="B" then "VENCIDO" ');
        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		when Amc.Estatus="C" then "CANCELADO" ');
        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' 		end as EstatusCredito,');

		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' ( round(Amc.SaldoCapVigente,2) ');
		set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoCapAtrasa,2) ');
		set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoCapVencido,2) ');
		set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoCapVenNExi,2) ');

		set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoInteresOrd,2) ');
		set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoInteresAtr,2) ');
		set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoInteresVen,2) ');
		set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoInteresPro,2) ');
		set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoIntNoConta,2) ');

		set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoMoratorios + Amc.SaldoMoraVencido +
																Amc.SaldoMoraCarVen,2) ');
		set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoComFaltaPa,2) ');
        set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoComServGar,2) ');
		set Var_Sentencia :=  CONCAT(Var_Sentencia, '   + round(Amc.SaldoOtrasComis,2) )');

        set Var_Sentencia :=  CONCAT(Var_Sentencia, '  as SaldoTotal,');
        set Var_Sentencia :=    CONCAT(Var_Sentencia, 'Amc.FechaInicio as Inicio, Amc.FechaVencim as Vencimiento,');

        set Var_Sentencia :=  CONCAT(Var_Sentencia, '(Amc.SaldoComFaltaPa + Amc.SaldoComServGar + Amc.SaldoOtrasComis)as Comisiones,');


        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' round( (');

		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' case when  Cli.PagaIVA="',SiCobraIVA,'"   or Cli.PagaIVA is NULL then');
		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' round( (Amc.SaldoComFaltaPa + Amc.SaldoComServGar + Amc.SaldoOtrasComis)');
		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' * (select IVA from SUCURSALES  where  SucursalID = Cre.SucursalID),2)');
		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' else 0.00');
		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' end');

		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' ) , 2 ) as IVA,');



        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' round( (');

		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' case when  Cli.PagaIVA="',SiCobraIVA,'"   or Cli.PagaIVA is NULL then');
		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' round( (Amc.SaldoComFaltaPa + Amc.SaldoComServGar  + Amc.SaldoOtrasComis)');
		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' * (select IVA from SUCURSALES  where  SucursalID = Cre.SucursalID),2)');
		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' else 0.00');
		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' end');

		  set Var_Sentencia := 	CONCAT(Var_Sentencia, ' ) , 2 ) + round((Amc.SaldoComFaltaPa + Amc.SaldoComServGar + Amc.SaldoOtrasComis),2) as Total,');

        set Var_Sentencia := 	CONCAT(Var_Sentencia, 'Cre.SucursalID, Suc.NombreSucurs,Cli.PromotorActual,PROM.PromotorID,PROM.NombrePromotor,');

        set Var_Sentencia := 	CONCAT(Var_Sentencia, 'Gru.GrupoID,Gru.NombreGrupo,Cre.MonedaID,time(now()) as HoraEmision');

        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' from  CREDITOS  as Cre ');
        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' inner join AMORTICREDITO  as Amc on Cre.CreditoID = Amc.CreditoID');
        set Var_Sentencia := 	CONCAT(Var_Sentencia,' inner join PRODUCTOSCREDITO  as Pro on Cre.ProductoCreditoID = Pro.ProducCreditoID');
        set Var_Sentencia := 	CONCAT(Var_Sentencia,'  inner join CLIENTES  as Cli on Cre.ClienteID = Cli.ClienteID');
        set Var_Sentencia := 	CONCAT(Var_Sentencia,' inner join PROMOTORES as PROM on PROM.PromotorID=Cli.PromotorActual ');
        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' inner join SUCURSALES  as Suc on Suc.SucursalID = Cre.SucursalID');

        set Par_GrupoID := ifnull(Par_GrupoID,Entero_Cero);
               if(Par_GrupoID!=0)then
        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' inner join GRUPOSCREDITO Gru on Gru.GrupoID = Cre.GrupoID');
        set Var_Sentencia = CONCAT(Var_sentencia,' and Cre.GrupoID   =',convert(Par_GrupoID,char));
                end if;
               if(Par_GrupoID = 0)then
        set Var_Sentencia := 	CONCAT(Var_Sentencia, ' left join GRUPOSCREDITO Gru on Gru.GrupoID = Cre.GrupoID');
                end if;

        set Var_Sentencia :=  CONCAT(Var_Sentencia," where	Amc.Estatus	in ('",EstatusVigente, "','", EstatusAtras,"','", EstatusVencido,"')");
        set Var_Sentencia :=  CONCAT(Var_Sentencia," and	Cre.Estatus	in ('",EstatusVigente, "','", EstatusVencido, "','", EstatusSuspendido, "')");
        set Var_Sentencia :=  CONCAT(Var_Sentencia,' and Amc.FechaExigible <= "',FechaSist,'" and (Amc.SaldoComFaltaPa > 0 or Amc.SaldoComServGar > 0 or Amc.SaldoOtrasComis > 0)');


        set Par_ClienteID := ifnull(Par_ClienteID,Entero_Cero);
                if(Par_ClienteID!=0)then
                    set Var_Sentencia := CONCAT(Var_sentencia,' and Cli.ClienteID="',Par_ClienteID,'"');
               end if;

        set Par_ProductoCre := ifnull(Par_ProductoCre,Entero_Cero);
                if(Par_ProductoCre!=0)then
                    set Var_Sentencia :=  CONCAT(Var_sentencia,' and Pro.ProducCreditoID =',convert(Par_ProductoCre,char));
                end if;

        set Par_Genero := ifnull(Par_Genero,Cadena_Vacia);
                if(Par_Genero!=Cadena_Vacia)then
                    set Var_Sentencia := CONCAT(Var_sentencia,' and Cli.Sexo="',Par_Genero,'"');

               end if;

        set Par_Estado := ifnull(Par_Estado,Entero_Cero);
                if(Par_Estado!=0)then
                    set Var_Sentencia := CONCAT(Var_sentencia,' and (select Dir.EstadoID from DIRECCLIENTE Dir where Dir.Oficial= "S" and Cli.ClienteID=Dir.ClienteID)=',convert(Par_Estado,char));
                end if;

        set Par_Municipio := ifnull(Par_Municipio,Entero_Cero);
                if(Par_Municipio!=0)then
                    set Var_Sentencia := CONCAT(Var_sentencia,' and (select Dir.MunicipioID from DIRECCLIENTE Dir where Dir.Oficial="S" and Cli.ClienteID=Dir.ClienteID)=',convert(Par_Municipio,char));
                end if;

        set Par_Promotor := ifnull(Par_Promotor,Entero_Cero);
                if(Par_Promotor!=0)then
                    set Var_Sentencia := CONCAT(Var_sentencia,' and PROM.PromotorID=',convert(Par_Promotor,char));
                end if;

        set Par_Moneda := ifnull(Par_Moneda,Entero_Cero);
                if(Par_Moneda!=0)then
                    set Var_Sentencia = CONCAT(Var_sentencia,' and Cre.MonedaID=',convert(Par_Moneda,char));
                end if;

        set Par_Sucursal := ifnull(Par_Sucursal,Entero_Cero);
                if(Par_Sucursal!=0)then
                    set Var_Sentencia = CONCAT(Var_sentencia,' and Cre.SucursalID=',convert(Par_Sucursal,char));
                end if;

        set Var_Sentencia :=  CONCAT(Var_Sentencia,' order by  Cre.SucursalID, Cli.PromotorActual,Cre.ProductoCreditoID,Cre.GrupoID;');


	SET @Sentencia	= (Var_Sentencia);

    PREPARE COMPENDPAGOREP FROM @Sentencia;
    EXECUTE COMPENDPAGOREP;
    DEALLOCATE PREPARE COMPENDPAGOREP;

END TerminaStore$$
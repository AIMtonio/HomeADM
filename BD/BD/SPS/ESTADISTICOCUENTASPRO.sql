-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTADISTICOCUENTASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTADISTICOCUENTASPRO`;DELIMITER $$

CREATE PROCEDURE `ESTADISTICOCUENTASPRO`(
    Par_NumCon                tinyint unsigned,
    Par_FechaCorte  				DateTime,
    Par_TipoReporte			char(1),
    Par_MostrarGL			char(1),
    Par_MinimoSaldo			decimal(12,2),
    Par_CtasEstRegis		char(1),
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
    )
TerminaStore:BEGIN


DECLARE Var_FechaSistema date;
Declare ReporteDetallado char(1);
Declare ReporteSinGarLiq char(1);
Declare ReporteGLOBAL	 char(1);
Declare Tipo_Ahorro		 varchar(20);
Declare Tipo_Inversion	 varchar(20);
Declare Var_FechaInicio	 date;
Declare Var_CtasEstRegis char(1);


set ReporteDetallado:= 'D'; -- Detalle de slados por Cuenta Inversion y Creditos.
set ReporteGLOBAL:= 'G'; -- Información a grupado por producto.end
set ReporteSinGarLiq ='S'; -- Informacion glogal sin Garantia Liquida.

set Tipo_Ahorro:='CUENTAS';
set Tipo_Inversion:='INVERSION';

set Var_CtasEstRegis := 'S'; -- Incluir cuentas que no fueron Autorizasas

drop table if exists SaldoCuentasGL;
 create /*temporary*/ table  SaldoCuentasGL(
											Cuenta bigint,
											Importe decimal(18,2),
                                            Primary Key(Cuenta));

drop table if exists tmp_SaldosBloqueo;
    create /*temporary*/ table tmp_SaldosBloqueo (Cuenta     bigint,
                                              Saldo        decimal(18,2),
                                              Referencia bigint(20),
                                              SaldoAho decimal(18,2),
                                              Primary Key(Cuenta));
drop table if exists tmp_SaldosCaptacion;
    create /*temporary*/ table tmp_SaldosCaptacion (No_Cuentas     bigint(12),
                                              Descripcion varchar(100),
                                              Importe        decimal(18,2),
                                              SaldoGarantias decimal(18,2),
											  Sucursal		Varchar(100),
											  SucursalID    int(11),
                                              Producto		varchar(50),
                                              TipoProducto  varchar(20),
                                              NombreCliente varchar(500),
                                              Estatus		varchar(15)
                                              );

drop table if exists Temp_SaldosCredito;
    create /*temporary*/ table Temp_SaldosCredito(CreditoID bigint (12),
										   NombreCompleto	varchar(200),
											   Descripcion		varchar(100),
                                               MontoCredito		decimal(12,2),
											   SaldoCapital		decimal(12,2),
											   SaldoInteres		decimal(12,2),
                                               NombreSucurs		varchar(200),
                                               primary key (CreditoID)
												);





 set Var_FechaSistema := (select FechaSistema from PARAMETROSSIS);
 set Var_FechaInicio  :=(SELECT Par_FechaCorte - INTERVAL DAYOFMONTH(Par_FechaCorte) - 1 DAY);

 -- === Saldo de Garantía Liqida Fecha Corte ====

    insert into tmp_SaldosBloqueo
      select CuentaAhoID,SUM(CASE WHEN NatMovimiento = 'B'
                    THEN IFNULL(MontoBloq,0.00)
                 ELSE IFNULL(MontoBloq,0.00)  * -1
            END) AS Saldo,
    Referencia , 0.0
    from BLOQUEOS
    where   date(FechaMov)  <= Par_FechaCorte AND-- Var_FechaFinal and
     TiposBloqID = 8
    group by CuentaAhoID;

create index tmp_idx on tmp_SaldosBloqueo(Referencia);
create index tmp_idx2 on tmp_SaldosBloqueo(Cuenta);
-- select * from tmp_SaldosBloqueo;


-- select * from tmp_SaldosBloqueo;

IF (substring(Var_FechaSistema,1,7) =   substring(Par_FechaCorte,1,7)) THEN


      insert into SaldoCuentasGL
		select C.CuentaAhoID as Cuenta,
        sum(case when CM.NatMovimiento = "A" then ifnull(CM.CantidadMov,0.00)
					else ifnull(CM.CantidadMov,0.00) * -1  end) + ifnull(C.SaldoIniMes,0.00) as Importe
			from  CUENTASAHO C
							inner join tmp_SaldosBloqueo tm on C.CuentaAhoID = tm.Cuenta
							left join CUENTASAHOMOV CM on C.CuentaAhoID = CM.CuentaAhoID AND
															CM.Fecha >= Var_FechaInicio
															and CM.Fecha <= Par_FechaCorte
		where C.ClienteID!=1   and C.Estatus in ('A','B')
			and tm.Saldo<>0.0 group by C.CuentaAhoID ;

	insert into tmp_SaldosCaptacion
		select C.CuentaAhoID as Cuenta,'AHORRO A LA VISTA',
				sum(case when CM.NatMovimiento = "A" then ifnull(CM.CantidadMov,0.00)
					else ifnull(CM.CantidadMov,0.00) * -1  end) + ifnull(C.SaldoIniMes,0.00) as Importe,
				0.0 as Saldo_Garantias,				Suc.NombreSucurs,Suc.SucursalID,T.Descripcion,Tipo_Ahorro,
				Cli.NombreCompleto,
					case C.Estatus when 'A' then 'ACTIVO'
									when 'B' then 'BLOQUEADO' END AS Estatus
			from  CUENTASAHO C
									left join CUENTASAHOMOV CM on C.CuentaAhoID = CM.CuentaAhoID AND
																	CM.Fecha >= Var_FechaInicio
																			and CM.Fecha <= Par_FechaCorte
									inner join TIPOSCUENTAS T on T.TipoCuentaID=C.TipoCuentaID
									inner join SUCURSALES Suc on C.SucursalID = Suc.SucursalID
                                    inner join CLIENTES Cli on C.ClienteID = Cli.ClienteID
		where C.Saldo> Par_MinimoSaldo and C.ClienteID!=1    and C.Estatus in ('A','B')
				and FechaApertura <=	Par_FechaCorte		-- AND C.FechaCan >Par_FechaCorte
			and C.CuentaAhoid not in(Select distinct Cuenta from tmp_SaldosBloqueo where Saldo<>0.0 )
            group by  C.CuentaAhoID;


-- Inversiones que no las hayan vencido anticiapadamente

     insert into tmp_SaldosCaptacion
		Select Inv.InversionID,"INVERSION A PLAZO",Inv.Monto as Importe, 0.0 as Saldo_Garantias,
			Suc.NombreSucurs, Suc.SucursalID, Cat.Descripcion,Tipo_Inversion, Cl.NombreCompleto,
            	case Inv.Estatus when 'N' then 'VIGENTE' end as Estatus
	from INVERSIONES  Inv
				inner join CATINVERSION Cat on Inv.TipoInversionID = Cat.TipoInversionID
                inner join CLIENTES Cl on Cl.ClienteID = Inv.ClienteID
				inner join SUCURSALES Suc on Cl.SucursalOrigen = Suc.SucursalID
    where /*Inv.Estatus='N' and  */ Inv.FechaVencimiento >Par_FechaCorte  and Inv.FechaInicio <=Par_FechaCorte
			 and Inv.Estatus NOT IN ('I','C')
      and  Inv.FechaVenAnt ='1900-01-01' ;-- FechaCorte = Par_FechaCorte;

-- Inversiones que se se vencieron anticipadamente
       insert into tmp_SaldosCaptacion
		Select Inv.InversionID,"INVERSION A PLAZO",Inv.Monto as Importe, 0.0 as Saldo_Garantias,
			Suc.NombreSucurs, Suc.SucursalID, Cat.Descripcion,Tipo_Inversion, Cl.NombreCompleto,
            	case Inv.Estatus when 'N' then 'VIGENTE' end as Estatus
	from INVERSIONES  Inv
				inner join CATINVERSION Cat on Inv.TipoInversionID = Cat.TipoInversionID
                inner join CLIENTES Cl on Cl.ClienteID = Inv.ClienteID
				inner join SUCURSALES Suc on Cl.SucursalOrigen = Suc.SucursalID
    where /*Inv.Estatus='N' and*/ Inv.FechaVencimiento >Par_FechaCorte  and Inv.FechaInicio <=Par_FechaCorte
		and Inv.Estatus NOT IN ('I')      and  Inv.FechaVenAnt >Par_FechaCorte;


 else
 -- ====== CAPTACION ========

         insert into SaldoCuentasGL
		select C.CuentaAhoID as Cuenta,
        sum(case when CM.NatMovimiento = "A" then ifnull(CM.CantidadMov,0.00)
					else ifnull(CM.CantidadMov,0.00) * -1  end) + ifnull(C.SaldoIniMes,0.00) as Importe
			from  `HIS-CUENTASAHO`  C
							inner join tmp_SaldosBloqueo tm on C.CuentaAhoID = tm.Cuenta
							left join `HIS-CUENAHOMOV` CM on C.CuentaAhoID = CM.CuentaAhoID AND
															CM.Fecha >= Var_FechaInicio
															and CM.Fecha <= Par_FechaCorte
		where  C.ClienteID!=1   and C.Estatus in ('A','B') 	and substring(C.Fecha,1,7) = substring(Par_FechaCorte,1,7)
			and tm.Saldo<>0.0 group by C.CuentaAhoID ;

	insert into tmp_SaldosCaptacion
		select C.CuentaAhoID,'AHORRO A LA VISTA',
				sum(case when CM.NatMovimiento = "A" then ifnull(CM.CantidadMov,0.00)
					else ifnull(CM.CantidadMov,0.00) * -1  end) + ifnull(C.SaldoIniMes,0.00) as Importe,
                    0.0 as Saldo_Garantias,
				Suc.NombreSucurs, Suc.SucursalID,T.Descripcion, Tipo_Ahorro, Cli.NombreCompleto,
				case C.Estatus when 'A' then 'ACTIVO'
									when 'B' then 'BLOQUEADO' END AS Estatus

			from `HIS-CUENTASAHO` C   inner join TIPOSCUENTAS T on T.TipoCuentaID=C.TipoCuentaID
				left join `HIS-CUENAHOMOV`  CM on C.CuentaAhoID = CM.CuentaAhoID
												AND CM.Fecha >= Var_FechaInicio and CM.Fecha <= Par_FechaCorte
				inner join SUCURSALES Suc on C.SucursalID = Suc.SucursalID
				inner join CLIENTES Cli on C.ClienteID = Cli.ClienteID

				where C.Saldo> Par_MinimoSaldo and C.ClienteID!=1  -- and  FechaApertura <=	Par_FechaCorte
					and  C.Estatus in ('A','B') and substring(C.Fecha,1,7) = substring(Par_FechaCorte,1,7)
				 	and C.CuentaAhoID not in(Select distinct Cuenta from tmp_SaldosBloqueo where Saldo<>0.0)
                                group by  C.CuentaAhoID;

-- Inversiones que no las hayan vencido anticiapadamente

     insert into tmp_SaldosCaptacion
		Select Inv.InversionID,"INVERSION A PLAZO",Inv.Monto as Importe, 0.0 as Saldo_Garantias,
			Suc.NombreSucurs, Suc.SucursalID, Cat.Descripcion,Tipo_Inversion, Cl.NombreCompleto,
			case Inv.Estatus when 'N' then 'VIGENTE' end as Estatus

	from INVERSIONES  Inv
				inner join CATINVERSION Cat on Inv.TipoInversionID = Cat.TipoInversionID
                inner join CLIENTES Cl on Cl.ClienteID = Inv.ClienteID
				inner join SUCURSALES Suc on Cl.SucursalOrigen = Suc.SucursalID
    where /*Inv.Estatus='N' and*/   Inv.FechaVencimiento >Par_FechaCorte  and Inv.FechaInicio <=Par_FechaCorte
			and Inv.Estatus NOT IN ('I','C')
      and  Inv.FechaVenAnt ='1900-01-01' ;-- FechaCorte = Par_FechaCorte;

-- Inversiones que se se vencieron anticipadamente
       insert into tmp_SaldosCaptacion
		Select Inv.InversionID,"INVERSION A PLAZO",Inv.Monto as Importe, 0.0 as Saldo_Garantias,
			Suc.NombreSucurs, Suc.SucursalID, Cat.Descripcion,Tipo_Inversion, Cl.NombreCompleto,
                        	case Inv.Estatus when 'N' then 'VIGENTE' end as Estatus

	from INVERSIONES  Inv
				inner join CATINVERSION Cat on Inv.TipoInversionID = Cat.TipoInversionID
                inner join CLIENTES Cl on Cl.ClienteID = Inv.ClienteID
				inner join SUCURSALES Suc on Cl.SucursalOrigen = Suc.SucursalID
    where /*Inv.Estatus='N' and*/  Inv.FechaVencimiento >Par_FechaCorte  and Inv.FechaInicio <=Par_FechaCorte
		and Inv.Estatus NOT IN ('I')      and  Inv.FechaVenAnt >Par_FechaCorte;



 END IF;

 -- =======================================================================
 -- Si requieren que se muetra los saldos de Garantía liquida en el reporte
-- ========================================================================
 if(Par_MostrarGL = ReporteSinGarLiq) then

insert into tmp_SaldosCaptacion
select t.Cuenta as No_Cuentas, P.Descripcion,SG.Importe  as importe ,t.Saldo as Saldo_Garantias,
		Suc.NombreSucurs, Suc.SucursalID, P.Descripcion, Tipo_Ahorro, Cli.NombreCompleto,
        case Cu.Estatus when 'A' then 'ACTIVO'
									when 'B' then 'BLOQUEADO' END AS Estatus
from tmp_SaldosBloqueo t
	left join SaldoCuentasGL SG on	t.Cuenta = SG.Cuenta
	inner join CREDITOS C on  t.Referencia = C.CreditoID
    inner join  PRODUCTOSCREDITO P on C.ProductoCreditoID = P.ProducCreditoID
    inner join CUENTASAHO	 Cu on t.Cuenta = Cu.CuentaAhoID
    inner join CLIENTES Cli on Cu.ClienteID = Cli.ClienteID
    inner join SUCURSALES Suc on Cu.SucursalID = Suc.SucursalID
    where t.Saldo <> 0.00;

    end if;

-- ========================================================================
 -- Si requieren que se muetra las Cuentas Registrada que no se han Autorizaron
-- ========================================================================

if(Par_CtasEstRegis=Var_CtasEstRegis) then
-- == Creditos que Esta con estatus Registrados Actualmente
insert into tmp_SaldosCaptacion
		select C.CuentaAhoID as Cuenta,'AHORRO A LA VISTA', 0.00 as Importe,
				0.0 as Saldo_Garantias,				Suc.NombreSucurs,Suc.SucursalID,T.Descripcion,Tipo_Ahorro,
				Cli.NombreCompleto,'REGISTRADO'  AS Estatus
			from  CUENTASAHO C

									inner join TIPOSCUENTAS T on T.TipoCuentaID=C.TipoCuentaID
									inner join SUCURSALES Suc on C.SucursalID = Suc.SucursalID
                                    inner join CLIENTES Cli on C.ClienteID = Cli.ClienteID
WHERE FechaReg <=Par_FechaCorte and  ifnull(FechaApertura,'')=''and ifnull(C.FechaCan,'')='';

-- == Creditos que Estuvieron con estatus registrados y que posteriormente lo Activaron
insert into tmp_SaldosCaptacion
		select C.CuentaAhoID as Cuenta,'AHORRO A LA VISTA', 0.00 as Importe,
				0.0 as Saldo_Garantias,				Suc.NombreSucurs,Suc.SucursalID,T.Descripcion,Tipo_Ahorro,
				Cli.NombreCompleto,'REGISTRADO'  AS Estatus
			from  CUENTASAHO C

									inner join TIPOSCUENTAS T on T.TipoCuentaID=C.TipoCuentaID
									inner join SUCURSALES Suc on C.SucursalID = Suc.SucursalID
                                    inner join CLIENTES Cli on C.ClienteID = Cli.ClienteID
WHERE   C.FechaReg <> C.FechaApertura  and C.FechaReg <= Par_FechaCorte
and C.FechaApertura > Par_FechaCorte and (ifnull(C.FechaCan,'')='' or C.FechaCan > Par_FechaCorte);

-- == Creditos que Estuvieron con estatus registrados y los cancelaron posteriormente
insert into tmp_SaldosCaptacion
		select C.CuentaAhoID as Cuenta,'AHORRO A LA VISTA', 0.00 as Importe,
				0.0 as Saldo_Garantias,				Suc.NombreSucurs,Suc.SucursalID,T.Descripcion,Tipo_Ahorro,
				Cli.NombreCompleto,'REGISTRADO'  AS Estatus
			from  CUENTASAHO C

									inner join TIPOSCUENTAS T on T.TipoCuentaID=C.TipoCuentaID
									inner join SUCURSALES Suc on C.SucursalID = Suc.SucursalID
                                    inner join CLIENTES Cli on C.ClienteID = Cli.ClienteID
WHERE   C.FechaReg <= Par_FechaCorte and ifnull(C.FechaApertura,'')='' and C.FechaCan > Par_FechaCorte;

end if;


IF (Var_FechaSistema =   Par_FechaCorte) THEN

-- ====== CREDITOS ========
insert into Temp_SaldosCredito
  select C.CreditoID,Cli.NombreCompleto,P.Descripcion, C.MontoCredito as Monto_Credito,
sum(AM.SaldoCapVigente+AM.SaldoCapAtrasa+AM.SaldoCapVencido+AM.SaldoCapVenNExi) as 'Saldo Capital',
sum(AM.SaldoInteresPro+AM.SaldoInteresAtr+AM.SaldoInteresVen+AM.SaldoIntNoConta) as 'Saldo Intereses',
	Suc.NombreSucurs
 from  CREDITOS C
		INNER JOIN AMORTICREDITO AM	ON C.CreditoID = AM.CreditoID
        INNER JOIN CLIENTES Cli on C.ClienteID = Cli.ClienteID
        inner join PRODUCTOSCREDITO P on C.ProductoCreditoID = P.ProducCreditoID
		inner join SUCURSALES Suc on C.SucursalID =Suc.SucursalID
	where P.ProducCreditoID=C.ProductoCreditoID  and AM.Estatus <> 'P'
		 AND C.Estatus in ('V','B','K')
    group by C.CreditoID order by C.SucursalID asc;



    else

insert into Temp_SaldosCredito
  select S.CreditoID,Cli.NombreCompleto,P.Descripcion, S.MontoCredito as Monto_Credito,
(SalCapVigente+SalCapAtrasado+SalCapVencido+SalCapVenNoExi) as 'Saldo Capital',
(SalIntOrdinario+SalIntAtrasado+SalIntVencido+SalIntProvision+SalIntNoConta) as 'Saldo Intereses',
	Suc.NombreSucurs
 from SALDOSCREDITOS S
		INNER JOIN CREDITOS C ON S.CreditoID = C.CreditoID
        INNER JOIN CLIENTES Cli on C.ClienteID = Cli.ClienteID
        inner join PRODUCTOSCREDITO P on C.ProductoCreditoID = P.ProducCreditoID
		inner join SUCURSALES Suc on C.SucursalID =Suc.SucursalID
	where P.ProducCreditoID=C.ProductoCreditoID and S.FechaCorte=Par_FechaCorte
    group by S.CreditoID order by C.SucursalID asc;

end if;

 if (ReporteDetallado = Par_TipoReporte) then

	if(Par_MostrarGL = ReporteSinGarLiq) then

		select No_Cuentas,NombreCliente,Descripcion,Estatus,
			Producto,TipoProducto,	Importe,	SaldoGarantias,	Sucursal
		from tmp_SaldosCaptacion order by TipoProducto,SucursalID asc;

		else
			select No_Cuentas,NombreCliente,Descripcion,Estatus,
				Producto,TipoProducto,	Importe,	Sucursal
				from tmp_SaldosCaptacion order by TipoProducto,SucursalID asc;

    end if;

    SELECT CreditoID, NombreCompleto, Descripcion, MontoCredito,SaldoCapital,SaldoInteres,NombreSucurs
    		FROM Temp_SaldosCredito;

  end if;


 if (ReporteGLOBAL = Par_TipoReporte) then

	if(Par_MostrarGL = ReporteSinGarLiq) then

        select count(*) as Cantidad, Descripcion,TipoProducto, sum(Importe)as Saldo ,
				sum(SaldoGarantias) as GarantiaLiquida
			from tmp_SaldosCaptacion
			group by Descripcion order by TipoProducto asc;

        else
			select count(*) as Cantidad, Descripcion,TipoProducto, sum(Importe)as Saldo
				from tmp_SaldosCaptacion
			group by Descripcion order by TipoProducto asc;

     end if;

            select count(CreditoID) AS Cantidad ,Descripcion, SUM(MontoCredito) as Monto_Credito,
					SUM(SaldoCapital) as 'Saldo Capital',
					SUM(SaldoInteres) as 'Saldo Intereses'
			from Temp_SaldosCredito
				group by Descripcion;

 end if;



END  TerminaStore$$
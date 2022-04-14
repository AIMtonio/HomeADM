-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSBANCOSCCREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSBANCOSCCREP`;DELIMITER $$

CREATE PROCEDURE `SALDOSBANCOSCCREP`(
	Par_Fecha		    	date,
	Par_InstitucionID  		int(11),
	Par_CuentaBancaria 		varchar(20),
    Par_tipoRep             int(11),

	Par_EmpresaID		    int,
	Aud_Usuario				int,
	Aud_FechaActual		    DateTime,
	Aud_DireccionIP		    varchar(15),
	Aud_ProgramaID		    varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_CuentaCompleta  char(25); 		-- Cuenta completa
DECLARE Var_EjercicioID     int(11);  		-- Ejercicio cntable
DECLARE Var_PeriodoID		int(11);  		-- Periodo Contable
DECLARE Var_Estatus			char(1);  		-- Estatus del periodo
DECLARE Var_FechaFin        date;     		-- Fecha Fin del periodo contable
DECLARE Var_SaldoFinal      decimal(18,2);  --  Saldo final del periodo
DECLARE Var_TotalCargos		decimal(18,2);  -- Total de cargos
DECLARE Var_TotalAbonos		decimal(18,2);  -- Total Abonos
DECLARE Var_TotSaldoFinal   decimal(18,2);  -- Total saldo
DECLARE Var_CentroCostos    char(1);        -- Centro de Costos
DECLARE Var_Naturaleza      char(1);   		-- Naturaleza de la cuenta
DECLARE Var_SaldoInicial    decimal(18,2); 	-- Saldo inicial del periodo contable
DECLARE Var_FechaInicio     date;          	-- Fecha inicio

DECLARE Var_EjercicioIDCerrado  int(11);  		-- Ejercicio cntable
DECLARE Var_PeriodoIDCerrado	int(11);  		-- Periodo Contable
DECLARE Var_EstatusCerrado		char(1);  		-- Estatus del periodo
DECLARE Var_FechaInicioCerrado  date;          	-- Fecha inicio
DECLARE Var_FechaFinCerrado     date;     		-- Fecha Fin del periodo contable
DECLARE Var_CentroCosto         int(11);

-- Declaracion de Constantes
DECLARE Cadena_Vacia		char(1);
DECLARE Fecha_Vacia			date;
DECLARE Entero_Cero			int;
DECLARE Rep_Sumarizado      int;
DECLARE Rep_Detallado       int;
DECLARE PeriodoCerrado      char(1);
DECLARE PeriodoVigente      char(1);
DECLARE NatDeudora			char(1);
DECLARE NatAcreedora    	char(1);



-- Asignacion de Constantes
Set Cadena_Vacia	:= '';  			-- cadena vacia
Set Fecha_Vacia		:= '1900-01-01';	-- fecha vacia
Set Entero_Cero		:= 0;				-- Entero cero
Set Rep_Sumarizado  := 1;               -- Reporte Sumarizado
Set Rep_Detallado   := 2;				-- Reporte Detallado
Set PeriodoCerrado  := 'C';             -- periodo contable cerrado
Set PeriodoVigente  := 'N';             -- periodo contable vigente
Set NatDeudora 		:= 'D'; 			-- naturaleza de la cuenta deudora
Set NatAcreedora 	:= 'A';				-- naturaleza de la cunta acredora

-- se crea tabla temporal para almacenar los saldos del reporte sumarizado
drop table if exists TMPHISSALDOS;
create temporary table TMPHISSALDOS(
	Fecha					date,
	CuentaBancaria			char(20),
	CuentaContable			char(25),
	CentroCostoID	        int(2),
	SaldoInicial			decimal(18,2),
	Cargos                  decimal(18,2),
	Abonos                  decimal(18,2),
    SaldoFinal     			decimal(18,2)

)engine = InnoDB default charset=Latin1;


-- table temporal para almacenar los datos del reporte sumarizado
drop table if exists TMPHISCARGOSABONOS;
create temporary table TMPHISCARGOSABONOS(
	CuentaContable			char(25),
	CentroCostoID	        int(2),
	SaldoInicial			decimal(18,2),
    SaldoFinal     			decimal(18,2)

)engine = InnoDB default charset=Latin1;


-- tabla temporal para datos del reporte detallado
drop table if exists TMPDETHISSALDOS;
create temporary table TMPDETHISSALDOS(
	Fecha					date,
	CuentaBancaria			char(20),
	CuentaContable			char(25),
	CentroCostoID	        int(2),
	Cargos                  decimal(18,2),
	Abonos                  decimal(18,2)

)engine = InnoDB default charset=Latin1;


-- Se obtiene la cuenta completa y la naturaleza de la cuenta
select ctas.CuentaCompleta, ctas.Naturaleza, tes.CentroCostoID
	into Var_CuentaCompleta, Var_Naturaleza, Var_CentroCosto
		from CUENTASCONTABLES  ctas
	 	inner join CUENTASAHOTESO  tes
		on ctas.CuentaCompleta  = tes.CuentaCompletaID
		where   tes.NumCtaInstit  = Par_CuentaBancaria
		and    tes.InstitucionID  =  Par_InstitucionID;

-- se consulta a periodo contable para verificar si esta vigente
select EjercicioID, PeriodoID, Estatus, Inicio, Fin
	into Var_EjercicioID, Var_PeriodoID, Var_Estatus,Var_FechaInicio, Var_FechaFin
	from PERIODOCONTABLE
	where Inicio<= Par_Fecha and Fin>= Par_Fecha ;

if (Par_tipoRep = Rep_Sumarizado ) then  -- SI EL TIPO DE REPORTE ES SUMARIZADO

	if(Var_Estatus = PeriodoCerrado) then  -- SI EL PERIODO CONTABLE ESTA CERRADO

	insert into TMPHISCARGOSABONOS
		select  Var_CuentaCompleta, CentroCosto, SaldoInicial, SaldoInicial
				 from  SALDOSCONTABLES
				where  PeriodoID =  Var_PeriodoID
				  and  EjercicioID = Var_EjercicioID
				  and  CuentaCompleta  = Var_CuentaCompleta;

	insert into TMPHISSALDOS
				 select  MIN(Fecha), Par_CuentaBancaria,Var_CuentaCompleta,CentroCostoID, Entero_Cero, sum(pol.Cargos), sum(pol.Abonos), Entero_Cero
				   from  `HIS-DETALLEPOL` pol
			      where  pol.Fecha>=Var_FechaInicio
				    and  pol.Fecha<=Par_Fecha and pol.CuentaCompleta = Var_CuentaCompleta
			   group by  CentroCostoID;


	end if; --  -- FIN PERIODO CONTABLE CERRADO

if(Var_Estatus = PeriodoVigente) then  -- SI EL PERIODO CONTABLE ESTA VIGENTE

      -- selecciona ultimo periodo contable cerrado
		select max(EjercicioID), max(PeriodoID), Estatus, max(Inicio), max(Fin)
			 into Var_EjercicioIDCerrado, Var_PeriodoIDCerrado, Var_EstatusCerrado,Var_FechaInicioCerrado, Var_FechaFinCerrado
			 from PERIODOCONTABLE
			where Estatus = PeriodoCerrado;

	INSERT INTO TMPHISCARGOSABONOS
			select  Var_CuentaCompleta, CentroCosto, SaldoInicial, SaldoInicial
					 from  SALDOSCONTABLES
					where  PeriodoID =  Var_PeriodoIDCerrado
					  and  EjercicioID = Var_EjercicioIDCerrado
					  and  CuentaCompleta  = Var_CuentaCompleta;

	if not exists(SELECT CuentaCompleta FROM SALDOSCONTABLES WHERE CuentaCompleta = Var_CuentaCompleta)then
		INSERT INTO TMPHISCARGOSABONOS (CuentaContable,CentroCostoID,SaldoInicial, SaldoFinal )
		VALUES (Var_CuentaCompleta,Var_CentroCosto, Entero_Cero, Entero_Cero);
	end if;

	INSERT INTO TMPHISSALDOS
					 select  MIN(Fecha),Par_CuentaBancaria,Var_CuentaCompleta,CentroCostoID, Entero_Cero, sum(pol.Cargos), sum(pol.Abonos), Entero_Cero
					   from  DETALLEPOLIZA pol
					  where  pol.Fecha>Var_FechaFinCerrado
						and  pol.Fecha<=Par_Fecha and pol.CuentaCompleta = Var_CuentaCompleta
				   group by  CentroCostoID;


	end if;	 -- FIN PERIODO CONTABLE VIGENTE


	update TMPHISSALDOS as tms
		inner join  TMPHISCARGOSABONOS as tca
				on 	tms.CuentaContable = tca.CuentaContable
			   set  tms.SaldoInicial = tca.SaldoInicial
			 where 	tms.CentroCostoID = tca.CentroCostoID;


	-- SI LA CUENTA BANCARIA ES DE NATURALEZA DEUDORA

	  if(Var_Naturaleza = NatDeudora) then
			update TMPHISSALDOS saldos
		inner join TMPHISCARGOSABONOS movs
			   set saldos.SaldoFinal=(movs.SaldoFinal+saldos.Cargos-saldos.Abonos)
			   where saldos.CentroCostoID = movs.CentroCostoID;
		end if;

	-- SI LA CUENTA BANCARIA ES DE NATURALEZA ACREEDORA
	  if(Var_Naturaleza = NatAcreedora) then
			update TMPHISSALDOS saldos
		inner join TMPHISCARGOSABONOS movs
			   set saldos.SaldoFinal=(movs.SaldoFinal+saldos.Abonos-saldos.Cargos)
			   where saldos.CentroCostoID = movs.CentroCostoID;
		end if;


	SELECT Fecha,	CuentaBancaria,	 CuentaContable,	CentroCostoID,	SaldoInicial,	Cargos,
		   Abonos,	SaldoFinal
	 FROM TMPHISSALDOS;

end if;  --  FIN DEL TIPO DE REPORTE SUMARIZADO



if (Par_tipoRep = Rep_Detallado ) then  -- SI EL TIPO DE REPORTE ES DETALLADO

  if(Var_Estatus = PeriodoCerrado) then  -- SI EL PERIODO CONTABLE ESTA CERRADO

	INSERT INTO TMPDETHISSALDOS
		  select   Fecha, Par_CuentaBancaria,Var_CuentaCompleta, pol.CentroCostoID, pol.Cargos, pol.Abonos
			from  `HIS-DETALLEPOL` pol
		   where  pol.Fecha>=Var_FechaInicio
			 and  pol.Fecha<=Par_Fecha and pol.CuentaCompleta = Var_CuentaCompleta
		order by  pol.CentroCostoID;

	end if;   -- FIN PERIODO CONTABLE CERRADO


	if(Var_Estatus = PeriodoVigente) then  -- SI EL PERIODO CONTABLE ESTA VIGENTE

	select max(EjercicioID), max(PeriodoID), Estatus, max(Inicio), max(Fin)
			 into Var_EjercicioIDCerrado, Var_PeriodoIDCerrado, Var_EstatusCerrado,Var_FechaInicioCerrado, Var_FechaFinCerrado
			 from PERIODOCONTABLE
			where Estatus = PeriodoCerrado;

		INSERT INTO TMPDETHISSALDOS
			  select  Fecha, Par_CuentaBancaria, Var_CuentaCompleta, pol.CentroCostoID, pol.Cargos, pol.Abonos
				from  DETALLEPOLIZA pol
			   where  pol.Fecha>Var_FechaFinCerrado
				 and  pol.Fecha<=Par_Fecha and pol.CuentaCompleta = Var_CuentaCompleta
			order by  pol.CentroCostoID;

	end if;	 -- FIN PERIODO CONTABLE VIGENTE


SELECT Fecha,	CuentaBancaria,	 CuentaContable,	CentroCostoID,	Cargos,  Abonos
  FROM TMPDETHISSALDOS;

end if;  --  FIN DEL TIPO DE REPORTE DETALLADO

drop table if exists TMPHISSALDOS;
drop table if exists TMPHISCARGOSABONOS;
drop table if exists TMPDETHISSALDOS;

END TerminaStore$$
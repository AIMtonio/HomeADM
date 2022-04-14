-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULOHISTASASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULOHISTASASPRO`;
DELIMITER $$


CREATE PROCEDURE `CALCULOHISTASASPRO`(
	Par_Fecha			date,

	Par_Salida			char(1),
inout	Par_NumErr		int,
inout	Par_ErrMen		varchar(200),

	Par_EmpresaID		int(1),
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
)

TerminaStore:BEGIN

declare EnteroCero			int(1);
declare DecimalCero			decimal(1,1);
declare	SalidaSi			char(1);
declare UnDiaHabil			int(1);




declare InicioMes			date;
declare FinMes				date;
declare DiasDiferencia		int(2);
declare Contador			int(2);
declare DiaRegistro			date;
declare	SigDiaHabil			date;
declare EsHabil				char(1);
declare MesActual			int(2);
declare MesSigDiaHabil		int(2);
declare	DiasCalcular		int(2);


set EnteroCero	:=	0;
set DecimalCero	:=	0.0;
set SalidaSi	:= 'S';
set UnDiaHabil	:= 1;



set Contador	:=	EnteroCero;

drop table if exists TMPTASASBASEAUX;

create temporary table TMPTASASBASEAUX(
	TasaBaseID			int(2),
	Fecha				datetime,
	Valor				decimal(12,4),
	primary key(TasaBaseID)
)engine=InnoDB default charset=Latin1;

drop table if exists TMPTASASBASEDIA;

create temporary table TMPTASASBASEDIA(
	RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	TasaBaseID			int(2),
	Fecha				datetime,
	FechaValor			date,
	Valor				decimal(12,4)
)engine=InnoDB default charset=Latin1;

drop table if exists TMPTASAHISMAX;

create temporary table TMPTASAHISMAX(
	RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	TasaBaseID			int(2),
	FechaMax			date
)engine=InnoDB default charset=Latin1;


set InicioMes = convert(concat(extract(year_month from Par_fecha),'01'),date);

call DIASFESTIVOSCAL(Par_Fecha,				UnDiaHabil,			SigDiaHabil,		EsHabil,		Par_EmpresaID,
					 Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
					 Aud_NumTransaccion);

set MesActual 		:= month(Par_Fecha);
set MesSigDiaHabil	:= month(SigDiaHabil);

set DiasDiferencia=datediff(SigDiaHabil,InicioMes);

set Contador=EnteroCero;
set DiaRegistro =InicioMes;

update CALHISTASASBASE
	set Valor	= 	DecimalCero
	where Fecha >= InicioMes and Fecha <= last_day(InicioMes);

while (DiasDiferencia>Contador) do


	insert into CALHISTASASBASE
	select TasaBaseID,DiaRegistro,DecimalCero
		from TASASBASE tb
		where not exists(select TasaBaseID
							from CALHISTASASBASE tmp
							where tmp.TasaBaseID=tb.TasaBaseID and Fecha=DiaRegistro);


	insert into TMPTASAHISMAX (TasaBaseID,		FechaMax)
	select TasaBaseID,max(Fecha)
		from `HIS-TASASBASE`
		where convert(Fecha,date)<=DiaRegistro
		group by TasaBaseID;


	insert into TMPTASASBASEAUX
	select his.TasaBaseID,max(his.FechaActual),DecimalCero
		from `HIS-TASASBASE` his
			inner join TMPTASAHISMAX tmp on his.TasaBaseID=tmp.TasaBaseID and his.Fecha=tmp.FechaMax
		group by TasaBaseID;

	update TMPTASASBASEAUX tmp
		inner join `HIS-TASASBASE` htb on tmp.TasaBaseID=htb.TasaBaseID and tmp.Fecha=htb.FechaActual
			set tmp.Valor=htb.Valor;


	insert into TMPTASASBASEDIA (TasaBaseID,	Fecha,	FechaValor,	Valor)
	select TasaBaseID,max(FechaActual),DiaRegistro,DecimalCero
		from `HIS-TASASBASE`
		where convert(Fecha,date) = DiaRegistro
		group by TasaBaseID;
		

	update TMPTASASBASEDIA tmp
		inner join `HIS-TASASBASE` htb on tmp.TasaBaseID=htb.TasaBaseID and tmp.Fecha=htb.FechaActual
			set tmp.Valor=htb.Valor;


	update CALHISTASASBASE tmp
		inner join TMPTASASBASEDIA htb	on tmp.TasaBaseID=htb.TasaBaseID  and htb.FechaValor=DiaRegistro
			set tmp.Valor=htb.Valor
	where tmp.Valor=DecimalCero and tmp.Fecha=DiaRegistro;


	update CALHISTASASBASE tmp
		inner join TMPTASASBASEAUX tmpa on tmp.TasaBaseID=tmpa.TasaBaseID
			set tmp.Valor=tmpa.Valor
	where tmp.Valor=DecimalCero and tmp.Fecha=DiaRegistro;


	update CALHISTASASBASE tmp
		inner join TASASBASE tb	on	tmp.TasaBaseID=tb.TasaBaseID
			set tmp.Valor=tb.Valor
	where tmp.Valor=DecimalCero and tmp.Fecha=DiaRegistro;

	set DiaRegistro=DATE_ADD(DiaRegistro,interval 1 day);
	set Contador=Contador+1;

	truncate TMPTASASBASEAUX;
	truncate TMPTASASBASEDIA;
	truncate TMPTASAHISMAX;

end while;

drop table if exists TMPTASASBASEAUX;
drop table if exists TMPTASASBASEDIA;
drop table if exists TMPTASAHISMAX;

set Par_NumErr	:=EnteroCero;
set Par_ErrMen	:= 'Calculo de Tasas Base Finalizado Correctamente.';

 if (Par_Salida = SalidaSi) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen;
end if;


END TerminaStore$$

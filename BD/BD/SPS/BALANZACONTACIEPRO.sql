-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANZACONTACIEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANZACONTACIEPRO`;DELIMITER $$

CREATE PROCEDURE `BALANZACONTACIEPRO`(
	Par_EjercicioID	int,
	Par_EmpresaID		int,

	Aud_Usuario		int,
	Aud_FechaActual	DateTime,
	Aud_DireccionIP	varchar(15),
	Aud_ProgramaID	varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Var_UltFecPer		date;
DECLARE	Var_FechaFinPer	date;
DECLARE	Var_FechaIniPer	date;
DECLARE	Var_FechaSistema	date;


DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Moneda_Cero		int;
DECLARE	VarDeudora			char(1);
DECLARE	VarAcreedora			char(1);


set Fecha_Vacia		= '1900-01-01';
set Entero_Cero	= 0;
set Moneda_Cero	= 0.00;

set VarDeudora	= 'D';
set VarAcreedora	= 'A';

select FechaSistema into Var_FechaSistema
	from PARAMETROSSIS;

select  max(FechaCorte) into Var_UltFecPer
	from SALDOSCONTABLES;

set Var_UltFecPer = ifnull(Var_UltFecPer, Fecha_Vacia);

select Fin, Inicio into Var_FechaFinPer, Var_FechaIniPer
	from EJERCICIOCONTABLE
	where EjercicioID = Par_EjercicioID;

set Var_FechaFinPer = ifnull(Var_FechaFinPer, Fecha_Vacia);

if (Var_FechaFinPer = Fecha_Vacia) then
	select '001' as NumErr,
		 'El Ejercicio a Cerrar no Existe' as ErrMen;
	LEAVE TerminaStore;
end if;

delete from BALANZACONTA
	where EjercicioID = Par_EjercicioID;

insert into TMPBALANZA
	SELECT Aud_NumTransaccion, Var_FechaSistema, Sal.CuentaCompleta, Cub.ConBalanzaID,
		  ROUND(sum(Cargos),2), ROUND(sum(Abonos),2), Cc.Naturaleza
		from SALDOSCONTABLES Sal,
			CUENTASBALANZA Cub,
			CUENTASCONTABLES Cc
		where 	Sal.CuentaCompleta= Cub.CuentaContable
		   and  	Sal.CuentaCompleta= Cc.CuentaCompleta
		   and 	Sal.FechaCorte >= Var_FechaIniPer
		   and 	Sal.FechaCorte <= Var_FechaFinPer
		group by Cub.ConBalanzaID;




insert into BALANZACONTA
	SELECT 	Par_EjercicioID,	Cob.ConBalanzaID, 	Cob.Descripcion,
			Var_FechaFinPer,	ifnull(bal.SaldoInicial, Entero_Cero),
			ifnull(Tmp.Cargos, 	Entero_Cero),
			ifnull(Tmp.Abonos, 	Entero_Cero),
			CASE WHEN (Tmp.Naturaleza)= VarDeudora THEN (Tmp.Cargos-Tmp.Abonos)
			  WHEN (Tmp.Naturaleza)= VarAcreedora THEN (Tmp.Abonos-Tmp.Cargos) END,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
		FROM CONCEPTOBALANZA Cob
		LEFT OUTER JOIN TMPBALANZA as Tmp ON  Tmp.ConBalanzaID =Cob.ConBalanzaID
		LEFT OUTER JOIN BALANZACONTA as bal ON (Tmp.ConBalanzaID = bal.ConBalanzaID);




 truncate table TMPBALANZA;

END TerminaStore$$
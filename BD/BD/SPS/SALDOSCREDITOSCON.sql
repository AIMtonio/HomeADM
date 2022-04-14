-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCREDITOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSCREDITOSCON`;DELIMITER $$

CREATE PROCEDURE `SALDOSCREDITOSCON`(


	Par_Fecha           	date,
	Par_NumCon			tinyint unsigned,

	Par_EmpresaID       	int,
	Aud_Usuario         	int,
	Aud_FechaActual     	dateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int,
	Aud_NumTransaccion  	bigint
		)
TerminaStore: BEGIN


declare Entero_Cero	int;
declare Con_UltFecha	int;
declare Fecha_Vacia	date;


declare Var_FechaCorte date;
declare Var_FechaSug 	date;


set Entero_Cero 		:= 0;
set Con_UltFecha		:= 4;
set Fecha_Vacia		:= '1900-01-01';





if(Par_NumCon = Con_UltFecha) then
	set Var_FechaCorte := (select  sal.FechaCorte
						from SALDOSCREDITOS sal
						inner join CATCLASIFREPREG reg on sal.ClasifRegID = reg.ClasifRegID
						where   sal.FechaCorte  = Par_Fecha
						group by sal.FechaCorte);
	if(ifnull(Var_FechaCorte, Entero_Cero))= Entero_Cero then
		set Var_FechaSug := (select  max(sal.FechaCorte)
							from SALDOSCREDITOS sal
							where FechaCorte <= Par_Fecha);


		if(ifnull(Var_FechaSug, Fecha_Vacia))= Fecha_Vacia then
			set Var_FechaSug := (select  min(sal.FechaCorte)
							from SALDOSCREDITOS sal);

         SET Var_FechaSug:= ifnull(Var_FechaSug, Fecha_Vacia);
		end if;

		select Var_FechaSug ;

	else
		select Par_Fecha ;
	end if;
end if;


END TerminaStore$$
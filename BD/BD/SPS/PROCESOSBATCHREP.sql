-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROCESOSBATCHREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROCESOSBATCHREP`;DELIMITER $$

CREATE PROCEDURE `PROCESOSBATCHREP`(

	Par_FechaInicio		Date,
	Par_FechaFinal    	Date,
	Par_NumRep			tinyint unsigned,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Var_Sentencia	varchar(8000);
DECLARE Var_PLD		int(11);
DECLARE Var_PLDopRel	int(11);
DECLARE Var_PLDopInu	int(11);
DECLARE Var_PLDPaSeg	int(11);


DECLARE Rep_Principal	int(11);
DECLARE Rep_PLD		int(11);


Set	Rep_Principal		:= 1;
Set	Rep_PLD			:= 2;


Set Var_PLD 			:= 500;
Set Var_PLDopRel		:= 501;
Set Var_PLDopInu		:= 502;
Set Var_PLDPaSeg		:= 503;

if(Par_NumRep = Rep_Principal) then
	set Var_Sentencia := 'select B.ProcesoBatchID,P.Descripcion,P.SubProceso, B.Fecha,B.Tiempo,B.Empresa,B.Usuario ';
	set Var_Sentencia :=  CONCAT(Var_Sentencia, ' from BITACORABATCH B, PROCESOSBATCH P ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia, 'where B.Fecha>="',Par_FechaInicio,'" and B.Fecha<="',Par_FechaFinal,'" ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia, 'and B.ProcesoBatchID = P.ProcesoBatchID ORDER BY B.Fecha, ProcesoBatchID');
end if;

if(Par_NumRep = Rep_PLD) then
	set Var_Sentencia := 'select B.ProcesoBatchID,P.Descripcion,P.SubProceso, B.Fecha,B.Tiempo,B.Empresa,B.Usuario ';
	set Var_Sentencia :=  CONCAT(Var_Sentencia, ' from BITACORABATCH B, PROCESOSBATCH P ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia, 'where B.Fecha>="',Par_FechaInicio,'" and B.Fecha<="',Par_FechaFinal,'" ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and (P.ProcesoBatchID =',Var_PLD, ' or P.ProcesoBatchID =',Var_PLDopRel, ' or P.ProcesoBatchID =',Var_PLDopInu,' or P.ProcesoBatchID =',Var_PLDPaSeg,') ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and B.ProcesoBatchID = P.ProcesoBatchID ORDER BY B.Fecha, ProcesoBatchID');

end if;


  SET @Sentencia	= (Var_Sentencia);

    PREPARE STPROCESOBATCHREP FROM @Sentencia;
    EXECUTE STPROCESOBATCHREP;
    DEALLOCATE PREPARE STPROCESOBATCHREP;

END TerminaStore$$
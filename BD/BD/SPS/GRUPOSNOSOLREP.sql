-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSNOSOLREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSNOSOLREP`;DELIMITER $$

CREATE PROCEDURE `GRUPOSNOSOLREP`(
	Par_GrupoInicial	    bigint,
	Par_GrupoFinal		    bigint,
	Par_PromotorInicial	 bigint,
	Par_PromotorFinal	    bigint,
	Par_Sucursal          bigint,

   Aud_Usuario		    	int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		   varchar(50),
	Aud_Sucursal		   int,
	Aud_NumTransaccion	bigint


	)
TerminaStore: BEGIN

DECLARE	Var_Sentencia	varchar(8000);
DECLARE	Var_SentenUnion	varchar(8000);


DECLARE Entero_Cero     int;
DECLARE EstatusVigente   char(1);
DECLARE EstatusVencido   char(1);
DECLARE EstatusActivas   char(1);
DECLARE EstatusBloqueadas   char(1);



SET Entero_Cero      := 0;
SET EstatusVigente   :='V';
SET EstatusVencido   :='B';
SET EstatusActivas   :='A';
SET EstatusBloqueadas   :='B';



set Var_Sentencia := CONCAT('select Inte.ClienteID as ClienteID, NombreCompleto as Nombrecompleto ,TipoIntegrantes,  EsMenorEdad , Gru.GrupoID,
                                    Gru.NombreGrupo, Gru.PromotorID, NombrePromotor,Suc.SucursalID, NombreSucurs,
                                       sum(ifnull(SaldoDispon,0)) as Ahorro,
                                       sum(FUNCIONEXIGIBLE(CreditoID)) AS ExigDia,
                                       sum(FUNCIONTOTDEUDACRE(CreditoID)) as TotalDia, convert(time(now()),char) as HoraEmision
                                        from  SUCURSALES Suc
                                        Inner join GRUPOSNOSOLIDARIOS Gru on Suc.SucursalID = Gru.SucursalID
                                        left  join PROMOTORES Pro  ON Gru.PromotorID= Pro.PromotorID
                                        inner join INTEGRAGRUPONOSOL Inte on Gru.GrupoID=Inte.GrupoID
                                        inner join CLIENTES Cli on Cli.ClienteID =Inte.ClienteID
                                        left join CREDITOS Cre on Inte.ClienteID= Cre.ClienteID
                                                                and Cre.Estatus IN("',EstatusVigente,'","',EstatusVencido,'")
                                        left join CUENTASAHO Cue on Cue.ClienteID=Inte.ClienteID
                                        and Cue.Estatus in("',EstatusActivas,'","',EstatusBloqueadas,'")
										         where Cli.ClienteID =Inte.ClienteID');

if Par_GrupoInicial != Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and Gru.GrupoID Between ',Par_GrupoInicial, ' and ',Par_GrupoFinal);

end if;

if Par_PromotorInicial != Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and Gru.PromotorID Between ',Par_PromotorInicial, ' and ', Par_PromotorFinal);

end if;

if Par_Sucursal!=Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and Gru.SucursalID= ',Par_Sucursal);
end if;

set Var_Sentencia :=  CONCAT(Var_Sentencia, '  group By Inte.ClienteID, Gru.GrupoID
                                                order By Gru.GrupoID ');

SET @Sentencia	= (Var_Sentencia);
PREPARE STGRUPOSNOSOLIDREP FROM @Sentencia;
 EXECUTE STGRUPOSNOSOLIDREP ;
DEALLOCATE PREPARE STGRUPOSNOSOLIDREP;



END TerminaStore$$
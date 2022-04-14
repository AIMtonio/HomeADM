-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSASOPERREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVERSASOPERREP`;DELIMITER $$

CREATE PROCEDURE `REVERSASOPERREP`(
		Par_FechaInicial	    date,
	Par_FechaFinal		    date,
	Par_Sucursal          	bigint,
	Par_CajaID				bigint,

	Par_EmpresaID			int,
    Aud_Usuario		    	int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID		    varchar(50),
	Aud_Sucursal		    int,
	Aud_NumTransaccion		bigint


	)
TerminaStore: BEGIN

DECLARE	Var_Sentencia		varchar(8000);
DECLARE	Var_SentenUnion		varchar(8000);


DECLARE Entero_Cero     	int;
DECLARE EstatusVigente   	char(1);
DECLARE EstatusVencido   	char(1);
DECLARE EstatusActivas   	char(1);
DECLARE EstatusBloqueadas   char(1);
DECLARE Cadena_Vacia		char(1);
DECLARE hora				varchar(200);

SET Entero_Cero      		:= 0;
SET EstatusVigente   		:='V';
SET EstatusVencido   		:='B';
SET EstatusActivas   		:='A';
SET EstatusBloqueadas   	:='B';
SET Cadena_Vacia			:='';
Set hora 					:='%H:%i';

set Var_Sentencia := CONCAT(' SELECT Suc.SucursalID,Suc.NombreSucurs,Caj.CajaID,Rev.Fecha,upper(Usu.Clave) as Clave ,upper(Rev.ClaveUsuarioAut) as ClaveUsuarioAut,DATE_FORMAT(Rev.FechaActual,"'"%H:%i"'"),CTP.Descripcion,Rev.Motivo,Rev.Referencia,
									 Rev.Monto,Rev.TransaccionID,Caj.DescripcionCaja
								FROM REVERSASOPER Rev
									INNER JOIN CAJASVENTANILLA Caj on Caj.CajaID=Rev.CajaID
									INNER JOIN USUARIOS Usu on Usu.UsuarioID=Caj.UsuarioID
									INNER JOIN CAJATIPOSOPERA CTP on CTP.Numero=Rev.TipoOperacion
									INNER JOIN SUCURSALES Suc on Suc.SucursalID=Rev.SucursalID
										where Rev.Fecha between ? and ? ');


if Par_Sucursal!=Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and Rev.SucursalID= ',Par_Sucursal);
end if;

if Par_CajaID!=Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and Rev.CajaID= ',Par_CajaID);
end if;

set Var_Sentencia :=  CONCAT(Var_Sentencia, '  order by Rev.SucursalID,Rev.CajaID,Rev.Fecha  ; ');



SET @Sentencia	= (Var_Sentencia);
SET @FechaInicio	= Par_FechaInicial;
SET @FechaFin		= Par_FechaFinal;


PREPARE STREPORTREVERSAS FROM @Sentencia;
EXECUTE STREPORTREVERSAS USING @FechaInicio,@FechaFin;
DEALLOCATE PREPARE STREPORTREVERSAS;

END TerminaStore$$
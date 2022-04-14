-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RECEPCHEQUESBCREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `RECEPCHEQUESBCREP`;DELIMITER $$

CREATE PROCEDURE `RECEPCHEQUESBCREP`(

	Par_FechaInicio			date,
	Par_FechaFin			date,
	Par_NoCuentaInstitu		bigint,
	Par_Sucursal			int(11),
	Par_ClienteID			int(11),
	Par_InstiBancaria		int(11),
	Par_EstatusCheque		char(1),

	Par_EmpresaID       	int,
    Aud_Usuario         	int,
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint

	)
TerminaStore: BEGIN


DECLARE Var_Sentencia 		varchar(9000);
DECLARE Var_NomInstiAplica	varchar(100);


DECLARE Cadena_Vacia        char(1);
DECLARE Fecha_Vacia         date;
DECLARE Entero_Cero         int;
DECLARE EstaChequeRecibido		char(1);


Set Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
Set EstaChequeRecibido		:= 'R';



set Var_Sentencia := 'select CLE.ClienteID,CLE.NombreCompleto as NombreCliente,CHE.CuentaAhoID,CHE.BancoEmisor,INS.Nombre as NombBanEmisor,CHE.CuentaEmisor,CHE.NumCheque,';
set Var_Sentencia := CONCAT(Var_Sentencia,'  CHE.NombreEmisor,CHE.CuentaAplica,CHE.Monto,CHE.Estatus,CHE.FechaCobro as FechaRecepcion,');
set Var_Sentencia := CONCAT(Var_Sentencia,'  CHE.FechaAplicacion,CHE.NumInstAplica,');
set Var_Sentencia := CONCAT(Var_Sentencia,'  INSAP.Nombre as NombreInsAplica,');
set Var_Sentencia := CONCAT(Var_Sentencia,' CHE.FormaAplica,CHE.SucursalID,SUC.NombreSucurs ');
set Var_Sentencia := CONCAT(Var_Sentencia,' from CLIENTES CLE ');
set Var_Sentencia := CONCAT(Var_Sentencia,' inner join  ABONOCHEQUESBC CHE ');
set Var_Sentencia := CONCAT(Var_Sentencia,' inner join INSTITUCIONES INS  ');
set Var_Sentencia := CONCAT(Var_Sentencia,' inner join SUCURSALES SUC');
set Var_Sentencia := CONCAT(Var_Sentencia,' left outer join INSTITUCIONES INSAP on (CHE.NumInstAplica = INSAP.InstitucionID) ');
set Var_Sentencia := CONCAT(Var_Sentencia,' WHERE CLE.ClienteID= CHE.ClienteID');
set Var_Sentencia := CONCAT(Var_Sentencia,' and	CHE.BancoEmisor = INS.InstitucionID ');
set Var_Sentencia := CONCAT(Var_Sentencia,' and	CHE.SucursalID = SUC.SucursalID');

set Par_FechaInicio :=ifnull(Par_FechaInicio,Fecha_Vacia);
set Par_FechaFin :=ifnull(Par_FechaFin,Fecha_Vacia);


		if(Par_FechaInicio!=Fecha_Vacia) then
			if(Par_FechaFin!=Fecha_Vacia) then
				if(Par_EstatusCheque!=EstaChequeRecibido)then
					set Var_Sentencia:= 	CONCAT(Var_Sentencia, " and CHE.FechaAplicacion >= '",Par_FechaInicio,"'");
					set Var_Sentencia:= 	CONCAT(Var_Sentencia, " and CHE.FechaAplicacion <=' ",Par_FechaFin,"'");
				else
					set Var_Sentencia:= 	CONCAT(Var_Sentencia, " and CHE.FechaCobro >= '",Par_FechaInicio,"'");
					set Var_Sentencia:= 	CONCAT(Var_Sentencia, " and CHE.FechaCobro <=' ",Par_FechaFin,"'");
			end if;
		end if;

	end if;

set Par_Sucursal :=ifnull(Par_Sucursal,Entero_Cero);

	if(Par_Sucursal!= Entero_Cero) then
			set Var_Sentencia := CONCAT(Var_Sentencia,'  and CHE.SucursalID = ',convert(Par_Sucursal,char));
	end if;

set Par_ClienteID :=ifnull(Par_ClienteID,Entero_Cero);

	if(Par_ClienteID!= Entero_Cero) then
			set Var_Sentencia := CONCAT(Var_Sentencia,'  and CHE.ClienteID = "',Par_ClienteID,'"');
	end if;

set Par_InstiBancaria :=ifnull(Par_InstiBancaria,Entero_Cero);

	if(Par_InstiBancaria != Entero_Cero) then
			set Var_Sentencia := CONCAT(Var_Sentencia,'  and CHE.NumInstAplica = ',convert(Par_InstiBancaria,char));
	end if;


set Par_NoCuentaInstitu	:=ifnull(Par_NoCuentaInstitu,Entero_Cero);

	if(Par_NoCuentaInstitu!= Entero_Cero) then
		if(Par_NoCuentaInstitu !=Entero_Cero)then
					set Var_Sentencia := CONCAT(Var_Sentencia,'  and CHE.CuentaAplica = ',convert(Par_NoCuentaInstitu,char(16)));
		end if;
	end if;

set Par_EstatusCheque :=ifnull(Par_EstatusCheque,Cadena_Vacia);

	if(Par_EstatusCheque!= Cadena_Vacia) then
		set Var_Sentencia := CONCAT(Var_Sentencia,"  and CHE.Estatus = '",Par_EstatusCheque,"'");
	end if;

set Var_Sentencia := CONCAT(Var_Sentencia,'  order by CHE.SucursalID,CHE.NumInstAplica, CHE.CuentaAplica  asc;');

SET @Sentencia	= (Var_Sentencia);


    PREPARE REPCEPCHEQUESBCREP FROM @Sentencia;
    EXECUTE REPCEPCHEQUESBCREP;
    DEALLOCATE PREPARE REPCEPCHEQUESBCREP;



END TerminaStore$$
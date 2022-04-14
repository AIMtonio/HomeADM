-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMEXCUENTASREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIMEXCUENTASREP`;DELIMITER $$

CREATE PROCEDURE `LIMEXCUENTASREP`(
	Par_FechaInicio			date,
	Par_FechaFin			date,
	Par_SucursalID			int(11),
    Par_Motivo              int,
	Par_NumRep              tinyint unsigned,

    Par_EmpresaID       	int,
    Aud_Usuario         	int,
    Aud_FechaActual     	date,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint

	)
TerminaStore: BEGIN



DECLARE Var_Sentencia 	 varchar(4000);

DECLARE Rep_LimExcep     int(11);
DECLARE canalE           char(1);
DECLARE canalR           char(1);
DECLARE valorCanalE      varchar(15);
DECLARE valorCanalR      varchar(15);
DECLARE motivoSMC        char(3);
DECLARE motivoLPM        char(3);
DECLARE valorMotivoSMC   varchar(45);
DECLARE valorMotivoLPM   varchar(55);
DECLARE Entero_Cero		 int;
DECLARE Cadena_Vacia	 char(1);
DECLARE todos            varchar(3);



set   Rep_LimExcep  := 1;
set   canalE        := 'E';
set   canalR        := 'R';
set   valorCanalE   := 'EFECTIVO';
set   valorCanalR   := 'REFERENCIADO';
set   motivoSMC     := '4';
set   motivoLPM     := '3';
set   valorMotivoSMC := 'SUPERÓ EL SALDO MÁXIMO DE LA CUENTA';
set   valorMotivoLPM := 'SUPERÓ EL LÍMITE DE ABONOS PERMITIDOS EN EL MES';
set   Entero_Cero    :=0;
set   Cadena_Vacia   := '';
set   todos          :='T';



if(Par_NumRep = Rep_LimExcep) then


set Var_Sentencia :=  'SELECT LE.CuentaAhoID,TC.Descripcion, LE.Fecha,  SC.NombreSucurs, CL.NombreCompleto, ';
set Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE  LE.Motivo ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "',motivoSMC,'" THEN "',valorMotivoSMC,'" ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "',motivoLPM,'" THEN "',valorMotivoLPM,'" ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' END as Motivo, ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE  LE.Canal ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "',canalE,'" THEN "',valorCanalE,'" ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "',canalR,'" THEN "',valorCanalR,'" ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' END as Canal ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM LIMEXCUENTAS as LE ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' inner join CUENTASAHO as CA on LE.CuentaAhoID = CA.CuentaAhoID ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' inner join TIPOSCUENTAS as TC on CA.TipoCuentaID = TC.TipoCuentaID ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' inner join CLIENTES as CL on CA.ClienteID = CL.ClienteID ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' inner join SUCURSALES as SC on LE.SucursalID = SC.SucursalID ' );
set Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE DATE(Fecha) >= "',DATE(Par_FechaInicio),'" and DATE(Fecha) <= "',DATE(Par_FechaFin),'" ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' and LE.CuentaAhoID = CA.CuentaAhoID ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' and CA.TipoCuentaID = TC.TipoCuentaID ');


set Par_SucursalID := ifnull(Par_SucursalID, Entero_Cero);
if(Par_SucursalID != Entero_Cero)then
    set Var_Sentencia = CONCAT(Var_sentencia,' and LE.SucursalID =', convert(Par_SucursalID,char));
end if;

set Par_Motivo := ifnull(Par_Motivo, Entero_Cero);
if(Par_Motivo != Entero_Cero)then
    set Var_Sentencia = CONCAT(Var_sentencia,' and LE.Motivo = ',Par_Motivo,' ' );
end if;

set Var_Sentencia :=  CONCAT(Var_Sentencia,' order by LE.SucursalID; ');

SET @Sentencia	= (Var_Sentencia);
PREPARE LIMEXCREP FROM @Sentencia;
EXECUTE LIMEXCREP;
DEALLOCATE PREPARE LIMEXCREP;

end if;

END TerminaStore$$
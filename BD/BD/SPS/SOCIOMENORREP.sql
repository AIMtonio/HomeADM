-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIOMENORREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIOMENORREP`;
DELIMITER $$


CREATE PROCEDURE `SOCIOMENORREP`(

	Par_Sucursal            int(11),
	Par_EstatusCta			char(1),
	Par_Promotor			int(6),

	Par_EmpresaID           int,
	Aud_Usuario             int,
	Aud_FechaActual         DateTime,
	Aud_DireccionIP         varchar(15),
	Aud_ProgramaID          varchar(50),
	Aud_Sucursal            int,
	Aud_NumTransaccion      bigint

	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Sentencia 			varchar(9000);
-- Declaracion de Constantes

DECLARE Cadena_Vacia            char(1);
DECLARE Entero_Cero             int;
DECLARE Decimal_Cero			decimal(14,2);

-- Asignacion de Constantes
Set Cadena_Vacia                := '';  -- Cadena  Vacia
Set Entero_Cero                 := 0;   -- Entero Cero
Set Decimal_Cero				:= 0.00; -- Decimal Cero

set Var_Sentencia :=( '	select  SOM.SocioMenorID as NoSocioMenor, ifnull(CLE.NombreCompleto,"NA") as NombreClienteMenor,');
set Var_Sentencia :=CONCAT(Var_Sentencia, '  ifnull(DIR.DireccionCompleta,"NA")as DirecSocioMenor,   (YEAR(curdate())-YEAR(CLE.FechaNacimiento)+ IF(DATE_FORMAT(curdate() ,''%m-%d'') >= DATE_FORMAT(CLE.FechaNacimiento	,''%m-%d''), 0, -1)) as Edad,');
set Var_Sentencia :=CONCAT(Var_Sentencia, '  CLE.FechaNacimiento,SOM.ClienteTutorID, ifnull(CL.NombreCompleto,"NA") as NombreTutor,ifnull(SOM.NombreTutor,"NA") as NombreTutorSocMe,');
set Var_Sentencia :=CONCAT(Var_Sentencia, '  convert(ifnull(CUE.CuentaAhoID,"',Entero_Cero,'"),char) as CuentaAhoID,ifnull(CUE.Estatus,"NA")as Estatus,CUE.Saldo');
set Var_Sentencia :=CONCAT(Var_Sentencia, '	 ,CLE.PromotorActual,ifnull(PRO.NombrePromotor,"NA") as NombrePromotor,CLE.SucursalOrigen,');
set Var_Sentencia :=CONCAT(Var_Sentencia, '	 ifnull(SUC.NombreSucurs,"NA") as NombreSucursal');
set Var_Sentencia :=CONCAT(Var_Sentencia, '  from');
set Var_Sentencia :=CONCAT(Var_Sentencia, '  CLIENTES CLE');
set Var_Sentencia :=CONCAT(Var_Sentencia, '  inner join SOCIOMENOR SOM on SOM.SocioMenorID = CLE.ClienteID');
set Var_Sentencia :=CONCAT(Var_Sentencia, '	 left join  CLIENTES CL on SOM.ClienteTutorID = CL.ClienteID');
set Var_Sentencia :=CONCAT(Var_Sentencia, '	 left join DIRECCLIENTE DIR on DIR.ClienteID = SOM.SocioMenorID');
set Var_Sentencia :=CONCAT(Var_Sentencia, '	 left join CUENTASAHO CUE	on CUE.ClienteID = SOM.SocioMenorID');
set Var_Sentencia :=CONCAT(Var_Sentencia, '	 left join PROMOTORES PRO	on PRO.PromotorID = CLE.PromotorActual');
set Var_Sentencia :=CONCAT(Var_Sentencia, '	 left join SUCURSALES SUC	on CLE.SucursalOrigen = SUC.SucursalID');
set Var_Sentencia :=CONCAT(Var_Sentencia, '  where SOM.SocioMenorID = CLE.ClienteID');

set Par_Sucursal :=ifnull(Par_Sucursal,Entero_Cero);

	if(Par_Sucursal!= Entero_Cero)then
		set Var_Sentencia :=CONCAT(Var_Sentencia, '	and CLE.SucursalOrigen ="',Par_Sucursal,'"');
	end if;

set Par_EstatusCta := ifnull(Par_EstatusCta,Cadena_Vacia);

	if(Par_EstatusCta!=Cadena_Vacia)then
	set Var_Sentencia:= 	CONCAT(Var_Sentencia,"  and CUE.Estatus='",Par_EstatusCta,"'");
	end if;

set Par_Promotor :=ifnull(Par_Promotor,Entero_Cero);

	if(Par_Promotor!= Entero_Cero)then
		set Var_Sentencia :=CONCAT(Var_Sentencia, '	and CLE.PromotorActual ="',Par_Promotor,'"');
	end if;

set Var_Sentencia :=CONCAT(Var_Sentencia, ' order by CLE.SucursalOrigen, CLE.PromotorActual;');

SET @Sentencia	= (Var_Sentencia);


    PREPARE SOCIOMENORREP FROM @Sentencia;
    EXECUTE SOCIOMENORREP;
    DEALLOCATE PREPARE SOCIOMENORREP;

END TerminaStore$$
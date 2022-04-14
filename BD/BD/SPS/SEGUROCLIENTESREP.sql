-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLIENTESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROCLIENTESREP`;DELIMITER $$

CREATE PROCEDURE `SEGUROCLIENTESREP`(
    Par_FechaInicio     date,
    Par_FechaFin        date,
    Par_ClienteID       int(11),
    Par_SucursalOrigen  int(11),    -- Sucursal que tiene el cliente
    Par_PromotorActual  int(11),    -- Promotor que tiene el cliente
    Par_EstatusSeg      char(1),    -- Estatus del Seguro

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Sentencia 		varchar(4000);


-- Declaracion de Constantes
DECLARE Cadena_Vacia		char(1);
DECLARE Fecha_Vacia			date;
DECLARE Entero_Cero			int;
DECLARE FechaSist			date;
DECLARE Est_Vigente		char(1);
DECLARE Est_Cobrado		char(1);

-- Asignacion de Constantes
Set Cadena_Vacia	:= '';
Set Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero		:= 0;
Set Est_Vigente		:= 'V';                 -- Estatus del Seguro: Vigente
Set Est_Cobrado		:= 'C';                 -- Estatus del Seguro: Cobrado

set Var_Sentencia :=  'select Cli.ClienteID, Seg.SeguroClienteID, Cli.NombreCompleto, (SELECT VigDiasSeguro FROM PARAMETROSSIS WHERE EmpresaID = 1 ) as Vigencia, ';
set Var_Sentencia :=  CONCAT(Var_Sentencia,' FechaInicio, Seg.FechaVencimiento, MontoSegAyuda, MontoSeguro as MontoPoliza, Seg.Estatus, ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' convert(ifnull(Mov.Fecha, "1900-01-01"),char) as FechaCobro,ifnull(sum(Mov.Monto), 0) as MontoCobro, Cli.SucursalOrigen, ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' Suc.NombreSucurs,Cli.PromotorActual,prom.NombrePromotor, ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE WHEN Seg.Estatus = "C" THEN MontoSeguro ELSE 0 END as MontoSeguro ');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' from CLIENTES as Cli, SUCURSALES as Suc, PROMOTORES as prom, SEGUROCLIENTE as Seg left outer join SEGUROCLIMOV as Mov' );
set Var_Sentencia := 	CONCAT(Var_Sentencia,' on Mov.SeguroClienteID = Seg.SeguroClienteID and  Mov.Tipo = "C"');
set Var_Sentencia :=  CONCAT(Var_Sentencia,' where Cli.ClienteID = Seg.ClienteID ');

set Par_ClienteID := ifnull(Par_ClienteID, Entero_Cero);
if(Par_ClienteID != Entero_Cero)then
    set Var_Sentencia = CONCAT(Var_sentencia,' and Cli.ClienteID =', convert(Par_ClienteID,char));
end if;

set Par_SucursalOrigen := ifnull(Par_SucursalOrigen, Entero_Cero);
if(Par_SucursalOrigen != Entero_Cero)then
    set Var_Sentencia = CONCAT(Var_sentencia,' and Cli.SucursalOrigen =',convert(Par_SucursalOrigen,char));
    set Var_Sentencia = CONCAT(Var_sentencia,' and Cli.SucursalOrigen = Suc.SucursalID');
else
    set Var_Sentencia = CONCAT(Var_sentencia,' and Cli.SucursalOrigen = Suc.SucursalID');
end if;

set Par_PromotorActual := ifnull(Par_PromotorActual, Entero_Cero);
if(Par_PromotorActual != Entero_Cero)then
    set Var_Sentencia = CONCAT(Var_sentencia,' and Cli.PromotorActual =',convert(Par_PromotorActual ,char));
    set Var_Sentencia = CONCAT(Var_sentencia,' and Cli.PromotorActual = prom.PromotorID');
else
    set Var_Sentencia = CONCAT(Var_sentencia,' and Cli.PromotorActual = prom.PromotorID');
end if;

set Par_EstatusSeg := ifnull(Par_EstatusSeg, Cadena_Vacia);
if(Par_EstatusSeg != Cadena_Vacia)then
    set Var_Sentencia = CONCAT(Var_sentencia,' and Seg.Estatus ="', Par_EstatusSeg, '" ');
end if;

-- Rango de Fechas
if(ifnull(Par_FechaInicio,Fecha_Vacia) != Fecha_Vacia and ifnull(Par_FechaFin,Fecha_Vacia) != Fecha_Vacia and
   Par_ClienteID = Entero_Cero ) then
    set Var_Sentencia = CONCAT(Var_sentencia,' and Seg.FechaInicio >= "', convert(Par_FechaInicio,char),  '" ');
    set Var_Sentencia = CONCAT(Var_sentencia,' and Seg.FechaInicio <= "', convert(Par_FechaFin,char),  '" ');
end if;


set Var_Sentencia :=  CONCAT(Var_Sentencia,' group by Seg.SeguroClienteID, Cli.ClienteID, Cli.NombreCompleto, Seg.FechaVencimiento, Seg.Estatus, Mov.Fecha, Cli.SucursalOrigen, Suc.NombreSucurs, Cli.PromotorActual, prom.NombrePromotor');


set Var_Sentencia :=  CONCAT(Var_Sentencia,' order by Cli.SucursalOrigen, Cli.PromotorActual ');
--  select Var_Sentencia;
SET @Sentencia	= (Var_Sentencia);

PREPARE CTESEGUROREP FROM @Sentencia;
EXECUTE CTESEGUROREP;
DEALLOCATE PREPARE CTESEGUROREP;

END TerminaStore$$
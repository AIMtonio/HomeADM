-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEASCREDITOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEASCREDITOREP`;
DELIMITER $$

CREATE PROCEDURE `LINEASCREDITOREP`(
	Par_FechaInicio			date,
	Par_FechaFin 			date,
	Par_LineaCreditoID      bigint(20),
	Par_ClienteID           int(11),
    Par_ProductoCreditoID   int(11),
    Par_SucursalID          int(11),
	Par_Estatus         	char(2),
	Par_NumReporte			tinyint unsigned,

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)

	)
TerminaStore: BEGIN


DECLARE Var_Sentencia       varchar(6000);
DECLARE FechaSistema        date;


DECLARE Cadena_Vacia		char(1);
DECLARE Entero_Cero         int;
DECLARE Rep_Principal  		int(11);
DECLARE Rep_Creditos  		int(11);


Set Cadena_Vacia          := '';
Set	Entero_Cero           := 0;
Set Rep_Principal   	  := 1;
Set Rep_Creditos          := 2;

set FechaSistema := (Select FechaSistema from PARAMETROSSIS);


if(Par_NumReporte = Rep_Principal) then
set Var_Sentencia :=' select Lin.LineaCreditoID,Lin.CuentaID,Lin.FolioContrato, Lin.FechaInicio, Lin.FechaVencimiento, ';
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'Lin.Solicitado,Lin.Autorizado,Lin.Dispuesto,Lin.Pagado,Lin.SaldoDisponible, ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'Lin.SaldoDeudor,NumeroCreditos,Lin.ClienteID, Cli.NombreCompleto, ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'Lin.SucursalID,Suc.NombreSucurs, Lin.ProductoCreditoID,Pro.Descripcion, ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'case when Lin.Estatus = "C" THEN "CANCELADO" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Lin.Estatus = "B" then "BLOQUEADO" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Lin.Estatus = "A" then "AUTORIZADO" ');
	set Var_Sentencia :=CONCAT(Var_Sentencia, 'when Lin.Estatus = "I" then "INACTIVO" ELSE "" end as Estatus ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'from LINEASCREDITO Lin ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'inner join CLIENTES Cli on Lin.ClienteID=Cli.ClienteID ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'inner join SUCURSALES Suc on Lin.SucursalID=Suc.SucursalID ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'inner join PRODUCTOSCREDITO Pro on Lin.ProductoCreditoID=Pro.ProducCreditoID ');
    set Var_Sentencia :=CONCAT(Var_Sentencia, 'where Lin.EsAgropecuario = "N" and Lin.FechaInicio between ? and ? ');

if(ifnull(Par_LineaCreditoID, Entero_Cero) != Entero_Cero) then
        set Var_Sentencia :=CONCAT(Var_Sentencia, ' and Lin.LineaCreditoID = ', Par_LineaCreditoID);
    end if;
    if(ifnull(Par_ClienteID, Entero_Cero) != Entero_Cero) then
        set Var_Sentencia :=CONCAT(Var_Sentencia, ' and Lin.ClienteID = ', Par_ClienteID);
    end if;
    if(ifnull(Par_ProductoCreditoID, Entero_Cero) != Entero_Cero) then
        set Var_Sentencia :=CONCAT(Var_Sentencia, ' and Lin.ProductoCreditoID = ', Par_ProductoCreditoID);
    end if;
    if(ifnull(Par_SucursalID, Entero_Cero) != Entero_Cero) then
        set Var_Sentencia :=CONCAT(Var_Sentencia, ' and Lin.SucursalID = ', Par_SucursalID);
    end if;
	set Par_Estatus := ifnull(Par_Estatus,Cadena_Vacia);
		if(Par_Estatus!=Cadena_Vacia)then
		set Var_Sentencia := CONCAT(Var_sentencia,' and Lin.Estatus="',Par_Estatus,'"');
    end if;
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' order by Lin.SucursalID,Lin.ProductoCreditoID,Lin.ClienteID; ');


	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
    SET @FechaFin		= Par_FechaFin;


	PREPARE LINEASCREDITOREP FROM @Sentencia;
    EXECUTE LINEASCREDITOREP USING @FechaInicio, @FechaFin;
    DEALLOCATE PREPARE LINEASCREDITOREP;
 end if;


if(Par_NumReporte = Rep_Creditos) then
select 	LineaCreditoID,		CreditoID,		MontoCredito,
		case 	when Estatus = 'I' then 'INACTIVO'
				when Estatus = 'A' then 'AUTORIZADO'
				when Estatus = 'V' then 'VIGENTE'
				when Estatus = 'P' then 'PAGADO'
				when Estatus = 'C' then 'CANCELADO'
				when Estatus = 'B' then 'VENCIDO'
				when Estatus = 'K' then 'CASTIGADO'
				when Estatus = 'S' then 'SUSPENDIDO'
end Estatus,
		FUNCIONTOTDEUDACRE(CreditoID) as TotalDeuda
    from CREDITOS Cre
where LineaCreditoID=Par_LineaCreditoID;
end if;
END TerminaStore$$
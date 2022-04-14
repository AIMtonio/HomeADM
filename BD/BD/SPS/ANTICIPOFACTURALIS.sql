-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ANTICIPOFACTURALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ANTICIPOFACTURALIS`;DELIMITER $$

CREATE PROCEDURE `ANTICIPOFACTURALIS`(
    Par_NoFactura	       varchar(20),
    Par_ProveedorID	       int(11),

    Par_NumLis              tinyint unsigned,

    Aud_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
	)
TerminaStore:BEGIN


DECLARE listaAnticipos		int;
DECLARE Entero_Cero		    int;
DECLARE Cadena_Vacia	    char(1);
DECLARE Est_Registrado    	char(1);
DECLARE Est_Pagado    	    char(1);
DECLARE Est_Cancelado   	char(1);
DECLARE PagoCheque		   	char(1);
DECLARE PagoSpei		    char(1);
DECLARE PagoElectronica		char(1);
DECLARE PagoTarjeta			char(1);



Set Entero_Cero		    := 0;
Set Cadena_Vacia		:= '';
Set Est_Registrado		:= 'R';
Set Est_Pagado			:= 'P';
Set Est_Cancelado		:= 'C';
Set PagoCheque			:= 'C';
Set PagoSpei			:= 'S';
Set PagoSpei			:= 'B';
Set PagoTarjeta			:= 'T';
set listaAnticipos		:= 2;



if(Par_NumLis=listaAnticipos)then
	select 	NoFactura,AnticipoFactID,FechaAnticipo,
			case when EstatusAnticipo='R' then 'Registrado'
			 when EstatusAnticipo='P' then 'Pagado'
			 when EstatusAnticipo='C' then 'Cancelado'
			end as EstatusAnticipo,
			case when FormaPago='C' then 'Cheque'
			 when FormaPago='S' then 'SPEI'
			 when FormaPago='B' then 'Banca Electronica'
			when FormaPago='T' then 'Tarjeta Empresarial'
			end as FormaPago,
			case EstatusAnticipo
				when 'R' then
					Cadena_Vacia
				else
					FechaCancela end as FechaCancela,
			MontoAnticipo,TotalFactura,SaldoFactura
	from ANTICIPOFACTURA
		where NoFactura=Par_NoFactura
		 and	ProveedorID =  Par_ProveedorID;
end if;
END TerminaStore$$
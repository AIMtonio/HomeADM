-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGCREWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPAGCREWSCON`;
DELIMITER $$


CREATE PROCEDURE `DETALLEPAGCREWSCON`(
	Par_ClienteID			int,
	Par_CreditoID			bigint(12),
	Par_FechaPago		    date,
	Par_FechaExigible		date,
	
	Par_NumCon			tinyint unsigned,
	
	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN


declare	Cadena_Vacia		char(1);
declare	Decimal_Cero		decimal(12,2);
declare	Fecha_Vacia		date;
declare	Entero_Cero		int;
declare	Con_DetPago		int;
declare	Est_Pagado		char(1);


declare	NumErr		 	int(11);
declare	ErrMen			varchar(40);


Set	Cadena_Vacia		:= '';
Set	Decimal_Cero		:= 0.0;
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Est_Pagado		:= 'P';
Set	Con_DetPago		:= 1;



if(Par_NumCon = Con_DetPago) then
	if(ifnull(Par_ClienteID, Entero_Cero))= Entero_Cero then
		set 	NumErr := '001';
		set 	ErrMen := 'El numero de Cliente esta Vacio.';
		select 	Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,		NumErr,
				ErrMen;
	
	else
		set 	NumErr := '000';
		set 	ErrMen := 'Consulta Exitosa';
		
		select ifnull(A.CreditoID,Entero_Cero) as CreditoID,
		    ifnull(A.FechaExigible,Fecha_Vacia) as FechaExigible,
			ifnull(D.FechaPago,Fecha_Vacia) as FechaPago,
			ifnull(D.MontoCapOrd,Decimal_Cero) as MontoCapOrd,
			ifnull(D.MontoCapAtr,Decimal_Cero) as MontoCapAtr,
			ifnull(D.MontoCapVen,Decimal_Cero) as MontoCapVen,
			ifnull(D.MontoIntOrd,Decimal_Cero) as MontoIntOrd,
			ifnull(D.MontoIntAtr,Decimal_Cero) as MontoIntAtr,
			ifnull(D.MontoIntVen,Decimal_Cero) as MontoIntVen,
			ifnull(D.MontoIntMora,Decimal_Cero) as MontoIntMora,
			ifnull(D.MontoIVA,Decimal_Cero) as MontoIVA,
			ifnull(D.MontoComision,Decimal_Cero) as MontoComision,
			ifnull(D.MontoGastoAdmon,Decimal_Cero) as MontoGastoAdmon,
			ifnull(D.FormaPago,Entero_Cero) as FormaPago,
			ifnull(D.MontoIVASeguroCuota,Entero_Cero) as MontoIVASeguroCuota,
			ifnull(D.MontoComAnual,Entero_Cero) as MontoComAnual,
			ifnull(D.MontoComAnualIVA,Entero_Cero) as MontoComAnualIVA,
			ifnull(D.MontoTotPago,Decimal_Cero) as MontoTotPago, NumErr, ErrMen
	
			from  	AMORTICREDITO A,
					DETALLEPAGCRE D
			where A.ClienteID = Par_ClienteID
			and A.ClienteID = D.ClienteID
			and A.CreditoID = Par_CreditoID
			and A.CreditoID = D.CreditoID
			and D.FechaPago = Par_FechaPago
			and A.FechaLiquida = D.FechaPago
			and A.FechaExigible = Par_FechaExigible
			and A.AmortizacionID = D.AmortizacionID

			order by A.CreditoID, A.FechaExigible, D.FechaPago, D.MontoCapOrd, D.MontoCapAtr, 
			D.MontoCapVen, D.MontoIntOrd, D.MontoIntAtr, D.MontoIntVen, D.MontoIntVen,
			D.MontoIntMora, D.MontoIVA,  D.MontoComision, D.MontoGastoAdmon, D.FormaPago, 
			D.MontoIVASeguroCuota, D.MontoComAnual, D.MontoComAnualIVA,D.MontoTotPago;
			
	end if;
end if;


END TerminaStore$$

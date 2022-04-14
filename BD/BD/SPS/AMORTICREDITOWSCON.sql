-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOWSCON`;DELIMITER $$

CREATE PROCEDURE `AMORTICREDITOWSCON`(
	Par_ClienteID			int,
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
			ifnull(D.FechaPago,Fecha_Vacia) as FechaLiquida,
			ifnull(D.MontoTotPago,Decimal_Cero) as PagoAplicado, NumErr, ErrMen
			from  	AMORTICREDITO A,
					DETALLEPAGCRE D
			where A.ClienteID = Par_ClienteID
			and A.ClienteID = D.ClienteID
			and A.Estatus = Est_Pagado
			and A.CreditoID = D.CreditoID
			and A.FechaLiquida = D.FechaPago

			and A.AmortizacionID = D.AmortizacionID
			order by A.CreditoID, D.CreditoID, A.FechaExigible;

	end if;
end if;


END TerminaStore$$
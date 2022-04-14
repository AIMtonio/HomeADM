-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTASOCIOMOVLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTASOCIOMOVLIS`;DELIMITER $$

CREATE PROCEDURE `APORTASOCIOMOVLIS`(
	Par_ClienteID  		int(11),


	Par_NumLis			tinyint unsigned,

	Par_EmpresaID   	int(11),
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint(20)


	)
TerminaStore:BEGIN


DECLARE VarFecha		date;
DECLARE VarMovimiento	char(1);
DECLARE VarDescripcion	varchar(150);
DECLARE VarSaldo		decimal(14,2);
DECLARE VarCantidadMov	decimal(14,2);


DECLARE Nat_Devolucion		char(1);
DECLARE Nat_Aportacion		char(1);
DECLARE Lis_Principal		char(1);

DECLARE	CursorMov  CURSOR FOR
		select 	ASM.Fecha, 	ASM.Tipo, ASM.DescripcionMov, ASM.Monto
			from	APORTASOCIOMOV	ASM
			where	ASM.ClienteID	=	Par_ClienteID
			order by ASM.Fecha, ASM.FechaActual;



set Nat_Devolucion		:='D';
set Nat_Aportacion		:='A';
set Lis_Principal		:=1;

if(Par_NumLis = Lis_Principal) then
Set  	VarSaldo	:= 0;
Create Temporary Table TMPAPORTASOCIOMOV(Fecha date, NatMovimiento char(1), DescripcionMov varchar(150),
							CantidadMov decimal(14,2),   Saldo decimal(14,2));

	Open  CursorMov;
	BEGIN
		declare EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		Loop
			Fetch CursorMov  Into VarFecha, VarMovimiento, VarDescripcion, VarCantidadMov;

			if(VarMovimiento=Nat_Devolucion)then
				Set  	VarSaldo	:= round(round(VarSaldo,2)-round(VarCantidadMov,2),2);
			end if;

			if(VarMovimiento=Nat_Aportacion)then
				Set  	VarSaldo	:= round(round(VarSaldo,2)+round(VarCantidadMov,2),2);
			end if;

			insert into TMPAPORTASOCIOMOV
				values (	VarFecha,	VarMovimiento,	VarDescripcion, VarCantidadMov,	VarSaldo);
		End Loop;
	END;
	Close CursorMov;
	select 	Fecha, 	NatMovimiento, 	DescripcionMov,	FORMAT(CantidadMov,2) as Cantidad,
			FORMAT(Saldo,2) as Saldo
			from TMPAPORTASOCIOMOV;
	Drop Table TMPAPORTASOCIOMOV;
end if;


END TerminaStore$$
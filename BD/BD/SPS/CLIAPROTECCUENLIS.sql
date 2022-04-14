-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPROTECCUENLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPROTECCUENLIS`;DELIMITER $$

CREATE PROCEDURE `CLIAPROTECCUENLIS`(
	Par_ClienteID			int(11),
	Par_NumLis				tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)


	)
TerminaStore:BEGIN

DECLARE Lis_Principal		int;
DECLARE EstatusActivo		int;

set Lis_Principal		:=1;
set EstatusActivo		:='A';

if (Lis_Principal = Par_NumLis)then
 select		CliP.CuentaAhoID,		CliP.ClienteID,
			CA.Etiqueta,			TCTA.Descripcion,
			format(CliP.SaldoCuenta,2) as Saldo,	format(CliP.MonAplicaCuenta,2) as MonAplicaCuenta
        from  CLIAPROTECCUEN CliP
			inner join  CUENTASAHO CA on CA.CuentaAhoID = CliP.CuentaAhoID
			inner join TIPOSCUENTAS TCTA   on CA.TipoCuentaID	= TCTA.TipoCuentaID
			where CA.ClienteID = Par_ClienteID
			and CA.Estatus = EstatusActivo;
end if;

END TerminaStore$$
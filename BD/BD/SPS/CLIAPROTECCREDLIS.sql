-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPROTECCREDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPROTECCREDLIS`;DELIMITER $$

CREATE PROCEDURE `CLIAPROTECCREDLIS`(
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



DECLARE Lis_CreditosProteccion		int;
DECLARE Entero_Cero					int;
DECLARE EstatusVigente				char(1);
DECLARE EstatusVencido				char(1);


set Lis_CreditosProteccion		:=2;
set Entero_Cero					:=0;
set EstatusVigente				:='V';
set EstatusVencido				:='B';

if (Lis_CreditosProteccion = Par_NumLis)then
	select	CliP.ClienteID,								CliP.CreditoID,
			format(CliP.MontoAdeudo,2) as MontoAdeudo,	CliP.Estatus,
			concat(convert(Cre.ProductoCreditoID, char),"  ",Pro.Descripcion) as  ProductoCreditoID,
			format (Cre.MontoCredito,2)as MontoCredito,	Cre.FechaMinistrado,
			format(CliP.MontoAplicaCred, 2) as MontoAplicaCred
		from CLIAPROTECCRED as CliP
			inner join CREDITOS Cre  ON (CliP.CreditoID = Cre.CreditoID)
			left join PRODUCTOSCREDITO Pro	on Cre.ProductoCreditoID =Pro.ProducCreditoID
			where Cre.ClienteID = Par_ClienteID ;
end if;

END TerminaStore$$
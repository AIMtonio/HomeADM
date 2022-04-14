-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRODUCTOSCREDITOWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRODUCTOSCREDITOWSCON`;DELIMITER $$

CREATE PROCEDURE `PRODUCTOSCREDITOWSCON`(
	Par_ProducCreditoID	 int,
	Par_PerfilID		 int,
	Par_NumCon			 tinyint unsigned,

	Par_EmpresaID		 int,
	Aud_Usuario			 int,
	Aud_FechaActual		 DateTime,
	Aud_DireccionIP		 varchar(15),
	Aud_ProgramaID		 varchar(50),
	Aud_Sucursal		 int,
	Aud_NumTransaccion	 bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:=  0 ;
Set	Con_Principal	:=  1 ;

if(Par_NumCon = Con_Principal) then
    select  Descripcion, ForCobroComAper, MontoComXapert,
			0 AS PorcGarLiq, FactorMora, Pbe.DestinoCreditoID,
			ClasificacionDestino
    from PRODUCTOSCREDITO Pro inner join PRODUCTOSCREDITOBE Pbe on Pro.ProducCreditoID=Pbe.ProductoCreditoID
    where  ProducCreditoID = Par_ProducCreditoID and PerfilID=Par_PerfilID ;
end if;

END TerminaStore$$
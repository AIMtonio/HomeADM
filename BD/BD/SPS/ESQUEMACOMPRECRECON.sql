-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACOMPRECRECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACOMPRECRECON`;DELIMITER $$

CREATE PROCEDURE `ESQUEMACOMPRECRECON`(
	Par_ProductoCreditoID	int,
	Par_NumCon	        tinyint unsigned,


	Par_EmpresaID		int,
	Aud_Usuario		int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia	date;
DECLARE	Entero_Cero	int;
DECLARE	Con_Principal	int;




Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero	     	:= 0;
Set	Con_Principal		:= 1;




if(Par_NumCon = Con_Principal) then
	select	ProductoCreditoID, PC.Descripcion,PermiteLiqAntici, CobraComLiqAntici, TipComLiqAntici,
			ComisionLiqAntici,DiasGraciaLiqAntici
    from ESQUEMACOMPRECRE ES,
		 PRODUCTOSCREDITO PC
    where  ES.ProductoCreditoID = Par_ProductoCreditoID
	  and  PC.ProducCreditoID=Par_ProductoCreditoID;
end if;
END TerminaStore$$
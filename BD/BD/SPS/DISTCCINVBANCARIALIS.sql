-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISTCCINVBANCARIALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISTCCINVBANCARIALIS`;DELIMITER $$

CREATE PROCEDURE `DISTCCINVBANCARIALIS`(



	Par_InversionID		int(11),
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint


)
TerminaStore: BEGIN


	DECLARE Lis_Principal	int;


	Set Lis_Principal    := 1;
	if(Par_NumLis = Lis_Principal) then
	    SELECT `InversionID`, 	`CentroCosto`,	cc.`Descripcion` as Nombre_centroCosto,	`Monto`,		`InteresGenerado`,		`ISR`,
				`TotalRecibir`
		FROM `DISTCCINVBANCARIA` as inv
        inner join CENTROCOSTOS as cc on inv.CentroCosto = cc.CentroCostoID
		 WHERE InversionID=Par_InversionID
         order by CentroCosto;
	end if;

END TerminaStore$$
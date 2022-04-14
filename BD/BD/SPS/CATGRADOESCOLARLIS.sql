-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATGRADOESCOLARLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATGRADOESCOLARLIS`;DELIMITER $$

CREATE PROCEDURE `CATGRADOESCOLARLIS`(
	Par_GradoEscolarID		int(11),
	Par_Descripcion			varchar(50),
	Par_NumLis				tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

	)
TerminaStore: BEGIN


	DECLARE     Lis_Principal  int;



	Set	Lis_Principal     := 1;






	if(Par_NumLis = Lis_Principal) then

		select  GradoEscolarID	,Descripcion from CATGRADOESCOLAR;

	end if;

END TerminaStore$$
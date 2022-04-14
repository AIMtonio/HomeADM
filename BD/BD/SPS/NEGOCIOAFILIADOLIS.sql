-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NEGOCIOAFILIADOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `NEGOCIOAFILIADOLIS`;DELIMITER $$

CREATE PROCEDURE `NEGOCIOAFILIADOLIS`(

	Par_RazonSocial 				varchar(200),
	Par_NegocioAfiliadoID			varchar(200),
	Par_NumLis						tinyint unsigned,



	Par_EmpresaID       			int(11),
	Aud_Usuario         			int,
	Aud_FechaActual     			DateTime,
	Aud_DireccionIP     			varchar(15),
	Aud_ProgramaID      			varchar(50),
	Aud_Sucursal        			int,
	Aud_NumTransaccion  			bigint
	)
TerminaStore : BEGIN



DECLARE Lis_Principal			int;
DECLARE Est_Alta				char(1);
DECLARE Lis_Foranea				int(11);

SET Lis_Principal				:=1;
SET Lis_Foranea					:=2;
SET Est_Alta					:='A';

IF(Par_NumLis = Lis_Principal) THEN
	SELECT NegocioAfiliadoID AS NegocioAfiliadoID, RazonSocial AS RazonSocial,NombreContacto AS NombreContacto
		FROM 	NEGOCIOAFILIADO
			WHERE 	RazonSocial like concat ('%',Par_RazonSocial,'%')
			AND Estatus=Est_Alta
	limit 0, 15;
end if;

IF(Par_NumLis = Lis_Foranea) THEN
	SELECT NegocioAfiliadoID ,RazonSocial
		FROM 	NEGOCIOAFILIADO
			WHERE 	NegocioAfiliadoID like concat ('%',Par_NegocioAfiliadoID,'%')
			AND Estatus=Est_Alta
	limit 0, 15;
end if;



END TerminaStore$$
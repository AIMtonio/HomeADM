-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSINSTITUCIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSINSTITUCIONCON`;DELIMITER $$

CREATE PROCEDURE `TIPOSINSTITUCIONCON`(
	Par_EmpresaID		varchar(11),
	Par_NumCon				int,


	Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)
TerminaStore:BEGIN


DECLARE	Cadena_Vacia				char(1);
DECLARE Entero_Cero					int;
DECLARE Con_Principal				int;
DECLARE Con_TipoInstitucion			int;
DECLARE Con_ActivaPromotorCaptacion int;
DECLARE Var_Empresa					int;



Set Cadena_Vacia				:= '';
Set Entero_Cero					:= 0;
Set Var_Empresa	                := 1;
Set Con_TipoInstitucion			:= 8;


if(Par_NumCon = Con_TipoInstitucion)then


	 SELECT
	 CASE tip.NombreCorto
		WHEN 'sofipo'   THEN 1
		WHEN 'scap'		THEN 1 ELSE 0 END as AplicaPromotor
	FROM PARAMETROSSIS ps
	INNER JOIN INSTITUCIONES ins ON ps.InstitucionID = ins.InstitucionID
	INNER JOIN TIPOSINSTITUCION tip ON ins.TipoInstitID = tip.TipoInstitID;

end if;



END TerminaStore$$
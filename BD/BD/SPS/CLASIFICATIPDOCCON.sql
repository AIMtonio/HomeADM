-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICATIPDOCCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFICATIPDOCCON`;DELIMITER $$

CREATE PROCEDURE `CLASIFICATIPDOCCON`(
	Par_ClasTipDocID		int(11),	-- para ClasificaTipDocID
	Par_NumCon			tinyint unsigned,

	Par_EmpresaID 			int(11) ,
	Aud_Usuario			int(11) ,
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11) ,
	Aud_NumTransaccion	bigint(20)

	)
TerminaStore:BEGIN


--  Declaracion de   Constantes
DECLARE Con_Principal		INT(11);
DECLARE Con_Documentos		INT(11);

--   asignacion de Constantes
SET Con_Principal			:= 1;  -- Consulta Principal
SET Con_Documentos			:= 2;  -- Consulta Principal



if(Par_NumCon = Con_Principal) then
	select	ClasificaTipDocID, 	ClasificaDesc, ClasificaTipo,TipoGrupInd,
			GrupoAplica,EsGarantia
		from 	CLASIFICATIPDOC
		where	ClasificaTipDocID 	= Par_ClasTipDocID;
end if;

if(Par_NumCon = Con_Documentos) then
	select	TipoDocumentoID, Descripcion
		from 	TIPOSDOCUMENTOS
		where	TipoDocumentoID 	= Par_ClasTipDocID;
end if;



END TerminaStore$$
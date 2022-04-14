-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICATIPDOCLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFICATIPDOCLIS`;DELIMITER $$

CREATE PROCEDURE `CLASIFICATIPDOCLIS`(

	Par_ClasTipDocID		int(11),
	Par_ClasificaDesc		varchar(50),
	Par_NumLis				int(11),

	Par_EmpresaID			int(11) ,
	Aud_Usuario				int(11) ,
	Aud_FechaActual			datetime,
	Aud_DireccionIP 		varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11) ,
	Aud_NumTransaccion		bigint(20)

	)
TerminaStore:BEGIN

DECLARE Lis_Principal		int;
DECLARE Lis_grid			int;
DECLARE Lis_GridDoc			int;
DECLARE var_DocMesaControl	int(11);
DECLARE Estatus_Activo		CHAR(11);

set Lis_Principal			:=1;
set Lis_grid				:=2;
SET Lis_GridDoc				:=3;		-- Lista para el Grid de Clasificacion
set var_DocMesaControl		:= 9998;
SET Estatus_Activo			:= 'A';		-- Estatus Activo

 if( Par_NumLis = Lis_Principal) then
		select  ClasificaTipDocID, ClasificaDesc
	from	CLASIFICATIPDOC
	where	ClasificaDesc like concat("%", Par_ClasificaDesc, "%")
			and		ClasificaTipDocID <>var_DocMesaControl
			limit	0, 15;
    end if;

 if( Par_NumLis = Lis_grid) then
	select  ClasificaTipDocID, ClasificaDesc, ClasificaTipo,TipoGrupInd,GrupoAplica,EsGarantia
		from	CLASIFICATIPDOC
		where ClasificaTipDocID <>var_DocMesaControl;
    end if;

 IF( Par_NumLis = Lis_GridDoc) THEN
	SELECT  TipoDocumentoID, Descripcion
		FROM	TIPOSDOCUMENTOS
        WHERE Descripcion LIKE concat("%", Par_ClasificaDesc, "%")
			AND Estatus = Estatus_Activo
		LIMIT	0, 15;
 END IF;



END TerminaStore$$
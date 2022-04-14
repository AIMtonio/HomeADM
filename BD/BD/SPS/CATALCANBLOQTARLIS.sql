-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALCANBLOQTARLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATALCANBLOQTARLIS`;DELIMITER $$

CREATE PROCEDURE `CATALCANBLOQTARLIS`(
	Par_NumLis			int(11),

	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN



DECLARE Cadena_Vacia        char(1);
DECLARE Fecha_Vacia         date;
DECLARE Entero_Cero			int(11);
DECLARE Lis_Principal       int(11);
DECLARE Lis_ComboBloq       int(11);
DECLARE Lis_ComboDesbloq    int(11);
DECLARE Lis_ComboCance      int(11);
DECLARE Est_Bloqueo         char(1);
DECLARE Est_Desbloq        	char(11);
DECLARE Est_Cancel         	char(11);
DECLARE Est_Todos			char(1);

Set Cadena_Vacia		:= '';
Set Fecha_Vacia			:= '1900-01-01';
Set Entero_Cero			:= 0;
Set Lis_Principal		:= 1;
Set Lis_ComboBloq   	:= 3;
set Lis_ComboDesbloq  	:= 4;
set Lis_ComboCance    	:= 5;
set Est_Bloqueo       	:= 'B';
set Est_Desbloq       	:= 'D';
set Est_Cancel        	:= 'C';
set Est_Todos			:= 'T';

    if(Par_NumLis = Lis_ComboBloq) then
        select MotCanBloID,Descripcion
            from CATALCANBLOQTAR
			where Tipo = Est_Bloqueo or Tipo = Est_Todos;
    end if;

    if(Par_NumLis = Lis_ComboDesbloq) then
        select MotCanBloID,Descripcion
            from CATALCANBLOQTAR
			where Tipo = Est_Desbloq or Tipo = Est_Todos;
    end if;

    if(Par_NumLis = Lis_ComboCance) then
        select MotCanBloID,Descripcion
            from CATALCANBLOQTAR
			where Tipo = Est_Cancel or Tipo = Est_Todos;
    end if;

END TerminaStore$$
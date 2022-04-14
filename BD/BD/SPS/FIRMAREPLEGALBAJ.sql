-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FIRMAREPLEGALBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `FIRMAREPLEGALBAJ`;DELIMITER $$

CREATE PROCEDURE `FIRMAREPLEGALBAJ`(
Par_RepresentLegal		char(70),
Par_Consecutivo			int,

Par_Salida				char(1),
inout Par_NumErr		int,
inout Par_ErrMen		varchar(400),

Par_EmpresaID			int,
Aud_Usuario				int,
Aud_FechaActual			DateTime,
Aud_DireccionIP			varchar(15),
Aud_ProgramaID			varchar(50),
Aud_Sucursal			int,
Aud_NumTransaccion		bigint
	)
TerminaStore:BEGIN

DECLARE SalidaSI 	char(1);


Set 	SalidaSI 	:='S';

delete from FIRMAREPLEGAL
				where RepresentLegal=Par_RepresentLegal
						and Consecutivo=Par_Consecutivo;

if(Par_Salida = SalidaSI) then
	select '000' as NumErr ,
		  'Archivo Eliminado' as ErrMen,
		  'representLegal' as control,
		  '0' as consecutivo;
else
	Set Par_NumErr := '0';
	Set Par_ErrMen := 'Archivo Eliminado.' ;
end if;

END TerminaStore$$
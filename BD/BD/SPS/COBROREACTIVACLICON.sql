-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROREACTIVACLICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROREACTIVACLICON`;DELIMITER $$

CREATE PROCEDURE `COBROREACTIVACLICON`(
    Par_ClienteID   int(11),

    Par_NumCon      tinyint unsigned,

    Par_EmpresaID			int,
    Aud_Usuario         	int,
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint
	)
TerminaStore: BEGIN


DECLARE	Con_CobroReactivaCli	int;
DECLARE  Est_Pendendiente   char(1);


Set Con_CobroReactivaCli	:= 1;
Set Est_Pendendiente    := 'P';

if(Par_NumCon = Con_CobroReactivaCli) then
	select  Estatus
	from    COBROREACTIVACLI
	where   ClienteID = Par_ClienteID and Estatus = Est_Pendendiente
limit 1 ;
end if;

END TerminaStore$$
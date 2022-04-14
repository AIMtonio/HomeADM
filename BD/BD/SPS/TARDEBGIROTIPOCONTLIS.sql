-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGIROTIPOCONTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBGIROTIPOCONTLIS`;DELIMITER $$

CREATE PROCEDURE `TARDEBGIROTIPOCONTLIS`(
	Par_TipoTarjetaID   int(11),
   Par_ClienteID       int(11),

	Par_NumLis		    tinyint unsigned,

	Par_EmpresaID       int(11),
	Aud_Usuario         int(11),
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),
	Aud_ProgramaID      varchar(50),
	Aud_Sucursal        int(11),
	Aud_NumTransaccion  bigint(20)
	)
TerminaStore:BEGIN


DECLARE listaGiroNegTarDebxContrato	int;

set listaGiroNegTarDebxContrato		:=1;


if(Par_NumLis=listaGiroNegTarDebxContrato)then
        select gir.GiroID,Descripcion from TARDEBGIROTIPOCONT as gir
            inner join TARDEBGIROSNEGISO as gine on gir.GiroID=gine.GiroID
   	                 where TipoTarjetaDebID=Par_TipoTarjetaID and ClienteID= Par_ClienteID;

end if;

END TerminaStore$$
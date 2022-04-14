-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGIROSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBGIROSLIS`;DELIMITER $$

CREATE PROCEDURE `TARDEBGIROSLIS`(
    Par_TarjetaDebID       char(16),

    Par_NumLis              tinyint unsigned,

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
	)
TerminaStore:BEGIN


DECLARE listaGirosTarIndiv	int;
DECLARE Entero_Cero		    int;
DECLARE Cadena_Vacia	    char(1);
DECLARE Est_Activado    	char(1);


Set Entero_Cero		    := 0;
Set Cadena_Vacia		:= '';
set Est_Activado    	:= 'A';
set listaGirosTarIndiv	:= 2;



if(Par_NumLis=listaGirosTarIndiv)then
	select T.TarjetaDebID,Tar.GiroID,Tar.Descripcion
		from TARDEBGIROSNEGISO  Tar
	inner join TARDEBGIROS T ON T.GiroID=Tar.GiroID
		where T.TarjetaDebID=Par_TarjetaDebID
		and Tar.Estatus=Est_Activado;
end if;

END TerminaStore$$
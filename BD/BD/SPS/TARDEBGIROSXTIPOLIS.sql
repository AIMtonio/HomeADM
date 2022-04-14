-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGIROSXTIPOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBGIROSXTIPOLIS`;DELIMITER $$

CREATE PROCEDURE `TARDEBGIROSXTIPOLIS`(
    Par_TipoTarjetaDebID    int(11),

    Par_NumLis              tinyint unsigned,

    Aud_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
	)
TerminaStore:BEGIN


DECLARE listaGirosTipoTar	int;
DECLARE Entero_Cero		    int;
DECLARE Cadena_Vacia	    char(1);
DECLARE Est_Activado    	char(1);


Set Entero_Cero		    := 0;
Set Cadena_Vacia		:= '';
set Est_Activado    	:= 'A';
set listaGirosTipoTar	:= 2;



if(Par_NumLis=listaGirosTipoTar)then
	select T.TipoTarjetaDebID,Tar.GiroID,Tar.Descripcion
		from TARDEBGIROSNEGISO  Tar
	inner join TARDEBGIROSXTIPO T ON T.GiroID=Tar.GiroID
		where T.TipoTarjetaDebID=Par_TipoTarjetaDebID
		 and Tar.Estatus=Est_Activado;
end if;

END TerminaStore$$
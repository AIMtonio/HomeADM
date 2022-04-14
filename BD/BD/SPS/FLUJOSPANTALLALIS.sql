-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FLUJOSPANTALLALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FLUJOSPANTALLALIS`;DELIMITER $$

CREATE PROCEDURE `FLUJOSPANTALLALIS`(
	Par_TipoFlujoID		int(11),
	Par_Identificador	int(11),

	Aud_EmpresaID	int(11),
	Aud_Usuario		int(11),
	Aud_FechaActual	datetime,
	Aud_DireccionIP	varchar(20),
	Aud_ProgramaID	varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion  bigint(20)
	)
TerminaStore: BEGIN
declare Con_TipoFlujoClienteSocio	int;
declare Var_TipoPersonaCliSoc		char(1);
declare Entero_Cero				int;
declare PersonaFisica			char(1);
declare OrdenUno				int;
set Con_TipoFlujoClienteSocio 	:= 1;
set Entero_Cero				:= 0;
set PersonaFisica				:='F';
set OrdenUno					:= 1;

if(Con_TipoFlujoClienteSocio = Par_TipoFlujoID)then
	if ( ifnull(Par_Identificador,Entero_Cero) = Entero_Cero)then
		set Var_TipoPersonaCliSoc := PersonaFisica;
		select Orden, Recurso, Desplegado from FLUJOSPANTALLA
		where TipoFlujoID = Par_TipoFlujoID
		and TipoPersonaID = Var_TipoPersonaCliSoc
		and Orden = OrdenUno;
	else
		select TipoPersona into	Var_TipoPersonaCliSoc from CLIENTES where ClienteID = Par_Identificador;
		set Var_TipoPersonaCliSoc := ifnull(Var_TipoPersonaCliSoc,'');
		select Orden, Recurso, Desplegado from FLUJOSPANTALLA
		where TipoFlujoID = Par_TipoFlujoID
		and TipoPersonaID = Var_TipoPersonaCliSoc;
	end if;


end if;



END TerminaStore$$
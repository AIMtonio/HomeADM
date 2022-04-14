-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLICANCELAENTREGALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLICANCELAENTREGALIS`;DELIMITER $$

CREATE PROCEDURE `CLICANCELAENTREGALIS`(




	Par_ClienteCancelaID	int(11),
	Par_NumLis				tinyint unsigned,
	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			datetime,

	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Lis_PorFolio		int;
DECLARE	Est_Pagado			char(1);
DECLARE	Est_Autorizado		char(1);
DECLARE	Est_PagadoDes		varchar(11);
DECLARE	Est_AutorizadoDes	varchar(11);


DECLARE Var_Sentencia		varchar(9000);
DECLARE	Var_FechaSis		date;
DECLARE	Var_TotalRecibir	decimal(14,2);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Lis_PorFolio		:= 1;
Set Est_Pagado			:= 'P';
Set Est_Autorizado		:= 'A';
Set Est_PagadoDes		:= 'PAGADO';
Set Est_AutorizadoDes	:= 'AUTORIZADO';


if(Par_NumLis = Lis_PorFolio) then
	set Var_TotalRecibir := (select	sum(CantidadRecibir)
								from	CLICANCELAENTREGA
								where	ClienteCancelaID = Par_ClienteCancelaID);

	select	CliCancelaEntregaID,	NombreBeneficiario, Porcentaje, Estatus, ClienteID,
			format(CantidadRecibir,2)as CantidadRecibir,
			format(Var_TotalRecibir,2)as Var_TotalRecibir,
			case Estatus
				when Est_Pagado		then Est_PagadoDes
				when Est_Autorizado	then Est_AutorizadoDes
				else Estatus end EstatusDes
		from	CLICANCELAENTREGA
		where	ClienteCancelaID = Par_ClienteCancelaID
		order by Estatus = Est_Pagado, Estatus =  Est_Autorizado;
end if;


END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSTASASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSTASASCON`;DELIMITER $$

CREATE PROCEDURE `CREDITOSTASASCON`(
	Par_ClienteID			int,
	Par_SucursalID			int,
	Par_ProdCreID			int,
	Par_MontoCred			decimal(12,2),
	Par_NumCon			tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero	decimal(12,2);
DECLARE	Con_Principal	int;
DECLARE	Con_Foranea		int;
DECLARE	Con_TasaCte		int;
DECLARE	SalidaSI		char(1);
DECLARE	SalidaNO		char(1);
DECLARE	CredNuevo		char(1);
DECLARE	CredRenovacion	char(1);
DECLARE	CalifNoAsig		char(1);
DECLARE	EstatusPagado	char(1);



DECLARE	Var_NCreditos	int;
DECLARE	Var_TipoSolic	char(1);



Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;
set	Con_TasaCte		:= 9;
set	SalidaSI		:= 'S';
Set	SalidaNO		:= 'N';
Set	CredNuevo		:= 'N';
Set	CredRenovacion	:= 'R';
Set	CalifNoAsig		:= 'N';
Set	Decimal_Cero	:= 0.0;
Set	EstatusPagado	:= 'P';



if(Par_NumCon = Con_TasaCte) then
	set Var_NCreditos := (select count(CreditoID)
							from CREDITOS
							where	ClienteID 			= Par_ClienteID
							and		ProductoCreditoID 	= Par_ProdCreID
							and		Estatus				= EstatusPagado);

	if(Var_NCreditos >= 1) then
		set Var_TipoSolic := CredRenovacion;
		set Var_NCreditos :=Var_NCreditos+1;
	end if;


	if(Var_NCreditos = Entero_Cero) then
		set Var_TipoSolic := CredNuevo;
		set Var_NCreditos :=Var_NCreditos+1;

	end if;

	select ifnull(TasaFija,Decimal_Cero),	ifnull(SobreTasa,Decimal_Cero)
		from ESQUEMATASAS
		where SucursalID		= 	Par_SucursalID
		and ProductoCreditoID	= 	Par_ProdCreID
 		and Var_NCreditos		>= 	MinCredito
		and Var_NCreditos		<= 	MaxCredito
		and Calificacion		=  	CalifNoAsig
		and Par_MontoCred		>=	MontoInferior
		and Par_MontoCred		<= 	MontoSuperior;


end if;

END TerminaStore$$
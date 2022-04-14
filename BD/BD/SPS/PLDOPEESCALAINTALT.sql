-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEESCALAINTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEESCALAINTALT`;DELIMITER $$

CREATE PROCEDURE `PLDOPEESCALAINTALT`(

	Par_OperProcID		bigint(12),
	Par_NombreProc		varchar(16),
	Par_FechDetec			datetime,
	Par_Sucursal			int,
	Par_Cliente			int,
	Par_MatNRiesgo		char(1),
	Par_MatPeps			char(1),
	Par_MCta3SDecl		char(1),
	Par_MDetDoctos		char(1),
	Par_MatMonto			char(1),
	Par_MatOtro			char(1),
	Par_MatOtroDesc  		varchar(40),
	Par_CFuncionar		int,
	Par_TipResEscID 		char(1),
	Par_CveJustif  		int,
	Par_SolSeguimiento	char(1),
	Par_NotasRevisor 		varchar(1500),
	Par_FechRealiza		datetime,

	Par_Salida			char(1),
	inout	Par_NumErr    int,
	inout	Par_ErrMen    varchar(400),
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN



Declare Var_Resultado	   char(1);



declare	Cadena_Vacia		char(1);
declare	Fecha_Vacia		date;
declare	Entero_Cero		int;
declare	SalidaSI			char(1);
declare	SalidaNO			char(1);



Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	SalidaSI			:= 'S';
Set	SalidaNO			:= 'N';


Insert	into PLDOPEESCALAINT(
							OperProcesoID,		ProcesoEscID,		FechaDeteccion,	SucursalID,		ClienteID,
							MatNivelRiesgo,		MatPeps,			MatCta3SinDecl,	MatDetDoctos,		MatMonto,
							MatchOtro,			MatchOtroDesc,	TipoResultEscID,	SolSeguimiento,
							NotasRevisor,			FechRealizacion,	EmpresaID,		Usuario,			FechaActual,
							DireccionIP,			ProgramaID,		Sucursal,		NumTransaccion)
					values(
							Par_OperProcID,		Par_NombreProc,	Par_FechDetec,	Par_Sucursal,			Par_Cliente,
							Par_MatNRiesgo,		Par_MatPeps,		Par_MCta3SDecl,	Par_MDetDoctos,		Par_MatMonto,
							Par_MatOtro,			Par_MatOtroDesc,	Par_TipResEscID,	Par_SolSeguimiento,	Par_NotasRevisor,
							Par_FechRealiza,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


if(Par_Salida = SalidaSI) then
	Select 0 as NumErr,
	"Solicitud de Escalamiento Interno Agregada" as ErrMen;
end if;

if(Par_Salida = SalidaNO) then
	Set Par_NumErr := 0;
	Set Par_ErrMen := "Solicitud de Escalamiento Interno Agregada";
end if;


END TerminaStore$$
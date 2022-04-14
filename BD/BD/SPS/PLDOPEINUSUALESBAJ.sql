-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINUSUALESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINUSUALESBAJ`;DELIMITER $$

CREATE PROCEDURE `PLDOPEINUSUALESBAJ`(
	Par_OpeInusualID			int(11),
	Par_FolioInterno			int(11),
	Par_FolioSITI				varchar(15),
	Par_UsuarioSITI				varchar(15),
	Par_NombreArchivo			varchar(45),
	Par_TipoBaja				int(11),

	Par_Salida					char(1),
	inout Par_NumErr			int(11),
	inout Par_ErrMen			varchar(400),
	Par_EmpresaID				int(11),
	Aud_Usuario				int(11),
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal				int(11),
	Aud_NumTransaccion		bigint(20)
	)
TerminaStore: BEGIN




DECLARE	Var_FechaSistema			date;
DECLARE	Var_DiasParaEnviar			int(11);
DECLARE	Var_PeriodoReporte			int(11);
DECLARE	Var_OrganoSupervisor		varchar(6);
DECLARE	Var_ClaveCasFim			varchar(6);


DECLARE Cadena_Vacia				char(1);
DECLARE Fecha_Vacia				date;
DECLARE Entero_Cero				int(11);
DECLARE	Str_SI					char(1);
DECLARE	EstatusReportarOperacion	int(11);
DECLARE ClavePersonalInterno			char(2);
DECLARE ClavePersonalExterno			char(2);
DECLARE ClaveSistemaAutomatico		char(2);
DECLARE	ParamVigente				char(1);
DECLARE	ActaConstitutiva			char(1);
DECLARE	RegistroTitularCta			char(2);
DECLARE	TipoRepInusuales			char(1);
DECLARE	InstrumEfectivo			char(2);

DECLARE	TipoEliminaEnviados			int(11);



set	Cadena_Vacia				:= '';
set	Fecha_Vacia				:= '1900-01-01';
set	Entero_Cero				:= 0;
set	Str_SI					:= 'S';
set	EstatusReportarOperacion	:= 3;
set	ClavePersonalInterno		:= '1';
set	ClavePersonalExterno		:= '2';
set	ClaveSistemaAutomatico		:= '3';
set	ParamVigente				:= 'V';
set	ActaConstitutiva			:= 'C';
set	RegistroTitularCta			:= '00';
set	TipoRepInusuales			:= '2';
set	InstrumEfectivo			:= '01';

set	TipoEliminaEnviados			:= 1;




set	Par_NumErr	:= 1;
set	Par_ErrMen	:= Cadena_Vacia;

ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
										"estamos trabajando para resolverla. Disculpe las molestias que ",
										"esto le ocasiona. Ref: SP-PLDOPEINUSUALESBAJ");

				END;

	if(Par_TipoBaja = TipoEliminaEnviados) then
		delete from PLDOPEINUSUALES
		where Estatus = EstatusReportarOperacion
		    and FolioInterno > Entero_Cero;

		set	Par_NumErr	:= Entero_Cero;
		set	Par_ErrMen	:= concat("Operaciones Enviadas fueron dadas de baja con exito");

		if Par_Salida = Str_SI then
			select	'000' as NumErr,
					Par_ErrMen as ErrMen,
					'opeInusualID	' as control,
					Entero_Cero	as consecutivo;
		end if;
		LEAVE ManejoErrores;
	end if;


END ManejoErrores;




END TerminaStore$$
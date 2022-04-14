-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BENEFICIARIOSINVERPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BENEFICIARIOSINVERPRO`;DELIMITER $$

CREATE PROCEDURE `BENEFICIARIOSINVERPRO`(
	Par_InversionID		int(11),
	Par_ClienteID		int(11),

	Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

	Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint


	)
TerminaStore:BEGIN

DECLARE Var_InersionID		int(11);
DECLARE Var_Control			varchar(50);
DECLARE Entero_Cero			int;


DECLARE SalidaSI			char(1);
DECLARE EstatusVigente		char(1);
DECLARE EstatusPagada		char(1);
DECLARE EstatusVencida		char(1);
DECLARE PorpiosInversion	char(1)	;


set SalidaSI			:='S';
set Entero_Cero			:=0;
set EstatusVigente		:='N';
set EstatusPagada		:='P';
set EstatusVencida		:='V';
set PorpiosInversion	:='I';
ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = '999';
			SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
									 'estamos trabajando para resolverla. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-BENEFICIARIOSINVERPRO');
			SET Var_Control = 'sqlException' ;
		END;


	delete from BENEFICIARIOSINVER
			where InversionID = Par_InversionID;
	set Var_InersionID :=(select InversionID from INVERSIONES WHERE ClienteID =Par_ClienteID
												and InversionID <> Par_InversionID
												and Estatus in(EstatusVigente,EstatusPagada, EstatusVencida)
												order by InversionID desc,FechaInicio desc limit 1);

	if(ifnull(Var_InersionID, Entero_Cero)= Entero_Cero)then
			set Par_NumErr = 1;
			set Par_ErrMen = 'El safilocale.cliente no Cuenta con una Inversion Anterior';
			set Var_Control := 'heredarBen';
			LEAVE ManejoErrores;

	end if;

	insert into BENEFICIARIOSINVER (
		BenefInverID,       InversionID,        ClienteID,          Titulo,             PrimerNombre,
		SegundoNombre,      TercerNombre,       PrimerApellido,     SegundoApellido,    FechaNacimiento,
		PaisID,             EstadoID,           EstadoCivil,        Sexo,               CURP,
		RFC,                OcupacionID,        ClavePuestoID,      TipoIdentiID,       NumIdentific,
		FecExIden,          FecVenIden,         TelefonoCasa,       TelefonoCelular,    Correo,
		Domicilio,          TipoRelacionID,     Porcentaje,         NombreCompleto,		EmpresaID,
		Usuario, 			FechaActual,        DireccionIP,        ProgramaID,         Sucursal,
		NumTransaccion
		)
	select	Ben.BenefInverID, 		Par_InversionID,		Ben.ClienteID,			Ben.Titulo,				Ben.PrimerNombre,
			Ben.SegundoNombre,      Ben.TercerNombre,		Ben.PrimerApellido,		Ben.SegundoApellido,    Ben.FechaNacimiento,
			Ben.PaisID,             Ben.EstadoID,           Ben.EstadoCivil,        Ben.Sexo,               Ben.CURP,
			Ben.RFC,                Ben.OcupacionID,        Ben.ClavePuestoID,      Ben.TipoIdentiID,       Ben.NumIdentific,
			Ben.FecExIden,          Ben.FecVenIden,         Ben.TelefonoCasa,       Ben.TelefonoCelular,    Ben.Correo,
			Ben.Domicilio,          Ben.TipoRelacionID,     Ben.Porcentaje,         Ben.NombreCompleto,		Par_EmpresaID,
			Aud_Usuario,            Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion
		From BENEFICIARIOSINVER Ben
			where Ben.InversionID = Var_InersionID;

	if not exists (select *
		from BENEFICIARIOSINVER Ben
			where  Ben.InversionID = Par_InversionID )then

			set Par_NumErr 	:=2;
			set Par_ErrMen	:= 'La Inversion anterior no cuenta con ningun Beneficiario';
			set Var_Control	:='heredarBen';
			LEAVE ManejoErrores;
	end if;
		update INVERSIONES SET
			Beneficiario = PorpiosInversion
			where InversionID = Par_InversionID;

			set Par_NumErr 	:=0;
			set Par_ErrMen	:= 'Beneficiarios Heredados Correctamente';
			set Var_Control	:='beneInverID';

END ManejoErrores;
	if (Par_Salida = SalidaSI) then
		select  convert(Par_NumErr, char) as NumErr,
				Par_ErrMen			 as ErrMen,
				Var_Control			 as control,
				''	 as consecutivo;
	end if;

END TerminaStore$$
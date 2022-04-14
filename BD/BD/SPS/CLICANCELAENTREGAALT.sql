-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLICANCELAENTREGAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLICANCELAENTREGAALT`;DELIMITER $$

CREATE PROCEDURE `CLICANCELAENTREGAALT`(


	Par_ClienteCancelaID	int(11),
	Par_ClienteID			int(11),
	Par_CuentaAhoID			bigint(12),
	Par_PersonaID			int(11),
	Par_ClienteBenID		int(11),

	Par_Parentesco			int(11),
	Par_NombreBeneficiario	varchar(200),
	Par_Porcentaje			decimal(12,2),
	Par_CantidadRecibir		decimal(14,2),
	Par_NombreRecibePago	varchar(200),

    Par_Salida				char(1),
    inout	Par_NumErr 		int,
    inout	Par_ErrMen  	varchar(350),
    Par_EmpresaID			int,
	Aud_Usuario         	int,

    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint
		)
TerminaStore: BEGIN


DECLARE VarCliCancelaEntregaID	int(11);
DECLARE Var_ClienteID			int(11);
DECLARE Var_UsuarioReg			int(11);
DECLARE VarControl				char(50);
DECLARE	Var_Fecha				date;
DECLARE	Var_EstatusDes			varchar(30);
DECLARE	Var_Estatus				char(1);


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Act_Autorizar		int;
DECLARE	Salida_SI       	char(1);
DECLARE	Est_Autorizado		char(1);


Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:= 0;
Set	Act_Autorizar			:= 1;
set Est_Autorizado			:= 'A';
set Salida_SI				:= 'S';


set Par_NumErr  		:= Entero_Cero;
set Par_ErrMen  		:= Cadena_Vacia;
set Aud_FechaActual 	:= now();
set Var_Fecha			:= (select FechaSistema from PARAMETROSSIS);

ManejoErrores:BEGIN



	set VarCliCancelaEntregaID := (select ifnull(Max(CliCancelaEntregaID),Entero_Cero) + 1 from CLICANCELAENTREGA);
	set VarCliCancelaEntregaID := ifnull(VarCliCancelaEntregaID,Entero_Cero);


	insert into CLICANCELAENTREGA (
		CliCancelaEntregaID,	ClienteCancelaID,		ClienteID,				CuentaAhoID,		PersonaID,
		ClienteBenID,			Parentesco,				NombreBeneficiario,		Porcentaje,			CantidadRecibir,
		Estatus,				NombreRecibePago,		EmpresaID,				Usuario,			FechaActual,
		DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
	values (
		VarCliCancelaEntregaID,	Par_ClienteCancelaID,	Par_ClienteID,			Par_CuentaAhoID,	Par_PersonaID,
		Par_ClienteBenID,		Par_Parentesco,			Par_NombreBeneficiario,	Par_Porcentaje,		Par_CantidadRecibir,
		Est_Autorizado,			Par_NombreRecibePago,	Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
		Aud_DireccionIP,   		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	set Par_NumErr  := 000;
	set Par_ErrMen  := concat('Datos Agregados Correctamente: ',convert(VarCliCancelaEntregaID,char));
	set varControl	:= 'clienteCancelaID';


END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Par_ClienteCancelaID AS consecutivo;
end IF;
END TerminaStore$$
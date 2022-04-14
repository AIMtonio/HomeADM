-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SERVIFUNENTREGADOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SERVIFUNENTREGADOALT`;DELIMITER $$

CREATE PROCEDURE `SERVIFUNENTREGADOALT`(
	Par_ServiFunFolioID		int(11),
	Par_ClienteID			int(11),
	Par_NombreCompleto		varchar(200),
	Par_MontoApoyo			decimal(14,2),
	Par_Salida				char(1),

	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(500),
	Par_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,

	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
	)
TerminaStore:BEGIN

DECLARE Var_ServiFunEntregadoID	int(11);
DECLARE Var_Control				char(1);

DECLARE Est_Autorizado			char(1);
DECLARE Entero_Cero				int;
DECLARE Cadena_Vacia			char(1);
DECLARE Fecha_Vacia				date;
DECLARE SalidaSI				char(1);


set Est_Autorizado		:='A';
set Entero_Cero			:=0;
set Cadena_Vacia		:='';
set Fecha_Vacia			:='1900-01-01';
set SalidaSI			:='S';
ManejoErrores:BEGIN


set Aud_FechaActual := now();


call FOLIOSAPLICAACT('SERVIFUNENTREGADO', Var_ServiFunEntregadoID);

insert into SERVIFUNENTREGADO (
	ServiFunEntregadoID,	ServiFunFolioID,	ClienteID,			NombreCompleto,		Estatus,
	CantidadEntregado,		TipoIdentiID,		FolioIdentific,		FechaEntrega,		CajaID,
	SucursalID,				EmpresaID,			Usuario,			FechaActual,		DireccionIP,
	ProgramaID,				Sucursal,			NumTransaccion)
values (
	Var_ServiFunEntregadoID,Par_ServiFunFolioID,Par_ClienteID,		Par_NombreCompleto,	Est_Autorizado,
	Par_MontoApoyo,			Entero_Cero,		Cadena_Vacia,		Fecha_Vacia,		Entero_Cero,
	Entero_Cero,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
		);
set Par_ErrMen 	:=0;
set Par_ErrMen	:=concat('Registro del Folio ',convert( Par_ServiFunFolioID,char), ' Agregado Exitosamente');
END ManejoErrores;
	if (Par_Salida = SalidaSI) then
		select  Par_NumErr as NumErr,
        Par_ErrMen as ErrMen,
        Var_Control as control,
        Par_ServiFunFolioID as consecutivo;
	end if;

END TerminaStore$$
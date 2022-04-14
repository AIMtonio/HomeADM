-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESPBUROCREDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `RESPBUROCREDALT`;DELIMITER $$

CREATE PROCEDURE `RESPBUROCREDALT`(
	Par_PrimerNomb		varchar(50),
	Par_SegundoNomb		varchar(50),
	Par_TercerNomb		varchar(50),
	Par_ApellidoPat		varchar(50),
	Par_ApellidoMat		varchar(50),
	Par_RFC				varchar(13),
	Par_FechaConsul  	datetime,
	Par_EstadoID		int,
	Par_MunicipioID		int,
	Par_Calle			varchar(50),
	Par_NumExterior		char(10),
	Par_NumInterior		char(10),
	Par_Piso			char(10),
	Par_Colonia			varchar(50),
	Par_CP				char(5),
	Par_Lote			char(10),
	Par_Manzana			char(10),
	Par_FechaNac		date,
	Par_Salida			char(1),

	inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint




	)
TerminaStore: BEGIN




DECLARE  Entero_Cero		int;
DECLARE  SalidaSI			char(1);
DECLARE  SalidaNO			char(1);



Set	Entero_Cero		:= 0;
Set SalidaSI		:='S';
Set SalidaNO		:='N';


	INSERT INTO RESPBUROCRED  (
								RFC,				FechaConsulta,		PrimerNombre,		SegundoNombre,		TercerNombre,
								ApellidoPaterno,	ApellidoMaterno,	EstadoID,			MunicipioID,		Calle,
								NumeroExterior,		NumeroInterior,		Piso,				Colonia,			CP,
								Lote,				Manzana,			FechaNacimiento,	EmpresaID,			Usuario,
								FechaActual,		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
						VALUES(
								Par_RFC,			Par_FechaConsul,	Par_PrimerNomb,		Par_SegundoNomb,	Par_TercerNomb,
								Par_ApellidoPat,	Par_ApellidoMat,	Par_EstadoID,		Par_MunicipioID,	Par_Calle,
								Par_NumExterior,	Par_NumInterior,	Par_Piso,			Par_Colonia,		Par_CP,
								Par_Lote,			Par_Manzana,		Par_FechaNac,		Par_EmpresaID,		Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


if(Par_Salida = SalidaSI)then
	select	'000' as NumErr ,
		'Solicitud Enviada: ' as ErrMen,
		'creditoID' as control,
		 Aud_NumTransaccion as consecutivo;
end if;

if(Par_Salida = SalidaNO)then
	set	 Par_NumErr := 0;
	set  Par_ErrMen := 'Solicitud Enviada.';
end if;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDESCOPEPREACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDESCOPEPREACT`;DELIMITER $$

CREATE PROCEDURE `PLDESCOPEPREACT`(
	Par_FolioID                 int(11),
	Par_NumAct					int(11),

	Par_Salida           		char(1),
	inout Par_NumErr     		int,
	inout Par_ErrMen    		varchar(400),

	Aud_EmpresaID				int,
	Aud_Usuario					int,
	Aud_FechaActual				DateTime,
	Aud_DireccionIP				varchar(15),
	Aud_ProgramaID				varchar(50),
	Aud_Sucursal				int,
	Aud_NumTransaccion			bigint
)
TerminaStore: BEGIN


declare	SalidaSI     			char(1);
declare	SalidaNO     			char(1);
declare	varControl   			char(15);
DECLARE Entero_Cero       		int;
DECLARE Decimal_Cero      		decimal(14,2);
DECLARE	Cadena_Vacia			char(1);
DECLARE	Act_Principal			int;
DECLARE Fecha_Vacia				date;
DECLARE EstatusBaja             char(1);


set Entero_Cero 				:=0;
Set Cadena_Vacia				:= '';
set Decimal_Cero 				:=0.00;
Set	SalidaSI    	    		:= 'S';
Set	SalidaNO    	    		:= 'N';
Set	Act_Principal				:= 3;
set Fecha_Vacia    		 		:= '1900-01-01';
set EstatusBaja                 := 'B';


ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-PLDESCOPEPREACT");
				END;

if(ifnull(Par_FolioID, Entero_Cero)) = Entero_Cero then
							set Par_NumErr :='001';
							set Par_ErrMen := 'El Folio esta Vacio';
							set varControl:= 'folioID' ;
							LEAVE ManejoErrores;
						end if;




Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(Par_NumAct = Act_Principal) then

update PLDESCOPEPRE  set
	Estatus   			= EstatusBaja,

	EmpresaID			= Aud_EmpresaID,
	Usuario				= Aud_Usuario,
	FechaActual			= Aud_FechaActual,
	DireccionIP			= Aud_DireccionIP,
	ProgramaID			= Aud_ProgramaID,

	Sucursal			= Aud_Sucursal,
	NumTransaccion 		= Aud_NumTransaccion
where FolioID = Par_FolioID;

set	Par_NumErr := 0;
	set	Par_ErrMen := concat("Folio dado de Baja Exitosamente");
set varControl :='folioID';

end if;

END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            varControl as control,
		    Par_FolioID as consecutivo;
 end if;

END TerminaStore$$
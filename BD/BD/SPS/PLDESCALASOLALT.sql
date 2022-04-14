-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDESCALASOLALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDESCALASOLALT`;DELIMITER $$

CREATE PROCEDURE `PLDESCALASOLALT`(
	Par_FolioID					int(11),
	Par_NivelRiesgoID			int(11),
	Par_Peps					char(1),
	Par_ActuaCuenTer			char(1),
	Par_DudasAutDoc				char(1),
	Par_RolTitular				int(11),
	Par_RolSuplente				int(11),
	Par_FechaVigencia			date,
	Par_Estatus					char(1),

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

DECLARE NumFolioID              int(11);
DECLARE Var_PerVigente          int(11);


declare	SalidaSI     			char(1);
declare	SalidaNO     			char(1);
declare	varControl   			char(15);
DECLARE Entero_Cero       		int;
DECLARE Decimal_Cero      		decimal(14,2);
DECLARE	Cadena_Vacia			char(1);
DECLARE	Entero_Negativo			int;
DECLARE Fecha_Vacia				date;
DECLARE Est_Vigente             char(1);


set Entero_Cero 				:= 0;
Set Cadena_Vacia				:= '';
set Decimal_Cero 				:= 0.00;
Set	SalidaSI    	    		:= 'S';
Set	SalidaNO    	    		:= 'N';
set Fecha_Vacia    		 		:= '1900-01-01';
set Est_Vigente                 := 'V';


ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-PLDESCALASOLALT");
				END;

set Var_PerVigente := (select count(Estatus) from PLDESCALASOL where Estatus = Est_Vigente);

if (Var_PerVigente > Entero_Cero) then
							set Par_NumErr :='001';
							set Par_ErrMen := 'Actualmente existe un periodo vigente';
							set varControl:= 'nivelRiesgoID' ;
							LEAVE ManejoErrores;
						end if;


if(ifnull(Par_NivelRiesgoID, Entero_Cero)) = Entero_Cero then
							set Par_NumErr :='003';
							set Par_ErrMen := 'El Nivel de Riesgo esta Vacio';
							set varControl:= 'nivelRiesgoID' ;
							LEAVE ManejoErrores;
						end if;

if(ifnull(Par_RolTitular, Entero_Cero)) = Entero_Cero then
							set Par_NumErr :='004';
							set Par_ErrMen := 'la moneda mensual esta vacia';
							set varControl:= 'rolTitular' ;
							LEAVE ManejoErrores;
						end if;

if(ifnull(Par_RolSuplente, Entero_Cero)) = Entero_Cero then
							set Par_NumErr :='005';
							set Par_ErrMen := 'El tipo de Instrumento esta vacio';
							set varControl:= 'rolSuplente' ;
							LEAVE ManejoErrores;
						end if;


set NumFolioID:= (select ifnull(Max(FolioID),Entero_Cero) + 1
from PLDESCALASOL);

Set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into PLDESCALASOL(	FolioID,		NivelRiesgoID,		Peps,			ActuaCuenTer,		DudasAutDoc,
							RolTitular,		RolSuplente,		FechaVigencia, 	Estatus,			EmpresaID,
							Usuario,		FechaActual,		DireccionIP,	ProgramaID,			Sucursal,
							NumTransaccion)

				values (NumFolioID,			Par_NivelRiesgoID,	Par_Peps,			Par_ActuaCuenTer,	Par_DudasAutDoc,
						Par_RolTitular,		Par_RolSuplente,	Par_FechaVigencia, 	Par_Estatus,		Aud_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

set	Par_NumErr := 0;
set	Par_ErrMen := concat("Parametros Agregados Exitosamente");
set varControl :='folioID';

END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            varControl as control,
		    NumFolioID as consecutivo;
 end if;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASPASOVENCIDOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASPASOVENCIDOBAJ`;DELIMITER $$

CREATE PROCEDURE `DIASPASOVENCIDOBAJ`(
	Par_ProducCreditoID		int(11),
	Par_Frecuencia			char(1),
	Par_TipoBaja			tinyint unsigned,

	Par_Salida          	char(1),
    inout Par_NumErr    	int,
    inout Par_ErrMen   		varchar(400),

    Par_EmpresaID       	int(11),
    Aud_Usuario         	int(11),
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
	Aud_NumTransaccion  	bigint(20)

	)
TerminaStore:BEGIN

DECLARE Var_Control		varchar(50);


DECLARE BajaProd			int;
DECLARE Cadena_Vacia		char;
DECLARE Entero_Cero			int;
DECLARE SalidaSI			char;

set BajaProd				:=1;
set Cadena_Vacia			:='';
set Entero_Cero				:=0;
set SalidaSI				:='S';
ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-DIASPASOVENCIDOBAJ");
				END;

if (Par_TipoBaja=BajaProd)then

	if (Par_ProducCreditoID=Entero_Cero)then
			set Par_NumErr  := 1;
			set Par_ErrMen  := 'El producto de credito está vacio';
			set Var_Control  := 'producCreditoID' ;
			LEAVE ManejoErrores;
	end if;


	delete from DIASPASOVENCIDO
					where ProducCreditoID = Par_ProducCreditoID;

	set Par_NumErr := 0;
        set Par_ErrMen := concat("Dias para paso a vencido eliminados.");

        if (Par_Salida = SalidaSI) then
            select  convert(Par_NumErr, char(3)) as NumErr,
                    Par_ErrMen as ErrMen,
                    Var_Control as control,
                    Entero_Cero as consecutivo;
        end if;
        LEAVE ManejoErrores;
end if;

END ManejoErrores;

END TerminaStore$$
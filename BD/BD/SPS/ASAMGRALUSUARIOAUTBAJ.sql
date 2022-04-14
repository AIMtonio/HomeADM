-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASAMGRALUSUARIOAUTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASAMGRALUSUARIOAUTBAJ`;DELIMITER $$

CREATE PROCEDURE `ASAMGRALUSUARIOAUTBAJ`(
	Par_EmpresaID		 	int(11),

    Par_Salida          	char(1),
	inout Par_NumErr		int(11),
	inout Par_ErrMen		varchar(400),

    Aud_Usuario				int(11),
	Aud_FechaActual			datetime,
	Aud_DireccionIP			varchar(20),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint(20)
)
TerminaStore: BEGIN



DECLARE Var_Control  	 varchar(200);


DECLARE Entero_Cero     int(11);
DECLARE Decimal_Cero    decimal(12,2);
DECLARE Cadena_Vacia    char(1);
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);


Set Entero_Cero  		:= 0;
Set SalidaSI     		:= 'S';
Set SalidaNO     		:= 'N';
Set Cadena_Vacia 		:='';
Set Decimal_Cero        := 0.0;



ManejoErrores: BEGIN



	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-ASAMGRALUSUARIOAUTBAJ');
				SET Var_Control = 'sqlException' ;
		END;





	delete from ASAMGRALUSUARIOAUT
	where EmpresaID = Par_EmpresaID;

	set Par_NumErr := Entero_Cero;
	set Par_ErrMen := 'Usuarios autorizados Eliminados Exitosamente';

	if(Par_Salida = SalidaSI) then
		select '000' as NumErr,
		Par_ErrMen  as ErrMen,
		'usuarioID' as control,
		Par_EmpresaID as consecutivo;
	end if;

END ManejoErrores;

END TerminaStore$$
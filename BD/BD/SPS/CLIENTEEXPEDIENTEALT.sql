-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTEEXPEDIENTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTEEXPEDIENTEALT`;DELIMITER $$

CREATE PROCEDURE `CLIENTEEXPEDIENTEALT`(
	Par_ClienteID 			INT(11),

	Par_Salida				char(1),
	inout	Par_NumErr 		int,
	inout	Par_ErrMen  	varchar(350),

	Aud_EmpresaID			int(11),
	Aud_Usuario         	int(11),
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(20),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
	)
TerminaStore:BEGIN


DECLARE Cadena_Vacia		char(1);
DECLARE Entero_Cero			int;
DECLARE Entero_Uno			int;
DECLARE Decimal_Cero		decimal;
DECLARE Fecha_Vacia			DATE;
DECLARE SalidaSI			char(1);
DECLARE SalidaNO			char(1);
DECLARE Par_FechaExp 		DATE;

DECLARE Var_FechaSis		DATE;
DECLARE Var_ClienteID		int(11);


SET Cadena_Vacia		:='';
SET Entero_Cero			:= 0;
SET Entero_Uno			:= 1;
SET Decimal_Cero		:= 0.0;
SET Fecha_Vacia			:='1900-01-01';
SET SalidaSI			:='S';
SET SalidaNO			:='N';


SELECT ClienteID INTO Var_ClienteID
	FROM CLIENTES
		WHERE ClienteID = Par_ClienteID;

SELECT FechaSistema INTO Var_FechaSis
	FROM PARAMETROSSIS;

call TRANSACCIONESPRO(Aud_NumTransaccion);
SET Aud_EmpresaID := IFNULL(Aud_EmpresaID,Entero_Uno);
SET Aud_FechaActual := NOW();
ManejoErrores:BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, ' ,
                                 'estamos trabajando para resolverla. Disculpe las molestias que ',
                                 'esto le ocasiona. Ref: SP-CLIENTEEXPEDIENTEALT');
    END;

if(IFNULL(Par_ClienteID, Entero_Cero) = Entero_Cero)then
		set	Par_NumErr 	:= 001;
		set	Par_ErrMen	:= 'El Cliente esta vacio.';
		LEAVE ManejoErrores;
end if;

if(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero)then
		set	Par_NumErr 	:= 002;
		set	Par_ErrMen	:= 'El Cliente No Existe.';
		LEAVE ManejoErrores;
end if;

SET Par_FechaExp := Var_FechaSis;

INSERT INTO CLIENTEEXPEDIENTE(
	ClienteID, 			FechaExpediente,	EmpresaID,		Usuario,		FechaActual,
    DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion
) VALUES (
	Par_ClienteID, 		Par_FechaExp,		Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
);

set	Par_NumErr 	:= 000;
set	Par_ErrMen	:= concat('Expediente Actualizado correctamente para el Cliente: ', Par_ClienteID);
END ManejoErrores;

if (Par_Salida = SalidaSI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'algoaqui' as control,
			Entero_Cero as consecutivo;
end if;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFLACIONACTUALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INFLACIONACTUALALT`;
DELIMITER $$

CREATE PROCEDURE `INFLACIONACTUALALT`(
	Par_ValorGatAct		decimal(5,2),
	Par_Salida			char(1),

	inout Par_NumErr	int,
	inout Par_ErrMen	varchar(400),
	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE 	Salida_SI		char(1);
DECLARE		Salida_NO		CHAR(1);
DECLARE 	Var_Control     VARCHAR(100);


DECLARE 	Var_InflacionID	bigint(20);
DECLARE 	Var_FechaSis	date;
DECLARE 	Var_Hora		time;
DECLARE 	Var_FechaComp	datetime;

Set			Cadena_Vacia	:= '';
Set			Fecha_Vacia		:= '1900-01-01';
Set			Entero_Cero		:= 0;
Set 		Salida_SI		:= 'S';
SET 		Salida_NO		:= 'N';

Set 		Var_FechaSis	:= (select FechaSistema from PARAMETROSSIS);
Set			Var_Hora		:= now();
Set 		Var_FechaComp	:= concat(Var_FechaSis,' ',Var_Hora);
Set 		Var_InflacionID := 	0;
SET 		Var_Control     := 'valorGatAct';

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr  := 999;
					SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-INFLACIONACTUALALT');
					SET Var_Control := 'sqlException';
			END;

	Set Par_ValorGatAct := ifnull(Par_ValorGatAct,Entero_Cero);
	if(Par_ValorGatAct = Entero_Cero) then
		SET Par_NumErr		:= 02;
		SET Par_ErrMen		:= 'El Valor GAT Actual viene Vacia.';
		SET Var_Control		:= 'valorGatAct';
		LEAVE ManejoErrores;
	end if;

	CALL FOLIOSAPLICAACT('INFLACIONACTUALALT',Var_InflacionID);

	insert into INFLACIONACTUAL(
		InflacionID,	InflacionProy,	FechaActualizacion,		EmpresaID,
		Usuario,		FechaActual,	DireccionIP,			ProgramaID,
		Sucursal,		NumTransaccion
	)values(
		Var_InflacionID,	Par_ValorGatAct,	Var_FechaComp,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion
	);

	-- SE MANDA A LLAMAR AL SP PARA ACTUALIZAR EL GAT DE LAS CUENTAS DE AHORRO
	CALL GENERAGATREALCTA(
			Salida_NO,		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,	Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	Set Par_NumErr := 0;
	Set Par_ErrMen := 'Valor Actualizado Exitosamente';
END ManejoErrores;

	if (Par_Salida = Salida_SI) then
		SELECT  Par_NumErr AS NumErr,
		      Par_ErrMen AS ErrMen,
		      Var_Control AS Control,
		      Entero_Cero AS Consecutivo;
	end if;

END TerminaStore$$
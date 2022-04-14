-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVBANCARIAMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVBANCARIAMOVSALT`;DELIMITER $$

CREATE PROCEDURE `INVBANCARIAMOVSALT`(


	Par_InversionID			int(12),
	Par_NumeroMov			bigint(20),
	Par_Fecha				date,
	Par_NatMovimiento		char(1),
	Par_Cantidad			decimal(14,4),

	Par_Descripcion			varchar(150),
	Par_TipoMovInbID		char(4),
	Par_Moneda				int,
	Par_Salida				char(1),
	inout Par_NumErr		int,

	inout Par_ErrMen		varchar(400),
	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),

	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

)
TerminaStore: BEGIN

	DECLARE Var_Control			varchar(20);
	DECLARE Var_Consecutivo		varchar(20);


	DECLARE Mov_Cantidad		decimal(12,4);
	DECLARE Cadena_Vacia		char(1);
	DECLARE Entero_Cero			int;
	DECLARE Decimal_Cero		decimal(12,2);
	DECLARE Nat_Cargo			char(1);
	DECLARE Nat_Abono			char(1);
	DECLARE Fecha_Vacia			date;
	DECLARE Fecha				date;
	DECLARE Salida_NO			char(1);
	DECLARE Salida_SI			char(1);

	Set Cadena_Vacia			:= '';
	Set Fecha_Vacia				:= '1900-01-01';
	Set Entero_Cero				:= 0;
	Set Decimal_Cero			:= 0.0;
	Set Nat_Cargo				:= 'C';
	Set Nat_Abono				:= 'A';
	Set Salida_NO				:= 'N';
	Set Salida_SI				:= 'S';
	set Var_Consecutivo			:= Entero_Cero;


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, ' ,
									 'estamos trabajando para resolverla. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-INVBANCARIAMOVSALT');
			SET Var_Control = 'sqlException' ;
		END;

		if(ifnull(Par_InversionID, Entero_Cero))= Entero_Cero then
				set Par_NumErr	:= '001';
				set Par_ErrMen	:= 'El numero de Inversion esta vacio.';
				set Var_Control	:= 'inversionID';
				set Var_Consecutivo := concat(Par_InversionID);
				LEAVE ManejoErrores;
		end if;

		if(ifnull(Par_NumeroMov, Entero_Cero))= Entero_Cero then
				set Par_NumErr	:= '002';
				set Par_ErrMen	:= 'El numero de Movimiento esta vacio.';
				set Var_Control	:= 'numeroMov';
			LEAVE ManejoErrores;
		end if;

		if(ifnull(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia then
				set Par_NumErr	:= '003';
				set Par_ErrMen	:= 'La Fecha esta Vacia.';
				set Var_Control	:= 'fecha';
			LEAVE ManejoErrores;
		end if;

		if(ifnull(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia then
				set Par_NumErr	:= '004';
				set Par_ErrMen	:= 'La naturaleza del Movimiento esta vacia.';
				set Var_Control	:= 'natMovimiento';
			LEAVE ManejoErrores;
		end if;

		if(Par_NatMovimiento<>Nat_Cargo)then
			if(Par_NatMovimiento<>Nat_Abono)then
				set Par_NumErr	:= '005';
				set Par_ErrMen	:= 'La naturaleza del Movimiento no es correcta.';
				set Var_Control	:= 'natMovimiento';
				set Var_Consecutivo := concat(Par_InversionID);
				LEAVE ManejoErrores;
			end if;
		end if;

		if(Par_NatMovimiento<>Nat_Abono)then
			if(Par_NatMovimiento<>Nat_Cargo)then
					set Par_NumErr	:= '005';
					set Par_ErrMen	:= 'La naturaleza del Movimiento no es correcta.';
					set Var_Control	:= 'natMovimiento';
					set Var_Consecutivo := concat(Par_InversionID);
				LEAVE ManejoErrores;
			end if;
		end if;

		if(ifnull(Par_Cantidad, Decimal_Cero))= Decimal_Cero then
				set Par_NumErr	:= '008';
				set Par_ErrMen	:= 'La Cantidad esta Vacia.';
				set Var_Control	:= 'cantidadMov';
				set Var_Consecutivo := concat(Par_InversionID);
			LEAVE ManejoErrores;
		end if;

		if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
				set Par_NumErr	:= '009';
				set Par_ErrMen	:= 'La Descripcion del Movimiento esta vacia.';
				set Var_Control	:= 'descripcionMov';
				set Var_Consecutivo := concat(Par_InversionID);
			LEAVE ManejoErrores;
		end if;

		if(ifnull(Par_TipoMovInbID, Cadena_Vacia)) = Cadena_Vacia then
				set Par_NumErr		:= '010';
				set Par_ErrMen		:= 'El Tipo de Movimiento esta vacio.';
				set Var_Control		:= 'tipoMovInbID';
				set Var_Consecutivo := concat(Par_InversionID);
			LEAVE ManejoErrores;
		end if;

		INSERT INVBANCARIAMOVS VALUES(
			Par_InversionID,	Par_NumeroMov,		Par_Fecha,		Par_NatMovimiento,	Par_Cantidad,
			Par_Descripcion,	Par_TipoMovInbID,	 Par_Moneda,	 Aud_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, Aud_Sucursal,		 Aud_NumTransaccion);
		set 	Par_NumErr := 0;
		set	Par_ErrMen := 'Movimiento Registrado';
		set Var_Control	:= 'inversionID';
		set Var_Consecutivo := concat(Par_InversionID);
	END ManejoErrores;

	if(Par_Salida = Salida_SI) then
		select	convert(Par_NumErr, char(3)) as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				Var_Consecutivo as consecutivo;
	end if;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISTCCINVBANCARIAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISTCCINVBANCARIAALT`;
DELIMITER $$


CREATE PROCEDURE `DISTCCINVBANCARIAALT`(



	Par_InversionID			int(11),
	Par_CentroCostoID		int(11),
	Par_Monto				decimal(14,2),
	Par_TasaISR				decimal(12,4),
	Par_InteresGenerado		decimal(12,4),

	Par_TotalRecibir		decimal(14,2),
	Par_Salida				char(1),
	inout Par_NumErr		int(11),
	inout Par_ErrMen		varchar(400),
	Par_EmpresaID			int(11),

	Aud_Usuario				int(11),
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,

	Aud_NumTransaccion		bigint


)

TerminaStore:BEGIN

	DECLARE Var_InversionID			int(11);
	DECLARE Var_Estatus 			char(1);
	DECLARE Var_CentroCostoID		int(11);
	DECLARE Var_Control				char(30);


	DECLARE	Cadena_Vacia			char(1);
	DECLARE	Fecha_Vacia				datetime;
	DECLARE	Entero_Cero				int;
	DECLARE Decimal_Cero			float;
	DECLARE Estatus_Activa			char(1);
	DECLARE Estatus_Pagada			char(1);
	DECLARE Estatus_Cancelada		char(1);
	DECLARE SalidaNO				char(1);
	DECLARE SalidaSI				char(1);


	Set	Cadena_Vacia				:= '';
	Set	Fecha_Vacia					:= '1900-01-01 00:00:00';
	Set	Entero_Cero					:= 0;
	Set Decimal_Cero				:= 0.0;
	Set Estatus_Activa				:= 'A';
	Set Estatus_Pagada				:= 'P';
	Set Estatus_Cancelada			:= 'C';
	SET SalidaSI					:= 'S';
	SET SalidaNO					:= 'N';


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			set Par_NumErr = 999;
			set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
									 "estamos trabajando para resolverla. Disculpe las molestias que ",
									 "esto le ocasiona. Ref: SP-DISTCCINVBANCARIAALT");
		END;

		Set Par_NumErr	:= Entero_Cero;
		Set Par_ErrMen	:= Cadena_Vacia;
		Set Aud_FechaActual := CURRENT_TIMESTAMP();




		IF NOT EXISTS( SELECT InversionID FROM INVBANCARIA	WHERE InversionID=Par_InversionID) THEN
				Set Par_NumErr	:= 1;
				Set Par_ErrMen	:= 'No existe la inversion';
 				Set Var_Control	:= 'InversionID';
			LEAVE ManejoErrores;
			else
				SELECT InversionID, Estatus into Var_InversionID, Var_Estatus FROM INVBANCARIA	WHERE InversionID=Par_InversionID;
		end if;
		if(ifnull(Var_Estatus, Cadena_Vacia))= Cadena_Vacia then
				Set Par_NumErr	:= 2;
				Set Par_ErrMen	:= 'La Inversion no tiene un Estatus';
 				Set Var_Control	:= 'InversionID';
			LEAVE ManejoErrores;
		end if;
		if(Var_Estatus= Estatus_Pagada) then
				Set Par_NumErr	:= 3;
				Set Par_ErrMen	:= 'La Inversion Ya Se Encuentra Pagada';
 				Set Var_Control	:= 'InversionID';
			LEAVE ManejoErrores;
		end if;
		if(Var_Estatus= Estatus_Cancelada) then
				Set Par_NumErr	:= 4;
				Set Par_ErrMen	:= 'La Inversion Se Encuentra Cancelada';
 				Set Var_Control	:= 'InversionID';
			LEAVE ManejoErrores;
		end if;
		IF NOT EXISTS( SELECT CentroCostoID FROM CENTROCOSTOS WHERE CentroCostoID=Par_CentroCostoID) THEN

				Set Par_NumErr	:= 5;
				Set Par_ErrMen	:= 'No existe el Centro de Costos';
 				Set Var_Control	:= 'InversionID';
			LEAVE ManejoErrores;
		end if;
		if(ifnull(Par_Monto, Decimal_Cero))= Decimal_Cero then
				Set Par_NumErr	:= 6;
				Set Par_ErrMen	:= 'El Monto viene Vacio';
 				Set Var_Control	:= 'InversionID';
			LEAVE ManejoErrores;
		end if;

		if(ifnull(Par_InteresGenerado, Decimal_Cero))= Decimal_Cero then
				Set Par_NumErr	:= 7;
				Set Par_ErrMen	:= 'El Interes Generado Viene Vacio';
 				Set Var_Control	:= 'InversionID';
			LEAVE ManejoErrores;
		end if;
		if(ifnull(Par_TotalRecibir, Decimal_Cero))= Decimal_Cero then
				Set Par_NumErr	:= 8;
				Set Par_ErrMen	:= 'El Total a Recibir Viene Vacio';
 				Set Var_Control	:= 'InversionID';
			LEAVE ManejoErrores;
		end if;
		INSERT INTO `DISTCCINVBANCARIA`
			(`InversionID`,			`CentroCosto`,		`Monto`,		`InteresGenerado`,		SalIntProvisionCC,
			`ISR`,					`TotalRecibir`,		`EmpresaID`,	`Usuario`,				`FechaActual`,
			`DireccionIP`,			`ProgramaID`, 		`Sucursal`,		`NumTransaccion`)
			VALUES
			(Par_InversionID,		Par_CentroCostoID,	Par_Monto,		Par_InteresGenerado,	Decimal_Cero,
			Par_TasaISR,			Par_TotalRecibir,	Par_EmpresaID,	Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);


		Set Par_NumErr	:= 0;
		Set Par_ErrMen	:= concat('Agregada Exitosamente la Distribucion por Centro de Costo de la Inversion Bancaria: ', Par_InversionID);
 		Set Var_Control	:= 'InversionID';

	END ManejoErrores;

	 IF(Par_Salida =SalidaSI) THEN
	select	convert(Par_NumErr, char(3)) as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				'' as consecutivo;
	 END IF;
END TerminaStore$$
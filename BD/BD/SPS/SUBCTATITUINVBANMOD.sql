-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATITUINVBANMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATITUINVBANMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTATITUINVBANMOD`(


	Par_ConceptoInvBanID	int(11),
	Par_TituNegocio			varchar(6),
	Par_TituDispVenta		varchar(6),
	Par_TituConsVenc		varchar(6),
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

	DECLARE 	Var_Control			char(30);
	DECLARE 	Var_Consecutivo		char(6);


	DECLARE		Cadena_Vacia		char(1);
	DECLARE		Entero_Cero			int;
	DECLARE		Float_Cero			float;
	DECLARE 	SalidaNO			char(1);
	DECLARE 	SalidaSI			char(1);

	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET	Float_Cero			:= 0.0;
	SET SalidaSI			:= 'S';
	SET SalidaNO			:= 'N';


	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, ' ,
									 'estamos trabajando para resolverla. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-SUBCTATITUINVBANMOD');
									  SET Var_Control = 'sqlException' ;
		END;
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= Cadena_Vacia;
		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		 SET Var_Consecutivo := Cadena_Vacia;


		IF(ifnull(Par_ConceptoInvBanID, Entero_Cero))= Entero_Cero then
				Set Par_NumErr	:= '001';
				Set Par_ErrMen	:= 'El Concepto esta Vacio';
				Set Var_Control	:= 'ConceptoInvBanID';
			LEAVE TerminaStore;
		END IF;
		IF NOT EXISTS( SELECT ConceptoInvBanID FROM CONCEPTOSINVBAN 	WHERE ConceptoInvBanID=Par_ConceptoInvBanID) THEN
				Set Par_NumErr	:= '002';
				Set Par_ErrMen	:= 'No Existe el Concepto';
				Set Var_Control	:= 'ConceptoInvBanID';
			LEAVE ManejoErrores;
		end if;

		if(ifnull(Aud_EmpresaID, Entero_Cero))= Entero_Cero then
				Set Par_NumErr	:= '003';
				Set Par_ErrMen	:= 'El Numero de la Empresa viene Vacio';
				SET Var_Control	:= 'TituNegocio';
				SET Var_Consecutivo := Par_TituNegocio;
		end if;


		UPDATE SUBCTATITUINVBAN
		SET
		ConceptoInvBanID 		= Par_ConceptoInvBanID,
		TituNegocio 			= Par_TituNegocio,
		TituDispVenta 			= Par_TituDispVenta,
		TituConsVenc 			= Par_TituConsVenc,
		EmpresaID 				= Aud_EmpresaID,
		Usuario 				= Aud_Usuario,
		FechaActual 			= Aud_FechaActual,
		DireccionIP 			= Aud_DireccionIP,
		ProgramaID 				= Aud_ProgramaID,
		Sucursal 				= Aud_Sucursal,
		NumTransaccion 			= Aud_NumTransaccion
		WHERE ConceptoInvBanID 	= Par_ConceptoInvBanID;

		SET Par_NumErr	:= '000';
		SET Par_ErrMen	:= concat('SubCuenta Contable Modificada Exitosamente');
		SET Var_Control	:= 'TituNegocio';
		SET Var_Consecutivo := Par_TituNegocio;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr   as NumErr,
				Par_ErrMen   as ErrMen,
				Var_Control  as control,
				Var_Consecutivo as consecutivo;
	END IF;
END TerminaStore$$
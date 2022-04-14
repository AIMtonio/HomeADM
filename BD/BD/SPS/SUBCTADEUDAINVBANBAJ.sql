-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTADEUDAINVBANBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTADEUDAINVBANBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTADEUDAINVBANBAJ`(


	Par_ConceptoInvBanID	int(11),
	Par_Salida				char(1),
	inout Par_NumErr    	int,
	inout Par_ErrMen    	varchar(400),
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
	DECLARE 	Var_Consecutivo		char(1);


	DECLARE 	Cadena_Vacia		char(1);
	DECLARE 	Entero_Cero			int;
	DECLARE 	SalidaNO        	char(1);
	DECLARE 	SalidaSI        	char(1);

	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET SalidaSI			:= 'S';
	SET SalidaNO			:= 'N';


    ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, ' ,
									 'estamos trabajando para resolverla. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-SUBCTADEUDAINVBANBAJ');
									  SET Var_Control = 'sqlException' ;
		END;
        SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= Cadena_Vacia;
		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		SET Var_Consecutivo := Cadena_Vacia;


		IF(ifnull(Par_ConceptoInvBanID, Entero_Cero))= Entero_Cero then
				Set Par_NumErr	:= '001';
				Set Par_ErrMen	:= 'El Concepto esta Vacío';
 				Set Var_Control	:= 'ConceptoInvBanID';
			LEAVE TerminaStore;
		END IF;

		IF NOT EXISTS( SELECT ConceptoInvBanID FROM SUBCTADEUDAINVBAN 	WHERE ConceptoInvBanID=Par_ConceptoInvBanID) THEN
				Set Par_NumErr	:= '002';
				Set Par_ErrMen	:= 'No Existe la Subcuenta';
 				Set Var_Control	:= 'ConceptoInvBanID';
			LEAVE ManejoErrores;
		end if;


		DELETE
		FROM 		SUBCTADEUDAINVBAN
		where  ConceptoInvBanID 	= Par_ConceptoInvBanID;

		Set Par_NumErr	:= '000';
		SET Par_ErrMen	:= concat('SubCuenta Contable Eliminada Exitosamente');
 		SET Var_Control	:= 'TipoDeuGuber';

	END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT Par_NumErr   as NumErr,
               Par_ErrMen   as ErrMen,
               Var_Control  as control,
			   Var_Consecutivo as consecutivo;
	END IF;
END TerminaStore$$
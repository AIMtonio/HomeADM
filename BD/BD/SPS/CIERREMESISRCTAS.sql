-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERREMESISRCTAS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREMESISRCTAS`;DELIMITER $$

CREATE PROCEDURE `CIERREMESISRCTAS`(

		Par_Salida			CHAR(1),
		INOUT Par_NumErr	INT,
		INOUT Par_ErrMen	VARCHAR(400),

		Aud_EmpresaID		INT,
		Aud_Usuario			INT,

		Aud_FechaActual		DATETIME,
		Aud_DireccionIP		VARCHAR(15),
		Aud_ProgramaID		VARCHAR(50),
		Aud_Sucursal		INT,
		Aud_NumTransaccion	BIGINT
			)
TerminaStore:BEGIN


	DECLARE InstrumentoCta		INT;
	DECLARE SalidaSI			CHAR(1);


	SET InstrumentoCta			:= 2;
	SET SalidaSI				:= 'S';
	ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		set Par_NumErr = 999;
		set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-CIERREMESISRCTAS");
		END;

		INSERT INTO HISCLIENTESISR(
			FechaSistema, 		ClienteID, 			TipoInstrumentoID, 	InstrumentoID, 		SaldoDiario,
			SaldoAcumulado, 	Exedente, 			ISR_dia, 		 	EmpresaID, 			Usuario,
			FechaActual, 		DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
			SELECT 		FechaSistema, 		ClienteID, 			TipoInstrumentoID, 	InstrumentoID, 		SaldoDiario,
						SaldoAcumulado,		Exedente, 			ISR_dia, 			Aud_EmpresaID,		Aud_Usuario,
						Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTESISR
					WHERE TipoInstrumentoID	=	InstrumentoCta;


		DELETE
			FROM CLIENTESISR
				WHERE TipoInstrumentoID	=	InstrumentoCta;
		SET Par_NumErr := 0;
		SET Par_ErrMen := CONCAT("EXITO");

     END ManejoErrores;
	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END if;

END TerminaStore$$
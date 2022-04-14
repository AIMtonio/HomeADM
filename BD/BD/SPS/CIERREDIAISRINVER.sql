-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERREDIAISRINVER
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREDIAISRINVER`;DELIMITER $$

CREATE PROCEDURE `CIERREDIAISRINVER`(

	Par_FecActual			DATETIME,
    Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),

    Aud_EmpresaID			INT,

	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
    Aud_Sucursal			INT,

	Aud_NumTransaccion		BIGINT
		)
TerminaStore: BEGIN


	DECLARE InstrumentoInv   		INT;
	DECLARE Estatus_Pagado  		CHAR(1);
	DECLARE Estatus_Cancelado  		CHAR(1);
    DECLARE Fecha_Vacia				DATE;
	DECLARE SalidaSI				CHAR(1);


	SET InstrumentoInv				:= 13;
	SET Estatus_Pagado				:= 'P';
	SET Estatus_Cancelado			:= 'C';
	SET Fecha_Vacia					:= '1900-01-01';
    SET SalidaSI					:= 'S';
	ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		set Par_NumErr = 999;
		set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-CIERREDIAISRINVER");
		END;


        TRUNCATE 	TMPCLIENTESISRELIM;
        INSERT INTO TMPCLIENTESISRELIM(FechaSistema,ClienteID,TipoInstrumentoID,InstrumentoID)
        SELECT  ISR.FechaSistema,ISR.ClienteID,ISR.TipoInstrumentoID,ISR.InstrumentoID FROM CLIENTESISR ISR INNER JOIN INVERSIONES Inv  ON
						 ISR.ClienteID	 	=Inv.ClienteID
                     AND ISR.InstrumentoID = Inv.InversionID
						WHERE TipoInstrumentoID=InstrumentoInv
							AND	(Inv.Estatus = Estatus_Pagado
							AND DATE(Inv.FechaVencimiento) = DATE(Par_FecActual) )
							OR	(Inv.Estatus = Estatus_Cancelado
							AND IFNULL(DATE(Inv.FechaVenAnt),Fecha_Vacia) = DATE(Par_FecActual)
							AND DATE(Inv.FechaInicio) != DATE(Par_FecActual));

		INSERT INTO HISCLIENTESISR(
			FechaSistema, 		ClienteID, 			TipoInstrumentoID, 		InstrumentoID, 		SaldoDiario,
			SaldoAcumulado, 	Exedente, 			ISR_dia, 		 		EmpresaID, 			Usuario,
			FechaActual, 		DireccionIP,		ProgramaID, 			Sucursal, 			NumTransaccion)

         SELECT  ISR.FechaSistema, 		ISR.ClienteID, 			ISR.TipoInstrumentoID, 		ISR.InstrumentoID, 	ISR.SaldoDiario,
					ISR.SaldoAcumulado,		ISR.Exedente, 			ISR.ISR_dia, 				Aud_EmpresaID,		Aud_Usuario,
					Aud_FechaActual, 		Aud_DireccionIP, 		Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTESISR ISR INNER JOIN INVERSIONES Inv  ON
						 ISR.ClienteID	 	=Inv.ClienteID
                     AND ISR.InstrumentoID = Inv.InversionID
						WHERE TipoInstrumentoID=InstrumentoInv
							AND	(Inv.Estatus = Estatus_Pagado
							AND DATE(Inv.FechaVencimiento) = DATE(Par_FecActual) )
							OR	(Inv.Estatus = Estatus_Cancelado
							AND IFNULL(DATE(Inv.FechaVenAnt),Fecha_Vacia) = DATE(Par_FecActual)
							AND DATE(Inv.FechaInicio) != DATE(Par_FecActual));


		DELETE ISR
			FROM CLIENTESISR ISR,TMPCLIENTESISRELIM CliISR
				WHERE ISR.TipoInstrumentoID=CliISR.TipoInstrumentoID
					AND ISR.InstrumentoID=CliISR.InstrumentoID;

		TRUNCATE 	TMPCLIENTESISRELIM;
		SET Par_NumErr := 0;
		SET Par_ErrMen := concAT("EXITO");
    END ManejoErrores;
	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END if;

END TerminaStore$$
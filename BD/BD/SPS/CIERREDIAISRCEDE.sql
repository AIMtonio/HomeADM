-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERREDIAISRCEDE
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREDIAISRCEDE`;DELIMITER $$

CREATE PROCEDURE `CIERREDIAISRCEDE`(
# ================================================================================
# -------SP QUE BORRA DE LA TABLA SOCIOSISR LOS REGISTROS DE CEDES PAGADAS--------
# ================================================================================
	Par_FecActual			DATETIME,		-- Optenemos la fecha del  Actual del sistema

    Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,			-- PARAMETROS DE SALIDA
	INOUT Par_ErrMen		VARCHAR(400),	-- PARAMETROS DE SALIDA

    Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
    Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE InstrumentoCede   		INT(11);
	DECLARE Estatus_Pagado  		CHAR(1);
	DECLARE Estatus_Cancelado  		CHAR(1);
    DECLARE Fecha_Vacia				DATE;
	DECLARE SalidaSI				CHAR(1);

	-- Asignacion de Constantes
	SET InstrumentoCede				:= 28;		-- Referencia a la tabla TIPOINSTRUMENTOS   para los instrumentos CEDES
	SET Estatus_Pagado				:= 'P';		-- En la tabla inverciones se asigna el estatus P alas inversiones pagadas
	SET Estatus_Cancelado			:= 'C';		-- En la tabla inverciones se asigna el estatus C alas inversiones canceladas
	SET Fecha_Vacia					:= '1900-01-01';-- fecha vacia
    SET SalidaSI					:= 'S';		-- Salida SI

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen	=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										   'esto le ocasiona. Ref: CIERREDIAISRCEDE');
			END;


		TRUNCATE 	TMPCLIENTESISRELIM;
        INSERT INTO TMPCLIENTESISRELIM(FechaSistema,ClienteID,TipoInstrumentoID,InstrumentoID)
		SELECT  	ISR.FechaSistema,ISR.ClienteID,ISR.TipoInstrumentoID,ISR.InstrumentoID
			FROM 	CLIENTESISR ISR
					INNER JOIN CEDES Ced  ON 	ISR.ClienteID	 	= Ced.ClienteID
										  AND 	ISR.InstrumentoID	= Ced.CedeID
			WHERE 	TipoInstrumentoID	= InstrumentoCede
			AND		(Ced.Estatus = Estatus_Pagado	 	AND 	DATE(Ced.FechaVencimiento) = DATE(Par_FecActual))
			OR		(Ced.Estatus = Estatus_Cancelado 	AND 	IFNULL(DATE(Ced.FechaVenAnt),Fecha_Vacia) = DATE(Par_FecActual) AND DATE(Ced.FechaInicio)!= DATE(Par_FecActual));

		-- Insertamos en la tabla historica de SOCIOSISR todos los registros de las inversiones vencidas del dia

		INSERT INTO HISCLIENTESISR(
					FechaSistema, 		ClienteID, 			TipoInstrumentoID, 		InstrumentoID, 		SaldoDiario,
					SaldoAcumulado, 	Exedente, 			ISR_dia, 		 		EmpresaID, 			Usuario,
					FechaActual, 		DireccionIP,		ProgramaID, 			Sucursal, 			NumTransaccion)

         SELECT		ISR.FechaSistema, 	ISR.ClienteID, 		ISR.TipoInstrumentoID, 	ISR.InstrumentoID, 	ISR.SaldoDiario,
					ISR.SaldoAcumulado,	ISR.Exedente, 		ISR.ISR_dia, 			Aud_EmpresaID,		Aud_Usuario,
					Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
			FROM 	CLIENTESISR ISR
					INNER JOIN CEDES Ced  ON	ISR.ClienteID	 	= Ced.ClienteID
										  AND 	ISR.InstrumentoID 	= Ced.CedeID
			WHERE 	TipoInstrumentoID	=	InstrumentoCede
			AND		(Ced.Estatus = Estatus_Pagado		AND 	DATE(Ced.FechaVencimiento) = DATE(Par_FecActual) )
			OR		(Ced.Estatus = Estatus_Cancelado	AND 	IFNULL(DATE(Ced.FechaVenAnt),Fecha_Vacia) = DATE(Par_FecActual) AND DATE(Ced.FechaInicio) != DATE(Par_FecActual));

		-- eliminamos de la tabla SOCIOSISR todos los registros de las CEDES vencidas del dia
		DELETE ISR
			FROM 	CLIENTESISR ISR,TMPCLIENTESISRELIM CliISR
			WHERE 	ISR.TipoInstrumentoID	= CliISR.TipoInstrumentoID
			AND 	ISR.InstrumentoID		= CliISR.InstrumentoID;

		TRUNCATE 	TMPCLIENTESISRELIM;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'EXITO';

    END ManejoErrores;  -- END del Handler de Errores.

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$
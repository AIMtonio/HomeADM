-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAAPORTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZAAPORTALT`;
DELIMITER $$

CREATE PROCEDURE `AMORTIZAAPORTALT`(
# ==================================================================
# ------- SP PARA REGISTAR LAS AMORTIZACIONES DE APORTACIONES-------
# ==================================================================
	Par_AportacionID		INT(11),		-- NÚMERO DE LA APORTACIÓN.
	Par_NumTransSim         BIGINT(20),		-- NÚM. DE SIMULACIÓN.
	Par_MontoAport			DECIMAL(16,2),	-- MONTO DE LA APORTACIÓN.
	Par_Salida              CHAR(1),		-- TIPO DE SALIDA.
	INOUT Par_NumErr        INT(11),		-- NÚMERO DE ERROR.

	INOUT Par_ErrMen        VARCHAR(400),	-- MENSAJE DE ERROR.
	/* Parámetros de Auditoría */
	Par_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),

	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero     INT(11);
	DECLARE VarSi           CHAR(1);
	DECLARE VarNo           CHAR(1);
	DECLARE Est_Vigente     CHAR(1);

	-- Declaracion de variables
	DECLARE VarSumaCapital  DECIMAL(16,2);
	DECLARE VarControl      VARCHAR(100);
    DECLARE Var_Capitaliza	CHAR(1);		-- Almacena si la aportación capitaliza interes

	-- Asignacion de constantes
	SET Entero_Cero     := 0;
	SET VarSi           := 'S';
	SET VarNo           := 'N';
	SET VarControl      := '';
	SET Est_Vigente     := 'N';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:=	999;
			SET Par_ErrMen	:=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: AMORTIZAAPORTALT');
		END;

        -- Se obtiene si la aportacion capitaliza o no interes
        SELECT PagoIntCapitaliza INTO Var_Capitaliza
			FROM APORTACIONES
            WHERE  AportacionID=Par_AportacionID;
		SET Var_Capitaliza := IFNULL(Var_Capitaliza,VarNo);

		SELECT  CASE
					WHEN Var_Capitaliza = VarNo THEN SUM(Capital)
					WHEN Var_Capitaliza = VarSi THEN SUM(Capital)-(SUM(Capital) - Par_MontoAport)
				END 	INTO    VarSumaCapital
			FROM 		TMPSIMULADORAPORT
			WHERE   	NumTransaccion	= Par_NumTransSim
			GROUP BY 	NumTransaccion;

		IF(Par_MontoAport != VarSumaCapital) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'La suma de amortizaciones y el monto de la Aportacion no coinciden.';
			LEAVE ManejoErrores;
		END IF;


		/*SP PARA DAR DE BAJA LAS AMORTIZACIONES DE APORTACIONES*/
		CALL `AMORTIZAAPORTBAJ`(
			Par_AportacionID,	VarNo,              Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
			Aud_NumTransaccion
		);
		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		INSERT INTO AMORTIZAAPORT (
			AportacionID,		AmortizacionID, FechaInicio,    FechaPago,          FechaVencimiento,
			Estatus,        	Capital,        Interes,        InteresRetener,		InteresRetenerRec,	Total,
			Dias,           	SaldoProvision, SaldoCap,		TipoPeriodo,		EmpresaID,
			Usuario,			FechaActual,	DireccionIP,    ProgramaID,     	Sucursal,
            NumTransaccion)
		SELECT
			Par_AportacionID,	Consecutivo,    FechaInicio,    FechaPago,          FechaPago,
			Est_Vigente,    	Capital,        Interes,        ISR,				ISR,				Total,
			Dias,           	Entero_Cero,    SaldoCap,		TipoPeriodo,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion
		FROM TMPSIMULADORAPORT
		WHERE NumTransaccion = Aud_NumTransaccion;


		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Amortizaciones Guardadas Exitosamente.';

	END ManejoErrores;

	IF(Par_Salida =VarSi) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				VarControl AS control,
				Par_AportacionID AS consecutivo;
	END IF;

END TerminaStore$$
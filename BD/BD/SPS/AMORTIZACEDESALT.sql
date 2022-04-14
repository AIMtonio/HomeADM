-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZACEDESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZACEDESALT`;DELIMITER $$

CREATE PROCEDURE `AMORTIZACEDESALT`(
# ==================================================================
# ----------- SP PARA REGISTAR LAS AMORTIZACIONES DE CEDES----------
# ==================================================================
    Par_CedeID              INT(11),
    Par_NumTransSim         BIGINT(20),
    Par_MontoCede           DECIMAL(16,2),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

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

	-- Asignacion de constantes
	SET Entero_Cero     := 0;
	SET VarSi           := 'S';
	SET VarNo           := 'N';
	SET VarControl      := '';
	SET Est_Vigente     := 'N';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	=	999;
			SET Par_ErrMen	=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: AMORTIZACEDESALT');
		END;


		SELECT  SUM(Capital)    INTO    VarSumaCapital
			FROM 		TMPSIMULADORCEDE
			WHERE   	NumTransaccion	= Par_NumTransSim
			GROUP BY 	NumTransaccion;

		IF(Par_MontoCede != VarSumaCapital) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'La suma de amortizaciones y el monto de CEDE no coinciden.';
			LEAVE ManejoErrores;
		END IF;


		/*SP PARA DAR DE BAJA LAS AMORTIZACIONES DE CEDES*/
		CALL `AMORTIZACEDESBAJ`(
			Par_CedeID,     VarNo,              Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
			Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
			Aud_NumTransaccion
		);
		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		INSERT INTO AMORTIZACEDES (
				CedeID,         AmortizacionID, FechaInicio,    FechaPago,          FechaVencimiento,
				Estatus,        Capital,        Interes,        InteresRetener,     Total,
				Dias,           SaldoProvision, EmpresaID,      Usuario,            FechaActual,
				DireccionIP,    ProgramaID,     Sucursal,       NumTransaccion)
		SELECT  Par_CedeID,     Consecutivo,    FechaInicio,    FechaPago,          Fecha,
				Est_Vigente,    Capital,        Interes,        ISR,                Total,
				Dias,           Entero_Cero,    Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
				Aud_DireccionIP,Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
		FROM TMPSIMULADORCEDE
		WHERE NumTransaccion = Aud_NumTransaccion;


		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Amortizaciones Guardadas Exitosamente.';

	END ManejoErrores;

	IF(Par_Salida =VarSi) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				VarControl AS control,
				Par_CedeID AS consecutivo;
	END IF;

END TerminaStore$$
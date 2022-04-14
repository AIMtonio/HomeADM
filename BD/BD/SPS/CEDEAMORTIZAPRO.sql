-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDEAMORTIZAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDEAMORTIZAPRO`;DELIMITER $$

CREATE PROCEDURE `CEDEAMORTIZAPRO`(
# ========================================================
# ----------- SP PARA GENERAR EL PAGARE DE CEDES----------
# ========================================================
    Par_CedeID              INT(11),        	-- ID del cede
    Par_FechaInicio         DATE,               -- Fecha de Inicio del calendario a simular
    Par_FechaVencimiento    DATE,               -- Fecha de Vencimiento del calendario a simular
    Par_Monto               DECIMAL(18,2),      -- Monto con el que se simulara
    Par_ClienteID           INT(11),            -- Valor del Cliente

    Par_TipoCedeID          INT(11),            -- Valor de Tipo de Cede
    Par_TasaFija            DECIMAL(18,4),      -- Valor de Tasa Fija
	Par_TipoPagoInt         CHAR(1),            -- Indica si es a FIN DE MES (F) o al VENCIMIENTO (V) o por PERIODO(P)
	Par_DiasPeriodo			INT(11),			-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	Par_PagoIntCal			CHAR(2),			-- Especifica el tipo de pago de interes D - Devengado, I - Iguales

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
	-- Declaracion de Constantes
	DECLARE Fecha_Vacia		DATE;
	DECLARE Entero_Cero     INT(11);
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE SalidaNO        CHAR(1);
	DECLARE SalidaSI        CHAR(1);
	DECLARE VarControl      VARCHAR(300);

	-- Asignacion de Constantes
	SET Fecha_Vacia     	:= '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero     	:= 0;           	-- Entero en Cero
	SET Cadena_Vacia    	:= '';          	-- String o Cadena Vacia
	SET SalidaNO        	:= 'N';         	-- El store NO Genera Salida
	SET SalidaSI        	:= 'S';         	-- El store SI Genera Salida

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	=  999;
				SET Par_ErrMen  =  CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										  'esto le ocasiona. Ref: SP-CEDEAMORTIZAPRO');
			END;

		/*SP QUE REALIZA LA SIMULACION DE LAS AMORTIZACIONES*/
		CALL CEDESSIMULADORPRO(
			Par_CedeID,         Par_FechaInicio,    Par_FechaVencimiento,   Par_Monto,          Par_ClienteID,
			Par_TipoCedeID,     Par_TasaFija,		Par_TipoPagoInt,		Par_DiasPeriodo,	Par_PagoIntCal,
            Par_Salida,         Par_NumErr,			Par_ErrMen,         	Par_EmpresaID,      Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     	Aud_Sucursal,       Aud_NumTransaccion
		);
		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- VERIFICA QUE NO EXISTE ERROR AL SIMULAR
		IF(Par_NumErr != Entero_Cero ) THEN
			IF(Par_Salida =SalidaSI) THEN
				SELECT  Par_NumErr  AS NumErr,
						Par_ErrMen  AS ErrMen,
						VarControl 	AS control,
						Par_CedeID 	AS consecutivo;
			END IF;
			LEAVE ManejoErrores;
		END IF;


		-- llama al sp que Graba las amortizaciones temporales en la tabla  de amortizaciones definitivas
		CALL AMORTIZACEDESALT(
			Par_CedeID,         Aud_NumTransaccion,     Par_Monto,      SalidaNO,           Par_NumErr,
			Par_ErrMen,         Par_EmpresaID,          Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		/* se limpia la tabla de paso*/
		DELETE FROM TMPSIMULADORCEDE WHERE NumTransaccion = Aud_NumTransaccion;
		-- verIFica que no exista ningun error al dar de alta las amortizaciones
		IF(Par_NumErr != Entero_Cero ) THEN
			IF(Par_Salida =SalidaSI) THEN
				SELECT  Par_NumErr  AS NumErr,
						Par_ErrMen  AS ErrMen,
						VarControl 	AS control,
						Par_CedeID 	AS consecutivo;
			END IF;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr  := 0;
		SET Par_ErrMen  := 'Amortizaciones generadas exitosamente.';

	END ManejoErrores;
		IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr	AS NumErr,
					Par_ErrMen 	AS ErrMen;
		END IF;

END TerminaStore$$
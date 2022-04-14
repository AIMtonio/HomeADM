-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRCALCTBLPAGOSADELANTADOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRCALCTBLPAGOSADELANTADOSPRO`;DELIMITER $$

CREATE PROCEDURE `ARRCALCTBLPAGOSADELANTADOSPRO`(
# =============================================================================================
# -- STORED PROCEDURE PARA PAGOS ADELANTADOS INDICANDO SI SERAN LAS PRIMERAS O ULTIMAS CUOTAS.
# =============================================================================================
	Par_RentasAdelantadas	INT(11),			-- Numero de cuotas que se quieren adelantar.
	Par_Adelanto			CHAR(1),				-- Indica si se adelantaran la primeras o las ultimas cuotas.

	Par_Salida 				CHAR(1),			-- Indica si el sp tendra salida.
	INOUT Par_NumErr		INT(11),			-- Numero de salida que retorna el sp.
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de salida.

	Aud_EmpresaID       	INT(11),			-- Id de la empresa.
	Aud_Usuario         	INT(11),			-- Usuario.
	Aud_FechaActual     	DATETIME,			-- Fecha actual.
	Aud_DireccionIP     	VARCHAR(15),		-- Direccion IP.
	Aud_ProgramaID      	VARCHAR(50),		-- Id del programa.
	Aud_Sucursal        	INT(11),			-- Numero de sucursal.
	Aud_NumTransaccion  	BIGINT(20)			-- Numero de transaccion.
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE	Var_Control			VARCHAR(100);	-- Variable de control.
	DECLARE	Var_PrimerasCuotas	CHAR(1);		-- Constante para indicar que se pagaran las primeras cuotas.
	DECLARE	Var_UltiCuotas		CHAR(1);		-- Constante para indicar que se pagaran las ultimas cuotas.
	DECLARE	Var_Mitad			INT(11);		-- Variable para dividir entre dos
	DECLARE	Var_MaxCuotasPermi	INT(11);		-- Variable para el maximo permitido de cuotas del arrendamiento
	DECLARE	Var_MontoAdelanto	DECIMAL(14,2);	-- Monto total de las cuotas adelantadas.

	-- Declaracion de constantes
	DECLARE	Est_Adelantado		CHAR(1);		-- Estatus Adelantado para arrendamiento.
	DECLARE	Est_Pagado			CHAR(1);		-- Estatus Pagado para arrendamiento.
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena vacia.
	DECLARE	Entero_Cero			INT(11);		-- Entero cero.
	DECLARE	Salida_SI			CHAR(1);		-- Variable si.
	DECLARE	Salida_NO			CHAR(1);		-- Variable no.

	-- Asignacion de constantes
	SET	Var_PrimerasCuotas	:= 'P';				-- Asigna valor para indicar pago de primeras cuotas
	SET	Var_UltiCuotas		:= 'U';				-- Asigna valor para indicar pago de ultimas cuotas
	SET	Var_Mitad			:= 2;				-- Valor dos

	SET	Est_Pagado			:= 'P';				-- Valor de estatus generado
	SET	Est_Adelantado		:= 'A';				-- Valor de estatus anticipado
	SET	Cadena_Vacia		:= '';				-- String Vacio
	SET	Entero_Cero			:= 0;				-- Entero en Cero
	SET	Salida_SI			:= 'S';				-- Valor SI
	SET	Salida_NO			:= 'N';				-- Valor NO

	-- Valores por default si son nulos
	SET Par_RentasAdelantadas	:= IFNULL(Par_RentasAdelantadas,Entero_Cero);
	SET Par_Adelanto			:= IFNULL(Par_Adelanto,Cadena_Vacia);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET	Par_NumErr	:= 999;
				SET	Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ARRCALCTBLPAGOSADELANTADOSPRO');
				SET Var_Control = 'sqlException';
			END;

		IF(Par_RentasAdelantadas = Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El campo de numero rentas que desea adelantar se ecuentra vacio';
			SET Var_Control		:= 'concRentasAdelantadas';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_RentasAdelantadas < Entero_Cero) THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= 'No son permitidos los numeros negativos para indicar las rentas a adelantar';
			SET Var_Control		:= 'concRentasAdelantadas';
			LEAVE ManejoErrores;
		END IF;

		SELECT	COUNT(Tmp_Consecutivo)/Var_Mitad
			INTO	Var_MaxCuotasPermi
			FROM	TMPARRENDAPAGOSIM
			WHERE	NumTransaccion	= Aud_NumTransaccion;

		IF(Par_RentasAdelantadas > Var_MaxCuotasPermi) THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'El Numero de cuotas que desea adelantar sobrepasa el maximo permitido';
			SET Var_Control		:= 'concRentasAdelantadas';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Adelanto = Cadena_Vacia) THEN
			SET Par_NumErr		:= 004;
			SET Par_ErrMen		:= 'No ha indicado la forma de adelanto que se aplicara a las cuotas';
			SET Var_Control		:= 'concRentasAdelantadas';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Adelanto <> Var_PrimerasCuotas) THEN
			IF(Par_Adelanto <> Var_UltiCuotas) THEN
				SET Par_NumErr		:= 005;
				SET Par_ErrMen		:= 'No se reconoce la forma de adelanto de cuotas indicada';
				SET Var_Control		:= 'concRentasAdelantadas';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Actualiza estatus de las primeras cuotas, de acuerdo a lo indicado en Par_RentasAdelantadas
		IF(Par_Adelanto = Var_PrimerasCuotas) THEN
		-- Se asisgna estatus adelantado a las cuotas que se adelantaran
			UPDATE	TMPARRENDAPAGOSIM
				SET	Tmp_Estatus	= Est_Adelantado
			WHERE	NumTransaccion	= Aud_NumTransaccion
			  AND	Tmp_Estatus	<> Est_Pagado
			ORDER	BY	Tmp_Consecutivo ASC
			LIMIT Par_RentasAdelantadas;

		END IF;

		-- Actualiza estatus de las ultimas cuotas, de acuerdo a lo indicado en Par_RentasAdelantadas
		IF(Par_Adelanto = Var_UltiCuotas) THEN
		-- Se asisgna estatus adelantado a las cuotas que se adelantaran
			UPDATE	TMPARRENDAPAGOSIM
				SET	Tmp_Estatus	= Est_Adelantado
			WHERE	NumTransaccion	= Aud_NumTransaccion
			  AND	Tmp_Estatus	<> Est_Pagado
			ORDER	BY	Tmp_Consecutivo DESC
			LIMIT	Par_RentasAdelantadas;

		END IF;


		-- Se suma el total de las cuotas que se adelantaran
		SELECT	SUM(Tmp_PagoTotal)
			INTO	Var_MontoAdelanto
			FROM	TMPARRENDAPAGOSIM
			WHERE	NumTransaccion	= Aud_NumTransaccion
			  AND	Tmp_Estatus		= Est_Adelantado;

		-- Se actualiza el estatus a pagado de las cuotas adelantadas
		UPDATE	TMPARRENDAPAGOSIM
			SET	Tmp_Estatus	= Est_Pagado
			WHERE	NumTransaccion	= Aud_NumTransaccion
			  AND	Tmp_Estatus		= Est_Adelantado;

		SET Par_NumErr		:= '000';
		SET Par_ErrMen		:= CONVERT(Var_MontoAdelanto,CHAR(20));
		SET Var_Control		:= 'arrendaID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$
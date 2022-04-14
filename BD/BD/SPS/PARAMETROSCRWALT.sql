-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSCRWALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSCRWALT`;
DELIMITER $$

CREATE PROCEDURE `PARAMETROSCRWALT`(
	Par_ProductoCreditoID	INT(11),		-- ID del Producto de Crédito.
	Par_FormReten			CHAR(1),		-- Formula de Calculo de Retencion:\n (T) Tasa de ISR sobre el Capital\n (P) Porcentaje Directo Sobre Rendimiento
	Par_TasaISR				DECIMAL(12,4),	-- Tasa de ISR aplicable las Retenciones de los Inversionistas CROWDFUNDING
	Par_PorcISRMora			DECIMAL(12,4),	-- Porcentaje o Tasa de ISR aplicable los Moratorios pagados al cliente
	Par_PorcISRComi			DECIMAL(12,4),	-- Porcentaje o Tasa de ISR aplicable las Comisiones pagadas al cliente

	Par_MinPorFonPr			DECIMAL(10,2),	-- Minimo Porcentaje de Fondeo Propio que debe mantener la institucion sobre el credito
	Par_MaxPorPaCre			DECIMAL(10,2),	-- Maximo Porcentaje de Saldo Pagado del Credito
	Par_MaxDiasAtra			INT(11),		-- Maximo Dias de Atraso Permitidos para Fondear el Credito
	Par_DiasGraPriV			INT(11),		-- Minimo Numero de Dias de Gracias para el 1er Vencimiento
	Par_Salida				CHAR(1),		-- Tipo de Salida.

	INOUT Par_NumErr    	INT(11),		-- Número de Error.
	INOUT Par_ErrMen    	VARCHAR(400),	-- Mensaje de Error.
	/* Parámetros de Auditoría */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	Var_Control		VARCHAR(50);

-- Declaracion de Constantes
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Entero_Cero		INT;
DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE SalidaSI		CHAR(1);
DECLARE SalidaNO		CHAR(1);
DECLARE NumCalPro		INT;

-- Asignación de constantes.
SET Cadena_Vacia	:= '';			-- Constante cadena vacía.
SET Entero_Cero		:= 0;			-- Constante entero cero.
SET Decimal_Cero	:= 0.0;			-- Constante decimal cero.
SET SalidaSI		:= 'S';			-- Constante si.
SET SalidaNO		:= 'N';			-- Constante no.

SET Aud_FechaActual := NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMETROSCRWALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_ProductoCreditoID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Producto de Crédito esta Vacio';
		SET Var_Control:= 'productoCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT * FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCreditoID))THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Producto de Crédito No Existe';
		SET Var_Control:= 'productoCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FormReten, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'La Formula de Calculo de Retencion esta Vacia';
		SET Var_Control:= 'formulaRetencion' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TasaISR, Decimal_Cero)) = Decimal_Cero THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'La Tasa ISR esta Vacia';
		SET Var_Control:= 'tasaISR' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PorcISRMora, Decimal_Cero)) = Decimal_Cero THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'La Tasa ISR Aplicable a Moratorios esta Vacia';
		SET Var_Control:= 'porcISRMoratorio' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PorcISRComi, Decimal_Cero)) = Decimal_Cero THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'La Tasa ISR Aplicable a las Comisiones Pagadas por el Cliente esta Vacia';
		SET Var_Control:= 'porcISRComision' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MaxDiasAtra, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'Maximo Dias de Atraso Permitidos esta Vacio';
		SET Var_Control:= 'maxDiasAtraso' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_DiasGraPriV, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 8;
		SET Par_ErrMen :=  'Minimo Numero de Dias de Gracias para el 1er Vencimiento esta Vacio' ;
		SET Var_Control:= 'diasGraciaPrimVen' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MinPorFonPr, Decimal_Cero)) = Decimal_Cero THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen := 'El Minimo Porcentaje de Fondeo Propio esta Vacio';
		SET Var_Control:= 'minPorcFonProp' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MaxPorPaCre, Decimal_Cero)) = Decimal_Cero THEN
		SET Par_NumErr := 10;
		SET Par_ErrMen := 'El Maximo Porcentaje de Saldo Pagado del Credito esta Vacio';
		SET Var_Control:= 'maxPorcPagCre' ;
		LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual := NOW();

	INSERT PARAMETROSCRW (
		ProductoCreditoID,		FormulaRetencion, 	TasaISR,			PorcISRMoratorio,	PorcISRComision,
		MinPorcFonProp,			MaxPorcPagCre,		MaxDiasAtraso,		DiasGraciaPrimVen,	EmpresaID,
		Usuario,				FechaActual,		DireccionIP, 		ProgramaID,			Sucursal,
		NumTransaccion)
	VALUES (
		Par_ProductoCreditoID,	Par_FormReten,		Par_TasaISR,		Par_PorcISRMora,	Par_PorcISRComi,
		Par_MinPorFonPr,		Par_MaxPorPaCre,	Par_MaxDiasAtra,	Par_DiasGraPriV,	Par_EmpresaID,
		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT('Parametros Crowdfunding Agregados Exitosamente: ',Par_ProductoCreditoID,'.');
	SET Var_Control:= 'productoCreditoID' ;

END ManejoErrores;
	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_ProductoCreditoID AS Consecutivo;
	END IF;
END TerminaStore$$
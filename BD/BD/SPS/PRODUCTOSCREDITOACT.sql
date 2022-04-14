-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRODUCTOSCREDITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRODUCTOSCREDITOACT`;DELIMITER $$

CREATE PROCEDURE `PRODUCTOSCREDITOACT`(
/* SP DE ACTUALIZACION PARA PRODUCTOS DE CREDITO */
	Par_ProducCreditoID 	INT(11),
    Par_TipoAct				TINYINT UNSIGNED,
	Par_CriterComFalPag		VARCHAR(1),
	Par_MontoMinFalPag		DECIMAL(12,2),
	Par_PerCobComFalPag		CHAR(1),

	Par_TipCobComFalPago	CHAR(1),
	Par_ProrrateoComFalPag	CHAR(1),
	Par_TipoPagoComFalPago	CHAR(1),
	Par_Refinanciamiento	CHAR(1),
    Par_Salida              CHAR(1),

    INOUT Par_NumErr		INT(11),
    INOUT Par_ErrMen		VARCHAR(400),
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

-- Declaracion de variables
DECLARE	Var_Control			VARCHAR(20);

-- Declaracion de constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Str_Si				CHAR(1);
DECLARE	Str_No				CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Decimal_Cero		DECIMAL;
DECLARE Tipo_ComFaltPago	INT(11);
DECLARE Tipo_CobraSeguro	INT(11);
DECLARE Tipo_Agropecuario	INT(11);

-- Asignacion de constantes
SET	Cadena_Vacia			:= '';			-- Cadena Vacia
SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
SET	Decimal_Cero			:= 0.0;			-- Decimal Cero
SET Tipo_ComFaltPago		:= 1;			-- Productos Credito Actualizar CriterioComFalPag y MontoIniComFalPAg
SET Tipo_CobraSeguro		:= 2;			-- Productos Credito Actualizar el Cobro de Seguro por Cuota
SET Tipo_Agropecuario		:= 3;			-- Productos Credito Actualizar el Cobro de Seguro por Cuota
SET Str_Si					:= 'S';			-- Constante SI
SET Str_No					:= 'N';			-- Constante NO

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr 	:= 999;
			SET Par_ErrMen 	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PRODUCTOSCREDITOACT');
			SET Var_Control := 'sqlException' ;
		END;

	/* Num. de actualizacion: 1
     * Productos Credito Actualizar CriterioComFalPag y MontoIniComFalPAg */
	IF(Par_TipoAct=Tipo_ComFaltPago)THEN
		UPDATE PRODUCTOSCREDITO SET

			CriterioComFalPag	= Par_CriterComFalPag,
			MontoMinComFalPag	= Par_MontoMinFalPag,
			PerCobComFalPag		= Par_PerCobComFalPag,
			TipCobComFalPago	= Par_TipCobComFalPago,
			ProrrateoComFalPag	= Par_ProrrateoComFalPag,
			TipoPagoComFalPago	= Par_TipoPagoComFalPago,


			EmpresaID			= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion

			WHERE producCreditoID =Par_ProducCreditoID;

		SET Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= CONCAT('Producto de Credito Actualizado Exitosamente: ',CAST(Par_ProducCreditoID AS CHAR));
		SET Var_Control := 'producCreditoID';
		LEAVE ManejoErrores;
	END IF;

	/* Num. de actualizacion: 2
     * Actualiza todos los Productos Credito el Cobro de Seguro por Cuota a NO */
	IF(Par_TipoAct=Tipo_CobraSeguro)THEN
		UPDATE PRODUCTOSCREDITO SET

			CobraSeguroCuota	= Str_No,
			CobraIVASeguroCuota	= Str_No,

			EmpresaID			= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion;

		SET Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= CONCAT('Productos de Credito Actualizados Exitosamente.');
		SET Var_Control := 'producCreditoID';
		LEAVE ManejoErrores;
	END IF;

	/* Num. de actualizacion: 3
     * Actualiza los productos dados de alta/modif. en el módulo Creditos Agro. Todos los productos que vengan de este módulo, son Agro.*/
	IF(Par_TipoAct = Tipo_Agropecuario)THEN

		IF(IFNULL(Par_Refinanciamiento,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr := 31;
			SET Par_ErrMen := 'Producto Agropecuario esta vacio.';
			SET Var_Control:= 'esAgropecuario' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Refinanciamiento,Cadena_Vacia) NOT IN (Str_Si,Str_No))THEN
			SET Par_NumErr := 32;
			SET Par_ErrMen := 'Producto Agropecuario No Es Valido.';
			SET Var_Control:= 'esAgropecuario' ;
			LEAVE ManejoErrores;
		END IF;

		UPDATE PRODUCTOSCREDITO SET

			EsAgropecuario		= Str_Si,
			Refinanciamiento	= Par_Refinanciamiento,

			EmpresaID			= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE ProducCreditoID	= Par_ProducCreditoID;

		SET Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= CONCAT('Productos de Credito Actualizados Exitosamente.');
		SET Var_Control := 'producCreditoID';
		LEAVE ManejoErrores;
	END IF;

END ManejoErrores;

IF(Par_Salida = Str_Si) THEN
    SELECT 	Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Par_ProducCreditoID AS Consecutivo;
END IF;

END TerminaStore$$
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALENDARIOMINISTRAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALENDARIOMINISTRAALT`;DELIMITER $$

CREATE PROCEDURE `CALENDARIOMINISTRAALT`(
/* SP DE ALTA EN EL CATALOGO DE PAISES DE LA GAFI */
	Par_ProductoCreditoID			INT(11),		-- ID del producto de Crédito.
	Par_TomaFechaInhabil			CHAR(1),		-- Indica el tipo de dia habil toma cuando se trata de un día inhabil. S.- Dia Habil Siguiente. A.- Día Habil Anterior.
	Par_PermiteCalIrregular			CHAR(1),		-- Indica si permite o no calendario irregular. S.- Si permite. N.- No permite.
	Par_DiasCancelacion				INT(11),		-- Indica el número de días en el cual se hará la cancelación de la ministración.
	Par_DiasMaxMinistraPosterior	INT(11),		-- Indica el número máximo de días de desembolso posterior a la fecha de ministración.

	Par_Frecuencias					VARCHAR(200),	-- IDs de las frecuencias separadas por comas (,). Corresponde al ID de la tabla CATFRECUENCIAS.
	Par_Plazos						VARCHAR(750),	-- IDs de los plazos separados por comas (,). Corresponde al ID de la tabla CALENDARIOPROD.
	Par_TipoCancelacion				CHAR(1),		-- Tipo de cancelación a aplicar. U.- Últimas cuotas. I.- Cuotas siguientes inmediatas. V.- Prorrateo en cuotas vivas.
	Par_Salida						CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr				INT(11),		-- Numero de Error

	INOUT Par_ErrMen				VARCHAR(400),	-- Mensaje de Error
    /* Parametros de Auditoria */
	Par_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),

	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control     	VARCHAR(50);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	SalidaSI        	CHAR(1);
DECLARE	SalidaNO        	CHAR(1);
DECLARE	ConstSI				CHAR(1);
DECLARE	ConstNO				CHAR(1);
DECLARE	DiaHabilSig			CHAR(1);
DECLARE	DiaHabilAnt			CHAR(1);
DECLARE	TipoCancUltCoutas	CHAR(1);
DECLARE	TipoCancProrrateo	CHAR(1);
DECLARE	TipoCancSigInmed	CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET	ConstSI	        	:= 'S';				-- Constante Si
SET	ConstNO	        	:= 'N'; 			-- Constante No
SET	DiaHabilSig	        := 'S'; 			-- Dia Habil Siguiente
SET	DiaHabilAnt	        := 'A'; 			-- Dia Habil Anterior
SET	TipoCancUltCoutas	:= 'U'; 			-- Tipo de Cancelacion Ultimas cuotas
SET	TipoCancProrrateo	:= 'V'; 			-- Tipo de Cancelacion Prorrateo
SET	TipoCancSigInmed	:= 'I'; 			-- Tipo de Cancelacion Coutas siguientes inmediatas (cuotas vivas)
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CALENDARIOMINISTRAALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL((SELECT EsAgropecuario FROM PRODUCTOSCREDITO WHERE ProducCreditoID=IFNULL(Par_ProductoCreditoID, Entero_Cero)),ConstNO)=ConstNO) THEN
		SET Par_NumErr := 14;
		SET Par_ErrMen := 'El Producto de Credito No es Agropecuario.';
		SET Var_Control:= 'productoCreditoID' ;
		LEAVE ManejoErrores;
    END IF;

	IF(EXISTS(SELECT ProductoCreditoID FROM CALENDARIOMINISTRA WHERE ProductoCreditoID=IFNULL(Par_ProductoCreditoID, Entero_Cero))) THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Producto de Credito Ya Existe.';
		SET Var_Control:= 'productoCreditoID' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_ProductoCreditoID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Producto de Credito esta Vacio.';
		SET Var_Control:= 'productoCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT ProducCreditoID FROM PRODUCTOSCREDITO WHERE ProducCreditoID=IFNULL(Par_ProductoCreditoID, Entero_Cero))) THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'El Producto de Credito No Existe.';
		SET Var_Control:= 'productoCreditoID' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_TomaFechaInhabil,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'La Fecha Inhabil a Tomar esta vacia.';
		SET Var_Control:= 'tomaFechaInhabil' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_TomaFechaInhabil,Cadena_Vacia) NOT IN (DiaHabilSig,DiaHabilAnt))THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'La Fecha Inhabil a Tomar No Es Valida.';
		SET Var_Control:= 'tomaFechaInhabil' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_PermiteCalIrregular,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'Permite Calendario Irregular esta vacio.';
		SET Var_Control:= 'permiteCalIrregular' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_PermiteCalIrregular,Cadena_Vacia) NOT IN (ConstSI,ConstNO))THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'Permite Calendario Irregular No Es Valido.';
		SET Var_Control:= 'permiteCalIrregular' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_DiasCancelacion,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr := 8;
		SET Par_ErrMen := 'Los Dias de Cancelacion estan vacios.';
		SET Var_Control:= 'diasCancelacion' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_DiasMaxMinistraPosterior,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen := 'Los Dias Maximos de Ministracion Posterior estan vacios.';
		SET Var_Control:= 'diasMaxMinistraPosterior' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_Frecuencias,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 10;
		SET Par_ErrMen := 'Las Frecuencias estan vacias.';
		SET Var_Control:= 'frecuencias' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_Plazos,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 11;
		SET Par_ErrMen := 'Los Plazos estan vacios.';
		SET Var_Control:= 'plazos' ;
		LEAVE ManejoErrores;
    END IF;

	IF(LENGTH(REPLACE(Par_Frecuencias,',',Cadena_Vacia))=Entero_Cero)THEN
		SET Par_NumErr := 12;
		SET Par_ErrMen := 'Las Frecuencias estan vacias.';
		SET Var_Control:= 'frecuencias' ;
		LEAVE ManejoErrores;
    END IF;

	IF(LENGTH(REPLACE(Par_Plazos,',',Cadena_Vacia))=Entero_Cero)THEN
		SET Par_NumErr := 13;
		SET Par_ErrMen := 'Los Plazos estan vacios.';
		SET Var_Control:= 'plazos' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_TipoCancelacion,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 14;
		SET Par_ErrMen := 'El Tipo de Cancelacion esta vacio.';
		SET Var_Control:= 'tipoCancelacion' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_TipoCancelacion,Cadena_Vacia) NOT IN (TipoCancProrrateo, TipoCancSigInmed, TipoCancUltCoutas))THEN
		SET Par_NumErr := 15;
		SET Par_ErrMen := 'El Tipo de Cancelacion No es Valido.';
		SET Var_Control:= 'tipoCancelacion' ;
		LEAVE ManejoErrores;
    END IF;

	INSERT INTO CALENDARIOMINISTRA(
		ProductoCreditoID, 		TomaFechaInhabil,		PermiteCalIrregular,		DiasCancelacion,		DiasMaxMinistraPosterior,
		Frecuencias, 			Plazos,					TipoCancelacion,		 	EmpresaID,				Usuario,
		FechaActual,			DireccionIP, 			ProgramaID,					Sucursal,				NumTransaccion
	)VALUES(
		Par_ProductoCreditoID, 	Par_TomaFechaInhabil,	Par_PermiteCalIrregular,	Par_DiasCancelacion,	Par_DiasMaxMinistraPosterior,
		Par_Frecuencias, 		Par_Plazos,				Par_TipoCancelacion,		Par_EmpresaID,			Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP, 		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Calendario de Ministraciones Grabado Exitosamente.';
	SET Var_Control:= 'productoCreditoID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			IFNULL(Par_ProductoCreditoID, Entero_Cero) AS Consecutivo;
END IF;

END TerminaStore$$
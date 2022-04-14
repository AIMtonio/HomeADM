-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEAFONDEADORMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEAFONDEADORMOD`;
DELIMITER $$


CREATE PROCEDURE `LINEAFONDEADORMOD`(
/* SP DE MODIFICACION DE LINEAS DE FONDEO */
	Par_LineaFondeoID		INT(11),
	Par_InstitutFondID		INT(11),
	Par_DescripLinea 		VARCHAR(200),
	Par_TipoLinFondeaID		INT(4),
	Par_MontoOtorgado		DECIMAL(12,2),

	Par_SaldoLinea			DECIMAL(12,2),
	Par_TasaPasiva			DECIMAL(14,4),
	Par_FactorMora			DECIMAL(12,2),
	Par_DiasGraciaMora		INT(11),
	Par_PagoAutoVenci		CHAR(1),

	Par_CobraMoratorios		CHAR(1),
	Par_CobraFaltaPago		CHAR(1),
	Par_DiasGraFaltaPag		INT(11),
	Par_MontoComFaltaPag 	DECIMAL(12,2),
	Par_EsRevolvente		CHAR(1),

	Par_TipoRevolvencia		CHAR(1),
	Par_InstitucionID		INT(11),
	Par_NumCtaInstit      	VARCHAR(20),
	Par_CuentaClabe			VARCHAR(18),
	Par_AfectacionConta     CHAR(1),

	Par_ReqIntegracion		CHAR(1),
	Par_TipoCobroMora		CHAR(1),
	Par_FolioFondeo			VARCHAR(45),
	Par_CalcInteresID		INT(11),						# Tipo de Calculo de Interes
	Par_TasaBase			INT(11),					# Tasa Base para el calculo de Interes Tasa Variable

	Par_Refinanciamiento	CHAR(1),						# Indica si la linea de fondeo permite refinanciamiento
	Par_MonedaID			INT(11),
	Par_Salida    			CHAR(1),
	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen  	VARCHAR(350),
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN
-- Declaracion de variables
DECLARE Var_Control 	VARCHAR(50);
DECLARE Var_Consecutivo	INT(11);
DECLARE Var_Estatus		CHAR(1);

-- declaracion de constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE Salida_SI		CHAR(1);
DECLARE EstatusInac		CHAR(1);

-- asignacion de constantes
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Salida_SI		:= 'S';

SET EstatusInac		:= 'I';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-LINEAFONDEADORMOD');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(NOT EXISTS(SELECT LineaFondeoID
				FROM LINEAFONDEADOR
				WHERE LineaFondeoID = Par_LineaFondeoID)) THEN
		SET Par_NumErr	:=	1;
		SET Par_ErrMen	:=	'La Linea de Fondeo no existe.';
		SET Var_Control	:=	'lineaFondeoID';
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_InstitutFondID,Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr	:=	2;
		SET Par_ErrMen	:=	'La Institucion de Fondeo esta Vacia.';
		SET Var_Control	:=	'institutFondID';
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_DescripLinea, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr	:=	3;
		SET Par_ErrMen	:=	'La Descripcion esta Vacia.';
		SET Var_Control	:=	'descripLinea';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CalcInteresID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr	:= 5;
		SET Par_ErrMen	:= 'El Tipo de Calculo de Interes esta Vacio.';
		SET Var_Control	:= 'calcInteres';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_CalcInteresID!= 1 /*Tasa fija*/ AND IFNULL(Par_TasaBase, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr	:= 6;
		SET Par_ErrMen	:= 'La Tasa Base esta Vacia.';
		SET Var_Control	:= 'tasaBase';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Refinanciamiento, Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr	:= 7;
		SET Par_ErrMen	:= 'El Refinanciamiento esta Vacio.';
		SET Var_Control	:= 'refinanciamiento';
		LEAVE ManejoErrores;
	END IF;
	IF(IFNULL(Par_MonedaID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr	:= 8;
		SET Par_ErrMen	:= 'El numero de la moneda esta Vacio.';
		SET Var_Control	:= 'MonedaID';
		LEAVE ManejoErrores;
	END IF;

	SELECT Estatus
			INTO Var_Estatus
	FROM INSTITUTFONDEO 
	WHERE InstitutFondID = Par_InstitutFondID;
	
	IF(IFNULL(Var_Estatus, Cadena_Vacia) = EstatusInac) THEN
		SET Par_NumErr	:= 9;
		SET Par_ErrMen	:= 'El Instituto de Fondeo se Encuentra Inactivo.';
		SET Var_Control	:= 'institutFondID';
		LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual := NOW();

	UPDATE	LINEAFONDEADOR SET
		InstitutFondID	= Par_InstitutFondID,
		DescripLinea	= Par_DescripLinea,
		TipoLinFondeaID	= Par_TipoLinFondeaID,
		TasaPasiva		= Par_TasaPasiva,
		FactorMora		= Par_FactorMora,

		DiasGraciaMora	= Par_DiasGraciaMora,
		PagoAutoVenci	= Par_PagoAutoVenci,
		CobraMoratorios	= Par_CobraMoratorios,
		CobraFaltaPago	= Par_CobraFaltaPago,
		DiasGraFaltaPag	= Par_DiasGraFaltaPag,

		MontoComFalPag  = Par_MontoComFaltaPag,
		EsRevolvente	= Par_EsRevolvente,
		TipoRevolvencia	= Par_TipoRevolvencia,
		InstitucionID	= Par_InstitucionID,
		NumCtaInstit	= Par_NumCtaInstit,

		CuentaClabe		= Par_CuentaClabe,
		AfectacionConta	= Par_AfectacionConta,
		ReqIntegracion	= Par_ReqIntegracion,
		TipoCobroMora   = Par_TipoCobroMora,
		FolioFondeo		= Par_FolioFondeo,
		CalcInteresID			= Par_CalcInteresID,
		TasaBase		= Par_TasaBase,
		Refinancia		= Par_Refinanciamiento,
		MonedaID		= Par_MonedaID,
		
		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE LineaFondeoID = Par_LineaFondeoID;

	SET Par_NumErr		:=	0;
	SET Par_ErrMen		:=	CONCAT('Linea de Fondeo Modificada: ', CONVERT(Par_LineaFondeoID, CHAR));
	SET Var_Control		:=	'lineaFondeoID';
	SET Var_Consecutivo	:=	Par_LineaFondeoID;

END ManejoErrores;

IF(Par_Salida = Salida_SI) THEN
	SELECT Par_NumErr AS NumErr ,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo ;
END IF;

END TerminaStore$$

-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEAFONDEADORALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEAFONDEADORALT`;
DELIMITER $$


CREATE PROCEDURE `LINEAFONDEADORALT`(
/*SP para el alta de linea de Fondeador*/
	Par_InstitutFondID		INT(11),
	Par_DescripLinea 		VARCHAR(200),
	Par_FechInicLinea		DATE,
	Par_FechaFinLinea		DATE,
	Par_TipoLinFondeaID		INT(4),

	Par_MontoOtorgado		DECIMAL(12,2),
	Par_SaldoLinea			DECIMAL(12,2),
	Par_TasaPasiva			DECIMAL(14,4),
	Par_FactorMora			DECIMAL(12,2),
	Par_DiasGraciaMora		INT(11),

	Par_PagoAutoVenci		CHAR(1),
	Par_FechaMaxVenci		DATE,
	Par_CobraMoratorios		CHAR(1),
	Par_CobraFaltaPago		CHAR(1),
	Par_DiasGraFaltaPag		INT(11),

	Par_MontoComFaltaPag 	DECIMAL(12,2),
	Par_EsRevolvente		CHAR(1),
	Par_TipoRevolvencia		CHAR(1),
	Par_InstitucionID		INT(11),
	Par_NumCtaInstit		VARCHAR(20),

	Par_CuentaClabe			VARCHAR(18),
	Par_AfectacionConta		CHAR(1),
	Par_ReqIntegracion		CHAR(1),
	Par_TipoCobroMora		CHAR(1),
	Par_FolioFondeo			VARCHAR(45),
	Par_CalcInteresID		INT(11),						# Tipo de Calculo de Interes
	Par_TasaBase			INT(11),					# Tasa Base para el calculo de Interes Tasa Variable
	Par_Refinanciamiento	CHAR(1),						# Indica si la linea de fondeo permite refinanciamiento
	Par_MonedaID			INT(11),
	
	Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_ProgramaID			VARCHAR(50),
	Aud_DireccionIP			VARCHAR(15),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN


	DECLARE Var_Control 	VARCHAR(50);
	DECLARE Var_Consecutivo	INT(11);
	DECLARE	VarLineaFonID	INT;
	DECLARE Var_PolizaID	BIGINT;
	DECLARE Par_Consecutivo	BIGINT;


	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE Salida_SI 		CHAR(1);
	DECLARE Salida_NO 		CHAR(1);
	DECLARE monedaPesos		INT(11);
	DECLARE Var_CtaOrdCar	INT(11);
	DECLARE Var_CtaOrdAbo	INT(11);
	DECLARE Var_Descripcion	VARCHAR(100);
	DECLARE	Var_SI			CHAR(1);
	DECLARE	Var_NO			CHAR(1);
	DECLARE Var_ConcepCon	INT(11);
	DECLARE	Nat_Cargo		CHAR(1);
	DECLARE	Nat_Abono		CHAR(1);
	DECLARE Tip_Fondeo		CHAR(1);
	DECLARE Var_Estatus		CHAR(1);
	DECLARE Var_EstatusInac	CHAR(1);


	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0;
	SET	Salida_SI			:= 'S';
	SET	Salida_NO			:= 'N';
	SET monedaPesos			:= 1;
	SET Var_CtaOrdCar		:= 11;
	SET Var_CtaOrdAbo		:= 12;
	SET Var_Descripcion		:= 'OTORGAMIENTO DE LINEA DE FONDEO';
	SET	Var_SI				:= 'S';
	SET	Var_NO				:= 'N';
	SET Var_ConcepCon		:= 24;
	SET	Nat_Cargo			:= 'C';
	SET	Nat_Abono			:= 'A';
	SET Tip_Fondeo			:= 'F';
	SET Var_EstatusInac		:= 'I';


	SET Var_PolizaID		:= 0;
	SET Par_Consecutivo		:= 0;
	SET VarLineaFonID		:= 0;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-LINEAFONDEADORALT');
			SET Var_Control:= 'sqlException' ;
		END;

		IF(IFNULL(Par_InstitutFondID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr:=	1;
			SET Par_ErrMen:=	'La Institucion de Fondeo esta Vacia.';
			SET Var_Control	:=	'institutFondID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DescripLinea, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr	:=	2;
			SET Par_ErrMen	:=	'La Descripcion esta Vacia.';
			SET Var_Control	:=	'descripLinea';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechInicLinea, Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr	:=	3;
			SET Par_ErrMen	:=	'La Fecha de Inicio esta Vacia.';
			SET Var_Control	:=	'fechInicLinea';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaFinLinea, Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr	:=	4;
			SET Par_ErrMen	:=	'La Fecha de Fin esta Vacio.';
			SET Var_Control	:=	'fechaFinLinea';
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
			SET Var_Control	:= 'monedaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT Estatus
			INTO Var_Estatus
		FROM INSTITUTFONDEO 
		WHERE InstitutFondID = Par_InstitutFondID;
		
		IF(IFNULL(Var_Estatus, Cadena_Vacia) = Var_EstatusInac) THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= 'El Instituto de Fondeo se Encuentra Inactivo.';
			SET Var_Control	:= 'institutFondID';
			LEAVE ManejoErrores;
		END IF;

		CALL FOLIOSAPLICAACT('LINEAFONDEADOR', VarLineaFonID);

		SET Aud_FechaActual := NOW();

		INSERT INTO LINEAFONDEADOR (
			LineaFondeoID,			InstitutFondID,			DescripLinea,			FechInicLinea,			FechaFinLinea,
			TipoLinFondeaID,		MontoOtorgado,			SaldoLinea,				TasaPasiva,				FactorMora,
			DiasGraciaMora,			PagoAutoVenci,			FechaMaxVenci,			CobraMoratorios,		CobraFaltaPago,
			DiasGraFaltaPag,		MontoComFalPag,			EsRevolvente,			TipoRevolvencia,		InstitucionID,
			NumCtaInstit,			CuentaClabe,			AfectacionConta,		ReqIntegracion,			TipoCobroMora,
			FolioFondeo,			CalcInteresID,			TasaBase,				Refinancia,				MonedaID,
			EmpresaID,				Usuario,				FechaActual,			ProgramaID,				DireccionIP,
			Sucursal,				NumTransaccion)
		VALUES (
			VarLineaFonID,			Par_InstitutFondID,		Par_DescripLinea,		Par_FechInicLinea,		Par_FechaFinLinea,
			Par_TipoLinFondeaID,	Par_MontoOtorgado,		Par_SaldoLinea,			Par_TasaPasiva,			Par_FactorMora,
			Par_DiasGraciaMora,		Par_PagoAutoVenci,		Par_FechaMaxVenci,		Par_CobraMoratorios,	Par_CobraFaltaPago,
			Par_DiasGraFaltaPag,	Par_MontoComFaltaPag,	Par_EsRevolvente,		Par_TipoRevolvencia,	Par_InstitucionID,
			Par_NumCtaInstit,		Par_CuentaClabe,		Par_AfectacionConta,	Par_ReqIntegracion,		Par_TipoCobroMora,
			Par_FolioFondeo,		Par_CalcInteresID,		Par_TasaBase,			Par_Refinanciamiento,	Par_MonedaID,
			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_ProgramaID,			Aud_DireccionIP,
			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_AfectacionConta = Var_SI)THEN

			CALL CONTAFONDEOPRO(
				Par_MonedaID,					VarLineaFonID,					Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
				Entero_Cero,					Cadena_Vacia,					Entero_Cero,			Cadena_Vacia,			Var_CtaOrdCar,
				Var_Descripcion,				Par_FechInicLinea,				Par_FechInicLinea,		Par_FechInicLinea,		Par_MontoOtorgado,
				CONVERT(VarLineaFonID,CHAR),	CONVERT(VarLineaFonID,CHAR),	Var_SI,					Var_ConcepCon,			Nat_Cargo,
				Nat_Cargo,						Nat_Cargo,						Nat_Cargo,				Var_NO,					Cadena_Vacia,
				Var_NO,							Entero_Cero,					Entero_Cero,			Var_SI,					Tip_Fondeo,
				Salida_NO,						Var_PolizaID,					Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
				Par_EmpresaID,					Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,					Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;


			CALL CONTAFONDEOPRO(
				Par_MonedaID,					VarLineaFonID,					Par_InstitutFondID,			Par_InstitucionID,		Par_NumCtaInstit,
				Entero_Cero,					Cadena_Vacia,					Entero_Cero,				Cadena_Vacia,			Var_CtaOrdAbo,
				Var_Descripcion,				Par_FechInicLinea,				Par_FechInicLinea,			Par_FechInicLinea,		Par_MontoOtorgado,
				CONVERT(VarLineaFonID,CHAR),	CONVERT(VarLineaFonID,CHAR),	Var_NO,						Var_ConcepCon,			Nat_Abono,
				Nat_Abono,						Nat_Abono,						Nat_Abono,					Var_NO,					Cadena_Vacia,
				Var_NO,							Entero_Cero,					Entero_Cero,				Var_SI,					Tip_Fondeo,
				Salida_NO,						Var_PolizaID,					Par_Consecutivo,			Par_NumErr,				Par_ErrMen,
				Par_EmpresaID,					Aud_Usuario,					Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,					Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	CONCAT('Linea de Fondeo Agregada: ', CONVERT(VarLineaFonID, CHAR));
		SET Var_Control		:=	'lineaFondeoID';
		SET Var_Consecutivo	:=	VarLineaFonID;
	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo ;
	END IF;

END TerminaStore$$

-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTMOVALT`;DELIMITER $$

CREATE PROCEDURE `APORTMOVALT`(
# ===========================================================
# -------- SP PARA REGISTRAR LOS MOVIMIENTOS DE APORTACIONES--------
# ===========================================================
	Par_AportacionID	INT(11),
	Par_Fecha			DATE,
	Par_TipoMovAportID	CHAR(4),
	Par_CantidadMov		DECIMAL(12,2),
	Par_NatMovimiento	CHAR(1),

	Par_ReferenciaMov	VARCHAR(100),
	Par_MonedaID		INT(11),
    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE	Nat_Cargo		CHAR(1);
	DECLARE	Nat_Abono		CHAR(1);
	DECLARE Var_Control		VARCHAR(50);
	DECLARE	Salida_SI		CHAR(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET	Nat_Cargo			:= 'C';
	SET	Nat_Abono			:= 'A';
	SET Aud_FechaActual 	:= NOW();
	SET Salida_SI			:='S';



	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:=	999;
				SET Par_ErrMen	:=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										   'esto le ocasiona. Ref: SP-APORTMOVALT');
			END;



		IF(IFNULL(Par_AportacionID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:=	1;
			SET Par_ErrMen	:=	'El Numero de Aportacion esta vacio.';
			SET Var_Control	:=	'aportacionID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Fecha,Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr	:=	3;
			SET Par_ErrMen	:=	'La fecha esta Vacia.';
			SET Var_Control	:=	'fecha';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Fecha,Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr	:=	4;
			SET Par_ErrMen	:=	'La naturaleza del Movimiento esta vacia';
			SET Var_Control	:=	'natMovimiento';
			LEAVE ManejoErrores;
		END IF;


		IF(Par_NatMovimiento <> Nat_Cargo)THEN
			IF(Par_NatMovimiento <> Nat_Abono) THEN
				SET Par_NumErr	:=	5;
				SET Par_ErrMen	:=	'La naturaleza del Movimiento no es correcta.';
				SET Var_Control	:=	'natMovimiento';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_NatMovimiento<>Nat_Abono)THEN
			IF(Par_NatMovimiento <> Nat_Cargo) THEN
				SET Par_NumErr	:=	6;
				SET Par_ErrMen	:=	'La naturaleza del Movimiento no es correcta.';
				SET Var_Control	:=	'natMovimiento';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_CantidadMov, Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr	:=	7;
			SET Par_ErrMen	:=	'La Cantidad esta Vacia.';
			SET Var_Control	:=	'cantidadMov';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CantidadMov, Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr	:=	8;
			SET Par_ErrMen	:=	'La Referencia esta vacia.';
			SET Var_Control	:=	'referenciaMov';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoMovAportID, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr	:=	9;
			SET Par_ErrMen	:=	'El Tipo de Movimiento esta vacio.';
			SET Var_Control	:=	'tipoMov';
			LEAVE ManejoErrores;
		END IF;


		INSERT INTO APORTMOV(
			AportacionID,		Fecha,			TipoMovAportID,			Monto,				NatMovimiento,
			Referencia,			MonedaID,		EmpresaID,				Usuario,			FechaActual,
			DireccionIP,		ProgramaID,		Sucursal,				NumTransaccion)
		VALUES(
			Par_AportacionID,	Par_Fecha,		Par_TipoMovAportID,		Par_CantidadMov,	Par_NatMovimiento,
			Par_ReferenciaMov,	Par_MonedaID,	Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr	:= 	0;
		SET Par_ErrMen	:=	'Movimiento Agregado Exitosamente';
		SET Var_Control	:=	'aportacionID';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI)THEN
		SELECT 	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Par_AportacionID 	AS consecutivo;
	END IF;
END TerminaStore$$
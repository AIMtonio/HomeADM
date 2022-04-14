-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSLINEAFONACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSLINEAFONACT`;DELIMITER $$

CREATE PROCEDURE `SALDOSLINEAFONACT`(
	/* Se utiliza para actualizar los saldos de la linea de fondeo
		se ocupa en el sp CREDITOFONDEOALT*/
	Par_LineaFondeoID   	INT(11),		-- Linea de Fondeo, corresponde con la tabla LINEAFONDEADOR
	Par_NatMovimiento 		CHAR(1),		-- Cargo C, Abono A
	Par_Monto				DECIMAL(14,2),	-- Monto del Credito de Fondeo

	Par_Salida		      	CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario			   	INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_Consecutivo		VARCHAR(50);

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Entero_Cero			INT;			-- Entero en Cero
	DECLARE	Decimal_Cero		DECIMAL(12,2);	-- Decimal en Cero
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	Salida_SI			CHAR(1);		-- Valor para devolver una Salida
	DECLARE	Nat_Cargo			CHAR(1);		-- Naturaleza de Cargo
	DECLARE	Nat_Abono			CHAR(1);		-- Naturaleza de Abono

	-- DECLARACION DE VARIABLES

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia		:= '';				-- Cadena Vacia
	SET	Entero_Cero			:= 0;				-- Entero en Cero
	SET	Salida_SI			:= 'S';				-- Decimal en Cero
	SET	Decimal_Cero		:= 0.00;			-- Valor para devolver una Salida
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	Nat_Cargo			:= 'C';				-- Naturaleza de Cargo
	SET	Nat_Abono			:= 'A';				-- Naturaleza de Abono

-- ASIGNACION DE VARIABLES

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-SALDOSLINEAFONACT');
			SET Var_Control := 'sqlException';
		END;

		-- Validacion de Campos Requeridos
		IF(IFNULL(Par_LineaFondeoID, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr := 2;
			SET	Par_ErrMen := 'La Linea de Fondeo esta Vacia.';
			SET Var_Control := 'lineaFondeoID';
			SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto, Decimal_Cero)) <= Decimal_Cero THEN
			SET	Par_NumErr := 5;
			SET	Par_ErrMen := 'El Monto esta Vacio.';
			SET Var_Control := 'monto';
			SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NatMovimiento = Nat_Cargo) THEN
			UPDATE LINEAFONDEADOR SET
				SaldoLinea		= SaldoLinea - Par_Monto,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE LineaFondeoID = Par_LineaFondeoID;
		ELSE
			UPDATE LINEAFONDEADOR SET
				SaldoLinea		= SaldoLinea + Par_Monto,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE LineaFondeoID = Par_LineaFondeoID;
		END IF;

		SET	Par_NumErr := 0;
		SET	Par_ErrMen := CONCAT('Saldos Actualizados de la linea de Fondeo: ',CONVERT(Par_LineaFondeoID,CHAR));
		SET Var_Control := 'lineaFondeoID';
		SET Var_Consecutivo := Par_LineaFondeoID;
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo 	AS consecutivo;
	END IF;

END TerminaStore$$
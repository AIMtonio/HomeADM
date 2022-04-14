-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EVALFORMULAREPPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EVALFORMULAREPPRO`;
DELIMITER $$


CREATE PROCEDURE `EVALFORMULAREPPRO`(
-- PARA REGULATORIOS: SP PARA CALCULAR EL SALDO FINAL DE VARIOS CONCEPTOS (PREVIAMENTE CALCULADOS) ENTRE SI
OUT		Par_SaldoFinal		DECIMAL(14,2),	-- Dara el Saldo final calculado
		Par_Formula			VARCHAR(500),	-- Formula de la operacion con claves de campos
		Par_Salida			CHAR(1),		-- Indica si existe salida S:SI N:NO

INOUT 	Par_NumErr			INT(11),		-- Numero de error
INOUT 	Par_ErrMen			VARCHAR(400),	-- Mensaje de error

		-- Parametros de Auditoria
		Aud_EmpresaID		INT(11),
		Aud_Usuario			INT(11),
		Aud_FechaActual		DATETIME,
		Aud_DireccionIP		VARCHAR(15),
		Aud_ProgramaID		VARCHAR(50),
		Aud_Sucursal		INT(11),
		Aud_NumTransaccion	BIGINT(20)

)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control					VARCHAR(100);		-- Variable de control
	DECLARE Var_Consecutivo				INT(11);			-- Consecutivo
	DECLARE Var_PosicionLlaveAbre		INT(11);			-- Indica la posicion de la llave que abre
	DECLARE Var_PosicionLlaveCierre		INT(11);			-- Indica la posicion de la llave que cierra
	DECLARE Var_PosicionDivide			INT(11);			-- Indica la posicion del simbolo que divide
	DECLARE Var_CadenaEvaluar			VARCHAR(100);		-- Almacena la cadena a evaluar
	DECLARE Var_ClaveCampo				VARCHAR(10);		-- Almacena la clave especifica a evaluar
	DECLARE Var_SaldoClave				DECIMAL(14,2);		-- Almacena el saldo de la clave evaluada
	DECLARE Var_FormulaEvaluar			VARCHAR(500);		-- Almacena la formula a evaluar
	DECLARE Var_FormulaFinal			VARCHAR(500);		-- Almacena la formula con los valores sustituidos
	DECLARE Var_Sentencia				VARCHAR(200);		-- Sentencia a ejecutar
	DECLARE Error_Key					INT(11);			-- Numero de Error

	--	Declaracion de constantes
	DECLARE Decimal_Cero				DECIMAL (14,2);		-- Constante Decimal Cero
	DECLARE Entero_Cero					INT(11);			-- Constante Cero
	DECLARE Cadena_Vacia				CHAR(1);			-- Constante Cadena Vacia
	DECLARE Cons_SI						CHAR(1);			-- Constante SI
	DECLARE Cons_Divide					CHAR(1);			-- Simbolo que divide
	DECLARE AbreLlave					CHAR(1);			-- Simbolo de llave que abre
	DECLARE CierraLlave					CHAR(1);			-- Simbolo de llave que cierra
	DECLARE SignoPesos					CHAR(1);			-- Simbolo signo de pesos

	--	Asignacion de constantes
	SET Decimal_Cero					:= 0.00;
	SET Entero_Cero						:= 0;
	SET Cadena_Vacia					:= '';
	SET Cons_SI							:= 'S';
	SET Cons_Divide						:= '/';
	SET AbreLlave						:= '{';
	SET CierraLlave						:= '}';
	SET SignoPesos						:= '$';

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1 Error_Key = MYSQL_ERRNO;

		IF(Error_Key = 1146) THEN
				SET Par_NumErr	:=	1;
				SET Par_ErrMen	:=	'La tabla no existe.';
			ELSE
				IF(Error_Key = 1064) THEN
					SET Par_NumErr	:=	2;
					SET Par_ErrMen	:=	'Existe un error en la formula.';
				ELSE
					SET	Par_NumErr	:=	999;
					SET	Par_ErrMen	:=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-EVALFORMULAREPPRO');
				END IF;
			END IF;
			SET	Var_Control	:=	'SQLEXCEPTION';

		END;

		IF(IFNULL(Par_Formula,	Cadena_Vacia) = Cadena_Vacia)	THEN
			SET Par_NumErr		:=	3;
			SET Par_ErrMen		:=	'La Formula esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

			SET Var_CadenaEvaluar	:=	Par_Formula;
			SET Var_FormulaEvaluar	:=	Par_Formula;
			SET Var_SaldoClave		:=	IFNULL(Var_SaldoClave,	Decimal_Cero);
			SET Par_SaldoFinal		:=	Decimal_Cero;
			SET Var_Consecutivo		:= Entero_Cero;

				--	Se evalua si en la formula existe un signo de pesos (indica que hay una operacion de variables)
			WHILE (LOCATE(SignoPesos,	Var_CadenaEvaluar) > Entero_Cero) DO

				-- Se obtiene la posicion de la llave que abre y cierra
				SET Var_PosicionLlaveAbre	:=	LOCATE(AbreLlave,	Var_CadenaEvaluar);
				SET	Var_PosicionLlaveCierre	:=	LOCATE(CierraLlave, Var_CadenaEvaluar);
				SET	Var_ClaveCampo			:=	(SELECT SUBSTRING(Var_CadenaEvaluar,(Var_PosicionLlaveAbre + 1) ,(Var_PosicionLlaveCierre- (Var_PosicionLlaveAbre + 1))));
				SET	Var_ClaveCampo			:=	REPLACE(Var_ClaveCampo, ' ', Cadena_Vacia);

				-- Se valida si el concepto existe en la tabla.
				IF NOT EXISTS (SELECT 	SaldoFinal
								FROM	TMPTIPOSSALDOSREG
								WHERE	ClaveCampo 			= Var_ClaveCampo
								AND		NumeroTransaccion	= Aud_NumTransaccion)THEN

					SET Par_NumErr	:=	4;
					SET Par_ErrMen	:=	'El Concepto No Existe.';
					LEAVE ManejoErrores;
				END IF;

				-- Se obtiene el saldo del campo evaluado.
				SET	Var_SaldoClave :=	(SELECT  SaldoFinal  FROM TMPTIPOSSALDOSREG WHERE ClaveCampo = Var_ClaveCampo AND NumeroTransaccion = Aud_NumTransaccion);
				SET	Var_SaldoClave :=	IFNULL(Var_SaldoClave, Decimal_Cero);

				-- Se corta la formula con la posición encontrada de la llave que cierra
				SET	Var_FormulaEvaluar	:=	REPLACE( Var_FormulaEvaluar, Var_ClaveCampo, Var_SaldoClave);
				SET	Var_CadenaEvaluar	:=	(SELECT SUBSTRING(Var_CadenaEvaluar,Var_PosicionLlaveCierre + 1));

			END WHILE;

			SET	Var_FormulaFinal	:=	REPLACE(Var_FormulaEvaluar, AbreLlave, Cadena_Vacia);
			SET	Var_FormulaFinal	:=	REPLACE(Var_FormulaFinal, CierraLlave, Cadena_Vacia);
			SET	Var_FormulaFinal	:=	REPLACE(Var_FormulaFinal, SignoPesos, Cadena_Vacia);
			SET	Var_FormulaFinal	:=	REPLACE(Var_FormulaFinal, ' ', Cadena_Vacia);

			SET Var_PosicionDivide	:=	 (SELECT LOCATE(CONCAT(Cons_Divide,Decimal_Cero), Var_FormulaFinal));
			-- Validacion para identificar si hay una division entre cero
			IF(Var_PosicionDivide > Entero_Cero) THEN
				SET Par_NumErr	:=	5;
				SET Par_ErrMen	:=	'No se puede realizar una division entre cero.';
				LEAVE ManejoErrores;
			END IF;

			SET	Var_Sentencia	:=	CONCAT(Var_FormulaFinal);
			SET	Var_Sentencia	:=	CONCAT("SELECT ROUND(" , Var_Sentencia, ",2) INTO @SaldoCuenta;");

			SET @Sentencia	:=	(Var_Sentencia);

			PREPARE EXECUTEFORMULA FROM @Sentencia;
			EXECUTE EXECUTEFORMULA;
			DEALLOCATE PREPARE EXECUTEFORMULA;

		SET	Par_SaldoFinal	:= @SaldoCuenta;

		IF(Par_SaldoFinal IS NULL )	THEN
			SET Par_NumErr	:=	4;
			SET Par_ErrMen	:=	'Ha ocurrido un error en la operacion.';
			LEAVE ManejoErrores;
		END IF;

		SET	Par_NumErr	:=	'000';
		SET	Par_ErrMen	:=	'Saldo calculado correctamente';

	END ManejoErrores;

	IF (Par_Salida = Cons_SI) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS Control,
				Var_Consecutivo	AS Consecutivo;
	END IF;

END TerminaStore$$

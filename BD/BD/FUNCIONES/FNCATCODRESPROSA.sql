DELIMITER ;
DROP FUNCTION IF EXISTS FNCATCODRESPROSA;

DELIMITER $$
CREATE FUNCTION `FNCATCODRESPROSA`(
	-- Descripcion	= Funcion retorna la descripcion de acuerdo a un Codigo
	-- Modulo		= Tarjetas de Credito WS
	Par_Codigo			CHAR(2),	-- Numero de Codigo
	Par_ProdIndicator	CHAR(2)		-- Indicador de Producto( limitado a 2 caracteres (01 - ATM, 02 - POS))
) RETURNS VARCHAR(500)
	DETERMINISTIC
BEGIN

	-- Declaraion de Variables
	DECLARE Var_Descripcion			VARCHAR(500);		-- Invalid transaction

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- Constante de entero cero
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE	Decimal_Cero		DECIMAL(12,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante de fecha vacia

	DECLARE Prod_ATM			CHAR(2);			-- Constante Indicador de Producto 01 - ATM
	DECLARE Prod_POS			CHAR(2);			-- Constante Indicador de Producto 02 - POS
	DECLARE Con_Exito			CHAR(2);			-- Operacion Exitosa
	DECLARE Con_InvTransaction	CHAR(2);			-- Invalid transaction
	DECLARE Con_InvAmount		CHAR(2);			-- Invalid amount
	DECLARE Con_InvCardNumber	CHAR(2);			-- Invalid card number (no such number)

	-- Asignacion  de Constantes
	SET Entero_Cero				:=0;
	SET	Cadena_Vacia			:= '';
	SET	Decimal_Cero			:= 0.0;
	SET Fecha_Vacia 			:='1900-01-01';

	SET Prod_ATM				:= '01';
	SET Prod_POS				:= '02';
	SET Con_Exito				:= '00';
	SET Con_InvTransaction		:= '12';
	SET Con_InvAmount			:= '13';
	SET Con_InvCardNumber		:= '14';

	IF( Par_Codigo NOT IN (Con_InvTransaction,Con_InvAmount,Con_InvCardNumber,Con_Exito) ) THEN
		SET Var_Descripcion := 'Invalid transaction';
	END IF;

	IF( Par_ProdIndicator = Cadena_Vacia || Par_ProdIndicator = Entero_Cero) THEN
		SET Par_ProdIndicator := Prod_ATM;
	END IF;

	IF( Par_ProdIndicator = Prod_ATM ) THEN
		SELECT	Descripcion
		INTO	Var_Descripcion
		FROM CATCODRESPROSA
		WHERE Peticion = Prod_ATM
		  AND Codigo = Par_Codigo
		LIMIT 1;
	END IF;

	IF( Par_ProdIndicator = Prod_POS ) THEN
		SELECT	Descripcion
		INTO	Var_Descripcion
		FROM CATCODRESPROSA
		WHERE Peticion = Prod_POS
		  AND Codigo = Par_Codigo
		LIMIT 1;
	END IF;

	RETURN Var_Descripcion;

END$$
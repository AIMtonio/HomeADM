
DELIMITER ;
DROP PROCEDURE IF EXISTS `ALGORITMOOXXOCAL`;
DELIMITER $$

CREATE PROCEDURE `ALGORITMOOXXOCAL`(
-- SP QUE REALIZA EL CALCULO DEL ALGORITMO OXXO

	Par_InstitucionID 		INT(11),		-- Id de la institucion
	Par_Referencia			VARCHAR(21),	-- Numero de referencia (Credito)
	INOUT Par_NuevaRefe		VARCHAR(22),	-- Numero de referencia final

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400)
)
TerminaStore:BEGIN

    -- Declaracion de variables
	DECLARE Var_Control			VARCHAR(100);	-- Variable de control
	DECLARE Var_Consecutivo 	VARCHAR(100);	-- Consecutivo
	DECLARE Var_NumCaracteres	VARCHAR(15);	-- Numero de caracteres
	DECLARE Var_Referencia		VARCHAR(21);    -- Referencia base sobre la que se va a calcular el digito verificador
    DECLARE Var_NumCred			BIGINT(12);		-- Numero de credito
    DECLARE Var_CreditoFormat   VARCHAR(20);	-- Numero de credito de 8 digitos(Se le quita un cero al valor original)
    DECLARE Var_SucursalID		INT(11);		-- Sucursal del Credito
    DECLARE Var_LogSuc			INT(11);		-- Longitud de la sucursal
    DECLARE Var_Suc				INT(11);		-- Sucursal de la cadena Referencia
    DECLARE Var_ClienteID		INT(11);		-- Numero de cliente
    DECLARE Var_TipoPersona		CHAR(1);		-- Tipo de persona al que pertenece el cliente
    DECLARE Var_EstadoID		INT(11);		-- Estado de la direccion del cliente
    DECLARE	Var_MunicipioID		INT(11);		-- Municipio de la direccion del cliente
    DECLARE Var_FechaNac		DATE;			-- Fecha de nacimiento del cliente
    DECLARE Var_TxtFechaNac		CHAR(6);		-- Fecha de nacimiento del cliente (Formato DDMMAA)
    DECLARE Var_DigitoVerif		INT(11);		-- Digito verificador

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);		-- Entero Cero
	DECLARE Entero_Uno			INT(11);		-- Entero Uno
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena Vacia
    DECLARE Fecha_Vacia			DATE;			-- Fecha Vacia
    DECLARE Cons_SI				CHAR(1);		-- Constante SI
	DECLARE Salida_SI			CHAR(1);		-- Constantes SI
    DECLARE Cons_PM				CHAR(1);		-- Constante Persona Moral
    DECLARE Prefijo_Oxxo		INT(11);		-- Constante Prefijo OXXO1

	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Cadena_Vacia		:= '';
    SET Fecha_Vacia			:= '1900-01-01';
    SET Cons_SI				:= 'S';
	SET Salida_SI			:='S';
    SET Cons_PM				:= 'M';
    SET Prefijo_Oxxo		:= 15;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-ALGORITMOOXXOCAL');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Se obtienen los datos del credito
        SELECT ClienteID, SucursalID INTO Var_ClienteID, Var_SucursalID FROM CREDITOS WHERE CreditoID = CAST(Par_Referencia AS UNSIGNED);

		-- Se obtienen los datos del cliente
        SELECT D.EstadoID, 	D.MunicipioID, 		C.FechaNacimiento,	C.TipoPersona
        INTO  Var_EstadoID, Var_MunicipioID,	Var_FechaNac,		Var_TipoPersona
        FROM CLIENTES C
        INNER JOIN DIRECCLIENTE D ON C.ClienteID = D.ClienteID
        WHERE D.Oficial = Cons_SI
        AND C.ClienteID = Var_ClienteID;

		SET Var_ClienteID	:=IFNULL(Var_ClienteID,	Entero_Cero);
        SET Var_SucursalID	:=IFNULL(Var_SucursalID,	Entero_Cero);
		SET Var_FechaNac	:=IFNULL(Var_FechaNac,	Fecha_Vacia);

         IF(IFNULL(Par_InstitucionID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'La Institucion esta Vacia';
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_Referencia, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'La Referencia esta Vacia';
			SET Var_Control		:= 'referencia';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Var_FechaNac, Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'La Fecha de Nacimiento del Cliente no esta Capturada';
			SET Var_Control		:= 'referencia';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Var_EstadoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'El Estado del Cliente no esta Capturado';
			SET Var_Control		:= 'referencia';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Var_MunicipioID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 5;
			SET Par_ErrMen 		:= 'El Municipio del Cliente no esta Capturado';
			SET Var_Control		:= 'referencia';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        -- Si el cliente es una persona moral no se le podra generar la referencia
       IF(IFNULL(Var_TipoPersona, Cadena_Vacia) = Cons_PM) THEN
			SET Par_NumErr 		:= 6;
			SET Par_ErrMen 		:= 'No se puede generar la Referencia a una Persona Moral';
			SET Var_Control		:= 'referencia';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

       -- Se genera el numero de credito a 8 digitos
		SELECT LENGTH(Var_SucursalID) INTO Var_LogSuc;

		SET Var_Suc 			:= SUBSTRING(Par_Referencia, 1, Var_LogSuc);
		SET Var_NumCred			:= CAST(SUBSTRING(Par_Referencia, Var_LogSuc+1, LENGTH(Par_Referencia)) AS  UNSIGNED);
        SET Var_CreditoFormat	:= CONCAT(Var_Suc, LPAD(Var_NumCred, (8 - Var_LogSuc), 0));

		SET Var_TxtFechaNac 	:= CONCAT(LPAD(DAY(Var_FechaNac), 2, '0'), LPAD(MONTH(Var_FechaNac), 2, '0'), DATE_FORMAT(Var_FechaNac, '%y'));

        -- Se genera la referencia base para el calculo del digito verificador
		SET Var_Referencia 		:= CONCAT(Prefijo_Oxxo, LPAD(Var_EstadoID, 2,0), LPAD(Var_MunicipioID, 3,0), Var_TxtFechaNac, Var_CreditoFormat);

        -- Se obtiene el digito verificador
        SET Var_DigitoVerif 	:= FNGENERADIGVERIALG137(Var_Referencia);

		IF(ISNULL(Var_DigitoVerif)) THEN
			SET Par_NumErr 		:= 7;
			SET Par_ErrMen 		:= 'Error al generar el Digito Verificador';
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        -- Se concatena la referencia base + el digito verificador
		SET Par_NuevaRefe 		:= CONCAT(Var_Referencia,Var_DigitoVerif);

        SET Var_NumCaracteres	:= CHAR_LENGTH(Par_NuevaRefe);

        IF(Var_NumCaracteres <> 22)THEN
			SET Par_NumErr 		:= 8;
			SET Par_ErrMen 		:= 'Numero de Caracteres incorrecto';
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= Par_NuevaRefe;
		SET Var_Control		:= 'referencia';
		SET Var_Consecutivo	:= Par_NuevaRefe;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
	END IF;
END TerminaStore$$


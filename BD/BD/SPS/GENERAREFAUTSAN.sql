DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERAREFAUTSAN`;

DELIMITER $$
CREATE PROCEDURE `GENERAREFAUTSAN`(
	/**
	** SP CREADO PARA GENERAR LA REFRENCIA AUTOMATICA
	** CUANDO SE TIENE EN AUTOMATICO EL CAMPO Algoritmo de Clave de Retiro de cuentasNostro
	_*/
	Par_TipoReferencia			INT(11),		-- Tipo de referencia a crear Credito(1) Cuenta(2) u otro(3)
	Par_CreCueOtro				VARCHAR(20),	-- Aca va la cuenta el credio u otro tipo de dispersion
	Par_Salida					CHAR(1),		-- Parametro de Salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	INOUT Par_Referencia		VARCHAR(20),	-- Referencia que se generara desde este SP

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria
	Aud_Usuario					INT(11),		-- Parametro de auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(20),	-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal				INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE VarControl 			VARCHAR(50);
	DECLARE Var_Credito			VARCHAR(12);
	DECLARE Var_CuentaAhoID		VARCHAR(12);
	DECLARE Var_Random 			VARCHAR(6);
	DECLARE Var_OtraSolicitud	VARCHAR(18);
	DECLARE Var_Consecutivo		INT(11);
	DECLARE Var_CreditoCtaOtro	BIGINT(20);

	-- Declaeracion de constantes
	DECLARE Con_Credito 		INT(11);
	DECLARE Con_Cuenta			INT(11);
	DECLARE Con_Otro			INT(11);
	DECLARE Con_LimiteMax		INT(11);
	DECLARE Con_LimiteMin		INT(11);
	DECLARE Cadena_Cero			CHAR(1);
	DECLARE Entero_Seis			INT(11);
	DECLARE Entero_Cero			INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Doce			INT(11);
	DECLARE Entero_Dieciocho	INT(11);
	DECLARE Entero_Once			INT(11);
	DECLARE SalidaSI			CHAR(1);

	DECLARE Tipo_Credito		INT(11);
	DECLARE Tipo_Cuenta			INT(11);
	DECLARE Tipo_Otro			INT(11);


	-- Seteo de valores
	SET Con_Credito				:= 1;
	SET Con_Cuenta				:= 3;
	SET Con_Otro				:= 2;
	SET Con_LimiteMin			:= 1;
	SET Con_LimiteMax			:= 999999;
	SET Cadena_Cero				:= '0';
	SET Entero_Seis				:= 6;
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET Entero_Doce 			:= 12;
	SET Entero_Dieciocho		:= 18;
	SET Entero_Once				:= 11;
	SET SalidaSI				:= 'S';
	SET Tipo_Credito			:= 1;
	SET Tipo_Cuenta				:= 2;
	SET Tipo_Otro				:= 3;



	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-GENERAREFAUTSAN');
				SET VarControl = 'SQLEXCEPTION';
			END;


	SET Var_Random := LPAD(ROUND((RAND()*Con_LimiteMax)+Con_LimiteMin),Entero_Seis,Cadena_Cero);
	SET Par_CreCueOtro := IFNULL(Par_CreCueOtro,Cadena_Vacia);
	

	-- para generar la referencia de un credito
	IF Par_TipoReferencia= Tipo_Credito AND Par_CreCueOtro <> Cadena_Vacia THEN
		SET Var_Credito := LPAD(Par_CreCueOtro,Entero_Once,Cadena_Cero);
		
		SELECT IFNULL(MAX(Folio),-1)+1 INTO Var_Consecutivo
			FROM FOLIOREFERENCIASAN
			WHERE Instrumento=Var_Credito;

		SET Var_Consecutivo :=IFNULL(Var_Consecutivo, Entero_Cero);

		IF(Var_Consecutivo=Entero_Cero)THEN
			INSERT INTO FOLIOREFERENCIASAN VALUES (Con_Credito, Var_Credito, Var_Consecutivo);
		END IF;

		IF(Var_Consecutivo>9)THEN
			SET Var_Consecutivo := Entero_Cero;
		END IF;

		UPDATE FOLIOREFERENCIASAN 
			SET Folio = Var_Consecutivo
		WHERE Instrumento= Var_Credito;

		SET Par_Referencia :=CONCAT(Con_Credito,Var_Credito,Var_Consecutivo);
		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Referencia Generada para Credito';
		SET VarControl := Cadena_Cero;
		LEAVE ManejoErrores;
	END IF;

	-- Para generar la refrencia de una cuenta
	IF Par_TipoReferencia = Tipo_Cuenta  AND Par_CreCueOtro <> Cadena_Vacia THEN
		SET Var_CuentaAhoID := LPAD(Par_CreCueOtro,Entero_Doce,Cadena_Cero);

		SELECT IFNULL(MAX(Folio),-1)+1 INTO Var_Consecutivo
			FROM FOLIOREFERENCIASAN
			WHERE Instrumento=Var_CuentaAhoID;
		
		SET Var_Consecutivo :=IFNULL(Var_Consecutivo, Entero_Cero);

		IF(Var_Consecutivo=Entero_Cero)THEN
			INSERT INTO FOLIOREFERENCIASAN VALUES (Con_Cuenta, Var_CuentaAhoID, Var_Consecutivo);
		END IF;

		IF(Var_Consecutivo>9)THEN
			SET Var_Consecutivo := Entero_Cero;
		END IF;

		UPDATE FOLIOREFERENCIASAN 
			SET Folio = Var_Consecutivo
		WHERE instrumento= Var_CuentaAhoID;		

		SET Par_Referencia := CONCAT(Con_Cuenta,Var_CuentaAhoID,Var_Consecutivo);
		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Referencia Generada para Cuenta';
		SET VarControl := Cadena_Cero;
		LEAVE ManejoErrores;
	END IF;


	-- Para genrar la referencia de otra solicitud de dispersion
	IF Par_TipoReferencia = Tipo_Otro  AND Par_CreCueOtro <> Cadena_Vacia THEN
		SET Var_OtraSolicitud := LPAD(Par_CreCueOtro,Entero_Dieciocho,Cadena_Cero);

		SELECT IFNULL(MAX(Folio),-1)+1 INTO Var_Consecutivo
			FROM FOLIOREFERENCIASAN
			WHERE Instrumento=Var_OtraSolicitud;

		SET Var_Consecutivo :=IFNULL(Var_Consecutivo, Entero_Cero);

		IF(Var_Consecutivo=Entero_Cero)THEN
			INSERT INTO FOLIOREFERENCIASAN VALUES (Con_Otro, Var_OtraSolicitud, Var_Consecutivo);
		END IF;

		IF(Var_Consecutivo>9)THEN
			SET Var_Consecutivo := Entero_Cero;
		END IF;

		UPDATE FOLIOREFERENCIASAN 
			SET Folio = Var_Consecutivo
		WHERE Instrumento= Var_OtraSolicitud;

		SET Par_Referencia := CONCAT(Con_Otro,Var_OtraSolicitud,Var_Consecutivo);
		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Referencia Generada para Otras Solicitudes';
		SET VarControl := Cadena_Cero;
		LEAVE ManejoErrores;
	END IF;

	SET Par_Referencia := Cadena_Vacia;
	SET Par_NumErr := 999;
		SET Par_ErrMen := 'Referencia No Generada';
		SET VarControl := Cadena_Cero;
	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				VarControl AS control,
				Par_Referencia AS consecutivo;
	END IF;

END TerminaStore$$
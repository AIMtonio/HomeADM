-- NOTIFICAREMSOFICON

DELIMITER ;

DROP PROCEDURE IF EXISTS `NOTIFICAREMSOFICON`;

DELIMITER $$

CREATE PROCEDURE `NOTIFICAREMSOFICON`(
	-- SP para generar xml y devuelve la cadena convertida a base64
	Par_ClaveRastreo	VARCHAR(30),
	Par_Visa			VARCHAR(200),
	Par_Pasaporte		VARCHAR(200),
	Par_GreenCard		VARCHAR(200),
	Par_SegSocial		VARCHAR(200),

	Par_MatrConsular	VARCHAR(200),
	Par_Ife				VARCHAR(200),
	Par_Licencia		VARCHAR(200),

	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)

TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_TotalCredito	DECIMAL(18,2);
	DECLARE Var_CadenaXML 		VARCHAR(10000);
	DECLARE Var_IdMerchantNT	VARCHAR(50);
	DECLARE Var_LoginNT			VARCHAR(50);
	DECLARE Var_PasswordNT		VARCHAR(50);
	DECLARE Var_IdTeller		VARCHAR(50);

	-- Declaracion de Constantes
	DECLARE Entero_Cero 		INT(11);
	DECLARE Decimal_Cero 		DECIMAL(14,2);
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE Entero_Uno 			INT(11);
	DECLARE VAR_SALTO_LINEA		VARCHAR(2);
	DECLARE Con_Principal		INT(11);			-- Consulta para el metodo Notificaciones
	DECLARE Var_ConInfo			TINYINT UNSIGNED;	-- Consulta para el metodo Info
	DECLARE Var_ConRepPago		TINYINT UNSIGNED;	-- Consulta para el metodo ReportarPago
	DECLARE Var_ConDevol		TINYINT UNSIGNED;	-- Consulta para el metodo Devolucion

	-- Asignacion de Constantes y Variables
	SET Entero_Cero			:= 0;					-- Entero cero
	SET Decimal_Cero		:= 0.00;				-- Decimal cero
	SET Entero_Uno			:= 1;					-- Entero uno
	SET Cadena_Vacia		:= '';					-- Cadena vacia
	SET VAR_SALTO_LINEA		:= '\n';				-- Saldo de linea
	SET Con_Principal		:= 1;					-- Consulta para el metodo Notificaciones
	SET Var_ConInfo			:= 2;					-- Consulta para el metodo Info
	SET Var_ConRepPago		:= 3;					-- Consulta para el metodo ReportarPago
	SET Var_ConDevol		:= 4;					-- Consulta para el metodo Devolucion
	SET Var_CadenaXML		:= '';					-- Inicializacion vacia de la variable Cadena XML

	SELECT ValorParametro
		INTO Var_IdMerchantNT
	FROM PARAMGENERALES
		WHERE LlaveParametro = 'IdMerchantNTSofiExpress';

	SELECT ValorParametro
		INTO Var_LoginNT
	FROM PARAMGENERALES
		WHERE LlaveParametro = 'LoginNTSofiExpress';

	SELECT ValorParametro
		INTO Var_PasswordNT
	FROM PARAMGENERALES
		WHERE LlaveParametro = 'PasswordNTSofiExpress';

	SELECT ValorParametro
		INTO Var_IdTeller
	FROM PARAMGENERALES
		WHERE LlaveParametro = 'IdTellerSofiExpress';

	IF(Par_NumCon = Con_Principal) THEN

		SET Var_CadenaXML = CONCAT('<?xml version="1.0" encoding="us-ascii" standalone="yes"?>', VAR_SALTO_LINEA);
		SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<LOTE_ENTRADA>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_LOTE> ','</ID_LOTE>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<CORRESPONSAL>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_MERCHANT>',Var_IdMerchantNT,'</ID_MERCHANT>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<LOGIN>','\'',Var_LoginNT,'\'','</LOGIN>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<PASSWORD>','\'',Var_PasswordNT,'\'','</PASSWORD>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</CORRESPONSAL>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<TRANSACCION_E>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<REQUEST_TYPE>N</REQUEST_TYPE>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_TRANSACCION></ID_TRANSACCION>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</TRANSACCION_E>', VAR_SALTO_LINEA);
		SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</LOTE_ENTRADA>');

	END IF;

	IF (Par_NumCon = Var_ConInfo) THEN

		SET Var_CadenaXML = CONCAT('<?xml version="1.0" encoding="us-ascii" standalone="yes"?>', VAR_SALTO_LINEA);
		SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<LOTE_ENTRADA>',VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_LOTE>','</ID_LOTE>',VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<CORRESPONSAL>',VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_MERCHANT>',Var_IdMerchantNT,'</ID_MERCHANT>',VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<LOGIN>','\'',Var_LoginNT,'\'','</LOGIN>',VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<PASSWORD>','\'',Var_PasswordNT,'\'','</PASSWORD>',VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</CORRESPONSAL>',VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<TRANSACCION_E>',VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<REQUEST_TYPE>I</REQUEST_TYPE>',VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_TRANSACCION></ID_TRANSACCION>',VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<INFO_INPUT>',VAR_SALTO_LINEA);
					SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<AUTHO_NUMBER>',Par_ClaveRastreo,'</AUTHO_NUMBER>',VAR_SALTO_LINEA);
					SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_TELLER>',Var_IdTeller,'</ID_TELLER>',VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</INFO_INPUT>',VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</TRANSACCION_E>',VAR_SALTO_LINEA);
		SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</LOTE_ENTRADA>');

	END IF;

	IF (Par_NumCon = Var_ConRepPago) THEN

		SET Var_CadenaXML = CONCAT('<?xml version="1.0" encoding="us-ascii" standalone="yes"?>', VAR_SALTO_LINEA);
		SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<LOTE_ENTRADA>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_LOTE>','</ID_LOTE>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<CORRESPONSAL>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_MERCHANT>',Var_IdMerchantNT,'</ID_MERCHANT>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<LOGIN>','\'',Var_LoginNT,'\'','</LOGIN>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<PASSWORD>','\'',Var_PasswordNT,'\'','</PASSWORD>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</CORRESPONSAL>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<TRANSACCION_E>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<REQUEST_TYPE>R</REQUEST_TYPE>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_TRANSACCION></ID_TRANSACCION>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<REPORTAR_PAGO_INPUT>', VAR_SALTO_LINEA);
					SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<AUTHO_NUMBER>',Par_ClaveRastreo,'</AUTHO_NUMBER>', VAR_SALTO_LINEA);
					SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_TELLER>',Var_IdTeller,'</ID_TELLER>', VAR_SALTO_LINEA);
					SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<DOCUMENTACION_CLIENTE>', VAR_SALTO_LINEA);
						SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<VISA>',Par_Visa,'</VISA>', VAR_SALTO_LINEA);
						SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<PASAPORTE>',Par_Pasaporte,'</PASAPORTE>', VAR_SALTO_LINEA);
						SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<GREENCARD>',Par_GreenCard,'</GREENCARD>', VAR_SALTO_LINEA);
						SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<SS>',Par_SegSocial,'</SS>', VAR_SALTO_LINEA);
						SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<MATRICULACONSULAR>',Par_MatrConsular,'</MATRICULACONSULAR>', VAR_SALTO_LINEA);
						SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<IFE>',Par_Ife,'</IFE>', VAR_SALTO_LINEA);
						SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<LICENCIA>',Par_Licencia,'</LICENCIA>', VAR_SALTO_LINEA);
					SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</DOCUMENTACION_CLIENTE>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</REPORTAR_PAGO_INPUT>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</TRANSACCION_E>', VAR_SALTO_LINEA);
		SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</LOTE_ENTRADA>');

	END IF;

	IF (Par_NumCon = Var_ConDevol) THEN

		SET Var_CadenaXML = CONCAT('<?xml version="1.0" encoding="us-ascii" standalone="yes"?>', VAR_SALTO_LINEA);
		SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<LOTE_ENTRADA>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_LOTE>','</ID_LOTE>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<CORRESPONSAL>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_MERCHANT>',Var_IdMerchantNT,'</ID_MERCHANT>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<LOGIN>','\'',Var_LoginNT,'\'','</LOGIN>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<PASSWORD>','\'',Var_PasswordNT,'\'','</PASSWORD>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</CORRESPONSAL>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<TRANSACCION_E>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<REQUEST_TYPE>D</REQUEST_TYPE>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_TRANSACCION></ID_TRANSACCION>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<DEVOLUCION_INPUT>', VAR_SALTO_LINEA);
					SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<BANK_AUTHO>',Par_ClaveRastreo,'</BANK_AUTHO>', VAR_SALTO_LINEA);
					SET Var_CadenaXML = CONCAT(Var_CadenaXML, '<ID_TELLER>',Var_IdTeller,'</ID_TELLER>', VAR_SALTO_LINEA);
				SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</DEVOLUCION_INPUT>', VAR_SALTO_LINEA);
			SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</TRANSACCION_E>', VAR_SALTO_LINEA);
		SET Var_CadenaXML = CONCAT(Var_CadenaXML, '</LOTE_ENTRADA>');

	END IF;

	SELECT TO_BASE64(Var_CadenaXML) AS CadenaB64;

END TerminaStore$$
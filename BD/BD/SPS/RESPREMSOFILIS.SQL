-- SP RESPREMSOFILIS

DELIMITER ;

DROP PROCEDURE IF EXISTS RESPREMSOFILIS;

DELIMITER $$

CREATE PROCEDURE `RESPREMSOFILIS`(
	-- Stored procedure para procesar la cadena XML en base64 que responden los servicios de Incorporate
	Par_CadenaB64				LONGTEXT,				-- Cadena de respuesta del servicio de Incorporate

	Par_NumLis					TINYINT UNSIGNED,		-- Numero de Lista

	Par_EmpresaID				INT(11),				-- Parametro de Auditoria de la Empresa
	Aud_Usuario					INT(11),				-- Parametro de Auditoria del Usuario
	Aud_FechaActual				DATETIME,				-- Parametro de Auditoria de la Fecha Actual
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de Auditoria de la Direccion IP
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de Auditoria del ID del Programa
	Aud_Sucursal				INT(11),				-- Parametro de Auditoria de Sucursal
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de Auditoria del numero de Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Var_LisInfo			TINYINT UNSIGNED;		-- Lista Info

	-- Declaracion de variables
	DECLARE Con_Interaccion		INT(11);
	DECLARE Var_Control			VARCHAR(50);			-- Control en Pantalla
	DECLARE Var_Consecutivo		INT(11);				-- Consecutivo en Pantalla
	DECLARE Con_CadenaXML		LONGTEXT;				-- Cadena XML decodificada
	DECLARE Con_TotalRegis      INT(11);
	DECLARE Var_AUTHO_NUMBER	VARCHAR(20);
	DECLARE Var_STATUS			VARCHAR(5);
	DECLARE Var_DATE_TIME		VARCHAR(30);
	DECLARE Var_Opcode1			CHAR(3);
	DECLARE Var_Opcode2			CHAR(3);

	-- Asignacion de Constantes y variables
	SET Entero_Cero				:= 0;					-- Entero en Cero
	SET Cadena_Vacia			:= '';					-- Cadena Vacia
	SET Var_LisInfo				:= 1;					-- Consulta Info

	DELETE FROM TMPINFODESCARGASREM WHERE NumTransaccion = Aud_NumTransaccion;

	-- Lista Notificaciones
	IF (Par_NumLis = Var_LisInfo) THEN

		SELECT		FROM_BASE64(Par_CadenaB64)
			INTO	Con_CadenaXML;

		SELECT		ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O/INFO_OUTPUT/OPCODE1') AS Opcode1,
					ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O/INFO_OUTPUT/OPCODE2') AS Opcode2
			INTO	Var_Opcode1,
					Var_Opcode2;

		SET Var_Opcode1	:= IFNULL(Var_Opcode1, Cadena_Vacia);
		SET Var_Opcode2	:= IFNULL(Var_Opcode2, Cadena_Vacia);

		IF (Var_Opcode1 = Cadena_Vacia AND Var_Opcode2 = Cadena_Vacia) THEN

			SELECT		ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O/INFO_OUTPUT/ID_STATUS') AS STATUS
				INTO	Var_STATUS;

			SET Var_STATUS			:= IFNULL(Var_STATUS, Cadena_Vacia);

			IF(Var_STATUS <> Cadena_Vacia)THEN

				INSERT INTO TMPINFODESCARGASREM (	AuthoNumber,		Status,			OpCode1,		OpCode2,		NumTransaccion		)
										VALUES (	Cadena_Vacia,		Var_STATUS,		Var_Opcode1,	Var_Opcode2,	Aud_NumTransaccion	);

			ELSE

				INSERT INTO TMPINFODESCARGASREM (	AuthoNumber,		Status,			OpCode1,		OpCode2,		NumTransaccion		)
										VALUES (	Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,	Aud_NumTransaccion	);

				SET Con_Interaccion	:= Con_TotalRegis;

			END IF;

		ELSE

			INSERT INTO TMPINFODESCARGASREM (	AuthoNumber,	Status,			OpCode1,		OpCode2,		NumTransaccion		)
									VALUES (	Cadena_Vacia,	Cadena_Vacia,	Var_Opcode1,	Var_Opcode2,	Aud_NumTransaccion	);

		END IF;

		SELECT		AuthoNumber,	Status,		OpCode1,		OpCode2,		NumTransaccion
			FROM	TMPINFODESCARGASREM
			WHERE	NumTransaccion = Aud_NumTransaccion;

		DELETE FROM TMPINFODESCARGASREM WHERE NumTransaccion = Aud_NumTransaccion;

	END IF;

END TerminaStore$$
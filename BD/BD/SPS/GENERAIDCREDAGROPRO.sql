-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERAIDCREDAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERAIDCREDAGROPRO`;
DELIMITER $$


CREATE PROCEDURE `GENERAIDCREDAGROPRO`(
/*SP QUE GENERA EL ID DEL ACREDITADO FIRA*/
	Par_CreditoID				BIGINT(12),			# ID del Crédito.
	OUT Par_IdentificadorID		VARCHAR(18),		# Identificador generado para el acreditado.
	Par_Salida					CHAR(1),			# Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),			# Numero de Error.

	INOUT Par_ErrMen			VARCHAR(400),		# Mensaje de Error.
	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),

	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(30);
	DECLARE Var_ClaveInterFin	VARCHAR(3);
	DECLARE Var_NumIntegrantes	CHAR(2);
	DECLARE Var_Consecutivo		CHAR(6);
	DECLARE Var_Anio			INT(11);
	DECLARE Var_SubClasifID		INT(11);
	DECLARE Var_TipoCredito		INT(11);
	DECLARE Var_GrupoID			INT(11);
	DECLARE Var_TipoCreditoSAFI	VARCHAR(1);
	DECLARE Var_SucBancaria		VARCHAR(6);
	DECLARE Var_Posicion5a10	VARCHAR(6);
	DECLARE Var_CicloActual		INT(11);		-- Varable para almacenar el ciclo actual de grupo

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		VARCHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	SalidaSI			CHAR(1);
	DECLARE	SalidaNO			CHAR(1);
	DECLARE	CuatroCeros			CHAR(4);
	DECLARE	CreditoActivo		CHAR(1);
	DECLARE	CreditoPasivo		CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena vacia.
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
	SET Entero_Cero			:= 0;				-- Entero Cero.
	SET	SalidaSI        	:= 'S';				-- Salida Si.
	SET	SalidaNO        	:= 'N'; 			-- Salida No.
	SET CuatroCeros			:= '0000';			-- Cadena con 4 ceros.
	SET	CreditoActivo      	:= 'A'; 			-- Tipo de Credito Activo.
	SET	CreditoPasivo      	:= 'P'; 			-- Tipo de Credito Pasivo.
	SET	Var_SucBancaria    	:= '520100';		-- Número de la Sucursal Bancaria para Créditos Pasivos.

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-GENERAIDCREDAGROPRO.');
			SET Var_Control:= 'sqlException';
		END;

	IF EXISTS(SELECT CreditoID FROM IDENTIFICADORESAGRO WHERE CreditoID = Par_CreditoID) THEN
		SET	Par_NumErr := 1;
		SET	Par_ErrMen := 'El Credito ya tiene un Identificador Generado.';
		SET Var_Control:= 'creditoID' ;
		LEAVE ManejoErrores;
	END IF;

	-- SE OBTIENE EL VALOR DE LA CLAVE DEL INTERMEDIARIO FINANCIERO.
	SELECT
		LEFT(IFNULL(ValorParametro, Entero_Cero),3)
	INTO
		Var_ClaveInterFin
		FROM PARAMGENERALES
		WHERE LlaveParametro = 'ClaveInterFIRA';

	-- SE OBTIENE EL AÑO DE REGISTRO.
	SELECT YEAR(FechaSistema) INTO Var_Anio
		FROM PARAMETROSSIS;

	-- SE OBTIENE EL TIPO DE CREDITO, SI ES ACTIVO O PASIVO.
	IF EXISTS(SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID) THEN
		SET Var_TipoCreditoSAFI := CreditoActivo;
	ELSEIF EXISTS(SELECT CreditoFondeoID FROM CREDITOFONDEO WHERE CreditoFondeoID = Par_CreditoID) THEN
		SET Var_TipoCreditoSAFI := CreditoPasivo;
	END IF;
	SET Var_TipoCreditoSAFI := IFNULL(Var_TipoCreditoSAFI, Cadena_Vacia);

	IF(Var_TipoCreditoSAFI = CreditoActivo)THEN
		-- SE OBTIENE EL GRUPO DEL CRÉDITO.
		SET Var_GrupoID := (SELECT S.GrupoID
								FROM SOLICITUDCREDITO S
									INNER JOIN CREDITOS C ON(S.SolicitudCreditoID = C.SolicitudCreditoID)
								WHERE C.CreditoID = Par_CreditoID);
		IF(IFNULL(Var_GrupoID, Entero_Cero) != Entero_Cero)THEN

			-- Ciclo actual del grupo
			SELECT	CicloActual
			INTO 	Var_CicloActual
			FROM GRUPOSCREDITO
			WHERE GrupoID = Var_GrupoID;

			SET Var_CicloActual := IFNULL(Var_GrupoID, Entero_Cero);

			-- SE OBTIENE EL NÚMERO DE INTEGRANTES SI ES UN CRÉDITO GRUPAL.
			SET Var_NumIntegrantes := (SELECT count(G.GrupoID)
											FROM SOLICITUDCREDITO S
												INNER JOIN INTEGRAGRUPOSCRE G ON(S.SolicitudCreditoID = G.SolicitudCreditoID)
												INNER JOIN CREDITOS C ON(S.SolicitudCreditoID = C.SolicitudCreditoID)
											WHERE S.GrupoID = Var_GrupoID
											AND G.Ciclo = Var_CicloActual
									        GROUP BY G.GrupoID);
		END IF;
		-- SI ES NULL (INDIVIDUAL) SE ASIGNA EL NÚMERO UNO
		SET Var_NumIntegrantes	:= LPAD(IFNULL(Var_NumIntegrantes,1), 2, '0');

		-- SE OBTIENE UN CONSECUTIVO POR AÑO.
		SELECT
			LPAD((IFNULL(COUNT(Consecutivo),Entero_Cero)+1), 6, '0')
		INTO
			Var_Consecutivo
			FROM IDENTIFICADORESAGRO
				WHERE Anio = Var_Anio
					AND TipoCredito = CreditoActivo;

		SET Var_Posicion5a10	:= CONCAT(CuatroCeros, Var_NumIntegrantes);
	END IF;

	IF(Var_TipoCreditoSAFI = CreditoPasivo)THEN
		SET Var_Posicion5a10	:= CONCAT(Var_SucBancaria);

		-- SE OBTIENE UN CONSECUTIVO POR AÑO.
		SELECT
			LPAD((IFNULL(COUNT(Consecutivo),Entero_Cero)+1), 6, '0')
		INTO
			Var_Consecutivo
			FROM IDENTIFICADORESAGRO
				WHERE Anio = Var_Anio
					AND TipoCredito = CreditoPasivo;
	END IF;

	SET Var_Consecutivo := IFNULL(Var_Consecutivo, Entero_Cero);

	-- SE OBTIENE LA SUBCLASIFICACIÓN.
	SELECT IFNULL(dest.SubClasifID, Entero_Cero) INTO Var_SubClasifID
		FROM CREDITOS cre INNER JOIN DESTINOSCREDITO dest ON(cre.DestinoCreID = dest.DestinoCreID)
			WHERE cre.CreditoID = Par_CreditoID;

	-- TIPO DE CRÉDITO DEPENDIENDO DE LA SUBCLASIFICACIÓN.
	SET Var_TipoCredito := (CASE
								WHEN Var_SubClasifID = 125 THEN 1
								WHEN Var_SubClasifID = 126 THEN 2
								WHEN Var_SubClasifID = 102 THEN 3
							ELSE Entero_Cero
							END);

	SET Par_IdentificadorID	:= CAST(Var_TipoCredito AS CHAR);

	SET Par_IdentificadorID	:= CONCAT(Par_IdentificadorID, Var_ClaveInterFin, Var_Posicion5a10,
										Var_Consecutivo, RIGHT(Var_Anio, 2));

	INSERT INTO IDENTIFICADORESAGRO(
		CreditoID,			IdentificadorID,		Consecutivo, 						Anio,				TipoCredito,
		EmpresaID,			Usuario,				FechaActual,						DireccionIP,		ProgramaID,
		Sucursal,			NumTransaccion)
	VALUES(
		Par_CreditoID,		Par_IdentificadorID,	CAST(Var_Consecutivo AS UNSIGNED),	Var_Anio,			Var_TipoCreditoSAFI,
		Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,					Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Identificador Generado Exitosamente.';
	SET Var_Control:= 'creditoID' ;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			IFNULL(Par_IdentificadorID, Cadena_Vacia) AS Consecutivo;
	END IF;

END TerminaStore$$
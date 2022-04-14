-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFOADICIONALCREDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INFOADICIONALCREDCON`;
DELIMITER $$

CREATE PROCEDURE `INFOADICIONALCREDCON`(
-- SP ENLISTAR LA INFORMACION ADICIONAL DE LOS CREDITOS
	Par_CreditoID		BIGINT(20),			-- Numero de Credito
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de Consulta

	-- AUDITORIA GENERAL
    Aud_EmpresaID		INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- DECLARACION DE CONSTANTES
    DECLARE	Cadena_Vacia	CHAR(1);		-- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;			-- Fecha vacia
	DECLARE	Entero_Cero		INT(11);		-- Entero en cero

	DECLARE Con_Principal	INT(2);			-- Consulta principal
    DECLARE Var_ClienteID	BIGINT(20);		-- ID del Cliente para Consulta
    DECLARE Var_CreditoID	BIGINT(20);		-- ID del Credito para Consulta
    DECLARE Var_Nombre		VARCHAR(250);	-- ID del Cliente para Consulta

    -- WS
	DECLARE Var_UrlServer	VARCHAR(100);	-- Valor del UrlServer
	DECLARE Var_UsuarioWS	VARCHAR(200);	-- Valor del UsuarioWS
	DECLARE Var_PasswordWS	VARCHAR(100);	-- Valor del Password
    DECLARE Var_Valor		VARCHAR(100);	-- Valor del seteo
    DECLARE Var_TimeOut		INT(11);		-- Valor del TimeOut

    DECLARE ConConexion		TINYINT;		-- Consulta la Conexión
    DECLARE ConSignin		TINYINT;		-- Consulta del Token
    DECLARE ConCreaCred		TINYINT;		-- Consulta de la Creación del Crédito

	-- ASIGNACION DE CONSTANTES
    SET	Cadena_Vacia	:= '';				-- Valor de auditoria
	SET	Fecha_Vacia		:= '1900-01-01';	-- Valor de auditoria
	SET	Entero_Cero		:= 0;				-- Valor de auditoria

    SET Con_Principal	:= '1';				-- Valor de la Consulta principal
    SET ConConexion		:= '2';				-- Valor de la Conexion al WS
	SET ConSignin		:= '3';				-- Valor de la Consulta del Endpoint Signin
    SET ConCreaCred		:= '4';				-- Valor de la Consulta del Endpoint Creación Crédito
    SET Var_TimeOut		:= 60000;			-- Valor del TimeOut

    IF(Par_NumCon = Con_Principal) THEN
		SET Var_ClienteID	:= (SELECT ClienteID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
        SET Var_Nombre		:= (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Var_ClienteID);
        SET Var_CreditoID	:= (SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);

		SELECT	Var_CreditoID	AS CreditoID,
				Var_Nombre		AS NombreCom;
	END IF;

    IF (Par_NumCon = ConConexion) THEN
		SET Var_UrlServer  := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'UrlWSNG');
		SET Var_PasswordWS := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'PasswordWSNG');
		SET Var_UsuarioWS  := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'UsuarioWSNG');

		SELECT
			Var_UrlServer	AS UrlServerWS,
			Var_UsuarioWS	AS UsuarioWS,
			Var_PasswordWS	AS PasswordWS,
            Var_TimeOut		AS TimeOutConWS;
    END IF;

    IF (Par_NumCon = ConSignin) THEN
		SET Var_Valor := 'SigninWSNG';
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro = Var_Valor;
    END IF;

    IF (Par_NumCon = ConCreaCred) THEN
		SET Var_Valor := 'CreaCredWSNG';
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro = Var_Valor;
    END IF;

END TerminaStore$$

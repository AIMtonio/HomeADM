-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFOADICIONALCREDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `INFOADICIONALCREDLIS`;
DELIMITER $$

CREATE PROCEDURE `INFOADICIONALCREDLIS`(
-- SP ENLISTAR LA INFORMACION ADICIONAL DE LOS CREDITOS
	Par_CreditoID		BIGINT(20),			-- Numero de Credito
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de Lista

	-- AUDITORIA GENERAL
    Aud_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- DECLARACION DE CONSTANTES
    DECLARE	Cadena_Vacia	CHAR(1);	-- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;		-- Fecha vacia
	DECLARE	Entero_Cero		INT(11);	-- Entero en cero
    DECLARE	Entero_Nueve	INT(11);	-- Entero en Nueve

	DECLARE Lis_Principal	INT(2);		-- Lista principal
    DECLARE ConDatos		TINYINT;		-- Consulta de datos para el WS
    DECLARE Var_Credito		BIGINT(20);
    DECLARE Var_Placa		VARCHAR(7);
	DECLARE Var_Recaudo		DECIMAL(14,4);
	DECLARE Var_Plazo		DECIMAL(14,2);
	DECLARE Var_Vin			VARCHAR(250);
    DECLARE Tam_Credito		INT(20);
    DECLARE EstP			CHAR(71);

	-- ASIGNACION DE CONSTANTES
    SET	Cadena_Vacia	:= '';				-- Valor de auditoria
	SET	Fecha_Vacia		:= '1900-01-01';	-- Valor de auditoria
	SET	Entero_Cero		:= 0;				-- Valor de auditoria
    SET	Entero_Nueve	:= 9;				-- Valor de auditoria
    SET Lis_Principal	:= '1';				-- Valor de la Lista principal
    SET ConDatos		:= '2';				-- Valor de la Consulta de los Datos
    SET EstP			:= 'P';

    IF(Par_NumLis = Lis_Principal) THEN
        SELECT
            Placa, GNV, Vin, EstatusWS
        FROM INFOADICIONALCRED
        WHERE CreditoID = Par_CreditoID;
	END IF;

    IF(Par_NumLis = ConDatos) THEN
		SET Tam_Credito := (SELECT LENGTH(CreditoID) FROM INFOADICIONALCRED WHERE CreditoID = Par_CreditoID LIMIT 1);

        IF (Tam_Credito = Entero_Nueve)THEN
			SELECT Placa, LPAD(CreditoID,10, Entero_Cero), Recaudo, Plazo, Vin
			FROM INFOADICIONALCRED WHERE CreditoID = Par_CreditoID AND EstatusWS = EstP;
		ELSE
			SELECT Placa, CreditoID, Recaudo, Plazo, Vin
			FROM INFOADICIONALCRED WHERE CreditoID = Par_CreditoID AND EstatusWS = EstP;
        END IF;
	END IF;

END TerminaStore$$

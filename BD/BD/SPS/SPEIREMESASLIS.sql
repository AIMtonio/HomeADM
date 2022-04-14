-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIREMESASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIREMESASLIS`;
DELIMITER $$


CREATE PROCEDURE `SPEIREMESASLIS`(
	Par_SpeiRemID   	BIGINT(20),
	Par_Estatus	        CHAR(1),
	Par_CuentaAhoID     BIGINT(12),
	Par_NumLis			TINYINT UNSIGNED,
	/* Parámetros de Auditoria */
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(20),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN
-- Declaracion de variables
DECLARE Var_FechaActual     DATE;					-- Fecha Actual del Sistema

-- Declaracion de constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE Estatus_Pen         CHAR(1);
DECLARE	Lis_Remesas 		INT;
DECLARE	Lis_Agentes 		INT;
DECLARE Lis_CuentasAge      INT;
DECLARE Estatus_Aut			CHAR(1);
DECLARE ConceptoAgentes     VARCHAR(40);
DECLARE ConceptoRemesasEnv  VARCHAR(40);

-- Asignacion de constantes
SET	Cadena_Vacia			:= '';					-- Constante Vacio
SET	Fecha_Vacia				:= '1900-01-01';		-- Constante Fecha Vacia
SET	Entero_Cero				:= 0;					-- Constante Cero
SET	Estatus_Pen				:= 'P'; 				-- Estatus de Pendiente de autorizar por monto
SET Estatus_Aut				:= 'A';					-- Estatus de Autorizado
SET	Lis_Remesas			    := 1;					-- Lista de Remesas
SET	Lis_Agentes				:= 2;					-- Lista de Agentes
SET Lis_CuentasAge          := 3;					-- Listas de Cuentas de Agentes
SET ConceptoAgentes         := 'REMESASWS';			-- Concepto de Agentes
SET ConceptoRemesasEnv      := 'ENVIO DE DINERO';	-- Concepto de Remesas Enviadas


IF(Par_NumLis = Lis_Remesas) THEN
	SELECT
		SpeiRemID,		FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,	FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario,	FNDECRYPTSAFI(NombreBeneficiario) AS NombreBeneficiario,
		ClaveRastreo,	FORMAT(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),2) AS Monto
	FROM SPEIREMESAS
		WHERE	Estatus	= Estatus_Pen
			AND     ConceptoPago = FNENCRYPTSAFI(ConceptoRemesasEnv)
	LIMIT 1000;
END IF;


IF(Par_NumLis = Lis_Agentes) THEN
	SELECT
		SpeiRemID,		FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,	FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario,	FNDECRYPTSAFI(NombreBeneficiario) AS NombreBeneficiario,
		ClaveRastreo,	FORMAT(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),2) AS Monto
	FROM SPEIREMESAS
		WHERE Estatus	= Estatus_Pen
			AND   ConceptoPago = LEFT(FNENCRYPTSAFI(ConceptoAgentes),40)
			AND   CuentaAho =  Par_CuentaAhoID
	LIMIT 1000;
END IF;

IF(Par_NumLis = Lis_CuentasAge) THEN
	SELECT sp.CuentaAho, MAX(cl.NombreCompleto) AS NombreCompleto
	FROM SPEIREMESAS sp
	INNER JOIN CUENTASAHO ca ON sp.CuentaAho = ca.CuentaAhoID
	INNER JOIN CLIENTES cl  ON ca.ClienteID = cl.ClienteID
	WHERE sp.Estatus	= Estatus_Pen
	GROUP BY sp.CuentaAho LIMIT 15;
END IF;

END TerminaStore$$